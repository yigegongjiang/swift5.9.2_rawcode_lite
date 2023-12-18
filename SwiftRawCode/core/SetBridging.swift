#if _runtime(_ObjC)
import SwiftShims
internal func _stdlib_NSSet_allObjects(_ object: AnyObject) -> _BridgingBuffer {
  let nss = unsafeBitCast(object, to: _NSSet.self)
  let count = nss.count
  let storage = _BridgingBuffer(count)
  nss.getObjects(storage.baseAddress)
  return storage
}
extension _NativeSet { 
  @usableFromInline
  internal __consuming func bridged() -> AnyObject {
    _connectOrphanedFoundationSubclassesIfNeeded()
    let nsSet: _NSSetCore
    if _storage === __RawSetStorage.empty || count == 0 {
      nsSet = __RawSetStorage.empty
    } else if _isBridgedVerbatimToObjectiveC(Element.self) {
      nsSet = unsafeDowncast(_storage, to: _SetStorage<Element>.self)
    } else {
      nsSet = _SwiftDeferredNSSet(self)
    }
    return nsSet
  }
}
final internal class _SwiftSetNSEnumerator<Element: Hashable>
  : __SwiftNativeNSEnumerator, _NSEnumerator {
  @nonobjc internal var base: _NativeSet<Element>
  @nonobjc internal var bridgedElements: __BridgingHashBuffer?
  @nonobjc internal var nextBucket: _NativeSet<Element>.Bucket
  @nonobjc internal var endBucket: _NativeSet<Element>.Bucket
  @objc
  internal override required init() {
    _internalInvariantFailure("don't call this designated initializer")
  }
  internal init(_ base: __owned _NativeSet<Element>) {
    _internalInvariant(_isBridgedVerbatimToObjectiveC(Element.self))
    _internalInvariant(_orphanedFoundationSubclassesReparented)
    self.base = base
    self.bridgedElements = nil
    self.nextBucket = base.hashTable.startBucket
    self.endBucket = base.hashTable.endBucket
    super.init()
  }
  @nonobjc
  internal init(_ deferred: __owned _SwiftDeferredNSSet<Element>) {
    _internalInvariant(!_isBridgedVerbatimToObjectiveC(Element.self))
    _internalInvariant(_orphanedFoundationSubclassesReparented)
    self.base = deferred.native
    self.bridgedElements = deferred.bridgeElements()
    self.nextBucket = base.hashTable.startBucket
    self.endBucket = base.hashTable.endBucket
    super.init()
  }
  private func bridgedElement(at bucket: _HashTable.Bucket) -> AnyObject {
    _internalInvariant(base.hashTable.isOccupied(bucket))
    if let bridgedElements = self.bridgedElements {
      return bridgedElements[bucket]
    }
    return _bridgeAnythingToObjectiveC(base.uncheckedElement(at: bucket))
  }
  @objc
  internal func nextObject() -> AnyObject? {
    if nextBucket == endBucket {
      return nil
    }
    let bucket = nextBucket
    nextBucket = base.hashTable.occupiedBucket(after: nextBucket)
    return self.bridgedElement(at: bucket)
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
    if nextBucket == endBucket {
      state.pointee = theState
      return 0
    }
    let unmanagedObjects = _UnmanagedAnyObjectArray(objects)
    unmanagedObjects[0] = self.bridgedElement(at: nextBucket)
    nextBucket = base.hashTable.occupiedBucket(after: nextBucket)
    state.pointee = theState
    return 1
  }
}
final internal class _SwiftDeferredNSSet<Element: Hashable>
  : __SwiftNativeNSSet, _NSSetCore {
  @nonobjc
  private var _bridgedElements_DoNotUse: AnyObject?
  internal var native: _NativeSet<Element>
  internal init(_ native: __owned _NativeSet<Element>) {
    _internalInvariant(native.count > 0)
    _internalInvariant(!_isBridgedVerbatimToObjectiveC(Element.self))
    self.native = native
    super.init()
  }
  @nonobjc
  private var _bridgedElementsPtr: UnsafeMutablePointer<AnyObject?> {
    return _getUnsafePointerToStoredProperties(self)
      .assumingMemoryBound(to: Optional<AnyObject>.self)
  }
  @nonobjc
  private var _bridgedElements: __BridgingHashBuffer? {
    guard let ref = _stdlib_atomicLoadARCRef(object: _bridgedElementsPtr) else {
      return nil
    }
    return unsafeDowncast(ref, to: __BridgingHashBuffer.self)
  }
  @nonobjc
  private func _initializeBridgedElements(_ storage: __BridgingHashBuffer) {
    _stdlib_atomicInitializeARCRef(
      object: _bridgedElementsPtr,
      desired: storage)
  }
  @nonobjc
  internal func bridgeElements() -> __BridgingHashBuffer {
    if let bridgedElements = _bridgedElements { return bridgedElements }
    let bridged = __BridgingHashBuffer.allocate(
      owner: native._storage,
      hashTable: native.hashTable)
    for bucket in native.hashTable {
      let object = _bridgeAnythingToObjectiveC(
        native.uncheckedElement(at: bucket))
      bridged.initialize(at: bucket, to: object)
    }
    _initializeBridgedElements(bridged)
    return _bridgedElements!
  }
  @objc
  internal required init(objects: UnsafePointer<AnyObject?>, count: Int) {
    _internalInvariantFailure("don't call this designated initializer")
  }
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @objc(member:)
  internal func member(_ object: AnyObject) -> AnyObject? {
    guard let element = _conditionallyBridgeFromObjectiveC(object, Element.self)
    else { return nil }
    let (bucket, found) = native.find(element)
    guard found else { return nil }
    let bridged = bridgeElements()
    return bridged[bucket]
  }
  @objc
  internal func objectEnumerator() -> _NSEnumerator {
    return _SwiftSetNSEnumerator<Element>(self)
  }
  @objc
  internal var count: Int {
    return native.count
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?,
    count: Int
  ) -> Int {
    defer { _fixLifetime(self) }
    let hashTable = native.hashTable
    var theState = state.pointee
    if theState.state == 0 {
      theState.state = 1 
      theState.itemsPtr = AutoreleasingUnsafeMutablePointer(objects)
      theState.mutationsPtr = _fastEnumerationStorageMutationsPtr
      theState.extra.0 = CUnsignedLong(hashTable.startBucket.offset)
    }
    if _slowPath(objects == nil) {
      return 0
    }
    let unmanagedObjects = _UnmanagedAnyObjectArray(objects!)
    var bucket = _HashTable.Bucket(offset: Int(theState.extra.0))
    let endBucket = hashTable.endBucket
    _precondition(bucket == endBucket || hashTable.isOccupied(bucket),
      "Invalid fast enumeration state")
    let bridgedElements = bridgeElements()
    var stored = 0
    for i in 0..<count {
      if bucket == endBucket { break }
      unmanagedObjects[i] = bridgedElements[bucket]
      stored += 1
      bucket = hashTable.occupiedBucket(after: bucket)
    }
    theState.extra.0 = CUnsignedLong(bucket.offset)
    state.pointee = theState
    return stored
  }
}
@usableFromInline
@frozen
internal struct __CocoaSet {
  @usableFromInline
  internal let object: AnyObject
  @inlinable
  internal init(_ object: __owned AnyObject) {
    self.object = object
  }
}
extension __CocoaSet {
  @usableFromInline
  internal func member(for index: Index) -> AnyObject {
    return index.element
  }
  @usableFromInline
  internal func member(for element: AnyObject) -> AnyObject? {
    let nss = unsafeBitCast(object, to: _NSSet.self)
    return nss.member(element)
  }
}
extension __CocoaSet {
  @usableFromInline
  internal func isEqual(to other: __CocoaSet) -> Bool {
    return _stdlib_NSObject_isEqual(self.object, other.object)
  }
}
extension __CocoaSet: _SetBuffer {
  @usableFromInline
  internal typealias Element = AnyObject
  @usableFromInline 
  internal var startIndex: Index {
    get {
      let allKeys = _stdlib_NSSet_allObjects(self.object)
      return Index(Index.Storage(self, allKeys), offset: 0)
    }
  }
  @usableFromInline 
  internal var endIndex: Index {
    get {
      let allKeys = _stdlib_NSSet_allObjects(self.object)
      return Index(Index.Storage(self, allKeys), offset: allKeys.count)
    }
  }
  @usableFromInline 
  internal func index(after index: Index) -> Index {
    validate(index)
    var result = index
    result._offset += 1
    return result
  }
  internal func validate(_ index: Index) {
    _precondition(index.storage.base.object === self.object,
      "Invalid index")
    _precondition(index._offset < index.storage.allKeys.count,
      "Attempt to access endIndex")
  }
  @usableFromInline 
  internal func formIndex(after index: inout Index, isUnique: Bool) {
    validate(index)
    index._offset += 1
  }
  @usableFromInline 
  internal func index(for element: AnyObject) -> Index? {
    if !contains(element) {
      return nil
    }
    let allKeys = _stdlib_NSSet_allObjects(object)
    for i in 0..<allKeys.count {
      if _stdlib_NSObject_isEqual(element, allKeys[i]) {
        return Index(Index.Storage(self, allKeys), offset: i)
      }
    }
    _internalInvariantFailure(
      "An NSSet member wasn't listed amongst its enumerated contents")
  }
  @usableFromInline
  internal var count: Int {
    let nss = unsafeBitCast(object, to: _NSSet.self)
    return nss.count
  }
  @usableFromInline
  internal func contains(_ element: AnyObject) -> Bool {
    let nss = unsafeBitCast(object, to: _NSSet.self)
    return nss.member(element) != nil
  }
  @usableFromInline 
  internal func element(at i: Index) -> AnyObject {
    let element: AnyObject? = i.element
    _internalInvariant(element != nil, "Item not found in underlying NSSet")
    return element!
  }
}
extension __CocoaSet {
  @frozen
  @usableFromInline
  internal struct Index {
    internal var _storage: Builtin.BridgeObject
    internal var _offset: Int
    internal var storage: Storage {
      @inline(__always)
      get {
        let storage = _bridgeObject(toNative: _storage)
        return unsafeDowncast(storage, to: Storage.self)
      }
    }
    internal init(_ storage: __owned Storage, offset: Int) {
      self._storage = _bridgeObject(fromNative: storage)
      self._offset = offset
    }
  }
}
extension __CocoaSet.Index {
  internal class Storage {
    internal let base: __CocoaSet
    internal var allKeys: _BridgingBuffer
    internal init(
      _ base: __owned __CocoaSet,
      _ allKeys: __owned _BridgingBuffer
    ) {
      self.base = base
      self.allKeys = allKeys
    }
  }
}
extension __CocoaSet.Index {
  @usableFromInline
  internal var handleBitPattern: UInt {
    get {
      return unsafeBitCast(storage, to: UInt.self)
    }
  }
}
extension __CocoaSet.Index {
  @usableFromInline 
  @nonobjc
  internal var element: AnyObject {
    get {
      _precondition(_offset < storage.allKeys.count,
        "Attempting to access Set elements using an invalid index")
      return storage.allKeys[_offset]
    }
  }
  @usableFromInline 
  @nonobjc
  internal var age: Int32 {
    get {
      return _HashTable.age(for: storage.base.object)
    }
  }
}
extension __CocoaSet.Index: Equatable {
  @usableFromInline 
  internal static func == (lhs: __CocoaSet.Index, rhs: __CocoaSet.Index) -> Bool {
    _precondition(lhs.storage.base.object === rhs.storage.base.object,
      "Comparing indexes from different sets")
    return lhs._offset == rhs._offset
  }
}
extension __CocoaSet.Index: Comparable {
  @usableFromInline 
  internal static func < (lhs: __CocoaSet.Index, rhs: __CocoaSet.Index) -> Bool {
    _precondition(lhs.storage.base.object === rhs.storage.base.object,
      "Comparing indexes from different sets")
    return lhs._offset < rhs._offset
  }
}
extension __CocoaSet: Sequence {
  @usableFromInline
  final internal class Iterator {
    internal var _fastEnumerationState: _SwiftNSFastEnumerationState =
      _makeSwiftNSFastEnumerationState()
    internal var _fastEnumerationStackBuf = _CocoaFastEnumerationStackBuf()
    internal let base: __CocoaSet
    internal var _fastEnumerationStatePtr:
      UnsafeMutablePointer<_SwiftNSFastEnumerationState> {
      return _getUnsafePointerToStoredProperties(self).assumingMemoryBound(
        to: _SwiftNSFastEnumerationState.self)
    }
    internal var _fastEnumerationStackBufPtr:
      UnsafeMutablePointer<_CocoaFastEnumerationStackBuf> {
      return UnsafeMutableRawPointer(_fastEnumerationStatePtr + 1)
        .assumingMemoryBound(to: _CocoaFastEnumerationStackBuf.self)
    }
    internal var itemIndex: Int = 0
    internal var itemCount: Int = 0
    internal init(_ base: __owned __CocoaSet) {
      self.base = base
    }
  }
  @usableFromInline
  internal __consuming func makeIterator() -> Iterator {
    return Iterator(self)
  }
}
extension __CocoaSet.Iterator: IteratorProtocol {
  @usableFromInline
  internal typealias Element = AnyObject
  @usableFromInline
  internal func next() -> Element? {
    if itemIndex < 0 {
      return nil
    }
    let base = self.base
    if itemIndex == itemCount {
      let stackBufCount = _fastEnumerationStackBuf.count
      itemCount = base.object.countByEnumerating(
        with: _fastEnumerationStatePtr,
        objects: UnsafeMutableRawPointer(_fastEnumerationStackBufPtr)
          .assumingMemoryBound(to: AnyObject.self),
        count: stackBufCount)
      if itemCount == 0 {
        itemIndex = -1
        return nil
      }
      itemIndex = 0
    }
    let itemsPtrUP =
    UnsafeMutableRawPointer(_fastEnumerationState.itemsPtr!)
      .assumingMemoryBound(to: AnyObject.self)
    let itemsPtr = _UnmanagedAnyObjectArray(itemsPtrUP)
    let key: AnyObject = itemsPtr[itemIndex]
    itemIndex += 1
    return key
  }
}
extension Set {
  @inlinable
  public __consuming func _bridgeToObjectiveCImpl() -> AnyObject {
    guard _variant.isNative else {
      return _variant.asCocoa.object
    }
    return _variant.asNative.bridged()
  }
  public static func _bridgeFromObjectiveCAdoptingNativeStorageOf(
    _ s: __owned AnyObject
  ) -> Set<Element>? {
    if let deferred = s as? _SwiftDeferredNSSet<Element> {
      return Set(_native: deferred.native)
    }
    if let nativeStorage = s as? _SetStorage<Element> {
      return Set(_native: _NativeSet(nativeStorage))
    }
    if s === __RawSetStorage.empty {
      return Set()
    }
    return nil
  }
}
#endif 
