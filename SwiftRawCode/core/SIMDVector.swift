infix operator .==: ComparisonPrecedence
infix operator .!=: ComparisonPrecedence
infix operator .<: ComparisonPrecedence
infix operator .<=: ComparisonPrecedence
infix operator .>: ComparisonPrecedence
infix operator .>=: ComparisonPrecedence
infix operator .&: LogicalConjunctionPrecedence
infix operator .^: LogicalDisjunctionPrecedence
infix operator .|: LogicalDisjunctionPrecedence
infix operator .&=: AssignmentPrecedence
infix operator .^=: AssignmentPrecedence
infix operator .|=: AssignmentPrecedence
prefix operator .!
public protocol SIMDStorage {
  associatedtype Scalar: Codable, Hashable
  var scalarCount: Int { get }
  init()
  subscript(index: Int) -> Scalar { get set }
}
extension SIMDStorage {
  public static var scalarCount: Int {
    return Self().scalarCount
  }
}
public protocol SIMDScalar {
  associatedtype SIMDMaskScalar: SIMDScalar & FixedWidthInteger & SignedInteger
    where SIMDMaskScalar.SIMDMaskScalar == SIMDMaskScalar
  associatedtype SIMD2Storage: SIMDStorage where SIMD2Storage.Scalar == Self
  associatedtype SIMD4Storage: SIMDStorage where SIMD4Storage.Scalar == Self
  associatedtype SIMD8Storage: SIMDStorage where SIMD8Storage.Scalar == Self
  associatedtype SIMD16Storage: SIMDStorage where SIMD16Storage.Scalar == Self
  associatedtype SIMD32Storage: SIMDStorage where SIMD32Storage.Scalar == Self
  associatedtype SIMD64Storage: SIMDStorage where SIMD64Storage.Scalar == Self
}
public protocol SIMD<Scalar>:
  SIMDStorage,
  Codable,
  Hashable,
  CustomStringConvertible,
  ExpressibleByArrayLiteral
{
  associatedtype MaskStorage: SIMD
    where MaskStorage.Scalar: FixedWidthInteger & SignedInteger
}
extension SIMD {
  public var indices: Range<Int> {
    return 0 ..< scalarCount
  }
  public init(repeating value: Scalar) {
    self.init()
    for i in indices { self[i] = value }
  }
  public static func ==(a: Self, b: Self) -> Bool {
    var result = true
    for i in a.indices { result = result && a[i] == b[i] }
    return result
  }
  @inlinable
  public func hash(into hasher: inout Hasher) {
    for i in indices { hasher.combine(self[i]) }
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    for i in indices {
      try container.encode(self[i])
    }
  }
  public init(from decoder: Decoder) throws {
    self.init()
    var container = try decoder.unkeyedContainer()
    guard container.count == scalarCount else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Expected vector with exactly \(scalarCount) elements."
        )
      )
    }
    for i in indices {
      self[i] = try container.decode(Scalar.self)
    }
  }
  public var description: String {
    get {
      return "\(Self.self)(" + indices.map({"\(self[$0])"}).joined(separator: ", ") + ")"
    }
  }
  public static func .==(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    var result = SIMDMask<MaskStorage>()
    for i in result.indices { result[i] = a[i] == b[i] }
    return result
  }
  public static func .!=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    var result = SIMDMask<MaskStorage>()
    for i in result.indices { result[i] = a[i] != b[i] }
    return result
  }
  public mutating func replace(with other: Self, where mask: SIMDMask<MaskStorage>) {
    for i in indices { self[i] = mask[i] ? other[i] : self[i] }
  }
  @inlinable
  public init(arrayLiteral scalars: Scalar...) {
    self.init(scalars)
  }
  @inlinable
  public init<S: Sequence>(_ scalars: S) where S.Element == Scalar {
    self.init()
    var index = 0
    for scalar in scalars {
      if index == scalarCount {
        _preconditionFailure("Too many elements in sequence.")
      }
      self[index] = scalar
      index += 1
    }
    if index < scalarCount {
      _preconditionFailure("Not enough elements in sequence.")
    }
  }
  public subscript<Index>(index: SIMD2<Index>) -> SIMD2<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD2<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD3<Index>) -> SIMD3<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD3<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD4<Index>) -> SIMD4<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD4<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD8<Index>) -> SIMD8<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD8<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD16<Index>) -> SIMD16<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD16<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD32<Index>) -> SIMD32<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD32<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
  public subscript<Index>(index: SIMD64<Index>) -> SIMD64<Scalar>
  where Index: FixedWidthInteger {
    var result = SIMD64<Scalar>()
    for i in result.indices {
      result[i] = self[Int(index[i]) % scalarCount]
    }
    return result
  }
}
extension SIMD where Scalar: Comparable {
  public static func .<(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    var result = SIMDMask<MaskStorage>()
    for i in result.indices { result[i] = a[i] < b[i] }
    return result
  }
  public static func .<=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    var result = SIMDMask<MaskStorage>()
    for i in result.indices { result[i] = a[i] <= b[i] }
    return result
  }
  public func min() -> Scalar {
    return indices.reduce(into: self[0]) { $0 = Swift.min($0, self[$1]) }
  }
  public func max() -> Scalar {
    return indices.reduce(into: self[0]) { $0 = Swift.max($0, self[$1]) }
  }
}
extension SIMD {
  public static func .==(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .== b
  }
  public static func .!=(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .!= b
  }
  public static func .==(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .== Self(repeating: b)
  }
  public static func .!=(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .!= Self(repeating: b)
  }
  public mutating func replace(with other: Scalar, where mask: SIMDMask<MaskStorage>) {
    replace(with: Self(repeating: other), where: mask)
  }
  public func replacing(with other: Self, where mask: SIMDMask<MaskStorage>) -> Self {
    var result = self
    result.replace(with: other, where: mask)
    return result
  }
  public func replacing(with other: Scalar, where mask: SIMDMask<MaskStorage>) -> Self {
    return replacing(with: Self(repeating: other), where: mask)
  }
}
extension SIMD where Scalar: Comparable {
  public static func .>=(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    return b .<= a
  }
  public static func .>(a: Self, b: Self) -> SIMDMask<MaskStorage> {
    return b .< a
  }
  public static func .<(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .< b
  }
  public static func .<=(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .<= b
  }
  public static func .>=(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .>= b
  }
  public static func .>(a: Scalar, b: Self) -> SIMDMask<MaskStorage> {
    return Self(repeating: a) .> b
  }
  public static func .<(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .< Self(repeating: b)
  }
  public static func .<=(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .<= Self(repeating: b)
  }
  public static func .>=(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .>= Self(repeating: b)
  }
  public static func .>(a: Self, b: Scalar) -> SIMDMask<MaskStorage> {
    return a .> Self(repeating: b)
  }
  public mutating func clamp(lowerBound: Self, upperBound: Self) {
    self = self.clamped(lowerBound: lowerBound, upperBound: upperBound)
  }
  public func clamped(lowerBound: Self, upperBound: Self) -> Self {
    return pointwiseMin(upperBound, pointwiseMax(lowerBound, self))
  }
}
extension SIMD where Scalar: FixedWidthInteger {
  public static var zero: Self {
    return Self()
  }
  public static var one: Self {
    return Self(repeating: 1)
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: Range<Scalar>,
    using generator: inout T
  ) -> Self {
    var result = Self()
    for i in result.indices {
      result[i] = Scalar.random(in: range, using: &generator)
    }
    return result
  }
  @inlinable
  public static func random(in range: Range<Scalar>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: ClosedRange<Scalar>,
    using generator: inout T
  ) -> Self {
    var result = Self()
    for i in result.indices {
      result[i] = Scalar.random(in: range, using: &generator)
    }
    return result
  }
  @inlinable
  public static func random(in range: ClosedRange<Scalar>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
}
extension SIMD where Scalar: FloatingPoint {
  public static var zero: Self {
    return Self()
  }
  public static var one: Self {
    return Self(repeating: 1)
  }
  public mutating func clamp(lowerBound: Self, upperBound: Self) {
    self = self.clamped(lowerBound: lowerBound, upperBound: upperBound)
  }
  public func clamped(lowerBound: Self, upperBound: Self) -> Self {
    return pointwiseMin(upperBound, pointwiseMax(lowerBound, self))
  }
}
extension SIMD
where Scalar: BinaryFloatingPoint, Scalar.RawSignificand: FixedWidthInteger {
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: Range<Scalar>,
    using generator: inout T
  ) -> Self {
    var result = Self()
    for i in result.indices {
      result[i] = Scalar.random(in: range, using: &generator)
    }
    return result
  }
  @inlinable
  public static func random(in range: Range<Scalar>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: ClosedRange<Scalar>,
    using generator: inout T
  ) -> Self {
    var result = Self()
    for i in result.indices {
      result[i] = Scalar.random(in: range, using: &generator)
    }
    return result
  }
  @inlinable
  public static func random(in range: ClosedRange<Scalar>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
}
@frozen
public struct SIMDMask<Storage>: SIMD
                  where Storage: SIMD,
                 Storage.Scalar: FixedWidthInteger & SignedInteger {
  public var _storage: Storage
  public typealias MaskStorage = Storage
  public typealias Scalar = Bool
  public init() {
    _storage = Storage()
  }
  public var scalarCount: Int {
    return _storage.scalarCount
  }
  public init(_ _storage: Storage) {
    self._storage = _storage
  }
  public subscript(index: Int) -> Bool {
    get {
      _precondition(indices.contains(index))
      return _storage[index] < 0
    }
    set {
      _precondition(indices.contains(index))
      _storage[index] = newValue ? -1 : 0
    }
  }
}
extension SIMDMask {
  @inlinable
  public static func random<T: RandomNumberGenerator>(using generator: inout T) -> SIMDMask {
    var result = SIMDMask()
    for i in result.indices { result[i] = Bool.random(using: &generator) }
    return result
  }
  @inlinable
  public static func random() -> SIMDMask {
    var g = SystemRandomNumberGenerator()
    return SIMDMask.random(using: &g)
  }
}
extension SIMD where Scalar: FixedWidthInteger {
  public var leadingZeroBitCount: Self {
    var result = Self()
    for i in indices { result[i] = Scalar(self[i].leadingZeroBitCount) }
    return result
  }
  public var trailingZeroBitCount: Self {
    var result = Self()
    for i in indices { result[i] = Scalar(self[i].trailingZeroBitCount) }
    return result
  }
  public var nonzeroBitCount: Self {
    var result = Self()
    for i in indices { result[i] = Scalar(self[i].nonzeroBitCount) }
    return result
  }
  public static prefix func ~(a: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = ~a[i] }
    return result
  }
  public static func &(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] & b[i] }
    return result
  }
  public static func ^(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] ^ b[i] }
    return result
  }
  public static func |(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] | b[i] }
    return result
  }
  public static func &<<(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] &<< b[i] }
    return result
  }
  public static func &>>(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] &>> b[i] }
    return result
  }
  public static func &+(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] &+ b[i] }
    return result
  }
  public static func &-(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] &- b[i] }
    return result
  }
  public static func &*(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] &* b[i] }
    return result
  }
  public static func /(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] / b[i] }
    return result
  }
  public static func %(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] % b[i] }
    return result
  }
  public func wrappedSum() -> Scalar {
    return indices.reduce(into: 0) { $0 &+= self[$1] }
  }
}
extension SIMD where Scalar: FloatingPoint {
  public static func +(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] + b[i] }
    return result
  }
  public static func -(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] - b[i] }
    return result
  }
  public static func *(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] * b[i] }
    return result
  }
  public static func /(a: Self, b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = a[i] / b[i] }
    return result
  }
  public func addingProduct(_ a: Self, _ b: Self) -> Self {
    var result = Self()
    for i in result.indices { result[i] = self[i].addingProduct(a[i], b[i]) }
    return result
  }
  public func squareRoot( ) -> Self {
    var result = Self()
    for i in result.indices { result[i] = self[i].squareRoot() }
    return result
  }
  public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
    var result = Self()
    for i in result.indices { result[i] = self[i].rounded(rule) }
    return result
  }
  public func min() -> Scalar {
    return indices.reduce(into: self[0]) { $0 = Scalar.minimum($0, self[$1]) }
  }
  public func max() -> Scalar {
    return indices.reduce(into: self[0]) { $0 = Scalar.maximum($0, self[$1]) }
  }
  public func sum() -> Scalar {
    return indices.reduce(into: 0) { $0 += self[$1] }
  }
}
extension SIMDMask {
  public static prefix func .!(a: SIMDMask) -> SIMDMask {
    return SIMDMask(~a._storage)
  }
  public static func .&(a: SIMDMask, b: SIMDMask) -> SIMDMask {
    return SIMDMask(a._storage & b._storage)
  }
  public static func .^(a: SIMDMask, b: SIMDMask) -> SIMDMask {
    return SIMDMask(a._storage ^ b._storage)
  }
  public static func .|(a: SIMDMask, b: SIMDMask) -> SIMDMask {
    return SIMDMask(a._storage | b._storage)
  }
}
extension SIMD where Scalar: FixedWidthInteger {
  public static func &(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) & b
  }
  public static func ^(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) ^ b
  }
  public static func |(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) | b
  }
  public static func &<<(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) &<< b
  }
  public static func &>>(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) &>> b
  }
  public static func &+(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) &+ b
  }
  public static func &-(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) &- b
  }
  public static func &*(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) &* b
  }
  public static func /(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) / b
  }
  public static func %(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) % b
  }
  public static func &(a: Self, b: Scalar) -> Self {
    return a & Self(repeating: b)
  }
  public static func ^(a: Self, b: Scalar) -> Self {
    return a ^ Self(repeating: b)
  }
  public static func |(a: Self, b: Scalar) -> Self {
    return a | Self(repeating: b)
  }
  public static func &<<(a: Self, b: Scalar) -> Self {
    return a &<< Self(repeating: b)
  }
  public static func &>>(a: Self, b: Scalar) -> Self {
    return a &>> Self(repeating: b)
  }
  public static func &+(a: Self, b: Scalar) -> Self {
    return a &+ Self(repeating: b)
  }
  public static func &-(a: Self, b: Scalar) -> Self {
    return a &- Self(repeating: b)
  }
  public static func &*(a: Self, b: Scalar) -> Self {
    return a &* Self(repeating: b)
  }
  public static func /(a: Self, b: Scalar) -> Self {
    return a / Self(repeating: b)
  }
  public static func %(a: Self, b: Scalar) -> Self {
    return a % Self(repeating: b)
  }
  public static func &=(a: inout Self, b: Self) {
    a = a & b
  }
  public static func ^=(a: inout Self, b: Self) {
    a = a ^ b
  }
  public static func |=(a: inout Self, b: Self) {
    a = a | b
  }
  public static func &<<=(a: inout Self, b: Self) {
    a = a &<< b
  }
  public static func &>>=(a: inout Self, b: Self) {
    a = a &>> b
  }
  public static func &+=(a: inout Self, b: Self) {
    a = a &+ b
  }
  public static func &-=(a: inout Self, b: Self) {
    a = a &- b
  }
  public static func &*=(a: inout Self, b: Self) {
    a = a &* b
  }
  public static func /=(a: inout Self, b: Self) {
    a = a / b
  }
  public static func %=(a: inout Self, b: Self) {
    a = a % b
  }
  public static func &=(a: inout Self, b: Scalar) {
    a = a & b
  }
  public static func ^=(a: inout Self, b: Scalar) {
    a = a ^ b
  }
  public static func |=(a: inout Self, b: Scalar) {
    a = a | b
  }
  public static func &<<=(a: inout Self, b: Scalar) {
    a = a &<< b
  }
  public static func &>>=(a: inout Self, b: Scalar) {
    a = a &>> b
  }
  public static func &+=(a: inout Self, b: Scalar) {
    a = a &+ b
  }
  public static func &-=(a: inout Self, b: Scalar) {
    a = a &- b
  }
  public static func &*=(a: inout Self, b: Scalar) {
    a = a &* b
  }
  public static func /=(a: inout Self, b: Scalar) {
    a = a / b
  }
  public static func %=(a: inout Self, b: Scalar) {
    a = a % b
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&+' instead")
  public static func +(a: Self, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&-' instead")
  public static func -(a: Self, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&*' instead")
  public static func *(a: Self, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&+' instead")
  public static func +(a: Self, b: Scalar) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&-' instead")
  public static func -(a: Self, b: Scalar) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&*' instead")
  public static func *(a: Self, b: Scalar) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&+' instead")
  public static func +(a: Scalar, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&-' instead")
  public static func -(a: Scalar, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&*' instead")
  public static func *(a: Scalar, b: Self) -> Self {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&+=' instead")
  public static func +=(a: inout Self, b: Self) {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&-=' instead")
  public static func -=(a: inout Self, b: Self) {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&*=' instead")
  public static func *=(a: inout Self, b: Self) {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&+=' instead")
  public static func +=(a: inout Self, b: Scalar) {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&-=' instead")
  public static func -=(a: inout Self, b: Scalar) {
    fatalError()
  }
  @available(*, unavailable, message: "integer vector types do not support checked arithmetic; use the wrapping operator '&*=' instead")
  public static func *=(a: inout Self, b: Scalar) {
    fatalError()
  }
}
extension SIMD where Scalar: FloatingPoint {
  public static prefix func -(a: Self) -> Self {
    return 0 - a
  }
  public static func +(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) + b
  }
  public static func -(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) - b
  }
  public static func *(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) * b
  }
  public static func /(a: Scalar, b: Self) -> Self {
    return Self(repeating: a) / b
  }
  public static func +(a: Self, b: Scalar) -> Self {
    return a + Self(repeating: b)
  }
  public static func -(a: Self, b: Scalar) -> Self {
    return a - Self(repeating: b)
  }
  public static func *(a: Self, b: Scalar) -> Self {
    return a * Self(repeating: b)
  }
  public static func /(a: Self, b: Scalar) -> Self {
    return a / Self(repeating: b)
  }
  public static func +=(a: inout Self, b: Self) {
    a = a + b
  }
  public static func -=(a: inout Self, b: Self) {
    a = a - b
  }
  public static func *=(a: inout Self, b: Self) {
    a = a * b
  }
  public static func /=(a: inout Self, b: Self) {
    a = a / b
  }
  public static func +=(a: inout Self, b: Scalar) {
    a = a + b
  }
  public static func -=(a: inout Self, b: Scalar) {
    a = a - b
  }
  public static func *=(a: inout Self, b: Scalar) {
    a = a * b
  }
  public static func /=(a: inout Self, b: Scalar) {
    a = a / b
  }
  public func addingProduct(_ a: Scalar, _ b: Self) -> Self {
    return self.addingProduct(Self(repeating: a), b)
  }
  public func addingProduct(_ a: Self, _ b: Scalar) -> Self {
    return self.addingProduct(a, Self(repeating: b))
  }
  public mutating func addProduct(_ a: Self, _ b: Self) {
    self = self.addingProduct(a, b)
  }
  public mutating func addProduct(_ a: Scalar, _ b: Self) {
    self = self.addingProduct(a, b)
  }
  public mutating func addProduct(_ a: Self, _ b: Scalar) {
    self = self.addingProduct(a, b)
  }
  public mutating func formSquareRoot( ) {
    self = self.squareRoot()
  }
  public mutating func round(_ rule: FloatingPointRoundingRule) {
    self = self.rounded(rule)
  }
}
extension SIMDMask {
  public static func .&(a: Bool, b: SIMDMask) -> SIMDMask {
    return SIMDMask(repeating: a) .& b
  }
  public static func .^(a: Bool, b: SIMDMask) -> SIMDMask {
    return SIMDMask(repeating: a) .^ b
  }
  public static func .|(a: Bool, b: SIMDMask) -> SIMDMask {
    return SIMDMask(repeating: a) .| b
  }
  public static func .&(a: SIMDMask, b: Bool) -> SIMDMask {
    return a .& SIMDMask(repeating: b)
  }
  public static func .^(a: SIMDMask, b: Bool) -> SIMDMask {
    return a .^ SIMDMask(repeating: b)
  }
  public static func .|(a: SIMDMask, b: Bool) -> SIMDMask {
    return a .| SIMDMask(repeating: b)
  }
  public static func .&=(a: inout SIMDMask, b: SIMDMask) {
    a = a .& b
  }
  public static func .^=(a: inout SIMDMask, b: SIMDMask) {
    a = a .^ b
  }
  public static func .|=(a: inout SIMDMask, b: SIMDMask) {
    a = a .| b
  }
  public static func .&=(a: inout SIMDMask, b: Bool) {
    a = a .& b
  }
  public static func .^=(a: inout SIMDMask, b: Bool) {
    a = a .^ b
  }
  public static func .|=(a: inout SIMDMask, b: Bool) {
    a = a .| b
  }
}
public func any<Storage>(_ mask: SIMDMask<Storage>) -> Bool {
  return mask._storage.min() < 0
}
public func all<Storage>(_ mask: SIMDMask<Storage>) -> Bool {
  return mask._storage.max() < 0
}
public func pointwiseMin<T>(_ a: T, _ b: T) -> T
where T: SIMD, T.Scalar: Comparable {
  var result = T()
  for i in result.indices {
    result[i] = min(a[i], b[i])
  }
  return result
}
public func pointwiseMax<T>(_ a: T, _ b: T) -> T
where T: SIMD, T.Scalar: Comparable {
  var result = T()
  for i in result.indices {
    result[i] = max(a[i], b[i])
  }
  return result
}
public func pointwiseMin<T>(_ a: T, _ b: T) -> T
where T: SIMD, T.Scalar: FloatingPoint {
  var result = T()
  for i in result.indices {
    result[i] = T.Scalar.minimum(a[i], b[i])
  }
  return result
}
public func pointwiseMax<T>(_ a: T, _ b: T) -> T
where T: SIMD, T.Scalar: FloatingPoint {
  var result = T()
  for i in result.indices {
    result[i] = T.Scalar.maximum(a[i], b[i])
  }
  return result
}
extension SIMD where Self: AdditiveArithmetic, Self.Scalar: FloatingPoint {
  public static func +=(a: inout Self, b: Self) {
    a = a + b
  }
  public static func -=(a: inout Self, b: Self) {
    a = a - b
  }
}
