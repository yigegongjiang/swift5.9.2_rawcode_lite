import SwiftShims
@inlinable
@inline(__always)
internal func _roundUpImpl(_ offset: UInt, toAlignment alignment: Int) -> UInt {
  _internalInvariant(alignment > 0)
  _internalInvariant(_isPowerOf2(alignment))
  let x = offset + UInt(bitPattern: alignment) &- 1
  return x & ~(UInt(bitPattern: alignment) &- 1)
}
@inlinable
internal func _roundUp(_ offset: UInt, toAlignment alignment: Int) -> UInt {
  return _roundUpImpl(offset, toAlignment: alignment)
}
@inlinable
internal func _roundUp(_ offset: Int, toAlignment alignment: Int) -> Int {
  _internalInvariant(offset >= 0)
  let offset = UInt(bitPattern: offset)
  let result = Int(bitPattern: _roundUpImpl(offset, toAlignment: alignment))
  _internalInvariant(result >= 0)
  return result
}
public 
func _canBeClass<T>(_: T.Type) -> Int8 {
  return Int8(Builtin.canBeClass(T.self))
}
@inlinable 
public func unsafeBitCast<T, U>(_ x: T, to type: U.Type) -> U {
  _precondition(MemoryLayout<T>.size == MemoryLayout<U>.size,
    "Can't unsafeBitCast between types of different sizes")
  return Builtin.reinterpretCast(x)
}
public func _identityCast<T, U>(_ x: T, to expectedType: U.Type) -> U {
  _precondition(T.self == expectedType, "_identityCast to wrong type")
  return Builtin.reinterpretCast(x)
}
internal func _reinterpretCastToAnyObject<T>(_ x: T) -> AnyObject {
  return unsafeBitCast(x, to: AnyObject.self)
}
internal func == (
  lhs: Builtin.NativeObject, rhs: Builtin.NativeObject
) -> Bool {
  return unsafeBitCast(lhs, to: Int.self) == unsafeBitCast(rhs, to: Int.self)
}
internal func != (
  lhs: Builtin.NativeObject, rhs: Builtin.NativeObject
) -> Bool {
  return !(lhs == rhs)
}
internal func == (
  lhs: Builtin.RawPointer, rhs: Builtin.RawPointer
) -> Bool {
  return unsafeBitCast(lhs, to: Int.self) == unsafeBitCast(rhs, to: Int.self)
}
internal func != (lhs: Builtin.RawPointer, rhs: Builtin.RawPointer) -> Bool {
  return !(lhs == rhs)
}
public func == (t0: Any.Type?, t1: Any.Type?) -> Bool {
  switch (t0, t1) {
  case (.none, .none): return true
  case let (.some(ty0), .some(ty1)):
    return Bool(Builtin.is_same_metatype(ty0, ty1))
  default: return false
  }
}
public func != (t0: Any.Type?, t1: Any.Type?) -> Bool {
  return !(t0 == t1)
}
internal func _unreachable(_ condition: Bool = true) {
  if condition {
    Builtin.unreachable()
  }
}
internal func _conditionallyUnreachable() -> Never {
  Builtin.conditionallyUnreachable()
}
@usableFromInline
internal func _swift_isClassOrObjCExistentialType<T>(_ x: T.Type) -> Bool
@available(SwiftStdlib 5.7, *)
@usableFromInline
internal func _swift_setClassMetadata<T>(_ x: T.Type,
                                         onObject: AnyObject) -> Bool
@inlinable
@inline(__always)
internal func _isClassOrObjCExistential<T>(_ x: T.Type) -> Bool {
  switch _canBeClass(x) {
  case 0:
    return false
  case 1:
    return true
  default:
    return _swift_isClassOrObjCExistentialType(x)
  }
}
public func _unsafeReferenceCast<T, U>(_ x: T, to: U.Type) -> U {
  return Builtin.castReference(x)
}
public func unsafeDowncast<T: AnyObject>(_ x: AnyObject, to type: T.Type) -> T {
  _debugPrecondition(x is T, "invalid unsafeDowncast")
  return Builtin.castReference(x)
}
public func _unsafeUncheckedDowncast<T: AnyObject>(_ x: AnyObject, to type: T.Type) -> T {
  _internalInvariant(x is T, "invalid unsafeDowncast")
  return Builtin.castReference(x)
}
@inlinable
@inline(__always)
public func _getUnsafePointerToStoredProperties(_ x: AnyObject)
  -> UnsafeMutableRawPointer {
  let storedPropertyOffset = _roundUp(
    MemoryLayout<SwiftShims.HeapObject>.size,
    toAlignment: MemoryLayout<Optional<AnyObject>>.alignment)
  return UnsafeMutableRawPointer(Builtin.bridgeToRawPointer(x)) +
    storedPropertyOffset
}
@inlinable
@inline(__always)
internal func _minAllocationAlignment() -> Int {
  return _swift_MinAllocationAlignment
}
public func _fastPath(_ x: Bool) -> Bool {
  return Bool(Builtin.int_expect_Int1(x._value, true._value))
}
public func _slowPath(_ x: Bool) -> Bool {
  return Bool(Builtin.int_expect_Int1(x._value, false._value))
}
public func _onFastPath() {
  Builtin.onFastPath()
}
func _uncheckedUnsafeAssume(_ condition: Bool) {
  _ = Builtin.assume_Int1(condition._value)
}
#if _runtime(_ObjC)
@usableFromInline
internal func _usesNativeSwiftReferenceCounting(_ theClass: AnyClass) -> Bool
internal func _swift_classOfObjCHeapObject(_ object: AnyObject) -> AnyClass
#else
@inlinable
@inline(__always)
internal func _usesNativeSwiftReferenceCounting(_ theClass: AnyClass) -> Bool {
  return true
}
#endif
@usableFromInline
internal func getSwiftClassInstanceExtents(_ theClass: AnyClass)
  -> (negative: UInt, positive: UInt)
@usableFromInline
internal func getObjCClassInstanceExtents(_ theClass: AnyClass)
  -> (negative: UInt, positive: UInt)
@inlinable
@inline(__always)
internal func _class_getInstancePositiveExtentSize(_ theClass: AnyClass) -> Int {
#if _runtime(_ObjC)
  return Int(getObjCClassInstanceExtents(theClass).positive)
#else
  return Int(getSwiftClassInstanceExtents(theClass).positive)
#endif
}
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
@usableFromInline
internal func _swift_isImmutableCOWBuffer(_ object: AnyObject) -> Bool
@usableFromInline
internal func _swift_setImmutableCOWBuffer(_ object: AnyObject, _ immutable: Bool) -> Bool
#endif
@inlinable
internal func _isValidAddress(_ address: UInt) -> Bool {
  return address >= _swift_abi_LeastValidPointerValue
}
@inlinable
internal var _bridgeObjectTaggedPointerBits: UInt {
  @inline(__always) get { return UInt(_swift_BridgeObject_TaggedPointerBits) }
}
@inlinable
internal var _objCTaggedPointerBits: UInt {
  @inline(__always) get { return UInt(_swift_abi_ObjCReservedBitsMask) }
}
@inlinable
internal var _objectPointerSpareBits: UInt {
    @inline(__always) get {
      return UInt(_swift_abi_SwiftSpareBitsMask) & ~_bridgeObjectTaggedPointerBits
    }
}
@inlinable
internal var _objectPointerLowSpareBitShift: UInt {
    @inline(__always) get {
      _internalInvariant(_swift_abi_ObjCReservedLowBits < 2,
        "num bits now differs from num-shift-amount, new platform?")
      return UInt(_swift_abi_ObjCReservedLowBits)
    }
}
#if arch(i386) || arch(arm) || arch(wasm32) || arch(powerpc) || arch(powerpc64) || arch(
  powerpc64le) || arch(s390x) || arch(arm64_32)
@inlinable
internal var _objectPointerIsObjCBit: UInt {
    @inline(__always) get { return 0x0000_0002 }
}
#else
@inlinable
internal var _objectPointerIsObjCBit: UInt {
  @inline(__always) get { return 0x4000_0000_0000_0000 }
}
#endif
@inlinable
@inline(__always)
internal func _bitPattern(_ x: Builtin.BridgeObject) -> UInt {
  return UInt(Builtin.castBitPatternFromBridgeObject(x))
}
@inlinable
@inline(__always)
internal func _nonPointerBits(_ x: Builtin.BridgeObject) -> UInt {
  return _bitPattern(x) & _objectPointerSpareBits
}
@inlinable
@inline(__always)
internal func _isObjCTaggedPointer(_ x: AnyObject) -> Bool {
  return (Builtin.reinterpretCast(x) & _objCTaggedPointerBits) != 0
}
@inlinable
@inline(__always)
internal func _isObjCTaggedPointer(_ x: UInt) -> Bool {
  return (x & _objCTaggedPointerBits) != 0
}
@inlinable @inline(__always) public 
func _isTaggedObject(_ x: Builtin.BridgeObject) -> Bool {
  return _bitPattern(x) & _bridgeObjectTaggedPointerBits != 0
}
@inlinable @inline(__always) public 
func _isNativePointer(_ x: Builtin.BridgeObject) -> Bool {
  return (
    _bitPattern(x) & (_bridgeObjectTaggedPointerBits | _objectPointerIsObjCBit)
  ) == 0
}
@inlinable @inline(__always) public 
func _isNonTaggedObjCPointer(_ x: Builtin.BridgeObject) -> Bool {
  return !_isTaggedObject(x) && !_isNativePointer(x)
}
@inlinable
@inline(__always)
func _getNonTagBits(_ x: Builtin.BridgeObject) -> UInt {
  _internalInvariant(_isTaggedObject(x), "not tagged!")
  return (_bitPattern(x) & ~_bridgeObjectTaggedPointerBits)
    >> _objectPointerLowSpareBitShift
}
@inline(__always)
@inlinable
public func _bridgeObject(fromNative x: AnyObject) -> Builtin.BridgeObject {
  _internalInvariant(!_isObjCTaggedPointer(x))
  let object = Builtin.castToBridgeObject(x, 0._builtinWordValue)
  _internalInvariant(_isNativePointer(object))
  return object
}
@inline(__always)
@inlinable
public func _bridgeObject(
  fromNonTaggedObjC x: AnyObject
) -> Builtin.BridgeObject {
  _internalInvariant(!_isObjCTaggedPointer(x))
  let object = _makeObjCBridgeObject(x)
  _internalInvariant(_isNonTaggedObjCPointer(object))
  return object
}
@inline(__always)
@inlinable
public func _bridgeObject(fromTagged x: UInt) -> Builtin.BridgeObject {
  _internalInvariant(x & _bridgeObjectTaggedPointerBits != 0)
  let object: Builtin.BridgeObject = Builtin.valueToBridgeObject(x._value)
  _internalInvariant(_isTaggedObject(object))
  return object
}
@inline(__always)
@inlinable
public func _bridgeObject(taggingPayload x: UInt) -> Builtin.BridgeObject {
  let shifted = x &<< _objectPointerLowSpareBitShift
  _internalInvariant(x == (shifted &>> _objectPointerLowSpareBitShift),
    "out-of-range: limited bit range requires some zero top bits")
  _internalInvariant(shifted & _bridgeObjectTaggedPointerBits == 0,
    "out-of-range: post-shift use of tag bits")
  return _bridgeObject(fromTagged: shifted | _bridgeObjectTaggedPointerBits)
}
@inline(__always)
@inlinable
public func _bridgeObject(toNative x: Builtin.BridgeObject) -> AnyObject {
  _internalInvariant(_isNativePointer(x))
  return Builtin.castReferenceFromBridgeObject(x)
}
@inline(__always)
@inlinable
public func _bridgeObject(
  toNonTaggedObjC x: Builtin.BridgeObject
) -> AnyObject {
  _internalInvariant(_isNonTaggedObjCPointer(x))
  return Builtin.castReferenceFromBridgeObject(x)
}
@inline(__always)
@inlinable
public func _bridgeObject(toTagged x: Builtin.BridgeObject) -> UInt {
  _internalInvariant(_isTaggedObject(x))
  let bits = _bitPattern(x)
  _internalInvariant(bits & _bridgeObjectTaggedPointerBits != 0)
  return bits
}
@inline(__always)
@inlinable
public func _bridgeObject(toTagPayload x: Builtin.BridgeObject) -> UInt {
  return _getNonTagBits(x)
}
@inline(__always)
@inlinable
public func _bridgeObject(
  fromNativeObject x: Builtin.NativeObject
) -> Builtin.BridgeObject {
  return _bridgeObject(fromNative: _nativeObject(toNative: x))
}
@inlinable
@inline(__always)
public func _nativeObject(fromNative x: AnyObject) -> Builtin.NativeObject {
  _internalInvariant(!_isObjCTaggedPointer(x))
  let native = Builtin.unsafeCastToNativeObject(x)
  return native
}
@inlinable
@inline(__always)
public func _nativeObject(
  fromBridge x: Builtin.BridgeObject
) -> Builtin.NativeObject {
  return _nativeObject(fromNative: _bridgeObject(toNative: x))
}
@inlinable
@inline(__always)
public func _nativeObject(toNative x: Builtin.NativeObject) -> AnyObject {
  return Builtin.castFromNativeObject(x)
}
extension ManagedBufferPointer {
  @inline(__always)
  @inlinable
  public init(_nativeObject buffer: Builtin.NativeObject) {
    self._nativeBuffer = buffer
  }
}
@inlinable
@inline(__always)
internal func _makeNativeBridgeObject(
  _ nativeObject: AnyObject, _ bits: UInt
) -> Builtin.BridgeObject {
  _internalInvariant(
    (bits & _objectPointerIsObjCBit) == 0,
    "BridgeObject is treated as non-native when ObjC bit is set"
  )
  return _makeBridgeObject(nativeObject, bits)
}
@inlinable
@inline(__always)
public 
func _makeObjCBridgeObject(
  _ objCObject: AnyObject
) -> Builtin.BridgeObject {
  return _makeBridgeObject(
    objCObject,
    _isObjCTaggedPointer(objCObject) ? 0 : _objectPointerIsObjCBit)
}
@inlinable
@inline(__always)
internal func _makeBridgeObject(
  _ object: AnyObject, _ bits: UInt
) -> Builtin.BridgeObject {
  _internalInvariant(!_isObjCTaggedPointer(object) || bits == 0,
    "Tagged pointers cannot be combined with bits")
  _internalInvariant(
    _isObjCTaggedPointer(object)
    || _usesNativeSwiftReferenceCounting(type(of: object))
    || bits == _objectPointerIsObjCBit,
    "All spare bits must be set in non-native, non-tagged bridge objects"
  )
  _internalInvariant(
    bits & _objectPointerSpareBits == bits,
    "Can't store non-spare bits into Builtin.BridgeObject")
  return Builtin.castToBridgeObject(
    object, bits._builtinWordValue
  )
}
internal func _swift_class_getSuperclass(_ t: AnyClass) -> AnyClass?
public func _getSuperclass(_ t: AnyClass) -> AnyClass? {
  return _swift_class_getSuperclass(t)
}
@inlinable
@inline(__always)
public 
func _getSuperclass(_ t: Any.Type) -> AnyClass? {
  return (t as? AnyClass).flatMap { _getSuperclass($0) }
}
internal func _isUnique<T>(_ object: inout T) -> Bool {
  return Bool(Builtin.isUnique(&object))
}
public 
func _isUnique_native<T>(_ object: inout T) -> Bool {
  _internalInvariant(
    (_bitPattern(Builtin.reinterpretCast(object)) & _objectPointerSpareBits)
    == 0)
  _internalInvariant(_usesNativeSwiftReferenceCounting(
      type(of: Builtin.reinterpretCast(object) as AnyObject)))
  return Bool(Builtin.isUnique_native(&object))
}
public 
func _COWBufferForReading<T: AnyObject>(_ object: T) -> T {
  return Builtin.COWBufferForReading(object)
}
public 
func _isPOD<T>(_ type: T.Type) -> Bool {
  return Bool(Builtin.ispod(type))
}
public 
func _isConcrete<T>(_ type: T.Type) -> Bool {
  return Bool(Builtin.isConcrete(type))
}
public 
func _isBitwiseTakable<T>(_ type: T.Type) -> Bool {
  return Bool(Builtin.isbitwisetakable(type))
}
public 
func _isOptional<T>(_ type: T.Type) -> Bool {
  return Bool(Builtin.isOptional(type))
}
internal func _isComputed(_ value: Int) -> Bool {
  return !Bool(Builtin.int_is_constant_Word(value._builtinWordValue))
}
@inlinable
internal func _unsafeDowncastToAnyObject(fromAny any: Any) -> AnyObject {
  _internalInvariant(type(of: any) is AnyObject.Type
               || type(of: any) is AnyObject.Protocol,
               "Any expected to contain object reference")
  return any as AnyObject
}
@inlinable
@inline(__always)
public 
func _trueAfterDiagnostics() -> Builtin.Int1 {
  return true._value
}
public func type<T, Metatype>(of value: T) -> Metatype {
  Builtin.staticReport(_trueAfterDiagnostics(), true._value,
    ("internal consistency error: 'type(of:)' operation failed to resolve"
     as StaticString).utf8Start._rawValue)
  Builtin.unreachable()
}
public func withoutActuallyEscaping<ClosureType, ResultType>(
  _ closure: ClosureType,
  do body: (_ escapingClosure: ClosureType) throws -> ResultType
) rethrows -> ResultType {
  Builtin.staticReport(_trueAfterDiagnostics(), true._value,
    ("internal consistency error: 'withoutActuallyEscaping(_:do:)' operation failed to resolve"
     as StaticString).utf8Start._rawValue)
  Builtin.unreachable()
}
public func _openExistential<ExistentialType, ContainedType, ResultType>(
  _ existential: ExistentialType,
  do body: (_ escapingClosure: ContainedType) throws -> ResultType
) rethrows -> ResultType {
  Builtin.staticReport(_trueAfterDiagnostics(), true._value,
    ("internal consistency error: '_openExistential(_:do:)' operation failed to resolve"
     as StaticString).utf8Start._rawValue)
  Builtin.unreachable()
}
public 
func _getGlobalStringTablePointer(_ constant: String) -> UnsafePointer<CChar> {
  return UnsafePointer<CChar>(Builtin.globalStringTablePointer(constant));
}
