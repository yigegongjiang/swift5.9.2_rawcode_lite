import Swift
@available(SwiftStdlib 5.1, *)
@frozen
public struct Task<Success: Sendable, Failure: Error>: Sendable {
  @usableFromInline
  internal let _task: Builtin.NativeObject
  internal init(_ task: Builtin.NativeObject) {
    self._task = task
  }
}
@available(SwiftStdlib 5.1, *)
extension Task {
  public var value: Success {
    get async throws {
      return try await _taskFutureGetThrowing(_task)
    }
  }
  public var result: Result<Success, Failure> {
    get async {
      do {
        return .success(try await value)
      } catch {
        return .failure(error as! Failure) 
      }
    }
  }
  public func cancel() {
    Builtin.cancelAsyncTask(_task)
  }
}
@available(SwiftStdlib 5.1, *)
extension Task where Failure == Never {
  public var value: Success {
    get async {
      return await _taskFutureGet(_task)
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension Task: Hashable {
  public func hash(into hasher: inout Hasher) {
    UnsafeRawPointer(Builtin.bridgeToRawPointer(_task)).hash(into: &hasher)
  }
}
@available(SwiftStdlib 5.1, *)
extension Task: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    UnsafeRawPointer(Builtin.bridgeToRawPointer(lhs._task)) ==
      UnsafeRawPointer(Builtin.bridgeToRawPointer(rhs._task))
  }
}
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.9, *)
extension Task where Failure == Error {
    @MainActor
    @available(SwiftStdlib 5.9, *)
    @discardableResult
    public static func startOnMainActor(
        priority: TaskPriority? = nil,
    ) -> Task<Success, Error> {
        let flags = taskCreateFlags(priority: priority, isChildTask: false,
                                    copyTaskLocals: true, inheritContext: true,
                                    enqueueJob: false,
                                    addPendingGroupTaskUnconditionally: false,
                                    isDiscardingTask: false)
        let (task, _) = Builtin.createAsyncTask(flags, work)
        _startTaskOnMainActor(task)
        return Task<Success, Error>(task)
    }
}
#endif
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.9, *)
extension Task where Failure == Never {
    @MainActor
    @available(SwiftStdlib 5.9, *)
    @discardableResult
    public static func startOnMainActor(
        priority: TaskPriority? = nil,
    ) -> Task<Success, Never> {
        let flags = taskCreateFlags(priority: priority, isChildTask: false,
                                    copyTaskLocals: true, inheritContext: true,
                                    enqueueJob: false,
                                    addPendingGroupTaskUnconditionally: false,
                                    isDiscardingTask: false)
        let (task, _) = Builtin.createAsyncTask(flags, work)
        _startTaskOnMainActor(task)
        return Task(task)
    }
}
#endif
@available(SwiftStdlib 5.1, *)
public struct TaskPriority: RawRepresentable, Sendable {
  public typealias RawValue = UInt8
  public var rawValue: UInt8
  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
  public static let high: TaskPriority = .init(rawValue: 0x19)
  public static var medium: TaskPriority {
    .init(rawValue: 0x15)
  }
  public static let low: TaskPriority = .init(rawValue: 0x11)
  public static let userInitiated: TaskPriority = high
  public static let utility: TaskPriority = low
  public static let background: TaskPriority = .init(rawValue: 0x09)
  @available(*, deprecated, renamed: "medium")
  public static let `default`: TaskPriority = .init(rawValue: 0x15)
}
@available(SwiftStdlib 5.1, *)
extension TaskPriority: Equatable {
  public static func == (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
  public static func != (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue != rhs.rawValue
  }
}
@available(SwiftStdlib 5.1, *)
extension TaskPriority: Comparable {
  public static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
  public static func <= (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue <= rhs.rawValue
  }
  public static func > (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue > rhs.rawValue
  }
  public static func >= (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
    lhs.rawValue >= rhs.rawValue
  }
}
@available(SwiftStdlib 5.9, *)
extension TaskPriority: CustomStringConvertible {
  @available(SwiftStdlib 5.9, *)
  public var description: String {
    switch self.rawValue {
    case Self.low.rawValue:
      return "\(Self.self).low"
    case Self.medium.rawValue:
      return "\(Self.self).medium"
    case Self.high.rawValue:
      return "\(Self.self).high"
    case Self.background.rawValue:
      return "\(Self.self).background"
    default:
      return "\(Self.self)(rawValue: \(self.rawValue))"
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension TaskPriority: Codable { }
@available(SwiftStdlib 5.1, *)
extension Task where Success == Never, Failure == Never {
  public static var currentPriority: TaskPriority {
    withUnsafeCurrentTask { unsafeTask in
      if let unsafeTask {
         return unsafeTask.priority
      }
      return TaskPriority(rawValue: UInt8(_getCurrentThreadPriority()))
    }
  }
  @available(SwiftStdlib 5.7, *)
  public static var basePriority: TaskPriority? {
    withUnsafeCurrentTask { task in
      if let unsafeTask = task {
         return TaskPriority(rawValue: _taskBasePriority(unsafeTask._task))
      }
      return nil
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension TaskPriority {
  var _downgradeUserInteractive: TaskPriority {
    return self
  }
}
@available(SwiftStdlib 5.1, *)
struct JobFlags {
  enum Kind: Int32 {
    case task = 0
  }
  var bits: Int32 = 0
  var kind: Kind {
    get {
      Kind(rawValue: bits & 0xFF)!
    }
    set {
      bits = (bits & ~0xFF) | newValue.rawValue
    }
  }
  var isAsyncTask: Bool { kind == .task }
  var priority: TaskPriority? {
    get {
      let value = (Int(bits) & 0xFF00) >> 8
      if value == 0 {
        return nil
      }
      return TaskPriority(rawValue: UInt8(value))
    }
    set {
      bits = (bits & ~0xFF00) | Int32((Int(newValue?.rawValue ?? 0) << 8))
    }
  }
  var isChildTask: Bool {
    get {
      (bits & (1 << 24)) != 0
    }
    set {
      if newValue {
        bits = bits | 1 << 24
      } else {
        bits = (bits & ~(1 << 24))
      }
    }
  }
  var isFuture: Bool {
    get {
      (bits & (1 << 25)) != 0
    }
    set {
      if newValue {
        bits = bits | 1 << 25
      } else {
        bits = (bits & ~(1 << 25))
      }
    }
  }
  var isGroupChildTask: Bool {
    get {
      (bits & (1 << 26)) != 0
    }
    set {
      if newValue {
        bits = bits | 1 << 26
      } else {
        bits = (bits & ~(1 << 26))
      }
    }
  }
  var isContinuingAsyncTask: Bool {
    get {
      (bits & (1 << 27)) != 0
    }
    set {
      if newValue {
        bits = bits | 1 << 27
      } else {
        bits = (bits & ~(1 << 27))
      }
    }
  }
}
@available(SwiftStdlib 5.1, *)
func taskCreateFlags(
  priority: TaskPriority?, isChildTask: Bool, copyTaskLocals: Bool,
  inheritContext: Bool, enqueueJob: Bool,
  addPendingGroupTaskUnconditionally: Bool,
  isDiscardingTask: Bool
) -> Int {
  var bits = 0
  bits |= (bits & ~0xFF) | Int(priority?.rawValue ?? 0)
  if isChildTask {
    bits |= 1 << 8
  }
  if copyTaskLocals {
    bits |= 1 << 10
  }
  if inheritContext {
    bits |= 1 << 11
  }
  if enqueueJob {
    bits |= 1 << 12
  }
  if addPendingGroupTaskUnconditionally {
    bits |= 1 << 13
  }
  if isDiscardingTask {
    bits |= 1 << 14
  }
  return bits
}
@available(SwiftStdlib 5.1, *)
extension Task where Failure == Never {
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @discardableResult
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public init(
    priority: TaskPriority? = nil,
  ) {
    fatalError("Unavailable in task-to-thread concurrency model.")
  }
#else
  @discardableResult
  public init(
    priority: TaskPriority? = nil,
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: false, copyTaskLocals: true,
      inheritContext: true, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    let (task, _) = Builtin.createAsyncTask(flags, operation)
    self._task = task
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
}
@available(SwiftStdlib 5.1, *)
extension Task where Failure == Error {
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @discardableResult
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public init(
    priority: TaskPriority? = nil,
  ) {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
#else
  @discardableResult
  public init(
    priority: TaskPriority? = nil,
  ) {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: false, copyTaskLocals: true,
      inheritContext: true, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    let (task, _) = Builtin.createAsyncTask(flags, operation)
    self._task = task
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
}
@available(SwiftStdlib 5.1, *)
extension Task where Failure == Never {
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @discardableResult
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func detached(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> Success
  ) -> Task<Success, Failure> {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
#else
  @discardableResult
  public static func detached(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async -> Success
  ) -> Task<Success, Failure> {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: false, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    let (task, _) = Builtin.createAsyncTask(flags, operation)
    return Task(task)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
}
@available(SwiftStdlib 5.1, *)
extension Task where Failure == Error {
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @discardableResult
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func detached(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> Success
  ) -> Task<Success, Failure> {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
#else
  @discardableResult
  public static func detached(
    priority: TaskPriority? = nil,
    operation: __owned @Sendable @escaping () async throws -> Success
  ) -> Task<Success, Failure> {
#if compiler(>=5.5) && $BuiltinCreateAsyncTaskInGroup
    let flags = taskCreateFlags(
      priority: priority, isChildTask: false, copyTaskLocals: false,
      inheritContext: false, enqueueJob: true,
      addPendingGroupTaskUnconditionally: false,
      isDiscardingTask: false)
    let (task, _) = Builtin.createAsyncTask(flags, operation)
    return Task(task)
#else
    fatalError("Unsupported Swift compiler")
#endif
  }
#endif
}
@available(SwiftStdlib 5.1, *)
extension Task where Success == Never, Failure == Never {
  public static func yield() async {
    return await Builtin.withUnsafeContinuation { (continuation: Builtin.RawUnsafeContinuation) -> Void in
      let job = _taskCreateNullaryContinuationJob(
          priority: Int(Task.currentPriority.rawValue),
          continuation: continuation)
      _enqueueJobGlobal(job)
    }
  }
}
@available(SwiftStdlib 5.1, *)
public func withUnsafeCurrentTask<T>(body: (UnsafeCurrentTask?) throws -> T) rethrows -> T {
  guard let _task = _getCurrentAsyncTask() else {
    return try body(nil)
  }
  Builtin.retain(_task)
  return try body(UnsafeCurrentTask(_task))
}
@available(SwiftStdlib 5.1, *)
public struct UnsafeCurrentTask {
  internal let _task: Builtin.NativeObject
  internal init(_ task: Builtin.NativeObject) {
    self._task = task
  }
  public var isCancelled: Bool {
    _taskIsCancelled(_task)
  }
  public var priority: TaskPriority {
    TaskPriority(rawValue: _taskCurrentPriority(_task))
  }
  @available(SwiftStdlib 5.9, *)
  public var basePriority: TaskPriority {
    TaskPriority(rawValue: _taskBasePriority(_task))
  }
  public func cancel() {
    _taskCancel(_task)
  }
}
@available(SwiftStdlib 5.1, *)
@available(*, unavailable)
extension UnsafeCurrentTask: Sendable { }
@available(SwiftStdlib 5.1, *)
extension UnsafeCurrentTask: Hashable {
  public func hash(into hasher: inout Hasher) {
    UnsafeRawPointer(Builtin.bridgeToRawPointer(_task)).hash(into: &hasher)
  }
}
@available(SwiftStdlib 5.1, *)
extension UnsafeCurrentTask: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    UnsafeRawPointer(Builtin.bridgeToRawPointer(lhs._task)) ==
      UnsafeRawPointer(Builtin.bridgeToRawPointer(rhs._task))
  }
}
@available(SwiftStdlib 5.1, *)
func _getCurrentAsyncTask() -> Builtin.NativeObject?
fileprivate func _startTaskOnMainActor(_ task: Builtin.NativeObject) -> Builtin.NativeObject?
@available(SwiftStdlib 5.1, *)
func getJobFlags(_ task: Builtin.NativeObject) -> JobFlags
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _enqueueJobGlobal(_ task: Builtin.Job)
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _enqueueJobGlobalWithDelay(_ delay: UInt64, _ task: Builtin.Job)
@available(SwiftStdlib 5.7, *)
@usableFromInline
func _enqueueJobGlobalWithDeadline(_ seconds: Int64, _ nanoseconds: Int64,
                                   _ toleranceSec: Int64, _ toleranceNSec: Int64,
                                   _ clock: Int32, _ task: Builtin.Job)
@available(SwiftStdlib 5.1, *)
@usableFromInline
internal func _asyncMainDrainQueue() -> Never
@available(SwiftStdlib 5.1, *)
@usableFromInline
internal func _getMainExecutor() -> Builtin.Executor
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
@usableFromInline
@preconcurrency
internal func _runAsyncMain(_ asyncFun: @Sendable @escaping () async throws -> ()) {
  fatalError("Unavailable in task-to-thread concurrency model")
}
#else
@available(SwiftStdlib 5.1, *)
@usableFromInline
@preconcurrency
internal func _runAsyncMain(_ asyncFun: @Sendable @escaping () async throws -> ()) {
  Task.detached {
    do {
#if !os(Windows)
#if compiler(>=5.5) && $BuiltinHopToActor
      Builtin.hopToActor(MainActor.shared)
#else
      fatalError("Swift compiler is incompatible with this SDK version")
#endif
#endif
      try await asyncFun()
      exit(0)
    } catch {
      _errorInMain(error)
    }
  }
  _asyncMainDrainQueue()
}
#endif
@available(SwiftStdlib 5.1, *)
public func _taskFutureGet<T>(_ task: Builtin.NativeObject) async -> T
@available(SwiftStdlib 5.1, *)
public func _taskFutureGetThrowing<T>(_ task: Builtin.NativeObject) async throws -> T
@available(SwiftStdlib 5.1, *)
func _taskCancel(_ task: Builtin.NativeObject)
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _taskIsCancelled(_ task: Builtin.NativeObject) -> Bool
internal func _taskCurrentPriority(_ task: Builtin.NativeObject) -> UInt8
internal func _taskBasePriority(_ task: Builtin.NativeObject) -> UInt8
@available(SwiftStdlib 5.1, *)
func _taskCreateNullaryContinuationJob(priority: Int, continuation: Builtin.RawUnsafeContinuation) -> Builtin.Job
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _taskIsCurrentExecutor(_ executor: Builtin.Executor) -> Bool
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _reportUnexpectedExecutor(_ _filenameStart: Builtin.RawPointer,
                               _ _filenameLength: Builtin.Word,
                               _ _filenameIsASCII: Builtin.Int1,
                               _ _line: Builtin.Word,
                               _ _executor: Builtin.Executor)
@available(SwiftStdlib 5.1, *)
func _getCurrentThreadPriority() -> Int
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.8, *)
@usableFromInline
internal func _taskRunInline<T>(_ body: () async -> T) -> T {
#if compiler(>=5.5) && $BuiltinTaskRunInline
  return Builtin.taskRunInline(body)
#else
  fatalError("Unsupported Swift compiler")
#endif
}
@available(SwiftStdlib 5.8, *)
extension Task where Failure == Never {
  @available(SwiftStdlib 5.8, *)
  public static func runInline(_ body: () async -> Success) -> Success {
    return _taskRunInline(body)
  }
}
@available(SwiftStdlib 5.8, *)
extension Task where Failure == Error {
  @available(SwiftStdlib 5.8, *)
  @usableFromInline
  internal static func _runInlineHelper<T>(
    body: () async -> Result<T, Error>,
    rescue: (Result<T, Error>) throws -> T
  ) rethrows -> T {
    return try rescue(
      _taskRunInline(body)
    )
  }
  @available(SwiftStdlib 5.8, *)
  public static func runInline(_ body: () async throws -> Success) rethrows -> Success {
    return try _runInlineHelper(
      body: {
        do {
          let value = try await body()
          return Result.success(value)
        }
        catch let error {
          return Result.failure(error)
        }
    },
      rescue: { try $0.get() }
    )
  }
}
#endif
#if _runtime(_ObjC)
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
@usableFromInline
#if compiler(>=5.6)
  Task(operation: body)
#else
  Task<Int, Error> {
    await body()
    return 0
  }
#endif
}
#endif
#endif
