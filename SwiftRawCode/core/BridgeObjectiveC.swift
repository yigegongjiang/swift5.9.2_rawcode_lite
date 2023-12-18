public protocol _ObjectiveCBridgeable {
  associatedtype _ObjectiveCType: AnyObject
  func _bridgeToObjectiveC() -> _ObjectiveCType
  static func _forceBridgeFromObjectiveC(
    _ source: _ObjectiveCType,
    result: inout Self?
  )
  @discardableResult
  static func _conditionallyBridgeFromObjectiveC(
    _ source: _ObjectiveCType,
    result: inout Self?
  ) -> Bool
  static func _unconditionallyBridgeFromObjectiveC(_ source: _ObjectiveCType?)
      -> Self
}
#if _runtime(_ObjC)
@available(SwiftStdlib 5.2, *)
@usableFromInline
internal func _SwiftCreateBridgedArray_DoNotCall(
  values: UnsafePointer<AnyObject>,
  numValues: Int
) -> Unmanaged<AnyObject> {
  let bufPtr = UnsafeBufferPointer(start: values, count: numValues)
  let bridged = Array(bufPtr)._bridgeToObjectiveCImpl()
  return Unmanaged<AnyObject>.passRetained(bridged)
}
@available(SwiftStdlib 5.2, *)
@usableFromInline
internal func _SwiftCreateBridgedMutableArray_DoNotCall(
  values: UnsafePointer<AnyObject>,
  numValues: Int
) -> Unmanaged<AnyObject> {
  let bufPtr = UnsafeBufferPointer(start: values, count: numValues)
  let bridged = _SwiftNSMutableArray(Array(bufPtr))
  return Unmanaged<AnyObject>.passRetained(bridged)
}
internal func _connectNSBaseClasses() -> Bool
private let _bridgeInitializedSuccessfully = _connectNSBaseClasses()
internal var _orphanedFoundationSubclassesReparented: Bool = false
 internal func _connectOrphanedFoundationSubclassesIfNeeded() -> Void {
  let bridgeWorks = _bridgeInitializedSuccessfully
  _debugPrecondition(bridgeWorks)
  _orphanedFoundationSubclassesReparented = true
}
public struct _BridgeableMetatype: _ObjectiveCBridgeable {
  internal var value: AnyObject.Type
  internal init(value: AnyObject.Type) {
    self.value = value
  }
  public typealias _ObjectiveCType = AnyObject
  public func _bridgeToObjectiveC() -> AnyObject {
    return value
  }
  public static func _forceBridgeFromObjectiveC(
    _ source: AnyObject,
    result: inout _BridgeableMetatype?
  ) {
    result = _BridgeableMetatype(value: source as! AnyObject.Type)
  }
  public static func _conditionallyBridgeFromObjectiveC(
    _ source: AnyObject,
    result: inout _BridgeableMetatype?
  ) -> Bool {
    if let type = source as? AnyObject.Type {
      result = _BridgeableMetatype(value: type)
      return true
    }
    result = nil
    return false
  }
  public static func _unconditionallyBridgeFromObjectiveC(_ source: AnyObject?)
      -> _BridgeableMetatype {
    var result: _BridgeableMetatype?
    _forceBridgeFromObjectiveC(source!, result: &result)
    return result!
  }
}
@inlinable
public func _bridgeAnythingToObjectiveC<T>(_ x: T) -> AnyObject {
  if _fastPath(_isClassOrObjCExistential(T.self)) {
    return unsafeBitCast(x, to: AnyObject.self)
  }
  return _bridgeAnythingNonVerbatimToObjectiveC(x)
}
public 
func _bridgeAnythingNonVerbatimToObjectiveC<T>(_ x: __owned T) -> AnyObject
public func _bridgeAnyObjectToAny(_ possiblyNullObject: AnyObject?) -> Any {
  if let nonnullObject = possiblyNullObject {
    return nonnullObject 
  }
  return possiblyNullObject as Any
}
@inlinable
public func _forceBridgeFromObjectiveC<T>(_ x: AnyObject, _: T.Type) -> T {
  if _fastPath(_isClassOrObjCExistential(T.self)) {
    return x as! T
  }
  var result: T?
  _bridgeNonVerbatimFromObjectiveC(x, T.self, &result)
  return result!
}
@inlinable
public func _forceBridgeFromObjectiveC_bridgeable<T:_ObjectiveCBridgeable> (
  _ x: T._ObjectiveCType,
  _: T.Type
) -> T {
  var result: T?
  T._forceBridgeFromObjectiveC(x, result: &result)
  return result!
}
@inlinable
public func _conditionallyBridgeFromObjectiveC<T>(
  _ x: AnyObject,
  _: T.Type
) -> T? {
  if _fastPath(_isClassOrObjCExistential(T.self)) {
    return x as? T
  }
  var result: T?
  _ = _bridgeNonVerbatimFromObjectiveCConditional(x, T.self, &result)
  return result
}
@inlinable
public func _conditionallyBridgeFromObjectiveC_bridgeable<T:_ObjectiveCBridgeable>(
  _ x: T._ObjectiveCType,
  _: T.Type
) -> T? {
  var result: T?
  T._conditionallyBridgeFromObjectiveC (x, result: &result)
  return result
}
@usableFromInline
internal func _bridgeNonVerbatimFromObjectiveC<T>(
  _ x: AnyObject,
  _ nativeType: T.Type,
  _ result: inout T?
)
internal func _bridgeNonVerbatimFromObjectiveCToAny(
    _ x: AnyObject,
    _ result: inout Any?
) {
  result = x as Any
}
internal func _bridgeNonVerbatimBoxedValue<NativeType>(
    _ x: UnsafePointer<NativeType>,
    _ result: inout NativeType?
) {
  result = x.pointee
}
public func _bridgeNonVerbatimFromObjectiveCConditional<T>(
  _ x: AnyObject,
  _ nativeType: T.Type,
  _ result: inout T?
) -> Bool
public func _isBridgedToObjectiveC<T>(_: T.Type) -> Bool {
  if _fastPath(_isClassOrObjCExistential(T.self)) {
    return true
  }
  return _isBridgedNonVerbatimToObjectiveC(T.self)
}
public func _isBridgedNonVerbatimToObjectiveC<T>(_: T.Type) -> Bool
@inlinable 
public func _isBridgedVerbatimToObjectiveC<T>(_: T.Type) -> Bool {
  return _isClassOrObjCExistential(T.self)
}
@inlinable 
public func _getBridgedObjectiveCType<T>(_: T.Type) -> Any.Type? {
  if _fastPath(_isClassOrObjCExistential(T.self)) {
    return T.self
  }
  return _getBridgedNonVerbatimObjectiveCType(T.self)
}
public func _getBridgedNonVerbatimObjectiveCType<T>(_: T.Type) -> Any.Type?
@frozen
public struct AutoreleasingUnsafeMutablePointer<Pointee >
  :  _Pointer {
  public let _rawValue: Builtin.RawPointer
  public 
  init(_ _rawValue: Builtin.RawPointer) {
    self._rawValue = _rawValue
  }
  @inlinable
  public var pointee: Pointee {
      let unmanaged =
        UnsafePointer<Optional<Unmanaged<AnyObject>>>(_rawValue).pointee
      return _unsafeReferenceCast(
        unmanaged?.takeUnretainedValue(),
        to: Pointee.self)
    }
      let object = _unsafeReferenceCast(newValue, to: Optional<AnyObject>.self)
      Builtin.retain(object)
      Builtin.autorelease(object)
      let unmanaged: Optional<Unmanaged<AnyObject>>
      if let object = object {
        unmanaged = Unmanaged.passUnretained(object)
      } else {
        unmanaged = nil
      }
      UnsafeMutablePointer<Optional<Unmanaged<AnyObject>>>(_rawValue).pointee =
        unmanaged
    }
  }
  @inlinable 
  public subscript(i: Int) -> Pointee {
    get {
      return self.advanced(by: i).pointee
    }
  }
   self._rawValue = from._rawValue
  }
   guard let unwrapped = from else { return nil }
   self.init(unwrapped)
  }
  internal init<U>(
  ) {
    self._rawValue = from._rawValue
  }
  internal init?<U>(
  ) {
    guard let unwrapped = from else { return nil }
    self.init(unwrapped)
  }
}
extension UnsafeMutableRawPointer {
  public init<T>(
  ) {
    _rawValue = other._rawValue
  }
  public init?<T>(
  ) {
    guard let unwrapped = other else { return nil }
    self.init(unwrapped)
  }
}
extension UnsafeRawPointer {
  public init<T>(
  ) {
    _rawValue = other._rawValue
  }
  public init?<T>(
  ) {
    guard let unwrapped = other else { return nil }
    self.init(unwrapped)
  }
}
extension AutoreleasingUnsafeMutablePointer { }
internal struct _CocoaFastEnumerationStackBuf {
  internal var _item0: UnsafeRawPointer?
  internal var _item1: UnsafeRawPointer?
  internal var _item2: UnsafeRawPointer?
  internal var _item3: UnsafeRawPointer?
  internal var _item4: UnsafeRawPointer?
  internal var _item5: UnsafeRawPointer?
  internal var _item6: UnsafeRawPointer?
  internal var _item7: UnsafeRawPointer?
  internal var _item8: UnsafeRawPointer?
  internal var _item9: UnsafeRawPointer?
  internal var _item10: UnsafeRawPointer?
  internal var _item11: UnsafeRawPointer?
  internal var _item12: UnsafeRawPointer?
  internal var _item13: UnsafeRawPointer?
  internal var _item14: UnsafeRawPointer?
  internal var _item15: UnsafeRawPointer?
  internal var count: Int {
    return 16
  }
  internal init() {
    _item0 = nil
    _item1 = _item0
    _item2 = _item0
    _item3 = _item0
    _item4 = _item0
    _item5 = _item0
    _item6 = _item0
    _item7 = _item0
    _item8 = _item0
    _item9 = _item0
    _item10 = _item0
    _item11 = _item0
    _item12 = _item0
    _item13 = _item0
    _item14 = _item0
    _item15 = _item0
    _internalInvariant(MemoryLayout.size(ofValue: self) >=
                   MemoryLayout<Optional<UnsafeRawPointer>>.size * count)
  }
}
public func _getObjCTypeEncoding<T>(_ type: T.Type) -> UnsafePointer<Int8> {
  return UnsafePointer(Builtin.getObjCTypeEncoding(type))
}
#endif
#if !_runtime(_ObjC)
@inlinable
public func _forceBridgeFromObjectiveC_bridgeable<T:_ObjectiveCBridgeable> (
  _ x: T._ObjectiveCType,
  _: T.Type
) -> T {
  var result: T?
  T._forceBridgeFromObjectiveC(x, result: &result)
  return result!
}
@inlinable
public func _conditionallyBridgeFromObjectiveC_bridgeable<T:_ObjectiveCBridgeable>(
  _ x: T._ObjectiveCType,
  _: T.Type
) -> T? {
  var result: T?
  T._conditionallyBridgeFromObjectiveC (x, result: &result)
  return result
}
public 
protocol _NSSwiftValue: AnyObject {
  init(_ value: Any)
  var value: Any { get }
  static var null: AnyObject { get }
}
@usableFromInline
internal class __SwiftValue {
  @usableFromInline
  let value: Any
  @usableFromInline
  init(_ value: Any) {
    self.value = value
  }
  @usableFromInline
  static let null = __SwiftValue(Optional<Any>.none as Any)
}
public func swift_unboxFromSwiftValueWithType<T>(
  _ source: inout AnyObject,
  _ result: UnsafeMutablePointer<T>
  ) -> Bool {
  if source === _nullPlaceholder {
    if let unpacked = Optional<Any>.none as? T {
      result.initialize(to: unpacked)
      return true
    }
  }
  if let box = source as? __SwiftValue {
    if let value = box.value as? T {
      result.initialize(to: value)
      return true
    }
  } else if let box = source as? _NSSwiftValue {
    if let value = box.value as? T {
      result.initialize(to: value)
      return true
    }
  }
  return false
}
public func _swiftValueConformsTo<T>(_ type: T.Type) -> Bool {
  if let foundationType = _foundationSwiftValueType {
    return foundationType is T.Type
  } else {
    return __SwiftValue.self is T.Type
  }
}
public func _extractDynamicValue<T>(_ value: T) -> AnyObject?
public func _bridgeToObjectiveCUsingProtocolIfPossible<T>(_ value: T) -> AnyObject?
internal protocol _Unwrappable {
  func _unwrap() -> Any?
}
extension Optional: _Unwrappable {
  internal func _unwrap() -> Any? {
    return self
  }
}
private let _foundationSwiftValueType = _typeByName("Foundation.__SwiftValue") as? _NSSwiftValue.Type
@usableFromInline
internal var _nullPlaceholder: AnyObject {
  if let foundationType = _foundationSwiftValueType {
    return foundationType.null
  } else {
    return __SwiftValue.null
  }
}
@usableFromInline
func _makeSwiftValue(_ value: Any) -> AnyObject {
  if let foundationType = _foundationSwiftValueType {
    return foundationType.init(value)
  } else {
    return __SwiftValue(value)
  }
}
public func _bridgeAnythingToObjectiveC<T>(_ x: T) -> AnyObject {
  var done = false
  var result: AnyObject!
  let source: Any = x
  if let dynamicSource = _extractDynamicValue(x) {
    result = dynamicSource as AnyObject
    done = true 
  }
  if !done, let wrapper = source as? _Unwrappable {
    if let value = wrapper._unwrap() {
      result = value as AnyObject
    } else {
      result = _nullPlaceholder
    }
    done = true
  }
  if !done {
    if type(of: source) as? AnyClass != nil {
      result = unsafeBitCast(x, to: AnyObject.self)
    } else if let object = _bridgeToObjectiveCUsingProtocolIfPossible(source) {
      result = object
    } else {
      result = _makeSwiftValue(source)
    }
  }
  return result
}
#endif 
