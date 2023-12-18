import Swift
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
@available(SwiftStdlib 5.1, *)
public struct AsyncStream<Element> {
  public struct Continuation: Sendable {
    public enum Termination {
      case finished
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
    public func finish() {
      storage.finish()
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
    let produce: () async -> Element?
    init(storage: _Storage? = nil, produce: @escaping () async -> Element?) {
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
  ) {
    let storage: _Storage = .create(limit: limit)
    context = _Context(storage: storage, produce: storage.next)
    build(Continuation(storage: storage))
  }
  public init(
    unfolding produce: @escaping () async -> Element?, 
    onCancel: (@Sendable () -> Void)? = nil
  ) {
    let storage: _AsyncStreamCriticalStorage<Optional<() async -> Element?>>
      = .create(produce)
    context = _Context {
      return await withTaskCancellationHandler {
        guard let result = await storage.value?() else {
          storage.value = nil
          return nil
        }
        return result
      } onCancel: {
        storage.value = nil
        onCancel?()
      }
    }
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncStream: AsyncSequence {
  public struct Iterator: AsyncIteratorProtocol {
    let context: _Context
    public mutating func next() async -> Element? {
      await context.produce()
    }
  }
  public func makeAsyncIterator() -> Iterator {
    return Iterator(context: context)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncStream.Continuation {
  @discardableResult
  public func yield(
    with result: Result<Element, Never>
  ) -> YieldResult {
    switch result {
      case .success(let val):
        return storage.yield(val)
    }
  }
  @discardableResult
  public func yield() -> YieldResult where Element == Void {
    return storage.yield(())
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncStream {
  @available(SwiftStdlib 5.1, *)
  @backDeployed(before: SwiftStdlib 5.9)
  public static func makeStream(
      of elementType: Element.Type = Element.self,
      bufferingPolicy limit: Continuation.BufferingPolicy = .unbounded
  ) -> (stream: AsyncStream<Element>, continuation: AsyncStream<Element>.Continuation) {
    var continuation: AsyncStream<Element>.Continuation!
    let stream = AsyncStream<Element>(bufferingPolicy: limit) { continuation = $0 }
    return (stream: stream, continuation: continuation!)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncStream: @unchecked Sendable where Element: Sendable { }
#else
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
public struct AsyncStream<Element> {
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public struct Continuation: Sendable {
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public enum Termination {
      case finished
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
    public func finish() {
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
  ) {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public init(
    unfolding produce: @escaping () async -> Element?, 
    onCancel: (@Sendable () -> Void)? = nil
  ) {
    fatalError("Unavailable in task-to-thread concurrency model")
  }
}
@available(SwiftStdlib 5.1, *)
@available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
extension AsyncStream {
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public struct Iterator {
    @available(SwiftStdlib 5.1, *)
    @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
    public mutating func next() async -> Element? {
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
extension AsyncStream.Continuation {
  @discardableResult
  @available(SwiftStdlib 5.1, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public func yield(
    with result: Result<Element, Never>
  ) -> YieldResult {
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
extension AsyncStream: @unchecked Sendable where Element: Sendable { }
#endif
