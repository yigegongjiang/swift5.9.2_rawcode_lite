import Swift
@available(SwiftStdlib 5.1, *)
@usableFromInline
internal func _swiftJobRun(_ job: UnownedJob,
                           _ executor: UnownedSerialExecutor) -> ()
@available(SwiftStdlib 5.1, *)
@frozen
public struct UnownedJob: Sendable {
  private var context: Builtin.Job
  @usableFromInline
  @available(SwiftStdlib 5.9, *)
  internal init(context: Builtin.Job) {
    self.context = context
  }
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  public init(_ job: __owned Job) { 
    self.context = job.context
  }
  #endif 
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  public init(_ job: __owned ExecutorJob) { 
    self.context = job.context
  }
  #endif 
  @available(SwiftStdlib 5.9, *)
  public var priority: JobPriority {
    let raw = _swift_concurrency_jobPriority(self)
    return JobPriority(rawValue: raw)
  }
  @available(SwiftStdlib 5.9, *)
  internal var _context: Builtin.Job {
    context
  }
  @inlinable
  @available(*, deprecated, renamed: "ExecutorJob.runSynchronously(on:)")
  public func _runSynchronously(on executor: UnownedSerialExecutor) {
    _swiftJobRun(self, executor)
  }
  @inlinable
  public func runSynchronously(on executor: UnownedSerialExecutor) {
    _swiftJobRun(self, executor)
  }
}
@available(SwiftStdlib 5.9, *)
extension UnownedJob: CustomStringConvertible {
  @available(SwiftStdlib 5.9, *)
  public var description: String {
    let id = _getJobTaskId(self)
    if (id > 0) {
      return "\(Self.self)(id: \(id))"
    } else {
      return "\(Self.self)(id: nil)"
    }
  }
}
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.9, *)
@available(*, deprecated, renamed: "ExecutorJob")
@frozen
public struct Job: Sendable {
  internal var context: Builtin.Job
  @usableFromInline
  internal init(context: __owned Builtin.Job) {
    self.context = context
  }
  public init(_ job: UnownedJob) {
    self.context = job._context
  }
  public init(_ job: __owned ExecutorJob) {
    self.context = job.context
  }
  public var priority: JobPriority {
    let raw = _swift_concurrency_jobPriority(UnownedJob(context: self.context))
    return JobPriority(rawValue: raw)
  }
  public var description: String {
    let id = _getJobTaskId(UnownedJob(context: self.context))
    if (id > 0) {
      return "Job(id: \(id))"
    } else {
      return "Job(id: nil)"
    }
  }
}
@available(SwiftStdlib 5.9, *)
extension Job {
  @inlinable
  __consuming public func runSynchronously(on executor: UnownedSerialExecutor) {
    _swiftJobRun(UnownedJob(self), executor)
  }
}
@available(SwiftStdlib 5.9, *)
@frozen
public struct ExecutorJob: Sendable {
  internal var context: Builtin.Job
  @usableFromInline
  internal init(context: __owned Builtin.Job) {
    self.context = context
  }
  public init(_ job: UnownedJob) {
    self.context = job._context
  }
  public init(_ job: __owned Job) {
    self.context = job.context
  }
  public var priority: JobPriority {
    let raw = _swift_concurrency_jobPriority(UnownedJob(context: self.context))
    return JobPriority(rawValue: raw)
  }
  public var description: String {
    let id = _getJobTaskId(UnownedJob(context: self.context))
    if (id > 0) {
      return "ExecutorJob(id: \(id))"
    } else {
      return "ExecutorJob(id: nil)"
    }
  }
}
@available(SwiftStdlib 5.9, *)
extension ExecutorJob {
  @inlinable
  __consuming public func runSynchronously(on executor: UnownedSerialExecutor) {
    _swiftJobRun(UnownedJob(self), executor)
  }
}
#endif 
@available(SwiftStdlib 5.9, *)
@frozen
public struct JobPriority: Sendable {
  public typealias RawValue = UInt8
  public var rawValue: RawValue
}
@available(SwiftStdlib 5.9, *)
extension TaskPriority {
  @available(SwiftStdlib 5.9, *)
  public init?(_ p: JobPriority) {
    guard p.rawValue != 0 else {
      return nil
    }
    self = TaskPriority(rawValue: p.rawValue)
  }
}
@available(SwiftStdlib 5.9, *)
extension JobPriority: Equatable {
  public static func == (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
  public static func != (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue != rhs.rawValue
  }
}
@available(SwiftStdlib 5.9, *)
extension JobPriority: Comparable {
  public static func < (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  public static func <= (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue <= rhs.rawValue
  }
  public static func > (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue > rhs.rawValue
  }
  public static func >= (lhs: JobPriority, rhs: JobPriority) -> Bool {
    lhs.rawValue >= rhs.rawValue
  }
}
@available(SwiftStdlib 5.1, *)
@frozen
public struct UnsafeContinuation<T, E: Error>: Sendable {
  @usableFromInline internal var context: Builtin.RawUnsafeContinuation
  internal init(_ context: Builtin.RawUnsafeContinuation) {
    self.context = context
  }
  public func resume(returning value: __owned T) where E == Never {
    #if compiler(>=5.5) && $BuiltinContinuation
    Builtin.resumeNonThrowingContinuationReturning(context, value)
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  public func resume(returning value: __owned T) {
    #if compiler(>=5.5) && $BuiltinContinuation
    Builtin.resumeThrowingContinuationReturning(context, value)
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  public func resume(throwing error: __owned E) {
    #if compiler(>=5.5) && $BuiltinContinuation
    Builtin.resumeThrowingContinuationThrowing(context, error)
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
}
@available(SwiftStdlib 5.1, *)
extension UnsafeContinuation {
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
#if _runtime(_ObjC)
@available(SwiftStdlib 5.1, *)
internal func _resumeUnsafeContinuation<T>(
  _ continuation: UnsafeContinuation<T, Never>,
  _ value: __owned T
) {
  continuation.resume(returning: value)
}
@available(SwiftStdlib 5.1, *)
internal func _resumeUnsafeThrowingContinuation<T>(
  _ continuation: UnsafeContinuation<T, Error>,
  _ value: __owned T
) {
  continuation.resume(returning: value)
}
@available(SwiftStdlib 5.1, *)
internal func _resumeUnsafeThrowingContinuationWithError<T>(
  _ continuation: UnsafeContinuation<T, Error>,
  _ error: __owned Error
) {
  continuation.resume(throwing: error)
}
#endif
@available(SwiftStdlib 5.1, *)
public func withUnsafeContinuation<T>(
  _ fn: (UnsafeContinuation<T, Never>) -> Void
) async -> T {
  return await Builtin.withUnsafeContinuation {
    fn(UnsafeContinuation<T, Never>($0))
  }
}
@available(SwiftStdlib 5.1, *)
public func withUnsafeThrowingContinuation<T>(
  _ fn: (UnsafeContinuation<T, Error>) -> Void
) async throws -> T {
  return try await Builtin.withUnsafeThrowingContinuation {
    fn(UnsafeContinuation<T, Error>($0))
  }
}
@available(SwiftStdlib 5.1, *)
public func _abiEnableAwaitContinuation() {
  fatalError("never use this function")
}
@available(SwiftStdlib 5.9, *)
internal func _swift_concurrency_jobPriority(_ job: UnownedJob) -> UInt8
