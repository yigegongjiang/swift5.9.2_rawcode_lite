extension MutableCollection where Self: BidirectionalCollection {
  @inlinable 
  public mutating func reverse() {
    if isEmpty { return }
    var f = startIndex
    var l = index(before: endIndex)
    while f < l {
      swapAt(f, l)
      formIndex(after: &f)
      formIndex(before: &l)
    }
  }
}
@frozen
public struct ReversedCollection<Base: BidirectionalCollection> {
  public let _base: Base
  @inlinable
  internal init(_base: Base) {
    self._base = _base
  }
}
extension ReversedCollection {
  @frozen
  public struct Iterator {
    @usableFromInline
    internal let _base: Base
    @usableFromInline
    internal var _position: Base.Index
    @inlinable
    @inline(__always)
    public 
    init(_base: Base) {
      self._base = _base
      self._position = _base.endIndex
    }
  }
}
extension ReversedCollection.Iterator: IteratorProtocol, Sequence {
  public typealias Element = Base.Element
  @inlinable
  @inline(__always)
  public mutating func next() -> Element? {
    guard _fastPath(_position != _base.startIndex) else { return nil }
    _base.formIndex(before: &_position)
    return _base[_position]
  }
}
extension ReversedCollection: Sequence {
  public typealias Element = Base.Element
  @inlinable
  @inline(__always)
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base)
  }
}
extension ReversedCollection {
  @frozen
  public struct Index {
    public let base: Base.Index
    @inlinable
    public init(_ base: Base.Index) {
      self.base = base
    }
  }
}
extension ReversedCollection.Index: Comparable {
  @inlinable
  public static func == (
    lhs: ReversedCollection<Base>.Index,
    rhs: ReversedCollection<Base>.Index
  ) -> Bool {
    return lhs.base == rhs.base
  }
  @inlinable
  public static func < (
    lhs: ReversedCollection<Base>.Index,
    rhs: ReversedCollection<Base>.Index
  ) -> Bool {
    return lhs.base > rhs.base
  }
}
extension ReversedCollection.Index: Hashable where Base.Index: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(base)
  }
}
extension ReversedCollection: BidirectionalCollection {  
  @inlinable
  public var startIndex: Index {
    return Index(_base.endIndex)
  }
  @inlinable
  public var endIndex: Index {
    return Index(_base.startIndex)
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return Index(_base.index(before: i.base))
  }
  @inlinable
  public func index(before i: Index) -> Index {
    return Index(_base.index(after: i.base))
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return Index(_base.index(i.base, offsetBy: -n))
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _base.index(i.base, offsetBy: -n, limitedBy: limit.base)
                .map(Index.init)
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _base.distance(from: end.base, to: start.base)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    return _base[_base.index(before: position.base)]
  }
}
extension ReversedCollection: RandomAccessCollection where Base: RandomAccessCollection { }
extension ReversedCollection {
  @inlinable
  @available(swift, introduced: 4.2)
  public __consuming func reversed() -> Base {
    return _base
  }
}
extension BidirectionalCollection {
  @inlinable
  public __consuming func reversed() -> ReversedCollection<Self> {
    return ReversedCollection(_base: self)
  }
}
