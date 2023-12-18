@frozen 
public struct LazyFilterSequence<Base: Sequence> {
  @usableFromInline 
  internal var _base: Base
  @usableFromInline 
  internal let _predicate: (Base.Element) -> Bool
  @inlinable 
  public 
  init(_base base: Base, _ isIncluded: @escaping (Base.Element) -> Bool) {
    self._base = base
    self._predicate = isIncluded
  }
}
extension LazyFilterSequence {
  @frozen 
  public struct Iterator {
    public var base: Base.Iterator { return _base }
    @usableFromInline 
    internal var _base: Base.Iterator
    @usableFromInline 
    internal let _predicate: (Base.Element) -> Bool
    @inlinable 
    internal init(_base: Base.Iterator, _ isIncluded: @escaping (Base.Element) -> Bool) {
      self._base = _base
      self._predicate = isIncluded
    }
  }
}
extension LazyFilterSequence.Iterator: IteratorProtocol, Sequence {
  public typealias Element = Base.Element
  @inlinable 
  public mutating func next() -> Element? {
    while let n = _base.next() {
      if _predicate(n) {
        return n
      }
    }
    return nil
  }
}
extension LazyFilterSequence: Sequence {
  public typealias Element = Base.Element
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base.makeIterator(), _predicate)
  }
  @inlinable
  public func _customContainsEquatableElement(_ element: Element) -> Bool? {
    guard _predicate(element) else { return false }
    return _base._customContainsEquatableElement(element)
  }
}
extension LazyFilterSequence: LazySequenceProtocol { }
public typealias LazyFilterCollection<T: Collection> = LazyFilterSequence<T>
extension LazyFilterCollection: Collection {
  public typealias SubSequence = LazyFilterCollection<Base.SubSequence>
  @inlinable 
  public var underestimatedCount: Int { return 0 }
  public typealias Index = Base.Index
  @inlinable 
  public var startIndex: Index {
    var index = _base.startIndex
    while index != _base.endIndex && !_predicate(_base[index]) {
      _base.formIndex(after: &index)
    }
    return index
  }
  @inlinable 
  public var endIndex: Index {
    return _base.endIndex
  }
  @inlinable 
  public func index(after i: Index) -> Index {
    var i = i
    formIndex(after: &i)
    return i
  }
  @inlinable 
  public func formIndex(after i: inout Index) {
    var index = i
    _precondition(index != _base.endIndex, "Can't advance past endIndex")
    repeat {
      _base.formIndex(after: &index)
    } while index != _base.endIndex && !_predicate(_base[index])
    i = index
  }
  @inline(__always)
  @inlinable 
  internal func _advanceIndex(_ i: inout Index, step: Int) {
    repeat {
      _base.formIndex(&i, offsetBy: step)
    } while i != _base.endIndex && !_predicate(_base[i])
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
  public func distance(from start: Index, to end: Index) -> Int {
    _ = _base.distance(from: start, to: end)
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
  public subscript(position: Index) -> Element {
    return _base[position]
  }
  @inlinable 
  public subscript(bounds: Range<Index>) -> SubSequence {
    return SubSequence(_base: _base[bounds], _predicate)
  }
  @inlinable
  public func _customLastIndexOfEquatableElement(_ element: Element) -> Index?? {
    guard _predicate(element) else { return .some(nil) }
    return _base._customLastIndexOfEquatableElement(element)
  }
}
extension LazyFilterCollection: LazyCollectionProtocol { }
extension LazyFilterCollection: BidirectionalCollection
  where Base: BidirectionalCollection {
  @inlinable 
  public func index(before i: Index) -> Index {
    var i = i
    formIndex(before: &i)
    return i
  }
  @inlinable 
  public func formIndex(before i: inout Index) {
    var index = i
    _precondition(index != _base.startIndex, "Can't retreat before startIndex")
    repeat {
      _base.formIndex(before: &index)
    } while !_predicate(_base[index])
    i = index
  }
}
extension LazySequenceProtocol {
  @inlinable 
  public __consuming func filter(
    _ isIncluded: @escaping (Elements.Element) -> Bool
  ) -> LazyFilterSequence<Self.Elements> {
    return LazyFilterSequence(_base: self.elements, isIncluded)
  }
}
extension LazyFilterSequence {
  @available(swift, introduced: 5)
  public __consuming func filter(
    _ isIncluded: @escaping (Element) -> Bool
  ) -> LazyFilterSequence<Base> {
    return LazyFilterSequence(_base: _base) {
      self._predicate($0) && isIncluded($0)
    }
  }
}
