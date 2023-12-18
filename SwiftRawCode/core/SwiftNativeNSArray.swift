#if _runtime(_ObjC)
import SwiftShims
internal func _isValidArrayIndex(_ index: Int, count: Int) -> Bool {
  return (index >= 0) && (index <= count)
}
internal func _isValidArraySubscript(_ index: Int, count: Int) -> Bool {
  return (index >= 0) && (index < count)
}
@usableFromInline
internal class __SwiftNativeNSArrayWithContiguousStorage
  : __SwiftNativeNSArray { 
  @inlinable
  @nonobjc internal override init() { super.init() }
  @inlinable
  deinit {}
  internal func withUnsafeBufferOfObjects<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R {
    _internalInvariantFailure(
      "Must override withUnsafeBufferOfObjects in derived classes")
  }
}
private let NSNotFound: Int = .max
extension __SwiftNativeNSArrayWithContiguousStorage {
  @objc internal var count: Int {
    return withUnsafeBufferOfObjects { $0.count }
  }
  @inline(__always)
  @nonobjc private func _objectAt(_ index: Int) -> Unmanaged<AnyObject> {
    return withUnsafeBufferOfObjects {
      objects in
      _precondition(
        _isValidArraySubscript(index, count: objects.count),
        "Array index out of range")
      return Unmanaged.passUnretained(objects[index])
    }
  }
  @objc(objectAtIndexedSubscript:)
  dynamic internal func objectAtSubscript(_ index: Int) -> Unmanaged<AnyObject> {
    return _objectAt(index)
  }
  @objc(objectAtIndex:)
  dynamic internal func objectAt(_ index: Int) -> Unmanaged<AnyObject> {
    return _objectAt(index)
  }
  @objc internal func getObjects(
    _ aBuffer: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange
  ) {
    return withUnsafeBufferOfObjects {
      objects in
      _precondition(
        _isValidArrayIndex(range.location, count: objects.count),
        "Array index out of range")
      _precondition(
        _isValidArrayIndex(
          range.location + range.length, count: objects.count),
        "Array index out of range")
      if objects.isEmpty { return }
      UnsafeMutableRawPointer(aBuffer).copyMemory(
        from: objects.baseAddress! + range.location,
        byteCount: range.length * MemoryLayout<AnyObject>.stride)
    }
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int {
    var enumerationState = state.pointee
    if enumerationState.state != 0 {
      return 0
    }
    return withUnsafeBufferOfObjects {
      objects in
      enumerationState.mutationsPtr = _fastEnumerationStorageMutationsPtr
      enumerationState.itemsPtr =
        AutoreleasingUnsafeMutablePointer(objects.baseAddress)
      enumerationState.state = 1
      state.pointee = enumerationState
      return objects.count
    }
  }
  @objc(copyWithZone:)
  internal func copy(with _: _SwiftNSZone?) -> AnyObject {
    return self
  }
}
@usableFromInline
@objc internal final class _SwiftNSMutableArray :
  _SwiftNativeNSMutableArray
{
  internal var contents: [AnyObject]
  internal init(_ array: [AnyObject]) {
    contents = array
    super.init()
  }
  @objc internal var count: Int {
    return contents.count
  }
  @objc(objectAtIndexedSubscript:)
  dynamic internal func objectAtSubscript(_ index: Int) -> Unmanaged<AnyObject> {
    return Unmanaged.passUnretained(contents[index])
  }
  @objc(objectAtIndex:)
  dynamic internal func objectAt(_ index: Int) -> Unmanaged<AnyObject> {
    return Unmanaged.passUnretained(contents[index])
  }
  @objc internal func getObjects(
    _ aBuffer: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange
  ) {
    return contents.withContiguousStorageIfAvailable { objects in
      _precondition(
        _isValidArrayIndex(range.location, count: objects.count),
        "Array index out of range")
      _precondition(
        _isValidArrayIndex(
          range.location + range.length, count: objects.count),
        "Array index out of range")
      if objects.isEmpty { return }
      UnsafeMutableRawPointer(aBuffer).copyMemory(
        from: objects.baseAddress! + range.location,
        byteCount: range.length * MemoryLayout<AnyObject>.stride)
    }!
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int {
    var enumerationState = state.pointee
    if enumerationState.state != 0 {
      return 0
    }
    return contents.withContiguousStorageIfAvailable {
      objects in
      enumerationState.mutationsPtr = _fastEnumerationStorageMutationsPtr
      enumerationState.itemsPtr =
        AutoreleasingUnsafeMutablePointer(objects.baseAddress)
      enumerationState.state = 1
      state.pointee = enumerationState
      return objects.count
    }!
  }
  @objc(copyWithZone:)
  dynamic internal func copy(with _: _SwiftNSZone?) -> AnyObject {
    return contents._bridgeToObjectiveCImpl()
  }
  @objc(insertObject:atIndex:)
  dynamic internal func insert(_ anObject: AnyObject, at index: Int) {
    contents.insert(anObject, at: index)
  }
  @objc(removeObjectAtIndex:)
  dynamic internal func removeObject(at index: Int) {
    contents.remove(at: index)
  }
  @objc(addObject:)
  dynamic internal func add(_ anObject: AnyObject) {
    contents.append(anObject)
  }
  @objc(removeLastObject)
  dynamic internal func removeLastObject() {
    if !contents.isEmpty {
      contents.removeLast()
    }
  }
  @objc(replaceObjectAtIndex:withObject:)
  dynamic internal func replaceObject(at index: Int, with anObject: AnyObject) {
    contents[index] = anObject
  }
  @objc(exchangeObjectAtIndex:withObjectAtIndex:)
  dynamic internal func exchange(at index: Int, with index2: Int) {
    contents.swapAt(index, index2)
  }
  @objc(replaceObjectsInRange:withObjects:count:)
  dynamic internal func replaceObjects(in range: _SwiftNSRange,
                               with objects: UnsafePointer<AnyObject>,
                               count: Int) {
    let range = range.location ..< range.location + range.length
    let buf = UnsafeBufferPointer(start: objects, count: count)
    if range == contents.startIndex..<contents.endIndex {
      contents = Array(buf)
    } else {
      contents.replaceSubrange(range, with: Array(buf))
    }
  }
  @objc(insertObjects:count:atIndex:)
  dynamic internal func insertObjects(_ objects: UnsafePointer<AnyObject>,
                              count: Int,
                              at index: Int) {
    let buf = UnsafeBufferPointer(start: objects, count: count)
    contents.insert(contentsOf: buf, at: index)
  }
  @objc(indexOfObjectIdenticalTo:)
  dynamic internal func index(ofObjectIdenticalTo object: AnyObject) -> Int {
    return contents.firstIndex { $0 === object } ?? NSNotFound
  }
  @objc(removeObjectsInRange:)
  dynamic internal func removeObjects(in range: _SwiftNSRange) {
    let range = range.location ..< range.location + range.length
    contents.replaceSubrange(range, with: [])
  }
  @objc(removeAllObjects)
  dynamic internal func removeAllObjects() {
    contents = []
  }
  @objc(setObject:atIndex:)
  dynamic internal func setObject(_ anObject: AnyObject, at index: Int) {
    if index == contents.count {
      contents.append(anObject)
    } else {
      contents[index] = anObject
    }
  }
  @objc(setObject:atIndexedSubscript:) dynamic
  internal func setObjectSubscript(_ anObject: AnyObject, at index: Int) {
    if index == contents.count {
      contents.append(anObject)
    } else {
      contents[index] = anObject
    }
  }
}
@usableFromInline
@objc internal final class __SwiftDeferredNSArray
  : __SwiftNativeNSArrayWithContiguousStorage {
  @nonobjc
  internal var _heapBufferBridged_DoNotUse: AnyObject?
  @usableFromInline
  @nonobjc
  internal let _nativeStorage: __ContiguousArrayStorageBase
  @nonobjc
  internal var _heapBufferBridgedPtr: UnsafeMutablePointer<AnyObject?> {
    return _getUnsafePointerToStoredProperties(self).assumingMemoryBound(
      to: Optional<AnyObject>.self)
  }
  internal var _heapBufferBridged: __BridgingBufferStorage? {
    if let ref =
      _stdlib_atomicLoadARCRef(object: _heapBufferBridgedPtr) {
      return unsafeBitCast(ref, to: __BridgingBufferStorage.self)
    }
    return nil
  }
  @inlinable 
  @nonobjc
  internal init(_nativeStorage: __ContiguousArrayStorageBase) {
    self._nativeStorage = _nativeStorage
  }
  internal func _destroyBridgedStorage(_ hb: __BridgingBufferStorage?) {
    if let bridgedStorage = hb {
      withExtendedLifetime(bridgedStorage) {
        let buffer = _BridgingBuffer(bridgedStorage)
        let count = buffer.count
        buffer.baseAddress.deinitialize(count: count)
      }
    }
  }
  deinit {
    _destroyBridgedStorage(_heapBufferBridged)
  }
  internal override func withUnsafeBufferOfObjects<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R {
    while true {
      var buffer: UnsafeBufferPointer<AnyObject>
      if let bridgedStorage = _heapBufferBridged {
        let bridgingBuffer = _BridgingBuffer(bridgedStorage)
        buffer = UnsafeBufferPointer(
            start: bridgingBuffer.baseAddress, count: bridgingBuffer.count)
      }
      else if let buf = _nativeStorage._withVerbatimBridgedUnsafeBuffer(
        { $0 }
      ) {
        buffer = buf
      }
      else {
        let objects = _nativeStorage._getNonVerbatimBridgingBuffer()
        if !_stdlib_atomicInitializeARCRef(
          object: _heapBufferBridgedPtr, desired: objects.storage!) {
          _destroyBridgedStorage(
            unsafeDowncast(objects.storage!, to: __BridgingBufferStorage.self))
        }
        continue 
      }
      defer { _fixLifetime(self) }
      return try body(buffer)
    }
  }
  @objc
  internal override var count: Int {
    return _nativeStorage.countAndCapacity.count
  }
}
#else
@usableFromInline
internal class __SwiftNativeNSArrayWithContiguousStorage {
  @inlinable
  internal init() {}
  @inlinable
  deinit {}
}
#endif
@usableFromInline
internal class __ContiguousArrayStorageBase
  : __SwiftNativeNSArrayWithContiguousStorage {
  @usableFromInline
  final var countAndCapacity: _ArrayBody
  @inlinable
  @nonobjc
  internal init(_doNotCallMeBase: ()) {
    _internalInvariantFailure("creating instance of __ContiguousArrayStorageBase")
  }
#if _runtime(_ObjC)
  internal override func withUnsafeBufferOfObjects<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R {
    if let result = try _withVerbatimBridgedUnsafeBuffer(body) {
      return result
    }
    _internalInvariantFailure(
      "Can't use a buffer of non-verbatim-bridged elements as an NSArray")
  }
  internal func _withVerbatimBridgedUnsafeBuffer<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R? {
    _internalInvariantFailure(
      "Concrete subclasses must implement _withVerbatimBridgedUnsafeBuffer")
  }
  internal func _getNonVerbatimBridgingBuffer() -> _BridgingBuffer {
    _internalInvariantFailure(
      "Concrete subclasses must implement _getNonVerbatimBridgingBuffer")
  }
  @objc(mutableCopyWithZone:)
  dynamic internal func mutableCopy(with _: _SwiftNSZone?) -> AnyObject {
    let arr = Array<AnyObject>(_ContiguousArrayBuffer(self))
    return _SwiftNSMutableArray(arr)
  }
  @objc(indexOfObjectIdenticalTo:)
  dynamic internal func index(ofObjectIdenticalTo object: AnyObject) -> Int {
    let arr = Array<AnyObject>(_ContiguousArrayBuffer(self))
    return arr.firstIndex { $0 === object } ?? NSNotFound
  }
#endif
@inlinable
  internal func canStoreElements(ofDynamicType _: Any.Type) -> Bool {
    _internalInvariantFailure(
      "Concrete subclasses must implement canStoreElements(ofDynamicType:)")
  }
  @inlinable
  internal var staticElementType: Any.Type {
    _internalInvariantFailure(
      "Concrete subclasses must implement staticElementType")
  }
  @inlinable
  deinit {
    _internalInvariant(
      self !== _emptyArrayStorage, "Deallocating empty array storage?!")
  }
}
