import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency 
  @inlinable
  public __consuming func map<Transformed>(
    _ transform: @Sendable @escaping (Element) async -> Transformed
  ) -> AsyncMapSequence<Self, Transformed> {
    return AsyncMapSequence(self, transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncMapSequence<Base: AsyncSequence, Transformed> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let transform: (Base.Element) async -> Transformed
  @usableFromInline
  init(
    _ base: Base, 
    transform: @escaping (Base.Element) async -> Transformed
  ) {
    self.base = base
    self.transform = transform
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncMapSequence: AsyncSequence {
  public typealias Element = Transformed
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let transform: (Base.Element) async -> Transformed
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      transform: @escaping (Base.Element) async -> Transformed
    ) {
      self.baseIterator = baseIterator
      self.transform = transform
    }
    @inlinable
    public mutating func next() async rethrows -> Transformed? {
      guard let element = try await baseIterator.next() else {
        return nil
      }
      return await transform(element)
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncMapSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable, 
        Transformed: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncMapSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable, 
        Transformed: Sendable { }
