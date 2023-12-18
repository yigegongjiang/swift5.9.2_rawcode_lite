extension ExpressibleByIntegerLiteral
  where Self: _ExpressibleByBuiltinIntegerLiteral {
  public init(integerLiteral value: Self) {
    self = value
  }
}
public protocol AdditiveArithmetic: Equatable {
  static var zero: Self { get }
  static func +(lhs: Self, rhs: Self) -> Self
  static func +=(lhs: inout Self, rhs: Self)
  static func -(lhs: Self, rhs: Self) -> Self
  static func -=(lhs: inout Self, rhs: Self)
}
public extension AdditiveArithmetic {
  static func +=(lhs: inout Self, rhs: Self) {
    lhs = lhs + rhs
  }
  static func -=(lhs: inout Self, rhs: Self) {
    lhs = lhs - rhs
  }
}
public extension AdditiveArithmetic where Self: ExpressibleByIntegerLiteral {
  @inlinable @inline(__always)
  static var zero: Self {
    return 0
  }
}
public protocol Numeric: AdditiveArithmetic, ExpressibleByIntegerLiteral {
  init?<T: BinaryInteger>(exactly source: T)
  associatedtype Magnitude: Comparable, Numeric
  var magnitude: Magnitude { get }
  static func *(lhs: Self, rhs: Self) -> Self
  static func *=(lhs: inout Self, rhs: Self)
}
public protocol SignedNumeric: Numeric {
  static prefix func - (_ operand: Self) -> Self
  mutating func negate()
}
extension SignedNumeric {
  public static prefix func - (_ operand: Self) -> Self {
    var result = operand
    result.negate()
    return result
  }
  public mutating func negate() {
    self = 0 - self
  }
}
@inlinable
public func abs<T: SignedNumeric & Comparable>(_ x: T) -> T {
  if T.self == T.Magnitude.self {
    return unsafeBitCast(x.magnitude, to: T.self)
  }
  return x < (0 as T) ? -x : x
}
extension AdditiveArithmetic {
  public static prefix func + (x: Self) -> Self {
    return x
  }
}
public protocol BinaryInteger :
  Hashable, Numeric, CustomStringConvertible, Strideable
  where Magnitude: BinaryInteger, Magnitude.Magnitude == Magnitude
{
  static var isSigned: Bool { get }
  init?<T: BinaryFloatingPoint>(exactly source: T)
  init<T: BinaryFloatingPoint>(_ source: T)
  init<T: BinaryInteger>(_ source: T)
  init<T: BinaryInteger>(truncatingIfNeeded source: T)
  init<T: BinaryInteger>(clamping source: T)
  associatedtype Words: RandomAccessCollection
      where Words.Element == UInt, Words.Index == Int
  var words: Words { get }
  var _lowWord: UInt { get }
  var bitWidth: Int { get }
  func _binaryLogarithm() -> Int
  var trailingZeroBitCount: Int { get }
  static func /(lhs: Self, rhs: Self) -> Self
  static func /=(lhs: inout Self, rhs: Self)
  static func %(lhs: Self, rhs: Self) -> Self
  static func %=(lhs: inout Self, rhs: Self)
  override static func +(lhs: Self, rhs: Self) -> Self
  override static func +=(lhs: inout Self, rhs: Self)
  override static func -(lhs: Self, rhs: Self) -> Self
  override static func -=(lhs: inout Self, rhs: Self)
  override static func *(lhs: Self, rhs: Self) -> Self
  override static func *=(lhs: inout Self, rhs: Self)
  static prefix func ~ (_ x: Self) -> Self
  static func &(lhs: Self, rhs: Self) -> Self
  static func &=(lhs: inout Self, rhs: Self)
  static func |(lhs: Self, rhs: Self) -> Self
  static func |=(lhs: inout Self, rhs: Self)
  static func ^(lhs: Self, rhs: Self) -> Self
  static func ^=(lhs: inout Self, rhs: Self)
  static func >> <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self
  static func >>= <RHS: BinaryInteger>(lhs: inout Self, rhs: RHS)
  static func << <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self
  static func <<=<RHS: BinaryInteger>(lhs: inout Self, rhs: RHS)
  func quotientAndRemainder(dividingBy rhs: Self)
    -> (quotient: Self, remainder: Self)
  func isMultiple(of other: Self) -> Bool
  func signum() -> Self
}
extension BinaryInteger {
  public init() {
    self = 0
  }
  @inlinable
  public func signum() -> Self {
    return (self > (0 as Self) ? 1 : 0) - (self < (0 as Self) ? 1 : 0)
  }
  public var _lowWord: UInt {
    var it = words.makeIterator()
    return it.next() ?? 0
  }
  @inlinable
  public func _binaryLogarithm() -> Int {
    _precondition(self > (0 as Self))
    var (quotient, remainder) =
      (bitWidth &- 1).quotientAndRemainder(dividingBy: UInt.bitWidth)
    remainder = remainder &+ 1
    var word = UInt(truncatingIfNeeded: self >> (bitWidth &- remainder))
    while word == 0 {
      quotient = quotient &- 1
      remainder = remainder &+ UInt.bitWidth
      word = UInt(truncatingIfNeeded: self >> (bitWidth &- remainder))
    }
    return UInt.bitWidth &* quotient &+
        (UInt.bitWidth &- (word.leadingZeroBitCount &+ 1))
  }
  @inlinable
  public func quotientAndRemainder(dividingBy rhs: Self)
    -> (quotient: Self, remainder: Self) {
    return (self / rhs, self % rhs)
  }
  @inlinable
  public func isMultiple(of other: Self) -> Bool {
    if other == 0 { return self == 0 }
    return self.magnitude % other.magnitude == 0
  }
  public static func & (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func | (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^ (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func >> <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self {
    var r = lhs
    r >>= rhs
    return r
  }
  public static func << <RHS: BinaryInteger>(lhs: Self, rhs: RHS) -> Self {
    var r = lhs
    r <<= rhs
    return r
  }
}
extension BinaryInteger {
  internal func _description(radix: Int, uppercase: Bool) -> String {
    _precondition(2...36 ~= radix, "Radix must be between 2 and 36")
    if bitWidth <= 64 {
      let radix_ = Int64(radix)
      return Self.isSigned
        ? _int64ToString(
          Int64(truncatingIfNeeded: self), radix: radix_, uppercase: uppercase)
        : _uint64ToString(
          UInt64(truncatingIfNeeded: self), radix: radix_, uppercase: uppercase)
    }
    if self == (0 as Self) { return "0" }
    let isRadixPowerOfTwo = radix.nonzeroBitCount == 1
    let radix_ = Magnitude(radix)
    func _quotientAndRemainder(_ value: Magnitude) -> (Magnitude, Magnitude) {
      return isRadixPowerOfTwo
        ? (value >> radix.trailingZeroBitCount, value & (radix_ - 1))
        : value.quotientAndRemainder(dividingBy: radix_)
    }
    let hasLetters = radix > 10
    func _ascii(_ digit: UInt8) -> UInt8 {
      let base: UInt8
      if !hasLetters || digit < 10 {
        base = UInt8(("0" as Unicode.Scalar).value)
      } else if uppercase {
        base = UInt8(("A" as Unicode.Scalar).value) &- 10
      } else {
        base = UInt8(("a" as Unicode.Scalar).value) &- 10
      }
      return base &+ digit
    }
    let isNegative = Self.isSigned && self < (0 as Self)
    var value = magnitude
    var result: [UInt8] = []
    while value != 0 {
      let (quotient, remainder) = _quotientAndRemainder(value)
      result.append(_ascii(UInt8(truncatingIfNeeded: remainder)))
      value = quotient
    }
    if isNegative {
      result.append(UInt8(("-" as Unicode.Scalar).value))
    }
    result.reverse()
    return result.withUnsafeBufferPointer {
      return String._fromASCII($0)
    }
  }
  public var description: String {
    return _description(radix: 10, uppercase: false)
  }
}
extension BinaryInteger {
  @inlinable
  @inline(__always)
  public func distance(to other: Self) -> Int {
    if !Self.isSigned {
      if self > other {
        if let result = Int(exactly: self - other) {
          return -result
        }
      } else {
        if let result = Int(exactly: other - self) {
          return result
        }
      }
    } else {
      let isNegative = self < (0 as Self)
      if isNegative == (other < (0 as Self)) {
        if let result = Int(exactly: other - self) {
          return result
        }
      } else {
        if let result = Int(exactly: self.magnitude + other.magnitude) {
          return isNegative ? result : -result
        }
      }
    }
    _preconditionFailure("Distance is not representable in Int")
  }
  @inlinable
  @inline(__always)
  public func advanced(by n: Int) -> Self {
    if !Self.isSigned {
      return n < (0 as Int)
        ? self - Self(-n)
        : self + Self(n)
    }
    if (self < (0 as Self)) == (n < (0 as Self)) {
      return self + Self(n)
    }
    return self.magnitude < n.magnitude
      ? Self(Int(self) + n)
      : self + Self(n)
  }
}
extension BinaryInteger {
  public static func == <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Bool {
    if Self.isSigned == Other.isSigned {
      return lhs.bitWidth >= rhs.bitWidth ?
        lhs == Self(truncatingIfNeeded: rhs) :
        Other(truncatingIfNeeded: lhs) == rhs
    }
    if Self.isSigned {    
      return lhs.bitWidth > rhs.bitWidth ? 
        lhs == Self(truncatingIfNeeded: rhs) :
        (lhs >= (0 as Self) && Other(truncatingIfNeeded: lhs) == rhs) 
    }
    return lhs.bitWidth < rhs.bitWidth ?
      Other(truncatingIfNeeded: lhs) == rhs :
      (rhs >= (0 as Other) && lhs == Self(truncatingIfNeeded: rhs))
  }
  public static func != <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Bool {
    return !(lhs == rhs)
  }
  public static func < <Other: BinaryInteger>(lhs: Self, rhs: Other) -> Bool {
    if Self.isSigned == Other.isSigned {
      return lhs.bitWidth >= rhs.bitWidth ?
        lhs < Self(truncatingIfNeeded: rhs) :
        Other(truncatingIfNeeded: lhs) < rhs
    }
    if Self.isSigned {
      return lhs.bitWidth > rhs.bitWidth ? 
        lhs < Self(truncatingIfNeeded: rhs) :
        (lhs < (0 as Self) || Other(truncatingIfNeeded: lhs) < rhs) 
    }
    return lhs.bitWidth < rhs.bitWidth ?
      Other(truncatingIfNeeded: lhs) < rhs :
      (rhs > (0 as Other) && lhs < Self(truncatingIfNeeded: rhs))
  }
  public static func <= <Other: BinaryInteger>(lhs: Self, rhs: Other) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= <Other: BinaryInteger>(lhs: Self, rhs: Other) -> Bool {
    return !(lhs < rhs)
  }
  public static func > <Other: BinaryInteger>(lhs: Self, rhs: Other) -> Bool {
    return rhs < lhs
  }
}
extension BinaryInteger {
  public static func != (lhs: Self, rhs: Self) -> Bool {
    return !(lhs == rhs)
  }
  public static func <= (lhs: Self, rhs: Self) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Self, rhs: Self) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Self, rhs: Self) -> Bool {
    return rhs < lhs
  }
}
public protocol FixedWidthInteger: BinaryInteger, LosslessStringConvertible
where Magnitude: FixedWidthInteger & UnsignedInteger,
      Stride: FixedWidthInteger & SignedInteger {
  static var bitWidth: Int { get }
  static var max: Self { get }
  static var min: Self { get }
  func addingReportingOverflow(
    _ rhs: Self
  ) -> (partialValue: Self, overflow: Bool)
  func subtractingReportingOverflow(
    _ rhs: Self
  ) -> (partialValue: Self, overflow: Bool)
  func multipliedReportingOverflow(
    by rhs: Self
  ) -> (partialValue: Self, overflow: Bool)
  func dividedReportingOverflow(
    by rhs: Self
  ) -> (partialValue: Self, overflow: Bool)
  func remainderReportingOverflow(
    dividingBy rhs: Self
  ) -> (partialValue: Self, overflow: Bool)
  func multipliedFullWidth(by other: Self) -> (high: Self, low: Self.Magnitude)
  func dividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude))
    -> (quotient: Self, remainder: Self)
  init(_truncatingBits bits: UInt)
  var nonzeroBitCount: Int { get }
  var leadingZeroBitCount: Int { get }
  init(bigEndian value: Self)
  init(littleEndian value: Self)
  var bigEndian: Self { get }
  var littleEndian: Self { get }
  var byteSwapped: Self { get }
  static func &>>(lhs: Self, rhs: Self) -> Self
  static func &>>=(lhs: inout Self, rhs: Self)
  static func &<<(lhs: Self, rhs: Self) -> Self
  static func &<<=(lhs: inout Self, rhs: Self)
}
extension FixedWidthInteger {
  @inlinable
  public var bitWidth: Int { return Self.bitWidth }
  @inlinable
  public func _binaryLogarithm() -> Int {
    _precondition(self > (0 as Self))
    return Self.bitWidth &- (leadingZeroBitCount &+ 1)
  }
  @inlinable
  public init(littleEndian value: Self) {
#if _endian(little)
    self = value
#else
    self = value.byteSwapped
#endif
  }
  @inlinable
  public init(bigEndian value: Self) {
#if _endian(big)
    self = value
#else
    self = value.byteSwapped
#endif
  }
  @inlinable
  public var littleEndian: Self {
#if _endian(little)
    return self
#else
    return byteSwapped
#endif
  }
  @inlinable
  public var bigEndian: Self {
#if _endian(big)
    return self
#else
    return byteSwapped
#endif
  }
  public func multipliedFullWidth(by other: Self) -> (high: Self, low: Magnitude) {
    func split<T: FixedWidthInteger>(_ x: T) -> (high: T, low: T.Magnitude) {
      let n = T.bitWidth/2
      return (x >> n, T.Magnitude(truncatingIfNeeded: x) & ((1 &<< n) &- 1))
    }
    let (x1, x0) = split(self)
    let (y1, y0) = split(other)
    let p00 = x0 &* y0
    let p01 = x1 &* Self(y0) &+ Self(split(p00).high)
    let p10 = Self(x0) &* y1 &+ Self(split(p01).low)
    let p11 = x1 &* y1 &+ split(p01).high &+ split(p10).high
    return (p11, split(p10).low << (bitWidth/2) | split(p00).low)
  }
  public static func &>> (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &>> <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Self {
    return lhs &>> Self(truncatingIfNeeded: rhs)
  }
  public static func &>>= <
    Other: BinaryInteger
  >(lhs: inout Self, rhs: Other) {
    lhs = lhs &>> rhs
  }
  public static func &<< (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func &<< <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Self {
    return lhs &<< Self(truncatingIfNeeded: rhs)
  }
  public static func &<<= <
    Other: BinaryInteger
  >(lhs: inout Self, rhs: Other) {
    lhs = lhs &<< rhs
  }
}
extension FixedWidthInteger {
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: Range<Self>,
    using generator: inout T
  ) -> Self {
    _precondition(
      !range.isEmpty,
      "Can't get random value with an empty range"
    )
    let delta = Magnitude(truncatingIfNeeded: range.upperBound &- range.lowerBound)
    return Self(truncatingIfNeeded:
      Magnitude(truncatingIfNeeded: range.lowerBound) &+
      generator.next(upperBound: delta)
    )
  }
  @inlinable
  public static func random(in range: Range<Self>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: ClosedRange<Self>,
    using generator: inout T
  ) -> Self {
    var delta = Magnitude(truncatingIfNeeded: range.upperBound &- range.lowerBound)
    if delta == Magnitude.max {
      return Self(truncatingIfNeeded: generator.next() as Magnitude)
    }
    delta += 1
    return Self(truncatingIfNeeded:
      Magnitude(truncatingIfNeeded: range.lowerBound) &+
      generator.next(upperBound: delta)
    )
  }
  @inlinable
  public static func random(in range: ClosedRange<Self>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
}
extension FixedWidthInteger {
  public static prefix func ~ (x: Self) -> Self {
    return 0 &- x &- 1
  }
  public static func >> <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Self {
    var lhs = lhs
    _nonMaskingRightShiftGeneric(&lhs, rhs)
    return lhs
  }
  public static func >>= <
    Other: BinaryInteger
  >(lhs: inout Self, rhs: Other) {
    _nonMaskingRightShiftGeneric(&lhs, rhs)
  }
  public static func _nonMaskingRightShiftGeneric <
    Other: BinaryInteger
  >(_ lhs: inout Self, _ rhs: Other) {
    let shift = rhs < -Self.bitWidth ? -Self.bitWidth
                : rhs > Self.bitWidth ? Self.bitWidth
                : Int(rhs)
    lhs = _nonMaskingRightShift(lhs, shift)
  }
  public static func _nonMaskingRightShift(_ lhs: Self, _ rhs: Int) -> Self {
    let overshiftR = Self.isSigned ? lhs &>> (Self.bitWidth - 1) : 0
    let overshiftL: Self = 0
    if _fastPath(rhs >= 0) {
      if _fastPath(rhs < Self.bitWidth) {
        return lhs &>> Self(truncatingIfNeeded: rhs)
      }
      return overshiftR
    }
    if _slowPath(rhs <= -Self.bitWidth) {
      return overshiftL
    }
    return lhs &<< -rhs
  }
  public static func << <
    Other: BinaryInteger
  >(lhs: Self, rhs: Other) -> Self {
    var lhs = lhs
    _nonMaskingLeftShiftGeneric(&lhs, rhs)
    return lhs
  }
  public static func <<= <
    Other: BinaryInteger
  >(lhs: inout Self, rhs: Other) {
    _nonMaskingLeftShiftGeneric(&lhs, rhs)
  }
  public static func _nonMaskingLeftShiftGeneric <
    Other: BinaryInteger
  >(_ lhs: inout Self, _ rhs: Other) {
    let shift = rhs < -Self.bitWidth ? -Self.bitWidth
                : rhs > Self.bitWidth ? Self.bitWidth
                : Int(rhs)
    lhs = _nonMaskingLeftShift(lhs, shift)
  }
  public static func _nonMaskingLeftShift(_ lhs: Self, _ rhs: Int) -> Self {
    let overshiftR = Self.isSigned ? lhs &>> (Self.bitWidth - 1) : 0
    let overshiftL: Self = 0
    if _fastPath(rhs >= 0) {
      if _fastPath(rhs < Self.bitWidth) {
        return lhs &<< Self(truncatingIfNeeded: rhs)
      }
      return overshiftL
    }
    if _slowPath(rhs <= -Self.bitWidth) {
      return overshiftR
    }
    return lhs &>> -rhs
  }
}
extension FixedWidthInteger {
  @inlinable
  public 
  static func _convert<Source: BinaryFloatingPoint>(
    from source: Source
  ) -> (value: Self?, exact: Bool) {
    guard _fastPath(!source.isZero) else { return (0, true) }
    guard _fastPath(source.isFinite) else { return (nil, false) }
    guard Self.isSigned || source > -1 else { return (nil, false) }
    let exponent = source.exponent
    if _slowPath(Self.bitWidth <= exponent) { return (nil, false) }
    let minBitWidth = source.significandWidth
    let isExact = (minBitWidth <= exponent)
    let bitPattern = source.significandBitPattern
    let bitWidth = minBitWidth &+ bitPattern.trailingZeroBitCount
    let shift = exponent - Source.Exponent(bitWidth)
    let shiftedBitPattern = Self.Magnitude.bitWidth > bitWidth
      ? Self.Magnitude(truncatingIfNeeded: bitPattern) << shift
      : Self.Magnitude(truncatingIfNeeded: bitPattern << shift)
    if _slowPath(Self.isSigned && Self.bitWidth &- 1 == exponent) {
      return source < 0 && shiftedBitPattern == 0
        ? (Self.min, isExact)
        : (nil, false)
    }
    let magnitude = ((1 as Self.Magnitude) << exponent) | shiftedBitPattern
    return (
      Self.isSigned && source < 0 ? 0 &- Self(magnitude) : Self(magnitude),
      isExact)
  }
  @inlinable
  @inline(__always)
  public init<T: BinaryFloatingPoint>(_ source: T) {
    guard let value = Self._convert(from: source).value else {
      fatalError("""
        \(T.self) value cannot be converted to \(Self.self) because it is \
        outside the representable range
        """)
    }
    self = value
  }
  @inlinable
  public init?<T: BinaryFloatingPoint>(exactly source: T) {
    let (temporary, exact) = Self._convert(from: source)
    guard exact, let value = temporary else {
      return nil
    }
    self = value
  }
  @inlinable
  public init<Other: BinaryInteger>(clamping source: Other) {
    if _slowPath(source < Self.min) {
      self = Self.min
    }
    else if _slowPath(source > Self.max) {
      self = Self.max
    }
    else { self = Self(truncatingIfNeeded: source) }
  }
  @inlinable 
  @inline(__always)
  public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
    if Self.bitWidth <= Int.bitWidth {
      self = Self(_truncatingBits: source._lowWord)
    }
    else {
      self = Self._truncatingInit(source)
    }
  }
  internal static func _truncatingInit<T: BinaryInteger>(_ source: T) -> Self {
    let neg = source < (0 as T)
    var result: Self = neg ? ~0 : 0
    var shift: Self = 0
    let width = Self(_truncatingBits: Self.bitWidth._lowWord)
    for word in source.words {
      guard shift < width else { break }
      result ^= Self(_truncatingBits: neg ? ~word : word) &<< shift
      shift += Self(_truncatingBits: Int.bitWidth._lowWord)
    }
    return result
  }
  public 
  static var _highBitIndex: Self {
    return Self.init(_truncatingBits: UInt(Self.bitWidth._value) &- 1)
  }
  public static func &+ (lhs: Self, rhs: Self) -> Self {
    return lhs.addingReportingOverflow(rhs).partialValue
  }
  public static func &+= (lhs: inout Self, rhs: Self) {
    lhs = lhs &+ rhs
  }
  public static func &- (lhs: Self, rhs: Self) -> Self {
    return lhs.subtractingReportingOverflow(rhs).partialValue
  }
  public static func &-= (lhs: inout Self, rhs: Self) {
    lhs = lhs &- rhs
  }
  public static func &* (lhs: Self, rhs: Self) -> Self {
    return lhs.multipliedReportingOverflow(by: rhs).partialValue
  }
  public static func &*= (lhs: inout Self, rhs: Self) {
    lhs = lhs &* rhs
  }
}
extension FixedWidthInteger {
  @inlinable
  public static func _random<R: RandomNumberGenerator>(
    using generator: inout R
  ) -> Self {
    if bitWidth <= UInt64.bitWidth {
      return Self(truncatingIfNeeded: generator.next())
    }
    let (quotient, remainder) = bitWidth.quotientAndRemainder(
      dividingBy: UInt64.bitWidth
    )
    var tmp: Self = 0
    for i in 0 ..< quotient + remainder.signum() {
      let next: UInt64 = generator.next()
      tmp += Self(truncatingIfNeeded: next) &<< (UInt64.bitWidth * i)
    }
    return tmp
  }
}
public protocol UnsignedInteger: BinaryInteger { }
extension UnsignedInteger {
  @inlinable 
  public var magnitude: Self {
    @inline(__always)
    get { return self }
  }
  @inlinable 
  public static var isSigned: Bool {
    @inline(__always)
    get { return false }
  }
}
extension UnsignedInteger where Self: FixedWidthInteger {
  @inlinable 
  @inline(__always)
  public init<T: BinaryInteger>(_ source: T) {
    if T.isSigned {
      _precondition(source >= (0 as T), "Negative value is not representable")
    }
    if source.bitWidth >= Self.bitWidth {
      _precondition(source <= Self.max,
        "Not enough bits to represent the passed value")
    }
    self.init(truncatingIfNeeded: source)
  }
  @inlinable 
  @inline(__always)
  public init?<T: BinaryInteger>(exactly source: T) {
    if T.isSigned && source < (0 as T) {
      return nil
    }
    if source.bitWidth >= Self.bitWidth &&
       source > Self.max {
      return nil
    }
    self.init(truncatingIfNeeded: source)
  }
  public static var max: Self { return ~0 }
  public static var min: Self { return 0 }
}
public protocol SignedInteger: BinaryInteger, SignedNumeric {
  @available(*, deprecated, message: "Use &+ instead.")
  static func _maskingAdd(_ lhs: Self, _ rhs: Self) -> Self
  @available(*, deprecated, message: "Use &- instead.")
  static func _maskingSubtract(_ lhs: Self, _ rhs: Self) -> Self
}
extension SignedInteger {
  @inlinable 
  public static var isSigned: Bool {
    @inline(__always)
    get { return true }
  }
}
extension SignedInteger where Self: FixedWidthInteger {
  @inlinable 
  @inline(__always)
  public init<T: BinaryInteger>(_ source: T) {
    if T.isSigned && source.bitWidth > Self.bitWidth {
      _precondition(source >= Self.min,
        "Not enough bits to represent a signed value")
    }
    if (source.bitWidth > Self.bitWidth) ||
       (source.bitWidth == Self.bitWidth && !T.isSigned) {
      _precondition(source <= Self.max,
        "Not enough bits to represent the passed value")
    }
    self.init(truncatingIfNeeded: source)
  }
  @inlinable 
  @inline(__always)
  public init?<T: BinaryInteger>(exactly source: T) {
    if T.isSigned && source.bitWidth > Self.bitWidth && source < Self.min {
      return nil
    }
    if (source.bitWidth > Self.bitWidth ||
        (source.bitWidth == Self.bitWidth && !T.isSigned)) &&
       source > Self.max {
      return nil
    }
    self.init(truncatingIfNeeded: source)
  }
  public static var max: Self { return ~min }
  public static var min: Self {
    return (-1 as Self) &<< Self._highBitIndex
  }
  @inlinable
  public func isMultiple(of other: Self) -> Bool {
    if other == 0 { return self == 0 }
    if other == -1 { return true }
    return self % other == 0
  }
}
@inlinable
public func numericCast<T: BinaryInteger, U: BinaryInteger>(_ x: T) -> U {
  return U(x)
}
extension SignedInteger {
  @available(*, deprecated, message: "Use &+ instead.")
  public static func _maskingAdd(_ lhs: Self, _ rhs: Self) -> Self {
    fatalError("Should be overridden in a more specific type")
  }
  @available(*, deprecated, message: "Use &- instead.")
  public static func _maskingSubtract(_ lhs: Self, _ rhs: Self) -> Self {
    fatalError("Should be overridden in a more specific type")
  }
}
extension SignedInteger where Self: FixedWidthInteger {
  @available(*, unavailable)
  public static func &+(lhs: Self, rhs: Self) -> Self {
    lhs.addingReportingOverflow(rhs).partialValue
  }
  @available(*, deprecated, message: "Use &+ instead.")
  public static func _maskingAdd(_ lhs: Self, _ rhs: Self) -> Self {
    lhs.addingReportingOverflow(rhs).partialValue
  }
  @available(*, unavailable)
  public static func &-(lhs: Self, rhs: Self) -> Self {
    lhs.subtractingReportingOverflow(rhs).partialValue
  }
  @available(*, deprecated, message: "Use &- instead.")
  public static func _maskingSubtract(_ lhs: Self, _ rhs: Self) -> Self {
    lhs.subtractingReportingOverflow(rhs).partialValue
  }
}
