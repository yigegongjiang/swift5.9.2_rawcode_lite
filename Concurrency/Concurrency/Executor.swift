import Swift
@available(SwiftStdlib 5.1, *)
public protocol Executor: AnyObject, Sendable {
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.1, *)
  @available(*, deprecated, message: "Implement 'enqueue(_: __owned ExecutorJob)' instead")
  #endif 
  func enqueue(_ job: UnownedJob)
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  @available(*, deprecated, message: "Implement 'enqueue(_: __owned ExecutorJob)' instead")
  func enqueue(_ job: consuming Job)
  #endif 
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  func enqueue(_ job: consuming ExecutorJob)
  #endif 
}
@available(SwiftStdlib 5.1, *)
public protocol SerialExecutor: Executor {
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.1, *)
  @available(*, deprecated, message: "Implement 'enqueue(_: __owned ExecutorJob)' instead")
  #endif 
  func enqueue(_ job: UnownedJob)
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  @available(*, deprecated, message: "Implement 'enqueue(_: __owned ExecutorJob)' instead")
  func enqueue(_ job: consuming Job)
  #endif 
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.9, *)
  func enqueue(_ job: consuming ExecutorJob)
  #endif 
  func asUnownedSerialExecutor() -> UnownedSerialExecutor
  @available(SwiftStdlib 5.9, *)
  func isSameExclusiveExecutionContext(other: Self) -> Bool
}
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.9, *)
extension Executor {
  public func enqueue(_ job: UnownedJob) {
    self.enqueue(ExecutorJob(job))
  }
  public func enqueue(_ job: consuming ExecutorJob) {
    self.enqueue(Job(job))
  }
  public func enqueue(_ job: consuming Job) {
    self.enqueue(UnownedJob(job))
  }
}
#endif 
@available(SwiftStdlib 5.9, *)
extension SerialExecutor {
  @available(SwiftStdlib 5.9, *)
  public func asUnownedSerialExecutor() -> UnownedSerialExecutor {
    UnownedSerialExecutor(ordinary: self)
  }
}
@available(SwiftStdlib 5.9, *)
extension SerialExecutor {
  @available(SwiftStdlib 5.9, *)
  public func isSameExclusiveExecutionContext(other: Self) -> Bool {
    return self === other
  }
}
@available(SwiftStdlib 5.1, *)
@frozen
public struct UnownedSerialExecutor: Sendable {
  #if compiler(>=5.5) && $BuiltinExecutor
  @usableFromInline
  internal var executor: Builtin.Executor
  @available(SwiftStdlib 5.9, *)
  public var _executor: Builtin.Executor {
    self.executor
  }
  #endif
  @inlinable
  public init(_ executor: Builtin.Executor) {
    #if compiler(>=5.5) && $BuiltinExecutor
    self.executor = executor
    #endif
  }
  @inlinable
  public init<E: SerialExecutor>(ordinary executor: __shared E) {
    #if compiler(>=5.5) && $BuiltinBuildExecutor
    self.executor = Builtin.buildOrdinarySerialExecutorRef(executor)
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @available(SwiftStdlib 5.9, *)
  @inlinable
  public init<E: SerialExecutor>(complexEquality executor: __shared E) {
    #if compiler(>=5.9) && $BuiltinBuildComplexEqualityExecutor
    self.executor = Builtin.buildComplexEqualitySerialExecutorRef(executor)
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @available(SwiftStdlib 5.9, *)
  public var _isComplexEquality: Bool {
    _executor_isComplexEquality(self)
  }
}
@available(SwiftStdlib 5.9, *)
public func _taskIsOnExecutor<Executor: SerialExecutor>(_ executor: Executor) -> Bool
@available(SwiftStdlib 5.9, *)
public func _executor_isComplexEquality(_ executor: UnownedSerialExecutor) -> Bool
@available(SwiftStdlib 5.1, *)
public 
func _checkExpectedExecutor(_filenameStart: Builtin.RawPointer,
                            _filenameLength: Builtin.Word,
                            _filenameIsASCII: Builtin.Int1,
                            _line: Builtin.Word,
                            _executor: Builtin.Executor) {
  if _taskIsCurrentExecutor(_executor) {
    return
  }
  _reportUnexpectedExecutor(
      _filenameStart, _filenameLength, _filenameIsASCII, _line, _executor)
}
@available(SwiftStdlib 5.9, *)
internal func _getJobTaskId(_ job: UnownedJob) -> UInt64
@available(SwiftStdlib 5.9, *)
internal func _task_serialExecutor_isSameExclusiveExecutionContext<E>(current currentExecutor: E, executor: E) -> Bool
    where E: SerialExecutor {
  currentExecutor.isSameExclusiveExecutionContext(other: executor)
}
@available(SwiftStdlib 5.9, *)
internal func _task_serialExecutor_getExecutorRef<E>(_ executor: E) -> Builtin.Executor
    where E: SerialExecutor {
  return executor.asUnownedSerialExecutor().executor
}
@available(SwiftStdlib 5.1, *)
internal func _enqueueOnExecutor<E>(job unownedJob: UnownedJob, executor: E)
where E: SerialExecutor {
  #if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  if #available(SwiftStdlib 5.9, *) {
    executor.enqueue(ExecutorJob(context: unownedJob._context))
  } else {
    executor.enqueue(unownedJob)
  }
  #else 
  executor.enqueue(unownedJob)
  #endif 
}
#if !SWIFT_STDLIB_SINGLE_THREADED_CONCURRENCY && !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
internal func _enqueueOnDispatchQueue(_ job: UnownedJob,
                                      queue: DispatchQueueShim)
@available(SwiftStdlib 5.1, *)
internal final class DispatchQueueShim: @unchecked Sendable, SerialExecutor {
  func enqueue(_ job: UnownedJob) {
    _enqueueOnDispatchQueue(job, queue: self)
  }
  func asUnownedSerialExecutor() -> UnownedSerialExecutor {
    return UnownedSerialExecutor(ordinary: self)
  }
}
#endif 
