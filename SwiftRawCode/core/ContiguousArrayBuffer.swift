import SwiftShims
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
public func _COWChecksEnabled() -> Bool
#endif
@usableFromInline
internal final class __EmptyArrayStorage
  : __ContiguousArrayStorageBase {
  @inlinable
  @nonobjc
  internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("creating instance of __EmptyArrayStorage")
  }
#if _runtime(_ObjC)
  override internal func _withVerbatimBridgedUnsafeBuffer<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R? {
    return try body(UnsafeBufferPointer(start: nil, count: 0))
  }
  override internal func _getNonVerbatimBridgingBuffer() -> _BridgingBuffer {
    return _BridgingBuffer(0)
  }
#endif
  @inlinable
  override internal func canStoreElements(ofDynamicType _: Any.Type) -> Bool {
    return false
  }
  @inlinable
  override internal var staticElementType: Any.Type {
    return Void.self
  }
}
@inlinable
internal var _emptyArrayStorage: __EmptyArrayStorage {
  return Builtin.bridgeFromRawPointer(
    Builtin.addressof(&_swiftEmptyArrayStorage))
}
@usableFromInline
internal final class _ContiguousArrayStorage<
  Element
>: __ContiguousArrayStorageBase {
  @inlinable
  deinit {
    _elementPointer.deinitialize(count: countAndCapacity.count)
    _fixLifetime(self)
  }
#if _runtime(_ObjC)
  internal final override func withUnsafeBufferOfObjects<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R {
    _internalInvariant(_isBridgedVerbatimToObjectiveC(Element.self))
    let count = countAndCapacity.count
    let elements = UnsafeRawPointer(_elementPointer)
      .assumingMemoryBound(to: AnyObject.self)
    defer { _fixLifetime(self) }
    return try body(UnsafeBufferPointer(start: elements, count: count))
  }
  @objc(countByEnumeratingWithState:objects:count:)
  internal final override func countByEnumerating(
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
  final override internal func objectAtSubscript(_ index: Int) -> Unmanaged<AnyObject> {
    return _objectAt(index)
  }
  @objc(objectAtIndex:)
  final override internal func objectAt(_ index: Int) -> Unmanaged<AnyObject> {
    return _objectAt(index)
  }
  @objc internal override final var count: Int {
      return withUnsafeBufferOfObjects { $0.count }
    }
  }
  @objc internal override final func getObjects(
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
  internal final override func _withVerbatimBridgedUnsafeBuffer<R>(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> R
  ) rethrows -> R? {
    var result: R?
    try self._withVerbatimBridgedUnsafeBufferImpl {
      result = try body($0)
    }
    return result
  }
  internal final func _withVerbatimBridgedUnsafeBufferImpl(
    _ body: (UnsafeBufferPointer<AnyObject>) throws -> Void
  ) rethrows {
    if _isBridgedVerbatimToObjectiveC(Element.self) {
      let count = countAndCapacity.count
      let elements = UnsafeRawPointer(_elementPointer)
        .assumingMemoryBound(to: AnyObject.self)
      defer { _fixLifetime(self) }
      try body(UnsafeBufferPointer(start: elements, count: count))
    }
  }
  override internal func _getNonVerbatimBridgingBuffer() -> _BridgingBuffer {
    _internalInvariant(
      !_isBridgedVerbatimToObjectiveC(Element.self),
      "Verbatim bridging should be handled separately")
    let count = countAndCapacity.count
    let result = _BridgingBuffer(count)
    let resultPtr = result.baseAddress
    let p = _elementPointer
    for i in 0..<count {
      (resultPtr + i).initialize(to: _bridgeAnythingToObjectiveC(p[i]))
    }
    _fixLifetime(self)
    return result
  }
#endif
  @inlinable
  internal override func canStoreElements(
    ofDynamicType proposedElementType: Any.Type
  ) -> Bool {
#if _runtime(_ObjC)
    return proposedElementType is Element.Type
#else
    return false
#endif
  }
  @inlinable
  internal override var staticElementType: Any.Type {
    return Element.self
  }
  @inlinable
  internal final var _elementPointer: UnsafeMutablePointer<Element> {
    return UnsafeMutablePointer(Builtin.projectTailElems(self, Element.self))
  }
}
@inline(__always)
internal func _uncheckedUnsafeBitCast<T, U>(_ x: T, to type: U.Type) -> U {
  return Builtin.reinterpretCast(x)
}
@inline(never)
func getContiguousArrayStorageType<Element>(
  for: Element.Type
) -> _ContiguousArrayStorage<Element>.Type {
    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) { 
      if Element.self is AnyObject.Type {
        return _uncheckedUnsafeBitCast(
          _ContiguousArrayStorage<AnyObject>.self,
          to: _ContiguousArrayStorage<Element>.Type.self)
      }
    }
    return _ContiguousArrayStorage<Element>.self
}
@usableFromInline
@frozen
internal struct _ContiguousArrayBuffer<Element>: _ArrayBufferProtocol {
  @usableFromInline
  internal var _storage: __ContiguousArrayStorageBase
  @inlinable
  internal init(
    _uninitializedCount uninitializedCount: Int,
    minimumCapacity: Int
  ) {
    let realMinimumCapacity = Swift.max(uninitializedCount, minimumCapacity)
    if realMinimumCapacity == 0 {
      self = _ContiguousArrayBuffer<Element>()
    }
    else {
      _storage = Builtin.allocWithTailElems_1(
         getContiguousArrayStorageType(for: Element.self),
         realMinimumCapacity._builtinWordValue, Element.self)
      let storageAddr = UnsafeMutableRawPointer(Builtin.bridgeToRawPointer(_storage))
      if let allocSize = _mallocSize(ofAllocation: storageAddr) {
        let endAddr = storageAddr + allocSize
        let realCapacity = endAddr.assumingMemoryBound(to: Element.self) - firstElementAddress
        _initStorageHeader(
          count: uninitializedCount, capacity: realCapacity)
      } else {
        _initStorageHeader(
          count: uninitializedCount, capacity: realMinimumCapacity)
      }
    }
  }
  @inlinable
  internal init(count: Int, storage: _ContiguousArrayStorage<Element>) {
    _storage = storage
    _initStorageHeader(count: count, capacity: count)
  }
  @inlinable
  internal init(_ storage: __ContiguousArrayStorageBase) {
    _storage = storage
  }
  @inlinable
  internal func _initStorageHeader(count: Int, capacity: Int) {
#if _runtime(_ObjC)
    let verbatim = _isBridgedVerbatimToObjectiveC(Element.self)
#else
    let verbatim = false
#endif
    _storage.countAndCapacity = _ArrayBody(
      count: count,
      capacity: capacity,
      elementTypeIsBridgedVerbatim: verbatim)
  }
  @inlinable
  internal var arrayPropertyIsNativeTypeChecked: Bool {
    return true
  }
  @inlinable
  internal var firstElementAddress: UnsafeMutablePointer<Element> {
    return UnsafeMutablePointer(Builtin.projectTailElems(_storage,
                                                         Element.self))
  }
  internal var mutableFirstElementAddress: UnsafeMutablePointer<Element> {
    return UnsafeMutablePointer(Builtin.projectTailElems(mutableOrEmptyStorage,
                                                         Element.self))
  }
  @inlinable
  internal var firstElementAddressIfContiguous: UnsafeMutablePointer<Element>? {
    return firstElementAddress
  }
  @inlinable
  internal func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    defer { _fixLifetime(self) }
    return try body(UnsafeBufferPointer(start: firstElementAddress,
      count: count))
  }
  @inlinable
  internal mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    defer { _fixLifetime(self) }
    return try body(
      UnsafeMutableBufferPointer(start: firstElementAddress, count: count))
  }
  @inlinable
  internal init() {
    _storage = _emptyArrayStorage
  }
  @inlinable
  internal init(_buffer buffer: _ContiguousArrayBuffer, shiftedToStartIndex: Int) {
    _internalInvariant(shiftedToStartIndex == 0, "shiftedToStartIndex must be 0")
    self = buffer
  }
  @inlinable
  internal mutating func requestUniqueMutableBackingBuffer(
    minimumCapacity: Int
  ) -> _ContiguousArrayBuffer<Element>? {
    if _fastPath(isUniquelyReferenced() && capacity >= minimumCapacity) {
      return self
    }
    return nil
  }
  @inlinable
  internal mutating func isMutableAndUniquelyReferenced() -> Bool {
    return isUniquelyReferenced()
  }
  @inlinable
  internal func requestNativeBuffer() -> _ContiguousArrayBuffer<Element>? {
    return self
  }
  @inlinable
  @inline(__always)
  internal func getElement(_ i: Int) -> Element {
    _internalInvariant(i >= 0 && i < count, "Array index out of range")
    let addr = UnsafePointer<Element>(
      Builtin.projectTailElems(immutableStorage, Element.self))
    return addr[i]
  }
  @inline(__always)
  internal var immutableStorage : __ContiguousArrayStorageBase {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    _internalInvariant(isImmutable, "Array storage is not immutable")
#endif
    return Builtin.COWBufferForReading(_storage)
  }
  @inline(__always)
  internal var mutableStorage : __ContiguousArrayStorageBase {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    _internalInvariant(isMutable, "Array storage is immutable")
#endif
    return _storage
  }
  @inline(__always)
  internal var mutableOrEmptyStorage : __ContiguousArrayStorageBase {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    _internalInvariant(isMutable || _storage.countAndCapacity.capacity == 0,
                       "Array storage is immutable and not empty")
#endif
    return _storage
  }
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
  internal var isImmutable: Bool {
    get {
      if (_COWChecksEnabled()) {
        return capacity == 0 || _swift_isImmutableCOWBuffer(_storage)
      }
      return true
    }
    nonmutating set {
      if (_COWChecksEnabled()) {
        if capacity > 0 {
          let wasImmutable = _swift_setImmutableCOWBuffer(_storage, newValue)
          if newValue {
            _internalInvariant(!wasImmutable,
              "re-setting immutable array buffer to immutable")
          } else {
            _internalInvariant(wasImmutable,
              "re-setting mutable array buffer to mutable")
          }
        }
      }
    }
  }
  internal var isMutable: Bool {
    if (_COWChecksEnabled()) {
      return !_swift_isImmutableCOWBuffer(_storage)
    }
    return true
  }
#endif
  @inlinable
  internal subscript(i: Int) -> Element {
    @inline(__always)
    get {
      return getElement(i)
    }
    @inline(__always)
    nonmutating set {
      _internalInvariant(i >= 0 && i < count, "Array index out of range")
      var nv = newValue
      let tmp = nv
      nv = firstElementAddress[i]
      firstElementAddress[i] = tmp
    }
  }
  @inlinable
  internal var count: Int {
    get {
      return _storage.countAndCapacity.count
    }
    nonmutating set {
      _internalInvariant(newValue >= 0)
      _internalInvariant(
        newValue <= mutableCapacity,
        "Can't grow an array buffer past its capacity")
      mutableStorage.countAndCapacity.count = newValue
    }
  }
  @inline(__always)
  internal var immutableCount: Int {
    return immutableStorage.countAndCapacity.count
  }
  internal var mutableCount: Int {
    @inline(__always)
    get {
      return mutableOrEmptyStorage.countAndCapacity.count
    }
    @inline(__always)
    nonmutating set {
      _internalInvariant(newValue >= 0)
      _internalInvariant(
        newValue <= mutableCapacity,
        "Can't grow an array buffer past its capacity")
      mutableStorage.countAndCapacity.count = newValue
    }
  }
  @inlinable
  @inline(__always)
  internal func _checkValidSubscript(_ index: Int) {
    _precondition(
      (index >= 0) && (index < immutableCount),
      "Index out of range"
    )
  }
  @inline(__always)
  internal func _checkValidSubscriptMutating(_ index: Int) {
    _precondition(
      (index >= 0) && (index < mutableCount),
      "Index out of range"
    )
  }
  @inlinable
  internal var capacity: Int {
    return _storage.countAndCapacity.capacity
  }
  @inline(__always)
  internal var immutableCapacity: Int {
    return immutableStorage.countAndCapacity.capacity
  }
  @inline(__always)
  internal var mutableCapacity: Int {
    return mutableOrEmptyStorage.countAndCapacity.capacity
  }
  @inlinable
  @discardableResult
  internal __consuming func _copyContents(
    subRange bounds: Range<Int>,
    initializing target: UnsafeMutablePointer<Element>
  ) -> UnsafeMutablePointer<Element> {
    _internalInvariant(bounds.lowerBound >= 0)
    _internalInvariant(bounds.upperBound >= bounds.lowerBound)
    _internalInvariant(bounds.upperBound <= count)
    let initializedCount = bounds.upperBound - bounds.lowerBound
    target.initialize(
      from: firstElementAddress + bounds.lowerBound, count: initializedCount)
    _fixLifetime(owner)
    return target + initializedCount
  }
  @inlinable
  internal __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    guard buffer.count > 0 else { return (makeIterator(), 0) }
    let c = Swift.min(self.count, buffer.count)
    buffer.baseAddress!.initialize(
      from: firstElementAddress,
      count: c)
    _fixLifetime(owner)
    return (IndexingIterator(_elements: self, _position: c), c)
  }
  @inlinable
  internal subscript(bounds: Range<Int>) -> _SliceBuffer<Element> {
    get {
      return _SliceBuffer(
        owner: _storage,
        subscriptBaseAddress: firstElementAddress,
        indices: bounds,
        hasNativeBuffer: true)
    }
    set {
      fatalError("not implemented")
    }
  }
  @inlinable
  internal mutating func isUniquelyReferenced() -> Bool {
    return _isUnique(&_storage)
  }
  internal mutating func beginCOWMutation() -> Bool {
    if Bool(Builtin.beginCOWMutation(&_storage)) {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
      isImmutable = false
#endif
      return true
    }
    return false;
  }
  @inline(__always)
  internal mutating func endCOWMutation() {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    isImmutable = true
#endif
    Builtin.endCOWMutation(&_storage)
  }
  @inline(never)
  internal __consuming func _consumeAndCreateNew() -> _ContiguousArrayBuffer {
    return _consumeAndCreateNew(bufferIsUnique: false,
                                minimumCapacity: count,
                                growForAppend: false)
  }
  @inline(never)
  internal __consuming func _consumeAndCreateNew(
    bufferIsUnique: Bool, minimumCapacity: Int, growForAppend: Bool
  ) -> _ContiguousArrayBuffer {
    let newCapacity = _growArrayCapacity(oldCapacity: capacity,
                                         minimumCapacity: minimumCapacity,
                                         growForAppend: growForAppend)
    let c = count
    _internalInvariant(newCapacity >= c)
    let newBuffer = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: c, minimumCapacity: newCapacity)
    if bufferIsUnique {
      let dest = newBuffer.mutableFirstElementAddress
      dest.moveInitialize(from: firstElementAddress,
                          count: c)
      mutableCount = 0
    } else {
      _copyContents(
        subRange: 0..<c,
        initializing: newBuffer.mutableFirstElementAddress)
    }
    return newBuffer
  }
#if _runtime(_ObjC)
  @usableFromInline
  internal __consuming func _asCocoaArray() -> AnyObject {
    _connectOrphanedFoundationSubclassesIfNeeded()
    if count == 0 {
      return _emptyArrayStorage
    }
    if _isBridgedVerbatimToObjectiveC(Element.self) {
      if #available(SwiftStdlib 5.7, *) {
        _ = _swift_setClassMetadata(_ContiguousArrayStorage<Element>.self,
                                    onObject: _storage)
      }
      return _storage
    }
    return __SwiftDeferredNSArray(_nativeStorage: _storage)
  }
#endif
  @inlinable
  internal var owner: AnyObject {
    return _storage
  }
  @inlinable
  internal var nativeOwner: AnyObject {
    return _storage
  }
  @inlinable
  internal var identity: UnsafeRawPointer {
    return UnsafeRawPointer(firstElementAddress)
  }
  @inlinable
  func canStoreElements(ofDynamicType proposedElementType: Any.Type) -> Bool {
    return _storage.canStoreElements(ofDynamicType: proposedElementType)
  }
  @inlinable
  internal func storesOnlyElementsOfType<U>(
    _: U.Type
  ) -> Bool {
    _internalInvariant(_isClassOrObjCExistential(U.self))
    if _fastPath(_storage.staticElementType is U.Type) {
      return true
    }
    for x in self {
      if !(x is U) {
        return false
      }
    }
    return true
  }
}
@inlinable
internal func += <Element, C: Collection>(
  lhs: inout _ContiguousArrayBuffer<Element>, rhs: __owned C
) where C.Element == Element {
  let oldCount = lhs.count
  let newCount = oldCount + rhs.count
  let buf: UnsafeMutableBufferPointer<Element>
  if _fastPath(newCount <= lhs.capacity) {
    buf = UnsafeMutableBufferPointer(
      start: lhs.firstElementAddress + oldCount,
      count: rhs.count)
    lhs.mutableCount = newCount
  }
  else {
    var newLHS = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: newCount,
      minimumCapacity: _growArrayCapacity(lhs.capacity))
    newLHS.firstElementAddress.moveInitialize(
      from: lhs.firstElementAddress, count: oldCount)
    lhs.mutableCount = 0
    (lhs, newLHS) = (newLHS, lhs)
    buf = UnsafeMutableBufferPointer(
      start: lhs.firstElementAddress + oldCount,
      count: rhs.count)
  }
  var (remainders,writtenUpTo) = buf.initialize(from: rhs)
  _precondition(remainders.next() == nil, "rhs underreported its count")
  _precondition(writtenUpTo == buf.endIndex, "rhs overreported its count")    
}
extension _ContiguousArrayBuffer: RandomAccessCollection {
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
}
extension Sequence {
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return _copySequenceToContiguousArray(self)
  }
}
@inlinable
internal func _copySequenceToContiguousArray<
  S: Sequence
>(_ source: S) -> ContiguousArray<S.Element> {
  let initialCapacity = source.underestimatedCount
  var builder =
    _UnsafePartiallyInitializedContiguousArrayBuffer<S.Element>(
      initialCapacity: initialCapacity)
  var iterator = source.makeIterator()
  for _ in 0..<initialCapacity {
    builder.addWithExistingCapacity(iterator.next()!)
  }
  while let element = iterator.next() {
    builder.add(element)
  }
  return builder.finish()
}
extension Collection {
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return _copyCollectionToContiguousArray(self)
  }
}
extension _ContiguousArrayBuffer {
  @inlinable
  internal __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return ContiguousArray(_buffer: self)
  }
}
@inlinable
internal func _copyCollectionToContiguousArray<
  C: Collection
>(_ source: C) -> ContiguousArray<C.Element>
{
  let count = source.count
  if count == 0 {
    return ContiguousArray()
  }
  var result = _ContiguousArrayBuffer<C.Element>(
    _uninitializedCount: count,
    minimumCapacity: 0)
  let p = UnsafeMutableBufferPointer(
    start: result.firstElementAddress,
    count: count)
  var (itr, end) = source._copyContents(initializing: p)
  _debugPrecondition(itr.next() == nil,
    "invalid Collection: more than 'count' elements in collection")
  _precondition(end == p.endIndex,
    "invalid Collection: less than 'count' elements in collection")
  result.endCOWMutation()
  return ContiguousArray(_buffer: result)
}
@usableFromInline
@frozen
internal struct _UnsafePartiallyInitializedContiguousArrayBuffer<Element> {
  @usableFromInline
  internal var result: _ContiguousArrayBuffer<Element>
  @usableFromInline
  internal var p: UnsafeMutablePointer<Element>
  @usableFromInline
  internal var remainingCapacity: Int
  @inlinable
  @inline(__always) 
  internal init(initialCapacity: Int) {
    if initialCapacity == 0 {
      result = _ContiguousArrayBuffer()
    } else {
      result = _ContiguousArrayBuffer(
        _uninitializedCount: initialCapacity,
        minimumCapacity: 0)
    }
    p = result.firstElementAddress
    remainingCapacity = result.capacity
  }
  @inlinable
  @inline(__always) 
  internal mutating func add(_ element: Element) {
    if remainingCapacity == 0 {
      let newCapacity = max(_growArrayCapacity(result.capacity), 1)
      var newResult = _ContiguousArrayBuffer<Element>(
        _uninitializedCount: newCapacity, minimumCapacity: 0)
      p = newResult.firstElementAddress + result.capacity
      remainingCapacity = newResult.capacity - result.capacity
      if !result.isEmpty {
        newResult.firstElementAddress.moveInitialize(
          from: result.firstElementAddress, count: result.capacity)
        result.mutableCount = 0
      }
      (result, newResult) = (newResult, result)
    }
    addWithExistingCapacity(element)
  }
  @inlinable
  @inline(__always) 
  internal mutating func addWithExistingCapacity(_ element: Element) {
    _internalInvariant(remainingCapacity > 0,
      "_UnsafePartiallyInitializedContiguousArrayBuffer has no more capacity")
    remainingCapacity -= 1
    p.initialize(to: element)
    p += 1
  }
  @inlinable
  @inline(__always) 
  internal mutating func finish() -> ContiguousArray<Element> {
    if (result.capacity != 0) {
      result.mutableCount = result.capacity - remainingCapacity
    } else {
      _internalInvariant(remainingCapacity == 0)
      _internalInvariant(result.count == 0)      
    }
    return finishWithOriginalCount()
  }
  @inlinable
  @inline(__always) 
  internal mutating func finishWithOriginalCount() -> ContiguousArray<Element> {
    _internalInvariant(remainingCapacity == result.capacity - result.count,
      "_UnsafePartiallyInitializedContiguousArrayBuffer has incorrect count")
    var finalResult = _ContiguousArrayBuffer<Element>()
    (finalResult, result) = (result, finalResult)
    remainingCapacity = 0
    finalResult.endCOWMutation()
    return ContiguousArray(_buffer: finalResult)
  }
}
