import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency 
  @inlinable
  public __consuming func drop(
    while predicate: @Sendable @escaping (Element) async -> Bool
  ) -> AsyncDropWhileSequence<Self> {
    AsyncDropWhileSequence(self, predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncDropWhileSequence<Base: AsyncSequence> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let predicate: (Base.Element) async -> Bool
  @usableFromInline
  init(
    _ base: Base, 
    predicate: @escaping (Base.Element) async -> Bool
  ) {
    self.base = base
    self.predicate = predicate
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncDropWhileSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    var predicate: ((Base.Element) async -> Bool)?
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      predicate: @escaping (Base.Element) async -> Bool
    ) {
      self.baseIterator = baseIterator
      self.predicate = predicate
    }
    @inlinable
    public mutating func next() async rethrows -> Base.Element? {
      while let predicate = self.predicate {
        guard let element = try await baseIterator.next() else {
          return nil
        }
        if await predicate(element) == false {
          self.predicate = nil
          return element
        }
      }
      return try await baseIterator.next()
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncDropWhileSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncDropWhileSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
