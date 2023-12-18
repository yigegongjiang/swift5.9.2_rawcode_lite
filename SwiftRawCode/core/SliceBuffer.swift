@frozen
@usableFromInline
internal struct _SliceBuffer<Element>
  : _ArrayBufferProtocol,
    RandomAccessCollection
{
  internal typealias NativeStorage = _ContiguousArrayStorage<Element>
  @usableFromInline
  internal typealias NativeBuffer = _ContiguousArrayBuffer<Element>
  @usableFromInline
  internal var owner: AnyObject
  @usableFromInline
  internal let subscriptBaseAddress: UnsafeMutablePointer<Element>
  @usableFromInline
  internal var startIndex: Int
  @usableFromInline
  internal var endIndexAndFlags: UInt
  @inlinable
  internal init(
    owner: AnyObject,
    subscriptBaseAddress: UnsafeMutablePointer<Element>,
    startIndex: Int,
    endIndexAndFlags: UInt
  ) {
    self.owner = owner
    self.subscriptBaseAddress = subscriptBaseAddress
    self.startIndex = startIndex
    self.endIndexAndFlags = endIndexAndFlags
  }
  @inlinable
  internal init(
    owner: AnyObject, subscriptBaseAddress: UnsafeMutablePointer<Element>,
    indices: Range<Int>, hasNativeBuffer: Bool
  ) {
    self.owner = owner
    self.subscriptBaseAddress = subscriptBaseAddress
    self.startIndex = indices.lowerBound
    let bufferFlag = UInt(hasNativeBuffer ? 1 : 0)
    self.endIndexAndFlags = (UInt(indices.upperBound) << 1) | bufferFlag
    _invariantCheck()
  }
  @inlinable
  internal init() {
    let empty = _ContiguousArrayBuffer<Element>()
    self.owner = empty.owner
    self.subscriptBaseAddress = empty.firstElementAddress
    self.startIndex = empty.startIndex
    self.endIndexAndFlags = 1
    _invariantCheck()
  }
  @inlinable
  internal init(_buffer buffer: NativeBuffer, shiftedToStartIndex: Int) {
    let shift = buffer.startIndex - shiftedToStartIndex
    self.init(
      owner: buffer.owner,
      subscriptBaseAddress: buffer.subscriptBaseAddress + shift,
      indices: shiftedToStartIndex..<shiftedToStartIndex + buffer.count,
      hasNativeBuffer: true)
  }
  @inlinable 
  internal func _invariantCheck() {
    let isNative = _hasNativeBuffer
    let isNativeStorage: Bool = owner is __ContiguousArrayStorageBase
    _internalInvariant(isNativeStorage == isNative)
    if isNative {
      _internalInvariant(count <= nativeBuffer.count)
    }
  }
  @inlinable
  internal var _hasNativeBuffer: Bool {
    return (endIndexAndFlags & 1) != 0
  }
  @inlinable
  internal var nativeBuffer: NativeBuffer {
    _internalInvariant(_hasNativeBuffer)
    return NativeBuffer(
      owner as? __ContiguousArrayStorageBase ?? _emptyArrayStorage)
  }
  @inlinable
  internal var nativeOwner: AnyObject {
    _internalInvariant(_hasNativeBuffer, "Expect a native array")
    return owner
  }
  @inlinable
  internal mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with insertCount: Int,
    elementsOf newValues: __owned C
  ) where C: Collection, C.Element == Element {
    _invariantCheck()
    _internalInvariant(insertCount <= newValues.count)
    _internalInvariant(_hasNativeBuffer)
    _internalInvariant(isUniquelyReferenced())
    let eraseCount = subrange.count
    let growth = insertCount - eraseCount
    let oldCount = count
    var native = nativeBuffer
    let hiddenElementCount = firstElementAddress - native.firstElementAddress
    _internalInvariant(native.count + growth <= native.capacity)
    let start = subrange.lowerBound - startIndex + hiddenElementCount
    let end = subrange.upperBound - startIndex + hiddenElementCount
    native.replaceSubrange(
      start..<end,
      with: insertCount,
      elementsOf: newValues)
    self.endIndex = self.startIndex + oldCount + growth
    _invariantCheck()
  }
  @inlinable
  internal var identity: UnsafeRawPointer {
    return UnsafeRawPointer(firstElementAddress)
  }
  @inlinable
  internal var firstElementAddress: UnsafeMutablePointer<Element> {
    return subscriptBaseAddress + startIndex
  }
  @inlinable
  internal var firstElementAddressIfContiguous: UnsafeMutablePointer<Element>? {
    return firstElementAddress
  }
  @inlinable
  internal mutating func requestUniqueMutableBackingBuffer(
    minimumCapacity: Int
  ) -> NativeBuffer? {
    _invariantCheck()
    if _fastPath(isUniquelyReferenced()) {
      if capacity >= minimumCapacity {
        var native = nativeBuffer
        let offset = self.firstElementAddress - native.firstElementAddress
        let backingCount = native.count
        let myCount = count
        if _slowPath(backingCount > myCount + offset) {
          native.replaceSubrange(
            (myCount+offset)..<backingCount,
            with: 0,
            elementsOf: EmptyCollection())
        }
        _invariantCheck()
        return native
      }
    }
    return nil
  }
  @inlinable
  internal mutating func isMutableAndUniquelyReferenced() -> Bool {
    if !_hasNativeBuffer {
      return false
    }
    return isUniquelyReferenced()
  }
  @inlinable
  internal func requestNativeBuffer() -> _ContiguousArrayBuffer<Element>? {
    _invariantCheck()
    if _fastPath(_hasNativeBuffer && nativeBuffer.count == count) {
      return nativeBuffer
    }
    return nil
  }
  @inlinable
  @discardableResult
  internal __consuming func _copyContents(
    subRange bounds: Range<Int>,
    initializing target: UnsafeMutablePointer<Element>
  ) -> UnsafeMutablePointer<Element> {
    _invariantCheck()
    _internalInvariant(bounds.lowerBound >= startIndex)
    _internalInvariant(bounds.upperBound >= bounds.lowerBound)
    _internalInvariant(bounds.upperBound <= endIndex)
    let c = bounds.count
    target.initialize(from: subscriptBaseAddress + bounds.lowerBound, count: c)
    return target + c
  }
  @inlinable
  internal __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    _invariantCheck()
    guard buffer.count > 0 else { return (makeIterator(), 0) }
    let c = Swift.min(self.count, buffer.count)
    buffer.baseAddress!.initialize(
      from: firstElementAddress,
      count: c)
    _fixLifetime(owner)
    return (IndexingIterator(_elements: self, _position: startIndex + c), c)
  }
  @inlinable
  internal var arrayPropertyIsNativeTypeChecked: Bool {
    return _hasNativeBuffer
  }
  @inlinable
  internal var count: Int {
    get {
      return endIndex - startIndex
    }
    set {
      let growth = newValue - count
      if growth != 0 {
        nativeBuffer.mutableCount += growth
        self.endIndex += growth
      }
      _invariantCheck()
    }
  }
  @inlinable
  internal func _checkValidSubscript(_ index: Int) {
    _precondition(
      index >= startIndex && index < endIndex, "Index out of bounds")
  }
  @inlinable
  internal var capacity: Int {
    let count = self.count
    if _slowPath(!_hasNativeBuffer) {
      return count
    }
    let n = nativeBuffer
    let nativeEnd = n.firstElementAddress + n.count
    if (firstElementAddress + count) == nativeEnd {
      return count + (n.capacity - n.count)
    }
    return count
  }
  @inlinable
  internal mutating func isUniquelyReferenced() -> Bool {
    return isKnownUniquelyReferenced(&owner)
  }
  internal mutating func beginCOWMutation() -> Bool {
    if !_hasNativeBuffer {
      return false
    }
    if Bool(Builtin.beginCOWMutation(&owner)) {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
      nativeBuffer.isImmutable = false
#endif
      return true
    }
    return false;
  }
  @inline(__always)
  internal mutating func endCOWMutation() {
#if INTERNAL_CHECKS_ENABLED && COW_CHECKS_ENABLED
    nativeBuffer.isImmutable = true
#endif
    Builtin.endCOWMutation(&owner)
  }
  @inlinable
  internal func getElement(_ i: Int) -> Element {
    _internalInvariant(i >= startIndex, "slice index is out of range (before startIndex)")
    _internalInvariant(i < endIndex, "slice index is out of range")
    return subscriptBaseAddress[i]
  }
  @inlinable
  internal subscript(position: Int) -> Element {
    get {
      return getElement(position)
    }
    nonmutating set {
      _internalInvariant(position >= startIndex, "slice index is out of range (before startIndex)")
      _internalInvariant(position < endIndex, "slice index is out of range")
      subscriptBaseAddress[position] = newValue
    }
  }
  @inlinable
  internal subscript(bounds: Range<Int>) -> _SliceBuffer {
    get {
      _internalInvariant(bounds.lowerBound >= startIndex)
      _internalInvariant(bounds.upperBound >= bounds.lowerBound)
      _internalInvariant(bounds.upperBound <= endIndex)
      return _SliceBuffer(
        owner: owner,
        subscriptBaseAddress: subscriptBaseAddress,
        indices: bounds,
        hasNativeBuffer: _hasNativeBuffer)
    }
    set {
      fatalError("not implemented")
    }
  }
  @inlinable
  internal var endIndex: Int {
    get {
      return Int(endIndexAndFlags >> 1)
    }
    set {
      endIndexAndFlags = (UInt(newValue) << 1) | (_hasNativeBuffer ? 1 : 0)
    }
  }
  @usableFromInline
  internal typealias Indices = Range<Int>
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
  internal func unsafeCastElements<T>(to type: T.Type) -> _SliceBuffer<T> {
    _internalInvariant(_isClassOrObjCExistential(T.self))
    let baseAddress = UnsafeMutableRawPointer(self.subscriptBaseAddress)
      .assumingMemoryBound(to: T.self)
    return _SliceBuffer<T>(
      owner: self.owner,
      subscriptBaseAddress: baseAddress,
      startIndex: self.startIndex,
      endIndexAndFlags: self.endIndexAndFlags)
  }
}
extension _SliceBuffer {
  @inlinable
  internal __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    if _hasNativeBuffer {
      let n = nativeBuffer
      if count == n.count {
        return ContiguousArray(_buffer: n)
      }
    }
    let result = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: count,
      minimumCapacity: 0)
    result.firstElementAddress.initialize(
      from: firstElementAddress, count: count)
    return ContiguousArray(_buffer: result)
  }
}
