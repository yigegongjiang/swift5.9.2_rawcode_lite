import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @inlinable
  public __consuming func dropFirst(
    _ count: Int = 1
  ) -> AsyncDropFirstSequence<Self> {
    precondition(count >= 0, 
      "Can't drop a negative number of elements from an async sequence")
    return AsyncDropFirstSequence(self, dropping: count)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncDropFirstSequence<Base: AsyncSequence> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let count: Int
  @usableFromInline 
  init(_ base: Base, dropping count: Int) {
    self.base = base
    self.count = count
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncDropFirstSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    var count: Int
    @usableFromInline
    init(_ baseIterator: Base.AsyncIterator, count: Int) {
      self.baseIterator = baseIterator
      self.count = count
    }
    @inlinable
    public mutating func next() async rethrows -> Base.Element? {
      var remainingToDrop = count
      while remainingToDrop > 0 {
        guard try await baseIterator.next() != nil else {
          count = 0
          return nil
        }
        remainingToDrop -= 1
      }
      count = 0
      return try await baseIterator.next()
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), count: count)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncDropFirstSequence {
  @inlinable
  public __consuming func dropFirst(
    _ count: Int = 1
  ) -> AsyncDropFirstSequence<Base> {
    precondition(count >= 0, 
      "Can't drop a negative number of elements from an async sequence")
    return AsyncDropFirstSequence(base, dropping: self.count + count)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncDropFirstSequence: Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncDropFirstSequence.Iterator: Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
