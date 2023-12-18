public protocol RawRepresentable<RawValue> {
  associatedtype RawValue
  init?(rawValue: RawValue)
  var rawValue: RawValue { get }
}
@inlinable 
public func == <T: RawRepresentable>(lhs: T, rhs: T) -> Bool
  where T.RawValue: Equatable {
  return lhs.rawValue == rhs.rawValue
}
@inlinable 
public func != <T: RawRepresentable>(lhs: T, rhs: T) -> Bool
  where T.RawValue: Equatable {
  return lhs.rawValue != rhs.rawValue
}
@inlinable 
public func != <T: Equatable>(lhs: T, rhs: T) -> Bool
  where T: RawRepresentable, T.RawValue: Equatable {
  return lhs.rawValue != rhs.rawValue
}
extension RawRepresentable where RawValue: Hashable, Self: Hashable {
  @inlinable 
  public var hashValue: Int {
    _hashValue(for: self)
  }
  @inlinable 
  public func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue)
  }
  @inlinable 
  public func _rawHashValue(seed: Int) -> Int {
    var hasher = Hasher(_seed: seed)
    self.hash(into: &hasher)
    return hasher._finalize()
  }
}
public protocol CaseIterable {
  associatedtype AllCases: Collection = [Self]
    where AllCases.Element == Self
  static var allCases: AllCases { get }
}
public protocol ExpressibleByNilLiteral {
  init(nilLiteral: ())
}
public protocol _ExpressibleByBuiltinIntegerLiteral {
  init(_builtinIntegerLiteral value: Builtin.IntLiteral)
}
public protocol ExpressibleByIntegerLiteral {
  associatedtype IntegerLiteralType: _ExpressibleByBuiltinIntegerLiteral
  init(integerLiteral value: IntegerLiteralType)
}
public protocol _ExpressibleByBuiltinFloatLiteral {
  init(_builtinFloatLiteral value: _MaxBuiltinFloatType)
}
public protocol ExpressibleByFloatLiteral {
  associatedtype FloatLiteralType: _ExpressibleByBuiltinFloatLiteral
  init(floatLiteral value: FloatLiteralType)
}
public protocol _ExpressibleByBuiltinBooleanLiteral {
  init(_builtinBooleanLiteral value: Builtin.Int1)
}
public protocol ExpressibleByBooleanLiteral {
  associatedtype BooleanLiteralType: _ExpressibleByBuiltinBooleanLiteral
  init(booleanLiteral value: BooleanLiteralType)
}
public protocol _ExpressibleByBuiltinUnicodeScalarLiteral {
  init(_builtinUnicodeScalarLiteral value: Builtin.Int32)
}
public protocol ExpressibleByUnicodeScalarLiteral {
  associatedtype UnicodeScalarLiteralType: _ExpressibleByBuiltinUnicodeScalarLiteral
  init(unicodeScalarLiteral value: UnicodeScalarLiteralType)
}
public protocol _ExpressibleByBuiltinExtendedGraphemeClusterLiteral
  : _ExpressibleByBuiltinUnicodeScalarLiteral {
  init(
    _builtinExtendedGraphemeClusterLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1)
}
public protocol ExpressibleByExtendedGraphemeClusterLiteral
  : ExpressibleByUnicodeScalarLiteral {
  associatedtype ExtendedGraphemeClusterLiteralType
    : _ExpressibleByBuiltinExtendedGraphemeClusterLiteral
  init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType)
}
extension ExpressibleByExtendedGraphemeClusterLiteral
  where ExtendedGraphemeClusterLiteralType == UnicodeScalarLiteralType {
  public init(unicodeScalarLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.init(extendedGraphemeClusterLiteral: value)
  }
}
public protocol _ExpressibleByBuiltinStringLiteral
  : _ExpressibleByBuiltinExtendedGraphemeClusterLiteral {
  init(
    _builtinStringLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1)
}
public protocol ExpressibleByStringLiteral
  : ExpressibleByExtendedGraphemeClusterLiteral {
  associatedtype StringLiteralType: _ExpressibleByBuiltinStringLiteral
  init(stringLiteral value: StringLiteralType)
}
extension ExpressibleByStringLiteral
  where StringLiteralType == ExtendedGraphemeClusterLiteralType {
  public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(stringLiteral: value)
  }
}
public protocol ExpressibleByArrayLiteral {
  associatedtype ArrayLiteralElement
  init(arrayLiteral elements: ArrayLiteralElement...)
}
public protocol ExpressibleByDictionaryLiteral {
  associatedtype Key
  associatedtype Value
  init(dictionaryLiteral elements: (Key, Value)...)
}
public protocol ExpressibleByStringInterpolation
  : ExpressibleByStringLiteral {
  associatedtype StringInterpolation: StringInterpolationProtocol
    = DefaultStringInterpolation
    where StringInterpolation.StringLiteralType == StringLiteralType
  init(stringInterpolation: StringInterpolation)
}
extension ExpressibleByStringInterpolation
  where StringInterpolation == DefaultStringInterpolation {
  public init(stringInterpolation: DefaultStringInterpolation) {
    self.init(stringLiteral: stringInterpolation.make())
  }
}
public protocol StringInterpolationProtocol {
  associatedtype StringLiteralType: _ExpressibleByBuiltinStringLiteral
  init(literalCapacity: Int, interpolationCount: Int)
  mutating func appendLiteral(_ literal: StringLiteralType)
}
public protocol _ExpressibleByColorLiteral {
  init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float)
}
public protocol _ExpressibleByImageLiteral {
  init(imageLiteralResourceName path: String)
}
public protocol _ExpressibleByFileReferenceLiteral {
  init(fileReferenceLiteralResourceName path: String)
}
public protocol _DestructorSafeContainer {
}
