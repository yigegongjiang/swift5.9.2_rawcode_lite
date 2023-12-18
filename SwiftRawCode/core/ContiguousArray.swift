@frozen
public struct ContiguousArray<Element>: _DestructorSafeContainer {
  @usableFromInline
  internal typealias _Buffer = _ContiguousArrayBuffer<Element>
  @usableFromInline
  internal var _buffer: _Buffer
  @inlinable
  internal init(_buffer: _Buffer) {
    self._buffer = _buffer
  }
}
extension ContiguousArray {
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
    _buffer._checkValidSubscript(index)
  }
  internal func _checkSubscript_mutating(_ index: Int) {
    _buffer._checkValidSubscriptMutating(index)
  }
  @inlinable
  internal func _checkIndex(_ index: Int) {
    _precondition(index <= endIndex, "ContiguousArray index is out of range")
    _precondition(index >= startIndex, "Negative ContiguousArray index is out of range")
  }
  @inlinable
  internal func _getElementAddress(_ index: Int) -> UnsafeMutablePointer<Element> {
    return _buffer.firstElementAddress + index
  }
}
extension ContiguousArray: _ArrayProtocol {
  @inlinable
  public var capacity: Int {
    return _getCapacity()
  }
  @inlinable
  public 
  var _owner: AnyObject? {
    return _buffer.owner
  }
  @inlinable
  public var _baseAddressIfContiguous: UnsafeMutablePointer<Element>? {
    @inline(__always) 
    get { return _buffer.firstElementAddressIfContiguous }
  }
  @inlinable
  internal var _baseAddress: UnsafeMutablePointer<Element> {
    return _buffer.firstElementAddress
  }
}
extension ContiguousArray: RandomAccessCollection, MutableCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias Iterator = IndexingIterator<ContiguousArray>
  @inlinable
  public var startIndex: Int {
    return 0
  }
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
      _checkSubscript_native(index)
      return _buffer.getElement(index)
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
extension ContiguousArray: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Element...) {
    self.init(_buffer: ContiguousArray(elements)._buffer)
  }
}
extension ContiguousArray: RangeReplaceableCollection {
  @inlinable
  public init() {
    _buffer = _Buffer()
  }
  @inlinable
  public init<S: Sequence>(_ s: S) where S.Element == Element {
    self.init(_buffer: s._copyToContiguousArray()._buffer)
  }
  @inlinable
  public init(repeating repeatedValue: Element, count: Int) {
    var p: UnsafeMutablePointer<Element>
    (self, p) = ContiguousArray._allocateUninitialized(count)
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
    _precondition(count >= 0, "Can't construct ContiguousArray with count < 0")
    _buffer = _Buffer()
    if count > 0 {
      _buffer = ContiguousArray._allocateBufferUninitialized(minimumCapacity: count)
      _buffer.mutableCount = count
    }
  }
  @inlinable
  internal static func _allocateUninitialized(
    _ count: Int
  ) -> (ContiguousArray, UnsafeMutablePointer<Element>) {
    let result = ContiguousArray(_uninitializedCount: count)
    return (result, result._buffer.firstElementAddress)
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
    _internalInvariant(_buffer.mutableCapacity == 0 || _buffer.isUniquelyReferenced())
  }
  @inline(never)
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
    _buffer._arrayOutOfPlaceUpdate(
      &newBuffer, oldCount, 0)
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
    if writtenUpTo == buf.endIndex {
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
    _precondition(newCount >= 0, "Can't removeLast from an empty ContiguousArray")
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
#if SWIFT_ENABLE_REFLECTION
extension ContiguousArray: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      unlabeledChildren: self,
      displayStyle: .collection)
  }
}
#endif
extension ContiguousArray: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return _makeCollectionDescription()
  }
  public var debugDescription: String {
    return _makeCollectionDescription(withTypeName: "ContiguousArray")
  }
}
extension ContiguousArray {
  internal func _cPointerArgs() -> (AnyObject?, UnsafeRawPointer?) {
    let p = _baseAddressIfContiguous
    if _fastPath(p != nil || isEmpty) {
      return (_owner, UnsafeRawPointer(p))
    }
    let n = ContiguousArray(self._buffer)._buffer
    return (n.owner, UnsafeRawPointer(n.firstElementAddress))
  }
}
extension ContiguousArray {
  public init(
    unsafeUninitializedCapacity: Int,
    initializingWith initializer: (
      _ buffer: inout UnsafeMutableBufferPointer<Element>,
      _ initializedCount: inout Int) throws -> Void
  ) rethrows {
    self = try ContiguousArray(Array(
      _unsafeUninitializedCapacity: unsafeUninitializedCapacity,
      initializingWith: initializer))
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
        "ContiguousArray withUnsafeMutableBufferPointer: replacing the buffer is not allowed")
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
extension ContiguousArray {
  @inlinable
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with newElements: __owned C
  ) where C: Collection, C.Element == Element {
    _precondition(subrange.lowerBound >= self._buffer.startIndex,
      "ContiguousArray replace: subrange start is negative")
    _precondition(subrange.upperBound <= _buffer.endIndex,
      "ContiguousArray replace: subrange extends past the end")
    let eraseCount = subrange.count
    let insertCount = newElements.count
    let growth = insertCount - eraseCount
    _reserveCapacityImpl(minimumCapacity: self.count + growth,
                         growForAppend: true)
    _buffer.replaceSubrange(subrange, with: insertCount, elementsOf: newElements)
    _endMutation()
  }
}
extension ContiguousArray: Equatable where Element: Equatable {
  @inlinable
  public static func ==(lhs: ContiguousArray<Element>, rhs: ContiguousArray<Element>) -> Bool {
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
extension ContiguousArray: Hashable where Element: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(count) 
    for element in self {
      hasher.combine(element)
    }
  }
}
extension ContiguousArray {
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
extension ContiguousArray: @unchecked Sendable
  where Element: Sendable { }
