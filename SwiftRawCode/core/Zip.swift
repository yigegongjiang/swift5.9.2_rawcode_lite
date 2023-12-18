@inlinable 
public func zip<Sequence1, Sequence2>(
  _ sequence1: Sequence1, _ sequence2: Sequence2
) -> Zip2Sequence<Sequence1, Sequence2> {
  return Zip2Sequence(sequence1, sequence2)
}
@frozen 
public struct Zip2Sequence<Sequence1: Sequence, Sequence2: Sequence> {
  @usableFromInline 
  internal let _sequence1: Sequence1
  @usableFromInline 
  internal let _sequence2: Sequence2
  @inlinable 
  internal init(_ sequence1: Sequence1, _ sequence2: Sequence2) {
    (_sequence1, _sequence2) = (sequence1, sequence2)
  }
}
extension Zip2Sequence {
  @frozen 
  public struct Iterator {
    @usableFromInline 
    internal var _baseStream1: Sequence1.Iterator
    @usableFromInline 
    internal var _baseStream2: Sequence2.Iterator
    @usableFromInline 
    internal var _reachedEnd: Bool = false
    @inlinable 
    internal init(
    _ iterator1: Sequence1.Iterator, 
    _ iterator2: Sequence2.Iterator
    ) {
      (_baseStream1, _baseStream2) = (iterator1, iterator2)
    }
  }
}
extension Zip2Sequence.Iterator: IteratorProtocol {
  public typealias Element = (Sequence1.Element, Sequence2.Element)
  @inlinable 
  public mutating func next() -> Element? {
    if _reachedEnd {
      return nil
    }
    guard let element1 = _baseStream1.next(),
          let element2 = _baseStream2.next() else {
      _reachedEnd = true
      return nil
    }
    return (element1, element2)
  }
}
extension Zip2Sequence: Sequence {
  public typealias Element = (Sequence1.Element, Sequence2.Element)
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(
      _sequence1.makeIterator(),
      _sequence2.makeIterator())
  }
  @inlinable 
  public var underestimatedCount: Int {
    return Swift.min(
      _sequence1.underestimatedCount,
      _sequence2.underestimatedCount
    )
  }
}
extension Zip2Sequence: Sendable where Sequence1: Sendable,
                                       Sequence2: Sendable { }
extension Zip2Sequence.Iterator: Sendable where Sequence1.Iterator: Sendable,
                                                Sequence2.Iterator: Sendable { }
