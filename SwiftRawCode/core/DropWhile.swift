@frozen 
public struct LazyDropWhileSequence<Base: Sequence> {
  public typealias Element = Base.Element
  @usableFromInline 
  internal var _base: Base
  @usableFromInline 
  internal let _predicate: (Element) -> Bool
  @inlinable 
  internal init(_base: Base, predicate: @escaping (Element) -> Bool) {
    self._base = _base
    self._predicate = predicate
  }
}
extension LazyDropWhileSequence {
  @frozen 
  public struct Iterator {
    public typealias Element = Base.Element
    @usableFromInline 
    internal var _predicateHasFailed = false
    @usableFromInline 
    internal var _base: Base.Iterator
    @usableFromInline 
    internal let _predicate: (Element) -> Bool
    @inlinable 
    internal init(_base: Base.Iterator, predicate: @escaping (Element) -> Bool) {
      self._base = _base
      self._predicate = predicate
    }
  }
}
extension LazyDropWhileSequence.Iterator: IteratorProtocol {
  @inlinable 
  public mutating func next() -> Element? {
    if _predicateHasFailed {
      return _base.next()
    }
    while let nextElement = _base.next() {
      if !_predicate(nextElement) {
        _predicateHasFailed = true
        return nextElement
      }
    }
    return nil
  }  
}
extension LazyDropWhileSequence: Sequence {
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base.makeIterator(), predicate: _predicate)
  }
}
extension LazyDropWhileSequence: LazySequenceProtocol {
  public typealias Elements = LazyDropWhileSequence
}
extension LazySequenceProtocol {
  @inlinable 
  public __consuming func drop(
    while predicate: @escaping (Elements.Element) -> Bool
  ) -> LazyDropWhileSequence<Self.Elements> {
    return LazyDropWhileSequence(_base: self.elements, predicate: predicate)
  }
}
public typealias LazyDropWhileCollection<T: Collection> = LazyDropWhileSequence<T>
extension LazyDropWhileCollection: Collection {
  public typealias SubSequence = Slice<LazyDropWhileCollection<Base>>
  public typealias Index = Base.Index
  @inlinable 
  public var startIndex: Index {
    var index = _base.startIndex
    while index != _base.endIndex && _predicate(_base[index]) {
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
    _precondition(i < _base.endIndex, "Can't advance past endIndex")
    return _base.index(after: i)
  }
  @inlinable 
  public subscript(position: Index) -> Element {
    return _base[position]
  }
}
extension LazyDropWhileCollection: BidirectionalCollection 
where Base: BidirectionalCollection {
  @inlinable 
  public func index(before i: Index) -> Index {
    _precondition(i > startIndex, "Can't move before startIndex")
    return _base.index(before: i)
  }
}
extension LazyDropWhileCollection: LazyCollectionProtocol { }
