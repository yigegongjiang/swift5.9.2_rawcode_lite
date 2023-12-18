@inlinable 
public func min<T: Comparable>(_ x: T, _ y: T) -> T {
  return y < x ? y : x
}
@inlinable 
public func min<T: Comparable>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T {
  var minValue = min(min(x, y), z)
  for value in rest where value < minValue {
    minValue = value
  }
  return minValue
}
@inlinable 
public func max<T: Comparable>(_ x: T, _ y: T) -> T {
  return y >= x ? y : x
}
@inlinable 
public func max<T: Comparable>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T {
  var maxValue = max(max(x, y), z)
  for value in rest where value >= maxValue {
    maxValue = value
  }
  return maxValue
}
@frozen
public struct EnumeratedSequence<Base: Sequence> {
  @usableFromInline
  internal var _base: Base
  @inlinable
  internal init(_base: Base) {
    self._base = _base
  }
}
extension EnumeratedSequence {
  @frozen
  public struct Iterator {
    @usableFromInline
    internal var _base: Base.Iterator
    @usableFromInline
    internal var _count: Int
    @inlinable
    internal init(_base: Base.Iterator) {
      self._base = _base
      self._count = 0
    }
  }
}
extension EnumeratedSequence.Iterator: IteratorProtocol, Sequence {
  public typealias Element = (offset: Int, element: Base.Element)
  @inlinable
  public mutating func next() -> Element? {
    guard let b = _base.next() else { return nil }
    let result = (offset: _count, element: b)
    _count += 1 
    return result
  }
}
extension EnumeratedSequence: Sequence {
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base: _base.makeIterator())
  }
}
