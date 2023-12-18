#if _runtime(_ObjC)
import SwiftShims
internal func _stdlib_NSDictionary_allKeys(
  _ object: AnyObject
) -> _BridgingBuffer {
  let nsd = unsafeBitCast(object, to: _NSDictionary.self)
  let count = nsd.count
  let storage = _BridgingBuffer(count)
  nsd.getObjects(nil, andKeys: storage.baseAddress, count: count)
  return storage
}
extension _NativeDictionary { 
  @usableFromInline
  __consuming internal func bridged() -> AnyObject {
    _connectOrphanedFoundationSubclassesIfNeeded()
    let nsDictionary: _NSDictionaryCore
    if _storage === __RawDictionaryStorage.empty || count == 0 {
      nsDictionary = __RawDictionaryStorage.empty
    } else if _isBridgedVerbatimToObjectiveC(Key.self),
      _isBridgedVerbatimToObjectiveC(Value.self) {
      nsDictionary = unsafeDowncast(
        _storage,
        to: _DictionaryStorage<Key, Value>.self)
    } else {
      nsDictionary = _SwiftDeferredNSDictionary(self)
    }
    return nsDictionary
  }
}
final internal class _SwiftDictionaryNSEnumerator<Key: Hashable, Value>
  : __SwiftNativeNSEnumerator, _NSEnumerator {
  @nonobjc internal var base: _NativeDictionary<Key, Value>
  @nonobjc internal var bridgedKeys: __BridgingHashBuffer?
  @nonobjc internal var nextBucket: _NativeDictionary<Key, Value>.Bucket
  @nonobjc internal var endBucket: _NativeDictionary<Key, Value>.Bucket
  @objc
  internal override required init() {
    _internalInvariantFailure("don't call this designated initializer")
  }
  internal init(_ base: __owned _NativeDictionary<Key, Value>) {
    _internalInvariant(_isBridgedVerbatimToObjectiveC(Key.self))
    _internalInvariant(_orphanedFoundationSubclassesReparented)
    self.base = base
    self.bridgedKeys = nil
    self.nextBucket = base.hashTable.startBucket
    self.endBucket = base.hashTable.endBucket
    super.init()
  }
  @nonobjc
  internal init(_ deferred: __owned _SwiftDeferredNSDictionary<Key, Value>) {
    _internalInvariant(!_isBridgedVerbatimToObjectiveC(Key.self))
    _internalInvariant(_orphanedFoundationSubclassesReparented)
    self.base = deferred.native
    self.bridgedKeys = deferred.bridgeKeys()
    self.nextBucket = base.hashTable.startBucket
    self.endBucket = base.hashTable.endBucket
    super.init()
  }
  private func bridgedKey(at bucket: _HashTable.Bucket) -> AnyObject {
    _internalInvariant(base.hashTable.isOccupied(bucket))
    if let bridgedKeys = self.bridgedKeys {
      return bridgedKeys[bucket]
    }
    return _bridgeAnythingToObjectiveC(base.uncheckedKey(at: bucket))
  }
  @objc
  internal func nextObject() -> AnyObject? {
    if nextBucket == endBucket {
      return nil
    }
    let bucket = nextBucket
    nextBucket = base.hashTable.occupiedBucket(after: nextBucket)
    return self.bridgedKey(at: bucket)
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
    unmanagedObjects[0] = self.bridgedKey(at: nextBucket)
    nextBucket = base.hashTable.occupiedBucket(after: nextBucket)
    state.pointee = theState
    return 1
  }
}
final internal class _SwiftDeferredNSDictionary<Key: Hashable, Value>
  : __SwiftNativeNSDictionary, _NSDictionaryCore {
  @usableFromInline
  internal typealias Bucket = _HashTable.Bucket
  @nonobjc
  private var _bridgedKeys_DoNotUse: AnyObject?
  @nonobjc
  private var _bridgedValues_DoNotUse: AnyObject?
  internal var native: _NativeDictionary<Key, Value>
  internal init(_ native: __owned _NativeDictionary<Key, Value>) {
    _internalInvariant(native.count > 0)
    _internalInvariant(!_isBridgedVerbatimToObjectiveC(Key.self) ||
      !_isBridgedVerbatimToObjectiveC(Value.self))
    self.native = native
    super.init()
  }
  @objc
  internal required init(
    objects: UnsafePointer<AnyObject?>,
    forKeys: UnsafeRawPointer,
    count: Int
  ) {
    _internalInvariantFailure("don't call this designated initializer")
  }
  @nonobjc
  private var _bridgedKeysPtr: UnsafeMutablePointer<AnyObject?> {
    return _getUnsafePointerToStoredProperties(self)
      .assumingMemoryBound(to: Optional<AnyObject>.self)
  }
  @nonobjc
  private var _bridgedValuesPtr: UnsafeMutablePointer<AnyObject?> {
    return _bridgedKeysPtr + 1
  }
  @nonobjc
  private var _bridgedKeys: __BridgingHashBuffer? {
    guard let ref = _stdlib_atomicLoadARCRef(object: _bridgedKeysPtr) else {
      return nil
    }
    return unsafeDowncast(ref, to: __BridgingHashBuffer.self)
  }
  @nonobjc
  private var _bridgedValues: __BridgingHashBuffer? {
    guard let ref = _stdlib_atomicLoadARCRef(object: _bridgedValuesPtr) else {
      return nil
    }
    return unsafeDowncast(ref, to: __BridgingHashBuffer.self)
  }
  @nonobjc
  private func _initializeBridgedKeys(_ storage: __BridgingHashBuffer) {
    _stdlib_atomicInitializeARCRef(object: _bridgedKeysPtr, desired: storage)
  }
  @nonobjc
  private func _initializeBridgedValues(_ storage: __BridgingHashBuffer) {
    _stdlib_atomicInitializeARCRef(object: _bridgedValuesPtr, desired: storage)
  }
  @nonobjc
  internal func bridgeKeys() -> __BridgingHashBuffer? {
    if _isBridgedVerbatimToObjectiveC(Key.self) { return nil }
    if let bridgedKeys = _bridgedKeys { return bridgedKeys }
    let bridged = __BridgingHashBuffer.allocate(
      owner: native._storage,
      hashTable: native.hashTable)
    for bucket in native.hashTable {
      let object = _bridgeAnythingToObjectiveC(native.uncheckedKey(at: bucket))
      bridged.initialize(at: bucket, to: object)
    }
    _initializeBridgedKeys(bridged)
    return _bridgedKeys!
  }
  @nonobjc
  internal func bridgeValues() -> __BridgingHashBuffer? {
    if _isBridgedVerbatimToObjectiveC(Value.self) { return nil }
    if let bridgedValues = _bridgedValues { return bridgedValues }
    let bridged = __BridgingHashBuffer.allocate(
      owner: native._storage,
      hashTable: native.hashTable)
    for bucket in native.hashTable {
      let value = native.uncheckedValue(at: bucket)
      let cocoaValue = _bridgeAnythingToObjectiveC(value)
      bridged.initialize(at: bucket, to: cocoaValue)
    }
    _initializeBridgedValues(bridged)
    return _bridgedValues!
  }
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @inline(__always)
  private func _key(
    at bucket: Bucket,
    bridgedKeys: __BridgingHashBuffer?
  ) -> AnyObject {
    if let bridgedKeys = bridgedKeys {
      return bridgedKeys[bucket]
    }
    return _bridgeAnythingToObjectiveC(native.uncheckedKey(at: bucket))
  }
  @inline(__always)
  private func _value(
    at bucket: Bucket,
    bridgedValues: __BridgingHashBuffer?
  ) -> AnyObject {
    if let bridgedValues = bridgedValues {
      return bridgedValues[bucket]
    }
    return _bridgeAnythingToObjectiveC(native.uncheckedValue(at: bucket))
  }
  @objc(objectForKey:)
  internal func object(forKey aKey: AnyObject) -> AnyObject? {
    guard let nativeKey = _conditionallyBridgeFromObjectiveC(aKey, Key.self)
    else { return nil }
    let (bucket, found) = native.find(nativeKey)
    guard found else { return nil }
    return _value(at: bucket, bridgedValues: bridgeValues())
  }
  @objc
  internal func keyEnumerator() -> _NSEnumerator {
    if _isBridgedVerbatimToObjectiveC(Key.self) {
      return _SwiftDictionaryNSEnumerator<Key, Value>(native)
    }
    return _SwiftDictionaryNSEnumerator<Key, Value>(self)
  }
  @objc(getObjects:andKeys:count:)
  internal func getObjects(
    _ objects: UnsafeMutablePointer<AnyObject>?,
    andKeys keys: UnsafeMutablePointer<AnyObject>?,
    count: Int
  ) {
    _precondition(count >= 0, "Invalid count")
    guard count > 0 else { return }
    let bridgedKeys = bridgeKeys()
    let bridgedValues = bridgeValues()
    var i = 0 
    defer { _fixLifetime(self) }
    switch (_UnmanagedAnyObjectArray(keys), _UnmanagedAnyObjectArray(objects)) {
    case (let unmanagedKeys?, let unmanagedObjects?):
      for bucket in native.hashTable {
        unmanagedKeys[i] = _key(at: bucket, bridgedKeys: bridgedKeys)
        unmanagedObjects[i] = _value(at: bucket, bridgedValues: bridgedValues)
        i += 1
        guard i < count else { break }
      }
    case (let unmanagedKeys?, nil):
      for bucket in native.hashTable {
        unmanagedKeys[i] = _key(at: bucket, bridgedKeys: bridgedKeys)
        i += 1
        guard i < count else { break }
      }
    case (nil, let unmanagedObjects?):
      for bucket in native.hashTable {
        unmanagedObjects[i] = _value(at: bucket, bridgedValues: bridgedValues)
        i += 1
        guard i < count else { break }
      }
    case (nil, nil):
      break
    }
  }
  @objc(enumerateKeysAndObjectsWithOptions:usingBlock:)
  internal func enumerateKeysAndObjects(
    options: Int,
    using block: @convention(block) (
      Unmanaged<AnyObject>,
      Unmanaged<AnyObject>,
      UnsafeMutablePointer<UInt8>
    ) -> Void) {
    let bridgedKeys = bridgeKeys()
    let bridgedValues = bridgeValues()
    defer { _fixLifetime(self) }
    var stop: UInt8 = 0
    for bucket in native.hashTable {
      let key = _key(at: bucket, bridgedKeys: bridgedKeys)
      let value = _value(at: bucket, bridgedValues: bridgedValues)
      block(
        Unmanaged.passUnretained(key),
        Unmanaged.passUnretained(value),
        &stop)
      if stop != 0 { return }
    }
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
    var stored = 0
    let bridgedKeys = bridgeKeys()
    for i in 0..<count {
      if bucket == endBucket { break }
      unmanagedObjects[i] = _key(at: bucket, bridgedKeys: bridgedKeys)
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
internal struct __CocoaDictionary {
  @usableFromInline
  internal let object: AnyObject
  @inlinable
  internal init(_ object: __owned AnyObject) {
    self.object = object
  }
}
extension __CocoaDictionary {
  @usableFromInline
  internal func isEqual(to other: __CocoaDictionary) -> Bool {
    return _stdlib_NSObject_isEqual(self.object, other.object)
  }
}
extension __CocoaDictionary: _DictionaryBuffer {
  @usableFromInline
  internal typealias Key = AnyObject
  @usableFromInline
  internal typealias Value = AnyObject
  @usableFromInline 
  internal var startIndex: Index {
    get {
      let allKeys = _stdlib_NSDictionary_allKeys(self.object)
      return Index(Index.Storage(self, allKeys), offset: 0)
    }
  }
  @usableFromInline 
  internal var endIndex: Index {
    get {
      let allKeys = _stdlib_NSDictionary_allKeys(self.object)
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
    _precondition(index.storage.base.object === self.object, "Invalid index")
    _precondition(index._offset < index.storage.allKeys.count,
      "Attempt to access endIndex")
  }
  @usableFromInline 
  internal func formIndex(after index: inout Index, isUnique: Bool) {
    validate(index)
    index._offset += 1
  }
  @usableFromInline 
  internal func index(forKey key: Key) -> Index? {
    if lookup(key) == nil {
      return nil
    }
    let allKeys = _stdlib_NSDictionary_allKeys(object)
    for i in 0..<allKeys.count {
      if _stdlib_NSObject_isEqual(key, allKeys[i]) {
        return Index(Index.Storage(self, allKeys), offset: i)
      }
    }
    _internalInvariantFailure(
      "An NSDictionary key wasn't listed amongst its enumerated contents")
  }
  @usableFromInline
  internal var count: Int {
    let nsd = unsafeBitCast(object, to: _NSDictionary.self)
    return nsd.count
  }
  @usableFromInline
  internal func contains(_ key: Key) -> Bool {
    let nsd = unsafeBitCast(object, to: _NSDictionary.self)
    return nsd.object(forKey: key) != nil
  }
  @usableFromInline
  internal func lookup(_ key: Key) -> Value? {
    let nsd = unsafeBitCast(object, to: _NSDictionary.self)
    return nsd.object(forKey: key)
  }
  @usableFromInline 
  internal func lookup(_ index: Index) -> (key: Key, value: Value) {
    _precondition(index.storage.base.object === self.object, "Invalid index")
    let key: Key = index.storage.allKeys[index._offset]
    let value: Value = index.storage.base.object.object(forKey: key)!
    return (key, value)
  }
  @usableFromInline 
  func key(at index: Index) -> Key {
    _precondition(index.storage.base.object === self.object, "Invalid index")
    return index.key
  }
  @usableFromInline 
  func value(at index: Index) -> Value {
    _precondition(index.storage.base.object === self.object, "Invalid index")
    let key = index.storage.allKeys[index._offset]
    return index.storage.base.object.object(forKey: key)!
  }
}
extension __CocoaDictionary {
  @inlinable
  internal func mapValues<Key: Hashable, Value, T>(
    _ transform: (Value) throws -> T
  ) rethrows -> _NativeDictionary<Key, T> {
    var result = _NativeDictionary<Key, T>(capacity: self.count)
    for (cocoaKey, cocoaValue) in self {
      let key = _forceBridgeFromObjectiveC(cocoaKey, Key.self)
      let value = _forceBridgeFromObjectiveC(cocoaValue, Value.self)
      try result.insertNew(key: key, value: transform(value))
    }
    return result
  }
}
extension __CocoaDictionary {
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
    internal init(_ storage: Storage, offset: Int) {
      self._storage = _bridgeObject(fromNative: storage)
      self._offset = offset
    }
  }
}
extension __CocoaDictionary.Index {
  internal class Storage {
    internal let base: __CocoaDictionary
    internal var allKeys: _BridgingBuffer
    internal init(
      _ base: __owned __CocoaDictionary,
      _ allKeys: __owned _BridgingBuffer
    ) {
      self.base = base
      self.allKeys = allKeys
    }
  }
}
extension __CocoaDictionary.Index {
  @usableFromInline
  internal var handleBitPattern: UInt {
    get {
      return unsafeBitCast(storage, to: UInt.self)
    }
  }
  @usableFromInline
  internal var dictionary: __CocoaDictionary {
    get {
      return storage.base
    }
  }
}
extension __CocoaDictionary.Index {
  @usableFromInline 
  @nonobjc
  internal var key: AnyObject {
    get {
      _precondition(_offset < storage.allKeys.count,
        "Attempting to access Dictionary elements using an invalid index")
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
extension __CocoaDictionary.Index: Equatable {
  @usableFromInline 
  internal static func == (
    lhs: __CocoaDictionary.Index,
    rhs: __CocoaDictionary.Index
  ) -> Bool {
    _precondition(lhs.storage.base.object === rhs.storage.base.object,
      "Comparing indexes from different dictionaries")
    return lhs._offset == rhs._offset
  }
}
extension __CocoaDictionary.Index: Comparable {
  @usableFromInline 
  internal static func < (
    lhs: __CocoaDictionary.Index,
    rhs: __CocoaDictionary.Index
  ) -> Bool {
    _precondition(lhs.storage.base.object === rhs.storage.base.object,
      "Comparing indexes from different dictionaries")
    return lhs._offset < rhs._offset
  }
}
extension __CocoaDictionary: Sequence {
  @usableFromInline
  final internal class Iterator {
    internal var _fastEnumerationState: _SwiftNSFastEnumerationState =
      _makeSwiftNSFastEnumerationState()
    internal var _fastEnumerationStackBuf = _CocoaFastEnumerationStackBuf()
    internal let base: __CocoaDictionary
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
    internal init(_ base: __owned __CocoaDictionary) {
      self.base = base
    }
  }
  @usableFromInline
  internal __consuming func makeIterator() -> Iterator {
    return Iterator(self)
  }
}
extension __CocoaDictionary.Iterator: IteratorProtocol {
  @usableFromInline
  internal typealias Element = (key: AnyObject, value: AnyObject)
  @usableFromInline
  internal func nextKey() -> AnyObject? {
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
  @usableFromInline
  internal func next() -> Element? {
    guard let key = nextKey() else { return nil }
    let value: AnyObject = base.object.object(forKey: key)!
    return (key, value)
  }
}
extension Dictionary {
  @inlinable
  public __consuming func _bridgeToObjectiveCImpl() -> AnyObject {
    guard _variant.isNative else {
      return _variant.asCocoa.object
    }
    return _variant.asNative.bridged()
  }
  public static func _bridgeFromObjectiveCAdoptingNativeStorageOf(
    _ s: __owned AnyObject
  ) -> Dictionary<Key, Value>? {
    if let deferred = s as? _SwiftDeferredNSDictionary<Key, Value> {
      return Dictionary(_native: deferred.native)
    }
    if let nativeStorage = s as? _DictionaryStorage<Key, Value> {
      return Dictionary(_native: _NativeDictionary(nativeStorage))
    }
    if s === __RawDictionaryStorage.empty {
      return Dictionary()
    }
    return nil
  }
}
#endif 
