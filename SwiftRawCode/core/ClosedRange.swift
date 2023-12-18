@frozen
public struct ClosedRange<Bound: Comparable> {
  public let lowerBound: Bound
  public let upperBound: Bound
  internal init(_uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    self.lowerBound = bounds.lower
    self.upperBound = bounds.upper
  }
  @inlinable
  public init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
    _debugPrecondition(bounds.lower <= bounds.upper,
      "ClosedRange requires lowerBound <= upperBound")
    self.init(_uncheckedBounds: (lower: bounds.lower, upper: bounds.upper))
  }
}
extension ClosedRange {
  @inlinable
  public var isEmpty: Bool {
    return false
  }
}
extension ClosedRange: RangeExpression {
  @inlinable 
  public func relative<C: Collection>(to collection: C) -> Range<Bound>
  where C.Index == Bound {
    return Range(
      _uncheckedBounds: (
        lower: lowerBound,
        upper: collection.index(after: self.upperBound)))
  }
  @inlinable
  public func contains(_ element: Bound) -> Bool {
    return element >= self.lowerBound && element <= self.upperBound
  }
}
extension ClosedRange: Sequence
where Bound: Strideable, Bound.Stride: SignedInteger {
  public typealias Element = Bound
  public typealias Iterator = IndexingIterator<ClosedRange<Bound>>
}
extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
  @frozen 
  public enum Index {
    case pastEnd
    case inRange(Bound)
  }
}
extension ClosedRange.Index: Comparable {
  @inlinable
  public static func == (
    lhs: ClosedRange<Bound>.Index,
    rhs: ClosedRange<Bound>.Index
  ) -> Bool {
    switch (lhs, rhs) {
    case (.inRange(let l), .inRange(let r)):
      return l == r
    case (.pastEnd, .pastEnd):
      return true
    default:
      return false
    }
  }
  @inlinable
  public static func < (
    lhs: ClosedRange<Bound>.Index,
    rhs: ClosedRange<Bound>.Index
  ) -> Bool {
    switch (lhs, rhs) {
    case (.inRange(let l), .inRange(let r)):
      return l < r
    case (.inRange, .pastEnd):
      return true
    default:
      return false
    }
  }
}
extension ClosedRange.Index: Hashable
where Bound: Strideable, Bound.Stride: SignedInteger, Bound: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .inRange(let value):
      hasher.combine(0 as Int8)
      hasher.combine(value)
    case .pastEnd:
      hasher.combine(1 as Int8)
    }
  }
}
extension ClosedRange: Collection, BidirectionalCollection, RandomAccessCollection
where Bound: Strideable, Bound.Stride: SignedInteger
{
  public typealias SubSequence = Slice<ClosedRange<Bound>>
  @inlinable
  public var startIndex: Index {
    return .inRange(lowerBound)
  }
  @inlinable
  public var endIndex: Index {
    return .pastEnd
  }
  @inlinable
  public func index(after i: Index) -> Index {
    switch i {
    case .inRange(let x):
      return x == upperBound
        ? .pastEnd
        : .inRange(x.advanced(by: 1))
    case .pastEnd: 
      _preconditionFailure("Incrementing past end index")
    }
  }
  @inlinable
  public func index(before i: Index) -> Index {
    switch i {
    case .inRange(let x):
      _precondition(x > lowerBound, "Incrementing past start index")
      return .inRange(x.advanced(by: -1))
    case .pastEnd: 
      _precondition(upperBound >= lowerBound, "Incrementing past start index")
      return .inRange(upperBound)
    }
  }
  @inlinable
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    switch i {
    case .inRange(let x):
      let d = x.distance(to: upperBound)
      if distance <= d {
        let newPosition = x.advanced(by: numericCast(distance))
        _precondition(newPosition >= lowerBound,
          "Advancing past start index")
        return .inRange(newPosition)
      }
      if d - -1 == distance { return .pastEnd }
      _preconditionFailure("Advancing past end index")
    case .pastEnd:
      if distance == 0 {
        return i
      } 
      if distance < 0 {
        return index(.inRange(upperBound), offsetBy: numericCast(distance + 1))
      }
      _preconditionFailure("Advancing past end index")
    }
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    switch (start, end) {
    case let (.inRange(left), .inRange(right)):
      return numericCast(left.distance(to: right))
    case let (.inRange(left), .pastEnd):
      return numericCast(1 + left.distance(to: upperBound))
    case let (.pastEnd, .inRange(right)):
      return numericCast(upperBound.distance(to: right) - 1)
    case (.pastEnd, .pastEnd):
      return 0
    }
  }
  @inlinable
  public subscript(position: Index) -> Bound {
    switch position {
    case .inRange(let x): return x
    case .pastEnd: _preconditionFailure("Index out of range")
    }
  }
  @inlinable
  public subscript(bounds: Range<Index>)
    -> Slice<ClosedRange<Bound>> {
    return Slice(base: self, bounds: bounds)
  }
  @inlinable
  public func _customContainsEquatableElement(_ element: Bound) -> Bool? {
    return lowerBound <= element && element <= upperBound
  }
  @inlinable
  public func _customIndexOfEquatableElement(_ element: Bound) -> Index?? {
    return lowerBound <= element && element <= upperBound
              ? .inRange(element) : nil
  }
  @inlinable
  public func _customLastIndexOfEquatableElement(_ element: Bound) -> Index?? {
    return _customIndexOfEquatableElement(element)
  }
}
extension Comparable {  
  public static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self> {
    _precondition(
      minimum <= maximum, "Range requires lowerBound <= upperBound")
    return ClosedRange(_uncheckedBounds: (lower: minimum, upper: maximum))
  }
}
extension ClosedRange: Equatable {
  @inlinable
  public static func == (
    lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>
  ) -> Bool {
    return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound
  }
}
extension ClosedRange: Hashable where Bound: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(lowerBound)
    hasher.combine(upperBound)
  }
}
extension ClosedRange: CustomStringConvertible {
  @inlinable 
  public var description: String {
    return "\(lowerBound)...\(upperBound)"
  }
}
extension ClosedRange: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "ClosedRange(\(String(reflecting: lowerBound))"
    + "...\(String(reflecting: upperBound)))"
  }
}
#if SWIFT_ENABLE_REFLECTION
extension ClosedRange: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self, children: ["lowerBound": lowerBound, "upperBound": upperBound])
  }
}
#endif
extension ClosedRange {
  @inlinable 
  @inline(__always)
  public func clamped(to limits: ClosedRange) -> ClosedRange {
    let lower =         
      limits.lowerBound > self.lowerBound ? limits.lowerBound
          : limits.upperBound < self.lowerBound ? limits.upperBound
          : self.lowerBound
    let upper =
      limits.upperBound < self.upperBound ? limits.upperBound
          : limits.lowerBound > self.upperBound ? limits.lowerBound
          : self.upperBound
    return ClosedRange(_uncheckedBounds: (lower: lower, upper: upper))
  }
}
extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
  @inlinable
  public init(_ other: Range<Bound>) {
    _precondition(!other.isEmpty, "Can't form an empty closed range")
    let upperBound = other.upperBound.advanced(by: -1)
    self.init(_uncheckedBounds: (lower: other.lowerBound, upper: upperBound))
  }
}
extension ClosedRange {
  @inlinable
  public func overlaps(_ other: ClosedRange<Bound>) -> Bool {
    let isDisjoint = other.upperBound < self.lowerBound
      || self.upperBound < other.lowerBound
    return !isDisjoint
  }
  @inlinable
  public func overlaps(_ other: Range<Bound>) -> Bool {
    return other.overlaps(self)
  }
}
public typealias CountableClosedRange<Bound: Strideable> = ClosedRange<Bound>
  where Bound.Stride: SignedInteger
extension ClosedRange: Decodable where Bound: Decodable {
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    let lowerBound = try container.decode(Bound.self)
    let upperBound = try container.decode(Bound.self)
    guard lowerBound <= upperBound else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(ClosedRange.self) with a lowerBound (\(lowerBound)) greater than upperBound (\(upperBound))"))
    }
    self.init(_uncheckedBounds: (lower: lowerBound, upper: upperBound))
  }
}
extension ClosedRange: Encodable where Bound: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(self.lowerBound)
    try container.encode(self.upperBound)
  }
}
extension ClosedRange: Sendable where Bound: Sendable { }
extension ClosedRange.Index: Sendable where Bound: Sendable { }
