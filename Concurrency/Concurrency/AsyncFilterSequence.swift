import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency 
  @inlinable
  public __consuming func filter(
    _ isIncluded: @Sendable @escaping (Element) async -> Bool
  ) -> AsyncFilterSequence<Self> {
    return AsyncFilterSequence(self, isIncluded: isIncluded)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncFilterSequence<Base: AsyncSequence> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let isIncluded: (Element) async -> Bool
  @usableFromInline
  init(
    _ base: Base, 
    isIncluded: @escaping (Base.Element) async -> Bool
  ) {
    self.base = base
    self.isIncluded = isIncluded
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncFilterSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let isIncluded: (Base.Element) async -> Bool
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator,
      isIncluded: @escaping (Base.Element) async -> Bool
    ) {
      self.baseIterator = baseIterator
      self.isIncluded = isIncluded
    }
    @inlinable
    public mutating func next() async rethrows -> Base.Element? {
      while true {
        guard let element = try await baseIterator.next() else {
          return nil
        }
        if await isIncluded(element) {
          return element
        }
      }
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), isIncluded: isIncluded)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncFilterSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncFilterSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
