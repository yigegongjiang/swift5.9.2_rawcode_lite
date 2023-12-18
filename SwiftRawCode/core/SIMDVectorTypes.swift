// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 1)
//===--- SIMDVectorTypes.swift.gyb ----------------------------*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2018 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 24)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of two scalar values.
@frozen
public struct SIMD2<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD2Storage

  public typealias MaskStorage = SIMD2<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 2
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD2Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 69)
  /// Creates a new vector from the given elements.
  ///
  /// - Parameters:
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - x: The first element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - y: The second element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 75)
  @_transparent
  public init(x: Scalar, y: Scalar) {
    self.init(x, y)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The first element of the vector.
  @_transparent
  public var x: Scalar {
    @_transparent get { return self[0]}
    @_transparent set { self[0] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The second element of the vector.
  @_transparent
  public var y: Scalar {
    @_transparent get { return self[1]}
    @_transparent set { self[1] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD2 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD2<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD2<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD2<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD2: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD2<\(Scalar.self)>(\(self[0]), \(self[1]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD2 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD2<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD2<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD2: Sendable
  where Scalar: Sendable,
        Scalar.SIMD2Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of four scalar values.
@frozen
public struct SIMD4<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD4Storage

  public typealias MaskStorage = SIMD4<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 4
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD4Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[3] = v3
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 69)
  /// Creates a new vector from the given elements.
  ///
  /// - Parameters:
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - x: The first element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - y: The second element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - z: The third element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - w: The fourth element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 75)
  @_transparent
  public init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) {
    self.init(x, y, z, w)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The first element of the vector.
  @_transparent
  public var x: Scalar {
    @_transparent get { return self[0]}
    @_transparent set { self[0] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The second element of the vector.
  @_transparent
  public var y: Scalar {
    @_transparent get { return self[1]}
    @_transparent set { self[1] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The third element of the vector.
  @_transparent
  public var z: Scalar {
    @_transparent get { return self[2]}
    @_transparent set { self[2] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The fourth element of the vector.
  @_transparent
  public var w: Scalar {
    @_transparent get { return self[3]}
    @_transparent set { self[3] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 91)
  /// Creates a new vector from two half-length vectors.
  @_transparent
  public init(lowHalf: SIMD2<Scalar>, highHalf: SIMD2<Scalar>) {
    self.init()
    self.lowHalf = lowHalf
    self.highHalf = highHalf
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the low elements of the vector.
  public var lowHalf: SIMD2<Scalar> {
    @inlinable get {
      var result = SIMD2<Scalar>()
      for i in result.indices { result[i] = self[i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the high elements of the vector.
  public var highHalf: SIMD2<Scalar> {
    @inlinable get {
      var result = SIMD2<Scalar>()
      for i in result.indices { result[i] = self[2+i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2+i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the even elements of the vector.
  public var evenHalf: SIMD2<Scalar> {
    @inlinable get {
      var result = SIMD2<Scalar>()
      for i in result.indices { result[i] = self[2*i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the odd elements of the vector.
  public var oddHalf: SIMD2<Scalar> {
    @inlinable get {
      var result = SIMD2<Scalar>()
      for i in result.indices { result[i] = self[2*i+1] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i+1] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD4 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD4<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD4<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD4<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD4: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD4<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]), \(self[3]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD4 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD4<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD4<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD4: Sendable
  where Scalar: Sendable,
        Scalar.SIMD4Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of eight scalar values.
@frozen
public struct SIMD8<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD8Storage

  public typealias MaskStorage = SIMD8<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 8
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD8Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar, _ v6: Scalar, _ v7: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[3] = v3
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[4] = v4
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[5] = v5
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[6] = v6
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[7] = v7
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 91)
  /// Creates a new vector from two half-length vectors.
  @_transparent
  public init(lowHalf: SIMD4<Scalar>, highHalf: SIMD4<Scalar>) {
    self.init()
    self.lowHalf = lowHalf
    self.highHalf = highHalf
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the low elements of the vector.
  public var lowHalf: SIMD4<Scalar> {
    @inlinable get {
      var result = SIMD4<Scalar>()
      for i in result.indices { result[i] = self[i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the high elements of the vector.
  public var highHalf: SIMD4<Scalar> {
    @inlinable get {
      var result = SIMD4<Scalar>()
      for i in result.indices { result[i] = self[4+i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[4+i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the even elements of the vector.
  public var evenHalf: SIMD4<Scalar> {
    @inlinable get {
      var result = SIMD4<Scalar>()
      for i in result.indices { result[i] = self[2*i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the odd elements of the vector.
  public var oddHalf: SIMD4<Scalar> {
    @inlinable get {
      var result = SIMD4<Scalar>()
      for i in result.indices { result[i] = self[2*i+1] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i+1] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD8 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD8<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD8<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD8<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD8: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD8<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]), \(self[3]), \(self[4]), \(self[5]), \(self[6]), \(self[7]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD8 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD8<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD8<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD8: Sendable
  where Scalar: Sendable,
        Scalar.SIMD8Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of 16 scalar values.
@frozen
public struct SIMD16<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD16Storage

  public typealias MaskStorage = SIMD16<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 16
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD16Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar, _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar, _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[3] = v3
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[4] = v4
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[5] = v5
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[6] = v6
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[7] = v7
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[8] = v8
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[9] = v9
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[10] = v10
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[11] = v11
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[12] = v12
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[13] = v13
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[14] = v14
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[15] = v15
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 91)
  /// Creates a new vector from two half-length vectors.
  @_transparent
  public init(lowHalf: SIMD8<Scalar>, highHalf: SIMD8<Scalar>) {
    self.init()
    self.lowHalf = lowHalf
    self.highHalf = highHalf
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the low elements of the vector.
  public var lowHalf: SIMD8<Scalar> {
    @inlinable get {
      var result = SIMD8<Scalar>()
      for i in result.indices { result[i] = self[i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the high elements of the vector.
  public var highHalf: SIMD8<Scalar> {
    @inlinable get {
      var result = SIMD8<Scalar>()
      for i in result.indices { result[i] = self[8+i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[8+i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the even elements of the vector.
  public var evenHalf: SIMD8<Scalar> {
    @inlinable get {
      var result = SIMD8<Scalar>()
      for i in result.indices { result[i] = self[2*i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the odd elements of the vector.
  public var oddHalf: SIMD8<Scalar> {
    @inlinable get {
      var result = SIMD8<Scalar>()
      for i in result.indices { result[i] = self[2*i+1] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i+1] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD16 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD16<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD16<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD16<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD16: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD16<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]), \(self[3]), \(self[4]), \(self[5]), \(self[6]), \(self[7]), \(self[8]), \(self[9]), \(self[10]), \(self[11]), \(self[12]), \(self[13]), \(self[14]), \(self[15]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD16 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD16<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD16<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD16: Sendable
  where Scalar: Sendable,
        Scalar.SIMD16Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of 32 scalar values.
@frozen
public struct SIMD32<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD32Storage

  public typealias MaskStorage = SIMD32<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 32
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD32Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar, _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar, _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar, _ v16: Scalar, _ v17: Scalar, _ v18: Scalar, _ v19: Scalar, _ v20: Scalar, _ v21: Scalar, _ v22: Scalar, _ v23: Scalar, _ v24: Scalar, _ v25: Scalar, _ v26: Scalar, _ v27: Scalar, _ v28: Scalar, _ v29: Scalar, _ v30: Scalar, _ v31: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[3] = v3
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[4] = v4
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[5] = v5
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[6] = v6
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[7] = v7
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[8] = v8
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[9] = v9
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[10] = v10
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[11] = v11
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[12] = v12
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[13] = v13
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[14] = v14
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[15] = v15
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[16] = v16
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[17] = v17
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[18] = v18
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[19] = v19
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[20] = v20
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[21] = v21
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[22] = v22
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[23] = v23
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[24] = v24
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[25] = v25
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[26] = v26
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[27] = v27
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[28] = v28
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[29] = v29
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[30] = v30
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[31] = v31
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 91)
  /// Creates a new vector from two half-length vectors.
  @_transparent
  public init(lowHalf: SIMD16<Scalar>, highHalf: SIMD16<Scalar>) {
    self.init()
    self.lowHalf = lowHalf
    self.highHalf = highHalf
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the low elements of the vector.
  public var lowHalf: SIMD16<Scalar> {
    @inlinable get {
      var result = SIMD16<Scalar>()
      for i in result.indices { result[i] = self[i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the high elements of the vector.
  public var highHalf: SIMD16<Scalar> {
    @inlinable get {
      var result = SIMD16<Scalar>()
      for i in result.indices { result[i] = self[16+i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[16+i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the even elements of the vector.
  public var evenHalf: SIMD16<Scalar> {
    @inlinable get {
      var result = SIMD16<Scalar>()
      for i in result.indices { result[i] = self[2*i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the odd elements of the vector.
  public var oddHalf: SIMD16<Scalar> {
    @inlinable get {
      var result = SIMD16<Scalar>()
      for i in result.indices { result[i] = self[2*i+1] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i+1] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD32 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD32<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD32<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD32<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD32: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD32<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]), \(self[3]), \(self[4]), \(self[5]), \(self[6]), \(self[7]), \(self[8]), \(self[9]), \(self[10]), \(self[11]), \(self[12]), \(self[13]), \(self[14]), \(self[15]), \(self[16]), \(self[17]), \(self[18]), \(self[19]), \(self[20]), \(self[21]), \(self[22]), \(self[23]), \(self[24]), \(self[25]), \(self[26]), \(self[27]), \(self[28]), \(self[29]), \(self[30]), \(self[31]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD32 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD32<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD32<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD32: Sendable
  where Scalar: Sendable,
        Scalar.SIMD32Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of 64 scalar values.
@frozen
public struct SIMD64<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD64Storage

  public typealias MaskStorage = SIMD64<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 64
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD64Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar, _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar, _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar, _ v16: Scalar, _ v17: Scalar, _ v18: Scalar, _ v19: Scalar, _ v20: Scalar, _ v21: Scalar, _ v22: Scalar, _ v23: Scalar, _ v24: Scalar, _ v25: Scalar, _ v26: Scalar, _ v27: Scalar, _ v28: Scalar, _ v29: Scalar, _ v30: Scalar, _ v31: Scalar, _ v32: Scalar, _ v33: Scalar, _ v34: Scalar, _ v35: Scalar, _ v36: Scalar, _ v37: Scalar, _ v38: Scalar, _ v39: Scalar, _ v40: Scalar, _ v41: Scalar, _ v42: Scalar, _ v43: Scalar, _ v44: Scalar, _ v45: Scalar, _ v46: Scalar, _ v47: Scalar, _ v48: Scalar, _ v49: Scalar, _ v50: Scalar, _ v51: Scalar, _ v52: Scalar, _ v53: Scalar, _ v54: Scalar, _ v55: Scalar, _ v56: Scalar, _ v57: Scalar, _ v58: Scalar, _ v59: Scalar, _ v60: Scalar, _ v61: Scalar, _ v62: Scalar, _ v63: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[3] = v3
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[4] = v4
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[5] = v5
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[6] = v6
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[7] = v7
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[8] = v8
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[9] = v9
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[10] = v10
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[11] = v11
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[12] = v12
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[13] = v13
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[14] = v14
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[15] = v15
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[16] = v16
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[17] = v17
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[18] = v18
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[19] = v19
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[20] = v20
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[21] = v21
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[22] = v22
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[23] = v23
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[24] = v24
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[25] = v25
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[26] = v26
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[27] = v27
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[28] = v28
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[29] = v29
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[30] = v30
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[31] = v31
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[32] = v32
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[33] = v33
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[34] = v34
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[35] = v35
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[36] = v36
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[37] = v37
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[38] = v38
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[39] = v39
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[40] = v40
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[41] = v41
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[42] = v42
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[43] = v43
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[44] = v44
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[45] = v45
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[46] = v46
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[47] = v47
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[48] = v48
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[49] = v49
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[50] = v50
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[51] = v51
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[52] = v52
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[53] = v53
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[54] = v54
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[55] = v55
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[56] = v56
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[57] = v57
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[58] = v58
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[59] = v59
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[60] = v60
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[61] = v61
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[62] = v62
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[63] = v63
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 91)
  /// Creates a new vector from two half-length vectors.
  @_transparent
  public init(lowHalf: SIMD32<Scalar>, highHalf: SIMD32<Scalar>) {
    self.init()
    self.lowHalf = lowHalf
    self.highHalf = highHalf
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the low elements of the vector.
  public var lowHalf: SIMD32<Scalar> {
    @inlinable get {
      var result = SIMD32<Scalar>()
      for i in result.indices { result[i] = self[i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the high elements of the vector.
  public var highHalf: SIMD32<Scalar> {
    @inlinable get {
      var result = SIMD32<Scalar>()
      for i in result.indices { result[i] = self[32+i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[32+i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the even elements of the vector.
  public var evenHalf: SIMD32<Scalar> {
    @inlinable get {
      var result = SIMD32<Scalar>()
      for i in result.indices { result[i] = self[2*i] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 100)
  /// A half-length vector made up of the odd elements of the vector.
  public var oddHalf: SIMD32<Scalar> {
    @inlinable get {
      var result = SIMD32<Scalar>()
      for i in result.indices { result[i] = self[2*i+1] }
      return result
    }
    @inlinable set {
      for i in newValue.indices { self[2*i+1] = newValue[i] }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD64 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD64<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD64<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD64<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD64: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD64<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]), \(self[3]), \(self[4]), \(self[5]), \(self[6]), \(self[7]), \(self[8]), \(self[9]), \(self[10]), \(self[11]), \(self[12]), \(self[13]), \(self[14]), \(self[15]), \(self[16]), \(self[17]), \(self[18]), \(self[19]), \(self[20]), \(self[21]), \(self[22]), \(self[23]), \(self[24]), \(self[25]), \(self[26]), \(self[27]), \(self[28]), \(self[29]), \(self[30]), \(self[31]), \(self[32]), \(self[33]), \(self[34]), \(self[35]), \(self[36]), \(self[37]), \(self[38]), \(self[39]), \(self[40]), \(self[41]), \(self[42]), \(self[43]), \(self[44]), \(self[45]), \(self[46]), \(self[47]), \(self[48]), \(self[49]), \(self[50]), \(self[51]), \(self[52]), \(self[53]), \(self[54]), \(self[55]), \(self[56]), \(self[57]), \(self[58]), \(self[59]), \(self[60]), \(self[61]), \(self[62]), \(self[63]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD64 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD64<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD64<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD64: Sendable
  where Scalar: Sendable,
        Scalar.SIMD64Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 27)
/// A vector of three scalar values.
@frozen
public struct SIMD3<Scalar>: SIMD where Scalar: SIMDScalar {

  public var _storage: Scalar.SIMD4Storage

  public typealias MaskStorage = SIMD3<Scalar.SIMDMaskScalar>

  /// The number of scalars in the vector.
  @_transparent
  public var scalarCount: Int {
    return 3
  }

  /// Creates a vector with zero in all lanes.
  @_transparent
  public init() {
    _storage = Scalar.SIMD4Storage()
  }

  /// Accesses the scalar at the specified position.
  public subscript(index: Int) -> Scalar {
    @_transparent get {
      _precondition(indices.contains(index))
      return _storage[index]
    }
    @_transparent set {
      _precondition(indices.contains(index))
      _storage[index] = newValue
    }
  }

  /// Creates a new vector from the given elements.
  @_transparent
  public init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar) {
    self.init()
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[0] = v0
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[1] = v1
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 64)
    self[2] = v2
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 66)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 69)
  /// Creates a new vector from the given elements.
  ///
  /// - Parameters:
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - x: The first element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - y: The second element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 73)
  ///   - z: The third element of the vector.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 75)
  @_transparent
  public init(x: Scalar, y: Scalar, z: Scalar) {
    self.init(x, y, z)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The first element of the vector.
  @_transparent
  public var x: Scalar {
    @_transparent get { return self[0]}
    @_transparent set { self[0] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The second element of the vector.
  @_transparent
  public var y: Scalar {
    @_transparent get { return self[1]}
    @_transparent set { self[1] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 81)
  /// The third element of the vector.
  @_transparent
  public var z: Scalar {
    @_transparent get { return self[2]}
    @_transparent set { self[2] = newValue }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 114)
}

extension SIMD3 where Scalar: FixedWidthInteger {
  /// Creates a new vector from the given vector, truncating the bit patterns
  /// of the given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(truncatingIfNeeded other: SIMD3<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(truncatingIfNeeded: other[i]) }
  }

  /// Creates a new vector from the given vector, clamping the values of the
  /// given vector's elements if necessary.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(clamping other: SIMD3<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(clamping: other[i]) }
  }

  /// Creates a new vector from the given vector, rounding the given vector's
  /// of elements using the specified rounding rule.
  ///
  /// - Parameters:
  ///   - other: The vector to convert.
  ///   - rule: The round rule to use when converting elements of `other.` The
  ///     default is `.towardZero`.
  @inlinable
  public init<Other>(
    _ other: SIMD3<Other>,
    rounding rule: FloatingPointRoundingRule = .towardZero
  )
  where Other: BinaryFloatingPoint {
    self.init()
    // TODO: this should clamp
    for i in indices { self[i] = Scalar(other[i].rounded(rule)) }
  }
}

extension SIMD3: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "SIMD3<\(Scalar.self)>(\(self[0]), \(self[1]), \(self[2]))"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 163)
  }
}

extension SIMD3 where Scalar: BinaryFloatingPoint {
  /// Creates a new vector from the given vector of integers.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD3<Other>)
  where Other: FixedWidthInteger {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }

  /// Creates a new vector from the given vector of floating-point values.
  ///
  /// - Parameter other: The vector to convert.
  @inlinable
  public init<Other>(_ other: SIMD3<Other>)
  where Other: BinaryFloatingPoint {
    self.init()
    for i in indices { self[i] = Scalar(other[i]) }
  }
}

extension SIMD3: Sendable
  where Scalar: Sendable,
        Scalar.SIMD4Storage: Sendable { }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 193)

extension SIMD3 {
  /// A three-element vector created by appending a scalar to a two-element vector.
  @_alwaysEmitIntoClient
  public init(_ xy: SIMD2<Scalar>, _ z: Scalar) {
    self.init(xy.x, xy.y, z)
  }
}

extension SIMD4 {
  /// A four-element vector created by appending a scalar to a three-element vector.
  @_alwaysEmitIntoClient
  public init(_ xyz: SIMD3<Scalar>, _ w: Scalar) {
    self.init(xyz.x, xyz.y, xyz.z, w)
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension UInt8: SIMDScalar {

  public typealias SIMDMaskScalar = Int8

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(2)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt8

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec2xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(4)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt8

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec4xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(8)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt8

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec8xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt8

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec16xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt8

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec32xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt8

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt8 {
      @_transparent
      get {
        return UInt8(Builtin.extractelement_Vec64xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension Int8: SIMDScalar {

  public typealias SIMDMaskScalar = Int8

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(2)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt8

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec2xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(4)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt8

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec4xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(8)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt8

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec8xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt8

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec16xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt8

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec32xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt8

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt8) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int8 {
      @_transparent
      get {
        return Int8(Builtin.extractelement_Vec64xInt8_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt8_Int8_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension UInt16: SIMDScalar {

  public typealias SIMDMaskScalar = Int16

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(4)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt16

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec2xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(8)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt16

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec4xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt16

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec8xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt16

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec16xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt16

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec32xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt16

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt16 {
      @_transparent
      get {
        return UInt16(Builtin.extractelement_Vec64xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension Int16: SIMDScalar {

  public typealias SIMDMaskScalar = Int16

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(4)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt16

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec2xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(8)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt16

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec4xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt16

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec8xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt16

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec16xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt16

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec32xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt16

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int16 {
      @_transparent
      get {
        return Int16(Builtin.extractelement_Vec64xInt16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt16_Int16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension UInt32: SIMDScalar {

  public typealias SIMDMaskScalar = Int32

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(8)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt32

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec2xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt32

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec4xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt32

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec8xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt32

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec16xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt32

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec32xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt32

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt32 {
      @_transparent
      get {
        return UInt32(Builtin.extractelement_Vec64xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension Int32: SIMDScalar {

  public typealias SIMDMaskScalar = Int32

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(8)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt32

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec2xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt32

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec4xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt32

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec8xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt32

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec16xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt32

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec32xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt32

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int32 {
      @_transparent
      get {
        return Int32(Builtin.extractelement_Vec64xInt32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt32_Int32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension UInt64: SIMDScalar {

  public typealias SIMDMaskScalar = Int64

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(16)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt64

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec2xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt64

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec4xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt64

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec8xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt64

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec16xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt64

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec32xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt64

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt64 {
      @_transparent
      get {
        return UInt64(Builtin.extractelement_Vec64xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension Int64: SIMDScalar {

  public typealias SIMDMaskScalar = Int64

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(16)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt64

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec2xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt64

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec4xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt64

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec8xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt64

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec16xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt64

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec32xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt64

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int64 {
      @_transparent
      get {
        return Int64(Builtin.extractelement_Vec64xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension UInt: SIMDScalar {

  public typealias SIMDMaskScalar = Int

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(16)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt64

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec2xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt64

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec4xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt64

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec8xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt64

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec16xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt64

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec32xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt64

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> UInt {
      @_transparent
      get {
        return UInt(Builtin.extractelement_Vec64xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 214)
extension Int: SIMDScalar {

  public typealias SIMDMaskScalar = Int

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of two integers.
  @frozen
  @_alignment(16)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xInt64

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec2xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of four integers.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xInt64

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec4xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of eight integers.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xInt64

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec8xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 16 integers.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xInt64

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec16xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 32 integers.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xInt64

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec32xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 220)
  /// Storage for a vector of 64 integers.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xInt64

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xInt64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Int {
      @_transparent
      get {
        return Int(Builtin.extractelement_Vec64xInt64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xInt64_Int64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 259)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 262)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 265)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 268)
extension Float16 : SIMDScalar {

  public typealias SIMDMaskScalar = Int16

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of two floating-point values.
  @frozen
  @_alignment(4)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec2xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of four floating-point values.
  @frozen
  @_alignment(8)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec4xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of eight floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec8xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 16 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec16xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 32 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec32xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 64 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xFPIEEE16

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xFPIEEE16) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float16 {
      @_transparent
      get {
        return Float16(Builtin.extractelement_Vec64xFPIEEE16_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xFPIEEE16_FPIEEE16_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 313)
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 315)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 317)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 268)
extension Float : SIMDScalar {

  public typealias SIMDMaskScalar = Int32

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of two floating-point values.
  @frozen
  @_alignment(8)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec2xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of four floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec4xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of eight floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec8xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 16 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec16xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 32 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec32xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 64 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xFPIEEE32

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xFPIEEE32) {
      _value = _builtin
    }

    public subscript(index: Int) -> Float {
      @_transparent
      get {
        return Float(Builtin.extractelement_Vec64xFPIEEE32_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xFPIEEE32_FPIEEE32_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 313)
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 317)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 268)
extension Double : SIMDScalar {

  public typealias SIMDMaskScalar = Int64

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of two floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD2Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec2xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 2
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec2xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec2xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec2xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of four floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD4Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec4xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 4
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec4xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec4xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec4xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of eight floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD8Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec8xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 8
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec8xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec8xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec8xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 16 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD16Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec16xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 16
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec16xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec16xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec16xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 32 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD32Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec32xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 32
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec32xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec32xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec32xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 274)
  /// Storage for a vector of 64 floating-point values.
  @frozen
  @_alignment(16)
  public struct SIMD64Storage: SIMDStorage, Sendable {

    public var _value: Builtin.Vec64xFPIEEE64

    @_transparent
    public var scalarCount: Int {
      return 64
    }

    @_transparent
    public init() {
      _value = Builtin.zeroInitializer()
    }
    
    @_alwaysEmitIntoClient
    internal init(_ _builtin: Builtin.Vec64xFPIEEE64) {
      _value = _builtin
    }

    public subscript(index: Int) -> Double {
      @_transparent
      get {
        return Double(Builtin.extractelement_Vec64xFPIEEE64_Int32(
          _value, Int32(truncatingIfNeeded: index)._value
        ))
      }
      @_transparent
      set {
        _value = Builtin.insertelement_Vec64xFPIEEE64_FPIEEE64_Int32(
          _value, newValue._value, Int32(truncatingIfNeeded: index)._value
        )
      }
    }
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 313)
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/SIMDVectorTypes.swift.gyb", line: 317)

