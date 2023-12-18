@frozen 
public struct LazyPrefixWhileSequence<Base: Sequence> {
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
extension LazyPrefixWhileSequence {
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
extension LazyPrefixWhileSequence.Iterator: IteratorProtocol, Sequence {
  @inlinable 
  public mutating func next() -> Element? {
    if !_predicateHasFailed, let nextElement = _base.next() {
      if _predicate(nextElement) {
        return nextElement
      } else {
        _predicateHasFailed = true
      }
    }
    return nil
  }
}
extension LazyPrefixWhileSequence: Sequence {
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base.makeIterator(), predicate: _predicate)
  }
}
extension LazyPrefixWhileSequence: LazySequenceProtocol {
  public typealias Elements = LazyPrefixWhileSequence
}
extension LazySequenceProtocol {
  @inlinable 
  public __consuming func prefix(
    while predicate: @escaping (Elements.Element) -> Bool
  ) -> LazyPrefixWhileSequence<Self.Elements> {
    return LazyPrefixWhileSequence(_base: self.elements, predicate: predicate)
  }
}
public typealias LazyPrefixWhileCollection<T: Collection> = LazyPrefixWhileSequence<T>
extension LazyPrefixWhileCollection {
  @frozen 
  @usableFromInline
  internal enum _IndexRepresentation {
    case index(Base.Index)
    case pastEnd
  }
  @frozen 
  public struct Index {
    @usableFromInline 
    internal let _value: _IndexRepresentation
    @inlinable 
    internal init(_ i: Base.Index) {
      self._value = .index(i)
    }
    @inlinable 
    internal init(endOf: Base) {
      self._value = .pastEnd
    }
  }
}
extension LazyPrefixWhileSequence.Index: Comparable where Base: Collection {
  @inlinable 
  public static func == (
    lhs: LazyPrefixWhileCollection<Base>.Index, 
    rhs: LazyPrefixWhileCollection<Base>.Index
  ) -> Bool {
    switch (lhs._value, rhs._value) {
    case let (.index(l), .index(r)):
      return l == r
    case (.pastEnd, .pastEnd):
      return true
    case (.pastEnd, .index), (.index, .pastEnd):
      return false
    }
  }
  @inlinable 
  public static func < (
    lhs: LazyPrefixWhileCollection<Base>.Index, 
    rhs: LazyPrefixWhileCollection<Base>.Index
  ) -> Bool {
    switch (lhs._value, rhs._value) {
    case let (.index(l), .index(r)):
      return l < r
    case (.index, .pastEnd):
      return true
    case (.pastEnd, _):
      return false
    }
  }
}
extension LazyPrefixWhileSequence.Index: Hashable where Base.Index: Hashable, Base: Collection {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    switch _value {
    case .index(let value):
      hasher.combine(value)
    case .pastEnd:
      hasher.combine(Int.max)
    }
  }
}
extension LazyPrefixWhileCollection: Collection {
  public typealias SubSequence = Slice<LazyPrefixWhileCollection<Base>>
  @inlinable 
  public var startIndex: Index {
    return Index(_base.startIndex)
  }
  @inlinable 
  public var endIndex: Index {
    if let first = _base.first, _predicate(first) {
      return Index(endOf: _base)
    }
    return startIndex
  }
  @inlinable 
  public func index(after i: Index) -> Index {
    _precondition(i != endIndex, "Can't advance past endIndex")
    guard case .index(let i) = i._value else {
      _preconditionFailure("Invalid index passed to index(after:)")
    }
    let nextIndex = _base.index(after: i)
    guard nextIndex != _base.endIndex && _predicate(_base[nextIndex]) else {
      return Index(endOf: _base)
    }
    return Index(nextIndex)
  }
  @inlinable 
  public subscript(position: Index) -> Element {
    switch position._value {
    case .index(let i):
      return _base[i]
    case .pastEnd:
      _preconditionFailure("Index out of range")
    }
  }
}
extension LazyPrefixWhileCollection: LazyCollectionProtocol { }
extension LazyPrefixWhileCollection: BidirectionalCollection
where Base: BidirectionalCollection {
  @inlinable 
  public func index(before i: Index) -> Index {
    switch i._value {
    case .index(let i):
      _precondition(i != _base.startIndex, "Can't move before startIndex")
      return Index(_base.index(before: i))
    case .pastEnd:
      _internalInvariant(!_base.isEmpty)
      var result = _base.startIndex
      while true {
        let next = _base.index(after: result)
        if next == _base.endIndex || !_predicate(_base[next]) {
          break
        }
        result = next
      }
      return Index(result)
    }
  }
}
