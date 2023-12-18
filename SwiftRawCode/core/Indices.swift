@frozen
public struct DefaultIndices<Elements: Collection> {
  @usableFromInline
  internal var _elements: Elements
  @usableFromInline
  internal var _startIndex: Elements.Index
  @usableFromInline
  internal var _endIndex: Elements.Index
  @inlinable
  internal init(
    _elements: Elements,
    startIndex: Elements.Index,
    endIndex: Elements.Index
  ) {
    self._elements = _elements
    self._startIndex = startIndex
    self._endIndex = endIndex
  }
}
extension DefaultIndices: Collection {
  public typealias Index = Elements.Index
  public typealias Element = Elements.Index
  public typealias Indices = DefaultIndices<Elements>
  public typealias SubSequence = DefaultIndices<Elements>
  public typealias Iterator = IndexingIterator<DefaultIndices<Elements>>
  @inlinable
  public var startIndex: Index {
    return _startIndex
  }
  @inlinable
  public var endIndex: Index {
    return _endIndex
  }
  @inlinable
  public subscript(i: Index) -> Elements.Index {
    return i
  }
  @inlinable
  public subscript(bounds: Range<Index>) -> DefaultIndices<Elements> {
    return DefaultIndices(
      _elements: _elements,
      startIndex: bounds.lowerBound,
      endIndex: bounds.upperBound)
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return _elements.index(after: i)
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    _elements.formIndex(after: &i)
  }
  @inlinable
  public var indices: Indices {
    return self
  }
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    return _elements.index(i, offsetBy: distance)
  }
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index? {
    return _elements.index(i, offsetBy: distance, limitedBy: limit)
  }
  public func distance(from start: Index, to end: Index) -> Int {
    return _elements.distance(from: start, to: end)
  }
}
extension DefaultIndices: BidirectionalCollection
where Elements: BidirectionalCollection {
  @inlinable
  public func index(before i: Index) -> Index {
    return _elements.index(before: i)
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    _elements.formIndex(before: &i)
  }
}
extension DefaultIndices: RandomAccessCollection
where Elements: RandomAccessCollection { }
extension Collection where Indices == DefaultIndices<Self> {
  @inlinable 
  public var indices: DefaultIndices<Self> {
    return DefaultIndices(
      _elements: self,
      startIndex: self.startIndex,
      endIndex: self.endIndex)
  }
}
extension DefaultIndices: Sendable
  where Elements: Sendable, Elements.Index: Sendable { }
