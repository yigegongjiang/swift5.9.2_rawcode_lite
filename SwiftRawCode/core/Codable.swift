public protocol Encodable {
  func encode(to encoder: any Encoder) throws
}
public protocol Decodable {
  init(from decoder: any Decoder) throws
}
public typealias Codable = Encodable & Decodable
public protocol CodingKey: Sendable,
                           CustomStringConvertible,
                           CustomDebugStringConvertible {
  var stringValue: String { get }
  init?(stringValue: String)
  var intValue: Int? { get }
  init?(intValue: Int)
}
extension CodingKey {
  public var description: String {
    let intValue = self.intValue?.description ?? "nil"
    return "\(type(of: self))(stringValue: \"\(stringValue)\", intValue: \(intValue))"
  }
  public var debugDescription: String {
    return description
  }
}
public protocol Encoder {
  var codingPath: [any CodingKey] { get }
  var userInfo: [CodingUserInfoKey: Any] { get }
  func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
  func unkeyedContainer() -> any UnkeyedEncodingContainer
  func singleValueContainer() -> any SingleValueEncodingContainer
}
public protocol Decoder {
  var codingPath: [any CodingKey] { get }
  var userInfo: [CodingUserInfoKey: Any] { get }
  func container<Key>(
    keyedBy type: Key.Type
  ) throws -> KeyedDecodingContainer<Key>
  func unkeyedContainer() throws -> any UnkeyedDecodingContainer
  func singleValueContainer() throws -> any SingleValueDecodingContainer
}
public protocol KeyedEncodingContainerProtocol {
  associatedtype Key: CodingKey
  var codingPath: [any CodingKey] { get }
  mutating func encodeNil(forKey key: Key) throws
  mutating func encode(_ value: Bool, forKey key: Key) throws
  mutating func encode(_ value: String, forKey key: Key) throws
  mutating func encode(_ value: Double, forKey key: Key) throws
  mutating func encode(_ value: Float, forKey key: Key) throws
  mutating func encode(_ value: Int, forKey key: Key) throws
  mutating func encode(_ value: Int8, forKey key: Key) throws
  mutating func encode(_ value: Int16, forKey key: Key) throws
  mutating func encode(_ value: Int32, forKey key: Key) throws
  mutating func encode(_ value: Int64, forKey key: Key) throws
  mutating func encode(_ value: UInt, forKey key: Key) throws
  mutating func encode(_ value: UInt8, forKey key: Key) throws
  mutating func encode(_ value: UInt16, forKey key: Key) throws
  mutating func encode(_ value: UInt32, forKey key: Key) throws
  mutating func encode(_ value: UInt64, forKey key: Key) throws
  mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws
  mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws
  mutating func encodeIfPresent(_ value: Bool?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: String?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Double?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Float?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Int?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Int8?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Int16?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Int32?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: Int64?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: UInt?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: UInt8?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: UInt16?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: UInt32?, forKey key: Key) throws
  mutating func encodeIfPresent(_ value: UInt64?, forKey key: Key) throws
  mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws
  mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey>
  mutating func nestedUnkeyedContainer(
    forKey key: Key
  ) -> any UnkeyedEncodingContainer
  mutating func superEncoder() -> any Encoder
  mutating func superEncoder(forKey key: Key) -> any Encoder
}
public struct KeyedEncodingContainer<K: CodingKey> :
  KeyedEncodingContainerProtocol
{
  public typealias Key = K
  internal var _box: _KeyedEncodingContainerBase
  public init<Container: KeyedEncodingContainerProtocol>(
    _ container: Container
  ) where Container.Key == Key {
    _box = _KeyedEncodingContainerBox(container)
  }
  public var codingPath: [any CodingKey] {
    return _box.codingPath
  }
  public mutating func encodeNil(forKey key: Key) throws {
    try _box.encodeNil(forKey: key)
  }
  public mutating func encode(_ value: Bool, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: String, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Double, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Float, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Int, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Int8, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Int16, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Int32, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: Int64, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: UInt, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: UInt8, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: UInt16, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: UInt32, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode(_ value: UInt64, forKey key: Key) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encode<T: Encodable>(
    _ value: T,
    forKey key: Key
  ) throws {
    try _box.encode(value, forKey: key)
  }
  public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws {
    try _box.encodeConditional(object, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Bool?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: String?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Double?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Float?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int8?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int16?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int32?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int64?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt8?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt16?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt32?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt64?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws {
    try _box.encodeIfPresent(value, forKey: key)
  }
  public mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey> {
    return _box.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }
  public mutating func nestedUnkeyedContainer(
    forKey key: Key
  ) -> any UnkeyedEncodingContainer {
    return _box.nestedUnkeyedContainer(forKey: key)
  }
  public mutating func superEncoder() -> any Encoder {
    return _box.superEncoder()
  }
  public mutating func superEncoder(forKey key: Key) -> any Encoder {
    return _box.superEncoder(forKey: key)
  }
}
public protocol KeyedDecodingContainerProtocol {
  associatedtype Key: CodingKey
  var codingPath: [any CodingKey] { get }
  var allKeys: [Key] { get }
  func contains(_ key: Key) -> Bool
  func decodeNil(forKey key: Key) throws -> Bool
  func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool
  func decode(_ type: String.Type, forKey key: Key) throws -> String
  func decode(_ type: Double.Type, forKey key: Key) throws -> Double
  func decode(_ type: Float.Type, forKey key: Key) throws -> Float
  func decode(_ type: Int.Type, forKey key: Key) throws -> Int
  func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8
  func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16
  func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32
  func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64
  func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt
  func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8
  func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16
  func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32
  func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64
  func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T
  func decodeIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool?
  func decodeIfPresent(_ type: String.Type, forKey key: Key) throws -> String?
  func decodeIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double?
  func decodeIfPresent(_ type: Float.Type, forKey key: Key) throws -> Float?
  func decodeIfPresent(_ type: Int.Type, forKey key: Key) throws -> Int?
  func decodeIfPresent(_ type: Int8.Type, forKey key: Key) throws -> Int8?
  func decodeIfPresent(_ type: Int16.Type, forKey key: Key) throws -> Int16?
  func decodeIfPresent(_ type: Int32.Type, forKey key: Key) throws -> Int32?
  func decodeIfPresent(_ type: Int64.Type, forKey key: Key) throws -> Int64?
  func decodeIfPresent(_ type: UInt.Type, forKey key: Key) throws -> UInt?
  func decodeIfPresent(_ type: UInt8.Type, forKey key: Key) throws -> UInt8?
  func decodeIfPresent(_ type: UInt16.Type, forKey key: Key) throws -> UInt16?
  func decodeIfPresent(_ type: UInt32.Type, forKey key: Key) throws -> UInt32?
  func decodeIfPresent(_ type: UInt64.Type, forKey key: Key) throws -> UInt64?
  func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T?
  func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey>
  func nestedUnkeyedContainer(
    forKey key: Key
  ) throws -> any UnkeyedDecodingContainer
  func superDecoder() throws -> any Decoder
  func superDecoder(forKey key: Key) throws -> any Decoder
}
public struct KeyedDecodingContainer<K: CodingKey> :
  KeyedDecodingContainerProtocol
{
  public typealias Key = K
  internal var _box: _KeyedDecodingContainerBase
  public init<Container: KeyedDecodingContainerProtocol>(
    _ container: Container
  ) where Container.Key == Key {
    _box = _KeyedDecodingContainerBox(container)
  }
  public var codingPath: [any CodingKey] {
    return _box.codingPath
  }
  public var allKeys: [Key] {
    return _box.allKeys as! [Key]
  }
  public func contains(_ key: Key) -> Bool {
    return _box.contains(key)
  }
  public func decodeNil(forKey key: Key) throws -> Bool {
    return try _box.decodeNil(forKey: key)
  }
  public func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
    return try _box.decode(Bool.self, forKey: key)
  }
  public func decode(_ type: String.Type, forKey key: Key) throws -> String {
    return try _box.decode(String.self, forKey: key)
  }
  public func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
    return try _box.decode(Double.self, forKey: key)
  }
  public func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
    return try _box.decode(Float.self, forKey: key)
  }
  public func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
    return try _box.decode(Int.self, forKey: key)
  }
  public func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
    return try _box.decode(Int8.self, forKey: key)
  }
  public func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
    return try _box.decode(Int16.self, forKey: key)
  }
  public func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
    return try _box.decode(Int32.self, forKey: key)
  }
  public func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
    return try _box.decode(Int64.self, forKey: key)
  }
  public func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
    return try _box.decode(UInt.self, forKey: key)
  }
  public func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
    return try _box.decode(UInt8.self, forKey: key)
  }
  public func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
    return try _box.decode(UInt16.self, forKey: key)
  }
  public func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
    return try _box.decode(UInt32.self, forKey: key)
  }
  public func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
    return try _box.decode(UInt64.self, forKey: key)
  }
  public func decode<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T {
    return try _box.decode(T.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Bool.Type,
    forKey key: Key
  ) throws -> Bool? {
    return try _box.decodeIfPresent(Bool.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: String.Type,
    forKey key: Key
  ) throws -> String? {
    return try _box.decodeIfPresent(String.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Double.Type,
    forKey key: Key
  ) throws -> Double? {
    return try _box.decodeIfPresent(Double.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Float.Type,
    forKey key: Key
  ) throws -> Float? {
    return try _box.decodeIfPresent(Float.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int.Type,
    forKey key: Key
  ) throws -> Int? {
    return try _box.decodeIfPresent(Int.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int8.Type,
    forKey key: Key
  ) throws -> Int8? {
    return try _box.decodeIfPresent(Int8.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int16.Type,
    forKey key: Key
  ) throws -> Int16? {
    return try _box.decodeIfPresent(Int16.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int32.Type,
    forKey key: Key
  ) throws -> Int32? {
    return try _box.decodeIfPresent(Int32.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int64.Type,
    forKey key: Key
  ) throws -> Int64? {
    return try _box.decodeIfPresent(Int64.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt.Type,
    forKey key: Key
  ) throws -> UInt? {
    return try _box.decodeIfPresent(UInt.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt8.Type,
    forKey key: Key
  ) throws -> UInt8? {
    return try _box.decodeIfPresent(UInt8.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt16.Type,
    forKey key: Key
  ) throws -> UInt16? {
    return try _box.decodeIfPresent(UInt16.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt32.Type,
    forKey key: Key
  ) throws -> UInt32? {
    return try _box.decodeIfPresent(UInt32.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt64.Type,
    forKey key: Key
  ) throws -> UInt64? {
    return try _box.decodeIfPresent(UInt64.self, forKey: key)
  }
  public func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T? {
    return try _box.decodeIfPresent(T.self, forKey: key)
  }
  public func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey> {
    return try _box.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }
  public func nestedUnkeyedContainer(
    forKey key: Key
  ) throws -> any UnkeyedDecodingContainer {
    return try _box.nestedUnkeyedContainer(forKey: key)
  }
  public func superDecoder() throws -> any Decoder {
    return try _box.superDecoder()
  }
  public func superDecoder(forKey key: Key) throws -> any Decoder {
    return try _box.superDecoder(forKey: key)
  }
}
public protocol UnkeyedEncodingContainer {
  var codingPath: [any CodingKey] { get }
  var count: Int { get }
  mutating func encodeNil() throws
  mutating func encode(_ value: Bool) throws
  mutating func encode(_ value: String) throws
  mutating func encode(_ value: Double) throws
  mutating func encode(_ value: Float) throws
  mutating func encode(_ value: Int) throws
  mutating func encode(_ value: Int8) throws
  mutating func encode(_ value: Int16) throws
  mutating func encode(_ value: Int32) throws
  mutating func encode(_ value: Int64) throws
  mutating func encode(_ value: UInt) throws
  mutating func encode(_ value: UInt8) throws
  mutating func encode(_ value: UInt16) throws
  mutating func encode(_ value: UInt32) throws
  mutating func encode(_ value: UInt64) throws
  mutating func encode<T: Encodable>(_ value: T) throws
  mutating func encodeConditional<T: AnyObject & Encodable>(_ object: T) throws
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Bool
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == String
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Double
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Float
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int8
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int16
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int32
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int64
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt8
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt16
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt32
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt64
  mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element: Encodable
  mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type
  ) -> KeyedEncodingContainer<NestedKey>
  mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer
  mutating func superEncoder() -> any Encoder
}
public protocol UnkeyedDecodingContainer {
  var codingPath: [any CodingKey] { get }
  var count: Int? { get }
  var isAtEnd: Bool { get }
  var currentIndex: Int { get }
  mutating func decodeNil() throws -> Bool
  mutating func decode(_ type: Bool.Type) throws -> Bool
  mutating func decode(_ type: String.Type) throws -> String
  mutating func decode(_ type: Double.Type) throws -> Double
  mutating func decode(_ type: Float.Type) throws -> Float
  mutating func decode(_ type: Int.Type) throws -> Int
  mutating func decode(_ type: Int8.Type) throws -> Int8
  mutating func decode(_ type: Int16.Type) throws -> Int16
  mutating func decode(_ type: Int32.Type) throws -> Int32
  mutating func decode(_ type: Int64.Type) throws -> Int64
  mutating func decode(_ type: UInt.Type) throws -> UInt
  mutating func decode(_ type: UInt8.Type) throws -> UInt8
  mutating func decode(_ type: UInt16.Type) throws -> UInt16
  mutating func decode(_ type: UInt32.Type) throws -> UInt32
  mutating func decode(_ type: UInt64.Type) throws -> UInt64
  mutating func decode<T: Decodable>(_ type: T.Type) throws -> T
  mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool?
  mutating func decodeIfPresent(_ type: String.Type) throws -> String?
  mutating func decodeIfPresent(_ type: Double.Type) throws -> Double?
  mutating func decodeIfPresent(_ type: Float.Type) throws -> Float?
  mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?
  mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8?
  mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16?
  mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32?
  mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64?
  mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
  mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?
  mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?
  mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?
  mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?
  mutating func decodeIfPresent<T: Decodable>(_ type: T.Type) throws -> T?
  mutating func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type
  ) throws -> KeyedDecodingContainer<NestedKey>
  mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer
  mutating func superDecoder() throws -> any Decoder
}
public protocol SingleValueEncodingContainer {
  var codingPath: [any CodingKey] { get }
  mutating func encodeNil() throws
  mutating func encode(_ value: Bool) throws
  mutating func encode(_ value: String) throws
  mutating func encode(_ value: Double) throws
  mutating func encode(_ value: Float) throws
  mutating func encode(_ value: Int) throws
  mutating func encode(_ value: Int8) throws
  mutating func encode(_ value: Int16) throws
  mutating func encode(_ value: Int32) throws
  mutating func encode(_ value: Int64) throws
  mutating func encode(_ value: UInt) throws
  mutating func encode(_ value: UInt8) throws
  mutating func encode(_ value: UInt16) throws
  mutating func encode(_ value: UInt32) throws
  mutating func encode(_ value: UInt64) throws
  mutating func encode<T: Encodable>(_ value: T) throws
}
public protocol SingleValueDecodingContainer {
  var codingPath: [any CodingKey] { get }
  func decodeNil() -> Bool
  func decode(_ type: Bool.Type) throws -> Bool
  func decode(_ type: String.Type) throws -> String
  func decode(_ type: Double.Type) throws -> Double
  func decode(_ type: Float.Type) throws -> Float
  func decode(_ type: Int.Type) throws -> Int
  func decode(_ type: Int8.Type) throws -> Int8
  func decode(_ type: Int16.Type) throws -> Int16
  func decode(_ type: Int32.Type) throws -> Int32
  func decode(_ type: Int64.Type) throws -> Int64
  func decode(_ type: UInt.Type) throws -> UInt
  func decode(_ type: UInt8.Type) throws -> UInt8
  func decode(_ type: UInt16.Type) throws -> UInt16
  func decode(_ type: UInt32.Type) throws -> UInt32
  func decode(_ type: UInt64.Type) throws -> UInt64
  func decode<T: Decodable>(_ type: T.Type) throws -> T
}
public struct CodingUserInfoKey: RawRepresentable, Equatable, Hashable, Sendable {
  public typealias RawValue = String
  public let rawValue: String
  public init?(rawValue: String) {
    self.rawValue = rawValue
  }
  public static func ==(
    lhs: CodingUserInfoKey,
    rhs: CodingUserInfoKey
  ) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
  public var hashValue: Int {
    return self.rawValue.hashValue
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.rawValue)
  }
}
public enum EncodingError: Error {
  public struct Context: Sendable {
    public let codingPath: [any CodingKey]
    public let debugDescription: String
    public let underlyingError: Error?
    public init(
      codingPath: [any CodingKey],
      debugDescription: String,
      underlyingError: Error? = nil
    ) {
      self.codingPath = codingPath
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }
  }
  case invalidValue(Any, Context)
  public var _domain: String {
    return "NSCocoaErrorDomain"
  }
  public var _code: Int {
    switch self {
    case .invalidValue: return 4866
    }
  }
  public var _userInfo: AnyObject? {
    #if _runtime(_ObjC)
      let context: Context
      switch self {
      case .invalidValue(_, let c): context = c
      }
      var userInfo: [String: Any] = [
        "NSCodingPath": context.codingPath,
        "NSDebugDescription": context.debugDescription
      ]
      if let underlyingError = context.underlyingError {
        userInfo["NSUnderlyingError"] = underlyingError
      }
      return userInfo as AnyObject
    #else
      return nil
    #endif
  }
}
public enum DecodingError: Error {
  public struct Context: Sendable {
    public let codingPath: [any CodingKey]
    public let debugDescription: String
    public let underlyingError: Error?
    public init(
      codingPath: [any CodingKey],
      debugDescription: String,
      underlyingError: Error? = nil
    ) {
      self.codingPath = codingPath
      self.debugDescription = debugDescription
      self.underlyingError = underlyingError
    }
  }
  case typeMismatch(Any.Type, Context)
  case valueNotFound(Any.Type, Context)
  case keyNotFound(any CodingKey, Context)
  case dataCorrupted(Context)
  public var _domain: String {
    return "NSCocoaErrorDomain"
  }
  public var _code: Int {
    switch self {
    case .keyNotFound, .valueNotFound: return 4865
    case .typeMismatch, .dataCorrupted:  return 4864
    }
  }
  public var _userInfo: AnyObject? {
    #if _runtime(_ObjC)
      let context: Context
      switch self {
      case .keyNotFound(_,   let c): context = c
      case .valueNotFound(_, let c): context = c
      case .typeMismatch(_,  let c): context = c
      case .dataCorrupted(   let c): context = c
      }
      var userInfo: [String: Any] = [
        "NSCodingPath": context.codingPath,
        "NSDebugDescription": context.debugDescription
      ]
      if let underlyingError = context.underlyingError {
        userInfo["NSUnderlyingError"] = underlyingError
      }
      return userInfo as AnyObject
    #else
      return nil
    #endif
  }
}
internal struct _GenericIndexKey: CodingKey, Sendable {
  internal var stringValue: String
  internal var intValue: Int?
  internal init?(stringValue: String) {
    return nil
  }
  internal init?(intValue: Int) {
    self.stringValue = "Index \(intValue)"
    self.intValue = intValue
  }
}
extension DecodingError {
  public static func dataCorruptedError<C: KeyedDecodingContainerProtocol>(
    forKey key: C.Key,
    in container: C,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(
      codingPath: container.codingPath + [key],
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }
  public static func dataCorruptedError(
    in container: any UnkeyedDecodingContainer,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(
      codingPath: container.codingPath +
        [_GenericIndexKey(intValue: container.currentIndex)!],
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }
  public static func dataCorruptedError(
    in container: any SingleValueDecodingContainer,
    debugDescription: String
  ) -> DecodingError {
    let context = DecodingError.Context(codingPath: container.codingPath,
      debugDescription: debugDescription)
    return .dataCorrupted(context)
  }
}
internal class _KeyedEncodingContainerBase {
  internal init(){}
  deinit {}
  internal var codingPath: [CodingKey] {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encode<T: Encodable, K: CodingKey>(_ value: T, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeConditional<T: AnyObject & Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Bool?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: String?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Double?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Float?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Int?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Int8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Int16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Int32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: Int64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt8?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt16?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt32?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<K: CodingKey>(_ value: UInt64?, forKey key: K) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: K
  ) -> KeyedEncodingContainer<NestedKey> {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func superEncoder() -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
  internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    fatalError("_KeyedEncodingContainerBase cannot be used directly.")
  }
}
internal final class _KeyedEncodingContainerBox<
  Concrete: KeyedEncodingContainerProtocol
>: _KeyedEncodingContainerBase {
  typealias Key = Concrete.Key
  internal var concrete: Concrete
  internal init(_ container: Concrete) {
    concrete = container
  }
  override internal var codingPath: [CodingKey] {
    return concrete.codingPath
  }
  override internal func encodeNil<K: CodingKey>(forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeNil(forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Bool, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: String, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Double, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Float, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Int, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Int8, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Int16, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Int32, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: Int64, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: UInt, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: UInt8, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: UInt16, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: UInt32, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<K: CodingKey>(_ value: UInt64, forKey key: K) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encode<T: Encodable, K: CodingKey>(
    _ value: T,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encode(value, forKey: key)
  }
  override internal func encodeConditional<T: AnyObject & Encodable, K: CodingKey>(
    _ object: T,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeConditional(object, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Bool?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: String?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Double?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Float?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int8?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int16?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int32?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: Int64?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt8?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt16?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt32?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<K: CodingKey>(
    _ value: UInt64?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func encodeIfPresent<T: Encodable, K: CodingKey>(
    _ value: T?,
    forKey key: K
  ) throws {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    try concrete.encodeIfPresent(value, forKey: key)
  }
  override internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: K
  ) -> KeyedEncodingContainer<NestedKey> {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }
  override internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) -> UnkeyedEncodingContainer {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.nestedUnkeyedContainer(forKey: key)
  }
  override internal func superEncoder() -> Encoder {
    return concrete.superEncoder()
  }
  override internal func superEncoder<K: CodingKey>(forKey key: K) -> Encoder {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.superEncoder(forKey: key)
  }
}
internal class _KeyedDecodingContainerBase {
  internal init(){}
  deinit {}
  internal var codingPath: [CodingKey] {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal var allKeys: [CodingKey] {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func contains<K: CodingKey>(_ key: K) -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64 {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decode<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func decodeIfPresent<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T? {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy type: NestedKey.Type,
    forKey key: K
  ) throws -> KeyedDecodingContainer<NestedKey> {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) throws -> UnkeyedDecodingContainer {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func superDecoder() throws -> Decoder {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
  internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
    fatalError("_KeyedDecodingContainerBase cannot be used directly.")
  }
}
internal final class _KeyedDecodingContainerBox<
  Concrete: KeyedDecodingContainerProtocol
>: _KeyedDecodingContainerBase {
  typealias Key = Concrete.Key
  internal var concrete: Concrete
  internal init(_ container: Concrete) {
    concrete = container
  }
  override var codingPath: [CodingKey] {
    return concrete.codingPath
  }
  override var allKeys: [CodingKey] {
    return concrete.allKeys
  }
  override internal func contains<K: CodingKey>(_ key: K) -> Bool {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return concrete.contains(key)
  }
  override internal func decodeNil<K: CodingKey>(forKey key: K) throws -> Bool {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeNil(forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Bool.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(String.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Double.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Float.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int8.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int16.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int32.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(Int64.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt8.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt16.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt32.self, forKey: key)
  }
  override internal func decode<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64 {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(UInt64.self, forKey: key)
  }
  override internal func decode<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decode(T.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Bool.Type,
    forKey key: K
  ) throws -> Bool? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Bool.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: String.Type,
    forKey key: K
  ) throws -> String? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(String.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Double.Type,
    forKey key: K
  ) throws -> Double? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Double.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Float.Type,
    forKey key: K
  ) throws -> Float? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Float.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int.Type,
    forKey key: K
  ) throws -> Int? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int8.Type,
    forKey key: K
  ) throws -> Int8? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int8.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int16.Type,
    forKey key: K
  ) throws -> Int16? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int16.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int32.Type,
    forKey key: K
  ) throws -> Int32? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int32.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: Int64.Type,
    forKey key: K
  ) throws -> Int64? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(Int64.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt.Type,
    forKey key: K
  ) throws -> UInt? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt8.Type,
    forKey key: K
  ) throws -> UInt8? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt8.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt16.Type,
    forKey key: K
  ) throws -> UInt16? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt16.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt32.Type,
    forKey key: K
  ) throws -> UInt32? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt32.self, forKey: key)
  }
  override internal func decodeIfPresent<K: CodingKey>(
    _ type: UInt64.Type,
    forKey key: K
  ) throws -> UInt64? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(UInt64.self, forKey: key)
  }
  override internal func decodeIfPresent<T: Decodable, K: CodingKey>(
    _ type: T.Type,
    forKey key: K
  ) throws -> T? {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.decodeIfPresent(T.self, forKey: key)
  }
  override internal func nestedContainer<NestedKey, K: CodingKey>(
    keyedBy type: NestedKey.Type,
    forKey key: K
  ) throws -> KeyedDecodingContainer<NestedKey> {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.nestedContainer(keyedBy: NestedKey.self, forKey: key)
  }
  override internal func nestedUnkeyedContainer<K: CodingKey>(
    forKey key: K
  ) throws -> UnkeyedDecodingContainer {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.nestedUnkeyedContainer(forKey: key)
  }
  override internal func superDecoder() throws -> Decoder {
    return try concrete.superDecoder()
  }
  override internal func superDecoder<K: CodingKey>(forKey key: K) throws -> Decoder {
    _internalInvariant(K.self == Key.self)
    let key = unsafeBitCast(key, to: Key.self)
    return try concrete.superDecoder(forKey: key)
  }
}
extension Bool: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Bool.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Bool> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Bool> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension String: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(String.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<String> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<String> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Double: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Double.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Double> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Double> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Float: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Float.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Float> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Float> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension Float16: Codable {
  public init(from decoder: any Decoder) throws {
    let floatValue = try Float(from: decoder)
    self = Float16(floatValue)
    if isInfinite && floatValue.isFinite {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Parsed JSON number \(floatValue) does not fit in Float16."
        )
      )
    }
  }
  public func encode(to encoder: any Encoder) throws {
    try Float(self).encode(to: encoder)
  }
}
#endif
extension Int: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Int> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Int> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Int8: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int8.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Int8> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Int8> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Int16: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int16.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Int16> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Int16> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Int32: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int32.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Int32> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Int32> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Int64: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(Int64.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<Int64> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<Int64> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension UInt: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<UInt> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<UInt> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension UInt8: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt8.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<UInt8> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<UInt8> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension UInt16: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt16.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<UInt16> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<UInt16> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension UInt32: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt32.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<UInt32> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<UInt32> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension UInt64: Codable {
  public init(from decoder: any Decoder) throws {
    self = try decoder.singleValueContainer().decode(UInt64.self)
  }
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self)
  }
}
extension RawRepresentable<UInt64> where Self: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension RawRepresentable<UInt64> where Self: Decodable {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"
        )
      )
    }
    self = value
  }
}
extension Optional: Encodable where Wrapped: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .none: try container.encodeNil()
    case .some(let wrapped): try container.encode(wrapped)
    }
  }
}
extension Optional: Decodable where Wrapped: Decodable {
  public init(from decoder: any Decoder) throws {
    let container = try decoder.singleValueContainer()
    if container.decodeNil() {
      self = .none
    }  else {
      let element = try container.decode(Wrapped.self)
      self = .some(element)
    }
  }
}
extension Array: Encodable where Element: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}
extension Array: Decodable where Element: Decodable {
  public init(from decoder: any Decoder) throws {
    self.init()
    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.append(element)
    }
  }
}
extension ContiguousArray: Encodable where Element: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}
extension ContiguousArray: Decodable where Element: Decodable {
  public init(from decoder: any Decoder) throws {
    self.init()
    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.append(element)
    }
  }
}
extension Set: Encodable where Element: Encodable {
  public func encode(to encoder: any Encoder) throws {
    var container = encoder.unkeyedContainer()
    for element in self {
      try container.encode(element)
    }
  }
}
extension Set: Decodable where Element: Decodable {
  public init(from decoder: any Decoder) throws {
    self.init()
    var container = try decoder.unkeyedContainer()
    while !container.isAtEnd {
      let element = try container.decode(Element.self)
      self.insert(element)
    }
  }
}
internal struct _DictionaryCodingKey: CodingKey {
  internal let stringValue: String
  internal let intValue: Int?
  internal init(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = Int(stringValue)
  }
  internal init(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }
  fileprivate init(codingKey: any CodingKey) {
    self.stringValue = codingKey.stringValue
    self.intValue = codingKey.intValue
  }
}
@available(SwiftStdlib 5.6, *)
public protocol CodingKeyRepresentable {
  @available(SwiftStdlib 5.6, *)
  var codingKey: CodingKey { get }
  @available(SwiftStdlib 5.6, *)
  init?<T: CodingKey>(codingKey: T)
}
@available(SwiftStdlib 5.6, *)
extension RawRepresentable
where Self: CodingKeyRepresentable, RawValue == String {
  @available(SwiftStdlib 5.6, *)
  public var codingKey: CodingKey {
    _DictionaryCodingKey(stringValue: rawValue)
  }
  @available(SwiftStdlib 5.6, *)
  public init?<T: CodingKey>(codingKey: T) {
    self.init(rawValue: codingKey.stringValue)
  }
}
@available(SwiftStdlib 5.6, *)
extension RawRepresentable where Self: CodingKeyRepresentable, RawValue == Int {
  @available(SwiftStdlib 5.6, *)
  public var codingKey: CodingKey {
    _DictionaryCodingKey(intValue: rawValue)
  }
  @available(SwiftStdlib 5.6, *)
  public init?<T: CodingKey>(codingKey: T) {
    if let intValue = codingKey.intValue {
      self.init(rawValue: intValue)
    } else {
      return nil
    }
  }
}
@available(SwiftStdlib 5.6, *)
extension Int: CodingKeyRepresentable {
  @available(SwiftStdlib 5.6, *)
  public var codingKey: CodingKey {
    _DictionaryCodingKey(intValue: self)
  }
  @available(SwiftStdlib 5.6, *)
  public init?<T: CodingKey>(codingKey: T) {
    if let intValue = codingKey.intValue {
      self = intValue
    } else {
      return nil
    }
  }
}
@available(SwiftStdlib 5.6, *)
extension String: CodingKeyRepresentable {
  @available(SwiftStdlib 5.6, *)
  public var codingKey: CodingKey {
    _DictionaryCodingKey(stringValue: self)
  }
  @available(SwiftStdlib 5.6, *)
  public init?<T: CodingKey>(codingKey: T) {
    self = codingKey.stringValue
  }
}
extension Dictionary: Encodable where Key: Encodable, Value: Encodable {
  public func encode(to encoder: any Encoder) throws {
    if Key.self == String.self {
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = _DictionaryCodingKey(stringValue: key as! String)
        try container.encode(value, forKey: codingKey)
      }
    } else if Key.self == Int.self {
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = _DictionaryCodingKey(intValue: key as! Int)
        try container.encode(value, forKey: codingKey)
      }
    } else if #available(SwiftStdlib 5.6, *),
              Key.self is CodingKeyRepresentable.Type {
      var container = encoder.container(keyedBy: _DictionaryCodingKey.self)
      for (key, value) in self {
        let codingKey = (key as! CodingKeyRepresentable).codingKey
        let dictionaryCodingKey = _DictionaryCodingKey(codingKey: codingKey)
        try container.encode(value, forKey: dictionaryCodingKey)
      }
    } else {
      var container = encoder.unkeyedContainer()
      for (key, value) in self {
        try container.encode(key)
        try container.encode(value)
      }
    }
  }
}
extension Dictionary: Decodable where Key: Decodable, Value: Decodable {
  public init(from decoder: any Decoder) throws {
    self.init()
    if Key.self == String.self {
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for key in container.allKeys {
        let value = try container.decode(Value.self, forKey: key)
        self[key.stringValue as! Key] = value
      }
    } else if Key.self == Int.self {
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for key in container.allKeys {
        guard key.intValue != nil else {
          var codingPath = decoder.codingPath
          codingPath.append(key)
          throw DecodingError.typeMismatch(
            Int.self,
            DecodingError.Context(
              codingPath: codingPath,
              debugDescription: "Expected Int key but found String key instead."
            )
          )
        }
        let value = try container.decode(Value.self, forKey: key)
        self[key.intValue! as! Key] = value
      }
    } else if #available(SwiftStdlib 5.6, *),
              let keyType = Key.self as? CodingKeyRepresentable.Type {
      let container = try decoder.container(keyedBy: _DictionaryCodingKey.self)
      for codingKey in container.allKeys {
        guard let key: Key = keyType.init(codingKey: codingKey) as? Key else {
          throw DecodingError.dataCorruptedError(
            forKey: codingKey,
            in: container,
            debugDescription: "Could not convert key to type \(Key.self)"
          )
        }
        let value: Value = try container.decode(Value.self, forKey: codingKey)
        self[key] = value
      }
    } else {
      var container = try decoder.unkeyedContainer()
      if let count = container.count {
        guard count % 2 == 0 else {
          throw DecodingError.dataCorrupted(
            DecodingError.Context(
              codingPath: decoder.codingPath,
              debugDescription: "Expected collection of key-value pairs; encountered odd-length array instead."
            )
          )
        }
      }
      while !container.isAtEnd {
        let key = try container.decode(Key.self)
        guard !container.isAtEnd else {
          throw DecodingError.dataCorrupted(
            DecodingError.Context(
              codingPath: decoder.codingPath,
              debugDescription: "Unkeyed container reached end before value in key-value pair."
            )
          )
        }
        let value = try container.decode(Value.self)
        self[key] = value
      }
    }
  }
}
extension KeyedEncodingContainerProtocol {
  public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T,
    forKey key: Key
  ) throws {
    try encode(object, forKey: key)
  }
}
extension KeyedEncodingContainerProtocol {
  public mutating func encodeIfPresent(
    _ value: Bool?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: String?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Double?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Float?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int8?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int16?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int32?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: Int64?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt8?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt16?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt32?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent(
    _ value: UInt64?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
  public mutating func encodeIfPresent<T: Encodable>(
    _ value: T?,
    forKey key: Key
  ) throws {
    guard let value = value else { return }
    try encode(value, forKey: key)
  }
}
extension KeyedDecodingContainerProtocol {
  public func decodeIfPresent(
    _ type: Bool.Type,
    forKey key: Key
  ) throws -> Bool? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Bool.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: String.Type,
    forKey key: Key
  ) throws -> String? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(String.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Double.Type,
    forKey key: Key
  ) throws -> Double? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Double.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Float.Type,
    forKey key: Key
  ) throws -> Float? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Float.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int.Type,
    forKey key: Key
  ) throws -> Int? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int8.Type,
    forKey key: Key
  ) throws -> Int8? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int8.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int16.Type,
    forKey key: Key
  ) throws -> Int16? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int16.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int32.Type,
    forKey key: Key
  ) throws -> Int32? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int32.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: Int64.Type,
    forKey key: Key
  ) throws -> Int64? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(Int64.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt.Type,
    forKey key: Key
  ) throws -> UInt? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt8.Type,
    forKey key: Key
  ) throws -> UInt8? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt8.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt16.Type,
    forKey key: Key
  ) throws -> UInt16? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt16.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt32.Type,
    forKey key: Key
  ) throws -> UInt32? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt32.self, forKey: key)
  }
  public func decodeIfPresent(
    _ type: UInt64.Type,
    forKey key: Key
  ) throws -> UInt64? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(UInt64.self, forKey: key)
  }
  public func decodeIfPresent<T: Decodable>(
    _ type: T.Type,
    forKey key: Key
  ) throws -> T? {
    guard try self.contains(key) && !self.decodeNil(forKey: key)
      else { return nil }
    return try self.decode(T.self, forKey: key)
  }
}
extension UnkeyedEncodingContainer {
  public mutating func encodeConditional<T: AnyObject & Encodable>(
    _ object: T
  ) throws {
    try self.encode(object)
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Bool {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == String {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Double {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Float {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int8 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int16 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int32 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == Int64 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt8 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt16 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt32 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element == UInt64 {
    for element in sequence {
      try self.encode(element)
    }
  }
  public mutating func encode<T: Sequence>(
    contentsOf sequence: T
  ) throws where T.Element: Encodable {
    for element in sequence {
      try self.encode(element)
    }
  }
}
extension UnkeyedDecodingContainer {
  public mutating func decodeIfPresent(
    _ type: Bool.Type
  ) throws -> Bool? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Bool.self)
  }
  public mutating func decodeIfPresent(
    _ type: String.Type
  ) throws -> String? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(String.self)
  }
  public mutating func decodeIfPresent(
    _ type: Double.Type
  ) throws -> Double? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Double.self)
  }
  public mutating func decodeIfPresent(
    _ type: Float.Type
  ) throws -> Float? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Float.self)
  }
  public mutating func decodeIfPresent(
    _ type: Int.Type
  ) throws -> Int? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int.self)
  }
  public mutating func decodeIfPresent(
    _ type: Int8.Type
  ) throws -> Int8? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int8.self)
  }
  public mutating func decodeIfPresent(
    _ type: Int16.Type
  ) throws -> Int16? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int16.self)
  }
  public mutating func decodeIfPresent(
    _ type: Int32.Type
  ) throws -> Int32? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int32.self)
  }
  public mutating func decodeIfPresent(
    _ type: Int64.Type
  ) throws -> Int64? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(Int64.self)
  }
  public mutating func decodeIfPresent(
    _ type: UInt.Type
  ) throws -> UInt? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt.self)
  }
  public mutating func decodeIfPresent(
    _ type: UInt8.Type
  ) throws -> UInt8? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt8.self)
  }
  public mutating func decodeIfPresent(
    _ type: UInt16.Type
  ) throws -> UInt16? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt16.self)
  }
  public mutating func decodeIfPresent(
    _ type: UInt32.Type
  ) throws -> UInt32? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt32.self)
  }
  public mutating func decodeIfPresent(
    _ type: UInt64.Type
  ) throws -> UInt64? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(UInt64.self)
  }
  public mutating func decodeIfPresent<T: Decodable>(
    _ type: T.Type
  ) throws -> T? {
    guard try !self.isAtEnd && !self.decodeNil() else { return nil }
    return try self.decode(T.self)
  }
}
