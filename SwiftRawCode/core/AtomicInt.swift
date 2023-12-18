@available(swift, deprecated: 4.2, obsoleted: 5.0)
public final class _stdlib_AtomicInt {
  internal var _value: Int
  internal var _valuePtr: UnsafeMutablePointer<Int> {
    return _getUnsafePointerToStoredProperties(self).assumingMemoryBound(
      to: Int.self)
  }
  public init(_ value: Int = 0) {
    _value = value
  }
  public func store(_ desired: Int) {
    return _swift_stdlib_atomicStoreInt(object: _valuePtr, desired: desired)
  }
  public func load() -> Int {
    return _swift_stdlib_atomicLoadInt(object: _valuePtr)
  }
  @discardableResult
  public func fetchAndAdd(_ operand: Int) -> Int {
    return _swift_stdlib_atomicFetchAddInt(
      object: _valuePtr,
      operand: operand)
  }
  public func addAndFetch(_ operand: Int) -> Int {
    return fetchAndAdd(operand) + operand
  }
  @discardableResult
  public func fetchAndAnd(_ operand: Int) -> Int {
    return _swift_stdlib_atomicFetchAndInt(
      object: _valuePtr,
      operand: operand)
  }
  public func andAndFetch(_ operand: Int) -> Int {
    return fetchAndAnd(operand) & operand
  }
  @discardableResult
  public func fetchAndOr(_ operand: Int) -> Int {
    return _swift_stdlib_atomicFetchOrInt(
      object: _valuePtr,
      operand: operand)
  }
  public func orAndFetch(_ operand: Int) -> Int {
    return fetchAndOr(operand) | operand
  }
  @discardableResult
  public func fetchAndXor(_ operand: Int) -> Int {
    return _swift_stdlib_atomicFetchXorInt(
      object: _valuePtr,
      operand: operand)
  }
  public func xorAndFetch(_ operand: Int) -> Int {
    return fetchAndXor(operand) ^ operand
  }
  public func compareExchange(expected: inout Int, desired: Int) -> Bool {
    var expectedVar = expected
    let result = _swift_stdlib_atomicCompareExchangeStrongInt(
      object: _valuePtr,
      expected: &expectedVar,
      desired: desired)
    expected = expectedVar
    return result
  }
}
@usableFromInline 
internal func _swift_stdlib_atomicCompareExchangeStrongInt(
  object target: UnsafeMutablePointer<Int>,
  expected: UnsafeMutablePointer<Int>,
  desired: Int) -> Bool {
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let (oldValue, won) = Builtin.cmpxchg_seqcst_seqcst_Int32(
    target._rawValue, expected.pointee._value, desired._value)
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let (oldValue, won) = Builtin.cmpxchg_seqcst_seqcst_Int64(
    target._rawValue, expected.pointee._value, desired._value)
#endif
  expected.pointee._value = oldValue
  return Bool(won)
}
public 
func _swift_stdlib_atomicLoadInt(
  object target: UnsafeMutablePointer<Int>) -> Int {
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let value = Builtin.atomicload_seqcst_Int32(target._rawValue)
  return Int(value)
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let value = Builtin.atomicload_seqcst_Int64(target._rawValue)
  return Int(value)
#endif
}
@usableFromInline 
internal func _swift_stdlib_atomicStoreInt(
  object target: UnsafeMutablePointer<Int>,
  desired: Int) {
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  Builtin.atomicstore_seqcst_Int32(target._rawValue, desired._value)
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  Builtin.atomicstore_seqcst_Int64(target._rawValue, desired._value)
#endif
}
public 
func _swift_stdlib_atomicFetchAddInt(
  object target: UnsafeMutablePointer<Int>,
  operand: Int) -> Int {
  let rawTarget = UnsafeMutableRawPointer(target)
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let value = _swift_stdlib_atomicFetchAddInt32(
    object: rawTarget.assumingMemoryBound(to: Int32.self),
    operand: Int32(operand))
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let value = _swift_stdlib_atomicFetchAddInt64(
    object: rawTarget.assumingMemoryBound(to: Int64.self),
    operand: Int64(operand))
#endif
  return Int(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchAddInt32(
  object target: UnsafeMutablePointer<Int32>,
  operand: Int32) -> Int32 {
  let value = Builtin.atomicrmw_add_seqcst_Int32(
    target._rawValue, operand._value)
  return Int32(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchAddInt64(
  object target: UnsafeMutablePointer<Int64>,
  operand: Int64) -> Int64 {
  let value = Builtin.atomicrmw_add_seqcst_Int64(
    target._rawValue, operand._value)
  return Int64(value)
}
public 
func _swift_stdlib_atomicFetchAndInt(
  object target: UnsafeMutablePointer<Int>,
  operand: Int) -> Int {
  let rawTarget = UnsafeMutableRawPointer(target)
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let value = _swift_stdlib_atomicFetchAndInt32(
    object: rawTarget.assumingMemoryBound(to: Int32.self),
    operand: Int32(operand))
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let value = _swift_stdlib_atomicFetchAndInt64(
    object: rawTarget.assumingMemoryBound(to: Int64.self),
    operand: Int64(operand))
#endif
  return Int(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchAndInt32(
  object target: UnsafeMutablePointer<Int32>,
  operand: Int32) -> Int32 {
  let value = Builtin.atomicrmw_and_seqcst_Int32(
    target._rawValue, operand._value)
  return Int32(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchAndInt64(
  object target: UnsafeMutablePointer<Int64>,
  operand: Int64) -> Int64 {
  let value = Builtin.atomicrmw_and_seqcst_Int64(
    target._rawValue, operand._value)
  return Int64(value)
}
public 
func _swift_stdlib_atomicFetchOrInt(
  object target: UnsafeMutablePointer<Int>,
  operand: Int) -> Int {
  let rawTarget = UnsafeMutableRawPointer(target)
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let value = _swift_stdlib_atomicFetchOrInt32(
    object: rawTarget.assumingMemoryBound(to: Int32.self),
    operand: Int32(operand))
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let value = _swift_stdlib_atomicFetchOrInt64(
    object: rawTarget.assumingMemoryBound(to: Int64.self),
    operand: Int64(operand))
#endif
  return Int(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchOrInt32(
  object target: UnsafeMutablePointer<Int32>,
  operand: Int32) -> Int32 {
  let value = Builtin.atomicrmw_or_seqcst_Int32(
    target._rawValue, operand._value)
  return Int32(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchOrInt64(
  object target: UnsafeMutablePointer<Int64>,
  operand: Int64) -> Int64 {
  let value = Builtin.atomicrmw_or_seqcst_Int64(
    target._rawValue, operand._value)
  return Int64(value)
}
public 
func _swift_stdlib_atomicFetchXorInt(
  object target: UnsafeMutablePointer<Int>,
  operand: Int) -> Int {
  let rawTarget = UnsafeMutableRawPointer(target)
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32) || arch(powerpc)
  let value = _swift_stdlib_atomicFetchXorInt32(
    object: rawTarget.assumingMemoryBound(to: Int32.self),
    operand: Int32(operand))
#elseif arch(x86_64) || arch(arm64) || arch(powerpc64) || arch(powerpc64le) || arch(s390x) || arch(riscv64)
  let value = _swift_stdlib_atomicFetchXorInt64(
    object: rawTarget.assumingMemoryBound(to: Int64.self),
    operand: Int64(operand))
#endif
  return Int(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchXorInt32(
  object target: UnsafeMutablePointer<Int32>,
  operand: Int32) -> Int32 {
  let value = Builtin.atomicrmw_xor_seqcst_Int32(
    target._rawValue, operand._value)
  return Int32(value)
}
@usableFromInline 
internal func _swift_stdlib_atomicFetchXorInt64(
  object target: UnsafeMutablePointer<Int64>,
  operand: Int64) -> Int64 {
  let value = Builtin.atomicrmw_xor_seqcst_Int64(
    target._rawValue, operand._value)
  return Int64(value)
}
