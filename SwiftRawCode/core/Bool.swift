@frozen
public struct Bool: Sendable {
  @usableFromInline
  internal var _value: Builtin.Int1
  public init() {
    let zero: Int8 = 0
    self._value = Builtin.trunc_Int8_Int1(zero._value)
  }
  internal init(_ v: Builtin.Int1) { self._value = v }
  @inlinable
  public init(_ value: Bool) {
    self = value
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    using generator: inout T
  ) -> Bool {
    return (generator.next() >> 17) & 1 == 0
  }
  @inlinable
  public static func random() -> Bool {
    var g = SystemRandomNumberGenerator()
    return Bool.random(using: &g)
  }
}
extension Bool: _ExpressibleByBuiltinBooleanLiteral, ExpressibleByBooleanLiteral {
  public init(_builtinBooleanLiteral value: Builtin.Int1) {
    self._value = value
  }
  public init(booleanLiteral value: Bool) {
    self = value
  }
}
extension Bool: CustomStringConvertible {
  @inlinable
  public var description: String {
    return self ? "true" : "false"
  }
}
extension Bool: Equatable {
  public static func == (lhs: Bool, rhs: Bool) -> Bool {
    return Bool(Builtin.cmp_eq_Int1(lhs._value, rhs._value))
  }
}
extension Bool: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine((self ? 1 : 0) as UInt8)
  }
}
extension Bool: LosslessStringConvertible {
  @inlinable
  public init?(_ description: String) {
    if description == "true" {
      self = true
    } else if description == "false" {
      self = false
    } else {
      return nil
    }
  }
}
extension Bool {
  public static prefix func ! (a: Bool) -> Bool {
    return Bool(Builtin.xor_Int1(a._value, true._value))
  }
}
extension Bool {
  @inline(__always)
  public static func && (lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows
      -> Bool {
    return lhs ? try rhs() : false
  }
  @inline(__always)
  public static func || (lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows
      -> Bool {
    return lhs ? true : try rhs()
  }
}
extension Bool {
  @inlinable
  public mutating func toggle() {
    self = !self
  }
}
