public protocol Strideable<Stride>: Comparable {
  associatedtype Stride: SignedNumeric, Comparable
  func distance(to other: Self) -> Stride
  func advanced(by n: Stride) -> Self
  static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self)
}
extension Strideable {
  @inlinable
  public static func < (x: Self, y: Self) -> Bool {
    return x.distance(to: y) > 0
  }
  @inlinable
  public static func == (x: Self, y: Self) -> Bool {
    return x.distance(to: y) == 0
  }
}
extension Strideable {
  @inlinable 
  public static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self) {
    return (nil, current.value.advanced(by: distance))
  }
}
extension Strideable where Self: FixedWidthInteger & SignedInteger {
  public static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self) {
    let value = current.value
    let (partialValue, overflow) =
      Self.bitWidth >= Self.Stride.bitWidth ||
        (value < (0 as Self)) == (distance < (0 as Self.Stride))
          ? value.addingReportingOverflow(Self(distance))
          : (Self(Self.Stride(value) + distance), false)
    return overflow
      ? (.min, distance < (0 as Self.Stride) ? .min : .max)
      : (nil, partialValue)
  }
}
extension Strideable where Self: FixedWidthInteger & UnsignedInteger {
  public static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self) {
    let (partialValue, overflow) = distance < (0 as Self.Stride)
      ? current.value.subtractingReportingOverflow(Self(-distance))
      : current.value.addingReportingOverflow(Self(distance))
    return overflow
      ? (.min, distance < (0 as Self.Stride) ? .min : .max)
      : (nil, partialValue)
  }
}
extension Strideable where Stride: FloatingPoint {
  @inlinable 
  public static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self) {
    if let i = current.index {
      return (i + 1, start.advanced(by: Stride(i + 1) * distance))
    }
    return (nil, current.value.advanced(by: distance))
  }
}
extension Strideable where Self: FloatingPoint, Self == Stride {
  @inlinable 
  public static func _step(
    after current: (index: Int?, value: Self),
    from start: Self, by distance: Self.Stride
  ) -> (index: Int?, value: Self) {
    if let i = current.index {
      return (i + 1, start.addingProduct(Stride(i + 1), distance))
    }
    return (nil, current.value.advanced(by: distance))
  }
}
@frozen
public struct StrideToIterator<Element: Strideable> {
  @usableFromInline
  internal let _start: Element
  @usableFromInline
  internal let _end: Element
  @usableFromInline
  internal let _stride: Element.Stride
  @usableFromInline
  internal var _current: (index: Int?, value: Element)
  @inlinable
  internal init(_start: Element, end: Element, stride: Element.Stride) {
    self._start = _start
    _end = end
    _stride = stride
    _current = (0, _start)
  }
}
extension StrideToIterator: IteratorProtocol {
  @inlinable
  public mutating func next() -> Element? {
    let result = _current.value
    if _stride > 0 ? result >= _end : result <= _end {
      return nil
    }
    _current = Element._step(after: _current, from: _start, by: _stride)
    return result
  }
}
@frozen
public struct StrideTo<Element: Strideable> {
  @usableFromInline
  internal let _start: Element
  @usableFromInline
  internal let _end: Element
  @usableFromInline
  internal let _stride: Element.Stride
  @inlinable
  internal init(_start: Element, end: Element, stride: Element.Stride) {
    _precondition(stride != 0, "Stride size must not be zero")
    self._start = _start
    self._end = end
    self._stride = stride
  }
}
extension StrideTo: Sequence {
  @inlinable
  public __consuming func makeIterator() -> StrideToIterator<Element> {
    return StrideToIterator(_start: _start, end: _end, stride: _stride)
  }
  @inlinable
  public var underestimatedCount: Int {
    var it = self.makeIterator()
    var count = 0
    while it.next() != nil {
      count += 1
    }
    return count
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    if _stride < 0 {
      if element <= _end || _start < element { return false }
    } else {
      if element < _start || _end <= element { return false }
    }
    return nil
  }
}
#if SWIFT_ENABLE_REFLECTION
extension StrideTo: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, children: ["from": _start, "to": _end, "by": _stride])
  }
}
#endif
#if false
extension StrideTo: RandomAccessCollection
where Element.Stride: BinaryInteger {
  public typealias Index = Int
  public typealias SubSequence = Slice<StrideTo<Element>>
  public typealias Indices = Range<Int>
  @inlinable
  public var startIndex: Index { return 0 }
  @inlinable
  public var endIndex: Index { return count }
  @inlinable
  public var count: Int {
    let distance = _start.distance(to: _end)
    guard distance != 0 && (distance < 0) == (_stride < 0) else { return 0 }
    return Int((distance - 1) / _stride) + 1
  }
  public subscript(position: Index) -> Element {
    _failEarlyRangeCheck(position, bounds: startIndex..<endIndex)
    return _start.advanced(by: Element.Stride(position) * _stride)
  }
  public subscript(bounds: Range<Index>) -> Slice<StrideTo<Element>> {
    _failEarlyRangeCheck(bounds, bounds: startIndex ..< endIndex)
    return Slice(base: self, bounds: bounds)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    _failEarlyRangeCheck(i, bounds: startIndex + 1...endIndex)
    return i - 1
  }
  @inlinable
  public func index(after i: Index) -> Index {
    _failEarlyRangeCheck(i, bounds: startIndex - 1..<endIndex)
    return i + 1
  }
}
#endif
@inlinable
public func stride<T>(
  from start: T, to end: T, by stride: T.Stride
) -> StrideTo<T> {
  return StrideTo(_start: start, end: end, stride: stride)
}
@frozen
public struct StrideThroughIterator<Element: Strideable> {
  @usableFromInline
  internal let _start: Element
  @usableFromInline
  internal let _end: Element
  @usableFromInline
  internal let _stride: Element.Stride
  @usableFromInline
  internal var _current: (index: Int?, value: Element)
  @usableFromInline
  internal var _didReturnEnd: Bool = false
  @inlinable
  internal init(_start: Element, end: Element, stride: Element.Stride) {
    self._start = _start
    _end = end
    _stride = stride
    _current = (0, _start)
  }
}
extension StrideThroughIterator: IteratorProtocol {
  @inlinable
  public mutating func next() -> Element? {
    let result = _current.value
    if _stride > 0 ? result >= _end : result <= _end {
      if result == _end && !_didReturnEnd && _current.index != .min {
        _didReturnEnd = true
        return result
      }
      return nil
    }
    _current = Element._step(after: _current, from: _start, by: _stride)
    return result
  }
}
@frozen
public struct StrideThrough<Element: Strideable> {
  @usableFromInline
  internal let _start: Element
  @usableFromInline
  internal let _end: Element
  @usableFromInline
  internal let _stride: Element.Stride
  @inlinable
  internal init(_start: Element, end: Element, stride: Element.Stride) {
    _precondition(stride != 0, "Stride size must not be zero")
    self._start = _start
    self._end = end
    self._stride = stride
  }
}
extension StrideThrough: Sequence {
  @inlinable
  public __consuming func makeIterator() -> StrideThroughIterator<Element> {
    return StrideThroughIterator(_start: _start, end: _end, stride: _stride)
  }
  @inlinable
  public var underestimatedCount: Int {
    var it = self.makeIterator()
    var count = 0
    while it.next() != nil {
      count += 1
    }
    return count
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    if _stride < 0 {
      if element < _end || _start < element { return false }
    } else {
      if element < _start || _end < element { return false }
    }
    return nil
  }
}
#if SWIFT_ENABLE_REFLECTION
extension StrideThrough: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self,
      children: ["from": _start, "through": _end, "by": _stride])
  }
}
#endif
#if false
extension StrideThrough: RandomAccessCollection
where Element.Stride: BinaryInteger {
  public typealias Index = ClosedRangeIndex<Int>
  public typealias SubSequence = Slice<StrideThrough<Element>>
  @inlinable
  public var startIndex: Index {
    let distance = _start.distance(to: _end)
    return distance == 0 || (distance < 0) == (_stride < 0)
      ? ClosedRangeIndex(0)
      : ClosedRangeIndex()
  }
  @inlinable
  public var endIndex: Index { return ClosedRangeIndex() }
  @inlinable
  public var count: Int {
    let distance = _start.distance(to: _end)
    guard distance != 0 else { return 1 }
    guard (distance < 0) == (_stride < 0) else { return 0 }
    return Int(distance / _stride) + 1
  }
  public subscript(position: Index) -> Element {
    let offset = Element.Stride(position._dereferenced) * _stride
    return _start.advanced(by: offset)
  }
  public subscript(bounds: Range<Index>) -> Slice<StrideThrough<Element>> {
    return Slice(base: self, bounds: bounds)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    switch i._value {
    case .inRange(let n):
      _precondition(n > 0, "Incrementing past start index")
      return ClosedRangeIndex(n - 1)
    case .pastEnd:
      _precondition(_end >= _start, "Incrementing past start index")
      return ClosedRangeIndex(count - 1)
    }
  }
  @inlinable
  public func index(after i: Index) -> Index {
    switch i._value {
    case .inRange(let n):
      return n == (count - 1)
        ? ClosedRangeIndex()
        : ClosedRangeIndex(n + 1)
    case .pastEnd:
      _preconditionFailure("Incrementing past end index")
    }
  }
}
#endif
@inlinable
public func stride<T>(
  from start: T, through end: T, by stride: T.Stride
) -> StrideThrough<T> {
  return StrideThrough(_start: start, end: end, stride: stride)
}
extension StrideToIterator: Sendable
  where Element: Sendable, Element.Stride: Sendable { }
extension StrideTo: Sendable
  where Element: Sendable, Element.Stride: Sendable { }
extension StrideThroughIterator: Sendable
  where Element: Sendable, Element.Stride: Sendable { }
extension StrideThrough: Sendable
  where Element: Sendable, Element.Stride: Sendable { }
