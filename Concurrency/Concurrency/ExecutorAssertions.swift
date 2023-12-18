import Swift
import SwiftShims
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.9, *)
extension SerialExecutor {
  @available(SwiftStdlib 5.9, *)
  public func preconditionIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    guard _isDebugAssertConfiguration() || _isReleaseAssertConfiguration() else {
      return
    }
    let expectationCheck = _taskIsCurrentExecutor(self.asUnownedSerialExecutor().executor)
    precondition(expectationCheck,
        "Incorrect actor executor assumption; Expected '\(self)' executor. \(message())",
        file: file, line: line) 
  }
}
@available(SwiftStdlib 5.9, *)
extension Actor {
  @available(SwiftStdlib 5.9, *)
  public nonisolated func preconditionIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    guard _isDebugAssertConfiguration() || _isReleaseAssertConfiguration() else {
      return
    }
    let expectationCheck = _taskIsCurrentExecutor(self.unownedExecutor.executor)
    precondition(expectationCheck,
        "Incorrect actor executor assumption; Expected '\(self.unownedExecutor)' executor. \(message())",
        file: file, line: line)
  }
}
@available(SwiftStdlib 5.9, *)
extension GlobalActor {
  @available(SwiftStdlib 5.9, *)
  public static func preconditionIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    try Self.shared.preconditionIsolated(message(), file: file, line: line)
  }
}
@available(SwiftStdlib 5.9, *)
extension SerialExecutor {
  @available(SwiftStdlib 5.9, *)
  public func assertIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    guard _isDebugAssertConfiguration() else {
      return
    }
    guard _taskIsCurrentExecutor(self.asUnownedSerialExecutor().executor) else {
      let msg = "Incorrect actor executor assumption; Expected '\(self)' executor. \(message())"
      assertionFailure(msg, file: file, line: line)
      return
    }
  }
}
@available(SwiftStdlib 5.9, *)
extension Actor {
  @available(SwiftStdlib 5.9, *)
  public nonisolated func assertIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    guard _isDebugAssertConfiguration() else {
      return
    }
    guard _taskIsCurrentExecutor(self.unownedExecutor.executor) else {
      let msg = "Incorrect actor executor assumption; Expected '\(self.unownedExecutor)' executor. \(message())"
      assertionFailure(msg, file: file, line: line) 
      return
    }
  }
}
@available(SwiftStdlib 5.9, *)
extension GlobalActor {
  @available(SwiftStdlib 5.9, *)
  public static func assertIsolated(
      _ message: @autoclosure () -> String = String(),
      file: StaticString = #fileID, line: UInt = #line
  ) {
    try Self.shared.assertIsolated(message(), file: file, line: line)
  }
}
@available(SwiftStdlib 5.9, *)
extension Actor {
  @available(SwiftStdlib 5.9, *)
  public nonisolated func assumeIsolated<T>(
      _ operation: (isolated Self) throws -> T,
      file: StaticString = #fileID, line: UInt = #line
  ) rethrows -> T {
    typealias YesActor = (isolated Self) throws -> T
    typealias NoActor = (Self) throws -> T
    let executor: Builtin.Executor = self.unownedExecutor.executor
    guard _taskIsCurrentExecutor(executor) else {
      fatalError("Incorrect actor executor assumption; Expected same executor as \(self).", file: file, line: line)
    }
    return try withoutActuallyEscaping(operation) {
      (_ fn: @escaping YesActor) throws -> T in
      let rawFn = unsafeBitCast(fn, to: NoActor.self)
      return try rawFn(self)
    }
  }
}
#endif 