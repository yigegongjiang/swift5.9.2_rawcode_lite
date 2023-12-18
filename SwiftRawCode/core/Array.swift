@frozen
public struct Array<Element>: _DestructorSafeContainer {
  #if _runtime(_ObjC)
  @usableFromInline
  internal typealias _Buffer = _ArrayBuffer<Element>
  #else
  @usableFromInline
  internal typealias _Buffer = _ContiguousArrayBuffer<Element>
  #endif
  @usableFromInline
  internal var _buffer: _Buffer
  @inlinable
  internal init(_buffer: _Buffer) {
    self._buffer = _buffer
  }
}
extension Array {
  @inlinable
  public 
  func _hoistableIsNativeTypeChecked() -> Bool {
   return _buffer.arrayPropertyIsNativeTypeChecked
  }
  @inlinable
  internal func _getCount() -> Int {
    return _buffer.immutableCount
  }
  @inlinable
  internal func _getCapacity() -> Int {
    return _buffer.immutableCapacity
  }
  @inlinable
  internal mutating func _makeMutableAndUnique() {
    if _slowPath(!_buffer.beginCOWMutation()) {
      _buffer = _buffer._consumeAndCreateNew()
    }
  }
  internal mutating func _endMutation() {
    _buffer.endCOWMutation()
  }
  @inlinable
  @inline(__always)
  internal func _checkSubscript_native(_ index: Int) {
    _ = _checkSubscript(index, wasNativeTypeChecked: true)
  }
  @inlinable
  public 
  func _checkSubscript(
    _ index: Int, wasNativeTypeChecked: Bool
  ) -> _DependenceToken {
#if _runtime(_ObjC)
    if _fastPath(wasNativeTypeChecked) {
      _buffer._native._checkValidSubscript(index)
    }
#else
    _buffer._checkValidSubscript(index)
#endif
    return _DependenceToken()
  }
  internal func _checkSubscript_mutating(_ index: Int) {
    _buffer._checkValidSubscriptMutating(index)
  }
  @inlinable
  internal func _checkIndex(_ index: Int) {
    _precondition(index <= endIndex, "Array index is out of range")
    _precondition(index >= startIndex, "Negative Array index is out of range")
  }
  @inlinable 
  @inline(__always)
  public 
  func _getElement(
    _ index: Int,
    wasNativeTypeChecked: Bool,
    matchingSubscriptCheck: _DependenceToken
  ) -> Element {
#if _runtime(_ObjC)
    return _buffer.getElement(index, wasNativeTypeChecked: wasNativeTypeChecked)
#else
    return _buffer.getElement(index)
#endif
  }
  @inlinable
  internal func _getElementAddress(_ index: Int) -> UnsafeMutablePointer<Element> {
    return _buffer.firstElementAddress + index
  }
}
extension Array: _ArrayProtocol {
  @inlinable
  public var capacity: Int {
    return _getCapacity()
  }
  @inlinable
  public 
  var _owner: AnyObject? {
    @inlinable 
    @inline(__always)
    get {
      return _buffer.owner      
    }
  }
  @inlinable
  public var _baseAddressIfContiguous: UnsafeMutablePointer<Element>? {
    @inline(__always) 
    get { return _buffer.firstElementAddressIfContiguous }
  }
}
extension Array: RandomAccessCollection, MutableCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias Iterator = IndexingIterator<Array>
  @inlinable
  public var startIndex: Int {
    return 0
  }
  @inlinable
  public var endIndex: Int {
    @inlinable
    get {
      return _getCount()
    }
  }
  @inlinable
  public func index(after i: Int) -> Int {
    return i + 1
  }
  @inlinable
  public func formIndex(after i: inout Int) {
    i += 1
  }
  @inlinable
  public func index(before i: Int) -> Int {
    return i - 1
  }
  @inlinable
  public func formIndex(before i: inout Int) {
    i -= 1
  }
  @inlinable
  public func index(_ i: Int, offsetBy distance: Int) -> Int {
    return i + distance
  }
  @inlinable
  public func index(
    _ i: Int, offsetBy distance: Int, limitedBy limit: Int
  ) -> Int? {
    let l = limit - i
    if distance > 0 ? l >= 0 && l < distance : l <= 0 && distance < l {
      return nil
    }
    return i + distance
  }
  @inlinable
  public func distance(from start: Int, to end: Int) -> Int {
    return end - start
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Int, bounds: Range<Int>) {
  }
  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Int>, bounds: Range<Int>) {
  }
  @inlinable
  public subscript(index: Int) -> Element {
    get {
      let wasNativeTypeChecked = _hoistableIsNativeTypeChecked()
      let token = _checkSubscript(
        index, wasNativeTypeChecked: wasNativeTypeChecked)
      return _getElement(
        index, wasNativeTypeChecked: wasNativeTypeChecked,
        matchingSubscriptCheck: token)
    }
    _modify {
      _makeMutableAndUnique() 
      _checkSubscript_mutating(index)
      let address = _buffer.mutableFirstElementAddress + index
      defer { _endMutation() }
      yield &address.pointee
    }
  }
  @inlinable
  public subscript(bounds: Range<Int>) -> ArraySlice<Element> {
    get {
      _checkIndex(bounds.lowerBound)
      _checkIndex(bounds.upperBound)
      return ArraySlice(_buffer: _buffer[bounds])
    }
    set(rhs) {
      _checkIndex(bounds.lowerBound)
      _checkIndex(bounds.upperBound)
      if self[bounds]._buffer.identity != rhs._buffer.identity
      || bounds != rhs.startIndex..<rhs.endIndex {
        self.replaceSubrange(bounds, with: rhs)
      }
    }
  }
  @inlinable
  public var count: Int {
    return _getCount()
  }
}
extension Array: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Element...) {
    self = elements
  }
}
extension Array: RangeReplaceableCollection {
  @inlinable
  public init() {
    _buffer = _Buffer()
  }
  @inlinable
  public init<S: Sequence>(_ s: S) where S.Element == Element {
    self = Array(
      _buffer: _Buffer(
        _buffer: s._copyToContiguousArray()._buffer,
        shiftedToStartIndex: 0))
  }
  @inlinable
  public init(repeating repeatedValue: Element, count: Int) {
    var p: UnsafeMutablePointer<Element>
    (self, p) = Array._allocateUninitialized(count)
    for _ in 0..<count {
      p.initialize(to: repeatedValue)
      p += 1
    }
    _endMutation()
  }
  @inline(never)
  @usableFromInline
  internal static func _allocateBufferUninitialized(
    minimumCapacity: Int
  ) -> _Buffer {
    let newBuffer = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: 0, minimumCapacity: minimumCapacity)
    return _Buffer(_buffer: newBuffer, shiftedToStartIndex: 0)
  }
  @inlinable
  internal init(_uninitializedCount count: Int) {
    _precondition(count >= 0, "Can't construct Array with count < 0")
    _buffer = _Buffer()
    if count > 0 {
      _buffer = Array._allocateBufferUninitialized(minimumCapacity: count)
      _buffer.mutableCount = count
    }
  }
  @inlinable
  internal static func _allocateUninitialized(
    _ count: Int
  ) -> (Array, UnsafeMutablePointer<Element>) {
    let result = Array(_uninitializedCount: count)
    return (result, result._buffer.firstElementAddress)
  }
  @inlinable
  internal static func _adoptStorage(
    _ storage: __owned _ContiguousArrayStorage<Element>, count: Int
  ) -> (Array, UnsafeMutablePointer<Element>) {
    let innerBuffer = _ContiguousArrayBuffer<Element>(
      count: count,
      storage: storage)
    return (
      Array(
        _buffer: _Buffer(_buffer: innerBuffer, shiftedToStartIndex: 0)),
        innerBuffer.firstElementAddress)
  }
  @inlinable
  internal mutating func _deallocateUninitialized() {
    _buffer.mutableCount = 0
  }
  @inlinable
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
    _reserveCapacityImpl(minimumCapacity: minimumCapacity,
                         growForAppend: false)
    _endMutation()
  }
  internal mutating func _reserveCapacityImpl(
    minimumCapacity: Int, growForAppend: Bool
  ) {
    let isUnique = _buffer.beginCOWMutation()
    if _slowPath(!isUnique || _buffer.mutableCapacity < minimumCapacity) {
      _createNewBuffer(bufferIsUnique: isUnique,
                       minimumCapacity: Swift.max(minimumCapacity, _buffer.count),
                       growForAppend: growForAppend)
    }
    _internalInvariant(_buffer.mutableCapacity >= minimumCapacity)
    _internalInvariant(_buffer.mutableCapacity == 0 ||
                       _buffer.isUniquelyReferenced())
  }
  internal mutating func _createNewBuffer(
    bufferIsUnique: Bool, minimumCapacity: Int, growForAppend: Bool
  ) {
    _internalInvariant(!bufferIsUnique || _buffer.isUniquelyReferenced())
    _buffer = _buffer._consumeAndCreateNew(bufferIsUnique: bufferIsUnique,
                                           minimumCapacity: minimumCapacity,
                                           growForAppend: growForAppend)
  }
  @inline(never)
  @inlinable 
  internal mutating func _copyToNewBuffer(oldCount: Int) {
    let newCount = oldCount &+ 1
    var newBuffer = _buffer._forceCreateUniqueMutableBuffer(
      countForNewBuffer: oldCount, minNewCapacity: newCount)
    _buffer._arrayOutOfPlaceUpdate(&newBuffer, oldCount, 0)
  }
  @inlinable
  internal mutating func _makeUniqueAndReserveCapacityIfNotUnique() {
    if _slowPath(!_buffer.beginCOWMutation()) {
      _createNewBuffer(bufferIsUnique: false,
                       minimumCapacity: count &+ 1,
                       growForAppend: true)
    }
  }
  @inlinable
  internal mutating func _reserveCapacityAssumingUniqueBuffer(oldCount: Int) {
    let capacity = _buffer.mutableCapacity
    _internalInvariant(capacity == 0 || _buffer.isMutableAndUniquelyReferenced())
    if _slowPath(oldCount &+ 1 > capacity) {
      _createNewBuffer(bufferIsUnique: capacity > 0,
                       minimumCapacity: oldCount &+ 1,
                       growForAppend: true)
    }
  }
  @inlinable
  internal mutating func _appendElementAssumeUniqueAndCapacity(
    _ oldCount: Int,
    newElement: __owned Element
  ) {
    _internalInvariant(_buffer.isMutableAndUniquelyReferenced())
    _internalInvariant(_buffer.mutableCapacity >= _buffer.mutableCount &+ 1)
    _buffer.mutableCount = oldCount &+ 1
    (_buffer.mutableFirstElementAddress + oldCount).initialize(to: newElement)
  }
  @inlinable
  public mutating func append(_ newElement: __owned Element) {
    _makeUniqueAndReserveCapacityIfNotUnique()
    let oldCount = _buffer.mutableCount
    _reserveCapacityAssumingUniqueBuffer(oldCount: oldCount)
    _appendElementAssumeUniqueAndCapacity(oldCount, newElement: newElement)
    _endMutation()
  }
  @inlinable
  public mutating func append<S: Sequence>(contentsOf newElements: __owned S)
    where S.Element == Element {
    defer {
      _endMutation()
    }
    let newElementsCount = newElements.underestimatedCount
    _reserveCapacityImpl(minimumCapacity: self.count + newElementsCount,
                         growForAppend: true)
    let oldCount = _buffer.mutableCount
    let startNewElements = _buffer.mutableFirstElementAddress + oldCount
    let buf = UnsafeMutableBufferPointer(
                start: startNewElements, 
                count: _buffer.mutableCapacity - oldCount)
    var (remainder,writtenUpTo) = buf.initialize(from: newElements)
    let writtenCount = buf.distance(from: buf.startIndex, to: writtenUpTo)
    _precondition(newElementsCount <= writtenCount, 
      "newElements.underestimatedCount was an overestimate")
    if writtenCount > 0 {
      _buffer.mutableCount = _buffer.mutableCount + writtenCount
    }
    if _slowPath(writtenUpTo == buf.endIndex) {
      if S.self == [Element].self {
        _internalInvariant(remainder.next() == nil)
        return
      }
      var newCount = _buffer.mutableCount
      var nextItem = remainder.next()
      while nextItem != nil {
        _reserveCapacityAssumingUniqueBuffer(oldCount: newCount)
        let currentCapacity = _buffer.mutableCapacity
        let base = _buffer.mutableFirstElementAddress
        while let next = nextItem, newCount < currentCapacity {
          (base + newCount).initialize(to: next)
          newCount += 1
          nextItem = remainder.next()
        }
        _buffer.mutableCount = newCount
      }
    }
  }
  @inlinable
  internal mutating func reserveCapacityForAppend(newElementsCount: Int) {
    _reserveCapacityImpl(minimumCapacity: self.count + newElementsCount,
                         growForAppend: true)
    _endMutation()
  }
  @inlinable
  public mutating func _customRemoveLast() -> Element? {
    _makeMutableAndUnique()
    let newCount = _buffer.mutableCount - 1
    _precondition(newCount >= 0, "Can't removeLast from an empty Array")
    let pointer = (_buffer.mutableFirstElementAddress + newCount)
    let element = pointer.move()
    _buffer.mutableCount = newCount
    _endMutation()
    return element
  }
  @inlinable
  @discardableResult
  public mutating func remove(at index: Int) -> Element {
    _makeMutableAndUnique()
    let currentCount = _buffer.mutableCount
    _precondition(index < currentCount, "Index out of range")
    _precondition(index >= 0, "Index out of range")
    let newCount = currentCount - 1
    let pointer = (_buffer.mutableFirstElementAddress + index)
    let result = pointer.move()
    pointer.moveInitialize(from: pointer + 1, count: newCount - index)
    _buffer.mutableCount = newCount
    _endMutation()
    return result
  }
  @inlinable
  public mutating func insert(_ newElement: __owned Element, at i: Int) {
    _checkIndex(i)
    self.replaceSubrange(i..<i, with: CollectionOfOne(newElement))
  }
  @inlinable
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    if !keepCapacity {
      _buffer = _Buffer()
    }
    else {
      self.replaceSubrange(indices, with: EmptyCollection())
    }
  }
  @inlinable
  @available(*, deprecated, renamed: "withContiguousMutableStorageIfAvailable")
  public mutating func _withUnsafeMutableBufferPointerIfSupported<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try withUnsafeMutableBufferPointer {
      (bufferPointer) -> R in
      return try body(&bufferPointer)
    }
  }
  @inlinable
  public mutating func withContiguousMutableStorageIfAvailable<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try withUnsafeMutableBufferPointer {
      (bufferPointer) -> R in
      return try body(&bufferPointer)
    }
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try withUnsafeBufferPointer {
      (bufferPointer) -> R in
      return try body(bufferPointer)
    }
  }
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    if let n = _buffer.requestNativeBuffer() {
      return ContiguousArray(_buffer: n)
    }
    return _copyCollectionToContiguousArray(self)
  }
}
extension Array {
  @inlinable
  public static func + (lhs: Array, rhs: Array) -> Array {
    var lhs = lhs
    lhs.append(contentsOf: rhs)
    return lhs
  }
  @inlinable
  public static func += (lhs: inout Array, rhs: Array) {
    lhs.append(contentsOf: rhs)
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Array: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      unlabeledChildren: self,
      displayStyle: .collection)
  }
}
#endif
extension Array: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return _makeCollectionDescription()
  }
  public var debugDescription: String {
    return _makeCollectionDescription()
  }
}
extension Array {
  internal func _cPointerArgs() -> (AnyObject?, UnsafeRawPointer?) {
    let p = _baseAddressIfContiguous
    if _fastPath(p != nil || isEmpty) {
      return (_owner, UnsafeRawPointer(p))
    }
    let n = ContiguousArray(self._buffer)._buffer
    return (n.owner, UnsafeRawPointer(n.firstElementAddress))
  }
}
extension Array {
  @inlinable
  internal init(
    _unsafeUninitializedCapacity: Int,
    initializingWith initializer: (
      _ buffer: inout UnsafeMutableBufferPointer<Element>,
      _ initializedCount: inout Int) throws -> Void
  ) rethrows {
    var firstElementAddress: UnsafeMutablePointer<Element>
    (self, firstElementAddress) =
      Array._allocateUninitialized(_unsafeUninitializedCapacity)
    var initializedCount = 0
    var buffer = UnsafeMutableBufferPointer<Element>(
      start: firstElementAddress, count: _unsafeUninitializedCapacity)
    defer {
      _precondition(
        initializedCount <= _unsafeUninitializedCapacity,
        "Initialized count set to greater than specified capacity."
      )
      _precondition(
        buffer.baseAddress == firstElementAddress,
        "Can't reassign buffer in Array(unsafeUninitializedCapacity:initializingWith:)"
      )
      self._buffer.mutableCount = initializedCount
      _endMutation()
    }
    try initializer(&buffer, &initializedCount)
  }
  public init(
    unsafeUninitializedCapacity: Int,
    initializingWith initializer: (
      _ buffer: inout UnsafeMutableBufferPointer<Element>,
      _ initializedCount: inout Int) throws -> Void
  ) rethrows {
    self = try Array(
      _unsafeUninitializedCapacity: unsafeUninitializedCapacity,
      initializingWith: initializer)
  }
  @inlinable
  public func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    return try _buffer.withUnsafeBufferPointer(body)
  }
  @inlinable 
  @inline(__always) 
  public mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    _makeMutableAndUnique()
    let count = _buffer.mutableCount
    let pointer = _buffer.mutableFirstElementAddress
    var inoutBufferPointer = UnsafeMutableBufferPointer(
      start: pointer, count: count)
    defer {
      _precondition(
        inoutBufferPointer.baseAddress == pointer &&
        inoutBufferPointer.count == count,
        "Array withUnsafeMutableBufferPointer: replacing the buffer is not allowed")
      _endMutation()
      _fixLifetime(self)
    }
    return try body(&inoutBufferPointer)
  }
  @inlinable
  public __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator,UnsafeMutableBufferPointer<Element>.Index) {
    guard !self.isEmpty else { return (makeIterator(),buffer.startIndex) }
    guard var p = buffer.baseAddress
      else { _preconditionFailure("Attempt to copy contents into nil buffer pointer") }
    _precondition(self.count <= buffer.count, 
      "Insufficient space allocated to copy array contents")
    if let s = _baseAddressIfContiguous {
      p.initialize(from: s, count: self.count)
      _fixLifetime(self._owner)
    } else {
      for x in self {
        p.initialize(to: x)
        p += 1
      }
    }
    var it = IndexingIterator(_elements: self)
    it._position = endIndex
    return (it,buffer.index(buffer.startIndex, offsetBy: self.count))
  }
}
extension Array {
  @inlinable
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with newElements: __owned C
  ) where C: Collection, C.Element == Element {
    _precondition(subrange.lowerBound >= self._buffer.startIndex,
      "Array replace: subrange start is negative")
    _precondition(subrange.upperBound <= _buffer.endIndex,
      "Array replace: subrange extends past the end")
    let eraseCount = subrange.count
    let insertCount = newElements.count
    let growth = insertCount - eraseCount
    _reserveCapacityImpl(minimumCapacity: self.count + growth,
                         growForAppend: true)
    _buffer.replaceSubrange(subrange, with: insertCount, elementsOf: newElements)
    _endMutation()
  }
}
extension Array: Equatable where Element: Equatable {
  @inlinable
  public static func ==(lhs: Array<Element>, rhs: Array<Element>) -> Bool {
    let lhsCount = lhs.count
    if lhsCount != rhs.count {
      return false
    }
    if lhsCount == 0 || lhs._buffer.identity == rhs._buffer.identity {
      return true
    }
    _internalInvariant(lhs.startIndex == 0 && rhs.startIndex == 0)
    _internalInvariant(lhs.endIndex == lhsCount && rhs.endIndex == lhsCount)
    for idx in 0..<lhsCount {
      if lhs[idx] != rhs[idx] {
        return false
      }
    }
    return true
  }
}
extension Array: Hashable where Element: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(count) 
    for element in self {
      hasher.combine(element)
    }
  }
}
extension Array {
  @inlinable
  public mutating func withUnsafeMutableBytes<R>(
    _ body: (UnsafeMutableRawBufferPointer) throws -> R
  ) rethrows -> R {
    return try self.withUnsafeMutableBufferPointer {
      return try body(UnsafeMutableRawBufferPointer($0))
    }
  }
  @inlinable
  public func withUnsafeBytes<R>(
    _ body: (UnsafeRawBufferPointer) throws -> R
  ) rethrows -> R {
    return try self.withUnsafeBufferPointer {
      try body(UnsafeRawBufferPointer($0))
    }
  }
}
#if INTERNAL_CHECKS_ENABLED
extension Array {
  public func _copyToNewArray() -> [Element] {
    Array(unsafeUninitializedCapacity: self.count) { buffer, count in
      var (it, c) = self._buffer._copyContents(initializing: buffer)
      _precondition(it.next() == nil)
      count = c
    }
  }
}
#endif
#if _runtime(_ObjC)
@usableFromInline internal
func _bridgeCocoaArray<T>(_ _immutableCocoaArray: AnyObject) -> Array<T> {
  return Array(_buffer: _ArrayBuffer(nsArray: _immutableCocoaArray))
}
extension Array {
  @inlinable
  public 
  func _bridgeToObjectiveCImpl() -> AnyObject {
    return _buffer._asCocoaArray()
  }
  @inlinable
  public static func _bridgeFromObjectiveCAdoptingNativeStorageOf(
    _ source: AnyObject
  ) -> Array? {
    let maybeNative = (source as? __SwiftDeferredNSArray)?._nativeStorage ?? source
    return (maybeNative as? _ContiguousArrayStorage<Element>).map {
      Array(_ContiguousArrayBuffer($0))
    }
  }
  @inlinable
  public init(_immutableCocoaArray: AnyObject) {
    self = _bridgeCocoaArray(_immutableCocoaArray)
  }
}
#endif
extension Array: _HasCustomAnyHashableRepresentation
  where Element: Hashable {
  public __consuming func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _ArrayAnyHashableBox(self))
  }
}
internal protocol _ArrayAnyHashableProtocol: _AnyHashableBox {
  var count: Int { get }
  subscript(index: Int) -> AnyHashable { get }
}
internal struct _ArrayAnyHashableBox<Element: Hashable>
  : _ArrayAnyHashableProtocol {
  internal let _value: [Element]
  internal init(_ value: [Element]) {
    self._value = value
  }
  internal var _base: Any {
    return _value
  }
  internal var count: Int {
    return _value.count
  }
  internal subscript(index: Int) -> AnyHashable {
    return _value[index] as AnyHashable
  }
  func _isEqual(to other: _AnyHashableBox) -> Bool? {
    guard let other = other as? _ArrayAnyHashableProtocol else { return nil }
    guard _value.count == other.count else { return false }
    for i in 0 ..< _value.count {
      if self[i] != other[i] { return false }
    }
    return true
  }
  var _hashValue: Int {
    var hasher = Hasher()
    _hash(into: &hasher)
    return hasher.finalize()
  }
  func _hash(into hasher: inout Hasher) {
    hasher.combine(_value.count) 
    for i in 0 ..< _value.count {
      hasher.combine(self[i])
    }
  }
  func _rawHashValue(_seed: Int) -> Int {
    var hasher = Hasher(_seed: _seed)
    self._hash(into: &hasher)
    return hasher._finalize()
  }
  internal func _unbox<T: Hashable>() -> T? {
    return _value as? T
  }
  internal func _downCastConditional<T>(
    into result: UnsafeMutablePointer<T>
  ) -> Bool {
    guard let value = _value as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
extension Array: @unchecked Sendable where Element: Sendable { }
