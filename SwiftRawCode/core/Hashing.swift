import SwiftShims
internal var _hashContainerDefaultMaxLoadFactorInverse: Double {
  return 1.0 / 0.75
}
#if _runtime(_ObjC)
internal func _stdlib_NSObject_isEqual(_ lhs: AnyObject, _ rhs: AnyObject) -> Bool
#endif
internal struct _UnmanagedAnyObjectArray {
  internal var value: UnsafeMutableRawPointer
  internal init(_ up: UnsafeMutablePointer<AnyObject>) {
    self.value = UnsafeMutableRawPointer(up)
  }
  internal init?(_ up: UnsafeMutablePointer<AnyObject>?) {
    guard let unwrapped = up else { return nil }
    self.init(unwrapped)
  }
  internal subscript(i: Int) -> AnyObject {
    get {
      let unmanaged = value.load(
        fromByteOffset: i * MemoryLayout<AnyObject>.stride,
        as: Unmanaged<AnyObject>.self)
      return unmanaged.takeUnretainedValue()
    }
    nonmutating set(newValue) {
      let unmanaged = Unmanaged.passUnretained(newValue)
      value.storeBytes(of: unmanaged,
        toByteOffset: i * MemoryLayout<AnyObject>.stride,
        as: Unmanaged<AnyObject>.self)
    }
  }
}
#if _runtime(_ObjC)
final internal class __SwiftEmptyNSEnumerator
  : __SwiftNativeNSEnumerator, _NSEnumerator {
  internal override required init() {
    super.init()
    _internalInvariant(_orphanedFoundationSubclassesReparented)
  }
  @objc
  internal func nextObject() -> AnyObject? {
    return nil
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>,
    count: Int
  ) -> Int {
    var theState = state.pointee
    if theState.state == 0 {
      theState.state = 1 
      theState.itemsPtr = AutoreleasingUnsafeMutablePointer(objects)
      theState.mutationsPtr = _fastEnumerationStorageMutationsPtr
    }
    state.pointee = theState
    return 0
  }
}
#endif
#if _runtime(_ObjC)
internal final class __BridgingHashBuffer
  : ManagedBuffer<__BridgingHashBuffer.Header, AnyObject> {
  struct Header {
    internal var owner: AnyObject
    internal var hashTable: _HashTable
    init(owner: AnyObject, hashTable: _HashTable) {
      self.owner = owner
      self.hashTable = hashTable
    }
  }
  internal static func allocate(
    owner: AnyObject,
    hashTable: _HashTable
  ) -> __BridgingHashBuffer {
    let buffer = self.create(minimumCapacity: hashTable.bucketCount) { _ in
      Header(owner: owner, hashTable: hashTable)
    }
    return unsafeDowncast(buffer, to: __BridgingHashBuffer.self)
  }
  deinit {
    for bucket in header.hashTable {
      (firstElementAddress + bucket.offset).deinitialize(count: 1)
    }
    _fixLifetime(self)
  }
  internal subscript(bucket: _HashTable.Bucket) -> AnyObject {
    @inline(__always) get {
      _internalInvariant(header.hashTable.isOccupied(bucket))
      defer { _fixLifetime(self) }
      return firstElementAddress[bucket.offset]
    }
  }
  @inline(__always)
  internal func initialize(at bucket: _HashTable.Bucket, to object: AnyObject) {
    _internalInvariant(header.hashTable.isOccupied(bucket))
    (firstElementAddress + bucket.offset).initialize(to: object)
    _fixLifetime(self)
  }
}
#endif
