import Swift
@available(SwiftStdlib 5.1, *)
public func withTaskCancellationHandler<T>(
  operation: () async throws -> T,
  onCancel handler: @Sendable () -> Void
) async rethrows -> T {
  let record = _taskAddCancellationHandler(handler: handler)
  do {
    let result = try await operation()
    _taskRemoveCancellationHandler(record: record)
    return result
  } catch {
    _taskRemoveCancellationHandler(record: record)
    throw error
  }
}
@available(SwiftStdlib 5.1, *)
extension Task {
    _taskIsCancelled(_task)
  }
}
@available(SwiftStdlib 5.1, *)
extension Task where Success == Never, Failure == Never {
  public static var isCancelled: Bool {
     withUnsafeCurrentTask { task in
       task?.isCancelled ?? false
     }
  }
}
@available(SwiftStdlib 5.1, *)
extension Task where Success == Never, Failure == Never {
  public static func checkCancellation() throws {
    if Task<Never, Never>.isCancelled {
      throw _Concurrency.CancellationError()
    }
  }
}
@available(SwiftStdlib 5.1, *)
public struct CancellationError: Error {
  public init() {}
}
@usableFromInline
@available(SwiftStdlib 5.1, *)
func _taskAddCancellationHandler(handler: () -> Void) -> UnsafeRawPointer 
@usableFromInline
@available(SwiftStdlib 5.1, *)
func _taskRemoveCancellationHandler(
  record: UnsafeRawPointer 
)
