@frozen 
public struct FlattenSequence<Base: Sequence> where Base.Element: Sequence {
  @usableFromInline 
  internal var _base: Base
  @inlinable 
  internal init(_base: Base) {
    self._base = _base
  }
}
extension FlattenSequence {
  @frozen 
  public struct Iterator {
    @usableFromInline 
    internal var _base: Base.Iterator
    @usableFromInline 
    internal var _inner: Base.Element.Iterator?
    @inlinable 
    internal init(_base: Base.Iterator) {
      self._base = _base
    }
  }
}
extension FlattenSequence.Iterator: IteratorProtocol {
  public typealias Element = Base.Element.Element
  @inlinable 
  public mutating func next() -> Element? {
    repeat {
      if _fastPath(_inner != nil) {
        let ret = _inner!.next()
        if _fastPath(ret != nil) {
          return ret
        }
      }
      let s = _base.next()
      if _slowPath(s == nil) {
        return nil
      }
      _inner = s!.makeIterator()
    }
    while true
  }
}
extension FlattenSequence.Iterator: Sequence { }
extension FlattenSequence: Sequence {
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base.makeIterator())
  }
}
extension Sequence where Element: Sequence {
  @inlinable 
  public __consuming func joined() -> FlattenSequence<Self> {
    return FlattenSequence(_base: self)
  }
}
extension LazySequenceProtocol where Element: Sequence {
  @inlinable 
  public __consuming func joined() -> LazySequence<FlattenSequence<Elements>> {
    return FlattenSequence(_base: elements).lazy
  }
}
public typealias FlattenCollection<T: Collection> = FlattenSequence<T> where T.Element: Collection
extension FlattenSequence where Base: Collection, Base.Element: Collection {
  @frozen 
  public struct Index {
    @usableFromInline 
    internal let _outer: Base.Index
    @usableFromInline 
    internal let _inner: Base.Element.Index?
    @inlinable 
    internal init(_ _outer: Base.Index, _ inner: Base.Element.Index?) {
      self._outer = _outer
      self._inner = inner
    }
  }
}
extension FlattenSequence.Index: Equatable where Base: Collection, Base.Element: Collection {
  @inlinable 
  public static func == (
    lhs: FlattenCollection<Base>.Index,
    rhs: FlattenCollection<Base>.Index
  ) -> Bool {
    return lhs._outer == rhs._outer && lhs._inner == rhs._inner
  }
}
extension FlattenSequence.Index: Comparable where Base: Collection, Base.Element: Collection {
  @inlinable 
  public static func < (
    lhs: FlattenCollection<Base>.Index,
    rhs: FlattenCollection<Base>.Index
  ) -> Bool {
    if lhs._outer != rhs._outer {
      return lhs._outer < rhs._outer
    }
    if let lhsInner = lhs._inner, let rhsInner = rhs._inner {
      return lhsInner < rhsInner
    }
    _precondition(lhs._inner == nil && rhs._inner == nil)
    return false
  }
}
extension FlattenSequence.Index: Hashable
  where Base: Collection, Base.Element: Collection, Base.Index: Hashable, Base.Element.Index: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(_outer)
    hasher.combine(_inner)
  }
}
extension FlattenCollection: Collection {
  @inlinable 
  public var startIndex: Index {
    let end = _base.endIndex
    var outer = _base.startIndex
    while outer != end {
      let innerCollection = _base[outer]
      if !innerCollection.isEmpty {
        return Index(outer, innerCollection.startIndex)
      }
      _base.formIndex(after: &outer)
    }
    return endIndex
  }
  @inlinable 
  public var endIndex: Index {
    return Index(_base.endIndex, nil)
  }
  @inlinable 
  internal func _index(after i: Index) -> Index {
    let innerCollection = _base[i._outer]
    let nextInner = innerCollection.index(after: i._inner!)
    if _fastPath(nextInner != innerCollection.endIndex) {
      return Index(i._outer, nextInner)
    }
    var nextOuter = _base.index(after: i._outer)
    while nextOuter != _base.endIndex {
      let nextInnerCollection = _base[nextOuter]
      if !nextInnerCollection.isEmpty {
        return Index(nextOuter, nextInnerCollection.startIndex)
      }
      _base.formIndex(after: &nextOuter)
    }
    return endIndex
  }
  @inlinable 
  internal func _index(before i: Index) -> Index {
    var prevOuter = i._outer
    if prevOuter == _base.endIndex {
      prevOuter = _base.index(prevOuter, offsetBy: -1)
    }
    var prevInnerCollection = _base[prevOuter]
    var prevInner = i._inner ?? prevInnerCollection.endIndex
    while prevInner == prevInnerCollection.startIndex {
      prevOuter = _base.index(prevOuter, offsetBy: -1)
      prevInnerCollection = _base[prevOuter]
      prevInner = prevInnerCollection.endIndex
    }
    return Index(prevOuter, prevInnerCollection.index(prevInner, offsetBy: -1))
  }
  @inlinable 
  public func index(after i: Index) -> Index {
    return _index(after: i)
  }
  @inlinable 
  public func formIndex(after i: inout Index) {
    i = index(after: i)
  }
  @inlinable 
  public func distance(from start: Index, to end: Index) -> Int {
    if end < start {
      _ = _base.distance(from: _base.endIndex, to: _base.startIndex)
    }
    var _start: Index
    let _end: Index
    let step: Int
    if start > end {
      _start = end
      _end = start
      step = -1
    }
    else {
      _start = start
      _end = end
      step = 1
    }
    var count = 0
    while _start != _end {
      count += step
      formIndex(after: &_start)
    }
    return count
  }
  @inline(__always)
  @inlinable 
  internal func _advanceIndex(_ i: inout Index, step: Int) {
    _internalInvariant(-1...1 ~= step, "step should be within the -1...1 range")
    i = step < 0 ? _index(before: i) : _index(after: i)
  }
  @inline(__always)
  @inlinable 
  internal func _ensureBidirectional(step: Int) {
    if step < 0 {
      _ = _base.index(
        _base.endIndex, offsetBy: step, limitedBy: _base.startIndex)
    }
  }
  @inlinable 
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    var i = i
    let step = n.signum()
    _ensureBidirectional(step: step)
    for _ in 0 ..< abs(n) {
      _advanceIndex(&i, step: step)
    }
    return i
  }
  @inlinable 
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    i = index(i, offsetBy: n)
  }
  @inlinable 
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    var i = i
    let step = n.signum()
    _ensureBidirectional(step: step)
    for _ in 0 ..< abs(n) {
      if i == limit {
        return nil
      }
      _advanceIndex(&i, step: step)
    }
    return i
  }
  @inlinable 
  public func formIndex(
    _ i: inout Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Bool {
    if let advancedIndex = index(i, offsetBy: n, limitedBy: limit) {
      i = advancedIndex
      return true
    }
    i = limit
    return false
  }
  @inlinable 
  public subscript(position: Index) -> Base.Element.Element {
    return _base[position._outer][position._inner!]
  }
  @inlinable 
  public subscript(bounds: Range<Index>) -> Slice<FlattenCollection<Base>> {
    return Slice(base: self, bounds: bounds)
  }
}
extension FlattenCollection: BidirectionalCollection
  where Base: BidirectionalCollection, Base.Element: BidirectionalCollection {
  @inlinable 
  public func index(before i: Index) -> Index {
    return _index(before: i)
  }
  @inlinable 
  public func formIndex(before i: inout Index) {
    i = index(before: i)
  }
}
