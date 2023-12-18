// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 1)
//===--- SIMDConcreteOperations.swift -------------------------*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2021 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 19)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = UInt8.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_eq_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ne_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ult_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ule_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ugt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_uge_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = UInt8.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ult_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ule_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ugt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_uge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = UInt8.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_eq_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ne_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ult_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ule_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ugt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_uge_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = UInt8.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_eq_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ne_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ult_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ule_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ugt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_uge_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = UInt8.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_eq_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ne_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ult_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ule_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ugt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_uge_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = UInt8.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_eq_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ne_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ult_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ule_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ugt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_uge_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == UInt8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = UInt8.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ult_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ule_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ugt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_uge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD2<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = SIMD2<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD2<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.and_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.xor_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int8>(Builtin.or_Vec2xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt8) {
    _storage = Int8.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_eq_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_ne_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_slt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sle_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sgt_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt8(
      Builtin.cmp_sge_Vec2xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD4<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = SIMD4<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD4<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.and_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.xor_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int8>(Builtin.or_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = Int8.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_slt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sle_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sgt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD8<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = SIMD8<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD8<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.and_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.xor_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int8>(Builtin.or_Vec8xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt8) {
    _storage = Int8.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_eq_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_ne_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_slt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sle_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sgt_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt8(
      Builtin.cmp_sge_Vec8xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD16<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = SIMD16<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD16<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.and_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.xor_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int8>(Builtin.or_Vec16xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt8) {
    _storage = Int8.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_eq_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_ne_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_slt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sle_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sgt_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt8(
      Builtin.cmp_sge_Vec16xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD32<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = SIMD32<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD32<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.and_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.xor_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int8>(Builtin.or_Vec32xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt8) {
    _storage = Int8.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_eq_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_ne_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_slt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sle_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sgt_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt8(
      Builtin.cmp_sge_Vec32xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD64<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = SIMD64<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD64<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.and_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.xor_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int8>(Builtin.or_Vec64xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt8) {
    _storage = Int8.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_eq_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_ne_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_slt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sle_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sgt_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt8(
      Builtin.cmp_sge_Vec64xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD3<Int8> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = SIMD3<Int8>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD3<Int8>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.and_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.xor_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int8>(Builtin.or_Vec4xInt8(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int8>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == Int8 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt8) {
    _storage = Int8.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_eq_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_ne_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_slt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sle_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sgt_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt8(
      Builtin.cmp_sge_Vec4xInt8(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt8(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt8(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = UInt16.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_eq_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ne_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ult_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ule_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ugt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_uge_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = UInt16.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ult_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ule_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ugt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_uge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = UInt16.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_eq_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ne_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ult_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ule_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ugt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_uge_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = UInt16.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_eq_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ne_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ult_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ule_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ugt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_uge_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = UInt16.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_eq_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ne_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ult_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ule_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ugt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_uge_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = UInt16.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_eq_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ne_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ult_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ule_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ugt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_uge_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == UInt16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = UInt16.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ult_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ule_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ugt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_uge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD2<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = SIMD2<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD2<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.and_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.xor_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int16>(Builtin.or_Vec2xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt16) {
    _storage = Int16.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_eq_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_ne_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_slt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sle_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sgt_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.cmp_sge_Vec2xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD4<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = SIMD4<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD4<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.and_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.xor_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int16>(Builtin.or_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = Int16.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_slt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sle_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sgt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD8<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = SIMD8<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD8<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.and_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.xor_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int16>(Builtin.or_Vec8xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt16) {
    _storage = Int16.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_eq_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_ne_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_slt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sle_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sgt_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.cmp_sge_Vec8xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD16<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = SIMD16<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD16<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.and_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.xor_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int16>(Builtin.or_Vec16xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt16) {
    _storage = Int16.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_eq_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_ne_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_slt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sle_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sgt_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.cmp_sge_Vec16xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD32<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = SIMD32<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD32<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.and_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.xor_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int16>(Builtin.or_Vec32xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt16) {
    _storage = Int16.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_eq_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_ne_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_slt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sle_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sgt_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.cmp_sge_Vec32xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD64<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = SIMD64<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD64<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.and_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.xor_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int16>(Builtin.or_Vec64xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt16) {
    _storage = Int16.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_eq_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_ne_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_slt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sle_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sgt_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.cmp_sge_Vec64xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD3<Int16> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = SIMD3<Int16>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD3<Int16>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.and_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.xor_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int16>(Builtin.or_Vec4xInt16(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int16>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == Int16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt16) {
    _storage = Int16.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_eq_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_ne_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_slt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sle_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sgt_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.cmp_sge_Vec4xInt16(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt16(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt16(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = UInt32.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_eq_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ne_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ult_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ule_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ugt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_uge_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = UInt32.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ult_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ule_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ugt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_uge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = UInt32.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_eq_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ne_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ult_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ule_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ugt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_uge_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = UInt32.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_eq_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ne_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ult_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ule_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ugt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_uge_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = UInt32.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_eq_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ne_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ult_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ule_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ugt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_uge_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = UInt32.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_eq_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ne_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ult_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ule_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ugt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_uge_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == UInt32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = UInt32.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ult_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ule_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ugt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_uge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD2<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = SIMD2<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD2<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.and_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.xor_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int32>(Builtin.or_Vec2xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt32) {
    _storage = Int32.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_eq_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_ne_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_slt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sle_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sgt_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.cmp_sge_Vec2xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD4<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = SIMD4<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD4<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.and_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.xor_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int32>(Builtin.or_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = Int32.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_slt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sle_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sgt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD8<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = SIMD8<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD8<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.and_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.xor_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int32>(Builtin.or_Vec8xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt32) {
    _storage = Int32.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_eq_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_ne_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_slt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sle_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sgt_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.cmp_sge_Vec8xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD16<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = SIMD16<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD16<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.and_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.xor_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int32>(Builtin.or_Vec16xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt32) {
    _storage = Int32.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_eq_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_ne_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_slt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sle_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sgt_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.cmp_sge_Vec16xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD32<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = SIMD32<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD32<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.and_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.xor_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int32>(Builtin.or_Vec32xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt32) {
    _storage = Int32.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_eq_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_ne_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_slt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sle_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sgt_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.cmp_sge_Vec32xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD64<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = SIMD64<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD64<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.and_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.xor_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int32>(Builtin.or_Vec64xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt32) {
    _storage = Int32.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_eq_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_ne_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_slt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sle_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sgt_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.cmp_sge_Vec64xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD3<Int32> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = SIMD3<Int32>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD3<Int32>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.and_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.xor_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int32>(Builtin.or_Vec4xInt32(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int32>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == Int32 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt32) {
    _storage = Int32.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_eq_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_ne_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_slt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sle_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sgt_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.cmp_sge_Vec4xInt32(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt32(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt32(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = UInt64.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ult_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ule_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ugt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_uge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt64.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = UInt64.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ult_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ule_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ugt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_uge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = UInt64.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ult_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ule_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ugt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_uge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = UInt64.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ult_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ule_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ugt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_uge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = UInt64.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ult_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ule_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ugt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_uge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == UInt64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt64.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD2<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = SIMD2<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD2<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.and_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.xor_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int64>(Builtin.or_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = Int64.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_slt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sle_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sgt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD4<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD4<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD4<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int64>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int64.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD8<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = SIMD8<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD8<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.and_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.xor_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int64>(Builtin.or_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = Int64.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_slt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sle_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sgt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD16<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = SIMD16<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD16<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.and_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.xor_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int64>(Builtin.or_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = Int64.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_slt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sle_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sgt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD32<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = SIMD32<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD32<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.and_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.xor_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int64>(Builtin.or_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = Int64.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_slt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sle_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sgt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD64<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = SIMD64<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD64<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.and_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.xor_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int64>(Builtin.or_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = Int64.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_slt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sle_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sgt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD3<Int64> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD3<Int64>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD3<Int64>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int64>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int64>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == Int64 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int64.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = UInt.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ult_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ule_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ugt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_uge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = UInt.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ult_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ule_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ugt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_uge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = UInt.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ult_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ule_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ugt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_uge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = UInt.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ult_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ule_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ugt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_uge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = UInt.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ult_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ule_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ugt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_uge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == UInt {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = UInt.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ult_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ule_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ugt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_uge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD2<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = SIMD2<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD2<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.and_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.xor_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD2<Int>(Builtin.or_Vec2xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD2<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD2 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xInt64) {
    _storage = Int.SIMD2Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_eq_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_ne_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_slt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sle_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sgt_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.cmp_sge_Vec2xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec2xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec2xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD4<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD4<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD4<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD4<Int>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD4<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD4 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD8<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = SIMD8<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD8<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.and_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.xor_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD8<Int>(Builtin.or_Vec8xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD8<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD8 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xInt64) {
    _storage = Int.SIMD8Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_eq_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_ne_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_slt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sle_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sgt_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.cmp_sge_Vec8xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec8xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec8xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD16<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = SIMD16<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD16<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.and_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.xor_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD16<Int>(Builtin.or_Vec16xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD16<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD16 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xInt64) {
    _storage = Int.SIMD16Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_eq_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_ne_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_slt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sle_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sgt_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.cmp_sge_Vec16xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec16xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec16xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD32<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = SIMD32<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD32<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.and_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.xor_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD32<Int>(Builtin.or_Vec32xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD32<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD32 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xInt64) {
    _storage = Int.SIMD32Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_eq_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_ne_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_slt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sle_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sgt_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.cmp_sge_Vec32xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec32xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec32xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD64<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = SIMD64<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD64<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.and_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.xor_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD64<Int>(Builtin.or_Vec64xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD64<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD64 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xInt64) {
    _storage = Int.SIMD64Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_eq_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_ne_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_slt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sle_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sgt_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.cmp_sge_Vec64xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec64xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec64xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 29)
extension SIMDMask where Storage == SIMD3<Int> {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = SIMD3<Int>(_builtin)
  }
  
  @_alwaysEmitIntoClient
  internal static var allTrue: Self {
    let zero = SIMD3<Int>()
    return zero .== zero
  }
  
  /// A vector mask that is the pointwise logical negation of the input.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = !a[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static prefix func .!(a: Self) -> Self {
    a .^ .allTrue
  }
    
  /// A vector mask that is the pointwise logical conjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] && b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `&&` operator, the SIMD `.&` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .&(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.and_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical conjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] && b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .&=(a: inout Self, b: Self) {
    a = a .& b
  }
      
  /// A vector mask that is the pointwise exclusive or of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.xor_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise exclusive or of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .^=(a: inout Self, b: Self) {
    a = a .^ b
  }
      
  /// A vector mask that is the pointwise logical disjunction of the inputs.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] || b[i]
  /// }
  /// ```
  ///
  /// Note that unlike the scalar `||` operator, the SIMD `.|` operator
  /// always fully evaluates both arguments.
  @_alwaysEmitIntoClient
  public static func .|(a: Self, b: Self) -> Self {
    Self(SIMD3<Int>(Builtin.or_Vec4xInt64(
      a._storage._storage._value,
      b._storage._storage._value
    )))
  }
    
  /// Replaces `a` with the pointwise logical disjunction of `a` and `b`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in a.indices {
  ///   a[i] = a[i] || b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .|=(a: inout Self, b: Self) {
    a = a .| b
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] == b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> Self {
    .!(a .^ b)
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  ///
  /// Equivalent to:
  /// ```
  /// var result = SIMDMask<SIMD3<Int>>()
  /// for i in result.indices {
  ///   result[i] = a[i] != b[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> Self {
    a .^ b
  }
    
  /// Replaces elements of this vector with elements of `other` in the lanes
  /// where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// for i in indices {
  ///   if mask[i] { self[i] = other[i] }
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public mutating func replace(with other: Self, where mask: Self) {
    self = replacing(with: other, where: mask)
  }
    
  /// Returns a copy of this vector, with elements replaced by elements of
  /// `other` in the lanes where `mask` is `true`.
  ///
  /// Equivalent to:
  /// ```
  /// var result = Self()
  /// for i in indices {
  ///   result[i] = mask[i] ? other[i] : self[i]
  /// }
  /// ```
  @_alwaysEmitIntoClient
  public func replacing(with other: Self, where mask: Self) -> Self {
    (self .& .!mask) .| (other .& mask)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 210)
extension SIMD3 where Scalar == Int {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xInt64) {
    _storage = Int.SIMD4Storage(_builtin)
  }
    
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_eq_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_ne_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_slt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sle_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sgt_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.cmp_sge_Vec4xInt64(a._storage._value, b._storage._value)
    ))
  }
    
  /// The wrapping sum of two vectors.
  @_alwaysEmitIntoClient
  public static func &+(a: Self, b: Self) -> Self {
    Self(Builtin.add_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The wrapping difference of two vectors.
  @_alwaysEmitIntoClient
  public static func &-(a: Self, b: Self) -> Self {
    Self(Builtin.sub_Vec4xInt64(a._storage._value, b._storage._value))
  }
    
  /// The pointwise wrapping product of two vectors.
  @_alwaysEmitIntoClient
  public static func &*(a: Self, b: Self) -> Self {
    Self(Builtin.mul_Vec4xInt64(a._storage._value, b._storage._value))
  }
        
  /// Updates the left hand side with the wrapping sum of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &+=(a: inout Self, b: Self) { a = a &+ b }
    
  /// Updates the left hand side with the wrapping difference of the two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &-=(a: inout Self, b: Self) { a = a &- b }
    
  /// Updates the left hand side with the pointwise wrapping product of two
  /// vectors.
  @_alwaysEmitIntoClient
  public static func &*=(a: inout Self, b: Self) { a = a &* b }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 300)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD2 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xFPIEEE16) {
    _storage = Float16.SIMD2Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_oeq_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_une_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_olt_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_ole_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_ogt_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt16(
      Builtin.fcmp_oge_Vec2xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD4 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE16) {
    _storage = Float16.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oeq_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_une_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_olt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ole_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ogt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oge_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD8 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xFPIEEE16) {
    _storage = Float16.SIMD8Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_oeq_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_une_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_olt_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_ole_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_ogt_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt16(
      Builtin.fcmp_oge_Vec8xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD16 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xFPIEEE16) {
    _storage = Float16.SIMD16Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_oeq_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_une_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_olt_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_ole_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_ogt_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt16(
      Builtin.fcmp_oge_Vec16xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD32 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xFPIEEE16) {
    _storage = Float16.SIMD32Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_oeq_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_une_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_olt_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_ole_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_ogt_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt16(
      Builtin.fcmp_oge_Vec32xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD64 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xFPIEEE16) {
    _storage = Float16.SIMD64Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_oeq_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_une_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_olt_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_ole_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_ogt_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt16(
      Builtin.fcmp_oge_Vec64xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 309)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD3 where Scalar == Float16 {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE16) {
    _storage = Float16.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oeq_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_une_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_olt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ole_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_ogt_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt16(
      Builtin.fcmp_oge_Vec4xFPIEEE16(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 367)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD2 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xFPIEEE32) {
    _storage = Float.SIMD2Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_oeq_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_une_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_olt_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_ole_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_ogt_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt32(
      Builtin.fcmp_oge_Vec2xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD4 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE32) {
    _storage = Float.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oeq_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_une_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_olt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ole_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ogt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oge_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD8 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xFPIEEE32) {
    _storage = Float.SIMD8Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_oeq_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_une_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_olt_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_ole_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_ogt_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt32(
      Builtin.fcmp_oge_Vec8xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD16 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xFPIEEE32) {
    _storage = Float.SIMD16Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_oeq_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_une_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_olt_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_ole_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_ogt_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt32(
      Builtin.fcmp_oge_Vec16xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD32 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xFPIEEE32) {
    _storage = Float.SIMD32Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_oeq_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_une_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_olt_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_ole_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_ogt_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt32(
      Builtin.fcmp_oge_Vec32xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD64 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xFPIEEE32) {
    _storage = Float.SIMD64Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_oeq_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_une_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_olt_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_ole_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_ogt_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt32(
      Builtin.fcmp_oge_Vec64xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD3 where Scalar == Float {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE32) {
    _storage = Float.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oeq_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_une_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_olt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ole_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_ogt_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt32(
      Builtin.fcmp_oge_Vec4xFPIEEE32(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD2 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec2xFPIEEE64) {
    _storage = Double.SIMD2Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_oeq_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_une_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_olt_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_ole_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_ogt_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec2xInt1_Vec2xInt64(
      Builtin.fcmp_oge_Vec2xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD4 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE64) {
    _storage = Double.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oeq_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_une_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_olt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ole_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ogt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oge_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD8 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec8xFPIEEE64) {
    _storage = Double.SIMD8Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_oeq_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_une_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_olt_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_ole_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_ogt_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec8xInt1_Vec8xInt64(
      Builtin.fcmp_oge_Vec8xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD16 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec16xFPIEEE64) {
    _storage = Double.SIMD16Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_oeq_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_une_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_olt_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_ole_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_ogt_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec16xInt1_Vec16xInt64(
      Builtin.fcmp_oge_Vec16xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD32 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec32xFPIEEE64) {
    _storage = Double.SIMD32Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_oeq_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_une_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_olt_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_ole_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_ogt_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec32xInt1_Vec32xInt64(
      Builtin.fcmp_oge_Vec32xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD64 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec64xFPIEEE64) {
    _storage = Double.SIMD64Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_oeq_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_une_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_olt_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_ole_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_ogt_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec64xInt1_Vec64xInt64(
      Builtin.fcmp_oge_Vec64xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 312)
extension SIMD3 where Scalar == Double {
  @_alwaysEmitIntoClient
  internal init(_ _builtin: Builtin.Vec4xFPIEEE64) {
    _storage = Double.SIMD4Storage(_builtin)
  }
  
  /// A vector mask with the result of a pointwise equality comparison.
  @_alwaysEmitIntoClient
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oeq_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise inequality comparison.
  @_alwaysEmitIntoClient
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_une_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than comparison.
  @_alwaysEmitIntoClient
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_olt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise less-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ole_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than comparison.
  @_alwaysEmitIntoClient
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_ogt_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
  
  /// A vector mask with the result of a pointwise greater-than-or-equal-to comparison.
  @_alwaysEmitIntoClient
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    SIMDMask<MaskStorage>(Builtin.sext_Vec4xInt1_Vec4xInt64(
      Builtin.fcmp_oge_Vec4xFPIEEE64(a._storage._value, b._storage._value)
    ))
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDConcreteOperations.swift.gyb", line: 369)

