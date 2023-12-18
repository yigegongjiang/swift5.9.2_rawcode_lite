import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func compactMap<ElementOfResult>(
    _ transform: @Sendable @escaping (Element) async throws -> ElementOfResult?
  ) -> AsyncThrowingCompactMapSequence<Self, ElementOfResult> {
    return AsyncThrowingCompactMapSequence(self, transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingCompactMapSequence<Base: AsyncSequence, ElementOfResult> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let transform: (Base.Element) async throws -> ElementOfResult?
  @usableFromInline
  init(
    _ base: Base, 
    transform: @escaping (Base.Element) async throws -> ElementOfResult?
  ) {
    self.base = base
    self.transform = transform
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingCompactMapSequence: AsyncSequence {
  public typealias Element = ElementOfResult
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    public typealias Element = ElementOfResult
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let transform: (Base.Element) async throws -> ElementOfResult?
    @usableFromInline
    var finished = false
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      transform: @escaping (Base.Element) async throws -> ElementOfResult?
    ) {
      self.baseIterator = baseIterator
      self.transform = transform
    }
    @inlinable
    public mutating func next() async throws -> ElementOfResult? {
      while !finished {
        guard let element = try await baseIterator.next() else {
          finished = true
          return nil
        }
        do {
          if let transformed = try await transform(element) {
            return transformed
          }
        } catch {
          finished = true
          throw error
        }
      }
      return nil
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingCompactMapSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingCompactMapSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
