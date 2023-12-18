import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func compactMap<ElementOfResult>(
    _ transform: @Sendable @escaping (Element) async -> ElementOfResult?
  ) -> AsyncCompactMapSequence<Self, ElementOfResult> {
    return AsyncCompactMapSequence(self, transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncCompactMapSequence<Base: AsyncSequence, ElementOfResult> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let transform: (Base.Element) async -> ElementOfResult?
  @usableFromInline
  init(
    _ base: Base, 
    transform: @escaping (Base.Element) async -> ElementOfResult?
  ) {
    self.base = base
    self.transform = transform
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncCompactMapSequence: AsyncSequence {
  public typealias Element = ElementOfResult
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    public typealias Element = ElementOfResult
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let transform: (Base.Element) async -> ElementOfResult?
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      transform: @escaping (Base.Element) async -> ElementOfResult?
    ) {
      self.baseIterator = baseIterator
      self.transform = transform
    }
    @inlinable
    public mutating func next() async rethrows -> ElementOfResult? {
      while true {
        guard let element = try await baseIterator.next() else {
          return nil
        }
        if let transformed = await transform(element) {
          return transformed
        }
      }
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncCompactMapSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable, 
        ElementOfResult: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncCompactMapSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable, 
        ElementOfResult: Sendable { }
