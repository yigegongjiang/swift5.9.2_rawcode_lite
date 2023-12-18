import Swift
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.7, *)
extension Task where Success == Never, Failure == Never {
  @available(SwiftStdlib 5.7, *)
  internal static func _sleep(
    until seconds: Int64, _ nanoseconds: Int64,
    tolerance: Duration?,
    clock: _ClockID
  ) async throws {
    let wordPtr = UnsafeMutablePointer<Builtin.Word>.allocate(capacity: 1)
    Builtin.atomicstore_seqcst_Word(
        wordPtr._rawValue, SleepState.notStarted.word._builtinWordValue)
    do {
      try await withTaskCancellationHandler {
        let _: () = try await withUnsafeThrowingContinuation { continuation in
          while true {
            let state = SleepState(loading: wordPtr)
            switch state {
            case .notStarted:
              let continuationWord =
                SleepState.activeContinuation(continuation).word
              let (_, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
                  wordPtr._rawValue,
                  state.word._builtinWordValue,
                  continuationWord._builtinWordValue)
              if !Bool(_builtinBooleanLiteral: won) {
                continue
              }
              let sleepTaskFlags = taskCreateFlags(
                priority: nil, isChildTask: false, copyTaskLocals: false,
                inheritContext: false, enqueueJob: false,
                addPendingGroupTaskUnconditionally: false,
                isDiscardingTask: false)
              let (sleepTask, _) = Builtin.createAsyncTask(sleepTaskFlags) {
                onSleepWake(wordPtr)
              }
              let toleranceSeconds: Int64
              let toleranceNanoseconds: Int64
              if let components = tolerance?.components {
                toleranceSeconds = components.seconds
                toleranceNanoseconds = components.attoseconds / 1_000_000_000
              } else {
                toleranceSeconds = 0
                toleranceNanoseconds = -1
              }
              _enqueueJobGlobalWithDeadline(
                  seconds, nanoseconds,
                  toleranceSeconds, toleranceNanoseconds,
                  clock.rawValue, Builtin.convertTaskToJob(sleepTask))
              return
            case .activeContinuation, .finished:
              fatalError("Impossible to have multiple active continuations")
            case .cancelled:
              fatalError("Impossible to have cancelled before we began")
            case .cancelledBeforeStarted:
              continuation.resume()
              return
          }
        }
        }
      } onCancel: {
        onSleepCancel(wordPtr)
      }
      let cancelledBeforeStarted: Bool
      switch SleepState(loading: wordPtr) {
      case .notStarted, .activeContinuation, .cancelled:
        fatalError("Invalid state for non-cancelled sleep task")
      case .cancelledBeforeStarted:
        cancelledBeforeStarted = true
      case .finished:
        cancelledBeforeStarted = false
      }
      wordPtr.deallocate()
      if cancelledBeforeStarted {
        throw _Concurrency.CancellationError()
      }
    } catch {
      throw error
    }
  }
  @available(SwiftStdlib 5.7, *)
  public static func sleep<C: Clock>(
    until deadline: C.Instant,
    tolerance: C.Instant.Duration? = nil,
    clock: C = ContinuousClock()
  ) async throws {
    try await clock.sleep(until: deadline, tolerance: tolerance)
  }
  @available(SwiftStdlib 5.7, *)
  public static func sleep<C: Clock>(
    for duration: C.Instant.Duration,
    tolerance: C.Instant.Duration? = nil,
    clock: C = ContinuousClock()
  ) async throws {
    try await clock.sleep(for: duration, tolerance: tolerance)
  }
}
#else
@available(SwiftStdlib 5.7, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension Task where Success == Never, Failure == Never {
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func sleep<C: Clock>(
    until deadline: C.Instant,
    tolerance: C.Instant.Duration? = nil,
    clock: C = ContinuousClock()
  ) async throws {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func sleep<C: Clock>(
    for duration: C.Instant.Duration,
    tolerance: C.Instant.Duration? = nil,
    clock: C = ContinuousClock()
  ) async throws {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
#endif
