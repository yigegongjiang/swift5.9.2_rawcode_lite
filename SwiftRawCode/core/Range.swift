public protocol RangeExpression<Bound> {
  associatedtype Bound: Comparable
  func relative<C: Collection>(
    to collection: C
  ) -> Range<Bound> where C.Index == Bound
  func contains(_ element: Bound) -> Bool
}
extension RangeExpression {
  @inlinable
  public static func ~= (pattern: Self, value: Bound) -> Bool {
    return pattern.contains(value)
  }  
}
@frozen
public struct Range<Bound: Comparable> {
  public let lowerBound: Bound
  public let upperBound: Bound
  internal init(_uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
  }
  @inlinable
  public init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    _debugPrecondition(bounds.lower <= bounds.upper,
      "Range requires lowerBound <= upperBound")
    self.init(_uncheckedBounds: (lower: bounds.lower, upper: bounds.upper))
  }
  @inlinable
  public func contains(_ element: Bound) -> Bool {
    return lowerBound <= element && element < upperBound
  }
  @inlinable
  public var isEmpty: Bool {
    return lowerBound == upperBound
  }
}
extension Range: Sequence
where Bound: Strideable, Bound.Stride: SignedInteger {
  public typealias Element = Bound
  public typealias Iterator = IndexingIterator<Range<Bound>>
}
extension Range: Collection, BidirectionalCollection, RandomAccessCollection
where Bound: Strideable, Bound.Stride: SignedInteger
{
  public typealias Index = Bound
  public typealias Indices = Range<Bound>
  public typealias SubSequence = Range<Bound>
  @inlinable
  public var startIndex: Index { return lowerBound }
  @inlinable
  public var endIndex: Index { return upperBound }
  @inlinable
  @inline(__always)
  public func index(after i: Index) -> Index {
    _failEarlyRangeCheck(i, bounds: startIndex..<endIndex)
    return i.advanced(by: 1)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    _precondition(i > lowerBound)
    _precondition(i <= upperBound)
    return i.advanced(by: -1)
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    let r = i.advanced(by: numericCast(n))
    _precondition(r >= lowerBound)
    _precondition(r <= upperBound)
    return r
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return numericCast(start.distance(to: end))
  }
  @inlinable
  public subscript(bounds: Range<Index>) -> Range<Bound> {
    return bounds
  }
  @inlinable
  public var indices: Indices {
    return self
  }
  @inlinable
  public func _customContainsEquatableElement(_ element: Element) -> Bool? {
    return lowerBound <= element && element < upperBound
  }
  @inlinable
  public func _customIndexOfEquatableElement(_ element: Bound) -> Index?? {
    return lowerBound <= element && element < upperBound ? element : nil
  }
  @inlinable
  public func _customLastIndexOfEquatableElement(_ element: Bound) -> Index?? {
    return _customIndexOfEquatableElement(element)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    _debugPrecondition(self.contains(position), "Index out of range")
    return position
  }
}
extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  @inlinable 
  public init(_ other: ClosedRange<Bound>) {
    let upperBound = other.upperBound.advanced(by: 1)
    self.init(_uncheckedBounds: (lower: other.lowerBound, upper: upperBound))
  }
}
extension Range: RangeExpression {
  @inlinable 
  public func relative<C: Collection>(to collection: C) -> Range<Bound>
  where C.Index == Bound {
    self
  }
}
extension Range {
  @inlinable 
  @inline(__always)
  public func clamped(to limits: Range) -> Range {
    let lower =         
      limits.lowerBound > self.lowerBound ? limits.lowerBound
          : limits.upperBound < self.lowerBound ? limits.upperBound
          : self.lowerBound
    let upper =
      limits.upperBound < self.upperBound ? limits.upperBound
          : limits.lowerBound > self.upperBound ? limits.lowerBound
          : self.upperBound
    return Range(_uncheckedBounds: (lower: lower, upper: upper))
  }
}
extension Range: CustomStringConvertible {
  @inlinable 
  public var description: String {
    return "\(lowerBound)..<\(upperBound)"
  }
}
extension Range: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "Range(\(String(reflecting: lowerBound))"
    + "..<\(String(reflecting: upperBound)))"
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Range: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self, children: ["lowerBound": lowerBound, "upperBound": upperBound])
  }
}
#endif
extension Range: Equatable {
  @inlinable
  public static func == (lhs: Range<Bound>, rhs: Range<Bound>) -> Bool {
    return
      lhs.lowerBound == rhs.lowerBound &&
      lhs.upperBound == rhs.upperBound
  }
}
extension Range: Hashable where Bound: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(lowerBound)
    hasher.combine(upperBound)
  }
}
extension Range: Decodable where Bound: Decodable {
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    let lowerBound = try container.decode(Bound.self)
    let upperBound = try container.decode(Bound.self)
    guard lowerBound <= upperBound else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Range.self) with a lowerBound (\(lowerBound)) greater than upperBound (\(upperBound))"))
    }
    self.init(_uncheckedBounds: (lower: lowerBound, upper: upperBound))
  }
}
extension Range: Encodable where Bound: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.lowerBound)
    try container.encode(self.upperBound)
  }
}
@frozen
public struct PartialRangeUpTo<Bound: Comparable> {
  public let upperBound: Bound
  @inlinable 
  public init(_ upperBound: Bound) { self.upperBound = upperBound }
}
extension PartialRangeUpTo: RangeExpression {
  public func relative<C: Collection>(to collection: C) -> Range<Bound>
  where C.Index == Bound {
    return collection.startIndex..<self.upperBound
  }
  public func contains(_ element: Bound) -> Bool {
    return element < upperBound
  }
}
extension PartialRangeUpTo: Decodable where Bound: Decodable {
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    try self.init(container.decode(Bound.self))
  }
}
extension PartialRangeUpTo: Encodable where Bound: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.upperBound)
  }
}
@frozen
public struct PartialRangeThrough<Bound: Comparable> {  
  public let upperBound: Bound
  @inlinable 
  public init(_ upperBound: Bound) { self.upperBound = upperBound }
}
extension PartialRangeThrough: RangeExpression {
  public func relative<C: Collection>(to collection: C) -> Range<Bound>
  where C.Index == Bound {
    return collection.startIndex..<collection.index(after: self.upperBound)
  }
  public func contains(_ element: Bound) -> Bool {
    return element <= upperBound
  }
}
extension PartialRangeThrough: Decodable where Bound: Decodable {
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    try self.init(container.decode(Bound.self))
  }
}
extension PartialRangeThrough: Encodable where Bound: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.upperBound)
  }
}
@frozen
public struct PartialRangeFrom<Bound: Comparable> {
  public let lowerBound: Bound
  @inlinable 
  public init(_ lowerBound: Bound) { self.lowerBound = lowerBound }
}
extension PartialRangeFrom: RangeExpression {
  public func relative<C: Collection>(
    to collection: C
  ) -> Range<Bound> where C.Index == Bound {
    return self.lowerBound..<collection.endIndex
  }
  @inlinable 
  public func contains(_ element: Bound) -> Bool {
    return lowerBound <= element
  }
}
extension PartialRangeFrom: Sequence
  where Bound: Strideable, Bound.Stride: SignedInteger
{
  public typealias Element = Bound
  @frozen
  public struct Iterator: IteratorProtocol {
    @usableFromInline
    internal var _current: Bound
    @inlinable
    public init(_current: Bound) { self._current = _current }
    @inlinable
    public mutating func next() -> Bound? {
      defer { _current = _current.advanced(by: 1) }
      return _current
    }
  }
  @inlinable
  public __consuming func makeIterator() -> Iterator { 
    return Iterator(_current: lowerBound) 
  }
}
extension PartialRangeFrom: Decodable where Bound: Decodable {
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    try self.init(container.decode(Bound.self))
  }
}
extension PartialRangeFrom: Encodable where Bound: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.lowerBound)
  }
}
extension Comparable {
  public static func ..< (minimum: Self, maximum: Self) -> Range<Self> {
    _precondition(minimum <= maximum,
      "Range requires lowerBound <= upperBound")
    return Range(_uncheckedBounds: (lower: minimum, upper: maximum))
  }
  public static prefix func ..< (maximum: Self) -> PartialRangeUpTo<Self> {
    _precondition(maximum == maximum,
      "Range cannot have an unordered upper bound.")
    return PartialRangeUpTo(maximum)
  }
  public static prefix func ... (maximum: Self) -> PartialRangeThrough<Self> {
    _precondition(maximum == maximum,
      "Range cannot have an unordered upper bound.")
    return PartialRangeThrough(maximum)
  }
  public static postfix func ... (minimum: Self) -> PartialRangeFrom<Self> {
    _precondition(minimum == minimum,
      "Range cannot have an unordered lower bound.")
    return PartialRangeFrom(minimum)
  }
}
@frozen 
public enum UnboundedRange_ {
  public static postfix func ... (_: UnboundedRange_) -> () {
  }
}
public typealias UnboundedRange = (UnboundedRange_)->()
extension Collection {
  @inlinable
  public subscript<R: RangeExpression>(r: R)
  -> SubSequence where R.Bound == Index {
    return self[r.relative(to: self)]
  }
  @inlinable
  public subscript(x: UnboundedRange) -> SubSequence {
    return self[startIndex...]
  }
}
extension MutableCollection {
  @inlinable
  public subscript<R: RangeExpression>(r: R) -> SubSequence
  where R.Bound == Index {
    get {
      return self[r.relative(to: self)]
    }
    set {
      self[r.relative(to: self)] = newValue
    }
  }
  @inlinable
  public subscript(x: UnboundedRange) -> SubSequence {
    get {
      return self[startIndex...]
    }
    set {
      self[startIndex...] = newValue
    }
  }
}
extension Range {
  @inlinable
  public func overlaps(_ other: Range<Bound>) -> Bool {
    let isDisjoint = other.upperBound <= self.lowerBound
      || self.upperBound <= other.lowerBound
      || self.isEmpty || other.isEmpty
    return !isDisjoint
  }
  @inlinable
  public func overlaps(_ other: ClosedRange<Bound>) -> Bool {
    let isDisjoint = other.upperBound < self.lowerBound
      || self.upperBound <= other.lowerBound
      || self.isEmpty
    return !isDisjoint
  }
}
public typealias CountableRange<Bound: Strideable> = Range<Bound>
  where Bound.Stride: SignedInteger
public typealias CountablePartialRangeFrom<Bound: Strideable> = PartialRangeFrom<Bound>
  where Bound.Stride: SignedInteger
extension Range: Sendable where Bound: Sendable { }
extension PartialRangeUpTo: Sendable where Bound: Sendable { }
extension PartialRangeThrough: Sendable where Bound: Sendable { }
extension PartialRangeFrom: Sendable where Bound: Sendable { }
extension PartialRangeFrom.Iterator: Sendable where Bound: Sendable { }
extension Range where Bound == String.Index {
  internal var _encodedOffsetRange: Range<Int> {
    _internalInvariant(
      (lowerBound._canBeUTF8 && upperBound._canBeUTF8)
      || (lowerBound._canBeUTF16 && upperBound._canBeUTF16))
    return Range<Int>(
      _uncheckedBounds: (lowerBound._encodedOffset, upperBound._encodedOffset))
  }
}
