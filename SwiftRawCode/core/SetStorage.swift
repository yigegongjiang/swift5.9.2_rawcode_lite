import SwiftShims
@usableFromInline
internal class __RawSetStorage: __SwiftNativeNSSet {
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
  internal final var _rawElements: UnsafeMutableRawPointer
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
internal class __EmptySetSingleton: __RawSetStorage {
  @nonobjc
  override internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
#if _runtime(_ObjC)
  @objc
  internal required init(objects: UnsafePointer<AnyObject?>, count: Int) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
#endif
}
extension __RawSetStorage {
  @inlinable
  @nonobjc
  internal static var empty: __EmptySetSingleton {
    return Builtin.bridgeFromRawPointer(
      Builtin.addressof(&_swiftEmptySetSingleton))
  }
}
extension __EmptySetSingleton: _NSSetCore {
#if _runtime(_ObjC)
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @objc
  internal var count: Int {
    return 0
  }
  @objc(member:)
  internal func member(_ object: AnyObject) -> AnyObject? {
    return nil
  }
  @objc
  internal func objectEnumerator() -> _NSEnumerator {
    return __SwiftEmptyNSEnumerator()
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
#endif
}
@usableFromInline
final internal class _SetStorage<Element: Hashable>
  : __RawSetStorage, _NSSetCore {
  @nonobjc
  override internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("This class cannot be directly initialized")
  }
  deinit {
    guard _count > 0 else { return }
    if !_isPOD(Element.self) {
      let elements = _elements
      for bucket in _hashTable {
        (elements + bucket.offset).deinitialize(count: 1)
      }
    }
    _fixLifetime(self)
  }
  @inlinable
  final internal var _elements: UnsafeMutablePointer<Element> {
    @inline(__always)
    get {
      return self._rawElements.assumingMemoryBound(to: Element.self)
    }
  }
  internal var asNative: _NativeSet<Element> {
    return _NativeSet(self)
  }
#if _runtime(_ObjC)
  @objc
  internal required init(objects: UnsafePointer<AnyObject?>, count: Int) {
    _internalInvariantFailure("don't call this designated initializer")
  }
  @objc(copyWithZone:)
  internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
  @objc
  internal var count: Int {
    return _count
  }
  @objc
  internal func objectEnumerator() -> _NSEnumerator {
    return _SwiftSetNSEnumerator<Element>(asNative)
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
      let element = _elements[bucket.offset]
      unmanagedObjects[i] = _bridgeAnythingToObjectiveC(element)
      stored += 1
      bucket = hashTable.occupiedBucket(after: bucket)
    }
    theState.extra.0 = CUnsignedLong(bucket.offset)
    state.pointee = theState
    return stored
  }
  @objc(member:)
  internal func member(_ object: AnyObject) -> AnyObject? {
    guard let native = _conditionallyBridgeFromObjectiveC(object, Element.self)
    else { return nil }
    let (bucket, found) = asNative.find(native)
    guard found else { return nil }
    return _bridgeAnythingToObjectiveC(_elements[bucket.offset])
  }
#endif
}
extension _SetStorage {
  @usableFromInline
  internal static func copy(original: __RawSetStorage) -> _SetStorage {
    return .allocate(
      scale: original._scale,
      age: original._age,
      seed: original._seed)
  }
  @usableFromInline
  static internal func resize(
    original: __RawSetStorage,
    capacity: Int,
    move: Bool
  ) -> _SetStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    return allocate(scale: scale, age: nil, seed: nil)
  }
  @usableFromInline
  static internal func allocate(capacity: Int) -> _SetStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    return allocate(scale: scale, age: nil, seed: nil)
  }
#if _runtime(_ObjC)
  @usableFromInline
  static internal func convert(
    _ cocoa: __CocoaSet,
    capacity: Int
  ) -> _SetStorage {
    let scale = _HashTable.scale(forCapacity: capacity)
    let age = _HashTable.age(for: cocoa.object)
    return allocate(scale: scale, age: age, seed: nil)
  }
#endif
  static internal func allocate(
    scale: Int8,
    age: Int32?,
    seed: Int?
  ) -> _SetStorage {
    _internalInvariant(scale >= 0 && scale < Int.bitWidth - 1)
    let bucketCount = (1 as Int) &<< scale
    let wordCount = _UnsafeBitset.wordCount(forCapacity: bucketCount)
    let storage = Builtin.allocWithTailElems_2(
      _SetStorage<Element>.self,
      wordCount._builtinWordValue, _HashTable.Word.self,
      bucketCount._builtinWordValue, Element.self)
    let metadataAddr = Builtin.projectTailElems(storage, _HashTable.Word.self)
    let elementsAddr = Builtin.getTailAddr_Word(
      metadataAddr, wordCount._builtinWordValue, _HashTable.Word.self,
      Element.self)
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
    storage._rawElements = UnsafeMutableRawPointer(elementsAddr)
    storage._hashTable.clear()
    return storage
  }
}
