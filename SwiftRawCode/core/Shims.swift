import SwiftShims
#if _runtime(_ObjC)
@inlinable
internal func _makeSwiftNSFastEnumerationState()
   -> _SwiftNSFastEnumerationState {
  return _SwiftNSFastEnumerationState(
    state: 0, itemsPtr: nil, mutationsPtr: nil,
    extra: (0, 0, 0, 0, 0))
}
@usableFromInline
internal var _fastEnumerationStorageMutationsTarget: CUnsignedLong = 0
@usableFromInline
internal let _fastEnumerationStorageMutationsPtr =
  UnsafeMutablePointer<CUnsignedLong>(Builtin.addressof(&_fastEnumerationStorageMutationsTarget))
#endif
internal func _mallocSize(ofAllocation ptr: UnsafeRawPointer) -> Int? {
  return _swift_stdlib_has_malloc_size() ? _swift_stdlib_malloc_size(ptr) : nil
}
