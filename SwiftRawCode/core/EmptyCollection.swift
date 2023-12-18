@frozen 
public struct EmptyCollection<Element> {
  @inlinable 
  public init() {}
}
extension EmptyCollection {
  @frozen 
  public struct Iterator {
    @inlinable 
    public init() {}
  }  
}
extension EmptyCollection.Iterator: IteratorProtocol, Sequence {
  @inlinable 
  public mutating func next() -> Element? {
    return nil
  }
}
extension EmptyCollection: Sequence {
  @inlinable 
  public func makeIterator() -> Iterator {
    return Iterator()
  }
}
extension EmptyCollection: RandomAccessCollection, MutableCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias SubSequence = EmptyCollection<Element>
  @inlinable 
  public var startIndex: Index {
    return 0
  }
  @inlinable 
  public var endIndex: Index {
    return 0
  }
  @inlinable 
  public func index(after i: Index) -> Index {
    _preconditionFailure("EmptyCollection can't advance indices")
  }
  @inlinable 
  public func index(before i: Index) -> Index {
    _preconditionFailure("EmptyCollection can't advance indices")
  }
  @inlinable 
  public subscript(position: Index) -> Element {
    get {
      _preconditionFailure("Index out of range")
    }
    set {
      _preconditionFailure("Index out of range")
    }
  }
  @inlinable 
  public subscript(bounds: Range<Index>) -> SubSequence {
    get {
      _debugPrecondition(bounds.lowerBound == 0 && bounds.upperBound == 0,
        "Index out of range")
      return self
    }
    set {
      _debugPrecondition(bounds.lowerBound == 0 && bounds.upperBound == 0,
        "Index out of range")
    }
  }
  @inlinable 
  public var count: Int {
    return 0
  }
  @inlinable 
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    _debugPrecondition(i == startIndex && n == 0, "Index out of range")
    return i
  }
  @inlinable 
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    _debugPrecondition(i == startIndex && limit == startIndex,
      "Index out of range")
    return n == 0 ? i : nil
  }
  @inlinable 
  public func distance(from start: Index, to end: Index) -> Int {
    _debugPrecondition(start == 0, "From must be startIndex (or endIndex)")
    _debugPrecondition(end == 0, "To must be endIndex (or startIndex)")
    return 0
  }
  @inlinable 
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    _debugPrecondition(index == 0, "out of bounds")
    _debugPrecondition(bounds == indices, "invalid bounds for an empty collection")
  }
  @inlinable 
  public func _failEarlyRangeCheck(
    _ range: Range<Index>, bounds: Range<Index>
  ) {
    _debugPrecondition(range == indices, "invalid range for an empty collection")
    _debugPrecondition(bounds == indices, "invalid bounds for an empty collection")
  }
}
extension EmptyCollection: Equatable {
  @inlinable 
  public static func == (
    lhs: EmptyCollection<Element>, rhs: EmptyCollection<Element>
  ) -> Bool {
    return true
  }
}
extension EmptyCollection: Sendable { }
extension EmptyCollection.Iterator: Sendable { }
