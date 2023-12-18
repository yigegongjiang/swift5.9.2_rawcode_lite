#if _runtime(_ObjC)
import SwiftShims
@usableFromInline
internal typealias _ArrayBridgeStorage
  = _BridgeStorage<__ContiguousArrayStorageBase>
@usableFromInline
@frozen
internal struct _ArrayBuffer<Element>: _ArrayBufferProtocol {
  @usableFromInline
  internal var _storage: _ArrayBridgeStorage
  @inlinable
  internal init(storage: _ArrayBridgeStorage) {
    _storage = storage
  }
  @inlinable
  internal init() {
    _storage = _ArrayBridgeStorage(native: _emptyArrayStorage)
  }
  @inlinable
  internal init(nsArray: AnyObject) {
    _internalInvariant(_isClassOrObjCExistential(Element.self))
    _storage = _ArrayBridgeStorage(objC: nsArray)
  }
  @inlinable
  __consuming internal func cast<U>(toBufferOf _: U.Type) -> _ArrayBuffer<U> {
    _internalInvariant(_isClassOrObjCExistential(Element.self))
    _internalInvariant(_isClassOrObjCExistential(U.self))
    return _ArrayBuffer<U>(storage: _storage)
  }
  @inlinable
  __consuming internal func downcast<U>(
    toBufferWithDeferredTypeCheckOf _: U.Type
  ) -> _ArrayBuffer<U> {
    _internalInvariant(_isClassOrObjCExistential(Element.self))
    _internalInvariant(_isClassOrObjCExistential(U.self))
    return _ArrayBuffer<U>(
      storage: _ArrayBridgeStorage(native: _native._storage, isFlagged: true))
  }
  @inlinable
  internal var needsElementTypeCheck: Bool {
    return !_isNativeTypeChecked && !(AnyObject.self is Element.Type)
  }
}
extension _ArrayBuffer {
  @inlinable
  internal init(_buffer source: NativeBuffer, shiftedToStartIndex: Int) {
    _internalInvariant(shiftedToStartIndex == 0, "shiftedToStartIndex must be 0")
    _storage = _ArrayBridgeStorage(native: source._storage)
  }
  @inlinable
  internal var arrayPropertyIsNativeTypeChecked: Bool {
    return _isNativeTypeChecked
  }
  @inlinable
  internal mutating func isUniquelyReferenced() -> Bool {
    if !_isClassOrObjCExistential(Element.self) {
      return _storage.isUniquelyReferencedUnflaggedNative()
    }
    return _storage.isUniquelyReferencedNative()
   }
  internal mutating func beginCOWMutation() -> Bool {
    let isUnique: Bool
    if !_isClassOrObjCExistential(Element.self) {
      isUnique = _storage.beginCOWMutationUnflaggedNative()
    } else if !_storage.beginCOWMutationNative() {
      return false
    } else {
      isUnique = _isNative
    }
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    if isUnique {
      _native.isImmutable = false
    }
#endif
    return isUnique
  }
  @inline(__always)
  internal mutating func endCOWMutation() {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    _native.isImmutable = true
#endif
    _storage.endCOWMutation()
  }
  @inlinable
  internal func _asCocoaArray() -> AnyObject {
    return _fastPath(_isNative) ? _native._asCocoaArray() : _nonNative.buffer
  }
  @inline(never)
  internal __consuming func _consumeAndCreateNew() -> _ArrayBuffer {
    return _consumeAndCreateNew(bufferIsUnique: false,
                                minimumCapacity: count,
                                growForAppend: false)
  }
  @inline(never)
  internal __consuming func _consumeAndCreateNew(
    bufferIsUnique: Bool, minimumCapacity: Int, growForAppend: Bool
  ) -> _ArrayBuffer {
    let newCapacity = _growArrayCapacity(oldCapacity: capacity,
                                         minimumCapacity: minimumCapacity,
                                         growForAppend: growForAppend)
    let c = count
    _internalInvariant(newCapacity >= c)
    let newBuffer = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: c, minimumCapacity: newCapacity)
    if bufferIsUnique {
      let dest = newBuffer.firstElementAddress
      dest.moveInitialize(from: mutableFirstElementAddress,
                          count: c)
      _native.mutableCount = 0
    } else {
      _copyContents(
        subRange: 0..<c,
        initializing: newBuffer.mutableFirstElementAddress)
    }
    return _ArrayBuffer(_buffer: newBuffer, shiftedToStartIndex: 0)
  }
  @inlinable
  internal mutating func requestUniqueMutableBackingBuffer(minimumCapacity: Int)
  -> NativeBuffer? {
    if _fastPath(isUniquelyReferenced()) {
      let b = _native
      if _fastPath(b.mutableCapacity >= minimumCapacity) {
        return b
      }
    }
    return nil
  }
  @inlinable
  internal mutating func isMutableAndUniquelyReferenced() -> Bool {
    return isUniquelyReferenced()
  }
  @inlinable
  internal func requestNativeBuffer() -> NativeBuffer? {
    if !_isClassOrObjCExistential(Element.self) {
      return _native
    }
    return _fastPath(_storage.isNative) ? _native : nil
  }
  @inline(never)
  @usableFromInline
  internal func _typeCheckSlowPath(_ index: Int) {
    if _fastPath(_isNative) {
      let element: AnyObject = cast(toBufferOf: AnyObject.self)._native[index]
      guard element is Element else {
        _assertionFailure(
          "Fatal error",
          """
          Down-casted Array element failed to match the target type
          Expected \(Element.self) but found \(type(of: element))
          """,
          flags: _fatalErrorFlags()
        )
      }
    }
    else {
      let element = _nonNative[index]
      guard element is Element else {
        _assertionFailure(
          "Fatal error",
          """
          NSArray element failed to match the Swift Array Element type
          Expected \(Element.self) but found \(type(of: element))
          """,
          flags: _fatalErrorFlags()
        )
      }
    }
  }
  @inlinable
  internal func _typeCheck(_ subRange: Range<Int>) {
    if !_isClassOrObjCExistential(Element.self) {
      return
    }
    if _slowPath(needsElementTypeCheck) {
      for i in subRange.lowerBound ..< subRange.upperBound {
        _typeCheckSlowPath(i)
      }
    }
  }
  @inlinable
  @discardableResult
  __consuming internal func _copyContents(
    subRange bounds: Range<Int>,
    initializing target: UnsafeMutablePointer<Element>
  ) -> UnsafeMutablePointer<Element> {
    _typeCheck(bounds)
    if _fastPath(_isNative) {
      return _native._copyContents(subRange: bounds, initializing: target)
    }
    let buffer = UnsafeMutableRawPointer(target)
      .assumingMemoryBound(to: AnyObject.self)
    let result = _nonNative._copyContents(
      subRange: bounds,
      initializing: buffer)
    return UnsafeMutableRawPointer(result).assumingMemoryBound(to: Element.self)
  }
  @inlinable
  internal __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    if _fastPath(_isNative) {
      let (_, c) = _native._copyContents(initializing: buffer)
      return (IndexingIterator(_elements: self, _position: c), c)
    }
    guard buffer.count > 0 else { return (makeIterator(), 0) }
    let ptr = UnsafeMutableRawPointer(buffer.baseAddress)?
      .assumingMemoryBound(to: AnyObject.self)
    let (_, c) = _nonNative._copyContents(
      initializing: UnsafeMutableBufferPointer(start: ptr, count: buffer.count))
    return (IndexingIterator(_elements: self, _position: c), c)
  }
  @inlinable
  internal subscript(bounds: Range<Int>) -> _SliceBuffer<Element> {
    get {
      _typeCheck(bounds)
      if _fastPath(_isNative) {
        return _native[bounds]
      }
      return _nonNative[bounds].unsafeCastElements(to: Element.self)
    }
    set {
      fatalError("not implemented")
    }
  }
  @inlinable
  internal var firstElementAddress: UnsafeMutablePointer<Element> {
    _internalInvariant(_isNative, "must be a native buffer")
    return _native.firstElementAddress
  }
  internal var mutableFirstElementAddress: UnsafeMutablePointer<Element> {
    _internalInvariant(_isNative, "must be a native buffer")
    return _native.mutableFirstElementAddress
  }
  @inlinable
  internal var firstElementAddressIfContiguous: UnsafeMutablePointer<Element>? {
    return _fastPath(_isNative) ? firstElementAddress : nil
  }
  @inlinable
  internal var count: Int {
    @inline(__always)
    get {
      return _fastPath(_isNative) ? _native.count : _nonNative.endIndex
    }
    set {
      _internalInvariant(_isNative, "attempting to update count of Cocoa array")
      _native.count = newValue
    }
  }
  internal var immutableCount: Int {
    return _fastPath(_isNative) ? _native.immutableCount : _nonNative.endIndex
  }
  internal var mutableCount: Int {
    @inline(__always)
    get {
      _internalInvariant(
        _isNative,
        "attempting to get mutating-count of non-native buffer")
      return _native.mutableCount
    }
    @inline(__always)
    set {
      _internalInvariant(_isNative, "attempting to update count of Cocoa array")
      _native.mutableCount = newValue
    }
  }
  @inlinable
  internal func _checkInoutAndNativeBounds(_ index: Int, wasNative: Bool) {
    _precondition(
      _isNative == wasNative,
      "inout rules were violated: the array was overwritten")
    if _fastPath(wasNative) {
      _native._checkValidSubscript(index)
    }
  }
  @inlinable
  internal func _checkInoutAndNativeTypeCheckedBounds(
    _ index: Int, wasNativeTypeChecked: Bool
  ) {
    _precondition(
      _isNativeTypeChecked == wasNativeTypeChecked,
      "inout rules were violated: the array was overwritten")
    if _fastPath(wasNativeTypeChecked) {
      _native._checkValidSubscript(index)
    }
  }
  internal func _checkValidSubscriptMutating(_ index: Int) {
    _native._checkValidSubscriptMutating(index)
  }
  @inlinable
  internal var capacity: Int {
    return _fastPath(_isNative) ? _native.capacity : _nonNative.endIndex
  }
  internal var immutableCapacity: Int {
    return _fastPath(_isNative) ? _native.immutableCapacity : _nonNative.count
  }
  internal var mutableCapacity: Int {
    _internalInvariant(_isNative, "attempting to get mutating-capacity of non-native buffer")
    return _native.mutableCapacity
  }
  @inlinable
  @inline(__always)
  internal func getElement(_ i: Int, wasNativeTypeChecked: Bool) -> Element {
    if _fastPath(wasNativeTypeChecked) {
      return _nativeTypeChecked[i]
    }
    return unsafeBitCast(_getElementSlowPath(i), to: Element.self)
  }
  @inline(never)
  @inlinable 
  internal func _getElementSlowPath(_ i: Int) -> AnyObject {
    _internalInvariant(
      _isClassOrObjCExistential(Element.self),
      "Only single reference elements can be indexed here.")
    let element: AnyObject
    if _isNative {
      _native._checkValidSubscript(i)
      element = cast(toBufferOf: AnyObject.self)._native[i]
      guard element is Element else {
        _assertionFailure(
          "Fatal error",
          """
          Down-casted Array element failed to match the target type
          Expected \(Element.self) but found \(type(of: element))
          """,
          flags: _fatalErrorFlags()
        )
      }
    } else {
      element = _nonNative[i]
      guard element is Element else {
        _assertionFailure(
          "Fatal error",
          """
          NSArray element failed to match the Swift Array Element type
          Expected \(Element.self) but found \(type(of: element))
          """,
          flags: _fatalErrorFlags()
        )
      }
    }
    return element
  }
  @inlinable
  internal subscript(i: Int) -> Element {
    get {
      return getElement(i, wasNativeTypeChecked: _isNativeTypeChecked)
    }
    nonmutating set {
      if _fastPath(_isNative) {
        _native[i] = newValue
      }
      else {
        var refCopy = self
        refCopy.replaceSubrange(
          i..<(i + 1),
          with: 1,
          elementsOf: CollectionOfOne(newValue))
      }
    }
  }
  @inlinable
  internal func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    if _fastPath(_isNative) {
      defer { _fixLifetime(self) }
      return try body(
        UnsafeBufferPointer(start: firstElementAddress, count: count))
    }
    return try ContiguousArray(self).withUnsafeBufferPointer(body)
  }
  @inlinable
  internal mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    _internalInvariant(
      _isNative || count == 0,
      "Array is bridging an opaque NSArray; can't get a pointer to the elements"
    )
    defer { _fixLifetime(self) }
    return try body(UnsafeMutableBufferPointer(
      start: firstElementAddressIfContiguous, count: count))
  }
  @inlinable
  internal var owner: AnyObject {
    return _fastPath(_isNative) ? _native._storage : _nonNative.buffer
  }
  @inlinable
  internal var nativeOwner: AnyObject {
    _internalInvariant(_isNative, "Expect a native array")
    return _native._storage
  }
  @inlinable
  internal var identity: UnsafeRawPointer {
    if _isNative {
      return _native.identity
    }
    else {
      return UnsafeRawPointer(
        Unmanaged.passUnretained(_nonNative.buffer).toOpaque())
    }
  }
  @inlinable
  internal var startIndex: Int {
    return 0
  }
  @inlinable
  internal var endIndex: Int {
    return count
  }
  @usableFromInline
  internal typealias Indices = Range<Int>
  internal typealias Storage = _ContiguousArrayStorage<Element>
  @usableFromInline
  internal typealias NativeBuffer = _ContiguousArrayBuffer<Element>
  @inlinable
  internal var _isNative: Bool {
    if !_isClassOrObjCExistential(Element.self) {
      return true
    } else {
      return _storage.isNative
    }
  }
  @inlinable
  internal var _isNativeTypeChecked: Bool {
    if !_isClassOrObjCExistential(Element.self) {
      return true
    } else {
      return _storage.isUnflaggedNative
    }
  }
  @inlinable
  internal var _native: NativeBuffer {
    return NativeBuffer(
      _isClassOrObjCExistential(Element.self)
      ? _storage.nativeInstance : _storage.unflaggedNativeInstance)
  }
  @inlinable
  internal var _nativeTypeChecked: NativeBuffer {
    return NativeBuffer(_storage.unflaggedNativeInstance)
  }
  @inlinable
  internal var _nonNative: _CocoaArrayWrapper {
    get {
      _internalInvariant(_isClassOrObjCExistential(Element.self))
      return _CocoaArrayWrapper(_storage.objCInstance)
    }
  }
}
extension _ArrayBuffer: @unchecked Sendable
  where Element: Sendable { }
#endif
