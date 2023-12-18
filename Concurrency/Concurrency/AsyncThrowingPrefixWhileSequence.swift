import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func prefix(
    while predicate: @Sendable @escaping (Element) async throws -> Bool
  ) rethrows -> AsyncThrowingPrefixWhileSequence<Self> {
    return AsyncThrowingPrefixWhileSequence(self, predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingPrefixWhileSequence<Base: AsyncSequence> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let predicate: (Base.Element) async throws -> Bool
  @usableFromInline
  init(
    _ base: Base, 
    predicate: @escaping (Base.Element) async throws -> Bool
  ) {
    self.base = base
    self.predicate = predicate
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingPrefixWhileSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var predicateHasFailed = false
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let predicate: (Base.Element) async throws -> Bool
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      predicate: @escaping (Base.Element) async throws -> Bool
    ) {
      self.baseIterator = baseIterator
      self.predicate = predicate
    }
    @inlinable
    public mutating func next() async throws -> Base.Element? {
      if !predicateHasFailed, let nextElement = try await baseIterator.next() {
        do { 
          if try await predicate(nextElement) {
            return nextElement
          } else {
            predicateHasFailed = true
          }
        } catch {
          predicateHasFailed = true
          throw error
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
extension AsyncThrowingPrefixWhileSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingPrefixWhileSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
