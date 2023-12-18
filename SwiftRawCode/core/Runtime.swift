import SwiftShims
public 
func _stdlib_atomicCompareExchangeStrongPtr(
  object target: UnsafeMutablePointer<UnsafeRawPointer?>,
  expected: UnsafeMutablePointer<UnsafeRawPointer?>,
  desired: UnsafeRawPointer?
) -> Bool {
  let (oldValue, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
    target._rawValue,
    UInt(bitPattern: expected.pointee)._builtinWordValue,
    UInt(bitPattern: desired)._builtinWordValue)
  expected.pointee = UnsafeRawPointer(bitPattern: Int(oldValue))
  return Bool(won)
}
public 
func _stdlib_atomicCompareExchangeStrongPtr<T>(
  object target: UnsafeMutablePointer<UnsafeMutablePointer<T>>,
  expected: UnsafeMutablePointer<UnsafeMutablePointer<T>>,
  desired: UnsafeMutablePointer<T>
) -> Bool {
  let rawTarget = UnsafeMutableRawPointer(target).assumingMemoryBound(
    to: Optional<UnsafeRawPointer>.self)
  let rawExpected = UnsafeMutableRawPointer(expected).assumingMemoryBound(
    to: Optional<UnsafeRawPointer>.self)
  return _stdlib_atomicCompareExchangeStrongPtr(
    object: rawTarget,
    expected: rawExpected,
    desired: UnsafeRawPointer(desired))
}
public 
func _stdlib_atomicCompareExchangeStrongPtr<T>(
  object target: UnsafeMutablePointer<UnsafeMutablePointer<T>?>,
  expected: UnsafeMutablePointer<UnsafeMutablePointer<T>?>,
  desired: UnsafeMutablePointer<T>?
) -> Bool {
  let rawTarget = UnsafeMutableRawPointer(target).assumingMemoryBound(
    to: Optional<UnsafeRawPointer>.self)
  let rawExpected = UnsafeMutableRawPointer(expected).assumingMemoryBound(
    to: Optional<UnsafeRawPointer>.self)
  return _stdlib_atomicCompareExchangeStrongPtr(
    object: rawTarget,
    expected: rawExpected,
    desired: UnsafeRawPointer(desired))
}
@discardableResult
public 
func _stdlib_atomicInitializeARCRef(
  object target: UnsafeMutablePointer<AnyObject?>,
  desired: AnyObject
) -> Bool {
  var expected: UnsafeRawPointer?
  let unmanaged = Unmanaged.passRetained(desired)
  let desiredPtr = unmanaged.toOpaque()
  let rawTarget = UnsafeMutableRawPointer(target).assumingMemoryBound(
    to: Optional<UnsafeRawPointer>.self)
  let wonRace = _stdlib_atomicCompareExchangeStrongPtr(
    object: rawTarget, expected: &expected, desired: desiredPtr)
  if !wonRace {
    unmanaged.release()
  }
  return wonRace
}
public 
func _stdlib_atomicLoadARCRef(
  object target: UnsafeMutablePointer<AnyObject?>
) -> AnyObject? {
  let value = Builtin.atomicload_seqcst_Word(target._rawValue)
  if let unwrapped = UnsafeRawPointer(bitPattern: Int(value)) {
    return Unmanaged<AnyObject>.fromOpaque(unwrapped).takeUnretainedValue()
  }
  return nil
}
@discardableResult
public func _stdlib_atomicAcquiringInitializeARCRef<T: AnyObject>(
  object target: UnsafeMutablePointer<T?>,
  desired: __owned T
) -> Unmanaged<T> {
  let unmanaged = Unmanaged.passRetained(desired)
  let desiredPtr = unmanaged.toOpaque()
  let (value, won) = Builtin.cmpxchg_acqrel_acquire_Word(
    target._rawValue,
    0._builtinWordValue,
    Builtin.ptrtoint_Word(desiredPtr._rawValue))
  if Bool(won) { return unmanaged }
  unmanaged.release()
  let ptr = UnsafeRawPointer(Builtin.inttoptr_Word(value))
  return Unmanaged<T>.fromOpaque(ptr)
}
public func _stdlib_atomicAcquiringLoadARCRef<T: AnyObject>(
  object target: UnsafeMutablePointer<T?>
) -> Unmanaged<T>? {
  let value = Builtin.atomicload_acquire_Word(target._rawValue)
  if Int(value) == 0 { return nil }
  let opaque = UnsafeRawPointer(Builtin.inttoptr_Word(value))
  return Unmanaged<T>.fromOpaque(opaque)
}
internal struct _Buffer32 {
  internal var _x0: UInt8 = 0
  internal var _x1: UInt8 = 0
  internal var _x2: UInt8 = 0
  internal var _x3: UInt8 = 0
  internal var _x4: UInt8 = 0
  internal var _x5: UInt8 = 0
  internal var _x6: UInt8 = 0
  internal var _x7: UInt8 = 0
  internal var _x8: UInt8 = 0
  internal var _x9: UInt8 = 0
  internal var _x10: UInt8 = 0
  internal var _x11: UInt8 = 0
  internal var _x12: UInt8 = 0
  internal var _x13: UInt8 = 0
  internal var _x14: UInt8 = 0
  internal var _x15: UInt8 = 0
  internal var _x16: UInt8 = 0
  internal var _x17: UInt8 = 0
  internal var _x18: UInt8 = 0
  internal var _x19: UInt8 = 0
  internal var _x20: UInt8 = 0
  internal var _x21: UInt8 = 0
  internal var _x22: UInt8 = 0
  internal var _x23: UInt8 = 0
  internal var _x24: UInt8 = 0
  internal var _x25: UInt8 = 0
  internal var _x26: UInt8 = 0
  internal var _x27: UInt8 = 0
  internal var _x28: UInt8 = 0
  internal var _x29: UInt8 = 0
  internal var _x30: UInt8 = 0
  internal var _x31: UInt8 = 0
  internal init() {}
  internal mutating func withBytes<Result>(
    _ body: (UnsafeMutablePointer<UInt8>) throws -> Result
  ) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &self) {
      try body(UnsafeMutableRawPointer($0).assumingMemoryBound(to: UInt8.self))
    }
  }
}
internal struct _Buffer72 {
  internal var _x0: UInt8 = 0
  internal var _x1: UInt8 = 0
  internal var _x2: UInt8 = 0
  internal var _x3: UInt8 = 0
  internal var _x4: UInt8 = 0
  internal var _x5: UInt8 = 0
  internal var _x6: UInt8 = 0
  internal var _x7: UInt8 = 0
  internal var _x8: UInt8 = 0
  internal var _x9: UInt8 = 0
  internal var _x10: UInt8 = 0
  internal var _x11: UInt8 = 0
  internal var _x12: UInt8 = 0
  internal var _x13: UInt8 = 0
  internal var _x14: UInt8 = 0
  internal var _x15: UInt8 = 0
  internal var _x16: UInt8 = 0
  internal var _x17: UInt8 = 0
  internal var _x18: UInt8 = 0
  internal var _x19: UInt8 = 0
  internal var _x20: UInt8 = 0
  internal var _x21: UInt8 = 0
  internal var _x22: UInt8 = 0
  internal var _x23: UInt8 = 0
  internal var _x24: UInt8 = 0
  internal var _x25: UInt8 = 0
  internal var _x26: UInt8 = 0
  internal var _x27: UInt8 = 0
  internal var _x28: UInt8 = 0
  internal var _x29: UInt8 = 0
  internal var _x30: UInt8 = 0
  internal var _x31: UInt8 = 0
  internal var _x32: UInt8 = 0
  internal var _x33: UInt8 = 0
  internal var _x34: UInt8 = 0
  internal var _x35: UInt8 = 0
  internal var _x36: UInt8 = 0
  internal var _x37: UInt8 = 0
  internal var _x38: UInt8 = 0
  internal var _x39: UInt8 = 0
  internal var _x40: UInt8 = 0
  internal var _x41: UInt8 = 0
  internal var _x42: UInt8 = 0
  internal var _x43: UInt8 = 0
  internal var _x44: UInt8 = 0
  internal var _x45: UInt8 = 0
  internal var _x46: UInt8 = 0
  internal var _x47: UInt8 = 0
  internal var _x48: UInt8 = 0
  internal var _x49: UInt8 = 0
  internal var _x50: UInt8 = 0
  internal var _x51: UInt8 = 0
  internal var _x52: UInt8 = 0
  internal var _x53: UInt8 = 0
  internal var _x54: UInt8 = 0
  internal var _x55: UInt8 = 0
  internal var _x56: UInt8 = 0
  internal var _x57: UInt8 = 0
  internal var _x58: UInt8 = 0
  internal var _x59: UInt8 = 0
  internal var _x60: UInt8 = 0
  internal var _x61: UInt8 = 0
  internal var _x62: UInt8 = 0
  internal var _x63: UInt8 = 0
  internal var _x64: UInt8 = 0
  internal var _x65: UInt8 = 0
  internal var _x66: UInt8 = 0
  internal var _x67: UInt8 = 0
  internal var _x68: UInt8 = 0
  internal var _x69: UInt8 = 0
  internal var _x70: UInt8 = 0
  internal var _x71: UInt8 = 0
  internal init() {}
  internal mutating func withBytes<Result>(
    _ body: (UnsafeMutablePointer<UInt8>) throws -> Result
  ) rethrows -> Result {
    return try withUnsafeMutablePointer(to: &self) {
      try body(UnsafeMutableRawPointer($0).assumingMemoryBound(to: UInt8.self))
    }
  }
}
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
internal func _float16ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: Float32,
  _ debug: Bool
) -> Int
@available(SwiftStdlib 5.3, *)
internal func _float16ToString(
  _ value: Float16,
  debug: Bool
) -> (buffer: _Buffer32, length: Int) {
  _internalInvariant(MemoryLayout<_Buffer32>.size == 32)
  var buffer = _Buffer32()
  let length = buffer.withBytes { (bufferPtr) in
    _float16ToStringImpl(bufferPtr, 32, Float(value), debug)
  }
  return (buffer, length)
}
#endif
internal func _float32ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: Float32,
  _ debug: Bool
) -> UInt64
internal func _float32ToString(
  _ value: Float32,
  debug: Bool
) -> (buffer: _Buffer32, length: Int) {
  _internalInvariant(MemoryLayout<_Buffer32>.size == 32)
  var buffer = _Buffer32()
  let length = buffer.withBytes { (bufferPtr) in Int(
    truncatingIfNeeded: _float32ToStringImpl(bufferPtr, 32, value, debug)
  )}
  return (buffer, length)
}
internal func _float64ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: Float64,
  _ debug: Bool
) -> UInt64
internal func _float64ToString(
  _ value: Float64,
  debug: Bool
) -> (buffer: _Buffer32, length: Int) {
  _internalInvariant(MemoryLayout<_Buffer32>.size == 32)
  var buffer = _Buffer32()
  let length = buffer.withBytes { (bufferPtr) in Int(
    truncatingIfNeeded: _float64ToStringImpl(bufferPtr, 32, value, debug)
  )}
  return (buffer, length)
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
internal func _float80ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: Float80,
  _ debug: Bool
) -> UInt64
internal func _float80ToString(
  _ value: Float80,
  debug: Bool
) -> (buffer: _Buffer32, length: Int) {
  _internalInvariant(MemoryLayout<_Buffer32>.size == 32)
  var buffer = _Buffer32()
  let length = buffer.withBytes { (bufferPtr) in Int(
    truncatingIfNeeded: _float80ToStringImpl(bufferPtr, 32, value, debug)
  )}
  return (buffer, length)
}
#endif
internal func _int64ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: Int64,
  _ radix: Int64,
  _ uppercase: Bool
) -> UInt64
internal func _int64ToString(
  _ value: Int64,
  radix: Int64 = 10,
  uppercase: Bool = false
) -> String {
  if radix >= 10 {
    var buffer = _Buffer32()
    return buffer.withBytes { (bufferPtr) in
      let actualLength = _int64ToStringImpl(bufferPtr, 32, value, radix, uppercase)
      return String._fromASCII(UnsafeBufferPointer(
        start: bufferPtr, count: Int(truncatingIfNeeded: actualLength)
      ))
    }
  } else {
    var buffer = _Buffer72()
    return buffer.withBytes { (bufferPtr) in
      let actualLength = _int64ToStringImpl(bufferPtr, 72, value, radix, uppercase)
      return String._fromASCII(UnsafeBufferPointer(
        start: bufferPtr, count: Int(truncatingIfNeeded: actualLength)
      ))
    }
  }
}
internal func _uint64ToStringImpl(
  _ buffer: UnsafeMutablePointer<UTF8.CodeUnit>,
  _ bufferLength: UInt,
  _ value: UInt64,
  _ radix: Int64,
  _ uppercase: Bool
) -> UInt64
public 
func _uint64ToString(
    _ value: UInt64,
    radix: Int64 = 10,
    uppercase: Bool = false
) -> String {
  if radix >= 10 {
    var buffer = _Buffer32()
    return buffer.withBytes { (bufferPtr) in
      let actualLength = _uint64ToStringImpl(bufferPtr, 32, value, radix, uppercase)
      return String._fromASCII(UnsafeBufferPointer(
        start: bufferPtr, count: Int(truncatingIfNeeded: actualLength)
      ))
    }
  } else {
    var buffer = _Buffer72()
    return buffer.withBytes { (bufferPtr) in
      let actualLength = _uint64ToStringImpl(bufferPtr, 72, value, radix, uppercase)
      return String._fromASCII(UnsafeBufferPointer(
        start: bufferPtr, count: Int(truncatingIfNeeded: actualLength)
      ))
    }
  }
}
@inlinable
internal func _rawPointerToString(_ value: Builtin.RawPointer) -> String {
  var result = _uint64ToString(
    UInt64(
      UInt(bitPattern: UnsafeRawPointer(value))),
      radix: 16,
      uppercase: false
    )
  for _ in 0..<(2 * MemoryLayout<UnsafeRawPointer>.size - result.utf16.count) {
    result = "0" + result
  }
  return "0x" + result
}
#if _runtime(_ObjC)
@usableFromInline
internal class __SwiftNativeNSArray {
  @inlinable
  @nonobjc
  internal init() {}
  @inlinable
  deinit {}
}
@usableFromInline
internal class _SwiftNativeNSMutableArray {
  @inlinable
  @nonobjc
  internal init() {}
  @inlinable
  deinit {}
}
@usableFromInline
internal class __SwiftNativeNSDictionary {
  @nonobjc
  internal init() {}
  @objc public init(coder: AnyObject) {}
  deinit {}
}
@usableFromInline
internal class __SwiftNativeNSSet {
  @nonobjc
  internal init() {}
  @objc public init(coder: AnyObject) {}
  deinit {}
}
@objc
internal class __SwiftNativeNSEnumerator {
  @nonobjc
  internal init() {}
  @objc public init(coder: AnyObject) {}
  deinit {}
}
@objc
internal class __stdlib_ReturnAutoreleasedDummy {
  @objc
  internal init() {}
  @objc
  internal dynamic func returnsAutoreleased(_ x: AnyObject) -> AnyObject {
    return x
  }
}
public func _stdlib_initializeReturnAutoreleased() {
#if arch(x86_64)
  let dummy = __stdlib_ReturnAutoreleasedDummy()
  _ = dummy.returnsAutoreleased(dummy)
#endif
}
#else
@usableFromInline
internal class __SwiftNativeNSArray {
  @inlinable
  internal init() {}
  @inlinable
  deinit {}
}
@usableFromInline
internal class __SwiftNativeNSDictionary {
  @inlinable
  internal init() {}
  @inlinable
  deinit {}
}
@usableFromInline
internal class __SwiftNativeNSSet {
  @inlinable
  internal init() {}
  @inlinable
  deinit {}
}
#endif
