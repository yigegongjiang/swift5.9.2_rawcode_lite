@frozen 
public struct CollectionOfOne<Element> {
  @usableFromInline 
  internal var _element: Element
  @inlinable 
  public init(_ element: Element) {
    self._element = element
  }
}
extension CollectionOfOne {
  @frozen 
  public struct Iterator {
    @usableFromInline 
    internal var _elements: Element?
    @inlinable 
    public 
    init(_elements: Element?) {
      self._elements = _elements
    }
  }
}
extension CollectionOfOne.Iterator: IteratorProtocol {
  @inlinable 
  public mutating func next() -> Element? {
    let result = _elements
    _elements = nil
    return result
  }
}
extension CollectionOfOne: RandomAccessCollection, MutableCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias SubSequence = Slice<CollectionOfOne<Element>>
  @inlinable 
  public var startIndex: Index {
    return 0
  }
  @inlinable 
  public var endIndex: Index {
    return 1
  }
  @inlinable 
  public func index(after i: Index) -> Index {
    _precondition(i == startIndex)
    return 1
  }
  @inlinable 
  public func index(before i: Index) -> Index {
    _precondition(i == endIndex)
    return 0
  }
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_elements: _element)
  }
  @inlinable 
  public subscript(position: Int) -> Element {
    _read {
      _precondition(position == 0, "Index out of range")
      yield _element
    }
    _modify {
      _precondition(position == 0, "Index out of range")
      yield &_element
    }
  }
  @inlinable 
  public subscript(bounds: Range<Int>) -> SubSequence {
    get {
      _failEarlyRangeCheck(bounds, bounds: 0..<1)
      return Slice(base: self, bounds: bounds)
    }
    set {
      _failEarlyRangeCheck(bounds, bounds: 0..<1)
      let n = newValue.count
      _precondition(bounds.count == n, "CollectionOfOne can't be resized")
      if n == 1 { self = newValue.base }
    }
  }
  @inlinable 
  public var count: Int {
    return 1
  }
}
extension CollectionOfOne: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "CollectionOfOne(\(String(reflecting: _element)))"
  }
}
#if SWIFT_ENABLE_REFLECTION
extension CollectionOfOne: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, children: ["element": _element])
  }
}
#endif
extension CollectionOfOne: Sendable where Element: Sendable { }
extension CollectionOfOne.Iterator: Sendable where Element: Sendable { }
