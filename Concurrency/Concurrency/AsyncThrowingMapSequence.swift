import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func map<Transformed>(
    _ transform: @Sendable @escaping (Element) async throws -> Transformed
  ) -> AsyncThrowingMapSequence<Self, Transformed> {
    return AsyncThrowingMapSequence(self, transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingMapSequence<Base: AsyncSequence, Transformed> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let transform: (Base.Element) async throws -> Transformed
  @usableFromInline
  init(
    _ base: Base, 
    transform: @escaping (Base.Element) async throws -> Transformed
  ) {
    self.base = base
    self.transform = transform
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingMapSequence: AsyncSequence {
  public typealias Element = Transformed
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let transform: (Base.Element) async throws -> Transformed
    @usableFromInline
    var finished = false
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator, 
      transform: @escaping (Base.Element) async throws -> Transformed
    ) {
      self.baseIterator = baseIterator
      self.transform = transform
    }
   @inlinable
    public mutating func next() async throws -> Transformed? {
      guard !finished, let element = try await baseIterator.next() else {
        return nil
      }
      do {
        return try await transform(element)
      } catch {
        finished = true
        throw error   
      }
    }
  }
  @inlinable
  public __consuming func makeAsyncIterator() -> Iterator {
    return Iterator(base.makeAsyncIterator(), transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingMapSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable, 
        Transformed: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingMapSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable, 
        Transformed: Sendable { }
