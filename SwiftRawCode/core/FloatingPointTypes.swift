import SwiftShims
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
@frozen
public struct Float16 {
  public 
  var _value: Builtin.FPIEEE16
  public init() {
    let zero: Int64 = 0
    self._value = Builtin.sitofp_Int64_FPIEEE16(zero._value)
  }
  public 
  init(_ _value: Builtin.FPIEEE16) {
    self._value = _value
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: CustomStringConvertible {
  public var description: String {
    if isNaN {
      return "nan"
    } else {
      var (buffer, length) = _float16ToString(self, debug: false)
      return buffer.withBytes { (bufferPtr) in
        String._fromASCII(
          UnsafeBufferPointer(start: bufferPtr, count: length))
      }
    }
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: CustomDebugStringConvertible {
  public var debugDescription: String {
    var (buffer, length) = _float16ToString(self, debug: true)
    return buffer.withBytes { (bufferPtr) in
      String._fromASCII(
        UnsafeBufferPointer(start: bufferPtr, count: length))
    }
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    var (buffer, length) = _float16ToString(self, debug: true)
    buffer.withBytes { (bufferPtr) in
      let bufPtr = UnsafeBufferPointer(start: bufferPtr, count: length)
      target._writeASCII(bufPtr)
    }
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: BinaryFloatingPoint {
  public typealias Magnitude = Float16
  public typealias Exponent = Int
  public typealias RawSignificand = UInt16
  @inlinable
  public static var exponentBitCount: Int {
    return 5
  }
  @inlinable
  public static var significandBitCount: Int {
    return 10
  }
  @inlinable 
  internal static var _infinityExponent: UInt {
    @inline(__always) get { return 1 &<< UInt(exponentBitCount) - 1 }
  }
  @inlinable 
  internal static var _exponentBias: UInt {
    @inline(__always) get { return _infinityExponent &>> 1 }
  }
  @inlinable 
  internal static var _significandMask: UInt16 {
    @inline(__always) get {
      return 1 &<< UInt16(significandBitCount) - 1
    }
  }
  @inlinable 
  internal static var _quietNaNMask: UInt16 {
    @inline(__always) get {
      return 1 &<< UInt16(significandBitCount - 1)
    }
  }
  @inlinable
  public var bitPattern: UInt16 {
    return UInt16(Builtin.bitcast_FPIEEE16_Int16(_value))
  }
  @inlinable
  public init(bitPattern: UInt16) {
    self.init(Builtin.bitcast_Int16_FPIEEE16(bitPattern._value))
  }
  @inlinable
  public var sign: FloatingPointSign {
    let shift = Float16.significandBitCount + Float16.exponentBitCount
    return FloatingPointSign(
      rawValue: Int(bitPattern &>> UInt16(shift))
    )!
  }
  @available(*, unavailable, renamed: "sign")
  public var isSignMinus: Bool { Builtin.unreachable() }
  @inlinable
  public var exponentBitPattern: UInt {
    return UInt(bitPattern &>> UInt16(Float16.significandBitCount)) &
      Float16._infinityExponent
  }
  @inlinable
  public var significandBitPattern: UInt16 {
    return UInt16(bitPattern) & Float16._significandMask
  }
  @inlinable
  public init(
    sign: FloatingPointSign,
    exponentBitPattern: UInt,
    significandBitPattern: UInt16
  ) {
    let signShift = Float16.significandBitCount + Float16.exponentBitCount
    let sign = UInt16(sign == .minus ? 1 : 0)
    let exponent = UInt16(
      exponentBitPattern & Float16._infinityExponent
    )
    let significand = UInt16(
      significandBitPattern & Float16._significandMask
    )
    self.init(bitPattern:
      sign &<< UInt16(signShift) |
      exponent &<< UInt16(Float16.significandBitCount) |
      significand
    )
  }
  @inlinable
  public var isCanonical: Bool {
    if Self.leastNonzeroMagnitude == Self.leastNormalMagnitude {
      if exponentBitPattern == 0 && significandBitPattern != 0 {
        return false
      }
    }
    return true
  }
  @inlinable
  public static var infinity: Float16 {
    return Float16(
      sign: .plus,
      exponentBitPattern: _infinityExponent,
      significandBitPattern: 0
    )
  }
  @inlinable
  public static var nan: Float16 {
    return Float16(nan: 0, signaling: false)
  }
  @inlinable
  public static var signalingNaN: Float16 {
    return Float16(nan: 0, signaling: true)
  }
  @available(*, unavailable, renamed: "nan")
  public static var quietNaN: Float16 { Builtin.unreachable() }
  @inlinable
  public static var greatestFiniteMagnitude: Float16 {
    return Float16(
      sign: .plus,
      exponentBitPattern: _infinityExponent - 1,
      significandBitPattern: _significandMask
    )
  }
  @inlinable
  public static var pi: Float16 {
    return 0x1.92p1
  }
  @inlinable
  public var ulp: Float16 {
    guard _fastPath(isFinite) else { return .nan }
    if _fastPath(isNormal) {
      let bitPattern_ = bitPattern & Float16.infinity.bitPattern
      return Float16(bitPattern: bitPattern_) * 0x1p-10
    }
    return .leastNormalMagnitude * 0x1p-10
  }
  @inlinable
  public static var leastNormalMagnitude: Float16 {
    return 0x1.0p-14
  }
  @inlinable
  public static var leastNonzeroMagnitude: Float16 {
#if arch(arm)
    return leastNormalMagnitude
#else
    return leastNormalMagnitude * ulpOfOne
#endif
  }
  @inlinable
  public static var ulpOfOne: Float16 {
    return 0x1.0p-10
  }
  @inlinable
  public var exponent: Int {
    if !isFinite { return .max }
    if isZero { return .min }
    let provisional = Int(exponentBitPattern) - Int(Float16._exponentBias)
    if isNormal { return provisional }
    let shift =
      Float16.significandBitCount - significandBitPattern._binaryLogarithm()
    return provisional + 1 - shift
  }
  @inlinable
  public var significand: Float16 {
    if isNaN { return self }
    if isNormal {
      return Float16(sign: .plus,
        exponentBitPattern: Float16._exponentBias,
        significandBitPattern: significandBitPattern)
    }
    if isSubnormal {
      let shift =
        Float16.significandBitCount - significandBitPattern._binaryLogarithm()
      return Float16(
        sign: .plus,
        exponentBitPattern: Float16._exponentBias,
        significandBitPattern: significandBitPattern &<< shift
      )
    }
    return Float16(
      sign: .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: 0
    )
  }
  @inlinable
  public init(sign: FloatingPointSign, exponent: Int, significand: Float16) {
    var result = significand
    if sign == .minus { result = -result }
    if significand.isFinite && !significand.isZero {
      var clamped = exponent
      let leastNormalExponent = 1 - Int(Float16._exponentBias)
      let greatestFiniteExponent = Int(Float16._exponentBias)
      if clamped < leastNormalExponent {
        clamped = max(clamped, 3*leastNormalExponent)
        while clamped < leastNormalExponent {
          result  *= Float16.leastNormalMagnitude
          clamped -= leastNormalExponent
        }
      }
      else if clamped > greatestFiniteExponent {
        clamped = min(clamped, 3*greatestFiniteExponent)
        let step = Float16(sign: .plus,
          exponentBitPattern: Float16._infinityExponent - 1,
          significandBitPattern: 0)
        while clamped > greatestFiniteExponent {
          result  *= step
          clamped -= greatestFiniteExponent
        }
      }
      let scale = Float16(
        sign: .plus,
        exponentBitPattern: UInt(Int(Float16._exponentBias) + clamped),
        significandBitPattern: 0
      )
      result = result * scale
    }
    self = result
  }
  @inlinable
  public init(nan payload: RawSignificand, signaling: Bool) {
    _precondition(payload < (Float16._quietNaNMask &>> 1),
      "NaN payload is not encodable.")
    var significand = payload
    significand |= Float16._quietNaNMask &>> (signaling ? 1 : 0)
    self.init(
      sign: .plus,
      exponentBitPattern: Float16._infinityExponent,
      significandBitPattern: significand
    )
  }
  @inlinable
  public var nextUp: Float16 {
    let x = self + 0
#if arch(arm)
    if _slowPath(x == 0) { return .leastNonzeroMagnitude }
    if _slowPath(x == -.leastNonzeroMagnitude) { return -0.0 }
#endif
    if _fastPath(x < .infinity) {
      let increment = Int16(bitPattern: x.bitPattern) &>> 15 | 1
      let bitPattern_ = x.bitPattern &+ UInt16(bitPattern: increment)
      return Float16(bitPattern: bitPattern_)
    }
    return x
  }
  public init(signOf sign: Float16, magnitudeOf mag: Float16) {
    _value = Builtin.int_copysign_FPIEEE16(mag._value, sign._value)
  }
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    switch rule {
    case .toNearestOrAwayFromZero:
      _value = Builtin.int_round_FPIEEE16(_value)
    case .toNearestOrEven:
      _value = Builtin.int_rint_FPIEEE16(_value)
    case .towardZero:
      _value = Builtin.int_trunc_FPIEEE16(_value)
    case .awayFromZero:
      if sign == .minus {
        _value = Builtin.int_floor_FPIEEE16(_value)
      }
      else {
        _value = Builtin.int_ceil_FPIEEE16(_value)
      }
    case .up:
      _value = Builtin.int_ceil_FPIEEE16(_value)
    case .down:
      _value = Builtin.int_floor_FPIEEE16(_value)
    @unknown default:
      self._roundSlowPath(rule)
    }
  }
  @usableFromInline
  internal mutating func _roundSlowPath(_ rule: FloatingPointRoundingRule) {
    self.round(rule)
  }
  public mutating func negate() {
    _value = Builtin.fneg_FPIEEE16(self._value)
  }
  public static func +=(lhs: inout Float16, rhs: Float16) {
    lhs._value = Builtin.fadd_FPIEEE16(lhs._value, rhs._value)
  }
  public static func -=(lhs: inout Float16, rhs: Float16) {
    lhs._value = Builtin.fsub_FPIEEE16(lhs._value, rhs._value)
  }
  public static func *=(lhs: inout Float16, rhs: Float16) {
    lhs._value = Builtin.fmul_FPIEEE16(lhs._value, rhs._value)
  }
  public static func /=(lhs: inout Float16, rhs: Float16) {
    lhs._value = Builtin.fdiv_FPIEEE16(lhs._value, rhs._value)
  }
  @inlinable 
  @inline(__always)
  public mutating func formRemainder(dividingBy other: Float16) {
    self = Float16(_stdlib_remainderf(Float(self), Float(other)))
  }
  @inlinable 
  @inline(__always)
  public mutating func formTruncatingRemainder(dividingBy other: Float16) {
    _value = Builtin.frem_FPIEEE16(self._value, other._value)
  }
  public mutating func formSquareRoot( ) {
    self = Float16(_stdlib_squareRootf(Float(self)))
  }
  public mutating func addProduct(_ lhs: Float16, _ rhs: Float16) {
    _value = Builtin.int_fma_FPIEEE16(lhs._value, rhs._value, _value)
  }
  public func isEqual(to other: Float16) -> Bool {
    return Bool(Builtin.fcmp_oeq_FPIEEE16(self._value, other._value))
  }
  public func isLess(than other: Float16) -> Bool {
    return Bool(Builtin.fcmp_olt_FPIEEE16(self._value, other._value))
  }
  public func isLessThanOrEqualTo(_ other: Float16) -> Bool {
    return Bool(Builtin.fcmp_ole_FPIEEE16(self._value, other._value))
  }
  @inlinable 
  public var isNormal: Bool {
    @inline(__always)
    get {
      return exponentBitPattern > 0 && isFinite
    }
  }
  @inlinable 
  public var isFinite: Bool {
    @inline(__always)
    get {
      return exponentBitPattern < Float16._infinityExponent
    }
  }
  @inlinable 
  public var isZero: Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isSubnormal:  Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isInfinite:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isNaN:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isSignalingNaN: Bool {
    @inline(__always)
    get {
      return isNaN && (significandBitPattern & Float16._quietNaNMask) == 0
    }
  }
  @inlinable
  public var binade: Float16 {
    guard _fastPath(isFinite) else { return .nan }
#if !arch(arm)
    if _slowPath(isSubnormal) {
      let bitPattern_ =
        (self * 0x1p10).bitPattern
          & (-Float16.infinity).bitPattern
      return Float16(bitPattern: bitPattern_) * 0x1p-10
    }
#endif
    return Float16(bitPattern: bitPattern & (-Float16.infinity).bitPattern)
  }
  @inlinable
  public var significandWidth: Int {
    let trailingZeroBits = significandBitPattern.trailingZeroBitCount
    if isNormal {
      guard significandBitPattern != 0 else { return 0 }
      return Float16.significandBitCount &- trailingZeroBits
    }
    if isSubnormal {
      let leadingZeroBits = significandBitPattern.leadingZeroBitCount
      return UInt16.bitWidth &- (trailingZeroBits &+ leadingZeroBits &+ 1)
    }
    return -1
  }
  @inlinable 
  @inline(__always)
  public init(floatLiteral value: Float16) {
    self = value
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: _ExpressibleByBuiltinIntegerLiteral, ExpressibleByIntegerLiteral {
  public
  init(_builtinIntegerLiteral value: Builtin.IntLiteral){
    self = Float16(Builtin.itofp_with_overflow_IntLiteral_FPIEEE16(value))
  }
  public init(integerLiteral value: Int64) {
    self = Float16(Builtin.sitofp_Int64_FPIEEE16(value._value))
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension Float16: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE80) {
    self = Float16(Float80(value))
  }
}
#else
@available(SwiftStdlib 5.3, *)
extension Float16: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE64) {
    self = Float16(Builtin.fptrunc_FPIEEE64_FPIEEE16(value))
  }
}
#endif
@available(SwiftStdlib 5.3, *)
extension Float16: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var v = self
    if isZero {
      v = 0
    }
    hasher.combine(v.bitPattern)
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    let v = isZero ? 0 : self
    return Hasher._hash(seed: seed, bytes: UInt64(v.bitPattern), count: 2)
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16 {
  @inlinable 
  public var magnitude: Float16 {
    @inline(__always)
    get {
      return Float16(Builtin.int_fabs_FPIEEE16(_value))
    }
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16 {
  public static prefix func - (x: Float16) -> Float16 {
    return Float16(Builtin.fneg_FPIEEE16(x._value))
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: Sendable { }
@available(SwiftStdlib 5.3, *)
extension Float16 {
  public init(_ v: Int) {
    _value = Builtin.sitofp_Int64_FPIEEE16(v._value)
  }
  @inlinable 
  @inline(__always)
  public init<Source: BinaryInteger>(_ value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let asInt = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE16(asInt._value)
      } else {
        let asUInt = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE16(asUInt._value)
      }
    } else {
      self = Float16._convert(from: value).value
    }
  }
  public init?<Source: BinaryInteger>(exactly value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let extended = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE16(extended._value)
        guard self.isFinite && Int(self) == extended else {
          return nil
        }
      } else {
        let extended = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE16(extended._value)
        guard self.isFinite && UInt(self) == extended else {
          return nil
        }
      }
    } else {
      let (value_, exact) = Self._convert(from: value)
      guard exact else { return nil }
      self = value_
    }
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  @inlinable 
  @inline(__always)
  public init(_ other: Float16) {
    _value = other._value
  }
  @available(SwiftStdlib 5.3, *)
  @inlinable
  @inline(__always)
  public init?(exactly other: Float16) {
    self.init(other)
    if Float16(self) != other {
      return nil
    }
  }
#endif
  @inlinable 
  @inline(__always)
  public init(_ other: Float) {
    _value = Builtin.fptrunc_FPIEEE32_FPIEEE16(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float) {
    self.init(other)
    if Float(self) != other {
      return nil
    }
  }
  @inlinable 
  @inline(__always)
  public init(_ other: Double) {
    _value = Builtin.fptrunc_FPIEEE64_FPIEEE16(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Double) {
    self.init(other)
    if Double(self) != other {
      return nil
    }
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ other: Float80) {
    var flt = Float(other)
    if flt.isFinite {
      if Float80(flt).magnitude > other.magnitude {
        flt = Float(bitPattern: flt.bitPattern &- (~flt.bitPattern & 1))
      }
      else if Float80(flt).magnitude < other.magnitude {
        flt = Float(bitPattern: flt.bitPattern | 1)
      }
    }
    self = Float16(flt)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float80) {
    self.init(other)
    if Float80(self) != other {
      return nil
    }
  }
#endif
}
@available(SwiftStdlib 5.3, *)
extension Float16 {
  public static func + (lhs: Float16, rhs: Float16) -> Float16 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func - (lhs: Float16, rhs: Float16) -> Float16 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func * (lhs: Float16, rhs: Float16) -> Float16 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func / (lhs: Float16, rhs: Float16) -> Float16 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
}
@available(SwiftStdlib 5.3, *)
extension Float16: Strideable {
  public func distance(to other: Float16) -> Float16 {
    return other - self
  }
  public func advanced(by amount: Float16) -> Float16 {
    return self + amount
  }
}
#else
@frozen
@available(SwiftStdlib 5.3, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
public struct Float16 {
  public init() {
    fatalError("Float16 is not available")
  }
}
@available(SwiftStdlib 5.3, *)
@available(macOS, unavailable)
@available(macCatalyst, unavailable)
extension Float16: Sendable { }
#endif
@frozen
public struct Float {
  public 
  var _value: Builtin.FPIEEE32
  public init() {
    let zero: Int64 = 0
    self._value = Builtin.sitofp_Int64_FPIEEE32(zero._value)
  }
  public 
  init(_ _value: Builtin.FPIEEE32) {
    self._value = _value
  }
}
extension Float: CustomStringConvertible {
  public var description: String {
    if isNaN {
      return "nan"
    } else {
      var (buffer, length) = _float32ToString(self, debug: false)
      return buffer.withBytes { (bufferPtr) in
        String._fromASCII(
          UnsafeBufferPointer(start: bufferPtr, count: length))
      }
    }
  }
}
extension Float: CustomDebugStringConvertible {
  public var debugDescription: String {
    var (buffer, length) = _float32ToString(self, debug: true)
    return buffer.withBytes { (bufferPtr) in
      String._fromASCII(
        UnsafeBufferPointer(start: bufferPtr, count: length))
    }
  }
}
extension Float: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    var (buffer, length) = _float32ToString(self, debug: true)
    buffer.withBytes { (bufferPtr) in
      let bufPtr = UnsafeBufferPointer(start: bufferPtr, count: length)
      target._writeASCII(bufPtr)
    }
  }
}
extension Float: BinaryFloatingPoint {
  public typealias Magnitude = Float
  public typealias Exponent = Int
  public typealias RawSignificand = UInt32
  @inlinable
  public static var exponentBitCount: Int {
    return 8
  }
  @inlinable
  public static var significandBitCount: Int {
    return 23
  }
  @inlinable 
  internal static var _infinityExponent: UInt {
    @inline(__always) get { return 1 &<< UInt(exponentBitCount) - 1 }
  }
  @inlinable 
  internal static var _exponentBias: UInt {
    @inline(__always) get { return _infinityExponent &>> 1 }
  }
  @inlinable 
  internal static var _significandMask: UInt32 {
    @inline(__always) get {
      return 1 &<< UInt32(significandBitCount) - 1
    }
  }
  @inlinable 
  internal static var _quietNaNMask: UInt32 {
    @inline(__always) get {
      return 1 &<< UInt32(significandBitCount - 1)
    }
  }
  @inlinable
  public var bitPattern: UInt32 {
    return UInt32(Builtin.bitcast_FPIEEE32_Int32(_value))
  }
  @inlinable
  public init(bitPattern: UInt32) {
    self.init(Builtin.bitcast_Int32_FPIEEE32(bitPattern._value))
  }
  @inlinable
  public var sign: FloatingPointSign {
    let shift = Float.significandBitCount + Float.exponentBitCount
    return FloatingPointSign(
      rawValue: Int(bitPattern &>> UInt32(shift))
    )!
  }
  @available(*, unavailable, renamed: "sign")
  public var isSignMinus: Bool { Builtin.unreachable() }
  @inlinable
  public var exponentBitPattern: UInt {
    return UInt(bitPattern &>> UInt32(Float.significandBitCount)) &
      Float._infinityExponent
  }
  @inlinable
  public var significandBitPattern: UInt32 {
    return UInt32(bitPattern) & Float._significandMask
  }
  @inlinable
  public init(
    sign: FloatingPointSign,
    exponentBitPattern: UInt,
    significandBitPattern: UInt32
  ) {
    let signShift = Float.significandBitCount + Float.exponentBitCount
    let sign = UInt32(sign == .minus ? 1 : 0)
    let exponent = UInt32(
      exponentBitPattern & Float._infinityExponent
    )
    let significand = UInt32(
      significandBitPattern & Float._significandMask
    )
    self.init(bitPattern:
      sign &<< UInt32(signShift) |
      exponent &<< UInt32(Float.significandBitCount) |
      significand
    )
  }
  @inlinable
  public var isCanonical: Bool {
    if Self.leastNonzeroMagnitude == Self.leastNormalMagnitude {
      if exponentBitPattern == 0 && significandBitPattern != 0 {
        return false
      }
    }
    return true
  }
  @inlinable
  public static var infinity: Float {
    return Float(bitPattern: 0x7f800000)
  }
  @inlinable
  public static var nan: Float {
    return Float(bitPattern: 0x7fc00000)
  }
  @inlinable
  public static var signalingNaN: Float {
    return Float(nan: 0, signaling: true)
  }
  @available(*, unavailable, renamed: "nan")
  public static var quietNaN: Float { Builtin.unreachable() }
  @inlinable
  public static var greatestFiniteMagnitude: Float {
    return 0x1.fffffep127
  }
  @inlinable
  public static var pi: Float {
    return 0x1.921fb4p1
  }
  @inlinable
  public var ulp: Float {
    guard _fastPath(isFinite) else { return .nan }
    if _fastPath(isNormal) {
      let bitPattern_ = bitPattern & Float.infinity.bitPattern
      return Float(bitPattern: bitPattern_) * 0x1p-23
    }
    return .leastNormalMagnitude * 0x1p-23
  }
  @inlinable
  public static var leastNormalMagnitude: Float {
    return 0x1.0p-126
  }
  @inlinable
  public static var leastNonzeroMagnitude: Float {
#if arch(arm)
    return leastNormalMagnitude
#else
    return leastNormalMagnitude * ulpOfOne
#endif
  }
  @inlinable
  public static var ulpOfOne: Float {
    return 0x1.0p-23
  }
  @inlinable
  public var exponent: Int {
    if !isFinite { return .max }
    if isZero { return .min }
    let provisional = Int(exponentBitPattern) - Int(Float._exponentBias)
    if isNormal { return provisional }
    let shift =
      Float.significandBitCount - significandBitPattern._binaryLogarithm()
    return provisional + 1 - shift
  }
  @inlinable
  public var significand: Float {
    if isNaN { return self }
    if isNormal {
      return Float(sign: .plus,
        exponentBitPattern: Float._exponentBias,
        significandBitPattern: significandBitPattern)
    }
    if isSubnormal {
      let shift =
        Float.significandBitCount - significandBitPattern._binaryLogarithm()
      return Float(
        sign: .plus,
        exponentBitPattern: Float._exponentBias,
        significandBitPattern: significandBitPattern &<< shift
      )
    }
    return Float(
      sign: .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: 0
    )
  }
  @inlinable
  public init(sign: FloatingPointSign, exponent: Int, significand: Float) {
    var result = significand
    if sign == .minus { result = -result }
    if significand.isFinite && !significand.isZero {
      var clamped = exponent
      let leastNormalExponent = 1 - Int(Float._exponentBias)
      let greatestFiniteExponent = Int(Float._exponentBias)
      if clamped < leastNormalExponent {
        clamped = max(clamped, 3*leastNormalExponent)
        while clamped < leastNormalExponent {
          result  *= Float.leastNormalMagnitude
          clamped -= leastNormalExponent
        }
      }
      else if clamped > greatestFiniteExponent {
        clamped = min(clamped, 3*greatestFiniteExponent)
        let step = Float(sign: .plus,
          exponentBitPattern: Float._infinityExponent - 1,
          significandBitPattern: 0)
        while clamped > greatestFiniteExponent {
          result  *= step
          clamped -= greatestFiniteExponent
        }
      }
      let scale = Float(
        sign: .plus,
        exponentBitPattern: UInt(Int(Float._exponentBias) + clamped),
        significandBitPattern: 0
      )
      result = result * scale
    }
    self = result
  }
  @inlinable
  public init(nan payload: RawSignificand, signaling: Bool) {
    _precondition(payload < (Float._quietNaNMask &>> 1),
      "NaN payload is not encodable.")
    var significand = payload
    significand |= Float._quietNaNMask &>> (signaling ? 1 : 0)
    self.init(
      sign: .plus,
      exponentBitPattern: Float._infinityExponent,
      significandBitPattern: significand
    )
  }
  @inlinable
  public var nextUp: Float {
    let x = self + 0
#if arch(arm)
    if _slowPath(x == 0) { return .leastNonzeroMagnitude }
    if _slowPath(x == -.leastNonzeroMagnitude) { return -0.0 }
#endif
    if _fastPath(x < .infinity) {
      let increment = Int32(bitPattern: x.bitPattern) &>> 31 | 1
      let bitPattern_ = x.bitPattern &+ UInt32(bitPattern: increment)
      return Float(bitPattern: bitPattern_)
    }
    return x
  }
  public init(signOf sign: Float, magnitudeOf mag: Float) {
    _value = Builtin.int_copysign_FPIEEE32(mag._value, sign._value)
  }
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    switch rule {
    case .toNearestOrAwayFromZero:
      _value = Builtin.int_round_FPIEEE32(_value)
    case .toNearestOrEven:
      _value = Builtin.int_rint_FPIEEE32(_value)
    case .towardZero:
      _value = Builtin.int_trunc_FPIEEE32(_value)
    case .awayFromZero:
      if sign == .minus {
        _value = Builtin.int_floor_FPIEEE32(_value)
      }
      else {
        _value = Builtin.int_ceil_FPIEEE32(_value)
      }
    case .up:
      _value = Builtin.int_ceil_FPIEEE32(_value)
    case .down:
      _value = Builtin.int_floor_FPIEEE32(_value)
    @unknown default:
      self._roundSlowPath(rule)
    }
  }
  @usableFromInline
  internal mutating func _roundSlowPath(_ rule: FloatingPointRoundingRule) {
    self.round(rule)
  }
  public mutating func negate() {
    _value = Builtin.fneg_FPIEEE32(self._value)
  }
  public static func +=(lhs: inout Float, rhs: Float) {
    lhs._value = Builtin.fadd_FPIEEE32(lhs._value, rhs._value)
  }
  public static func -=(lhs: inout Float, rhs: Float) {
    lhs._value = Builtin.fsub_FPIEEE32(lhs._value, rhs._value)
  }
  public static func *=(lhs: inout Float, rhs: Float) {
    lhs._value = Builtin.fmul_FPIEEE32(lhs._value, rhs._value)
  }
  public static func /=(lhs: inout Float, rhs: Float) {
    lhs._value = Builtin.fdiv_FPIEEE32(lhs._value, rhs._value)
  }
  @inlinable 
  @inline(__always)
  public mutating func formRemainder(dividingBy other: Float) {
    self = _stdlib_remainderf(self, other)
  }
  @inlinable 
  @inline(__always)
  public mutating func formTruncatingRemainder(dividingBy other: Float) {
    _value = Builtin.frem_FPIEEE32(self._value, other._value)
  }
  public mutating func formSquareRoot( ) {
    self = _stdlib_squareRootf(self)
  }
  public mutating func addProduct(_ lhs: Float, _ rhs: Float) {
    _value = Builtin.int_fma_FPIEEE32(lhs._value, rhs._value, _value)
  }
  public func isEqual(to other: Float) -> Bool {
    return Bool(Builtin.fcmp_oeq_FPIEEE32(self._value, other._value))
  }
  public func isLess(than other: Float) -> Bool {
    return Bool(Builtin.fcmp_olt_FPIEEE32(self._value, other._value))
  }
  public func isLessThanOrEqualTo(_ other: Float) -> Bool {
    return Bool(Builtin.fcmp_ole_FPIEEE32(self._value, other._value))
  }
  @inlinable 
  public var isNormal: Bool {
    @inline(__always)
    get {
      return exponentBitPattern > 0 && isFinite
    }
  }
  @inlinable 
  public var isFinite: Bool {
    @inline(__always)
    get {
      return exponentBitPattern < Float._infinityExponent
    }
  }
  @inlinable 
  public var isZero: Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isSubnormal:  Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isInfinite:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isNaN:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isSignalingNaN: Bool {
    @inline(__always)
    get {
      return isNaN && (significandBitPattern & Float._quietNaNMask) == 0
    }
  }
  @inlinable
  public var binade: Float {
    guard _fastPath(isFinite) else { return .nan }
#if !arch(arm)
    if _slowPath(isSubnormal) {
      let bitPattern_ =
        (self * 0x1p23).bitPattern
          & (-Float.infinity).bitPattern
      return Float(bitPattern: bitPattern_) * 0x1p-23
    }
#endif
    return Float(bitPattern: bitPattern & (-Float.infinity).bitPattern)
  }
  @inlinable
  public var significandWidth: Int {
    let trailingZeroBits = significandBitPattern.trailingZeroBitCount
    if isNormal {
      guard significandBitPattern != 0 else { return 0 }
      return Float.significandBitCount &- trailingZeroBits
    }
    if isSubnormal {
      let leadingZeroBits = significandBitPattern.leadingZeroBitCount
      return UInt32.bitWidth &- (trailingZeroBits &+ leadingZeroBits &+ 1)
    }
    return -1
  }
  @inlinable 
  @inline(__always)
  public init(floatLiteral value: Float) {
    self = value
  }
}
extension Float: _ExpressibleByBuiltinIntegerLiteral, ExpressibleByIntegerLiteral {
  public
  init(_builtinIntegerLiteral value: Builtin.IntLiteral){
    self = Float(Builtin.itofp_with_overflow_IntLiteral_FPIEEE32(value))
  }
  public init(integerLiteral value: Int64) {
    self = Float(Builtin.sitofp_Int64_FPIEEE32(value._value))
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
extension Float: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE80) {
    self = Float(Builtin.fptrunc_FPIEEE80_FPIEEE32(value))
  }
}
#else
extension Float: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE64) {
    self = Float(Builtin.fptrunc_FPIEEE64_FPIEEE32(value))
  }
}
#endif
extension Float: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var v = self
    if isZero {
      v = 0
    }
    hasher.combine(v.bitPattern)
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    let v = isZero ? 0 : self
    return Hasher._hash(seed: seed, bytes: UInt64(v.bitPattern), count: 4)
  }
}
extension Float: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _FloatAnyHashableBox(self))
  }
}
extension Float {
  @inlinable 
  public var magnitude: Float {
    @inline(__always)
    get {
      return Float(Builtin.int_fabs_FPIEEE32(_value))
    }
  }
}
extension Float {
  public static prefix func - (x: Float) -> Float {
    return Float(Builtin.fneg_FPIEEE32(x._value))
  }
}
extension Float: Sendable { }
extension Float {
  public init(_ v: Int) {
    _value = Builtin.sitofp_Int64_FPIEEE32(v._value)
  }
  @inlinable 
  @inline(__always)
  public init<Source: BinaryInteger>(_ value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let asInt = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE32(asInt._value)
      } else {
        let asUInt = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE32(asUInt._value)
      }
    } else {
      self = Float._convert(from: value).value
    }
  }
  public init?<Source: BinaryInteger>(exactly value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let extended = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE32(extended._value)
        guard self < 0x1.0p63 && Int(self) == extended else {
          return nil
        }
      } else {
        let extended = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE32(extended._value)
        guard self < 0x1.0p64 && UInt(self) == extended else {
          return nil
        }
      }
    } else {
      let (value_, exact) = Self._convert(from: value)
      guard exact else { return nil }
      self = value_
    }
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  @inlinable 
  @inline(__always)
  public init(_ other: Float16) {
    _value = Builtin.fpext_FPIEEE16_FPIEEE32(other._value)
  }
  @available(SwiftStdlib 5.3, *)
  @inlinable
  @inline(__always)
  public init?(exactly other: Float16) {
    self.init(other)
    if Float16(self) != other {
      return nil
    }
  }
#endif
  @inlinable 
  @inline(__always)
  public init(_ other: Float) {
    _value = other._value
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float) {
    self.init(other)
    if Float(self) != other {
      return nil
    }
  }
  @inlinable 
  @inline(__always)
  public init(_ other: Double) {
    _value = Builtin.fptrunc_FPIEEE64_FPIEEE32(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Double) {
    self.init(other)
    if Double(self) != other {
      return nil
    }
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  @inlinable 
  @inline(__always)
  public init(_ other: Float80) {
    _value = Builtin.fptrunc_FPIEEE80_FPIEEE32(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float80) {
    self.init(other)
    if Float80(self) != other {
      return nil
    }
  }
#endif
}
extension Float {
  public static func + (lhs: Float, rhs: Float) -> Float {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func - (lhs: Float, rhs: Float) -> Float {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func * (lhs: Float, rhs: Float) -> Float {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func / (lhs: Float, rhs: Float) -> Float {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
}
extension Float: Strideable {
  public func distance(to other: Float) -> Float {
    return other - self
  }
  public func advanced(by amount: Float) -> Float {
    return self + amount
  }
}
internal struct _FloatAnyHashableBox: _AnyHashableBox {
  internal typealias Base = Float
  internal let _value: Base
  internal init(_ value: Base) {
    self._value = value
  }
  internal var _canonicalBox: _AnyHashableBox {
    if _value < 0 {
      if let i = Int64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    } else {
      if let i = UInt64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    }
    if let d = Double(exactly: _value) {
      return _DoubleAnyHashableBox(d)
    }
    return self
  }
  internal func _isEqual(to box: _AnyHashableBox) -> Bool? {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    if let box = box as? _FloatAnyHashableBox {
      return _value == box._value
    }
    return nil
  }
  internal var _hashValue: Int {
    return _rawHashValue(_seed: 0)
  }
  internal func _hash(into hasher: inout Hasher) {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    hasher.combine(_value)
  }
  internal func _rawHashValue(_seed: Int) -> Int {
    var hasher = Hasher(_seed: _seed)
    _hash(into: &hasher)
    return hasher.finalize()
  }
  internal var _base: Any {
    return _value
  }
  internal func _unbox<T: Hashable>() -> T? {
    return _value as? T
  }
  internal func _downCastConditional<T>(
    into result: UnsafeMutablePointer<T>
  ) -> Bool {
    guard let value = _value as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
@frozen
public struct Double {
  public 
  var _value: Builtin.FPIEEE64
  public init() {
    let zero: Int64 = 0
    self._value = Builtin.sitofp_Int64_FPIEEE64(zero._value)
  }
  public 
  init(_ _value: Builtin.FPIEEE64) {
    self._value = _value
  }
}
extension Double: CustomStringConvertible {
  public var description: String {
    if isNaN {
      return "nan"
    } else {
      var (buffer, length) = _float64ToString(self, debug: false)
      return buffer.withBytes { (bufferPtr) in
        String._fromASCII(
          UnsafeBufferPointer(start: bufferPtr, count: length))
      }
    }
  }
}
extension Double: CustomDebugStringConvertible {
  public var debugDescription: String {
    var (buffer, length) = _float64ToString(self, debug: true)
    return buffer.withBytes { (bufferPtr) in
      String._fromASCII(
        UnsafeBufferPointer(start: bufferPtr, count: length))
    }
  }
}
extension Double: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    var (buffer, length) = _float64ToString(self, debug: true)
    buffer.withBytes { (bufferPtr) in
      let bufPtr = UnsafeBufferPointer(start: bufferPtr, count: length)
      target._writeASCII(bufPtr)
    }
  }
}
extension Double: BinaryFloatingPoint {
  public typealias Magnitude = Double
  public typealias Exponent = Int
  public typealias RawSignificand = UInt64
  @inlinable
  public static var exponentBitCount: Int {
    return 11
  }
  @inlinable
  public static var significandBitCount: Int {
    return 52
  }
  @inlinable 
  internal static var _infinityExponent: UInt {
    @inline(__always) get { return 1 &<< UInt(exponentBitCount) - 1 }
  }
  @inlinable 
  internal static var _exponentBias: UInt {
    @inline(__always) get { return _infinityExponent &>> 1 }
  }
  @inlinable 
  internal static var _significandMask: UInt64 {
    @inline(__always) get {
      return 1 &<< UInt64(significandBitCount) - 1
    }
  }
  @inlinable 
  internal static var _quietNaNMask: UInt64 {
    @inline(__always) get {
      return 1 &<< UInt64(significandBitCount - 1)
    }
  }
  @inlinable
  public var bitPattern: UInt64 {
    return UInt64(Builtin.bitcast_FPIEEE64_Int64(_value))
  }
  @inlinable
  public init(bitPattern: UInt64) {
    self.init(Builtin.bitcast_Int64_FPIEEE64(bitPattern._value))
  }
  @inlinable
  public var sign: FloatingPointSign {
    let shift = Double.significandBitCount + Double.exponentBitCount
    return FloatingPointSign(
      rawValue: Int(bitPattern &>> UInt64(shift))
    )!
  }
  @available(*, unavailable, renamed: "sign")
  public var isSignMinus: Bool { Builtin.unreachable() }
  @inlinable
  public var exponentBitPattern: UInt {
    return UInt(bitPattern &>> UInt64(Double.significandBitCount)) &
      Double._infinityExponent
  }
  @inlinable
  public var significandBitPattern: UInt64 {
    return UInt64(bitPattern) & Double._significandMask
  }
  @inlinable
  public init(
    sign: FloatingPointSign,
    exponentBitPattern: UInt,
    significandBitPattern: UInt64
  ) {
    let signShift = Double.significandBitCount + Double.exponentBitCount
    let sign = UInt64(sign == .minus ? 1 : 0)
    let exponent = UInt64(
      exponentBitPattern & Double._infinityExponent
    )
    let significand = UInt64(
      significandBitPattern & Double._significandMask
    )
    self.init(bitPattern:
      sign &<< UInt64(signShift) |
      exponent &<< UInt64(Double.significandBitCount) |
      significand
    )
  }
  @inlinable
  public var isCanonical: Bool {
    if Self.leastNonzeroMagnitude == Self.leastNormalMagnitude {
      if exponentBitPattern == 0 && significandBitPattern != 0 {
        return false
      }
    }
    return true
  }
  @inlinable
  public static var infinity: Double {
    return Double(bitPattern: 0x7ff0000000000000)
  }
  @inlinable
  public static var nan: Double {
    return Double(bitPattern: 0x7ff8000000000000)
  }
  @inlinable
  public static var signalingNaN: Double {
    return Double(nan: 0, signaling: true)
  }
  @available(*, unavailable, renamed: "nan")
  public static var quietNaN: Double { Builtin.unreachable() }
  @inlinable
  public static var greatestFiniteMagnitude: Double {
    return 0x1.fffffffffffffp1023
  }
  @inlinable
  public static var pi: Double {
    return 0x1.921fb54442d18p1
  }
  @inlinable
  public var ulp: Double {
    guard _fastPath(isFinite) else { return .nan }
    if _fastPath(isNormal) {
      let bitPattern_ = bitPattern & Double.infinity.bitPattern
      return Double(bitPattern: bitPattern_) * 0x1p-52
    }
    return .leastNormalMagnitude * 0x1p-52
  }
  @inlinable
  public static var leastNormalMagnitude: Double {
    return 0x1.0p-1022
  }
  @inlinable
  public static var leastNonzeroMagnitude: Double {
#if arch(arm)
    return leastNormalMagnitude
#else
    return leastNormalMagnitude * ulpOfOne
#endif
  }
  @inlinable
  public static var ulpOfOne: Double {
    return 0x1.0p-52
  }
  @inlinable
  public var exponent: Int {
    if !isFinite { return .max }
    if isZero { return .min }
    let provisional = Int(exponentBitPattern) - Int(Double._exponentBias)
    if isNormal { return provisional }
    let shift =
      Double.significandBitCount - significandBitPattern._binaryLogarithm()
    return provisional + 1 - shift
  }
  @inlinable
  public var significand: Double {
    if isNaN { return self }
    if isNormal {
      return Double(sign: .plus,
        exponentBitPattern: Double._exponentBias,
        significandBitPattern: significandBitPattern)
    }
    if isSubnormal {
      let shift =
        Double.significandBitCount - significandBitPattern._binaryLogarithm()
      return Double(
        sign: .plus,
        exponentBitPattern: Double._exponentBias,
        significandBitPattern: significandBitPattern &<< shift
      )
    }
    return Double(
      sign: .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: 0
    )
  }
  @inlinable
  public init(sign: FloatingPointSign, exponent: Int, significand: Double) {
    var result = significand
    if sign == .minus { result = -result }
    if significand.isFinite && !significand.isZero {
      var clamped = exponent
      let leastNormalExponent = 1 - Int(Double._exponentBias)
      let greatestFiniteExponent = Int(Double._exponentBias)
      if clamped < leastNormalExponent {
        clamped = max(clamped, 3*leastNormalExponent)
        while clamped < leastNormalExponent {
          result  *= Double.leastNormalMagnitude
          clamped -= leastNormalExponent
        }
      }
      else if clamped > greatestFiniteExponent {
        clamped = min(clamped, 3*greatestFiniteExponent)
        let step = Double(sign: .plus,
          exponentBitPattern: Double._infinityExponent - 1,
          significandBitPattern: 0)
        while clamped > greatestFiniteExponent {
          result  *= step
          clamped -= greatestFiniteExponent
        }
      }
      let scale = Double(
        sign: .plus,
        exponentBitPattern: UInt(Int(Double._exponentBias) + clamped),
        significandBitPattern: 0
      )
      result = result * scale
    }
    self = result
  }
  @inlinable
  public init(nan payload: RawSignificand, signaling: Bool) {
    _precondition(payload < (Double._quietNaNMask &>> 1),
      "NaN payload is not encodable.")
    var significand = payload
    significand |= Double._quietNaNMask &>> (signaling ? 1 : 0)
    self.init(
      sign: .plus,
      exponentBitPattern: Double._infinityExponent,
      significandBitPattern: significand
    )
  }
  @inlinable
  public var nextUp: Double {
    let x = self + 0
#if arch(arm)
    if _slowPath(x == 0) { return .leastNonzeroMagnitude }
    if _slowPath(x == -.leastNonzeroMagnitude) { return -0.0 }
#endif
    if _fastPath(x < .infinity) {
      let increment = Int64(bitPattern: x.bitPattern) &>> 63 | 1
      let bitPattern_ = x.bitPattern &+ UInt64(bitPattern: increment)
      return Double(bitPattern: bitPattern_)
    }
    return x
  }
  public init(signOf sign: Double, magnitudeOf mag: Double) {
    _value = Builtin.int_copysign_FPIEEE64(mag._value, sign._value)
  }
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    switch rule {
    case .toNearestOrAwayFromZero:
      _value = Builtin.int_round_FPIEEE64(_value)
    case .toNearestOrEven:
      _value = Builtin.int_rint_FPIEEE64(_value)
    case .towardZero:
      _value = Builtin.int_trunc_FPIEEE64(_value)
    case .awayFromZero:
      if sign == .minus {
        _value = Builtin.int_floor_FPIEEE64(_value)
      }
      else {
        _value = Builtin.int_ceil_FPIEEE64(_value)
      }
    case .up:
      _value = Builtin.int_ceil_FPIEEE64(_value)
    case .down:
      _value = Builtin.int_floor_FPIEEE64(_value)
    @unknown default:
      self._roundSlowPath(rule)
    }
  }
  @usableFromInline
  internal mutating func _roundSlowPath(_ rule: FloatingPointRoundingRule) {
    self.round(rule)
  }
  public mutating func negate() {
    _value = Builtin.fneg_FPIEEE64(self._value)
  }
  public static func +=(lhs: inout Double, rhs: Double) {
    lhs._value = Builtin.fadd_FPIEEE64(lhs._value, rhs._value)
  }
  public static func -=(lhs: inout Double, rhs: Double) {
    lhs._value = Builtin.fsub_FPIEEE64(lhs._value, rhs._value)
  }
  public static func *=(lhs: inout Double, rhs: Double) {
    lhs._value = Builtin.fmul_FPIEEE64(lhs._value, rhs._value)
  }
  public static func /=(lhs: inout Double, rhs: Double) {
    lhs._value = Builtin.fdiv_FPIEEE64(lhs._value, rhs._value)
  }
  @inlinable 
  @inline(__always)
  public mutating func formRemainder(dividingBy other: Double) {
    self = _stdlib_remainder(self, other)
  }
  @inlinable 
  @inline(__always)
  public mutating func formTruncatingRemainder(dividingBy other: Double) {
    _value = Builtin.frem_FPIEEE64(self._value, other._value)
  }
  public mutating func formSquareRoot( ) {
    self = _stdlib_squareRoot(self)
  }
  public mutating func addProduct(_ lhs: Double, _ rhs: Double) {
    _value = Builtin.int_fma_FPIEEE64(lhs._value, rhs._value, _value)
  }
  public func isEqual(to other: Double) -> Bool {
    return Bool(Builtin.fcmp_oeq_FPIEEE64(self._value, other._value))
  }
  public func isLess(than other: Double) -> Bool {
    return Bool(Builtin.fcmp_olt_FPIEEE64(self._value, other._value))
  }
  public func isLessThanOrEqualTo(_ other: Double) -> Bool {
    return Bool(Builtin.fcmp_ole_FPIEEE64(self._value, other._value))
  }
  @inlinable 
  public var isNormal: Bool {
    @inline(__always)
    get {
      return exponentBitPattern > 0 && isFinite
    }
  }
  @inlinable 
  public var isFinite: Bool {
    @inline(__always)
    get {
      return exponentBitPattern < Double._infinityExponent
    }
  }
  @inlinable 
  public var isZero: Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isSubnormal:  Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isInfinite:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isNaN:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isSignalingNaN: Bool {
    @inline(__always)
    get {
      return isNaN && (significandBitPattern & Double._quietNaNMask) == 0
    }
  }
  @inlinable
  public var binade: Double {
    guard _fastPath(isFinite) else { return .nan }
#if !arch(arm)
    if _slowPath(isSubnormal) {
      let bitPattern_ =
        (self * 0x1p52).bitPattern
          & (-Double.infinity).bitPattern
      return Double(bitPattern: bitPattern_) * 0x1p-52
    }
#endif
    return Double(bitPattern: bitPattern & (-Double.infinity).bitPattern)
  }
  @inlinable
  public var significandWidth: Int {
    let trailingZeroBits = significandBitPattern.trailingZeroBitCount
    if isNormal {
      guard significandBitPattern != 0 else { return 0 }
      return Double.significandBitCount &- trailingZeroBits
    }
    if isSubnormal {
      let leadingZeroBits = significandBitPattern.leadingZeroBitCount
      return UInt64.bitWidth &- (trailingZeroBits &+ leadingZeroBits &+ 1)
    }
    return -1
  }
  @inlinable 
  @inline(__always)
  public init(floatLiteral value: Double) {
    self = value
  }
}
extension Double: _ExpressibleByBuiltinIntegerLiteral, ExpressibleByIntegerLiteral {
  public
  init(_builtinIntegerLiteral value: Builtin.IntLiteral){
    self = Double(Builtin.itofp_with_overflow_IntLiteral_FPIEEE64(value))
  }
  public init(integerLiteral value: Int64) {
    self = Double(Builtin.sitofp_Int64_FPIEEE64(value._value))
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
extension Double: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE80) {
    self = Double(Builtin.fptrunc_FPIEEE80_FPIEEE64(value))
  }
}
#else
extension Double: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE64) {
    self = Double(value)
  }
}
#endif
extension Double: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var v = self
    if isZero {
      v = 0
    }
    hasher.combine(v.bitPattern)
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    let v = isZero ? 0 : self
    return Hasher._hash(seed: seed, v.bitPattern)
  }
}
extension Double: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _DoubleAnyHashableBox(self))
  }
}
extension Double {
  @inlinable 
  public var magnitude: Double {
    @inline(__always)
    get {
      return Double(Builtin.int_fabs_FPIEEE64(_value))
    }
  }
}
extension Double {
  public static prefix func - (x: Double) -> Double {
    return Double(Builtin.fneg_FPIEEE64(x._value))
  }
}
extension Double: Sendable { }
extension Double {
  public init(_ v: Int) {
    _value = Builtin.sitofp_Int64_FPIEEE64(v._value)
  }
  @inlinable 
  @inline(__always)
  public init<Source: BinaryInteger>(_ value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let asInt = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE64(asInt._value)
      } else {
        let asUInt = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE64(asUInt._value)
      }
    } else {
      self = Double._convert(from: value).value
    }
  }
  public init?<Source: BinaryInteger>(exactly value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let extended = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE64(extended._value)
        guard self < 0x1.0p63 && Int(self) == extended else {
          return nil
        }
      } else {
        let extended = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE64(extended._value)
        guard self < 0x1.0p64 && UInt(self) == extended else {
          return nil
        }
      }
    } else {
      let (value_, exact) = Self._convert(from: value)
      guard exact else { return nil }
      self = value_
    }
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  @inlinable 
  @inline(__always)
  public init(_ other: Float16) {
    _value = Builtin.fpext_FPIEEE16_FPIEEE64(other._value)
  }
  @available(SwiftStdlib 5.3, *)
  @inlinable
  @inline(__always)
  public init?(exactly other: Float16) {
    self.init(other)
    if Float16(self) != other {
      return nil
    }
  }
#endif
  @inlinable 
  @inline(__always)
  public init(_ other: Float) {
    _value = Builtin.fpext_FPIEEE32_FPIEEE64(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float) {
    self.init(other)
    if Float(self) != other {
      return nil
    }
  }
  @inlinable 
  @inline(__always)
  public init(_ other: Double) {
    _value = other._value
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Double) {
    self.init(other)
    if Double(self) != other {
      return nil
    }
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  @inlinable 
  @inline(__always)
  public init(_ other: Float80) {
    _value = Builtin.fptrunc_FPIEEE80_FPIEEE64(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float80) {
    self.init(other)
    if Float80(self) != other {
      return nil
    }
  }
#endif
}
extension Double {
  public static func + (lhs: Double, rhs: Double) -> Double {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func - (lhs: Double, rhs: Double) -> Double {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func * (lhs: Double, rhs: Double) -> Double {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func / (lhs: Double, rhs: Double) -> Double {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
}
extension Double: Strideable {
  public func distance(to other: Double) -> Double {
    return other - self
  }
  public func advanced(by amount: Double) -> Double {
    return self + amount
  }
}
internal struct _DoubleAnyHashableBox: _AnyHashableBox {
  internal typealias Base = Double
  internal let _value: Base
  internal init(_ value: Base) {
    self._value = value
  }
  internal var _canonicalBox: _AnyHashableBox {
    if _value < 0 {
      if let i = Int64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    } else {
      if let i = UInt64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    }
    if let d = Double(exactly: _value) {
      return _DoubleAnyHashableBox(d)
    }
    return self
  }
  internal func _isEqual(to box: _AnyHashableBox) -> Bool? {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    if let box = box as? _DoubleAnyHashableBox {
      return _value == box._value
    }
    return nil
  }
  internal var _hashValue: Int {
    return _rawHashValue(_seed: 0)
  }
  internal func _hash(into hasher: inout Hasher) {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    hasher.combine(_value)
  }
  internal func _rawHashValue(_seed: Int) -> Int {
    var hasher = Hasher(_seed: _seed)
    _hash(into: &hasher)
    return hasher.finalize()
  }
  internal var _base: Any {
    return _value
  }
  internal func _unbox<T: Hashable>() -> T? {
    return _value as? T
  }
  internal func _downCastConditional<T>(
    into result: UnsafeMutablePointer<T>
  ) -> Bool {
    guard let value = _value as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
@frozen
public struct Float80 {
  public 
  var _value: Builtin.FPIEEE80
  public init() {
    let zero: Int64 = 0
    self._value = Builtin.sitofp_Int64_FPIEEE80(zero._value)
  }
  public 
  init(_ _value: Builtin.FPIEEE80) {
    self._value = _value
  }
}
extension Float80: CustomStringConvertible {
  public var description: String {
    if isNaN {
      return "nan"
    } else {
      var (buffer, length) = _float80ToString(self, debug: false)
      return buffer.withBytes { (bufferPtr) in
        String._fromASCII(
          UnsafeBufferPointer(start: bufferPtr, count: length))
      }
    }
  }
}
extension Float80: CustomDebugStringConvertible {
  public var debugDescription: String {
    var (buffer, length) = _float80ToString(self, debug: true)
    return buffer.withBytes { (bufferPtr) in
      String._fromASCII(
        UnsafeBufferPointer(start: bufferPtr, count: length))
    }
  }
}
extension Float80: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    var (buffer, length) = _float80ToString(self, debug: true)
    buffer.withBytes { (bufferPtr) in
      let bufPtr = UnsafeBufferPointer(start: bufferPtr, count: length)
      target._writeASCII(bufPtr)
    }
  }
}
extension Float80: BinaryFloatingPoint {
  public typealias Magnitude = Float80
  public typealias Exponent = Int
  public typealias RawSignificand = UInt64
  @inlinable
  public static var exponentBitCount: Int {
    return 15
  }
  @inlinable
  public static var significandBitCount: Int {
    return 63
  }
  @inlinable 
  internal static var _infinityExponent: UInt {
    @inline(__always) get { return 1 &<< UInt(exponentBitCount) - 1 }
  }
  @inlinable 
  internal static var _exponentBias: UInt {
    @inline(__always) get { return _infinityExponent &>> 1 }
  }
  @inlinable 
  internal static var _significandMask: UInt64 {
    @inline(__always) get {
      return 1 &<< UInt64(significandBitCount) - 1
    }
  }
  @inlinable 
  internal static var _quietNaNMask: UInt64 {
    @inline(__always) get {
      return 1 &<< UInt64(significandBitCount - 1)
    }
  }
  @frozen
  @usableFromInline
  internal struct _Representation {
    @usableFromInline
    internal var _storage: (UInt64, UInt16,  UInt16, UInt16, UInt16)
    @usableFromInline
    internal init(explicitSignificand: UInt64, signAndExponent: UInt16) {
      _storage = (explicitSignificand, signAndExponent, 0, 0, 0)
    }
    @usableFromInline
    internal var explicitSignificand: UInt64 { return _storage.0 }
    @usableFromInline
    internal var signAndExponent: UInt16 { return _storage.1 }
    @usableFromInline
    internal var sign: FloatingPointSign {
      return FloatingPointSign(rawValue: Int(signAndExponent &>> 15))!
    }
    @usableFromInline
    internal var exponentBitPattern: UInt {
      return UInt(signAndExponent) & 0x7fff
    }
  }
  @inlinable
  internal var _representation: _Representation {
    return unsafeBitCast(self, to: _Representation.self)
  }
  @inlinable
  public var sign: FloatingPointSign {
    return _representation.sign
  }
  @inlinable
  internal static var _explicitBitMask: UInt64 {
    @inline(__always) get { return 1 &<< 63 }
  }
  @inlinable
  public var exponentBitPattern: UInt {
    let provisional = _representation.exponentBitPattern
    if provisional == 0 {
      if _representation.explicitSignificand >= Float80._explicitBitMask {
        return 1
      }
      return 0
    }
    if _representation.explicitSignificand < Float80._explicitBitMask {
      return Float80._infinityExponent
    }
    return provisional
  }
  @inlinable
  public var significandBitPattern: UInt64 {
    if _representation.exponentBitPattern > 0 &&
      _representation.explicitSignificand < Float80._explicitBitMask {
        return _representation.explicitSignificand | Float80._quietNaNMask
    }
    return _representation.explicitSignificand & Float80._significandMask
  }
  @inlinable
  public init(sign: FloatingPointSign,
              exponentBitPattern: UInt,
              significandBitPattern: UInt64) {
    let signBit = UInt16(sign == .minus ? 0x8000 : 0)
    let exponent = UInt16(exponentBitPattern)
    var significand = significandBitPattern
    if exponent != 0 { significand |= Float80._explicitBitMask }
    let rep = _Representation(
      explicitSignificand: significand, signAndExponent: signBit|exponent)
    self = unsafeBitCast(rep, to: Float80.self)
  }
  @inlinable
  public var isCanonical: Bool {
    if exponentBitPattern == 0 {
      return _representation.explicitSignificand < Float80._explicitBitMask
    }
    return _representation.explicitSignificand >= Float80._explicitBitMask
  }
  @inlinable
  public static var infinity: Float80 {
    let rep = _Representation(
      explicitSignificand: Float80._explicitBitMask,
      signAndExponent: 0x7fff
    )
    return unsafeBitCast(rep, to: Float80.self)
  }
  @inlinable
  public static var nan: Float80 {
    let rep = _Representation(
      explicitSignificand: Float80._explicitBitMask | Float80._quietNaNMask,
      signAndExponent: 0x7fff
    )
    return unsafeBitCast(rep, to: Float80.self)
  }
  @inlinable
  public static var signalingNaN: Float80 {
    return Float80(nan: 0, signaling: true)
  }
  @available(*, unavailable, renamed: "nan")
  public static var quietNaN: Float80 { Builtin.unreachable() }
  @inlinable
  public static var greatestFiniteMagnitude: Float80 {
    return 0x1.fffffffffffffffep16383
  }
  @inlinable
  public static var pi: Float80 {
    return 0x1.921fb54442d1846ap1
  }
  @inlinable
  public var ulp: Float80 {
    guard _fastPath(isFinite) else { return .nan }
    if exponentBitPattern > UInt(Float80.significandBitCount) {
      let ulpExponent =
        exponentBitPattern - UInt(Float80.significandBitCount)
      return Float80(
        sign: .plus,
        exponentBitPattern: ulpExponent,
        significandBitPattern: 0
      )
    }
    if exponentBitPattern >= 1 {
      let ulpShift = UInt64(exponentBitPattern - 1)
      return Float80(
        sign: .plus,
        exponentBitPattern: 0,
        significandBitPattern: 1 &<< ulpShift
      )
    }
    return Float80(
      sign: .plus,
      exponentBitPattern: 0,
      significandBitPattern: 1
    )
  }
  @inlinable
  public static var leastNormalMagnitude: Float80 {
    return 0x1.0p-16382
  }
  @inlinable
  public static var leastNonzeroMagnitude: Float80 {
#if arch(arm)
    return leastNormalMagnitude
#else
    return leastNormalMagnitude * ulpOfOne
#endif
  }
  @inlinable
  public static var ulpOfOne: Float80 {
    return 0x1.0p-63
  }
  @inlinable
  public var exponent: Int {
    if !isFinite { return .max }
    if isZero { return .min }
    let provisional = Int(exponentBitPattern) - Int(Float80._exponentBias)
    if isNormal { return provisional }
    let shift =
      Float80.significandBitCount - significandBitPattern._binaryLogarithm()
    return provisional + 1 - shift
  }
  @inlinable
  public var significand: Float80 {
    if isNaN { return self }
    if isNormal {
      return Float80(sign: .plus,
        exponentBitPattern: Float80._exponentBias,
        significandBitPattern: significandBitPattern)
    }
    if isSubnormal {
      let shift =
        Float80.significandBitCount - significandBitPattern._binaryLogarithm()
      return Float80(
        sign: .plus,
        exponentBitPattern: Float80._exponentBias,
        significandBitPattern: significandBitPattern &<< shift
      )
    }
    return Float80(
      sign: .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: 0
    )
  }
  @inlinable
  public init(sign: FloatingPointSign, exponent: Int, significand: Float80) {
    var result = significand
    if sign == .minus { result = -result }
    if significand.isFinite && !significand.isZero {
      var clamped = exponent
      let leastNormalExponent = 1 - Int(Float80._exponentBias)
      let greatestFiniteExponent = Int(Float80._exponentBias)
      if clamped < leastNormalExponent {
        clamped = max(clamped, 3*leastNormalExponent)
        while clamped < leastNormalExponent {
          result  *= Float80.leastNormalMagnitude
          clamped -= leastNormalExponent
        }
      }
      else if clamped > greatestFiniteExponent {
        clamped = min(clamped, 3*greatestFiniteExponent)
        let step = Float80(sign: .plus,
          exponentBitPattern: Float80._infinityExponent - 1,
          significandBitPattern: 0)
        while clamped > greatestFiniteExponent {
          result  *= step
          clamped -= greatestFiniteExponent
        }
      }
      let scale = Float80(
        sign: .plus,
        exponentBitPattern: UInt(Int(Float80._exponentBias) + clamped),
        significandBitPattern: 0
      )
      result = result * scale
    }
    self = result
  }
  @inlinable
  public init(nan payload: RawSignificand, signaling: Bool) {
    _precondition(payload < (Float80._quietNaNMask &>> 1),
      "NaN payload is not encodable.")
    var significand = payload
    significand |= Float80._quietNaNMask &>> (signaling ? 1 : 0)
    self.init(
      sign: .plus,
      exponentBitPattern: Float80._infinityExponent,
      significandBitPattern: significand
    )
  }
  @inlinable
  public var nextUp: Float80 {
    if isNaN {  return self + 0 }
    if sign == .minus {
      if significandBitPattern == 0 {
        if exponentBitPattern == 0 {
          return .leastNonzeroMagnitude
        }
        return Float80(sign: .minus,
          exponentBitPattern: exponentBitPattern - 1,
          significandBitPattern: Float80._significandMask)
      }
      return Float80(sign: .minus,
        exponentBitPattern: exponentBitPattern,
        significandBitPattern: significandBitPattern - 1)
    }
    if isInfinite { return self }
    if significandBitPattern == Float80._significandMask {
      return Float80(sign: .plus,
        exponentBitPattern: exponentBitPattern + 1,
        significandBitPattern: 0)
    }
    return Float80(sign: .plus,
      exponentBitPattern: exponentBitPattern,
      significandBitPattern: significandBitPattern + 1)
  }
  public init(signOf sign: Float80, magnitudeOf mag: Float80) {
    _value = Builtin.int_copysign_FPIEEE80(mag._value, sign._value)
  }
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    switch rule {
    case .toNearestOrAwayFromZero:
      _value = Builtin.int_round_FPIEEE80(_value)
    case .toNearestOrEven:
      _value = Builtin.int_rint_FPIEEE80(_value)
    case .towardZero:
      _value = Builtin.int_trunc_FPIEEE80(_value)
    case .awayFromZero:
      if sign == .minus {
        _value = Builtin.int_floor_FPIEEE80(_value)
      }
      else {
        _value = Builtin.int_ceil_FPIEEE80(_value)
      }
    case .up:
      _value = Builtin.int_ceil_FPIEEE80(_value)
    case .down:
      _value = Builtin.int_floor_FPIEEE80(_value)
    @unknown default:
      self._roundSlowPath(rule)
    }
  }
  @usableFromInline
  internal mutating func _roundSlowPath(_ rule: FloatingPointRoundingRule) {
    self.round(rule)
  }
  public mutating func negate() {
    _value = Builtin.fneg_FPIEEE80(self._value)
  }
  public static func +=(lhs: inout Float80, rhs: Float80) {
    lhs._value = Builtin.fadd_FPIEEE80(lhs._value, rhs._value)
  }
  public static func -=(lhs: inout Float80, rhs: Float80) {
    lhs._value = Builtin.fsub_FPIEEE80(lhs._value, rhs._value)
  }
  public static func *=(lhs: inout Float80, rhs: Float80) {
    lhs._value = Builtin.fmul_FPIEEE80(lhs._value, rhs._value)
  }
  public static func /=(lhs: inout Float80, rhs: Float80) {
    lhs._value = Builtin.fdiv_FPIEEE80(lhs._value, rhs._value)
  }
  @inlinable 
  @inline(__always)
  public mutating func formRemainder(dividingBy other: Float80) {
    self = _stdlib_remainderl(self, other)
  }
  @inlinable 
  @inline(__always)
  public mutating func formTruncatingRemainder(dividingBy other: Float80) {
    _value = Builtin.frem_FPIEEE80(self._value, other._value)
  }
  public mutating func formSquareRoot( ) {
    self = _stdlib_squareRootl(self)
  }
  public mutating func addProduct(_ lhs: Float80, _ rhs: Float80) {
    _value = Builtin.int_fma_FPIEEE80(lhs._value, rhs._value, _value)
  }
  public func isEqual(to other: Float80) -> Bool {
    return Bool(Builtin.fcmp_oeq_FPIEEE80(self._value, other._value))
  }
  public func isLess(than other: Float80) -> Bool {
    return Bool(Builtin.fcmp_olt_FPIEEE80(self._value, other._value))
  }
  public func isLessThanOrEqualTo(_ other: Float80) -> Bool {
    return Bool(Builtin.fcmp_ole_FPIEEE80(self._value, other._value))
  }
  @inlinable 
  public var isNormal: Bool {
    @inline(__always)
    get {
      return exponentBitPattern > 0 && isFinite
    }
  }
  @inlinable 
  public var isFinite: Bool {
    @inline(__always)
    get {
      return exponentBitPattern < Float80._infinityExponent
    }
  }
  @inlinable 
  public var isZero: Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isSubnormal:  Bool {
    @inline(__always)
    get {
      return exponentBitPattern == 0 && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isInfinite:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern == 0
    }
  }
  @inlinable 
  public var isNaN:  Bool {
    @inline(__always)
    get {
      return !isFinite && significandBitPattern != 0
    }
  }
  @inlinable 
  public var isSignalingNaN: Bool {
    @inline(__always)
    get {
      return isNaN && (significandBitPattern & Float80._quietNaNMask) == 0
    }
  }
  @inlinable
  public var binade: Float80 {
    guard _fastPath(isFinite) else { return .nan }
    if exponentBitPattern != 0 {
      return Float80(sign: sign, exponentBitPattern: exponentBitPattern,
        significandBitPattern: 0)
    }
    if significandBitPattern == 0 { return self }
    let index = significandBitPattern._binaryLogarithm()
    return Float80(sign: sign, exponentBitPattern: 0,
      significandBitPattern: 1 &<< index)
  }
  @inlinable
  public var significandWidth: Int {
    let trailingZeroBits = significandBitPattern.trailingZeroBitCount
    if isNormal {
      guard significandBitPattern != 0 else { return 0 }
      return Float80.significandBitCount &- trailingZeroBits
    }
    if isSubnormal {
      let leadingZeroBits = significandBitPattern.leadingZeroBitCount
      return UInt64.bitWidth &- (trailingZeroBits &+ leadingZeroBits &+ 1)
    }
    return -1
  }
  @inlinable 
  @inline(__always)
  public init(floatLiteral value: Float80) {
    self = value
  }
}
extension Float80: _ExpressibleByBuiltinIntegerLiteral, ExpressibleByIntegerLiteral {
  public
  init(_builtinIntegerLiteral value: Builtin.IntLiteral){
    self = Float80(Builtin.itofp_with_overflow_IntLiteral_FPIEEE80(value))
  }
  public init(integerLiteral value: Int64) {
    self = Float80(Builtin.sitofp_Int64_FPIEEE80(value._value))
  }
}
extension Float80: _ExpressibleByBuiltinFloatLiteral {
  public
  init(_builtinFloatLiteral value: Builtin.FPIEEE80) {
    self = Float80(value)
  }
}
extension Float80: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var v = self
    if isZero {
      v = 0
    }
    hasher.combine(v._representation.signAndExponent)
    hasher.combine(v.significandBitPattern)
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    let v = isZero ? 0 : self
    var hasher = Hasher(_seed: seed)
    hasher.combine(v._representation.signAndExponent)
    hasher.combine(v.significandBitPattern)
    return hasher._finalize()
  }
}
extension Float80: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _Float80AnyHashableBox(self))
  }
}
extension Float80 {
  @inlinable 
  public var magnitude: Float80 {
    @inline(__always)
    get {
      return Float80(Builtin.int_fabs_FPIEEE80(_value))
    }
  }
}
extension Float80 {
  public static prefix func - (x: Float80) -> Float80 {
    return Float80(Builtin.fneg_FPIEEE80(x._value))
  }
}
extension Float80: Sendable { }
extension Float80 {
  public init(_ v: Int) {
    _value = Builtin.sitofp_Int64_FPIEEE80(v._value)
  }
  @inlinable 
  @inline(__always)
  public init<Source: BinaryInteger>(_ value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let asInt = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE80(asInt._value)
      } else {
        let asUInt = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE80(asUInt._value)
      }
    } else {
      self = Float80._convert(from: value).value
    }
  }
  public init?<Source: BinaryInteger>(exactly value: Source) {
    if value.bitWidth <= 64 {
      if Source.isSigned {
        let extended = Int(truncatingIfNeeded: value)
        _value = Builtin.sitofp_Int64_FPIEEE80(extended._value)
        guard self < 0x1.0p63 && Int(self) == extended else {
          return nil
        }
      } else {
        let extended = UInt(truncatingIfNeeded: value)
        _value = Builtin.uitofp_Int64_FPIEEE80(extended._value)
        guard self < 0x1.0p64 && UInt(self) == extended else {
          return nil
        }
      }
    } else {
      let (value_, exact) = Self._convert(from: value)
      guard exact else { return nil }
      self = value_
    }
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  @inlinable 
  @inline(__always)
  public init(_ other: Float16) {
    _value = Builtin.fpext_FPIEEE16_FPIEEE80(other._value)
  }
  @available(SwiftStdlib 5.3, *)
  @inlinable
  @inline(__always)
  public init?(exactly other: Float16) {
    self.init(other)
    if Float16(self) != other {
      return nil
    }
  }
#endif
  @inlinable 
  @inline(__always)
  public init(_ other: Float) {
    _value = Builtin.fpext_FPIEEE32_FPIEEE80(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float) {
    self.init(other)
    if Float(self) != other {
      return nil
    }
  }
  @inlinable 
  @inline(__always)
  public init(_ other: Double) {
    _value = Builtin.fpext_FPIEEE64_FPIEEE80(other._value)
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Double) {
    self.init(other)
    if Double(self) != other {
      return nil
    }
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  @inlinable 
  @inline(__always)
  public init(_ other: Float80) {
    _value = other._value
  }
  @inlinable
  @inline(__always)
  public init?(exactly other: Float80) {
    self.init(other)
    if Float80(self) != other {
      return nil
    }
  }
#endif
}
extension Float80 {
  public static func + (lhs: Float80, rhs: Float80) -> Float80 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func - (lhs: Float80, rhs: Float80) -> Float80 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func * (lhs: Float80, rhs: Float80) -> Float80 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func / (lhs: Float80, rhs: Float80) -> Float80 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
}
extension Float80: Strideable {
  public func distance(to other: Float80) -> Float80 {
    return other - self
  }
  public func advanced(by amount: Float80) -> Float80 {
    return self + amount
  }
}
internal struct _Float80AnyHashableBox: _AnyHashableBox {
  internal typealias Base = Float80
  internal let _value: Base
  internal init(_ value: Base) {
    self._value = value
  }
  internal var _canonicalBox: _AnyHashableBox {
    if _value < 0 {
      if let i = Int64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    } else {
      if let i = UInt64(exactly: _value) {
        return _IntegerAnyHashableBox(i)
      }
    }
    if let d = Double(exactly: _value) {
      return _DoubleAnyHashableBox(d)
    }
    return self
  }
  internal func _isEqual(to box: _AnyHashableBox) -> Bool? {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    if let box = box as? _Float80AnyHashableBox {
      return _value == box._value
    }
    return nil
  }
  internal var _hashValue: Int {
    return _rawHashValue(_seed: 0)
  }
  internal func _hash(into hasher: inout Hasher) {
    _internalInvariant(Int64(exactly: _value) == nil, "self isn't canonical")
    _internalInvariant(UInt64(exactly: _value) == nil, "self isn't canonical")
    hasher.combine(_value)
  }
  internal func _rawHashValue(_seed: Int) -> Int {
    var hasher = Hasher(_seed: _seed)
    _hash(into: &hasher)
    return hasher.finalize()
  }
  internal var _base: Any {
    return _value
  }
  internal func _unbox<T: Hashable>() -> T? {
    return _value as? T
  }
  internal func _downCastConditional<T>(
    into result: UnsafeMutablePointer<T>
  ) -> Bool {
    guard let value = _value as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
#else
@frozen
@available(*, unavailable, message: "Float80 is not available on target platform.")
public struct Float80 {
  public init() {
    fatalError("Float80 is not available")
  }
}
#endif
@available(*, unavailable,
  message: "For floating point numbers use truncatingRemainder instead")
public func % <T: BinaryFloatingPoint>(lhs: T, rhs: T) -> T {
  fatalError("% is not available.")
}
@available(*, unavailable,
  message: "For floating point numbers use formTruncatingRemainder instead")
public func %= <T: BinaryFloatingPoint> (lhs: inout T, rhs: T) {
  fatalError("%= is not available.")
}
