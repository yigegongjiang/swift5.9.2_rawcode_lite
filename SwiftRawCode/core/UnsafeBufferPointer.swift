@frozen 
public struct UnsafeMutableBufferPointer<Element> {
  @usableFromInline
  let _position: UnsafeMutablePointer<Element>?
  public let count: Int
  internal init(
    count: Int
  ) {
    _position = start
    self.count = count
  }
  @inlinable 
  public init(
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeMutableBufferPointer with negative count")
    _debugPrecondition(
      count == 0 || start != nil,
      "UnsafeMutableBufferPointer has a nil start and nonzero count")
    self.init(_uncheckedStart: start, count: _assumeNonNegative(count))
  }
  @inlinable 
  public init(_empty: ()) {
    _position = nil
    count = 0
  }
  @inlinable 
  public init(mutating other: UnsafeBufferPointer<Element>) {
    _position = UnsafeMutablePointer<Element>(mutating: other._position)
    count = other.count
  }
}
extension UnsafeMutableBufferPointer {
  public typealias Iterator = UnsafeBufferPointer<Element>.Iterator
}
extension UnsafeMutableBufferPointer: Sequence {
  @inlinable 
  public func makeIterator() -> Iterator {
    guard let start = _position else {
      return Iterator(_position: nil, _end: nil)
    }
    return Iterator(_position: start, _end: start + count)
  }
  @inlinable 
  public func _copyContents(
    initializing destination: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    guard !isEmpty && !destination.isEmpty else { return (makeIterator(), 0) }
    let s = self.baseAddress._unsafelyUnwrappedUnchecked
    let d = destination.baseAddress._unsafelyUnwrappedUnchecked
    let n = Swift.min(destination.count, self.count)
    d.initialize(from: s, count: n)
    return (Iterator(_position: s + n, _end: s + count), n)
  }
}
extension UnsafeMutableBufferPointer: MutableCollection, RandomAccessCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  @inlinable 
  public var startIndex: Int { return 0 }
  @inlinable 
  public var endIndex: Int { return count }
  @inlinable 
  public func index(after i: Int) -> Int {
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func formIndex(after i: inout Int) {
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }
  @inlinable 
  public func index(before i: Int) -> Int {
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func formIndex(before i: inout Int) {
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }
  @inlinable 
  public func index(_ i: Int, offsetBy n: Int) -> Int {
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? {
    let maxOffset = limit.subtractingReportingOverflow(i)
    _debugPrecondition(!maxOffset.overflow)
    let l = maxOffset.partialValue
    if n > 0 ? l >= 0 && l < n : l <= 0 && n < l {
      return nil
    }
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func distance(from start: Int, to end: Int) -> Int {
    let result = end.subtractingReportingOverflow(start)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func _failEarlyRangeCheck(_ index: Int, bounds: Range<Int>) {
    _debugPrecondition(index >= bounds.lowerBound)
    _debugPrecondition(index < bounds.upperBound)
  }
  @inlinable 
  public func _failEarlyRangeCheck(_ range: Range<Int>, bounds: Range<Int>) {
    _debugPrecondition(range.lowerBound >= bounds.lowerBound)
    _debugPrecondition(range.upperBound <= bounds.upperBound)
  }
  @inlinable 
  public var indices: Indices {
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }
  @inlinable 
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
    nonmutating _modify {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      yield &_position._unsafelyUnwrappedUnchecked[i]
    }
  }
  @inlinable 
  internal subscript(_unchecked i: Int) -> Element {
    get {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
    nonmutating _modify {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      yield &_position._unsafelyUnwrappedUnchecked[i]
    }
  }
  @inlinable 
  public subscript(bounds: Range<Int>)
    -> Slice<UnsafeMutableBufferPointer<Element>>
  {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(
        base: self, bounds: bounds)
    }
    nonmutating set {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      _debugPrecondition(bounds.count == newValue.count)
      if !newValue.isEmpty {
        (_position! + bounds.lowerBound).update(
          from: newValue.base._position! + newValue.startIndex,
          count: newValue.count)
      }
    }
  }
  @inlinable 
  public func swapAt(_ i: Int, _ j: Int) {
    guard i != j else { return }
    _debugPrecondition(i >= 0 && j >= 0)
    _debugPrecondition(i < endIndex && j < endIndex)
    let pi = (_position! + i)
    let pj = (_position! + j)
    let tmp = pi.move()
    pi.moveInitialize(from: pj, count: 1)
    pj.initialize(to: tmp)
  }
}
extension UnsafeMutableBufferPointer {
  @inlinable
  @available(*, deprecated, renamed: "withContiguousMutableStorageIfAvailable")
  public mutating func _withUnsafeMutableBufferPointerIfSupported<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try body(&self)
  }
  @inlinable
  public mutating func withContiguousMutableStorageIfAvailable<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    let (oldBase, oldCount) = (self.baseAddress, self.count)
    defer { 
      _debugPrecondition((oldBase, oldCount) == (self.baseAddress, self.count),
      "UnsafeMutableBufferPointer.withContiguousMutableStorageIfAvailable: replacing the buffer is not allowed")
    } 
    return try body(&self)
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try body(UnsafeBufferPointer(self))
  }
  @inlinable 
  public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable 
  public func deallocate() {
    _position?.deallocate()
  }
  @inlinable 
  public static func allocate(capacity count: Int) 
    -> UnsafeMutableBufferPointer<Element> {
    let base  = UnsafeMutablePointer<Element>.allocate(capacity: count)
    return UnsafeMutableBufferPointer(start: base, count: count)
  }
  @inlinable 
  public func initialize(repeating repeatedValue: Element) {
    guard let dstBase = _position else {
      return
    }
    dstBase.initialize(repeating: repeatedValue, count: count)
  }
  @inlinable 
  public func initialize<S: Sequence>(
    from source: S
  ) -> (unwritten: S.Iterator, index: Index) where S.Element == Element {
    return source._copyContents(initializing: self)
  }
  @inlinable
  public func initialize<C: Collection>(
    fromContentsOf source: C
  ) -> Index where C.Element == Element {
    let count = source.withContiguousStorageIfAvailable {
      guard let sourceAddress = $0.baseAddress, !$0.isEmpty else {
        return 0
      }
      _precondition(
        $0.count <= self.count,
        "buffer cannot contain every element from source."
      )
      baseAddress?.initialize(from: sourceAddress, count: $0.count)
      return $0.count
    }
    if let count {
      return startIndex.advanced(by: count)
    }
    var (iterator, copied) = source._copyContents(initializing: self)
    _precondition(
      iterator.next() == nil,
      "buffer cannot contain every element from source."
    )
    return startIndex.advanced(by: copied)
  }
  @inlinable 
  public func update(repeating repeatedValue: Element) {
    guard let dstBase = _position else {
      return
    }
    dstBase.update(repeating: repeatedValue, count: count)
  }
  @inlinable
  @available(*, deprecated, renamed: "update(repeating:)")
  public func assign(repeating repeatedValue: Element) {
    update(repeating: repeatedValue)
  }
  @inlinable
  public func update<S: Sequence>(
    from source: S
  ) -> (unwritten: S.Iterator, index: Index) where S.Element == Element {
    var iterator = source.makeIterator()
    guard !self.isEmpty else { return (iterator, startIndex) }
    _internalInvariant(_position != nil)
    var index = startIndex
    while index < endIndex {
      guard let element = iterator.next() else { break }
      _position._unsafelyUnwrappedUnchecked[index] = element
      formIndex(after: &index)
    }
    return (iterator, index)
  }
  @inlinable
  public func update<C: Collection>(
    fromContentsOf source: C
  ) -> Index where C.Element == Element {
    let count = source.withContiguousStorageIfAvailable {
      guard let sourceAddress = $0.baseAddress else {
        return 0
      }
      _precondition(
        $0.count <= self.count,
        "buffer cannot contain every element from source."
      )
      baseAddress?.update(from: sourceAddress, count: $0.count)
      return $0.count
    }
    if let count {
      return startIndex.advanced(by: count)
    }
    if self.isEmpty {
      _precondition(
        source.isEmpty,
        "buffer cannot contain every element from source."
      )
      return startIndex
    }
    _internalInvariant(_position != nil)
    var iterator = source.makeIterator()
    var index = startIndex
    while let value = iterator.next() {
      guard index < endIndex else {
        _preconditionFailure(
          "buffer cannot contain every element from source."
        )
        break
      }
      _position._unsafelyUnwrappedUnchecked[index] = value
      formIndex(after: &index)
    }
    return index
  }
  @inlinable
  public func moveInitialize(fromContentsOf source: Self) -> Index {
    guard let sourceAddress = source.baseAddress, !source.isEmpty else {
      return startIndex
    }
    _precondition(
      source.count <= self.count,
      "buffer cannot contain every element from source."
    )
    baseAddress?.moveInitialize(from: sourceAddress, count: source.count)
    return startIndex.advanced(by: source.count)
  }
  @inlinable
  public func moveInitialize(fromContentsOf source: Slice<Self>) -> Index {
    return moveInitialize(fromContentsOf: Self(rebasing: source))
  }
  @inlinable
  public func moveUpdate(fromContentsOf source: Self) -> Index {
    guard let sourceAddress = source.baseAddress, !source.isEmpty else {
      return startIndex
    }
    _precondition(
      source.count <= self.count,
      "buffer cannot contain every element from source."
    )
    baseAddress?.moveUpdate(from: sourceAddress, count: source.count)
    return startIndex.advanced(by: source.count)
  }
  @inlinable
  public func moveUpdate(fromContentsOf source: Slice<Self>) -> Index {
    return moveUpdate(fromContentsOf: Self(rebasing: source))
  }
  @discardableResult
  @inlinable
  public func deinitialize() -> UnsafeMutableRawBufferPointer {
    guard let rawValue = baseAddress?._rawValue
      else { return .init(start: nil, count: 0) }
    Builtin.destroyArray(Element.self, rawValue, count._builtinWordValue)
    return .init(start: UnsafeMutableRawPointer(rawValue),
                 count: count*MemoryLayout<Element>.stride)
   }
  @inlinable
  public func initializeElement(at index: Index, to value: Element) {
    _debugPrecondition(startIndex <= index && index < endIndex)
    let p = baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index)
    p.initialize(to: value)
  }
  @inlinable
  public func moveElement(from index: Index) -> Element {
    _debugPrecondition(startIndex <= index && index < endIndex)
    return baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index).move()
  }
  @inlinable
  public func deinitializeElement(at index: Index) {
    _debugPrecondition(startIndex <= index && index < endIndex)
    let p = baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index)
    p.deinitialize(count: 1)
  }
  @inlinable 
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (_ buffer: UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    guard let base = _position?._rawValue else {
      return try body(.init(start: nil, count: 0))
    }
    _debugPrecondition(
      Int(bitPattern: .init(base)) & (MemoryLayout<T>.alignment-1) == 0,
      "baseAddress must be a properly aligned pointer for types Element and T"
    )
    let newCount: Int
    if MemoryLayout<T>.stride == MemoryLayout<Element>.stride {
      newCount = count
    } else {
      newCount = count * MemoryLayout<Element>.stride / MemoryLayout<T>.stride
      _debugPrecondition(
        MemoryLayout<T>.stride > MemoryLayout<Element>.stride
        ? MemoryLayout<T>.stride % MemoryLayout<Element>.stride == 0
        : MemoryLayout<Element>.stride % MemoryLayout<T>.stride == 0,
        "Buffer must contain a whole number of Element instances"
      )
    }
    let binding = Builtin.bindMemory(base, newCount._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(base, binding) }
    return try body(.init(start: .init(base), count: newCount))
  }
  @available(*, unavailable)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    return try withMemoryRebound(to: T.self, body)
  }
  @inlinable 
  public var baseAddress: UnsafeMutablePointer<Element>? {
    return _position
  }
}
extension UnsafeMutableBufferPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "UnsafeMutableBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
@frozen 
public struct UnsafeBufferPointer<Element> {
  @usableFromInline
  let _position: UnsafePointer<Element>?
  public let count: Int
  internal init(
    count: Int
  ) {
    _position = start
    self.count = count
  }
  @inlinable 
  public init(
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeBufferPointer with negative count")
    _debugPrecondition(
      count == 0 || start != nil,
      "UnsafeBufferPointer has a nil start and nonzero count")
    self.init(_uncheckedStart: start, count: _assumeNonNegative(count))
  }
  @inlinable 
  public init(_empty: ()) {
    _position = nil
    count = 0
  }
  @inlinable 
  public init(_ other: UnsafeMutableBufferPointer<Element>) {
    _position = UnsafePointer<Element>(other._position)
    count = other.count
  }
}
extension UnsafeBufferPointer {
  @frozen 
  public struct Iterator {
    @usableFromInline
    internal var _position, _end: UnsafePointer<Element>?
    @inlinable 
    public init(_position: UnsafePointer<Element>?, _end: UnsafePointer<Element>?) {
        self._position = _position
        self._end = _end
    }
  }
}
extension UnsafeBufferPointer.Iterator: IteratorProtocol {
  @inlinable 
  public mutating func next() -> Element? {
    guard let start = _position else {
      return nil
    }
    _internalInvariant(_end != nil, "inconsistent _position, _end pointers")
    if start == _end._unsafelyUnwrappedUnchecked { return nil }
    let result = start.pointee
    _position  = start + 1
    return result
  }
}
extension UnsafeBufferPointer: Sequence {
  @inlinable 
  public func makeIterator() -> Iterator {
    guard let start = _position else {
      return Iterator(_position: nil, _end: nil)
    }
    return Iterator(_position: start, _end: start + count)
  }
  @inlinable 
  public func _copyContents(
    initializing destination: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    guard !isEmpty && !destination.isEmpty else { return (makeIterator(), 0) }
    let s = self.baseAddress._unsafelyUnwrappedUnchecked
    let d = destination.baseAddress._unsafelyUnwrappedUnchecked
    let n = Swift.min(destination.count, self.count)
    d.initialize(from: s, count: n)
    return (Iterator(_position: s + n, _end: s + count), n)
  }
}
extension UnsafeBufferPointer: Collection, RandomAccessCollection {
  public typealias Index = Int
  public typealias Indices = Range<Int>
  @inlinable 
  public var startIndex: Int { return 0 }
  @inlinable 
  public var endIndex: Int { return count }
  @inlinable 
  public func index(after i: Int) -> Int {
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func formIndex(after i: inout Int) {
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }
  @inlinable 
  public func index(before i: Int) -> Int {
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func formIndex(before i: inout Int) {
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }
  @inlinable 
  public func index(_ i: Int, offsetBy n: Int) -> Int {
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? {
    let maxOffset = limit.subtractingReportingOverflow(i)
    _debugPrecondition(!maxOffset.overflow)
    let l = maxOffset.partialValue
    if n > 0 ? l >= 0 && l < n : l <= 0 && n < l {
      return nil
    }
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func distance(from start: Int, to end: Int) -> Int {
    let result = end.subtractingReportingOverflow(start)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }
  @inlinable 
  public func _failEarlyRangeCheck(_ index: Int, bounds: Range<Int>) {
    _debugPrecondition(index >= bounds.lowerBound)
    _debugPrecondition(index < bounds.upperBound)
  }
  @inlinable 
  public func _failEarlyRangeCheck(_ range: Range<Int>, bounds: Range<Int>) {
    _debugPrecondition(range.lowerBound >= bounds.lowerBound)
    _debugPrecondition(range.upperBound <= bounds.upperBound)
  }
  @inlinable 
  public var indices: Indices {
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }
  @inlinable 
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
  }
  @inlinable 
  internal subscript(_unchecked i: Int) -> Element {
    get {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
  }
  @inlinable 
  public subscript(bounds: Range<Int>)
    -> Slice<UnsafeBufferPointer<Element>>
  {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(
        base: self, bounds: bounds)
    }
  }
}
extension UnsafeBufferPointer {
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try body(self)
  }
  @inlinable 
  public init(rebasing slice: Slice<UnsafeBufferPointer<Element>>) {
    _debugPrecondition(
      slice.startIndex >= 0 && slice.endIndex <= slice.base.count,
      "Invalid slice")
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable 
  public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable 
  public func deallocate() {
    _position?.deallocate()
  }
  @inlinable 
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (_ buffer: UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    guard let base = _position?._rawValue else {
      return try body(.init(start: nil, count: 0))
    }
    _debugPrecondition(
      Int(bitPattern: .init(base)) & (MemoryLayout<T>.alignment-1) == 0,
      "baseAddress must be a properly aligned pointer for types Element and T"
    )
    let newCount: Int
    if MemoryLayout<T>.stride == MemoryLayout<Element>.stride {
      newCount = count
    } else {
      newCount = count * MemoryLayout<Element>.stride / MemoryLayout<T>.stride
      _debugPrecondition(
        MemoryLayout<T>.stride > MemoryLayout<Element>.stride
        ? MemoryLayout<T>.stride % MemoryLayout<Element>.stride == 0
        : MemoryLayout<Element>.stride % MemoryLayout<T>.stride == 0,
        "Buffer must contain a whole number of Element instances"
      )
    }
    let binding = Builtin.bindMemory(base, newCount._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(base, binding) }
    return try body(.init(start: .init(base), count: newCount))
  }
  @available(*, unavailable)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    return try withMemoryRebound(to: T.self, body)
  }
  @inlinable 
  public var baseAddress: UnsafePointer<Element>? {
    return _position
  }
}
extension UnsafeBufferPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "UnsafeBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
