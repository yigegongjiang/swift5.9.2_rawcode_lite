import Swift
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
extension Task where Success == Never, Failure == Never {
  @available(*, deprecated, renamed: "Task.sleep(nanoseconds:)")
  public static func sleep(_ duration: UInt64) async {
    return await Builtin.withUnsafeContinuation {
      (continuation: Builtin.RawUnsafeContinuation) -> Void in
      let job = _taskCreateNullaryContinuationJob(
          priority: Int(Task.currentPriority.rawValue),
          continuation: continuation)
      _enqueueJobGlobalWithDelay(duration, job)
    }
  }
  typealias SleepContinuation = UnsafeContinuation<(), Error>
  enum SleepState {
    case notStarted
    case activeContinuation(SleepContinuation)
    case finished
    case cancelled
    case cancelledBeforeStarted
    init(word: Builtin.Word) {
      switch UInt(word) & 0x03 {
      case 0:
        let continuationBits = UInt(word) & ~0x03
        if continuationBits == 0 {
          self = .notStarted
        } else {
          let continuation = unsafeBitCast(
            continuationBits, to: SleepContinuation.self)
          self = .activeContinuation(continuation)
        }
      case 1:
        self = .finished
      case 2:
        self = .cancelled
      case 3:
        self = .cancelledBeforeStarted
      default:
        fatalError("Bitmask failure")
      }
    }
    init(loading wordPtr: UnsafeMutablePointer<Builtin.Word>) {
      self.init(word: Builtin.atomicload_seqcst_Word(wordPtr._rawValue))
    }
    var word: UInt {
      switch self {
      case .notStarted:
        return 0
      case .activeContinuation(let continuation):
        let continuationBits = unsafeBitCast(continuation, to: UInt.self)
        return continuationBits
      case .finished:
        return 1
      case .cancelled:
        return 2
      case .cancelledBeforeStarted:
        return 3
      }
    }
  }
  static func onSleepWake(
      _ wordPtr: UnsafeMutablePointer<Builtin.Word>
  ) {
    while true {
      let state = SleepState(loading: wordPtr)
      switch state {
      case .notStarted:
        fatalError("Cannot wake before we even started")
      case .activeContinuation(let continuation):
        let (_, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
            wordPtr._rawValue,
            state.word._builtinWordValue,
            SleepState.finished.word._builtinWordValue)
        if Bool(_builtinBooleanLiteral: won) {
          continuation.resume()
          return
        }
        continue
      case .finished:
        fatalError("Already finished normally, can't do that again")
      case .cancelled:
        wordPtr.deallocate()
        return
      case .cancelledBeforeStarted:
        return
      }
    }
  }
  static func onSleepCancel(
      _ wordPtr: UnsafeMutablePointer<Builtin.Word>
  ) {
    while true {
      let state = SleepState(loading: wordPtr)
      switch state {
      case .notStarted:
        let (_, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
            wordPtr._rawValue,
            state.word._builtinWordValue,
            SleepState.cancelledBeforeStarted.word._builtinWordValue)
        if Bool(_builtinBooleanLiteral: won) {
          return
        }
        continue
      case .activeContinuation(let continuation):
        let (_, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
            wordPtr._rawValue,
            state.word._builtinWordValue,
            SleepState.cancelled.word._builtinWordValue)
        if Bool(_builtinBooleanLiteral: won) {
          continuation.resume(throwing: _Concurrency.CancellationError())
          return
        }
        continue
      case .finished, .cancelled, .cancelledBeforeStarted:
        return
      }
    }
  }
  public static func sleep(nanoseconds duration: UInt64) async throws {
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
              _enqueueJobGlobalWithDelay(
                  duration, Builtin.convertTaskToJob(sleepTask))
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
}
#else
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension Task where Success == Never, Failure == Never {
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func sleep(_ duration: UInt64) async {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public static func sleep(nanoseconds duration: UInt64) async throws {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
#endif
