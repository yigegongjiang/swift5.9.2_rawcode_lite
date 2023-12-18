extension SIMD2 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = UInt8.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_eq_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ne_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ult_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ule_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ugt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_uge_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD4 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = UInt8.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ult_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ule_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ugt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_uge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD8 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = UInt8.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_eq_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ne_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ult_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ule_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ugt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_uge_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD16 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = UInt8.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_eq_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ne_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ult_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ule_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ugt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_uge_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD32 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = UInt8.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_eq_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ne_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ult_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ule_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ugt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_uge_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD64 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = UInt8.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_eq_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ne_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ult_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ule_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ugt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_uge_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD3 where Scalar == UInt8 {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = UInt8.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ult_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ule_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ugt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_uge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD2<Int8> {
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = SIMD2<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD2<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.and_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.xor_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.or_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD2 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = Int8.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_eq_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ne_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_slt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sle_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sgt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sge_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD4<Int8> {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = SIMD4<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD4<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.and_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.xor_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.or_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD4 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = Int8.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_slt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sle_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sgt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD8<Int8> {
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = SIMD8<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD8<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.and_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.xor_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.or_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD8 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = Int8.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_eq_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ne_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_slt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sle_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sgt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sge_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD16<Int8> {
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = SIMD16<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD16<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.and_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.xor_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.or_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD16 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = Int8.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_eq_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ne_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_slt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sle_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sgt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sge_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD32<Int8> {
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = SIMD32<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD32<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.and_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.xor_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.or_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD32 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = Int8.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_eq_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ne_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_slt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sle_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sgt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sge_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD64<Int8> {
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = SIMD64<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD64<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.and_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.xor_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.or_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD64 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = Int8.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_eq_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ne_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_slt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sle_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sgt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sge_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD3<Int8> {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = SIMD3<Int8>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD3<Int8>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.and_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.xor_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.or_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD3 where Scalar == Int8 {
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = Int8.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_slt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sle_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sgt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD2 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = UInt16.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_eq_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ne_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ult_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ule_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ugt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_uge_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD4 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = UInt16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ult_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ule_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ugt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_uge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD8 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = UInt16.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_eq_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ne_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ult_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ule_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ugt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_uge_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD16 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = UInt16.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_eq_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ne_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ult_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ule_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ugt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_uge_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD32 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = UInt16.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_eq_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ne_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ult_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ule_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ugt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_uge_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD64 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = UInt16.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_eq_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ne_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ult_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ule_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ugt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_uge_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD3 where Scalar == UInt16 {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = UInt16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ult_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ule_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ugt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_uge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD2<Int16> {
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = SIMD2<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD2<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.and_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.xor_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.or_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD2 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = Int16.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_eq_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ne_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_slt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sle_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sgt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sge_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD4<Int16> {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = SIMD4<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD4<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.and_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.xor_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.or_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD4 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = Int16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_slt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sle_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sgt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD8<Int16> {
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = SIMD8<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD8<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.and_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.xor_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.or_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD8 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = Int16.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_eq_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ne_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_slt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sle_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sgt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sge_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD16<Int16> {
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = SIMD16<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD16<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.and_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.xor_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.or_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD16 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = Int16.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_eq_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ne_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_slt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sle_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sgt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sge_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD32<Int16> {
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = SIMD32<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD32<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.and_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.xor_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.or_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD32 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = Int16.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_eq_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ne_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_slt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sle_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sgt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sge_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD64<Int16> {
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = SIMD64<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD64<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.and_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.xor_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.or_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD64 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = Int16.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_eq_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ne_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_slt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sle_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sgt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sge_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD3<Int16> {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = SIMD3<Int16>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD3<Int16>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.and_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.xor_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.or_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD3 where Scalar == Int16 {
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = Int16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_slt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sle_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sgt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD2 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = UInt32.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_eq_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ne_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ult_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ule_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ugt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_uge_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD4 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = UInt32.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ult_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ule_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ugt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_uge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD8 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = UInt32.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_eq_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ne_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ult_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ule_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ugt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_uge_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD16 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = UInt32.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_eq_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ne_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ult_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ule_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ugt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_uge_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD32 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = UInt32.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_eq_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ne_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ult_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ule_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ugt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_uge_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD64 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = UInt32.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_eq_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ne_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ult_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ule_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ugt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_uge_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD3 where Scalar == UInt32 {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = UInt32.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ult_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ule_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ugt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_uge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD2<Int32> {
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = SIMD2<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD2<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.and_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.xor_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.or_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD2 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = Int32.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_eq_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ne_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_slt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sle_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sgt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sge_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD4<Int32> {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = SIMD4<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD4<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.and_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.xor_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.or_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD4 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = Int32.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_slt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sle_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sgt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD8<Int32> {
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = SIMD8<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD8<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.and_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.xor_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.or_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD8 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = Int32.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_eq_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ne_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_slt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sle_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sgt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sge_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD16<Int32> {
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = SIMD16<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD16<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.and_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.xor_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.or_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD16 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = Int32.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_eq_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ne_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_slt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sle_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sgt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sge_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD32<Int32> {
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = SIMD32<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD32<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.and_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.xor_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.or_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD32 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = Int32.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_eq_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ne_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_slt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sle_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sgt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sge_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD64<Int32> {
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = SIMD64<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD64<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.and_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.xor_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.or_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD64 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = Int32.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_eq_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ne_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_slt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sle_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sgt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sge_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD3<Int32> {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = SIMD3<Int32>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD3<Int32>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.and_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.xor_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.or_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD3 where Scalar == Int32 {
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = Int32.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_slt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sle_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sgt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD2 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = UInt64.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ult_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ule_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ugt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_uge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD4 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt64.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD8 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = UInt64.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ult_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ule_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ugt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_uge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD16 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = UInt64.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ult_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ule_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ugt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_uge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD32 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = UInt64.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ult_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ule_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ugt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_uge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD64 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = UInt64.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ult_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ule_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ugt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_uge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD3 where Scalar == UInt64 {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt64.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD2<Int64> {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = SIMD2<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD2<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.and_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.xor_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.or_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD2 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = Int64.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_slt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sle_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sgt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD4<Int64> {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD4<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD4<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD4 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int64.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD8<Int64> {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = SIMD8<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD8<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.and_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.xor_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.or_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD8 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = Int64.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_slt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sle_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sgt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD16<Int64> {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = SIMD16<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD16<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.and_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.xor_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.or_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD16 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = Int64.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_slt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sle_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sgt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD32<Int64> {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = SIMD32<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD32<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.and_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.xor_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.or_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD32 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = Int64.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_slt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sle_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sgt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD64<Int64> {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = SIMD64<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD64<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.and_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.xor_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.or_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD64 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = Int64.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_slt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sle_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sgt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD3<Int64> {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD3<Int64>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD3<Int64>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD3 where Scalar == Int64 {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int64.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD2 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = UInt.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ult_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ule_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ugt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_uge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD4 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD8 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = UInt.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ult_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ule_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ugt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_uge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD16 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = UInt.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ult_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ule_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ugt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_uge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD32 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = UInt.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ult_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ule_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ugt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_uge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD64 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = UInt.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ult_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ule_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ugt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_uge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMD3 where Scalar == UInt {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD2<Int> {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = SIMD2<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD2<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.and_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.xor_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.or_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD2 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = Int.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_slt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sle_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sgt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD4<Int> {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD4<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD4<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD4 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD8<Int> {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = SIMD8<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD8<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.and_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.xor_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.or_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD8 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = Int.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_slt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sle_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sgt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD16<Int> {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = SIMD16<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD16<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.and_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.xor_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.or_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD16 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = Int.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_slt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sle_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sgt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD32<Int> {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = SIMD32<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD32<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.and_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.xor_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.or_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD32 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = Int.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_slt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sle_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sgt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD64<Int> {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = SIMD64<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD64<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.and_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.xor_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.or_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD64 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = Int.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_slt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sle_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sgt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
extension SIMDMask where Storage == SIMD3<Int> {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD3<Int>(_builtin)
  }
  internal static var allTrue: Self {
    let zero = SIMD3<Int>()
    return zero .== zero
  }
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}
extension SIMD3 where Scalar == Int {
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD2 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec2xFPIEEE16) {
    _storage = Float16.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_oeq_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_une_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_olt_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_ole_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_ogt_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_oge_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD4 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE16) {
    _storage = Float16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oeq_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_une_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_olt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ole_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ogt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oge_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD8 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec8xFPIEEE16) {
    _storage = Float16.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_oeq_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_une_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_olt_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_ole_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_ogt_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_oge_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD16 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec16xFPIEEE16) {
    _storage = Float16.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_oeq_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_une_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_olt_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_ole_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_ogt_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_oge_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD32 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec32xFPIEEE16) {
    _storage = Float16.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_oeq_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_une_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_olt_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_ole_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_ogt_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_oge_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD64 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec64xFPIEEE16) {
    _storage = Float16.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_oeq_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_une_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_olt_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_ole_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_ogt_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_oge_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension SIMD3 where Scalar == Float16 {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE16) {
    _storage = Float16.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oeq_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_une_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_olt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ole_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ogt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oge_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
#endif
extension SIMD2 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec2xFPIEEE32) {
    _storage = Float.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_oeq_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_une_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_olt_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_ole_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_ogt_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_oge_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD4 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE32) {
    _storage = Float.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oeq_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_une_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_olt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ole_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ogt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oge_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD8 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec8xFPIEEE32) {
    _storage = Float.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_oeq_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_une_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_olt_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_ole_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_ogt_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_oge_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD16 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec16xFPIEEE32) {
    _storage = Float.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_oeq_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_une_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_olt_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_ole_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_ogt_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_oge_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD32 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec32xFPIEEE32) {
    _storage = Float.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_oeq_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_une_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_olt_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_ole_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_ogt_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_oge_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD64 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec64xFPIEEE32) {
    _storage = Float.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_oeq_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_une_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_olt_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_ole_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_ogt_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_oge_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD3 where Scalar == Float {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE32) {
    _storage = Float.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oeq_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_une_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_olt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ole_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ogt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oge_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD2 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec2xFPIEEE64) {
    _storage = Double.SIMD2Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_oeq_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_une_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_olt_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_ole_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_ogt_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_oge_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD4 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE64) {
    _storage = Double.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oeq_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_une_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_olt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ole_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ogt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oge_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD8 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec8xFPIEEE64) {
    _storage = Double.SIMD8Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_oeq_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_une_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_olt_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_ole_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_ogt_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_oge_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD16 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec16xFPIEEE64) {
    _storage = Double.SIMD16Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_oeq_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_une_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_olt_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_ole_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_ogt_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_oge_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD32 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec32xFPIEEE64) {
    _storage = Double.SIMD32Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_oeq_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_une_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_olt_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_ole_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_ogt_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_oge_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD64 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec64xFPIEEE64) {
    _storage = Double.SIMD64Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_oeq_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_une_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_olt_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_ole_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_ogt_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_oge_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
extension SIMD3 where Scalar == Double {
  internal init(_ _builtin: Builtin.Vec4xFPIEEE64) {
    _storage = Double.SIMD4Storage(_builtin)
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oeq_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_une_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_olt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ole_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ogt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oge_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
