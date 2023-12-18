import Swift
@available(SwiftStdlib 5.1, *)
@inlinable
public func withTaskGroup<ChildTaskResult, GroupResult>(
  of childTaskResultType: ChildTaskResult.Type,
  returning returnType: GroupResult.Type = GroupResult.self,
  body: (inout TaskGroup<ChildTaskResult>) async -> GroupResult
) async -> GroupResult {
  #if compiler(>=5.5) && $BuiltinTaskGroupWithArgument
  let _group = Builtin.createTaskGroup(ChildTaskResult.self)
  var group = TaskGroup<ChildTaskResult>(group: _group)
  let result = await body(&group)
  await group.awaitAllRemainingTasks()
  Builtin.destroyTaskGroup(_group)
  return result
  #else
  fatalError("Swift compiler is incompatible with this SDK version")
  #endif
}
@available(SwiftStdlib 5.1, *)
@inlinable
public func withThrowingTaskGroup<ChildTaskResult, GroupResult>(
  of childTaskResultType: ChildTaskResult.Type,
  returning returnType: GroupResult.Type = GroupResult.self,
  body: (inout ThrowingTaskGroup<ChildTaskResult, Error>) async throws -> GroupResult
) async rethrows -> GroupResult {
  #if compiler(>=5.5) && $BuiltinTaskGroupWithArgument
  let _group = Builtin.createTaskGroup(ChildTaskResult.self)
  var group = ThrowingTaskGroup<ChildTaskResult, Error>(group: _group)
  do {
    let result = try await body(&group)
    await group.awaitAllRemainingTasks()
    Builtin.destroyTaskGroup(_group)
    return result
  } catch {
    group.cancelAll()
    await group.awaitAllRemainingTasks()
    Builtin.destroyTaskGroup(_group)
    throw error
  }
  #else
  fatalError("Swift compiler is incompatible with this SDK version")
  #endif
}
@available(SwiftStdlib 5.1, *)
@frozen
public struct TaskGroup<ChildTaskResult: Sendable> {
  @usableFromInline
  internal let _group: Builtin.RawPointer
  @inlinable
  init(group: Builtin.RawPointer) {
    self._group = group
  }
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: false,
      addPendingGroupTaskUnconditionally: true,
      isDiscardingTask: false
    )
#else
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true,
      isDiscardingTask: false)
#endif
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: false,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
#else
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
#endif
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#else 
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  public mutating func addTask(
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true,
      isDiscardingTask: false)
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTaskUnlessCancelled(operation:)")
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) -> Bool {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  public mutating func addTaskUnlessCancelled(
    operation: __owned @Sendable @escaping () async -> ChildTaskResult
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
  public mutating func next() async -> ChildTaskResult? {
    return try! await _taskGroupWaitNext(group: _group) 
  }
  @usableFromInline
  internal mutating func awaitAllRemainingTasks() async {
    while let _ = await next() {}
  }
  public mutating func waitForAll() async {
    await awaitAllRemainingTasks()
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
@available(SwiftStdlib 5.1, *)
@available(*, unavailable)
extension TaskGroup: Sendable { }
@available(SwiftStdlib 5.1, *)
@frozen
public struct ThrowingTaskGroup<ChildTaskResult: Sendable, Failure: Error> {
  @usableFromInline
  internal let _group: Builtin.RawPointer
  @inlinable
  init(group: Builtin.RawPointer) {
    self._group = group
  }
  @usableFromInline
  internal mutating func awaitAllRemainingTasks() async {
    while true {
      do {
        guard let _ = try await next() else {
          return
        }
      } catch {}
    }
  }
  @usableFromInline
  internal mutating func _waitForAll() async throws {
    await self.awaitAllRemainingTasks()
  }
  public mutating func waitForAll() async throws {
    var firstError: Error? = nil
    while !isEmpty {
      do {
        while let _ = try await next() {}
      } catch {
        if firstError == nil {
          firstError = error
        }
      }
    }
    if let firstError {
      throw firstError
    }
  }
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true,
      isDiscardingTask: false
    )
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
    let flags = taskCreateFlags(
      priority: priority, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#else
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTask(operation:)")
  public mutating func addTask(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  public mutating func addTask(
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: true,
      isDiscardingTask: false)
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model", renamed: "addTaskUnlessCancelled(operation:)")
  public mutating func addTaskUnlessCancelled(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) -> Bool {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  public mutating func addTaskUnlessCancelled(
    operation: __owned @Sendable @escaping () async throws -> ChildTaskResult
  ) -> Bool {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let canAdd = _taskGroupAddPendingTask(group: _group, unconditionally: false)
    guard canAdd else {
      return false
    }
    let flags = taskCreateFlags(
      priority: nil, isChildTask: true, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    _ = Builtin.createAsyncTaskInGroup(flags, _group, operation)
    return true
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
  public mutating func next() async throws -> ChildTaskResult? {
    return try await _taskGroupWaitNext(group: _group)
  }
  @usableFromInline
  mutating func nextResultForABI() async throws -> Result<ChildTaskResult, Failure>? {
    do {
      guard let success: ChildTaskResult = try await _taskGroupWaitNext(group: _group) else {
        return nil
      }
      return .success(success)
    } catch {
      return .failure(error as! Failure) 
    }
  }
  public mutating func nextResult() async -> Result<ChildTaskResult, Failure>? {
    return try! await nextResultForABI()
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
@available(SwiftStdlib 5.1, *)
@available(*, unavailable)
extension ThrowingTaskGroup: Sendable { }
@available(SwiftStdlib 5.1, *)
extension TaskGroup: AsyncSequence {
  public typealias AsyncIterator = Iterator
  public typealias Element = ChildTaskResult
  public func makeAsyncIterator() -> Iterator {
    return Iterator(group: self)
  }
  @available(SwiftStdlib 5.1, *)
  public struct Iterator: AsyncIteratorProtocol {
    public typealias Element = ChildTaskResult
    @usableFromInline
    var group: TaskGroup<ChildTaskResult>
    @usableFromInline
    var finished: Bool = false
    init(group: TaskGroup<ChildTaskResult>) {
      self.group = group
    }
    public mutating func next() async -> Element? {
      guard !finished else { return nil }
      guard let element = await group.next() else {
        finished = true
        return nil
      }
      return element
    }
    public mutating func cancel() {
      finished = true
      group.cancelAll()
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension ThrowingTaskGroup: AsyncSequence {
  public typealias AsyncIterator = Iterator
  public typealias Element = ChildTaskResult
  public func makeAsyncIterator() -> Iterator {
    return Iterator(group: self)
  }
  @available(SwiftStdlib 5.1, *)
  public struct Iterator: AsyncIteratorProtocol {
    public typealias Element = ChildTaskResult
    @usableFromInline
    var group: ThrowingTaskGroup<ChildTaskResult, Failure>
    @usableFromInline
    var finished: Bool = false
    init(group: ThrowingTaskGroup<ChildTaskResult, Failure>) {
      self.group = group
    }
    public mutating func next() async throws -> Element? {
      guard !finished else { return nil }
      do {
        guard let element = try await group.next() else {
          finished = true
          return nil
        }
        return element
      } catch {
        finished = true
        throw error
      }
    }
    public mutating func cancel() {
      finished = true
      group.cancelAll()
    }
  }
}
@available(SwiftStdlib 5.1, *)
func _taskGroupDestroy(group: __owned Builtin.RawPointer)
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _taskGroupAddPendingTask(
  group: Builtin.RawPointer,
  unconditionally: Bool
) -> Bool
@available(SwiftStdlib 5.1, *)
func _taskGroupCancelAll(group: Builtin.RawPointer)
@available(SwiftStdlib 5.1, *)
func _taskGroupIsCancelled(group: Builtin.RawPointer) -> Bool
@available(SwiftStdlib 5.1, *)
func _taskGroupWaitNext<T>(group: Builtin.RawPointer) async throws -> T?
@available(SwiftStdlib 5.1, *)
func _taskHasTaskGroupStatusRecord() -> Bool
@available(SwiftStdlib 5.1, *)
enum PollStatus: Int {
  case empty   = 0
  case waiting = 1
  case success = 2
  case error   = 3
}
@available(SwiftStdlib 5.1, *)
func _taskGroupIsEmpty(
  _ group: Builtin.RawPointer
) -> Bool
@available(SwiftStdlib 5.8, *)
struct TaskGroupFlags {
  var bits: Int32 = 0
  var discardResults: Bool? {
    get {
      let value = (Int(bits) & 1 << 24)
      return value > 0
    }
    set {
      if newValue == true {
        bits = bits | 1 << 24
      } else {
        bits = (bits & ~(1 << 23))
      }
    }
  }
}
@available(SwiftStdlib 5.8, *)
func taskGroupCreateFlags(
        discardResults: Bool) -> Int {
  var bits = 0
  if discardResults {
    bits |= 1 << 8
  }
  return bits
}
