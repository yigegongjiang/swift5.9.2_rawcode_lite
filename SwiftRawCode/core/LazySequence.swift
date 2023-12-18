public protocol LazySequenceProtocol: Sequence {
  associatedtype Elements: Sequence = Self where Elements.Element == Element
  var elements: Elements { get }
}
extension LazySequenceProtocol where Elements == Self {
  @inlinable 
  public var elements: Self { return self }
}
extension LazySequenceProtocol {
  @inlinable 
  public var lazy: LazySequence<Elements> {
    return elements.lazy
  }
}
extension LazySequenceProtocol where Elements: LazySequenceProtocol {
  @inlinable 
  public var lazy: Elements {
    return elements
  }
}
@frozen 
public struct LazySequence<Base: Sequence> {
  @usableFromInline
  internal var _base: Base
  @inlinable 
  internal init(_base: Base) {
    self._base = _base
  }
}
extension LazySequence: Sequence {
  public typealias Element = Base.Element
  public typealias Iterator = Base.Iterator
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return _base.makeIterator()
  }
  @inlinable 
  public var underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable 
  @discardableResult
  public __consuming func _copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    return _base._copyContents(initializing: buf)
  }
  @inlinable 
  public func _customContainsEquatableElement(_ element: Element) -> Bool? { 
    return _base._customContainsEquatableElement(element)
  }
  @inlinable 
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
}
extension LazySequence: LazySequenceProtocol {
  public typealias Elements = Base
  @inlinable 
  public var elements: Elements { return _base }
}
extension Sequence {
  @inlinable 
  public var lazy: LazySequence<Self> {
    return LazySequence(_base: self)
  }
}
