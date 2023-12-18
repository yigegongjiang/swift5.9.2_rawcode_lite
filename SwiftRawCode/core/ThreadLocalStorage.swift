import SwiftShims
#if INTERNAL_CHECKS_ENABLED
internal class _TLSAtomicInt {
  internal var value: Int
  internal init() { self.value = 0 }
  internal var valuePtr: UnsafeMutablePointer<Int> {
    return _getUnsafePointerToStoredProperties(self).assumingMemoryBound(
      to: Int.self)
  }
  internal func increment() {
    _ = _swift_stdlib_atomicFetchAddInt(
      object: valuePtr,
      operand: 1)
  }
  internal func load() -> Int {
    return _swift_stdlib_atomicLoadInt(object: valuePtr)
  }
}
internal let _destroyTLSCounter = _TLSAtomicInt()
public 
func _loadDestroyTLSCounter() -> Int {
  return _destroyTLSCounter.load()
}
#endif
internal struct _ThreadLocalStorage {
  internal init() {}
  internal static func getPointer()
    -> UnsafeMutablePointer<_ThreadLocalStorage>
  {
    return _swift_stdlib_threadLocalStorageGet().assumingMemoryBound(
      to: _ThreadLocalStorage.self)
  }
}
internal func _destroyTLS(_ ptr: UnsafeMutableRawPointer?) {
  _internalInvariant(ptr != nil,
    "_destroyTLS was called, but with nil...")
  let tlsPtr = ptr!.assumingMemoryBound(to: _ThreadLocalStorage.self)
  tlsPtr.deinitialize(count: 1)
  tlsPtr.deallocate()
#if INTERNAL_CHECKS_ENABLED
  _destroyTLSCounter.increment()
#endif
}
internal func _createThreadLocalStorage()
  -> UnsafeMutablePointer<_ThreadLocalStorage>
{
  let tlsPtr: UnsafeMutablePointer<_ThreadLocalStorage>
    = UnsafeMutablePointer<_ThreadLocalStorage>.allocate(
      capacity: 1
  )
  tlsPtr.initialize(to: _ThreadLocalStorage())
  return tlsPtr
}
