import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func drop(
    while predicate: @Sendable @escaping (Element) async throws -> Bool
  ) -> AsyncThrowingDropWhileSequence<Self> {
    AsyncThrowingDropWhileSequence(self, predicate: predicate)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingDropWhileSequence<Base: AsyncSequence> {
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
extension AsyncThrowingDropWhileSequence: AsyncSequence {
  public typealias Element = Base.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let predicate: (Base.Element) async throws -> Bool
    @usableFromInline
    var finished = false
    @usableFromInline
    var doneDropping = false
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
      while !finished && !doneDropping {
        guard let element = try await baseIterator.next() else {
          return nil
        }
        do {
          if try await predicate(element) == false {
            doneDropping = true
            return element
          }
        } catch {
          finished = true
          throw error
        }
      }
      guard !finished else { 
        return nil
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
extension AsyncThrowingDropWhileSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingDropWhileSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable { }
