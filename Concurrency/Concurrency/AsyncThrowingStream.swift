import Swift
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingStream<Element, Failure: Error> {
  public struct Continuation: Sendable {
    public enum Termination {
      case finished(Failure?)
      case cancelled
    }
    public enum YieldResult {
      case enqueued(remaining: Int)
      case dropped(Element)
      case terminated
    }
    public enum BufferingPolicy {
      case unbounded
      case bufferingOldest(Int)
      case bufferingNewest(Int)
    }
    let storage: _Storage
    @discardableResult
    public func yield(_ value: __owned Element) -> YieldResult {
      storage.yield(value)
    }
    public func finish(throwing error: __owned Failure? = nil) {
      storage.finish(throwing: error)
    }
    public var onTermination: (@Sendable (Termination) -> Void)? {
      get {
        return storage.getOnTermination()
      }
      nonmutating set {
        storage.setOnTermination(newValue)
      }
    }
  }
  final class _Context {
    let storage: _Storage?
    let produce: () async throws -> Element?
    init(storage: _Storage? = nil, produce: @escaping () async throws -> Element?) {
      self.storage = storage
      self.produce = produce
    }
    deinit {
      storage?.cancel()
    }
  }
  let context: _Context
  public init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded,
    _ build: (Continuation) -> Void
  ) where Failure == Error {
    let storage: _Storage = .create(limit: limit)
    context = _Context(storage: storage, produce: storage.next)
    build(Continuation(storage: storage))
  }
  public init(
    unfolding produce: @escaping () async throws -> Element?
  ) where Failure == Error {
    let storage: _AsyncStreamCriticalStorage<Optional<() async throws -> Element?>>
      = .create(produce)
    context = _Context {
      return try await withTaskCancellationHandler {
        guard let result = try await storage.value?() else {
          storage.value = nil
          return nil
        }
        return result
      } onCancel: {
        storage.value = nil
      }
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingStream: AsyncSequence {
  public struct Iterator: AsyncIteratorProtocol {
    let context: _Context
    public mutating func next() async throws -> Element? {
      return try await context.produce()
    }
  }
  public func makeAsyncIterator() -> Iterator {
    return Iterator(context: context)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingStream.Continuation {
  @discardableResult
  public func yield(
    with result: Result<Element, Failure>
  ) -> YieldResult where Failure == Error {
    switch result {
    case .success(let val):
      return storage.yield(val)
    case .failure(let err):
      storage.finish(throwing: err)
      return .terminated
    }
  }
  @discardableResult
  public func yield() -> YieldResult where Element == Void {
    storage.yield(())
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingStream {
  @available(SwiftStdlib 5.1, *)
  @backDeployed(before: SwiftStdlib 5.9)
  public static func makeStream(
      of elementType: Element.Type = Element.self,
      throwing failureType: Failure.Type = Failure.self,
      bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
  ) -> (stream: AsyncThrowingStream<Element, Failure>, continuation: AsyncThrowingStream<Element, Failure>.Continuation) where Failure == Error {
    var continuation: AsyncThrowingStream<Element, Failure>.Continuation!
    let stream = AsyncThrowingStream<Element, Failure>(bufferingPolicy: limit) { continuation = $0 }
    return (stream: stream, continuation: continuation!)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingStream: @unchecked Sendable where Element: Sendable { }
#else
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
public struct AsyncThrowingStream<Element, Failure: Error> {
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public struct Continuation: Sendable {
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public enum Termination {
      case finished(Failure?)
      case cancelled
    }
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public enum YieldResult {
      case enqueued(remaining: Int)
      case dropped(Element)
      case terminated
    }
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public enum BufferingPolicy {
      case unbounded
      case bufferingOldest(Int)
      case bufferingNewest(Int)
    }
    @discardableResult
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public func yield(_ value: __owned Element) -> YieldResult {
      fatalError("Unavailable in task-to-thread concurrency model")
    }
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public func finish(throwing error: __owned Failure? = nil) {
      fatalError("Unavailable in task-to-thread concurrency model")
    }
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public var onTermination: (@Sendable (Termination) -> Void)? {
      get {
        fatalError("Unavailable in task-to-thread concurrency model")
      }
      nonmutating set {
        fatalError("Unavailable in task-to-thread concurrency model")
      }
    }
  }
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public init(
    _ elementType: Element.Type = Element.self,
    bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded,
    _ build: (Continuation) -> Void
  ) where Failure == Error {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public init(
    unfolding produce: @escaping () async throws -> Element?
  ) where Failure == Error {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension AsyncThrowingStream {
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public struct Iterator {
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public mutating func next() async throws -> Element? {
      fatalError("Unavailable in task-to-thread concurrency model")
    }
  }
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public func makeAsyncIterator() -> Iterator {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension AsyncThrowingStream.Continuation {
  @discardableResult
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public func yield(
    with result: Result<Element, Failure>
  ) -> YieldResult where Failure == Error {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  @discardableResult
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public func yield() -> YieldResult where Element == Void {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension AsyncThrowingStream: @unchecked Sendable where Element: Sendable { }
#endif
