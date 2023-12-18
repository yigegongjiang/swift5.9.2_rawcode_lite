import SwiftShims
@usableFromInline
internal class __RawDictionaryStorage: __SwiftNativeNSDictionary {
  @usableFromInline
  @nonobjc
  internal final var _count: Int
  @usableFromInline
  @nonobjc
  internal final var _capacity: Int
  @usableFromInline
  @nonobjc
  internal final var _scale: Int8
  @usableFromInline
  @nonobjc
  internal final var _reservedScale: Int8
  @nonobjc
  internal final var _extra: Int16
  @usableFromInline
  @nonobjc
  internal final var _age: Int32
  @usableFromInline
  internal final var _seed: Int
  @usableFromInline
  @nonobjc
  internal final var _rawKeys: UnsafeMutableRawPointer
  @usableFromInline
  @nonobjc
  internal final var _rawValues: UnsafeMutableRawPointer
  @nonobjc
  internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
  @inlinable
  @nonobjc
  internal final var _bucketCount: Int {
    @inline(__always) get { return 1 &<< _scale }
  }
  @inlinable
  @nonobjc
  internal final var _metadata: UnsafeMutablePointer<_HashTable.Word> {
    @inline(__always) get {
      let address = Builtin.projectTailElems(self, _HashTable.Word.self)
      return UnsafeMutablePointer(address)
    }
  }
  @inlinable
  @nonobjc
  internal final var _hashTable: _HashTable {
    @inline(__always) get {
      return _HashTable(words: _metadata, bucketCount: _bucketCount)
    }
  }
}
@usableFromInline
internal class __EmptyDictionarySingleton: __RawDictionaryStorage {
  @nonobjc
  internal override init(_doNotCallMe: ()) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
#if _runtime(_ObjC)
  @objc
  internal required init(
    objects: UnsafePointer<AnyObject?>,
    forKeys: UnsafeRawPointer,
    count: Int
  ) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
#endif
}
#if _runtime(_ObjC)
extension __EmptyDictionarySingleton: _NSDictionaryCore {
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @objc
  internal var count: Int {
    return 0
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
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
  @objc(objectForKey:)
  internal func object(forKey aKey: AnyObject) -> AnyObject? {
    return nil
  }
  @objc(keyEnumerator)
  internal func keyEnumerator() -> _NSEnumerator {
    return __SwiftEmptyNSEnumerator()
  }
  @objc(getObjects:andKeys:count:)
  internal func getObjects(
    _ objects: UnsafeMutablePointer<AnyObject>?,
    andKeys keys: UnsafeMutablePointer<AnyObject>?,
    count: Int) {
  }
}
#endif
extension __RawDictionaryStorage {
  @inlinable
  @nonobjc
  internal static var empty: __EmptyDictionarySingleton {
    return Builtin.bridgeFromRawPointer(
      Builtin.addressof(&_swiftEmptyDictionarySingleton))
  }
  @inline(__always)
  internal final func uncheckedKey<Key: Hashable>(at bucket: _HashTable.Bucket) -> Key {
    defer { _fixLifetime(self) }
    _internalInvariant(_hashTable.isOccupied(bucket))
    let keys = _rawKeys.assumingMemoryBound(to: Key.self)
    return keys[bucket.offset]
  }
  @inline(never)
  internal final func find<Key: Hashable>(_ key: Key) -> (bucket: _HashTable.Bucket, found: Bool) {
    return find(key, hashValue: key._rawHashValue(seed: _seed))
  }
  @inline(never)
  internal final func find<Key: Hashable>(_ key: Key, hashValue: Int) -> (bucket: _HashTable.Bucket, found: Bool) {
      let hashTable = _hashTable
      var bucket = hashTable.idealBucket(forHashValue: hashValue)
      while hashTable._isOccupied(bucket) {
        if uncheckedKey(at: bucket) == key {
          return (bucket, true)
        }
        bucket = hashTable.bucket(wrappedAfter: bucket)
      }
      return (bucket, false)
  }
}
@usableFromInline
final internal class _DictionaryStorage<Key: Hashable, Value>
  : __RawDictionaryStorage, _NSDictionaryCore {
  @nonobjc
  override internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
  deinit {
    guard _count > 0 else { return }
    if !_isPOD(Key.self) {
      let keys = self._keys
      for bucket in _hashTable {
        (keys + bucket.offset).deinitialize(count: 1)
      }
    }
    if !_isPOD(Value.self) {
      let values = self._values
      for bucket in _hashTable {
        (values + bucket.offset).deinitialize(count: 1)
      }
    }
    _count = 0
    _fixLifetime(self)
  }
  @inlinable
  final internal var _keys: UnsafeMutablePointer<Key> {
    @inline(__always)
    get {
      return self._rawKeys.assumingMemoryBound(to: Key.self)
    }
  }
  @inlinable
  final internal var _values: UnsafeMutablePointer<Value> {
    @inline(__always)
    get {
      return self._rawValues.assumingMemoryBound(to: Value.self)
    }
  }
  internal var asNative: _NativeDictionary<Key, Value> {
    return _NativeDictionary(self)
  }
#if _runtime(_ObjC)
  @objc
  internal required init(
    objects: UnsafePointer<AnyObject?>,
    forKeys: UnsafeRawPointer,
    count: Int
  ) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @objc
  internal var count: Int {
    return _count
  }
  @objc(keyEnumerator)
  internal func keyEnumerator() -> _NSEnumerator {
    return _SwiftDictionaryNSEnumerator<Key, Value>(asNative)
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int {
    defer { _fixLifetime(self) }
    let hashTable = _hashTable
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
    for i in 0..<count {
      if bucket == endBucket { break }
      let key = _keys[bucket.offset]
      unmanagedObjects[i] = _bridgeAnythingToObjectiveC(key)
      stored += 1
      bucket = hashTable.occupiedBucket(after: bucket)
    }
    theState.extra.0 = CUnsignedLong(bucket.offset)
    state.pointee = theState
    return stored
  }
  @objc(objectForKey:)
  internal func object(forKey aKey: AnyObject) -> AnyObject? {
    guard let nativeKey = _conditionallyBridgeFromObjectiveC(aKey, Key.self)
    else { return nil }
    let (bucket, found) = asNative.find(nativeKey)
    guard found else { return nil }
    let value = asNative.uncheckedValue(at: bucket)
    return _bridgeAnythingToObjectiveC(value)
  }
  @objc(getObjects:andKeys:count:)
  internal func getObjects(
    _ objects: UnsafeMutablePointer<AnyObject>?,
    andKeys keys: UnsafeMutablePointer<AnyObject>?,
    count: Int) {
    _precondition(count >= 0, "Invalid count")
    guard count > 0 else { return }
    var i = 0 
    switch (_UnmanagedAnyObjectArray(keys), _UnmanagedAnyObjectArray(objects)) {
    case (let unmanagedKeys?, let unmanagedObjects?):
      for (key, value) in asNative {
        unmanagedObjects[i] = _bridgeAnythingToObjectiveC(value)
        unmanagedKeys[i] = _bridgeAnythingToObjectiveC(key)
        i += 1
        guard i < count else { break }
      }
    case (let unmanagedKeys?, nil):
      for (key, _) in asNative {
        unmanagedKeys[i] = _bridgeAnythingToObjectiveC(key)
        i += 1
        guard i < count else { break }
      }
    case (nil, let unmanagedObjects?):
      for (_, value) in asNative {
        unmanagedObjects[i] = _bridgeAnythingToObjectiveC(value)
        i += 1
        guard i < count else { break }
      }
    case (nil, nil):
      break
    }
  }
#endif
}
extension _DictionaryStorage {
  @usableFromInline
  internal static func copy(
    original: __RawDictionaryStorage
  ) -> _DictionaryStorage {
    return allocate(
      scale: original._scale,
      age: original._age,
      seed: original._seed)
  }
  @usableFromInline
  static internal func resize(
    original: __RawDictionaryStorage,
    capacity: Int,
    move: Bool
  ) -> _DictionaryStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    return allocate(scale: scale, age: nil, seed: nil)
  }
  @usableFromInline
  static internal func allocate(capacity: Int) -> _DictionaryStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    return allocate(scale: scale, age: nil, seed: nil)
  }
#if _runtime(_ObjC)
  @usableFromInline
  static internal func convert(
    _ cocoa: __CocoaDictionary,
    capacity: Int
  ) -> _DictionaryStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    let age = _HashTable.age(for: cocoa.object)
    return allocate(scale: scale, age: age, seed: nil)
  }
#endif
  static internal func allocate(
    scale: Int8,
    age: Int32?,
    seed: Int?
  ) -> _DictionaryStorage {
    _internalInvariant(scale >= 0 && scale < Int.bitWidth - 1)
    let bucketCount = (1 as Int) &<< scale
    let wordCount = _UnsafeBitset.wordCount(forCapacity: bucketCount)
    let storage = Builtin.allocWithTailElems_3(
      _DictionaryStorage<Key, Value>.self,
      wordCount._builtinWordValue, _HashTable.Word.self,
      bucketCount._builtinWordValue, Key.self,
      bucketCount._builtinWordValue, Value.self)
    let metadataAddr = Builtin.projectTailElems(storage, _HashTable.Word.self)
    let keysAddr = Builtin.getTailAddr_Word(
      metadataAddr, wordCount._builtinWordValue, _HashTable.Word.self,
      Key.self)
    let valuesAddr = Builtin.getTailAddr_Word(
      keysAddr, bucketCount._builtinWordValue, Key.self,
      Value.self)
    storage._count = 0
    storage._capacity = _HashTable.capacity(forScale: scale)
    storage._scale = scale
    storage._reservedScale = 0
    storage._extra = 0
    if let age = age {
      storage._age = age
    } else {
      storage._age = Int32(
        truncatingIfNeeded: ObjectIdentifier(storage).hashValue)
    }
    storage._seed = seed ?? _HashTable.hashSeed(for: storage, scale: scale)
    storage._rawKeys = UnsafeMutableRawPointer(keysAddr)
    storage._rawValues = UnsafeMutableRawPointer(valuesAddr)
    storage._hashTable.clear()
    return storage
  }
}
