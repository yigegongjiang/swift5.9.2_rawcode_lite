import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func prefix(
    while predicate: @Sendable @escaping (Element) async -> Bool
  ) rethrows -> AsyncPrefixWhileSequence<Self> {
    return AsyncPrefixWhileSequence(self, predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncPrefixWhileSequence<Base: AsyncSequence> {
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
extension AsyncPrefixWhileSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var predicateHasFailed = false
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let predicate: (Base.Element) async -> Bool
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
      if !predicateHasFailed, let nextElement = try await baseIterator.next() {
        if await predicate(nextElement) {
          return nextElement
        } else {
          predicateHasFailed = true
        }
      }
      return nil
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncPrefixWhileSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncPrefixWhileSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
