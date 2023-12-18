@frozen
public struct DefaultStringInterpolation: StringInterpolationProtocol, Sendable {
  @usableFromInline
  internal var _storage: String
  @inlinable
  public init(literalCapacity: Int, interpolationCount: Int) {
    let capacityPerInterpolation = 2
    let initialCapacity = literalCapacity +
      interpolationCount * capacityPerInterpolation
    _storage = String._createEmpty(withInitialCapacity: initialCapacity)
  }
  @inlinable
  public mutating func appendLiteral(_ literal: String) {
    literal.write(to: &self)
  }
  @inlinable
  public mutating func appendInterpolation<T>(_ value: T)
    where T: TextOutputStreamable, T: CustomStringConvertible
  {
    value.write(to: &self)
  }
  @inlinable
  public mutating func appendInterpolation<T>(_ value: T)
    where T: TextOutputStreamable
  {
    value.write(to: &self)
  }
  @inlinable
  public mutating func appendInterpolation<T>(_ value: T)
    where T: CustomStringConvertible
  {
    value.description.write(to: &self)
  }
  @inlinable
  public mutating func appendInterpolation<T>(_ value: T) {
    _print_unlocked(value, &self)
  }
  public mutating func appendInterpolation(_ value: Any.Type) {
	  _typeName(value, qualified: false).write(to: &self)
  }
  @inlinable
  internal __consuming func make() -> String {
    return _storage
  }
}
extension DefaultStringInterpolation: CustomStringConvertible {
  @inlinable
  public var description: String {
    return _storage
  }
}
extension DefaultStringInterpolation: TextOutputStream {
  @inlinable
  public mutating func write(_ string: String) {
    _storage.append(string)
  }
  public mutating func _writeASCII(_ buffer: UnsafeBufferPointer<UInt8>) {
    _storage._guts.append(_StringGuts(buffer, isASCII: true))
  }
}
extension String {
  @inlinable
  public init(stringInterpolation: DefaultStringInterpolation) {
    self = stringInterpolation.make()
  }
}
extension Substring {
  @inlinable
  public init(stringInterpolation: DefaultStringInterpolation) {
    self.init(stringInterpolation.make())
  }
}
