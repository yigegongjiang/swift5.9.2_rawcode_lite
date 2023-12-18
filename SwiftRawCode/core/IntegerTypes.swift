@frozen
public struct UInt8
  : FixedWidthInteger, UnsignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = UInt8
  public var _value: Builtin.Int8
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_u_checked_trunc_IntLiteral_Int8(x).0
  }
  public init(bitPattern x: Int8) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to UInt8 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float16 value cannot be converted to UInt8 because the result would be less than UInt8.min")
    _precondition(source < 256.0,
      "Float16 value cannot be converted to UInt8 because the result would be greater than UInt8.max")
    self._value = Builtin.fptoui_FPIEEE16_Int8(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -1.0 && source < 256.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE16_Int8(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to UInt8 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float value cannot be converted to UInt8 because the result would be less than UInt8.min")
    _precondition(source < 256.0,
      "Float value cannot be converted to UInt8 because the result would be greater than UInt8.max")
    self._value = Builtin.fptoui_FPIEEE32_Int8(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -1.0 && source < 256.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE32_Int8(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to UInt8 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Double value cannot be converted to UInt8 because the result would be less than UInt8.min")
    _precondition(source < 256.0,
      "Double value cannot be converted to UInt8 because the result would be greater than UInt8.max")
    self._value = Builtin.fptoui_FPIEEE64_Int8(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -1.0 && source < 256.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE64_Int8(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to UInt8 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float80 value cannot be converted to UInt8 because the result would be less than UInt8.min")
    _precondition(source < 256.0,
      "Float80 value cannot be converted to UInt8 because the result would be greater than UInt8.max")
    self._value = Builtin.fptoui_FPIEEE80_Int8(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -1.0 && source < 256.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE80_Int8(source._value)
  }
#endif
  public static func == (lhs: UInt8, rhs: UInt8) -> Bool {
    return Bool(Builtin.cmp_eq_Int8(lhs._value, rhs._value))
  }
  public static func < (lhs: UInt8, rhs: UInt8) -> Bool {
    return Bool(Builtin.cmp_ult_Int8(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout UInt8, rhs: UInt8) {
    let (result, overflow) =
      Builtin.uadd_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt8(result)
  }
  public static func -=(lhs: inout UInt8, rhs: UInt8) {
    let (result, overflow) =
      Builtin.usub_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt8(result)
  }
  public static func *=(lhs: inout UInt8, rhs: UInt8) {
    let (result, overflow) =
      Builtin.umul_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt8(result)
  }
  public static func /=(lhs: inout UInt8, rhs: UInt8) {
    if _slowPath(rhs == (0 as UInt8)) {
      _preconditionFailure(
        "Division by zero")
    }
    let (result, overflow) =
      (Builtin.udiv_Int8(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt8(result)
  }
  public func addingReportingOverflow(
    _ other: UInt8
  ) -> (partialValue: UInt8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.uadd_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: UInt8(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: UInt8
  ) -> (partialValue: UInt8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.usub_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: UInt8(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: UInt8
  ) -> (partialValue: UInt8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.umul_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: UInt8(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: UInt8
  ) -> (partialValue: UInt8, overflow: Bool) {
    if _slowPath(other == (0 as UInt8)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.udiv_Int8(self._value, other._value),
      false._value)
    return (
      partialValue: UInt8(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: UInt8
  ) -> (partialValue: UInt8, overflow: Bool) {
    if _slowPath(other == (0 as UInt8)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.urem_Int8(self._value, other._value),
      false._value)
    return (
      partialValue: UInt8(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout UInt8, rhs: UInt8) {
    if _slowPath(rhs == (0 as UInt8)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.urem_Int8(lhs._value, rhs._value),
      false._value)
    lhs = UInt8(newStorage)
  }
  public init(_ _value: Builtin.Int8) {
    self._value = _value
  }
  public static func &=(lhs: inout UInt8, rhs: UInt8) {
    lhs = UInt8(Builtin.and_Int8(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout UInt8, rhs: UInt8) {
    lhs = UInt8(Builtin.or_Int8(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout UInt8, rhs: UInt8) {
    lhs = UInt8(Builtin.xor_Int8(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout UInt8, rhs: UInt8) {
    let rhs_ = rhs & 7
    lhs = UInt8(
      Builtin.lshr_Int8(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout UInt8, rhs: UInt8) {
    let rhs_ = rhs & 7
    lhs = UInt8(
      Builtin.shl_Int8(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 8 }
  public var leadingZeroBitCount: Int {
    return Int(
      UInt8(
        Builtin.int_ctlz_Int8(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      UInt8(
        Builtin.int_cttz_Int8(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      UInt8(
        Builtin.int_ctpop_Int8(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<UInt8.Words>
    @usableFromInline
    internal var _value: UInt8
    @inlinable
    public init(_ value: UInt8) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (8 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> UInt8(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.zextOrBitCast_Int8_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int8(bits._value))
  }
  public typealias Magnitude = UInt8
  @inlinable
  public func multipliedFullWidth(by other: UInt8)
    -> (high: UInt8, low: UInt8.Magnitude) {
    let lhs_ = Builtin.zext_Int8_Int16(self._value)
    let rhs_ = Builtin.zext_Int8_Int16(other._value)
    let res = Builtin.mul_Int16(lhs_, rhs_)
    let low = UInt8.Magnitude(Builtin.truncOrBitCast_Int16_Int8(res))
    let shift = Builtin.zextOrBitCast_Int8_Int16(UInt8(8)._value)
    let shifted = Builtin.ashr_Int16(res, shift)
    let high = UInt8(Builtin.truncOrBitCast_Int16_Int8(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: UInt8, low: UInt8.Magnitude)
  ) -> (quotient: UInt8, remainder: UInt8) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.zext_Int8_Int16(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int16(UInt8(8)._value)
    let lhsHighShifted = Builtin.shl_Int16(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int8_Int16(dividend.low._value)
    let lhs_ = Builtin.or_Int16(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.zext_Int8_Int16(self._value)
    let quotient_ = Builtin.udiv_Int16(lhs_, rhs_)
    let remainder_ = Builtin.urem_Int16(lhs_, rhs_)
    let quotient = UInt8(
      Builtin.truncOrBitCast_Int16_Int8(quotient_))
    let remainder = UInt8(
      Builtin.truncOrBitCast_Int16_Int8(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: UInt8 {
    return self
  }
  @inlinable
  @inline(__always)
  public func signum() -> UInt8 {
    let isPositive = UInt8(Builtin.zext_Int1_Int8(
      (self > (0 as UInt8))._value))
    return isPositive | (self &>> 7)
  }
}
extension UInt8: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt8(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt8(_value)),
      count: 1)
  }
}
extension UInt8: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension UInt8 {
  public static func &(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: UInt8, rhs: UInt8) -> UInt8 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: UInt8, rhs: UInt8) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: UInt8, rhs: UInt8) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: UInt8, rhs: UInt8) -> Bool {
    return rhs < lhs
  }
}
extension UInt8: Sendable { }
@frozen
public struct Int8
  : FixedWidthInteger, SignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = Int8
  public var _value: Builtin.Int8
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_s_checked_trunc_IntLiteral_Int8(x).0
  }
  public init(bitPattern x: UInt8) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to Int8 because it is either infinite or NaN")
    _precondition(source > -129.0,
      "Float16 value cannot be converted to Int8 because the result would be less than Int8.min")
    _precondition(source < 128.0,
      "Float16 value cannot be converted to Int8 because the result would be greater than Int8.max")
    self._value = Builtin.fptosi_FPIEEE16_Int8(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -129.0 && source < 128.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE16_Int8(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to Int8 because it is either infinite or NaN")
    _precondition(source > -129.0,
      "Float value cannot be converted to Int8 because the result would be less than Int8.min")
    _precondition(source < 128.0,
      "Float value cannot be converted to Int8 because the result would be greater than Int8.max")
    self._value = Builtin.fptosi_FPIEEE32_Int8(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -129.0 && source < 128.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE32_Int8(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to Int8 because it is either infinite or NaN")
    _precondition(source > -129.0,
      "Double value cannot be converted to Int8 because the result would be less than Int8.min")
    _precondition(source < 128.0,
      "Double value cannot be converted to Int8 because the result would be greater than Int8.max")
    self._value = Builtin.fptosi_FPIEEE64_Int8(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -129.0 && source < 128.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE64_Int8(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to Int8 because it is either infinite or NaN")
    _precondition(source > -129.0,
      "Float80 value cannot be converted to Int8 because the result would be less than Int8.min")
    _precondition(source < 128.0,
      "Float80 value cannot be converted to Int8 because the result would be greater than Int8.max")
    self._value = Builtin.fptosi_FPIEEE80_Int8(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -129.0 && source < 128.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE80_Int8(source._value)
  }
#endif
  public static func == (lhs: Int8, rhs: Int8) -> Bool {
    return Bool(Builtin.cmp_eq_Int8(lhs._value, rhs._value))
  }
  public static func < (lhs: Int8, rhs: Int8) -> Bool {
    return Bool(Builtin.cmp_slt_Int8(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout Int8, rhs: Int8) {
    let (result, overflow) =
      Builtin.sadd_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int8(result)
  }
  public static func -=(lhs: inout Int8, rhs: Int8) {
    let (result, overflow) =
      Builtin.ssub_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int8(result)
  }
  public static func *=(lhs: inout Int8, rhs: Int8) {
    let (result, overflow) =
      Builtin.smul_with_overflow_Int8(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int8(result)
  }
  public static func /=(lhs: inout Int8, rhs: Int8) {
    if _slowPath(rhs == (0 as Int8)) {
      _preconditionFailure(
        "Division by zero")
    }
    if _slowPath(
      lhs == Int8.min && rhs == (-1 as Int8)
    ) {
      _preconditionFailure(
        "Division results in an overflow")
    }
    let (result, overflow) =
      (Builtin.sdiv_Int8(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int8(result)
  }
  public func addingReportingOverflow(
    _ other: Int8
  ) -> (partialValue: Int8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.sadd_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: Int8(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: Int8
  ) -> (partialValue: Int8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.ssub_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: Int8(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: Int8
  ) -> (partialValue: Int8, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.smul_with_overflow_Int8(
        self._value, other._value, false._value)
    return (
      partialValue: Int8(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: Int8
  ) -> (partialValue: Int8, overflow: Bool) {
    if _slowPath(other == (0 as Int8)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int8.min && other == (-1 as Int8)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.sdiv_Int8(self._value, other._value),
      false._value)
    return (
      partialValue: Int8(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: Int8
  ) -> (partialValue: Int8, overflow: Bool) {
    if _slowPath(other == (0 as Int8)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int8.min && other == (-1 as Int8)) {
      return (partialValue: 0, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.srem_Int8(self._value, other._value),
      false._value)
    return (
      partialValue: Int8(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout Int8, rhs: Int8) {
    if _slowPath(rhs == (0 as Int8)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    if _slowPath(lhs == Int8.min && rhs == (-1 as Int8)) {
      _preconditionFailure(
        "Division results in an overflow in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.srem_Int8(lhs._value, rhs._value),
      false._value)
    lhs = Int8(newStorage)
  }
  public init(_ _value: Builtin.Int8) {
    self._value = _value
  }
  public static func &=(lhs: inout Int8, rhs: Int8) {
    lhs = Int8(Builtin.and_Int8(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout Int8, rhs: Int8) {
    lhs = Int8(Builtin.or_Int8(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout Int8, rhs: Int8) {
    lhs = Int8(Builtin.xor_Int8(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout Int8, rhs: Int8) {
    let rhs_ = rhs & 7
    lhs = Int8(
      Builtin.ashr_Int8(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout Int8, rhs: Int8) {
    let rhs_ = rhs & 7
    lhs = Int8(
      Builtin.shl_Int8(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 8 }
  public var leadingZeroBitCount: Int {
    return Int(
      Int8(
        Builtin.int_ctlz_Int8(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      Int8(
        Builtin.int_cttz_Int8(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      Int8(
        Builtin.int_ctpop_Int8(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<Int8.Words>
    @usableFromInline
    internal var _value: Int8
    @inlinable
    public init(_ value: Int8) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (8 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> Int8(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.sextOrBitCast_Int8_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int8(bits._value))
  }
  public typealias Magnitude = UInt8
  public var magnitude: UInt8 {
    let base = UInt8(_value)
    return self < (0 as Int8) ? ~base &+ 1 : base
  }
  @inlinable
  public func multipliedFullWidth(by other: Int8)
    -> (high: Int8, low: Int8.Magnitude) {
    let lhs_ = Builtin.sext_Int8_Int16(self._value)
    let rhs_ = Builtin.sext_Int8_Int16(other._value)
    let res = Builtin.mul_Int16(lhs_, rhs_)
    let low = Int8.Magnitude(Builtin.truncOrBitCast_Int16_Int8(res))
    let shift = Builtin.zextOrBitCast_Int8_Int16(UInt8(8)._value)
    let shifted = Builtin.ashr_Int16(res, shift)
    let high = Int8(Builtin.truncOrBitCast_Int16_Int8(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: Int8, low: Int8.Magnitude)
  ) -> (quotient: Int8, remainder: Int8) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.sext_Int8_Int16(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int16(UInt8(8)._value)
    let lhsHighShifted = Builtin.shl_Int16(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int8_Int16(dividend.low._value)
    let lhs_ = Builtin.or_Int16(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.sext_Int8_Int16(self._value)
    let quotient_ = Builtin.sdiv_Int16(lhs_, rhs_)
    let remainder_ = Builtin.srem_Int16(lhs_, rhs_)
    let quotient = Int8(
      Builtin.truncOrBitCast_Int16_Int8(quotient_))
    let remainder = Int8(
      Builtin.truncOrBitCast_Int16_Int8(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: Int8 {
    return self
  }
  @inlinable
  @inline(__always)
  public func signum() -> Int8 {
    let isPositive = Int8(Builtin.zext_Int1_Int8(
      (self > (0 as Int8))._value))
    return isPositive | (self &>> 7)
  }
}
extension Int8: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt8(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt8(_value)),
      count: 1)
  }
}
extension Int8: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension Int8 {
  public static func &(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: Int8, rhs: Int8) -> Int8 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: Int8, rhs: Int8) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Int8, rhs: Int8) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Int8, rhs: Int8) -> Bool {
    return rhs < lhs
  }
}
extension Int8: Sendable { }
public func _assumeNonNegative(_ x: Int8) -> Int8 {
  _internalInvariant(x >= (0 as Int8))
  return Int8(Builtin.assumeNonNegative_Int8(x._value))
}
@frozen
public struct UInt16
  : FixedWidthInteger, UnsignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = UInt16
  public var _value: Builtin.Int16
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_u_checked_trunc_IntLiteral_Int16(x).0
  }
  public init(bitPattern x: Int16) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to UInt16 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float16 value cannot be converted to UInt16 because the result would be less than UInt16.min")
    self._value = Builtin.fptoui_FPIEEE16_Int16(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -1.0 && source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE16_Int16(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to UInt16 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float value cannot be converted to UInt16 because the result would be less than UInt16.min")
    _precondition(source < 65536.0,
      "Float value cannot be converted to UInt16 because the result would be greater than UInt16.max")
    self._value = Builtin.fptoui_FPIEEE32_Int16(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -1.0 && source < 65536.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE32_Int16(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to UInt16 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Double value cannot be converted to UInt16 because the result would be less than UInt16.min")
    _precondition(source < 65536.0,
      "Double value cannot be converted to UInt16 because the result would be greater than UInt16.max")
    self._value = Builtin.fptoui_FPIEEE64_Int16(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -1.0 && source < 65536.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE64_Int16(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to UInt16 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float80 value cannot be converted to UInt16 because the result would be less than UInt16.min")
    _precondition(source < 65536.0,
      "Float80 value cannot be converted to UInt16 because the result would be greater than UInt16.max")
    self._value = Builtin.fptoui_FPIEEE80_Int16(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -1.0 && source < 65536.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE80_Int16(source._value)
  }
#endif
  public static func == (lhs: UInt16, rhs: UInt16) -> Bool {
    return Bool(Builtin.cmp_eq_Int16(lhs._value, rhs._value))
  }
  public static func < (lhs: UInt16, rhs: UInt16) -> Bool {
    return Bool(Builtin.cmp_ult_Int16(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout UInt16, rhs: UInt16) {
    let (result, overflow) =
      Builtin.uadd_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt16(result)
  }
  public static func -=(lhs: inout UInt16, rhs: UInt16) {
    let (result, overflow) =
      Builtin.usub_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt16(result)
  }
  public static func *=(lhs: inout UInt16, rhs: UInt16) {
    let (result, overflow) =
      Builtin.umul_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt16(result)
  }
  public static func /=(lhs: inout UInt16, rhs: UInt16) {
    if _slowPath(rhs == (0 as UInt16)) {
      _preconditionFailure(
        "Division by zero")
    }
    let (result, overflow) =
      (Builtin.udiv_Int16(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt16(result)
  }
  public func addingReportingOverflow(
    _ other: UInt16
  ) -> (partialValue: UInt16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.uadd_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: UInt16(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: UInt16
  ) -> (partialValue: UInt16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.usub_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: UInt16(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: UInt16
  ) -> (partialValue: UInt16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.umul_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: UInt16(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: UInt16
  ) -> (partialValue: UInt16, overflow: Bool) {
    if _slowPath(other == (0 as UInt16)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.udiv_Int16(self._value, other._value),
      false._value)
    return (
      partialValue: UInt16(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: UInt16
  ) -> (partialValue: UInt16, overflow: Bool) {
    if _slowPath(other == (0 as UInt16)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.urem_Int16(self._value, other._value),
      false._value)
    return (
      partialValue: UInt16(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout UInt16, rhs: UInt16) {
    if _slowPath(rhs == (0 as UInt16)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.urem_Int16(lhs._value, rhs._value),
      false._value)
    lhs = UInt16(newStorage)
  }
  public init(_ _value: Builtin.Int16) {
    self._value = _value
  }
  public static func &=(lhs: inout UInt16, rhs: UInt16) {
    lhs = UInt16(Builtin.and_Int16(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout UInt16, rhs: UInt16) {
    lhs = UInt16(Builtin.or_Int16(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout UInt16, rhs: UInt16) {
    lhs = UInt16(Builtin.xor_Int16(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout UInt16, rhs: UInt16) {
    let rhs_ = rhs & 15
    lhs = UInt16(
      Builtin.lshr_Int16(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout UInt16, rhs: UInt16) {
    let rhs_ = rhs & 15
    lhs = UInt16(
      Builtin.shl_Int16(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 16 }
  public var leadingZeroBitCount: Int {
    return Int(
      UInt16(
        Builtin.int_ctlz_Int16(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      UInt16(
        Builtin.int_cttz_Int16(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      UInt16(
        Builtin.int_ctpop_Int16(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<UInt16.Words>
    @usableFromInline
    internal var _value: UInt16
    @inlinable
    public init(_ value: UInt16) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (16 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> UInt16(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.zextOrBitCast_Int16_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int16(bits._value))
  }
  public typealias Magnitude = UInt16
  @inlinable
  public func multipliedFullWidth(by other: UInt16)
    -> (high: UInt16, low: UInt16.Magnitude) {
    let lhs_ = Builtin.zext_Int16_Int32(self._value)
    let rhs_ = Builtin.zext_Int16_Int32(other._value)
    let res = Builtin.mul_Int32(lhs_, rhs_)
    let low = UInt16.Magnitude(Builtin.truncOrBitCast_Int32_Int16(res))
    let shift = Builtin.zextOrBitCast_Int8_Int32(UInt8(16)._value)
    let shifted = Builtin.ashr_Int32(res, shift)
    let high = UInt16(Builtin.truncOrBitCast_Int32_Int16(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: UInt16, low: UInt16.Magnitude)
  ) -> (quotient: UInt16, remainder: UInt16) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.zext_Int16_Int32(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int32(UInt8(16)._value)
    let lhsHighShifted = Builtin.shl_Int32(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int16_Int32(dividend.low._value)
    let lhs_ = Builtin.or_Int32(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.zext_Int16_Int32(self._value)
    let quotient_ = Builtin.udiv_Int32(lhs_, rhs_)
    let remainder_ = Builtin.urem_Int32(lhs_, rhs_)
    let quotient = UInt16(
      Builtin.truncOrBitCast_Int32_Int16(quotient_))
    let remainder = UInt16(
      Builtin.truncOrBitCast_Int32_Int16(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: UInt16 {
    return UInt16(Builtin.int_bswap_Int16(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> UInt16 {
    let isPositive = UInt16(Builtin.zext_Int1_Int16(
      (self > (0 as UInt16))._value))
    return isPositive | (self &>> 15)
  }
}
extension UInt16: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt16(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt16(_value)),
      count: 2)
  }
}
extension UInt16: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension UInt16 {
  public static func &(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: UInt16, rhs: UInt16) -> UInt16 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: UInt16, rhs: UInt16) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: UInt16, rhs: UInt16) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: UInt16, rhs: UInt16) -> Bool {
    return rhs < lhs
  }
}
extension UInt16: Sendable { }
@frozen
public struct Int16
  : FixedWidthInteger, SignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = Int16
  public var _value: Builtin.Int16
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_s_checked_trunc_IntLiteral_Int16(x).0
  }
  public init(bitPattern x: UInt16) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to Int16 because it is either infinite or NaN")
    _precondition(source > -32800.0,
      "Float16 value cannot be converted to Int16 because the result would be less than Int16.min")
    _precondition(source < 32768.0,
      "Float16 value cannot be converted to Int16 because the result would be greater than Int16.max")
    self._value = Builtin.fptosi_FPIEEE16_Int16(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -32800.0 && source < 32768.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE16_Int16(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to Int16 because it is either infinite or NaN")
    _precondition(source > -32769.0,
      "Float value cannot be converted to Int16 because the result would be less than Int16.min")
    _precondition(source < 32768.0,
      "Float value cannot be converted to Int16 because the result would be greater than Int16.max")
    self._value = Builtin.fptosi_FPIEEE32_Int16(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -32769.0 && source < 32768.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE32_Int16(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to Int16 because it is either infinite or NaN")
    _precondition(source > -32769.0,
      "Double value cannot be converted to Int16 because the result would be less than Int16.min")
    _precondition(source < 32768.0,
      "Double value cannot be converted to Int16 because the result would be greater than Int16.max")
    self._value = Builtin.fptosi_FPIEEE64_Int16(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -32769.0 && source < 32768.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE64_Int16(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to Int16 because it is either infinite or NaN")
    _precondition(source > -32769.0,
      "Float80 value cannot be converted to Int16 because the result would be less than Int16.min")
    _precondition(source < 32768.0,
      "Float80 value cannot be converted to Int16 because the result would be greater than Int16.max")
    self._value = Builtin.fptosi_FPIEEE80_Int16(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -32769.0 && source < 32768.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE80_Int16(source._value)
  }
#endif
  public static func == (lhs: Int16, rhs: Int16) -> Bool {
    return Bool(Builtin.cmp_eq_Int16(lhs._value, rhs._value))
  }
  public static func < (lhs: Int16, rhs: Int16) -> Bool {
    return Bool(Builtin.cmp_slt_Int16(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout Int16, rhs: Int16) {
    let (result, overflow) =
      Builtin.sadd_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int16(result)
  }
  public static func -=(lhs: inout Int16, rhs: Int16) {
    let (result, overflow) =
      Builtin.ssub_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int16(result)
  }
  public static func *=(lhs: inout Int16, rhs: Int16) {
    let (result, overflow) =
      Builtin.smul_with_overflow_Int16(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int16(result)
  }
  public static func /=(lhs: inout Int16, rhs: Int16) {
    if _slowPath(rhs == (0 as Int16)) {
      _preconditionFailure(
        "Division by zero")
    }
    if _slowPath(
      lhs == Int16.min && rhs == (-1 as Int16)
    ) {
      _preconditionFailure(
        "Division results in an overflow")
    }
    let (result, overflow) =
      (Builtin.sdiv_Int16(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int16(result)
  }
  public func addingReportingOverflow(
    _ other: Int16
  ) -> (partialValue: Int16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.sadd_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: Int16(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: Int16
  ) -> (partialValue: Int16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.ssub_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: Int16(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: Int16
  ) -> (partialValue: Int16, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.smul_with_overflow_Int16(
        self._value, other._value, false._value)
    return (
      partialValue: Int16(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: Int16
  ) -> (partialValue: Int16, overflow: Bool) {
    if _slowPath(other == (0 as Int16)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int16.min && other == (-1 as Int16)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.sdiv_Int16(self._value, other._value),
      false._value)
    return (
      partialValue: Int16(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: Int16
  ) -> (partialValue: Int16, overflow: Bool) {
    if _slowPath(other == (0 as Int16)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int16.min && other == (-1 as Int16)) {
      return (partialValue: 0, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.srem_Int16(self._value, other._value),
      false._value)
    return (
      partialValue: Int16(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout Int16, rhs: Int16) {
    if _slowPath(rhs == (0 as Int16)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    if _slowPath(lhs == Int16.min && rhs == (-1 as Int16)) {
      _preconditionFailure(
        "Division results in an overflow in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.srem_Int16(lhs._value, rhs._value),
      false._value)
    lhs = Int16(newStorage)
  }
  public init(_ _value: Builtin.Int16) {
    self._value = _value
  }
  public static func &=(lhs: inout Int16, rhs: Int16) {
    lhs = Int16(Builtin.and_Int16(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout Int16, rhs: Int16) {
    lhs = Int16(Builtin.or_Int16(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout Int16, rhs: Int16) {
    lhs = Int16(Builtin.xor_Int16(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout Int16, rhs: Int16) {
    let rhs_ = rhs & 15
    lhs = Int16(
      Builtin.ashr_Int16(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout Int16, rhs: Int16) {
    let rhs_ = rhs & 15
    lhs = Int16(
      Builtin.shl_Int16(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 16 }
  public var leadingZeroBitCount: Int {
    return Int(
      Int16(
        Builtin.int_ctlz_Int16(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      Int16(
        Builtin.int_cttz_Int16(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      Int16(
        Builtin.int_ctpop_Int16(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<Int16.Words>
    @usableFromInline
    internal var _value: Int16
    @inlinable
    public init(_ value: Int16) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (16 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> Int16(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.sextOrBitCast_Int16_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int16(bits._value))
  }
  public typealias Magnitude = UInt16
  public var magnitude: UInt16 {
    let base = UInt16(_value)
    return self < (0 as Int16) ? ~base &+ 1 : base
  }
  @inlinable
  public func multipliedFullWidth(by other: Int16)
    -> (high: Int16, low: Int16.Magnitude) {
    let lhs_ = Builtin.sext_Int16_Int32(self._value)
    let rhs_ = Builtin.sext_Int16_Int32(other._value)
    let res = Builtin.mul_Int32(lhs_, rhs_)
    let low = Int16.Magnitude(Builtin.truncOrBitCast_Int32_Int16(res))
    let shift = Builtin.zextOrBitCast_Int8_Int32(UInt8(16)._value)
    let shifted = Builtin.ashr_Int32(res, shift)
    let high = Int16(Builtin.truncOrBitCast_Int32_Int16(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: Int16, low: Int16.Magnitude)
  ) -> (quotient: Int16, remainder: Int16) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.sext_Int16_Int32(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int32(UInt8(16)._value)
    let lhsHighShifted = Builtin.shl_Int32(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int16_Int32(dividend.low._value)
    let lhs_ = Builtin.or_Int32(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.sext_Int16_Int32(self._value)
    let quotient_ = Builtin.sdiv_Int32(lhs_, rhs_)
    let remainder_ = Builtin.srem_Int32(lhs_, rhs_)
    let quotient = Int16(
      Builtin.truncOrBitCast_Int32_Int16(quotient_))
    let remainder = Int16(
      Builtin.truncOrBitCast_Int32_Int16(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: Int16 {
    return Int16(Builtin.int_bswap_Int16(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> Int16 {
    let isPositive = Int16(Builtin.zext_Int1_Int16(
      (self > (0 as Int16))._value))
    return isPositive | (self &>> 15)
  }
}
extension Int16: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt16(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt16(_value)),
      count: 2)
  }
}
extension Int16: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension Int16 {
  public static func &(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: Int16, rhs: Int16) -> Int16 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: Int16, rhs: Int16) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Int16, rhs: Int16) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Int16, rhs: Int16) -> Bool {
    return rhs < lhs
  }
}
extension Int16: Sendable { }
public func _assumeNonNegative(_ x: Int16) -> Int16 {
  _internalInvariant(x >= (0 as Int16))
  return Int16(Builtin.assumeNonNegative_Int16(x._value))
}
@frozen
public struct UInt32
  : FixedWidthInteger, UnsignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = UInt32
  public var _value: Builtin.Int32
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_u_checked_trunc_IntLiteral_Int32(x).0
  }
  public init(bitPattern x: Int32) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to UInt32 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float16 value cannot be converted to UInt32 because the result would be less than UInt32.min")
    self._value = Builtin.fptoui_FPIEEE16_Int32(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -1.0 && source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE16_Int32(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to UInt32 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float value cannot be converted to UInt32 because the result would be less than UInt32.min")
    _precondition(source < 4294967296.0,
      "Float value cannot be converted to UInt32 because the result would be greater than UInt32.max")
    self._value = Builtin.fptoui_FPIEEE32_Int32(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -1.0 && source < 4294967296.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE32_Int32(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to UInt32 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Double value cannot be converted to UInt32 because the result would be less than UInt32.min")
    _precondition(source < 4294967296.0,
      "Double value cannot be converted to UInt32 because the result would be greater than UInt32.max")
    self._value = Builtin.fptoui_FPIEEE64_Int32(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -1.0 && source < 4294967296.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE64_Int32(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to UInt32 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float80 value cannot be converted to UInt32 because the result would be less than UInt32.min")
    _precondition(source < 4294967296.0,
      "Float80 value cannot be converted to UInt32 because the result would be greater than UInt32.max")
    self._value = Builtin.fptoui_FPIEEE80_Int32(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -1.0 && source < 4294967296.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE80_Int32(source._value)
  }
#endif
  public static func == (lhs: UInt32, rhs: UInt32) -> Bool {
    return Bool(Builtin.cmp_eq_Int32(lhs._value, rhs._value))
  }
  public static func < (lhs: UInt32, rhs: UInt32) -> Bool {
    return Bool(Builtin.cmp_ult_Int32(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout UInt32, rhs: UInt32) {
    let (result, overflow) =
      Builtin.uadd_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt32(result)
  }
  public static func -=(lhs: inout UInt32, rhs: UInt32) {
    let (result, overflow) =
      Builtin.usub_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt32(result)
  }
  public static func *=(lhs: inout UInt32, rhs: UInt32) {
    let (result, overflow) =
      Builtin.umul_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt32(result)
  }
  public static func /=(lhs: inout UInt32, rhs: UInt32) {
    if _slowPath(rhs == (0 as UInt32)) {
      _preconditionFailure(
        "Division by zero")
    }
    let (result, overflow) =
      (Builtin.udiv_Int32(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt32(result)
  }
  public func addingReportingOverflow(
    _ other: UInt32
  ) -> (partialValue: UInt32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.uadd_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: UInt32(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: UInt32
  ) -> (partialValue: UInt32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.usub_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: UInt32(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: UInt32
  ) -> (partialValue: UInt32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.umul_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: UInt32(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: UInt32
  ) -> (partialValue: UInt32, overflow: Bool) {
    if _slowPath(other == (0 as UInt32)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.udiv_Int32(self._value, other._value),
      false._value)
    return (
      partialValue: UInt32(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: UInt32
  ) -> (partialValue: UInt32, overflow: Bool) {
    if _slowPath(other == (0 as UInt32)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.urem_Int32(self._value, other._value),
      false._value)
    return (
      partialValue: UInt32(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout UInt32, rhs: UInt32) {
    if _slowPath(rhs == (0 as UInt32)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.urem_Int32(lhs._value, rhs._value),
      false._value)
    lhs = UInt32(newStorage)
  }
  public init(_ _value: Builtin.Int32) {
    self._value = _value
  }
  public static func &=(lhs: inout UInt32, rhs: UInt32) {
    lhs = UInt32(Builtin.and_Int32(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout UInt32, rhs: UInt32) {
    lhs = UInt32(Builtin.or_Int32(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout UInt32, rhs: UInt32) {
    lhs = UInt32(Builtin.xor_Int32(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout UInt32, rhs: UInt32) {
    let rhs_ = rhs & 31
    lhs = UInt32(
      Builtin.lshr_Int32(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout UInt32, rhs: UInt32) {
    let rhs_ = rhs & 31
    lhs = UInt32(
      Builtin.shl_Int32(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 32 }
  public var leadingZeroBitCount: Int {
    return Int(
      UInt32(
        Builtin.int_ctlz_Int32(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      UInt32(
        Builtin.int_cttz_Int32(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      UInt32(
        Builtin.int_ctpop_Int32(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<UInt32.Words>
    @usableFromInline
    internal var _value: UInt32
    @inlinable
    public init(_ value: UInt32) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (32 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> UInt32(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.zextOrBitCast_Int32_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int32(bits._value))
  }
  public typealias Magnitude = UInt32
  @inlinable
  public func multipliedFullWidth(by other: UInt32)
    -> (high: UInt32, low: UInt32.Magnitude) {
    let lhs_ = Builtin.zext_Int32_Int64(self._value)
    let rhs_ = Builtin.zext_Int32_Int64(other._value)
    let res = Builtin.mul_Int64(lhs_, rhs_)
    let low = UInt32.Magnitude(Builtin.truncOrBitCast_Int64_Int32(res))
    let shift = Builtin.zextOrBitCast_Int8_Int64(UInt8(32)._value)
    let shifted = Builtin.ashr_Int64(res, shift)
    let high = UInt32(Builtin.truncOrBitCast_Int64_Int32(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: UInt32, low: UInt32.Magnitude)
  ) -> (quotient: UInt32, remainder: UInt32) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.zext_Int32_Int64(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int64(UInt8(32)._value)
    let lhsHighShifted = Builtin.shl_Int64(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int32_Int64(dividend.low._value)
    let lhs_ = Builtin.or_Int64(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.zext_Int32_Int64(self._value)
    let quotient_ = Builtin.udiv_Int64(lhs_, rhs_)
    let remainder_ = Builtin.urem_Int64(lhs_, rhs_)
    let quotient = UInt32(
      Builtin.truncOrBitCast_Int64_Int32(quotient_))
    let remainder = UInt32(
      Builtin.truncOrBitCast_Int64_Int32(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: UInt32 {
    return UInt32(Builtin.int_bswap_Int32(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> UInt32 {
    let isPositive = UInt32(Builtin.zext_Int1_Int32(
      (self > (0 as UInt32))._value))
    return isPositive | (self &>> 31)
  }
}
extension UInt32: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt32(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt32(_value)),
      count: 4)
  }
}
extension UInt32: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension UInt32 {
  public static func &(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: UInt32, rhs: UInt32) -> UInt32 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: UInt32, rhs: UInt32) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: UInt32, rhs: UInt32) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: UInt32, rhs: UInt32) -> Bool {
    return rhs < lhs
  }
}
extension UInt32: Sendable { }
@frozen
public struct Int32
  : FixedWidthInteger, SignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = Int32
  public var _value: Builtin.Int32
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_s_checked_trunc_IntLiteral_Int32(x).0
  }
  public init(bitPattern x: UInt32) {
    _value = x._value
  }
  @available(*, unavailable,
    message: "Please use Int32(bitPattern: UInt32) in combination with Float.bitPattern property.")
  public init(bitPattern x: Float) {
    Builtin.unreachable()
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to Int32 because it is either infinite or NaN")
    self._value = Builtin.fptosi_FPIEEE16_Int32(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE16_Int32(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to Int32 because it is either infinite or NaN")
    _precondition(source > -2147483904.0,
      "Float value cannot be converted to Int32 because the result would be less than Int32.min")
    _precondition(source < 2147483648.0,
      "Float value cannot be converted to Int32 because the result would be greater than Int32.max")
    self._value = Builtin.fptosi_FPIEEE32_Int32(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -2147483904.0 && source < 2147483648.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE32_Int32(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to Int32 because it is either infinite or NaN")
    _precondition(source > -2147483649.0,
      "Double value cannot be converted to Int32 because the result would be less than Int32.min")
    _precondition(source < 2147483648.0,
      "Double value cannot be converted to Int32 because the result would be greater than Int32.max")
    self._value = Builtin.fptosi_FPIEEE64_Int32(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -2147483649.0 && source < 2147483648.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE64_Int32(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to Int32 because it is either infinite or NaN")
    _precondition(source > -2147483649.0,
      "Float80 value cannot be converted to Int32 because the result would be less than Int32.min")
    _precondition(source < 2147483648.0,
      "Float80 value cannot be converted to Int32 because the result would be greater than Int32.max")
    self._value = Builtin.fptosi_FPIEEE80_Int32(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -2147483649.0 && source < 2147483648.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE80_Int32(source._value)
  }
#endif
  public static func == (lhs: Int32, rhs: Int32) -> Bool {
    return Bool(Builtin.cmp_eq_Int32(lhs._value, rhs._value))
  }
  public static func < (lhs: Int32, rhs: Int32) -> Bool {
    return Bool(Builtin.cmp_slt_Int32(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout Int32, rhs: Int32) {
    let (result, overflow) =
      Builtin.sadd_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int32(result)
  }
  public static func -=(lhs: inout Int32, rhs: Int32) {
    let (result, overflow) =
      Builtin.ssub_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int32(result)
  }
  public static func *=(lhs: inout Int32, rhs: Int32) {
    let (result, overflow) =
      Builtin.smul_with_overflow_Int32(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int32(result)
  }
  public static func /=(lhs: inout Int32, rhs: Int32) {
    if _slowPath(rhs == (0 as Int32)) {
      _preconditionFailure(
        "Division by zero")
    }
    if _slowPath(
      lhs == Int32.min && rhs == (-1 as Int32)
    ) {
      _preconditionFailure(
        "Division results in an overflow")
    }
    let (result, overflow) =
      (Builtin.sdiv_Int32(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int32(result)
  }
  public func addingReportingOverflow(
    _ other: Int32
  ) -> (partialValue: Int32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.sadd_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: Int32(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: Int32
  ) -> (partialValue: Int32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.ssub_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: Int32(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: Int32
  ) -> (partialValue: Int32, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.smul_with_overflow_Int32(
        self._value, other._value, false._value)
    return (
      partialValue: Int32(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: Int32
  ) -> (partialValue: Int32, overflow: Bool) {
    if _slowPath(other == (0 as Int32)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int32.min && other == (-1 as Int32)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.sdiv_Int32(self._value, other._value),
      false._value)
    return (
      partialValue: Int32(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: Int32
  ) -> (partialValue: Int32, overflow: Bool) {
    if _slowPath(other == (0 as Int32)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int32.min && other == (-1 as Int32)) {
      return (partialValue: 0, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.srem_Int32(self._value, other._value),
      false._value)
    return (
      partialValue: Int32(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout Int32, rhs: Int32) {
    if _slowPath(rhs == (0 as Int32)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    if _slowPath(lhs == Int32.min && rhs == (-1 as Int32)) {
      _preconditionFailure(
        "Division results in an overflow in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.srem_Int32(lhs._value, rhs._value),
      false._value)
    lhs = Int32(newStorage)
  }
  public init(_ _value: Builtin.Int32) {
    self._value = _value
  }
  public static func &=(lhs: inout Int32, rhs: Int32) {
    lhs = Int32(Builtin.and_Int32(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout Int32, rhs: Int32) {
    lhs = Int32(Builtin.or_Int32(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout Int32, rhs: Int32) {
    lhs = Int32(Builtin.xor_Int32(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout Int32, rhs: Int32) {
    let rhs_ = rhs & 31
    lhs = Int32(
      Builtin.ashr_Int32(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout Int32, rhs: Int32) {
    let rhs_ = rhs & 31
    lhs = Int32(
      Builtin.shl_Int32(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 32 }
  public var leadingZeroBitCount: Int {
    return Int(
      Int32(
        Builtin.int_ctlz_Int32(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      Int32(
        Builtin.int_cttz_Int32(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      Int32(
        Builtin.int_ctpop_Int32(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<Int32.Words>
    @usableFromInline
    internal var _value: Int32
    @inlinable
    public init(_ value: Int32) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (32 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> Int32(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.sextOrBitCast_Int32_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int32(bits._value))
  }
  public typealias Magnitude = UInt32
  public var magnitude: UInt32 {
    let base = UInt32(_value)
    return self < (0 as Int32) ? ~base &+ 1 : base
  }
  @inlinable
  public func multipliedFullWidth(by other: Int32)
    -> (high: Int32, low: Int32.Magnitude) {
    let lhs_ = Builtin.sext_Int32_Int64(self._value)
    let rhs_ = Builtin.sext_Int32_Int64(other._value)
    let res = Builtin.mul_Int64(lhs_, rhs_)
    let low = Int32.Magnitude(Builtin.truncOrBitCast_Int64_Int32(res))
    let shift = Builtin.zextOrBitCast_Int8_Int64(UInt8(32)._value)
    let shifted = Builtin.ashr_Int64(res, shift)
    let high = Int32(Builtin.truncOrBitCast_Int64_Int32(shifted))
    return (high: high, low: low)
  }
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: Int32, low: Int32.Magnitude)
  ) -> (quotient: Int32, remainder: Int32) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.sext_Int32_Int64(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int64(UInt8(32)._value)
    let lhsHighShifted = Builtin.shl_Int64(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int32_Int64(dividend.low._value)
    let lhs_ = Builtin.or_Int64(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.sext_Int32_Int64(self._value)
    let quotient_ = Builtin.sdiv_Int64(lhs_, rhs_)
    let remainder_ = Builtin.srem_Int64(lhs_, rhs_)
    let quotient = Int32(
      Builtin.truncOrBitCast_Int64_Int32(quotient_))
    let remainder = Int32(
      Builtin.truncOrBitCast_Int64_Int32(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: Int32 {
    return Int32(Builtin.int_bswap_Int32(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> Int32 {
    let isPositive = Int32(Builtin.zext_Int1_Int32(
      (self > (0 as Int32))._value))
    return isPositive | (self &>> 31)
  }
}
extension Int32: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt32(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(
      seed: seed,
      bytes: UInt64(truncatingIfNeeded: UInt32(_value)),
      count: 4)
  }
}
extension Int32: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension Int32 {
  public static func &(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: Int32, rhs: Int32) -> Int32 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: Int32, rhs: Int32) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Int32, rhs: Int32) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Int32, rhs: Int32) -> Bool {
    return rhs < lhs
  }
}
extension Int32: Sendable { }
public func _assumeNonNegative(_ x: Int32) -> Int32 {
  _internalInvariant(x >= (0 as Int32))
  return Int32(Builtin.assumeNonNegative_Int32(x._value))
}
@frozen
public struct UInt64
  : FixedWidthInteger, UnsignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = UInt64
  public var _value: Builtin.Int64
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_u_checked_trunc_IntLiteral_Int64(x).0
  }
  public init(bitPattern x: Int64) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to UInt64 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float16 value cannot be converted to UInt64 because the result would be less than UInt64.min")
    self._value = Builtin.fptoui_FPIEEE16_Int64(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -1.0 && source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE16_Int64(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to UInt64 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float value cannot be converted to UInt64 because the result would be less than UInt64.min")
    _precondition(source < 18446744073709551616.0,
      "Float value cannot be converted to UInt64 because the result would be greater than UInt64.max")
    self._value = Builtin.fptoui_FPIEEE32_Int64(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE32_Int64(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to UInt64 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Double value cannot be converted to UInt64 because the result would be less than UInt64.min")
    _precondition(source < 18446744073709551616.0,
      "Double value cannot be converted to UInt64 because the result would be greater than UInt64.max")
    self._value = Builtin.fptoui_FPIEEE64_Int64(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE64_Int64(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to UInt64 because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float80 value cannot be converted to UInt64 because the result would be less than UInt64.min")
    _precondition(source < 18446744073709551616.0,
      "Float80 value cannot be converted to UInt64 because the result would be greater than UInt64.max")
    self._value = Builtin.fptoui_FPIEEE80_Int64(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE80_Int64(source._value)
  }
#endif
  public static func == (lhs: UInt64, rhs: UInt64) -> Bool {
    return Bool(Builtin.cmp_eq_Int64(lhs._value, rhs._value))
  }
  public static func < (lhs: UInt64, rhs: UInt64) -> Bool {
    return Bool(Builtin.cmp_ult_Int64(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout UInt64, rhs: UInt64) {
    let (result, overflow) =
      Builtin.uadd_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt64(result)
  }
  public static func -=(lhs: inout UInt64, rhs: UInt64) {
    let (result, overflow) =
      Builtin.usub_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt64(result)
  }
  public static func *=(lhs: inout UInt64, rhs: UInt64) {
    let (result, overflow) =
      Builtin.umul_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt64(result)
  }
  public static func /=(lhs: inout UInt64, rhs: UInt64) {
    if _slowPath(rhs == (0 as UInt64)) {
      _preconditionFailure(
        "Division by zero")
    }
    let (result, overflow) =
      (Builtin.udiv_Int64(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt64(result)
  }
  public func addingReportingOverflow(
    _ other: UInt64
  ) -> (partialValue: UInt64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.uadd_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt64(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: UInt64
  ) -> (partialValue: UInt64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.usub_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt64(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: UInt64
  ) -> (partialValue: UInt64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.umul_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt64(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: UInt64
  ) -> (partialValue: UInt64, overflow: Bool) {
    if _slowPath(other == (0 as UInt64)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.udiv_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: UInt64(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: UInt64
  ) -> (partialValue: UInt64, overflow: Bool) {
    if _slowPath(other == (0 as UInt64)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.urem_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: UInt64(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout UInt64, rhs: UInt64) {
    if _slowPath(rhs == (0 as UInt64)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.urem_Int64(lhs._value, rhs._value),
      false._value)
    lhs = UInt64(newStorage)
  }
  public init(_ _value: Builtin.Int64) {
    self._value = _value
  }
  public static func &=(lhs: inout UInt64, rhs: UInt64) {
    lhs = UInt64(Builtin.and_Int64(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout UInt64, rhs: UInt64) {
    lhs = UInt64(Builtin.or_Int64(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout UInt64, rhs: UInt64) {
    lhs = UInt64(Builtin.xor_Int64(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout UInt64, rhs: UInt64) {
    let rhs_ = rhs & 63
    lhs = UInt64(
      Builtin.lshr_Int64(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout UInt64, rhs: UInt64) {
    let rhs_ = rhs & 63
    lhs = UInt64(
      Builtin.shl_Int64(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 64 }
  public var leadingZeroBitCount: Int {
    return Int(
      UInt64(
        Builtin.int_ctlz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      UInt64(
        Builtin.int_cttz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      UInt64(
        Builtin.int_ctpop_Int64(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<UInt64.Words>
    @usableFromInline
    internal var _value: UInt64
    @inlinable
    public init(_ value: UInt64) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (64 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> UInt64(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.zextOrBitCast_Int64_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int64(bits._value))
  }
  public typealias Magnitude = UInt64
  #if !(arch(arm) || arch(i386) || arch(wasm32))
  @inlinable
  public func multipliedFullWidth(by other: UInt64)
    -> (high: UInt64, low: UInt64.Magnitude) {
    let lhs_ = Builtin.zext_Int64_Int128(self._value)
    let rhs_ = Builtin.zext_Int64_Int128(other._value)
    let res = Builtin.mul_Int128(lhs_, rhs_)
    let low = UInt64.Magnitude(Builtin.truncOrBitCast_Int128_Int64(res))
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let shifted = Builtin.ashr_Int128(res, shift)
    let high = UInt64(Builtin.truncOrBitCast_Int128_Int64(shifted))
    return (high: high, low: low)
  }
  #endif
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: UInt64, low: UInt64.Magnitude)
  ) -> (quotient: UInt64, remainder: UInt64) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.zext_Int64_Int128(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let lhsHighShifted = Builtin.shl_Int128(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int64_Int128(dividend.low._value)
    let lhs_ = Builtin.or_Int128(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.zext_Int64_Int128(self._value)
    let quotient_ = Builtin.udiv_Int128(lhs_, rhs_)
    let remainder_ = Builtin.urem_Int128(lhs_, rhs_)
    let quotient = UInt64(
      Builtin.truncOrBitCast_Int128_Int64(quotient_))
    let remainder = UInt64(
      Builtin.truncOrBitCast_Int128_Int64(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: UInt64 {
    return UInt64(Builtin.int_bswap_Int64(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> UInt64 {
    let isPositive = UInt64(Builtin.zext_Int1_Int64(
      (self > (0 as UInt64))._value))
    return isPositive | (self &>> 63)
  }
}
extension UInt64: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt64(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(seed: seed, UInt64(_value))
  }
}
extension UInt64: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension UInt64 {
  public static func &(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: UInt64, rhs: UInt64) -> UInt64 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: UInt64, rhs: UInt64) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: UInt64, rhs: UInt64) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: UInt64, rhs: UInt64) -> Bool {
    return rhs < lhs
  }
}
extension UInt64: Sendable { }
@frozen
public struct Int64
  : FixedWidthInteger, SignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = Int64
  public var _value: Builtin.Int64
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_s_checked_trunc_IntLiteral_Int64(x).0
  }
  public init(bitPattern x: UInt64) {
    _value = x._value
  }
  @available(*, unavailable,
    message: "Please use Int64(bitPattern: UInt64) in combination with Double.bitPattern property.")
  public init(bitPattern x: Double) {
    Builtin.unreachable()
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to Int64 because it is either infinite or NaN")
    self._value = Builtin.fptosi_FPIEEE16_Int64(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE16_Int64(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to Int64 because it is either infinite or NaN")
    _precondition(source > -9223373136366403584.0,
      "Float value cannot be converted to Int64 because the result would be less than Int64.min")
    _precondition(source < 9223372036854775808.0,
      "Float value cannot be converted to Int64 because the result would be greater than Int64.max")
    self._value = Builtin.fptosi_FPIEEE32_Int64(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -9223373136366403584.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE32_Int64(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to Int64 because it is either infinite or NaN")
    _precondition(source > -9223372036854777856.0,
      "Double value cannot be converted to Int64 because the result would be less than Int64.min")
    _precondition(source < 9223372036854775808.0,
      "Double value cannot be converted to Int64 because the result would be greater than Int64.max")
    self._value = Builtin.fptosi_FPIEEE64_Int64(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -9223372036854777856.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE64_Int64(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to Int64 because it is either infinite or NaN")
    _precondition(source > -9223372036854775809.0,
      "Float80 value cannot be converted to Int64 because the result would be less than Int64.min")
    _precondition(source < 9223372036854775808.0,
      "Float80 value cannot be converted to Int64 because the result would be greater than Int64.max")
    self._value = Builtin.fptosi_FPIEEE80_Int64(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -9223372036854775809.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE80_Int64(source._value)
  }
#endif
  public static func == (lhs: Int64, rhs: Int64) -> Bool {
    return Bool(Builtin.cmp_eq_Int64(lhs._value, rhs._value))
  }
  public static func < (lhs: Int64, rhs: Int64) -> Bool {
    return Bool(Builtin.cmp_slt_Int64(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout Int64, rhs: Int64) {
    let (result, overflow) =
      Builtin.sadd_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int64(result)
  }
  public static func -=(lhs: inout Int64, rhs: Int64) {
    let (result, overflow) =
      Builtin.ssub_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int64(result)
  }
  public static func *=(lhs: inout Int64, rhs: Int64) {
    let (result, overflow) =
      Builtin.smul_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int64(result)
  }
  public static func /=(lhs: inout Int64, rhs: Int64) {
    if _slowPath(rhs == (0 as Int64)) {
      _preconditionFailure(
        "Division by zero")
    }
    if _slowPath(
      lhs == Int64.min && rhs == (-1 as Int64)
    ) {
      _preconditionFailure(
        "Division results in an overflow")
    }
    let (result, overflow) =
      (Builtin.sdiv_Int64(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int64(result)
  }
  public func addingReportingOverflow(
    _ other: Int64
  ) -> (partialValue: Int64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.sadd_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int64(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: Int64
  ) -> (partialValue: Int64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.ssub_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int64(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: Int64
  ) -> (partialValue: Int64, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.smul_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int64(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: Int64
  ) -> (partialValue: Int64, overflow: Bool) {
    if _slowPath(other == (0 as Int64)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int64.min && other == (-1 as Int64)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.sdiv_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: Int64(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: Int64
  ) -> (partialValue: Int64, overflow: Bool) {
    if _slowPath(other == (0 as Int64)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int64.min && other == (-1 as Int64)) {
      return (partialValue: 0, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.srem_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: Int64(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout Int64, rhs: Int64) {
    if _slowPath(rhs == (0 as Int64)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    if _slowPath(lhs == Int64.min && rhs == (-1 as Int64)) {
      _preconditionFailure(
        "Division results in an overflow in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.srem_Int64(lhs._value, rhs._value),
      false._value)
    lhs = Int64(newStorage)
  }
  public init(_ _value: Builtin.Int64) {
    self._value = _value
  }
  public static func &=(lhs: inout Int64, rhs: Int64) {
    lhs = Int64(Builtin.and_Int64(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout Int64, rhs: Int64) {
    lhs = Int64(Builtin.or_Int64(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout Int64, rhs: Int64) {
    lhs = Int64(Builtin.xor_Int64(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout Int64, rhs: Int64) {
    let rhs_ = rhs & 63
    lhs = Int64(
      Builtin.ashr_Int64(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout Int64, rhs: Int64) {
    let rhs_ = rhs & 63
    lhs = Int64(
      Builtin.shl_Int64(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 64 }
  public var leadingZeroBitCount: Int {
    return Int(
      Int64(
        Builtin.int_ctlz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      Int64(
        Builtin.int_cttz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      Int64(
        Builtin.int_ctpop_Int64(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<Int64.Words>
    @usableFromInline
    internal var _value: Int64
    @inlinable
    public init(_ value: Int64) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (64 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> Int64(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.sextOrBitCast_Int64_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int64(bits._value))
  }
  public typealias Magnitude = UInt64
  public var magnitude: UInt64 {
    let base = UInt64(_value)
    return self < (0 as Int64) ? ~base &+ 1 : base
  }
  #if !(arch(arm) || arch(i386) || arch(wasm32))
  @inlinable
  public func multipliedFullWidth(by other: Int64)
    -> (high: Int64, low: Int64.Magnitude) {
    let lhs_ = Builtin.sext_Int64_Int128(self._value)
    let rhs_ = Builtin.sext_Int64_Int128(other._value)
    let res = Builtin.mul_Int128(lhs_, rhs_)
    let low = Int64.Magnitude(Builtin.truncOrBitCast_Int128_Int64(res))
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let shifted = Builtin.ashr_Int128(res, shift)
    let high = Int64(Builtin.truncOrBitCast_Int128_Int64(shifted))
    return (high: high, low: low)
  }
  #endif
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: Int64, low: Int64.Magnitude)
  ) -> (quotient: Int64, remainder: Int64) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.sext_Int64_Int128(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let lhsHighShifted = Builtin.shl_Int128(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int64_Int128(dividend.low._value)
    let lhs_ = Builtin.or_Int128(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.sext_Int64_Int128(self._value)
    let quotient_ = Builtin.sdiv_Int128(lhs_, rhs_)
    let remainder_ = Builtin.srem_Int128(lhs_, rhs_)
    let quotient = Int64(
      Builtin.truncOrBitCast_Int128_Int64(quotient_))
    let remainder = Int64(
      Builtin.truncOrBitCast_Int128_Int64(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: Int64 {
    return Int64(Builtin.int_bswap_Int64(_value))
  }
  @inlinable
  @inline(__always)
  public func signum() -> Int64 {
    let isPositive = Int64(Builtin.zext_Int1_Int64(
      (self > (0 as Int64))._value))
    return isPositive | (self &>> 63)
  }
}
extension Int64: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt64(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(seed: seed, UInt64(_value))
  }
}
extension Int64: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension Int64 {
  public static func &(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: Int64, rhs: Int64) -> Int64 {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: Int64, rhs: Int64) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Int64, rhs: Int64) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Int64, rhs: Int64) -> Bool {
    return rhs < lhs
  }
}
extension Int64: Sendable { }
public func _assumeNonNegative(_ x: Int64) -> Int64 {
  _internalInvariant(x >= (0 as Int64))
  return Int64(Builtin.assumeNonNegative_Int64(x._value))
}
@frozen
public struct UInt
  : FixedWidthInteger, UnsignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = UInt
  public var _value: Builtin.Int64
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_u_checked_trunc_IntLiteral_Int64(x).0
  }
  public init(bitPattern x: Int) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to UInt because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float16 value cannot be converted to UInt because the result would be less than UInt.min")
    self._value = Builtin.fptoui_FPIEEE16_Int64(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source > -1.0 && source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE16_Int64(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to UInt because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float value cannot be converted to UInt because the result would be less than UInt.min")
    _precondition(source < 18446744073709551616.0,
      "Float value cannot be converted to UInt because the result would be greater than UInt.max")
    self._value = Builtin.fptoui_FPIEEE32_Int64(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE32_Int64(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to UInt because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Double value cannot be converted to UInt because the result would be less than UInt.min")
    _precondition(source < 18446744073709551616.0,
      "Double value cannot be converted to UInt because the result would be greater than UInt.max")
    self._value = Builtin.fptoui_FPIEEE64_Int64(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE64_Int64(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to UInt because it is either infinite or NaN")
    _precondition(source > -1.0,
      "Float80 value cannot be converted to UInt because the result would be less than UInt.min")
    _precondition(source < 18446744073709551616.0,
      "Float80 value cannot be converted to UInt because the result would be greater than UInt.max")
    self._value = Builtin.fptoui_FPIEEE80_Int64(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -1.0 && source < 18446744073709551616.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptoui_FPIEEE80_Int64(source._value)
  }
#endif
  public static func == (lhs: UInt, rhs: UInt) -> Bool {
    return Bool(Builtin.cmp_eq_Int64(lhs._value, rhs._value))
  }
  public static func < (lhs: UInt, rhs: UInt) -> Bool {
    return Bool(Builtin.cmp_ult_Int64(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout UInt, rhs: UInt) {
    let (result, overflow) =
      Builtin.uadd_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt(result)
  }
  public static func -=(lhs: inout UInt, rhs: UInt) {
    let (result, overflow) =
      Builtin.usub_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt(result)
  }
  public static func *=(lhs: inout UInt, rhs: UInt) {
    let (result, overflow) =
      Builtin.umul_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt(result)
  }
  public static func /=(lhs: inout UInt, rhs: UInt) {
    if _slowPath(rhs == (0 as UInt)) {
      _preconditionFailure(
        "Division by zero")
    }
    let (result, overflow) =
      (Builtin.udiv_Int64(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = UInt(result)
  }
  public func addingReportingOverflow(
    _ other: UInt
  ) -> (partialValue: UInt, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.uadd_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: UInt
  ) -> (partialValue: UInt, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.usub_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: UInt
  ) -> (partialValue: UInt, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.umul_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: UInt(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: UInt
  ) -> (partialValue: UInt, overflow: Bool) {
    if _slowPath(other == (0 as UInt)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.udiv_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: UInt(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: UInt
  ) -> (partialValue: UInt, overflow: Bool) {
    if _slowPath(other == (0 as UInt)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.urem_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: UInt(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout UInt, rhs: UInt) {
    if _slowPath(rhs == (0 as UInt)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.urem_Int64(lhs._value, rhs._value),
      false._value)
    lhs = UInt(newStorage)
  }
  public init(_ _value: Builtin.Int64) {
    self._value = _value
  }
  public static func &=(lhs: inout UInt, rhs: UInt) {
    lhs = UInt(Builtin.and_Int64(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout UInt, rhs: UInt) {
    lhs = UInt(Builtin.or_Int64(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout UInt, rhs: UInt) {
    lhs = UInt(Builtin.xor_Int64(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout UInt, rhs: UInt) {
    let rhs_ = rhs & 63
    lhs = UInt(
      Builtin.lshr_Int64(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout UInt, rhs: UInt) {
    let rhs_ = rhs & 63
    lhs = UInt(
      Builtin.shl_Int64(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 64 }
  public var leadingZeroBitCount: Int {
    return Int(
      UInt(
        Builtin.int_ctlz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      UInt(
        Builtin.int_cttz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      UInt(
        Builtin.int_ctpop_Int64(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<UInt.Words>
    @usableFromInline
    internal var _value: UInt
    @inlinable
    public init(_ value: UInt) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (64 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> UInt(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.zextOrBitCast_Int64_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int64(bits._value))
  }
  public typealias Magnitude = UInt
  #if !(arch(arm) || arch(i386) || arch(wasm32))
  @inlinable
  public func multipliedFullWidth(by other: UInt)
    -> (high: UInt, low: UInt.Magnitude) {
    let lhs_ = Builtin.zext_Int64_Int128(self._value)
    let rhs_ = Builtin.zext_Int64_Int128(other._value)
    let res = Builtin.mul_Int128(lhs_, rhs_)
    let low = UInt.Magnitude(Builtin.truncOrBitCast_Int128_Int64(res))
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let shifted = Builtin.ashr_Int128(res, shift)
    let high = UInt(Builtin.truncOrBitCast_Int128_Int64(shifted))
    return (high: high, low: low)
  }
  #endif
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: UInt, low: UInt.Magnitude)
  ) -> (quotient: UInt, remainder: UInt) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.zext_Int64_Int128(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let lhsHighShifted = Builtin.shl_Int128(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int64_Int128(dividend.low._value)
    let lhs_ = Builtin.or_Int128(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.zext_Int64_Int128(self._value)
    let quotient_ = Builtin.udiv_Int128(lhs_, rhs_)
    let remainder_ = Builtin.urem_Int128(lhs_, rhs_)
    let quotient = UInt(
      Builtin.truncOrBitCast_Int128_Int64(quotient_))
    let remainder = UInt(
      Builtin.truncOrBitCast_Int128_Int64(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: UInt {
    return UInt(Builtin.int_bswap_Int64(_value))
  }
  public 
  init(_ _v: Builtin.Word) {
    self._value = Builtin.zextOrBitCast_Word_Int64(_v)
  }
  public 
  var _builtinWordValue: Builtin.Word {
    return Builtin.truncOrBitCast_Int64_Word(_value)
  }
  @inlinable
  @inline(__always)
  public func signum() -> UInt {
    let isPositive = UInt(Builtin.zext_Int1_Int64(
      (self > (0 as UInt))._value))
    return isPositive | (self &>> 63)
  }
}
extension UInt: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(seed: seed, UInt64(_value))
  }
}
extension UInt: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension UInt {
  public static func &(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: UInt, rhs: UInt) -> UInt {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: UInt, rhs: UInt) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: UInt, rhs: UInt) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: UInt, rhs: UInt) -> Bool {
    return rhs < lhs
  }
}
extension UInt: Sendable { }
@frozen
public struct Int
  : FixedWidthInteger, SignedInteger,
    _ExpressibleByBuiltinIntegerLiteral {
  public typealias IntegerLiteralType = Int
  public var _value: Builtin.Int64
  public init(_builtinIntegerLiteral x: Builtin.IntLiteral) {
    _value = Builtin.s_to_s_checked_trunc_IntLiteral_Int64(x).0
  }
  public init(bitPattern x: UInt) {
    _value = x._value
  }
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
  @available(SwiftStdlib 5.3, *)
  public init(_ source: Float16) {
    _precondition(source.isFinite,
      "Float16 value cannot be converted to Int because it is either infinite or NaN")
    self._value = Builtin.fptosi_FPIEEE16_Int64(source._value)
  }
  @available(SwiftStdlib 5.3, *)
  public init?(exactly source: Float16) {
    guard source.isFinite else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE16_Int64(source._value)
  }
#endif
  public init(_ source: Float) {
    _precondition(source.isFinite,
      "Float value cannot be converted to Int because it is either infinite or NaN")
    _precondition(source > -9223373136366403584.0,
      "Float value cannot be converted to Int because the result would be less than Int.min")
    _precondition(source < 9223372036854775808.0,
      "Float value cannot be converted to Int because the result would be greater than Int.max")
    self._value = Builtin.fptosi_FPIEEE32_Int64(source._value)
  }
  public init?(exactly source: Float) {
    guard source > -9223373136366403584.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE32_Int64(source._value)
  }
  public init(_ source: Double) {
    _precondition(source.isFinite,
      "Double value cannot be converted to Int because it is either infinite or NaN")
    _precondition(source > -9223372036854777856.0,
      "Double value cannot be converted to Int because the result would be less than Int.min")
    _precondition(source < 9223372036854775808.0,
      "Double value cannot be converted to Int because the result would be greater than Int.max")
    self._value = Builtin.fptosi_FPIEEE64_Int64(source._value)
  }
  public init?(exactly source: Double) {
    guard source > -9223372036854777856.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE64_Int64(source._value)
  }
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
  public init(_ source: Float80) {
    _precondition(source.isFinite,
      "Float80 value cannot be converted to Int because it is either infinite or NaN")
    _precondition(source > -9223372036854775809.0,
      "Float80 value cannot be converted to Int because the result would be less than Int.min")
    _precondition(source < 9223372036854775808.0,
      "Float80 value cannot be converted to Int because the result would be greater than Int.max")
    self._value = Builtin.fptosi_FPIEEE80_Int64(source._value)
  }
  public init?(exactly source: Float80) {
    guard source > -9223372036854775809.0 && source < 9223372036854775808.0 else {
      return nil
    }
    guard source == source.rounded(.towardZero) else {
      return nil
    }
    self._value = Builtin.fptosi_FPIEEE80_Int64(source._value)
  }
#endif
  public static func == (lhs: Int, rhs: Int) -> Bool {
    return Bool(Builtin.cmp_eq_Int64(lhs._value, rhs._value))
  }
  public static func < (lhs: Int, rhs: Int) -> Bool {
    return Bool(Builtin.cmp_slt_Int64(lhs._value, rhs._value))
  }
  public static func +=(lhs: inout Int, rhs: Int) {
    let (result, overflow) =
      Builtin.sadd_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int(result)
  }
  public static func -=(lhs: inout Int, rhs: Int) {
    let (result, overflow) =
      Builtin.ssub_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int(result)
  }
  public static func *=(lhs: inout Int, rhs: Int) {
    let (result, overflow) =
      Builtin.smul_with_overflow_Int64(
        lhs._value, rhs._value, true._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int(result)
  }
  public static func /=(lhs: inout Int, rhs: Int) {
    if _slowPath(rhs == (0 as Int)) {
      _preconditionFailure(
        "Division by zero")
    }
    if _slowPath(
      lhs == Int.min && rhs == (-1 as Int)
    ) {
      _preconditionFailure(
        "Division results in an overflow")
    }
    let (result, overflow) =
      (Builtin.sdiv_Int64(lhs._value, rhs._value),
      false._value)
    Builtin.condfail_message(overflow,
      StaticString("arithmetic overflow").unsafeRawPointer)
    lhs = Int(result)
  }
  public func addingReportingOverflow(
    _ other: Int
  ) -> (partialValue: Int, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.sadd_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int(newStorage),
      overflow: Bool(overflow))
  }
  public func subtractingReportingOverflow(
    _ other: Int
  ) -> (partialValue: Int, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.ssub_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int(newStorage),
      overflow: Bool(overflow))
  }
  public func multipliedReportingOverflow(
    by other: Int
  ) -> (partialValue: Int, overflow: Bool) {
    let (newStorage, overflow) =
      Builtin.smul_with_overflow_Int64(
        self._value, other._value, false._value)
    return (
      partialValue: Int(newStorage),
      overflow: Bool(overflow))
  }
  public func dividedReportingOverflow(
    by other: Int
  ) -> (partialValue: Int, overflow: Bool) {
    if _slowPath(other == (0 as Int)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int.min && other == (-1 as Int)) {
      return (partialValue: self, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.sdiv_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: Int(newStorage),
      overflow: Bool(overflow))
  }
  public func remainderReportingOverflow(
    dividingBy other: Int
  ) -> (partialValue: Int, overflow: Bool) {
    if _slowPath(other == (0 as Int)) {
      return (partialValue: self, overflow: true)
    }
    if _slowPath(self == Int.min && other == (-1 as Int)) {
      return (partialValue: 0, overflow: true)
    }
    let (newStorage, overflow) = (
      Builtin.srem_Int64(self._value, other._value),
      false._value)
    return (
      partialValue: Int(newStorage),
      overflow: Bool(overflow))
  }
  public static func %=(lhs: inout Int, rhs: Int) {
    if _slowPath(rhs == (0 as Int)) {
      _preconditionFailure(
        "Division by zero in remainder operation")
    }
    if _slowPath(lhs == Int.min && rhs == (-1 as Int)) {
      _preconditionFailure(
        "Division results in an overflow in remainder operation")
    }
    let (newStorage, _) = (
      Builtin.srem_Int64(lhs._value, rhs._value),
      false._value)
    lhs = Int(newStorage)
  }
  public init(_ _value: Builtin.Int64) {
    self._value = _value
  }
  public static func &=(lhs: inout Int, rhs: Int) {
    lhs = Int(Builtin.and_Int64(lhs._value, rhs._value))
  }
  public static func |=(lhs: inout Int, rhs: Int) {
    lhs = Int(Builtin.or_Int64(lhs._value, rhs._value))
  }
  public static func ^=(lhs: inout Int, rhs: Int) {
    lhs = Int(Builtin.xor_Int64(lhs._value, rhs._value))
  }
  public static func &>>=(lhs: inout Int, rhs: Int) {
    let rhs_ = rhs & 63
    lhs = Int(
      Builtin.ashr_Int64(lhs._value, rhs_._value))
  }
  public static func &<<=(lhs: inout Int, rhs: Int) {
    let rhs_ = rhs & 63
    lhs = Int(
      Builtin.shl_Int64(lhs._value, rhs_._value))
  }
  public static var bitWidth: Int { return 64 }
  public var leadingZeroBitCount: Int {
    return Int(
      Int(
        Builtin.int_ctlz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var trailingZeroBitCount: Int {
    return Int(
      Int(
        Builtin.int_cttz_Int64(self._value, false._value)
      )._lowWord._value)
  }
  public var nonzeroBitCount: Int {
    return Int(
      Int(
        Builtin.int_ctpop_Int64(self._value)
      )._lowWord._value)
  }
  @frozen
  public struct Words: RandomAccessCollection, Sendable {
    public typealias Indices = Range<Int>
    public typealias SubSequence = Slice<Int.Words>
    @usableFromInline
    internal var _value: Int
    @inlinable
    public init(_ value: Int) {
      self._value = value
    }
    @inlinable
    public var count: Int {
      return (64 + 64 - 1) / 64
    }
    @inlinable
    public var startIndex: Int { return 0 }
    @inlinable
    public var endIndex: Int { return count }
    @inlinable
    public var indices: Indices { return startIndex ..< endIndex }
    public func index(after i: Int) -> Int { return i + 1 }
    public func index(before i: Int) -> Int { return i - 1 }
    @inlinable
    public subscript(position: Int) -> UInt {
      get {
        _precondition(position >= 0, "Negative word index")
        _precondition(position < endIndex, "Word index out of range")
        let shift = UInt(position._value) &* 64
        _internalInvariant(shift < UInt(_value.bitWidth._value))
        return (_value &>> Int(_truncatingBits: shift))._lowWord
      }
    }
  }
  public var words: Words {
    return Words(self)
  }
  public 
  var _lowWord: UInt {
    return UInt(
      Builtin.sextOrBitCast_Int64_Int64(_value)
    )
  }
  public 
  init(_truncatingBits bits: UInt) {
    self.init(
      Builtin.truncOrBitCast_Int64_Int64(bits._value))
  }
  public typealias Magnitude = UInt
  public var magnitude: UInt {
    let base = UInt(_value)
    return self < (0 as Int) ? ~base &+ 1 : base
  }
  #if !(arch(arm) || arch(i386) || arch(wasm32))
  @inlinable
  public func multipliedFullWidth(by other: Int)
    -> (high: Int, low: Int.Magnitude) {
    let lhs_ = Builtin.sext_Int64_Int128(self._value)
    let rhs_ = Builtin.sext_Int64_Int128(other._value)
    let res = Builtin.mul_Int128(lhs_, rhs_)
    let low = Int.Magnitude(Builtin.truncOrBitCast_Int128_Int64(res))
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let shifted = Builtin.ashr_Int128(res, shift)
    let high = Int(Builtin.truncOrBitCast_Int128_Int64(shifted))
    return (high: high, low: low)
  }
  #endif
  @inlinable
  public func dividingFullWidth(
    _ dividend: (high: Int, low: Int.Magnitude)
  ) -> (quotient: Int, remainder: Int) {
    _precondition(self != 0, "Division by zero")
    let lhsHigh = Builtin.sext_Int64_Int128(dividend.high._value)
    let shift = Builtin.zextOrBitCast_Int8_Int128(UInt8(64)._value)
    let lhsHighShifted = Builtin.shl_Int128(lhsHigh, shift)
    let lhsLow = Builtin.zext_Int64_Int128(dividend.low._value)
    let lhs_ = Builtin.or_Int128(lhsHighShifted, lhsLow)
    let rhs_ = Builtin.sext_Int64_Int128(self._value)
    let quotient_ = Builtin.sdiv_Int128(lhs_, rhs_)
    let remainder_ = Builtin.srem_Int128(lhs_, rhs_)
    let quotient = Int(
      Builtin.truncOrBitCast_Int128_Int64(quotient_))
    let remainder = Int(
      Builtin.truncOrBitCast_Int128_Int64(remainder_))
    return (quotient: quotient, remainder: remainder)
  }
  public var byteSwapped: Int {
    return Int(Builtin.int_bswap_Int64(_value))
  }
  public 
  init(_ _v: Builtin.Word) {
    self._value = Builtin.sextOrBitCast_Word_Int64(_v)
  }
  public 
  var _builtinWordValue: Builtin.Word {
    return Builtin.truncOrBitCast_Int64_Word(_value)
  }
  @inlinable
  @inline(__always)
  public func signum() -> Int {
    let isPositive = Int(Builtin.zext_Int1_Int64(
      (self > (0 as Int))._value))
    return isPositive | (self &>> 63)
  }
}
extension Int: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher._combine(UInt(_value))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(seed: seed, UInt64(_value))
  }
}
extension Int: _HasCustomAnyHashableRepresentation {
  public func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _IntegerAnyHashableBox(self))
  }
}
extension Int {
  public static func &(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs &= rhs
    return lhs
  }
  public static func |(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs |= rhs
    return lhs
  }
  public static func ^(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs ^= rhs
    return lhs
  }
  public static func &>>(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs &>>= rhs
    return lhs
  }
  public static func &<<(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs &<<= rhs
    return lhs
  }
  public static func +(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs += rhs
    return lhs
  }
  public static func -(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs -= rhs
    return lhs
  }
  public static func *(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs *= rhs
    return lhs
  }
  public static func /(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs /= rhs
    return lhs
  }
  public static func %(lhs: Int, rhs: Int) -> Int {
    var lhs = lhs
    lhs %= rhs
    return lhs
  }
  public static func <= (lhs: Int, rhs: Int) -> Bool {
    return !(rhs < lhs)
  }
  public static func >= (lhs: Int, rhs: Int) -> Bool {
    return !(lhs < rhs)
  }
  public static func > (lhs: Int, rhs: Int) -> Bool {
    return rhs < lhs
  }
}
extension Int: Sendable { }
public func _assumeNonNegative(_ x: Int) -> Int {
  _internalInvariant(x >= (0 as Int))
  return Int(Builtin.assumeNonNegative_Int64(x._value))
}
extension Int {
  public func distance(to other: Int) -> Int {
    return other - self
  }
  public func advanced(by n: Int) -> Int {
    return self + n
  }
}
@inlinable
internal func _unsafePlus(_ lhs: Int, _ rhs: Int) -> Int {
#if INTERNAL_CHECKS_ENABLED
  return lhs + rhs
#else
  return lhs &+ rhs
#endif
}
@inlinable
internal func _unsafeMinus(_ lhs: Int, _ rhs: Int) -> Int {
#if INTERNAL_CHECKS_ENABLED
  return lhs - rhs
#else
  return lhs &- rhs
#endif
}
internal struct _IntegerAnyHashableBox<
  Base: FixedWidthInteger
>: _AnyHashableBox {
  internal let _value: Base
  internal init(_ value: Base) {
    self._value = value
  }
  internal var _canonicalBox: _AnyHashableBox {
    if _value < 0 {
      return _IntegerAnyHashableBox<Int64>(Int64(truncatingIfNeeded: _value))
    }
    return _IntegerAnyHashableBox<UInt64>(UInt64(truncatingIfNeeded: _value))
  }
  internal func _isEqual(to box: _AnyHashableBox) -> Bool? {
    if Base.self == UInt64.self {
      guard let box = box as? _IntegerAnyHashableBox<UInt64> else { return nil }
      return _value == box._value
    }
    if Base.self == Int64.self {
      guard let box = box as? _IntegerAnyHashableBox<Int64> else { return nil }
      return _value == box._value
    }
    _preconditionFailure("self isn't canonical")
  }
  internal var _hashValue: Int {
    _internalInvariant(Base.self == UInt64.self || Base.self == Int64.self,
      "self isn't canonical")
    return _value.hashValue
  }
  internal func _hash(into hasher: inout Hasher) {
    _internalInvariant(Base.self == UInt64.self || Base.self == Int64.self,
      "self isn't canonical")
    _value.hash(into: &hasher)
  }
  internal func _rawHashValue(_seed: Int) -> Int {
    _internalInvariant(Base.self == UInt64.self || Base.self == Int64.self,
      "self isn't canonical")
    return _value._rawHashValue(seed: _seed)
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
