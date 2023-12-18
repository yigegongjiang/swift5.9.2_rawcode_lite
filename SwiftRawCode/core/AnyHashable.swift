public protocol _HasCustomAnyHashableRepresentation {
  __consuming func _toCustomAnyHashable() -> AnyHashable?
}
@usableFromInline
internal protocol _AnyHashableBox {
  var _canonicalBox: _AnyHashableBox { get }
  func _isEqual(to box: _AnyHashableBox) -> Bool?
  var _hashValue: Int { get }
  func _hash(into hasher: inout Hasher)
  func _rawHashValue(_seed: Int) -> Int
  var _base: Any { get }
  func _unbox<T: Hashable>() -> T?
  func _downCastConditional<T>(into result: UnsafeMutablePointer<T>) -> Bool
}
extension _AnyHashableBox {
  var _canonicalBox: _AnyHashableBox {
    return self
  }
}
internal struct _ConcreteHashableBox<Base: Hashable>: _AnyHashableBox {
  internal var _baseHashable: Base
  internal init(_ base: Base) {
    self._baseHashable = base
  }
  internal func _unbox<T: Hashable>() -> T? {
    return (self as _AnyHashableBox as? _ConcreteHashableBox<T>)?._baseHashable
  }
  internal func _isEqual(to rhs: _AnyHashableBox) -> Bool? {
    if let rhs: Base = rhs._unbox() {
      return _baseHashable == rhs
    }
    return nil
  }
  internal var _hashValue: Int {
    return _baseHashable.hashValue
  }
  func _hash(into hasher: inout Hasher) {
    _baseHashable.hash(into: &hasher)
  }
  func _rawHashValue(_seed: Int) -> Int {
    return _baseHashable._rawHashValue(seed: _seed)
  }
  internal var _base: Any {
    return _baseHashable
  }
  internal
  func _downCastConditional<T>(into result: UnsafeMutablePointer<T>) -> Bool {
    guard let value = _baseHashable as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
@frozen
public struct AnyHashable {
  internal var _box: _AnyHashableBox
  internal init(_box box: _AnyHashableBox) {
    self._box = box
  }
  public init<H: Hashable>(_ base: H) {
    if H.self == String.self {
      self.init(_box: _ConcreteHashableBox(base))
      return
    }
    if let custom =
      (base as? _HasCustomAnyHashableRepresentation)?._toCustomAnyHashable() {
      self = custom
      return
    }
    self.init(_box: _ConcreteHashableBox(false)) 
    _withUnprotectedUnsafeMutablePointer(to: &self) {
      _makeAnyHashableUpcastingToHashableBaseType(
        base,
        storingResultInto: $0)
    }
  }
  internal init<H: Hashable>(_usingDefaultRepresentationOf base: H) {
    self._box = _ConcreteHashableBox(base)
  }
  public var base: Any {
    return _box._base
  }
  internal
  func _downCastConditional<T>(into result: UnsafeMutablePointer<T>) -> Bool {
    if _box._downCastConditional(into: result) { return true }
    #if _runtime(_ObjC)
    if let value = _bridgeAnythingToObjectiveC(_box._base) as? T {
      result.initialize(to: value)
      return true
    }
    #endif
    return false
  }
}
extension AnyHashable: Equatable {
  public static func == (lhs: AnyHashable, rhs: AnyHashable) -> Bool {
    return lhs._box._canonicalBox._isEqual(to: rhs._box._canonicalBox) ?? false
  }
}
extension AnyHashable: Hashable {
  public var hashValue: Int {
    return _box._canonicalBox._hashValue
  }
  public func hash(into hasher: inout Hasher) {
    _box._canonicalBox._hash(into: &hasher)
  }
  public func _rawHashValue(seed: Int) -> Int {
    return _box._canonicalBox._rawHashValue(_seed: seed)
  }
}
extension AnyHashable: CustomStringConvertible {
  public var description: String {
    return String(describing: base)
  }
}
extension AnyHashable: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "AnyHashable(" + String(reflecting: base) + ")"
  }
}
#if SWIFT_ENABLE_REFLECTION
extension AnyHashable: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      children: ["value": base])
  }
}
#endif
@available(SwiftStdlib 5.5, *)
extension AnyHashable: _HasCustomAnyHashableRepresentation {
}
extension AnyHashable {
  public __consuming func _toCustomAnyHashable() -> AnyHashable? {
    return self
  }
}
internal func _makeAnyHashableUsingDefaultRepresentation<H: Hashable>(
  of value: H,
  storingResultInto result: UnsafeMutablePointer<AnyHashable>
) {
  result.pointee = AnyHashable(_usingDefaultRepresentationOf: value)
}
internal func _makeAnyHashableUpcastingToHashableBaseType<H: Hashable>(
  _ value: H,
  storingResultInto result: UnsafeMutablePointer<AnyHashable>
)
@inlinable
public 
func _convertToAnyHashable<H: Hashable>(_ value: H) -> AnyHashable {
  return AnyHashable(value)
}
internal func _convertToAnyHashableIndirect<H: Hashable>(
  _ value: H,
  _ target: UnsafeMutablePointer<AnyHashable>
) {
  target.initialize(to: AnyHashable(value))
}
internal func _anyHashableDownCastConditionalIndirect<T>(
  _ value: UnsafePointer<AnyHashable>,
  _ target: UnsafeMutablePointer<T>
) -> Bool {
  return value.pointee._downCastConditional(into: target)
}
