import Swift
@available(SwiftStdlib 5.1, *)
internal func logFailedCheck(_ message: UnsafeRawPointer)
@available(SwiftStdlib 5.1, *)
internal final class CheckedContinuationCanary: @unchecked Sendable {
  private init() { fatalError("must use create") }
  private static func _create(continuation: UnsafeRawPointer, function: String)
      -> Self {
    let instance = Builtin.allocWithTailElems_1(self,
      1._builtinWordValue,
      (UnsafeRawPointer?, String).self)
    instance._continuationPtr.initialize(to: continuation)
    instance._functionPtr.initialize(to: function)
    return instance
  }
  private var _continuationPtr: UnsafeMutablePointer<UnsafeRawPointer?> {
    return UnsafeMutablePointer<UnsafeRawPointer?>(
      Builtin.projectTailElems(self, (UnsafeRawPointer?, String).self))
  }
  private var _functionPtr: UnsafeMutablePointer<String> {
    let tailPtr = UnsafeMutableRawPointer(
      Builtin.projectTailElems(self, (UnsafeRawPointer?, String).self))
    let functionPtr = tailPtr 
        + MemoryLayout<(UnsafeRawPointer?, String)>.offset(of: \(UnsafeRawPointer?, String).1)!
    return functionPtr.assumingMemoryBound(to: String.self)
  }
  internal static func create<T, E>(continuation: UnsafeContinuation<T, E>,
                                 function: String) -> Self {
    return _create(
        continuation: unsafeBitCast(continuation, to: UnsafeRawPointer.self),
        function: function)
  }
  internal var function: String {
    return _functionPtr.pointee
  }
  internal func takeContinuation<T, E>() -> UnsafeContinuation<T, E>? {
    let rawContinuationPtr = unsafeBitCast(_continuationPtr,
      to: Builtin.RawPointer.self)
    let rawOld = Builtin.atomicrmw_xchg_seqcst_Word(rawContinuationPtr,
      0._builtinWordValue)
    return unsafeBitCast(rawOld, to: UnsafeContinuation<T, E>?.self)
  }
  deinit {
    _functionPtr.deinitialize(count: 1)
    if _continuationPtr.pointee != nil {
      logFailedCheck("SWIFT TASK CONTINUATION MISUSE: \(function) leaked its continuation!\n")
    }
  }
}
@available(SwiftStdlib 5.1, *)
public struct CheckedContinuation<T, E: Error>: Sendable {
  private let canary: CheckedContinuationCanary
  public init(continuation: UnsafeContinuation<T, E>, function: String = #function) {
    canary = CheckedContinuationCanary.create(
      continuation: continuation,
      function: function)
  }
  public func resume(returning value: __owned T) {
    if let c: UnsafeContinuation<T, E> = canary.takeContinuation() {
      c.resume(returning: value)
    } else {
      fatalError("SWIFT TASK CONTINUATION MISUSE: \(canary.function) tried to resume its continuation more than once, returning \(value)!\n")
    }
  }
  public func resume(throwing error: __owned E) {
    if let c: UnsafeContinuation<T, E> = canary.takeContinuation() {
      c.resume(throwing: error)
    } else {
      fatalError("SWIFT TASK CONTINUATION MISUSE: \(canary.function) tried to resume its continuation more than once, throwing \(error)!\n")
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension CheckedContinuation {
  public func resume<Er: Error>(with result: Result<T, Er>) where E == Error {
    switch result {
      case .success(let val):
        self.resume(returning: val)
      case .failure(let err):
        self.resume(throwing: err)
    }
  }
  public func resume(with result: Result<T, E>) {
    switch result {
      case .success(let val):
        self.resume(returning: val)
      case .failure(let err):
        self.resume(throwing: err)
    }
  }
  public func resume() where T == Void {
    self.resume(returning: ())
  }
}
@available(SwiftStdlib 5.1, *)
@inlinable
public func withCheckedContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Never>) -> Void
) async -> T {
  return await withUnsafeContinuation {
    body(CheckedContinuation(continuation: $0, function: function))
  }
}
@available(SwiftStdlib 5.1, *)
@inlinable
public func withCheckedThrowingContinuation<T>(
    function: String = #function,
    _ body: (CheckedContinuation<T, Error>) -> Void
) async throws -> T {
  return try await withUnsafeThrowingContinuation {
    body(CheckedContinuation(continuation: $0, function: function))
  }
}
