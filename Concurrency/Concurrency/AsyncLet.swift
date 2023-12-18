import Swift
@available(SwiftStdlib 5.1, *)
public func _asyncLetStart<T>(
  asyncLet: Builtin.RawPointer,
  options: Builtin.RawPointer?,
  operation: @Sendable () async throws -> T
)
@available(SwiftStdlib 5.1, *)
public func _asyncLetGet<T>(asyncLet: Builtin.RawPointer) async -> T
@available(SwiftStdlib 5.1, *)
public func _asyncLetGetThrowing<T>(asyncLet: Builtin.RawPointer) async throws -> T
@available(SwiftStdlib 5.1, *)
public func _asyncLetEnd(
  asyncLet: Builtin.RawPointer 
)
@available(SwiftStdlib 5.1, *)
public func _asyncLet_get(_ asyncLet: Builtin.RawPointer, _ resultBuffer: Builtin.RawPointer) async
@available(SwiftStdlib 5.1, *)
public func _asyncLet_get_throwing(_ asyncLet: Builtin.RawPointer, _ resultBuffer: Builtin.RawPointer) async throws
@available(SwiftStdlib 5.1, *)
public func _asyncLet_finish(_ asyncLet: Builtin.RawPointer, _ resultBuffer: Builtin.RawPointer) async
func _asyncLetExtractTask(
  of asyncLet: Builtin.RawPointer
) -> Builtin.NativeObject
