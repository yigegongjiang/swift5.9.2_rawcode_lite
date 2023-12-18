import Swift
@available(SwiftStdlib 5.1, *)
extension AsyncSequence {
  @preconcurrency
  @inlinable
  public __consuming func flatMap<SegmentOfResult: AsyncSequence>(
    _ transform: @Sendable @escaping (Element) async throws -> SegmentOfResult
  ) -> AsyncThrowingFlatMapSequence<Self, SegmentOfResult> {
    return AsyncThrowingFlatMapSequence(self, transform: transform)
  }
}
@available(SwiftStdlib 5.1, *)
public struct AsyncThrowingFlatMapSequence<Base: AsyncSequence, SegmentOfResult: AsyncSequence> {
  @usableFromInline
  let base: Base
  @usableFromInline
  let transform: (Base.Element) async throws -> SegmentOfResult
  @usableFromInline
  init(
    _ base: Base,
    transform: @escaping (Base.Element) async throws -> SegmentOfResult
  ) {
    self.base = base
    self.transform = transform
  }
}
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingFlatMapSequence: AsyncSequence {
  public typealias Element = SegmentOfResult.Element
  public typealias AsyncIterator = Iterator
  public struct Iterator: AsyncIteratorProtocol {
    @usableFromInline
    var baseIterator: Base.AsyncIterator
    @usableFromInline
    let transform: (Base.Element) async throws -> SegmentOfResult
    @usableFromInline
    var currentIterator: SegmentOfResult.AsyncIterator?
    @usableFromInline
    var finished = false
    @usableFromInline
    init(
      _ baseIterator: Base.AsyncIterator,
      transform: @escaping (Base.Element) async throws -> SegmentOfResult
    ) {
      self.baseIterator = baseIterator
      self.transform = transform
    }
    @inlinable
    public mutating func next() async throws -> SegmentOfResult.Element? {
      while !finished {
        if var iterator = currentIterator {
          do {
            guard let element = try await iterator.next() else {
              currentIterator = nil
              continue
            }
            currentIterator = iterator
            return element
          } catch {
            finished = true
            throw error
          }
        } else {
          guard let item = try await baseIterator.next() else {
            return nil
          }
          let segment: SegmentOfResult
          do {
            segment = try await transform(item)
            var iterator = segment.makeAsyncIterator()
            guard let element = try await iterator.next() else {
              currentIterator = nil
              continue
            }
            currentIterator = iterator
            return element
          } catch {
            finished = true
            currentIterator = nil
            throw error
          }
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
extension AsyncThrowingFlatMapSequence: @unchecked Sendable 
  where Base: Sendable, 
        Base.Element: Sendable, 
        SegmentOfResult: Sendable, 
        SegmentOfResult.Element: Sendable { }
@available(SwiftStdlib 5.1, *)
extension AsyncThrowingFlatMapSequence.Iterator: @unchecked Sendable 
  where Base.AsyncIterator: Sendable, 
        Base.Element: Sendable, 
        SegmentOfResult: Sendable, 
        SegmentOfResult.Element: Sendable, 
        SegmentOfResult.AsyncIterator: Sendable { }
