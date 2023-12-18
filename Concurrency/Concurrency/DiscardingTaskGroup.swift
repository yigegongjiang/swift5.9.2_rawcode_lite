import Swift
@available(SwiftStdlib 5.9, *)
@inlinable
public func withDiscardingTaskGroup<GroupResult>(
  returning returnType: GroupResult.Type = GroupResult.self,
  body: (inout DiscardingTaskGroup) async -> GroupResult
) async -> GroupResult {
  #if compiler(>=5.5) && $BuiltinCreateTaskGroupWithFlags
  let flags = taskGroupCreateFlags(
    discardResults: true
  )
  let _group = Builtin.createTaskGroupWithFlags(flags, GroupResult.self)
  var group = DiscardingTaskGroup(group: _group)
  defer { Builtin.destroyTaskGroup(_group) }
  let result = await body(&group)
  try! await group.awaitAllRemainingTasks() 
  return result
  #else
  fatalError("Swift compiler is incompatible with this SDK version")
  #endif
}
@available(SwiftStdlib 5.9, *)
@frozen
public struct DiscardingTaskGroup {
  @usableFromInline
  internal let _group: Builtin.RawPointer
  @inlinable
  init(group: Builtin.RawPointer) {
    self._group = group
  }
  @usableFromInline
  internal mutating func awaitAllRemainingTasks() async throws {
    let _: Void? = try await _taskGroupWaitAll(group: _group, bodyError: nil)
  }
  #if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
  #endif
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> Void
  ) {
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: false,
      addPendingGroupTaskUnconditionally: true, isDiscardingTask: true
    )
#else
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true, isDiscardingTask: true
    )
#endif
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
  }
  #if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
  #endif
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> Void
  ) -> Bool {
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: false,
      addPendingGroupTaskUnconditionally: false, isDiscardingTask: true
    )
#else
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false, isDiscardingTask: true
    )
#endif
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
  }
  public mutating func addTask(
    operation: __owned @Sendable @escaping () async -> Void
  ) {
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true, isDiscardingTask: true
    )
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
  }
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTaskUnlessCancelled(operation:)")
#endif
  public mutating func addTaskUnlessCancelled(
    operation: __owned @Sendable @escaping () async -> Void
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false, isDiscardingTask: true
    )
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  public var isEmpty: Bool {
    _taskGroupIsEmpty(_group)
  }
  public func cancelAll() {
    _taskGroupCancelAll(group: _group)
  }
  public var isCancelled: Bool {
    return _taskGroupIsCancelled(group: _group)
  }
}
@available(SwiftStdlib 5.9, *)
@available(*, unavailable)
extension DiscardingTaskGroup: Sendable { }
@available(SwiftStdlib 5.9, *)
@inlinable
public func withThrowingDiscardingTaskGroup<GroupResult>(
    returning returnType: GroupResult.Type = GroupResult.self,
    body: (inout ThrowingDiscardingTaskGroup<Error>) async throws -> GroupResult
) async throws -> GroupResult {
  #if compiler(>=5.5) && $BuiltinCreateTaskGroupWithFlags
  let flags = taskGroupCreateFlags(
      discardResults: true
  )
  let _group = Builtin.createTaskGroupWithFlags(flags, GroupResult.self)
  var group = ThrowingDiscardingTaskGroup<Error>(group: _group)
  defer { Builtin.destroyTaskGroup(_group) }
  let result: GroupResult
  do {
    result = try await body(&group)
  } catch {
    group.cancelAll()
    try await group.awaitAllRemainingTasks(bodyError: error)
    throw error
  }
  try await group.awaitAllRemainingTasks(bodyError: nil)
  return result
  #else
  fatalError("Swift compiler is incompatible with this SDK version")
  #endif
}
@available(SwiftStdlib 5.9, *)
@frozen
public struct ThrowingDiscardingTaskGroup<Failure: Error> {
  @usableFromInline
  internal let _group: Builtin.RawPointer
  @inlinable
  init(group: Builtin.RawPointer) {
    self._group = group
  }
  @usableFromInline
  internal mutating func awaitAllRemainingTasks(bodyError: Error?) async throws {
    let _: Void? = try await _taskGroupWaitAll(group: _group, bodyError: bodyError)
  }
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
#endif
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> Void
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true, isDiscardingTask: true
    )
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
#endif
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> Void
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false, isDiscardingTask: true
    )
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  public var isEmpty: Bool {
    _taskGroupIsEmpty(_group)
  }
  public func cancelAll() {
    _taskGroupCancelAll(group: _group)
  }
  public var isCancelled: Bool {
    return _taskGroupIsCancelled(group: _group)
  }
}
@available(SwiftStdlib 5.9, *)
@available(*, unavailable)
extension ThrowingDiscardingTaskGroup: Sendable { }
@available(SwiftStdlib 5.9, *)
@usableFromInline
@discardableResult
func _taskGroupWaitAll<T>(
    group: Builtin.RawPointer,
    bodyError: Error?
) async throws -> T?
