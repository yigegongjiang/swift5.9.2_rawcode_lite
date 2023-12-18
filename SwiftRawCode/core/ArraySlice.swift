@frozen
public struct ArraySlice<Element>: _DestructorSafeContainer {
  @usableFromInline
  internal typealias _Buffer = _SliceBuffer<Element>
  @usableFromInline
  internal var _buffer: _Buffer
  @inlinable
  internal init(_buffer: _Buffer) {
    self._buffer = _buffer
  }
  @inlinable
  internal init(_buffer buffer: _ContiguousArrayBuffer<Element>) {
    self.init(_buffer: _Buffer(_buffer: buffer, shiftedToStartIndex: 0))
  }
}
extension ArraySlice {
  @inlinable
  public 
  func _hoistableIsNativeTypeChecked() -> Bool {
   return _buffer.arrayPropertyIsNativeTypeChecked
  }
  @inlinable
  internal func _getCount() -> Int {
    return _buffer.count
  }
  @inlinable
  internal func _getCapacity() -> Int {
    return _buffer.capacity
  }
  @inlinable
  internal mutating func _makeMutableAndUnique() {
    if _slowPath(!_buffer.beginCOWMutation()) {
      _buffer = _Buffer(copying: _buffer)
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
  @inlinable
  public 
  func _checkSubscript(
    _ index: Int, wasNativeTypeChecked: Bool
  ) -> _DependenceToken {
#if _runtime(_ObjC)
    _buffer._checkValidSubscript(index)
#else
    _buffer._checkValidSubscript(index)
#endif
    return _DependenceToken()
  }
  @inlinable
  internal func _checkIndex(_ index: Int) {
    _precondition(index <= endIndex, "ArraySlice index is out of range")
    _precondition(index >= startIndex, "ArraySlice index is out of range (before startIndex)")
  }
  @inlinable 
  @inline(__always)
  public 
  func _getElement(
    _ index: Int,
    wasNativeTypeChecked: Bool,
    matchingSubscriptCheck: _DependenceToken
  ) -> Element {
#if false
    return _buffer.getElement(index, wasNativeTypeChecked: wasNativeTypeChecked)
#else
    return _buffer.getElement(index)
#endif
  }
  @inlinable
  internal func _getElementAddress(_ index: Int) -> UnsafeMutablePointer<Element> {
    return _buffer.subscriptBaseAddress + index
  }
}
extension ArraySlice: _ArrayProtocol {
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
extension ArraySlice: RandomAccessCollection, MutableCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias Iterator = IndexingIterator<ArraySlice>
  @inlinable
  public var startIndex: Int {
    return _buffer.startIndex
  }
  @inlinable
  public var endIndex: Int {
    return _buffer.endIndex
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
      _checkSubscript_native(index)
      let address = _buffer.subscriptBaseAddress + index
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
extension ArraySlice: ExpressibleByArrayLiteral {
  @inlinable
  public init(arrayLiteral elements: Element...) {
    self.init(_buffer: ContiguousArray(elements)._buffer)
  }
}
extension ArraySlice: RangeReplaceableCollection {
  @inlinable
  public init() {
    _buffer = _Buffer()
  }
  @inlinable
  public init<S: Sequence>(_ s: S)
    where S.Element == Element {
    self.init(_buffer: s._copyToContiguousArray()._buffer)
  }
  @inlinable
  public init(repeating repeatedValue: Element, count: Int) {
    _precondition(count >= 0, "Can't construct ArraySlice with count < 0")
    if count > 0 {
      _buffer = ArraySlice._allocateBufferUninitialized(minimumCapacity: count)
      _buffer.count = count
      var p = _buffer.firstElementAddress
      for _ in 0..<count {
        p.initialize(to: repeatedValue)
        p += 1
      }
    } else {
      _buffer = _Buffer()
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
    _precondition(count >= 0, "Can't construct ArraySlice with count < 0")
    _buffer = _Buffer()
    if count > 0 {
      _buffer = ArraySlice._allocateBufferUninitialized(minimumCapacity: count)
      _buffer.count = count
    }
    _endMutation()
  }
  @inlinable
  internal static func _allocateUninitialized(
    _ count: Int
  ) -> (ArraySlice, UnsafeMutablePointer<Element>) {
    let result = ArraySlice(_uninitializedCount: count)
    return (result, result._buffer.firstElementAddress)
  }
  @inlinable
  public mutating func reserveCapacity(_ minimumCapacity: Int) {
    if !_buffer.beginCOWMutation() || _buffer.capacity < minimumCapacity {
      let newBuffer = _ContiguousArrayBuffer<Element>(
        _uninitializedCount: count, minimumCapacity: minimumCapacity)
      _buffer._copyContents(
        subRange: _buffer.indices,
        initializing: newBuffer.firstElementAddress)
      _buffer = _Buffer(
        _buffer: newBuffer, shiftedToStartIndex: _buffer.startIndex)
    }
    _internalInvariant(capacity >= minimumCapacity)
    _endMutation()
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
      _copyToNewBuffer(oldCount: _buffer.count)
    }
  }
  @inlinable
  internal mutating func _reserveCapacityAssumingUniqueBuffer(oldCount: Int) {
    let capacity = _buffer.capacity
    _internalInvariant(capacity == 0 || _buffer.isMutableAndUniquelyReferenced())
    if _slowPath(oldCount &+ 1 > capacity) {
      _copyToNewBuffer(oldCount: oldCount)
    }
  }
  @inlinable
  internal mutating func _appendElementAssumeUniqueAndCapacity(
    _ oldCount: Int,
    newElement: __owned Element
  ) {
    _internalInvariant(_buffer.isMutableAndUniquelyReferenced())
    _internalInvariant(_buffer.capacity >= _buffer.count &+ 1)
    _buffer.count = oldCount &+ 1
    (_buffer.firstElementAddress + oldCount).initialize(to: newElement)
  }
  @inlinable
  public mutating func append(_ newElement: __owned Element) {
    _makeUniqueAndReserveCapacityIfNotUnique()
    let oldCount = _getCount()
    _reserveCapacityAssumingUniqueBuffer(oldCount: oldCount)
    _appendElementAssumeUniqueAndCapacity(oldCount, newElement: newElement)
    _endMutation()
  }
  @inlinable
  public mutating func append<S: Sequence>(contentsOf newElements: __owned S)
    where S.Element == Element {
    let newElementsCount = newElements.underestimatedCount
    reserveCapacityForAppend(newElementsCount: newElementsCount)
    _ = _buffer.beginCOWMutation()
    let oldCount = self.count
    let startNewElements = _buffer.firstElementAddress + oldCount
    let buf = UnsafeMutableBufferPointer(
                start: startNewElements, 
                count: self.capacity - oldCount)
    let (remainder,writtenUpTo) = buf.initialize(from: newElements)
    let writtenCount = buf.distance(from: buf.startIndex, to: writtenUpTo)
    _precondition(newElementsCount <= writtenCount,
      "newElements.underestimatedCount was an overestimate")
    if writtenCount > 0 {
      _buffer.count += writtenCount
    }
    if writtenUpTo == buf.endIndex {
      _buffer._arrayAppendSequence(IteratorSequence(remainder))
    }
    _endMutation()
  }
  @inlinable
  internal mutating func reserveCapacityForAppend(newElementsCount: Int) {
    let oldCount = self.count
    let oldCapacity = self.capacity
    let newCount = oldCount + newElementsCount
    self.reserveCapacity(
      newCount > oldCapacity ?
      Swift.max(newCount, _growArrayCapacity(oldCapacity))
      : newCount)
  }
  @inlinable
  public mutating func _customRemoveLast() -> Element? {
    _precondition(count > 0, "Can't removeLast from an empty ArraySlice")
    let i = endIndex
    let result = self[i &- 1]
    self.replaceSubrange((i &- 1)..<i, with: EmptyCollection())
    return result
  }
  @inlinable
  @discardableResult
  public mutating func remove(at index: Int) -> Element {
    let result = self[index]
    self.replaceSubrange(index..<(index + 1), with: EmptyCollection())
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
extension ArraySlice: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      unlabeledChildren: self,
      displayStyle: .collection)
  }
}
#endif
extension ArraySlice: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return _makeCollectionDescription()
  }
  public var debugDescription: String {
    return _makeCollectionDescription(withTypeName: "ArraySlice")
  }
}
extension ArraySlice {
  internal func _cPointerArgs() -> (AnyObject?, UnsafeRawPointer?) {
    let p = _baseAddressIfContiguous
    if _fastPath(p != nil || isEmpty) {
      return (_owner, UnsafeRawPointer(p))
    }
    let n = ContiguousArray(self._buffer)._buffer
    return (n.owner, UnsafeRawPointer(n.firstElementAddress))
  }
}
extension ArraySlice {
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
    let count = self.count
    _makeMutableAndUnique()
    let pointer = _buffer.firstElementAddress
    var inoutBufferPointer = UnsafeMutableBufferPointer(
      start: pointer, count: count)
    defer {
      _precondition(
        inoutBufferPointer.baseAddress == pointer &&
        inoutBufferPointer.count == count,
        "ArraySlice withUnsafeMutableBufferPointer: replacing the buffer is not allowed")
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
extension ArraySlice {
  @inlinable
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with newElements: __owned C
  ) where C: Collection, C.Element == Element {
    _precondition(subrange.lowerBound >= _buffer.startIndex,
      "ArraySlice replace: subrange start is before the startIndex")
    _precondition(subrange.upperBound <= _buffer.endIndex,
      "ArraySlice replace: subrange extends past the end")
    let oldCount = _buffer.count
    let eraseCount = subrange.count
    let insertCount = newElements.count
    let growth = insertCount - eraseCount
    if _buffer.beginCOWMutation() && _buffer.capacity >= oldCount + growth {
      _buffer.replaceSubrange(
        subrange, with: insertCount, elementsOf: newElements)
    } else {
      _buffer._arrayOutOfPlaceReplace(subrange, with: newElements, count: insertCount)
    }
    _endMutation()
  }
}
extension ArraySlice: Equatable where Element: Equatable {
  @inlinable
  public static func ==(lhs: ArraySlice<Element>, rhs: ArraySlice<Element>) -> Bool {
    let lhsCount = lhs.count
    if lhsCount != rhs.count {
      return false
    }
    if lhsCount == 0 || lhs._buffer.identity == rhs._buffer.identity {
      return true
    }
    var streamLHS = lhs.makeIterator()
    var streamRHS = rhs.makeIterator()
    var nextLHS = streamLHS.next()
    while nextLHS != nil {
      let nextRHS = streamRHS.next()
      if nextLHS != nextRHS {
        return false
      }
      nextLHS = streamLHS.next()
    }
    return true
  }
}
extension ArraySlice: Hashable where Element: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(count) 
    for element in self {
      hasher.combine(element)
    }
  }
}
extension ArraySlice {
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
extension ArraySlice {
  @inlinable
  public 
  init(_startIndex: Int) {
    self.init(
      _buffer: _Buffer(
        _buffer: ContiguousArray()._buffer,
        shiftedToStartIndex: _startIndex))
  }
}
extension ArraySlice: @unchecked Sendable
  where Element: Sendable { }
#if INTERNAL_CHECKS_ENABLED
extension ArraySlice {
  public func _copyToNewArray() -> [Element] {
    Array(unsafeUninitializedCapacity: self.count) { buffer, count in
      var (it, c) = self._buffer._copyContents(initializing: buffer)
      _precondition(it.next() == nil)
      count = c
    }
  }
}
#endif
