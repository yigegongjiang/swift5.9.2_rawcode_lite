import Swift
#if SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
@globalActor public final actor MainActor: GlobalActor {
  public static let shared = MainActor()
  @inlinable
  public nonisolated var unownedExecutor: UnownedSerialExecutor {
    #if compiler(>=5.5) && $BuiltinBuildMainExecutor
    return UnownedSerialExecutor(Builtin.buildMainActorExecutorRef())
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @inlinable
  public static var sharedUnownedExecutor: UnownedSerialExecutor {
    #if compiler(>=5.5) && $BuiltinBuildMainExecutor
    return UnownedSerialExecutor(Builtin.buildMainActorExecutorRef())
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @inlinable
  public nonisolated func enqueue(_ job: UnownedJob) {
    _enqueueOnMain(job)
  }
}
#else
@available(SwiftStdlib 5.1, *)
@globalActor public final actor MainActor: GlobalActor {
  public static let shared = MainActor()
  @inlinable
  public nonisolated var unownedExecutor: UnownedSerialExecutor {
    #if compiler(>=5.5) && $BuiltinBuildMainExecutor
    return UnownedSerialExecutor(Builtin.buildMainActorExecutorRef())
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @inlinable
  public static var sharedUnownedExecutor: UnownedSerialExecutor {
    #if compiler(>=5.5) && $BuiltinBuildMainExecutor
    return UnownedSerialExecutor(Builtin.buildMainActorExecutorRef())
    #else
    fatalError("Swift compiler is incompatible with this SDK version")
    #endif
  }
  @inlinable
  public nonisolated func enqueue(_ job: UnownedJob) {
    _enqueueOnMain(job)
  }
}
#endif
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
extension MainActor {
  @usableFromInline
  static func run<T>(
    resultType: T.Type = T.self,
    body: @MainActor @Sendable () throws -> T
  ) async rethrows -> T {
    return try await body()
  }
  public static func run<T: Sendable>(
    resultType: T.Type = T.self,
    body: @MainActor @Sendable () throws -> T
  ) async rethrows -> T {
    return try await body()
  }
}
@available(SwiftStdlib 5.9, *)
extension MainActor {
  @available(SwiftStdlib 5.9, *)
  public static func assumeIsolated<T>(
      _ operation: @MainActor () throws -> T,
      file: StaticString = #fileID, line: UInt = #line
  ) rethrows -> T {
    typealias YesActor = @MainActor () throws -> T
    typealias NoActor = () throws -> T
    let executor: Builtin.Executor = Self.shared.unownedExecutor.executor
    guard _taskIsCurrentExecutor(executor) else {
      fatalError("Incorrect actor executor assumption; Expected same executor as \(self).", file: file, line: line)
    }
    return try withoutActuallyEscaping(operation) {
      (_ fn: @escaping YesActor) throws -> T in
      let rawFn = unsafeBitCast(fn, to: NoActor.self)
      return try rawFn()
    }
  }
}
#endif
