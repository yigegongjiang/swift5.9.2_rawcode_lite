extension String: StringProtocol {}
extension String: RangeReplaceableCollection {
  public init(repeating repeatedValue: Character, count: Int) {
    self.init(repeating: repeatedValue._str, count: count)
  }
  public init<S: Sequence & LosslessStringConvertible>(_ other: S)
  where S.Element == Character {
    if let str = other as? String {
      self = str
      return
    }
    self = other.description
  }
  public init<S: Sequence>(_ characters: S)
  where S.Iterator.Element == Character {
    if let str = characters as? String {
      self = str
      return
    }
    if let subStr = characters as? Substring {
      self.init(subStr)
      return
    }
    self = ""
    self.append(contentsOf: characters)
  }
  public mutating func reserveCapacity(_ n: Int) {
    self._guts.reserveCapacity(n)
  }
  public mutating func append(_ other: String) {
    if self.isEmpty && !_guts.hasNativeStorage {
      self = other
      return
    }
    self._guts.append(other._guts)
  }
  public mutating func append(_ c: Character) {
    self.append(c._str)
  }
  public mutating func append(contentsOf newElements: String) {
    self.append(newElements)
  }
  public mutating func append(contentsOf newElements: Substring) {
    self._guts.append(newElements._gutsSlice)
  }
  public mutating func append<S: Sequence>(contentsOf newElements: S)
  where S.Iterator.Element == Character {
    if let str = newElements as? String {
      self.append(str)
      return
    }
    if let substr = newElements as? Substring {
      self.append(contentsOf: substr)
      return
    }
    for c in newElements {
      self.append(c._str)
    }
  }
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: C
  ) where C: Collection, C.Iterator.Element == Character {
    let subrange = _guts.validateScalarRange(subrange)
    _guts.replaceSubrange(subrange, with: newElements)
  }
  public mutating func insert(_ newElement: Character, at i: Index) {
    let i = _guts.validateInclusiveScalarIndex(i)
    let range = Range(_uncheckedBounds: (i, i))
    _guts.replaceSubrange(range, with: newElement._str)
  }
  public mutating func insert<S: Collection>(
    contentsOf newElements: S, at i: Index
  ) where S.Element == Character {
    let i = _guts.validateInclusiveScalarIndex(i)
    let range = Range(_uncheckedBounds: (i, i))
    _guts.replaceSubrange(range, with: newElements)
  }
  @discardableResult
  public mutating func remove(at i: Index) -> Character {
    let i = _guts.validateScalarIndex(i)
    let stride = _characterStride(startingAt: i)
    let j = Index(_encodedOffset: i._encodedOffset &+ stride)._scalarAligned
    let result = _guts.errorCorrectedCharacter(
      startingAt: i._encodedOffset, endingAt: j._encodedOffset)
    _guts.remove(from: i, to: j)
    return result
  }
  public mutating func removeSubrange(_ bounds: Range<Index>) {
    let bounds = _guts.validateScalarRange(bounds)
    _guts.remove(from: bounds.lowerBound, to: bounds.upperBound)
  }
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    guard keepCapacity else {
      self = ""
      return
    }
    _guts.clear()
  }
}
extension String {
  @available(*, deprecated,
    message: "Use one of the _StringGuts.validateScalarIndex methods")
  @usableFromInline 
  internal func _boundsCheck(_ index: Index) {
    _precondition(index._encodedOffset < _guts.count,
      "String index is out of bounds")
  }
  @available(*, deprecated,
    message: "Use one of the _StringGuts.validateScalarIndexRange methods")
  @usableFromInline 
  internal func _boundsCheck(_ range: Range<Index>) {
    _precondition(
      range.upperBound._encodedOffset <= _guts.count,
      "String index range is out of bounds")
  }
  @available(*, deprecated,
    message: "Use one of the _StringGuts.validateScalarIndex methods")
  @usableFromInline 
  internal func _boundsCheck(_ range: ClosedRange<Index>) {
    _precondition(
      range.upperBound._encodedOffset < _guts.count,
      "String index range is out of bounds")
  }
}
extension String {
  public func max<T: Comparable>(_ x: T, _ y: T) -> T {
    return Swift.max(x,y)
  }
  public func min<T: Comparable>(_ x: T, _ y: T) -> T {
    return Swift.min(x,y)
  }
}
extension Sequence where Element == String {
  @available(*, unavailable, message: "Operator '+' cannot be used to append a String to a sequence of strings")
  public static func + (lhs: Self, rhs: String) -> Never {
    fatalError()
  }
  @available(*, unavailable, message: "Operator '+' cannot be used to append a String to a sequence of strings")
  public static func + (lhs: String, rhs: Self) -> Never {
    fatalError()
  }
}
