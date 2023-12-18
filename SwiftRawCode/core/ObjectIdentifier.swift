@frozen 
public struct ObjectIdentifier: Sendable {
  @usableFromInline 
  internal let _value: Builtin.RawPointer
  @inlinable 
  public init(_ x: AnyObject) {
    self._value = Builtin.bridgeToRawPointer(x)
  }
  @inlinable 
  public init(_ x: Any.Type) {
    self._value = unsafeBitCast(x, to: Builtin.RawPointer.self)
  }
}
extension ObjectIdentifier: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "ObjectIdentifier(\(_rawPointerToString(_value)))"
  }
}
extension ObjectIdentifier: Equatable {
  @inlinable 
  public static func == (x: ObjectIdentifier, y: ObjectIdentifier) -> Bool {
    return Bool(Builtin.cmp_eq_RawPointer(x._value, y._value))
  }
}
extension ObjectIdentifier: Comparable {
  @inlinable 
  public static func < (lhs: ObjectIdentifier, rhs: ObjectIdentifier) -> Bool {
    return UInt(bitPattern: lhs) < UInt(bitPattern: rhs)
  }
}
extension ObjectIdentifier: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(Int(Builtin.ptrtoint_Word(_value)))
  }
  public func _rawHashValue(seed: Int) -> Int {
    Int(Builtin.ptrtoint_Word(_value))._rawHashValue(seed: seed)
  }
}
extension UInt {
  @inlinable 
  public init(bitPattern objectID: ObjectIdentifier) {
    self.init(Builtin.ptrtoint_Word(objectID._value))
  }
}
extension Int {
  @inlinable 
  public init(bitPattern objectID: ObjectIdentifier) {
    self.init(bitPattern: UInt(bitPattern: objectID))
  }
}
