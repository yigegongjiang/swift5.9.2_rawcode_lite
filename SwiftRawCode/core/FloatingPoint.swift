public protocol FloatingPoint: SignedNumeric, Strideable, Hashable
                                where Magnitude == Self {
  associatedtype Exponent: SignedInteger
  init(sign: FloatingPointSign, exponent: Exponent, significand: Self)
  init(signOf: Self, magnitudeOf: Self)
  init(_ value: Int)
  init<Source: BinaryInteger>(_ value: Source)
  init?<Source: BinaryInteger>(exactly value: Source)
  static var radix: Int { get }
  static var nan: Self { get }
  static var signalingNaN: Self { get }
  static var infinity: Self { get }
  static var greatestFiniteMagnitude: Self { get }
  static var pi: Self { get }
  var ulp: Self { get }
  static var ulpOfOne: Self { get }
  static var leastNormalMagnitude: Self { get }
  static var leastNonzeroMagnitude: Self { get }
  var sign: FloatingPointSign { get }
  var exponent: Exponent { get }
  var significand: Self { get }
  override static func +(lhs: Self, rhs: Self) -> Self
  override static func +=(lhs: inout Self, rhs: Self)
  override static prefix func - (_ operand: Self) -> Self
  override mutating func negate()
  override static func -(lhs: Self, rhs: Self) -> Self
  override static func -=(lhs: inout Self, rhs: Self)
  override static func *(lhs: Self, rhs: Self) -> Self
  override static func *=(lhs: inout Self, rhs: Self)
  static func /(lhs: Self, rhs: Self) -> Self
  static func /=(lhs: inout Self, rhs: Self)
  func remainder(dividingBy other: Self) -> Self
  mutating func formRemainder(dividingBy other: Self)
  func truncatingRemainder(dividingBy other: Self) -> Self
  mutating func formTruncatingRemainder(dividingBy other: Self)
  func squareRoot() -> Self
  mutating func formSquareRoot()
  func addingProduct(_ lhs: Self, _ rhs: Self) -> Self
  mutating func addProduct(_ lhs: Self, _ rhs: Self)
  static func minimum(_ x: Self, _ y: Self) -> Self
  static func maximum(_ x: Self, _ y: Self) -> Self
  static func minimumMagnitude(_ x: Self, _ y: Self) -> Self
  static func maximumMagnitude(_ x: Self, _ y: Self) -> Self
  func rounded(_ rule: FloatingPointRoundingRule) -> Self
  mutating func round(_ rule: FloatingPointRoundingRule)
  var nextUp: Self { get }
  var nextDown: Self { get }
  func isEqual(to other: Self) -> Bool
  func isLess(than other: Self) -> Bool
  func isLessThanOrEqualTo(_ other: Self) -> Bool
  func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool
  var isNormal: Bool { get }
  var isFinite: Bool { get }
  var isZero: Bool { get }
  var isSubnormal: Bool { get }
  var isInfinite: Bool { get }
  var isNaN: Bool { get }
  var isSignalingNaN: Bool { get }
  var floatingPointClass: FloatingPointClassification { get }
  var isCanonical: Bool { get }
}
@frozen
public enum FloatingPointSign: Int, Sendable {
  case plus
  case minus
  @inlinable
  public init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .plus
    case 1: self = .minus
    default: return nil
    }
  }
  @inlinable
  public var rawValue: Int {
    switch self {
    case .plus: return 0
    case .minus: return 1
    }
  }
  @inlinable
  public static func ==(a: FloatingPointSign, b: FloatingPointSign) -> Bool {
    return a.rawValue == b.rawValue
  }
  @inlinable
  public var hashValue: Int { return rawValue.hashValue }
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return rawValue._rawHashValue(seed: seed)
  }
}
@frozen
public enum FloatingPointClassification: Sendable {
  case signalingNaN
  case quietNaN
  case negativeInfinity
  case negativeNormal
  case negativeSubnormal
  case negativeZero
  case positiveZero
  case positiveSubnormal
  case positiveNormal
  case positiveInfinity
}
public enum FloatingPointRoundingRule: Sendable {
  case toNearestOrAwayFromZero
  case toNearestOrEven
  case up
  case down
  case towardZero
  case awayFromZero
}
extension FloatingPoint {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.isEqual(to: rhs)
  }
  public static func < (lhs: Self, rhs: Self) -> Bool {
    return lhs.isLess(than: rhs)
  }
  public static func <= (lhs: Self, rhs: Self) -> Bool {
    return lhs.isLessThanOrEqualTo(rhs)
  }
  public static func > (lhs: Self, rhs: Self) -> Bool {
    return rhs.isLess(than: lhs)
  }
  public static func >= (lhs: Self, rhs: Self) -> Bool {
    return rhs.isLessThanOrEqualTo(lhs)
  }
}
public protocol BinaryFloatingPoint: FloatingPoint, ExpressibleByFloatLiteral {
  associatedtype RawSignificand: UnsignedInteger
  associatedtype RawExponent: UnsignedInteger
  init(sign: FloatingPointSign,
       exponentBitPattern: RawExponent,
       significandBitPattern: RawSignificand)
  init(_ value: Float)
  init(_ value: Double)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  init(_ value: Float80)
#endif
  init<Source: BinaryFloatingPoint>(_ value: Source)
  init?<Source: BinaryFloatingPoint>(exactly value: Source)
  static var exponentBitCount: Int { get }
  static var significandBitCount: Int { get }
  var exponentBitPattern: RawExponent { get }
  var significandBitPattern: RawSignificand { get }
  var binade: Self { get }
  var significandWidth: Int { get }
}
extension FloatingPoint {
  @inlinable 
  public static var ulpOfOne: Self {
    return (1 as Self).ulp
  }
  public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
    var lhs = self
    lhs.round(rule)
    return lhs
  }
  public func rounded() -> Self {
    return rounded(.toNearestOrAwayFromZero)
  }
  public mutating func round() {
    round(.toNearestOrAwayFromZero)
  }
  @inlinable 
  public var nextDown: Self {
    @inline(__always)
    get {
      return -(-self).nextUp
    }
  }
  @inlinable 
  @inline(__always)
  public func truncatingRemainder(dividingBy other: Self) -> Self {
    var lhs = self
    lhs.formTruncatingRemainder(dividingBy: other)
    return lhs
  }
  @inlinable 
  @inline(__always)
  public func remainder(dividingBy other: Self) -> Self {
    var lhs = self
    lhs.formRemainder(dividingBy: other)
    return lhs
  }
  public func squareRoot( ) -> Self {
    var lhs = self
    lhs.formSquareRoot( )
    return lhs
  }
  public func addingProduct(_ lhs: Self, _ rhs: Self) -> Self {
    var addend = self
    addend.addProduct(lhs, rhs)
    return addend
  }
  @inlinable
  public static func minimum(_ x: Self, _ y: Self) -> Self {
    if x <= y || y.isNaN { return x }
    return y
  }
  @inlinable
  public static func maximum(_ x: Self, _ y: Self) -> Self {
    if x > y || y.isNaN { return x }
    return y
  }
  @inlinable
  public static func minimumMagnitude(_ x: Self, _ y: Self) -> Self {
    if x.magnitude <= y.magnitude || y.isNaN { return x }
    return y
  }
  @inlinable
  public static func maximumMagnitude(_ x: Self, _ y: Self) -> Self {
    if x.magnitude > y.magnitude || y.isNaN { return x }
    return y
  }
  @inlinable
  public var floatingPointClass: FloatingPointClassification {
    if isSignalingNaN { return .signalingNaN }
    if isNaN { return .quietNaN }
    if isInfinite { return sign == .minus ? .negativeInfinity : .positiveInfinity }
    if isNormal { return sign == .minus ? .negativeNormal : .positiveNormal }
    if isSubnormal { return sign == .minus ? .negativeSubnormal : .positiveSubnormal }
    return sign == .minus ? .negativeZero : .positiveZero
  }
}
extension BinaryFloatingPoint {
  @inlinable @inline(__always)
  public static var radix: Int { return 2 }
  @inlinable
  public init(signOf: Self, magnitudeOf: Self) {
    self.init(
      sign: signOf.sign,
      exponentBitPattern: magnitudeOf.exponentBitPattern,
      significandBitPattern: magnitudeOf.significandBitPattern
    )
  }
  public 
  static func _convert<Source: BinaryFloatingPoint>(
    from source: Source
  ) -> (value: Self, exact: Bool) {
    guard _fastPath(!source.isZero) else {
      return (source.sign == .minus ? -0.0 : 0, true)
    }
    guard _fastPath(source.isFinite) else {
      if source.isInfinite {
        return (source.sign == .minus ? -.infinity : .infinity, true)
      }
      let payload_ =
        source.significandBitPattern &
          ~(Source.nan.significandBitPattern |
            Source.signalingNaN.significandBitPattern)
      let mask =
        Self.greatestFiniteMagnitude.significandBitPattern &
          ~(Self.nan.significandBitPattern |
            Self.signalingNaN.significandBitPattern)
      let payload = Self.RawSignificand(truncatingIfNeeded: payload_) & mask
      let value = source.isSignalingNaN
        ? Self(
          sign: source.sign,
          exponentBitPattern: Self.signalingNaN.exponentBitPattern,
          significandBitPattern: payload |
            Self.signalingNaN.significandBitPattern)
        : Self(
          sign: source.sign,
          exponentBitPattern: Self.nan.exponentBitPattern,
          significandBitPattern: payload | Self.nan.significandBitPattern)
      return (value, false)
    }
    let exponent = source.exponent
    var exemplar = Self.leastNormalMagnitude
    let exponentBitPattern: Self.RawExponent
    let leadingBitIndex: Int
    let shift: Int
    let significandBitPattern: Self.RawSignificand
    if exponent < exemplar.exponent {
      exemplar = Self.leastNonzeroMagnitude
      let minExponent = exemplar.exponent
      if exponent + 1 < minExponent {
        return (source.sign == .minus ? -0.0 : 0, false)
      }
      if _slowPath(exponent + 1 == minExponent) {
        return source.significandWidth == 0
          ? (source.sign == .minus ? -0.0 : 0, false)
          : (source.sign == .minus ? -exemplar : exemplar, false)
      }
      exponentBitPattern = 0 as Self.RawExponent
      leadingBitIndex = Int(Self.Exponent(exponent) - minExponent)
      shift =
        leadingBitIndex &-
        (source.significandWidth &+
          source.significandBitPattern.trailingZeroBitCount)
      let leadingBit = source.isNormal
        ? (1 as Self.RawSignificand) << leadingBitIndex
        : 0
      significandBitPattern = leadingBit | (shift >= 0
        ? Self.RawSignificand(source.significandBitPattern) << shift
        : Self.RawSignificand(source.significandBitPattern >> -shift))
    } else {
      exemplar = Self.greatestFiniteMagnitude
      if exponent > exemplar.exponent {
        return (source.sign == .minus ? -.infinity : .infinity, false)
      }
      exponentBitPattern = exponent < 0
        ? (1 as Self).exponentBitPattern - Self.RawExponent(-exponent)
        : (1 as Self).exponentBitPattern + Self.RawExponent(exponent)
      leadingBitIndex = exemplar.significandWidth
      shift =
        leadingBitIndex &-
          (source.significandWidth &+
            source.significandBitPattern.trailingZeroBitCount)
      let sourceLeadingBit = source.isSubnormal
        ? (1 as Source.RawSignificand) <<
          (source.significandWidth &+
            source.significandBitPattern.trailingZeroBitCount)
        : 0
      significandBitPattern = shift >= 0
        ? Self.RawSignificand(
          sourceLeadingBit ^ source.significandBitPattern) << shift
        : Self.RawSignificand(
          (sourceLeadingBit ^ source.significandBitPattern) >> -shift)
    }
    let value = Self(
      sign: source.sign,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: significandBitPattern)
    if source.significandWidth <= leadingBitIndex {
      return (value, true)
    }
    let ulp = (1 as Source.RawSignificand) << -shift
    let truncatedBits = source.significandBitPattern & (ulp - 1)
    if truncatedBits < ulp / 2 {
      return (value, false)
    }
    let rounded = source.sign == .minus ? value.nextDown : value.nextUp
    if _fastPath(truncatedBits > ulp / 2) {
      return (rounded, false)
    }
    return
      significandBitPattern.trailingZeroBitCount >
        rounded.significandBitPattern.trailingZeroBitCount
      ? (value, false)
      : (rounded, false)
  }
  @inlinable
  public init<Source: BinaryFloatingPoint>(_ value: Source) {
    switch (Source.exponentBitCount, Source.significandBitCount) {
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    case (5, 10):
      guard #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) 
      else {
        self = Self._convert(from: value).value * 1
        break
      }
      let value_ = value as? Float16 ?? Float16(
        sign: value.sign,
        exponentBitPattern:
          UInt(truncatingIfNeeded: value.exponentBitPattern),
        significandBitPattern:
          UInt16(truncatingIfNeeded: value.significandBitPattern))
      self = Self(Float(value_))
#endif
    case (8, 23):
      let value_ = value as? Float ?? Float(
        sign: value.sign,
        exponentBitPattern:
          UInt(truncatingIfNeeded: value.exponentBitPattern),
        significandBitPattern:
          UInt32(truncatingIfNeeded: value.significandBitPattern))
      self = Self(value_)
    case (11, 52):
      let value_ = value as? Double ?? Double(
        sign: value.sign,
        exponentBitPattern:
          UInt(truncatingIfNeeded: value.exponentBitPattern),
        significandBitPattern:
          UInt64(truncatingIfNeeded: value.significandBitPattern))
      self = Self(value_)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
    case (15, 63):
      let value_ = value as? Float80 ?? Float80(
        sign: value.sign,
        exponentBitPattern:
          UInt(truncatingIfNeeded: value.exponentBitPattern),
        significandBitPattern:
          UInt64(truncatingIfNeeded: value.significandBitPattern))
      self = Self(value_)
#endif
    default:
      self = Self._convert(from: value).value * 1
    }
  }
  @inlinable
  public init?<Source: BinaryFloatingPoint>(exactly value: Source) {
    if value.isNaN { return nil }
    if (Source.exponentBitCount > Self.exponentBitCount
        || Source.significandBitCount > Self.significandBitCount)
      && value.isFinite && !value.isZero {
      let exponent = value.exponent
      if exponent < Self.leastNormalMagnitude.exponent {
        if exponent < Self.leastNonzeroMagnitude.exponent { return nil }
        if value.significandWidth >
          Int(Self.Exponent(exponent) - Self.leastNonzeroMagnitude.exponent) {
          return nil
        }
      } else {
        if exponent > Self.greatestFiniteMagnitude.exponent { return nil }
        if value.significandWidth >
          Self.greatestFiniteMagnitude.significandWidth {
          return nil
        }
      }
    }
    self = Self(value)
  }
  @inlinable
  public func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool {
    if self < other { return true }
    if other > self { return false }
    if sign != other.sign { return sign == .minus }
    if exponentBitPattern > other.exponentBitPattern { return sign == .minus }
    if exponentBitPattern < other.exponentBitPattern { return sign == .plus }
    if significandBitPattern > other.significandBitPattern {
      return sign == .minus
    }
    if significandBitPattern < other.significandBitPattern {
      return sign == .plus
    }
    return true
  }
}
extension BinaryFloatingPoint where Self.RawSignificand: FixedWidthInteger {
  public 
  static func _convert<Source: BinaryInteger>(
    from source: Source
  ) -> (value: Self, exact: Bool) {
    let exponentBias = (1 as Self).exponentBitPattern
    let significandMask = ((1 as RawSignificand) << Self.significandBitCount) &- 1
    if _fastPath(source == 0) { return (0, true) }
    let magnitude = source.magnitude
    var exponent = magnitude._binaryLogarithm()
    guard exponent <= Self.greatestFiniteMagnitude.exponent else {
      return (Source.isSigned && source < 0 ? -.infinity : .infinity, false)
    }
    if exponent <= Self.significandBitCount {
      let shift = Self.significandBitCount &- exponent
      let significand = RawSignificand(magnitude) &<< shift
      let value = Self(
        sign: Source.isSigned && source < 0 ? .minus : .plus,
        exponentBitPattern: exponentBias + RawExponent(exponent),
        significandBitPattern: significand
      )
      return (value, true)
    }
    let shift = exponent &- Self.significandBitCount
    let halfway = (1 as Source.Magnitude) << (shift - 1)
    let mask = 2 * halfway - 1
    let fraction = magnitude & mask
    var significand = RawSignificand(truncatingIfNeeded: magnitude >> shift) & significandMask
    if fraction > halfway || (fraction == halfway && significand & 1 == 1) {
      var carry = false
      (significand, carry) = significand.addingReportingOverflow(1)
      if carry || significand > significandMask {
        exponent += 1
        guard exponent <= Self.greatestFiniteMagnitude.exponent else {
          return (Source.isSigned && source < 0 ? -.infinity : .infinity, false)
        }
      }
    }
    return (Self(
      sign: Source.isSigned && source < 0 ? .minus : .plus,
      exponentBitPattern: exponentBias + RawExponent(exponent),
      significandBitPattern: significand
    ), fraction == 0)
  }
  @inlinable
  public init<Source: BinaryInteger>(_ value: Source) {
    self = Self._convert(from: value).value
  }
  @inlinable
  public init?<Source: BinaryInteger>(exactly value: Source) {
    let (value_, exact) = Self._convert(from: value)
    guard exact else { return nil }
    self = value_
  }
}
