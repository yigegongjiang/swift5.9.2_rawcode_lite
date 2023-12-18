@frozen
public struct UnsafeMutableRawBufferPointer {
  @usableFromInline
  internal let _position, _end: UnsafeMutableRawPointer?
  @inlinable
  public init(
  ) {
    _debugPrecondition(count >= 0, "UnsafeMutableRawBufferPointer with negative count")
    _debugPrecondition(count == 0 || start != nil,
      "UnsafeMutableRawBufferPointer has a nil start and nonzero count")
    _position = start
    _end = start.map { $0 + _assumeNonNegative(count) }
  }
}
extension UnsafeMutableRawBufferPointer {
  public typealias Iterator = UnsafeRawBufferPointer.Iterator
}
extension UnsafeMutableRawBufferPointer: Sequence {
  public typealias SubSequence = Slice<UnsafeMutableRawBufferPointer>
  @inlinable
  public func makeIterator() -> Iterator {
    return Iterator(_position: _position, _end: _end)
  }
  @inlinable 
  public func _copyContents(
    initializing destination: UnsafeMutableBufferPointer<UInt8>
  ) -> (Iterator, UnsafeMutableBufferPointer<UInt8>.Index) {
    guard let s = _position, let e = _end, e > s, !destination.isEmpty else {
      return (makeIterator(), 0)
    }
    let destinationAddress = destination.baseAddress._unsafelyUnwrappedUnchecked
    let d = UnsafeMutableRawPointer(destinationAddress)
    let n = Swift.min(destination.count, s.distance(to: e))
    d.copyMemory(from: s, byteCount: n)
    return (Iterator(_position: s.advanced(by: n), _end: e), n)
  }
}
extension UnsafeMutableRawBufferPointer: MutableCollection {
  public typealias Element = UInt8
  public typealias Index = Int
  public typealias Indices = Range<Int>
  @inlinable
  public var startIndex: Index {
    return 0
  }
  @inlinable
  public var endIndex: Index {
    return count
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
      return _position._unsafelyUnwrappedUnchecked.load(fromByteOffset: i, as: UInt8.self)
    }
    nonmutating set {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      _position._unsafelyUnwrappedUnchecked.storeBytes(of: newValue, toByteOffset: i, as: UInt8.self)
    }
  }
  @inlinable
  public subscript(bounds: Range<Int>) -> SubSequence {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(base: self, bounds: bounds)
    }
    nonmutating set {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      _debugPrecondition(bounds.count == newValue.count)
      if !newValue.isEmpty {
        (baseAddress! + bounds.lowerBound).copyMemory(
          from: newValue.base.baseAddress! + newValue.startIndex,
          byteCount: newValue.count)
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
    let tmp = pi.load(fromByteOffset: 0, as: UInt8.self)
    pi.copyMemory(from: pj, byteCount: MemoryLayout<UInt8>.size)
    pj.storeBytes(of: tmp, toByteOffset: 0, as: UInt8.self)
  }
  @inlinable
  public var count: Int {
    if let pos = _position {
      _internalInvariant(_end != nil)
      return _assumeNonNegative(_end._unsafelyUnwrappedUnchecked - pos)
    }
    return 0
  }
}
extension UnsafeMutableRawBufferPointer: RandomAccessCollection { }
extension UnsafeMutableRawBufferPointer {
  @inlinable
  public static func allocate(
    byteCount: Int, alignment: Int
  ) -> UnsafeMutableRawBufferPointer {
    let base = UnsafeMutableRawPointer.allocate(
      byteCount: byteCount, alignment: alignment)
    return UnsafeMutableRawBufferPointer(start: base, count: byteCount)
  }
  @inlinable
  public func deallocate() {
    _position?.deallocate()
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.load out of bounds")
    return baseAddress!.load(fromByteOffset: offset, as: T.self)
  }
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.load out of bounds")
    return baseAddress!.loadUnaligned(fromByteOffset: offset, as: T.self)
  }
  @inlinable
  public func storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.storeBytes with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.storeBytes out of bounds")
    let pointer = baseAddress._unsafelyUnwrappedUnchecked
    pointer.storeBytes(of: value, toByteOffset: offset, as: T.self)
  }
  @available(*, unavailable)
  @usableFromInline func _legacy_se0349_storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.storeBytes with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.storeBytes out of bounds")
    baseAddress!._legacy_se0349_storeBytes_internal(
      of: value, toByteOffset: offset, as: T.self
    )
  }
  @inlinable
  public func copyMemory(from source: UnsafeRawBufferPointer) {
    _debugPrecondition(source.count <= self.count,
      "UnsafeMutableRawBufferPointer.copyMemory source has too many elements")
    if let baseAddress = baseAddress, let sourceAddress = source.baseAddress {
      baseAddress.copyMemory(from: sourceAddress, byteCount: source.count)
    }
  }
  @inlinable
  public func copyBytes<C: Collection>(
    from source: C
  ) where C.Element == UInt8 {
    guard let position = _position else {
      return
    }
    if source.withContiguousStorageIfAvailable({
      (buffer: UnsafeBufferPointer<UInt8>) -> Void in
      _debugPrecondition(source.count <= self.count,
        "UnsafeMutableRawBufferPointer.copyBytes source has too many elements")
      if let base = buffer.baseAddress {
        position.copyMemory(from: base, byteCount: buffer.count)
      }
    }) != nil {
      return
    }
    for (index, byteValue) in source.enumerated() {
      _debugPrecondition(index < self.count,
        "UnsafeMutableRawBufferPointer.copyBytes source has too many elements")
      position.storeBytes(
        of: byteValue, toByteOffset: index, as: UInt8.self)
    }
  }
  @inlinable
  public init(_ bytes: UnsafeMutableRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }
  @inlinable
  public init(mutating bytes: UnsafeRawBufferPointer) {
    self.init(start: UnsafeMutableRawPointer(mutating: bytes.baseAddress),
      count: bytes.count)
  }
  @inlinable
  public init<T>(_ buffer: UnsafeMutableBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }
  @inlinable
  public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable
  public var baseAddress: UnsafeMutableRawPointer? {
    return _position
  }
  @inlinable
  @discardableResult
  public func initializeMemory<T>(as type: T.Type, repeating repeatedValue: T)
    -> UnsafeMutableBufferPointer<T> {
    guard let base = _position else {
      return .init(start: nil, count: 0)
    }
    let count = (_end._unsafelyUnwrappedUnchecked-base) / MemoryLayout<T>.stride
    let initialized = base.initializeMemory(
      as: type, repeating: repeatedValue, count: count
    )
    return .init(start: initialized, count: count)
  }
  @inlinable
  public func initializeMemory<S: Sequence>(
    as type: S.Element.Type, from source: S
  ) -> (unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>) {
    var it = source.makeIterator()
    var idx = startIndex
    let elementStride = MemoryLayout<S.Element>.stride
    _debugPrecondition(source.underestimatedCount <= (count / elementStride),
      "insufficient space to accommodate source.underestimatedCount elements")
    guard let base = baseAddress else {
      _precondition(source.underestimatedCount == 0, 
        "no memory available to initialize from source")
      return (it, UnsafeMutableBufferPointer(start: nil, count: 0))
    }  
    _debugPrecondition(
      Int(bitPattern: base) % MemoryLayout<S.Element>.stride == 0,
      "buffer base address must be properly aligned to access S.Element"
    )
    _internalInvariant(_end != nil)
    for p in stride(from: base, 
      to: _end._unsafelyUnwrappedUnchecked - elementStride + 1, 
      by: elementStride
    ) {
      guard let x = it.next() else { break }
      p.initializeMemory(as: S.Element.self, repeating: x, count: 1)
      formIndex(&idx, offsetBy: elementStride)
    }
    return (it, UnsafeMutableBufferPointer(
                  start: base.assumingMemoryBound(to: S.Element.self), 
                  count: idx / elementStride))
  }
  @inlinable
  public func initializeMemory<C: Collection>(
    as type: C.Element.Type,
    fromContentsOf source: C
  ) -> UnsafeMutableBufferPointer<C.Element> {
    let buffer: UnsafeMutableBufferPointer<C.Element>?
    buffer = source.withContiguousStorageIfAvailable {
      guard let sourceAddress = $0.baseAddress, !$0.isEmpty else {
        return .init(start: nil, count: 0)
      }
      _debugPrecondition(
        Int(bitPattern: baseAddress) % MemoryLayout<C.Element>.stride == 0,
        "buffer base address must be properly aligned to access C.Element"
      )
      _precondition(
        $0.count * MemoryLayout<C.Element>.stride < self.count,
        "buffer cannot contain every element from source collection."
      )
      let start = baseAddress?.initializeMemory(
        as: C.Element.self, from: sourceAddress, count: $0.count
      )
      return .init(start: start, count: $0.count)
    }
    if let buffer {
      return buffer
    }
    guard let base = baseAddress else {
      _precondition(
        source.isEmpty,
        "buffer cannot contain every element from source collection."
      )
      return .init(start: nil, count: 0)
    }
    _internalInvariant(_end != nil)
    _debugPrecondition(
      Int(bitPattern: baseAddress) % MemoryLayout<C.Element>.stride == 0,
      "buffer base address must be properly aligned to access C.Element"
    )
    var iterator = source.makeIterator()
    var element = base
    var initialized = 0
    let end = _end._unsafelyUnwrappedUnchecked - MemoryLayout<C.Element>.stride
    while element <= end {
      guard let value = iterator.next() else {
        return .init(start: .init(base._rawValue), count: initialized)
      }
      element.initializeMemory(as: C.Element.self, to: value)
      element = element.advanced(by: MemoryLayout<C.Element>.stride)
      initialized += 1
    }
    _precondition(
      iterator.next() == nil,
      "buffer cannot contain every element from source collection."
    )
    return .init(start: .init(base._rawValue), count: initialized)
  }
  @discardableResult
  @inlinable
  public func moveInitializeMemory<T>(
    as type: T.Type,
    fromContentsOf source: UnsafeMutableBufferPointer<T>
  ) -> UnsafeMutableBufferPointer<T> {
    guard let sourceAddress = source.baseAddress, !source.isEmpty else {
      return .init(start: nil, count: 0)
    }
    _debugPrecondition(
      Int(bitPattern: baseAddress) % MemoryLayout<T>.stride == 0,
      "buffer base address must be properly aligned to access T"
    )
    _precondition(
      source.count * MemoryLayout<T>.stride <= self.count,
      "buffer cannot contain every element from source."
    )
    let initialized = baseAddress?.moveInitializeMemory(
      as: T.self, from: sourceAddress, count: source.count
    )
    return .init(start: initialized, count: source.count)
  }
  @discardableResult
  @inlinable
  public func moveInitializeMemory<T>(
    as type: T.Type,
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<T>>
  ) -> UnsafeMutableBufferPointer<T> {
    let rebased = UnsafeMutableBufferPointer(rebasing: source)
    return moveInitializeMemory(as: T.self, fromContentsOf: rebased)
  }
  @discardableResult
  public func bindMemory<T>(
    to type: T.Type
  ) -> UnsafeMutableBufferPointer<T> {
    guard let base = _position else {
      return UnsafeMutableBufferPointer<T>(start: nil, count: 0)
    }
    let capacity = count / MemoryLayout<T>.stride
    Builtin.bindMemory(base._rawValue, capacity._builtinWordValue, type)
    return UnsafeMutableBufferPointer<T>(
      start: UnsafeMutablePointer<T>(base._rawValue), count: capacity)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (_ buffer: UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    guard let s = _position else {
      return try body(.init(start: nil, count: 0))
    }
    _debugPrecondition(
      Int(bitPattern: s) & (MemoryLayout<T>.alignment-1) == 0,
      "baseAddress must be a properly aligned pointer for type T"
    )
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    let binding = Builtin.bindMemory(s._rawValue, n._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(s._rawValue, binding) }
    return try body(.init(start: .init(s._rawValue), count: n))
  }
  @inlinable
  public func assumingMemoryBound<T>(
    to: T.Type
  ) -> UnsafeMutableBufferPointer<T> {
    guard let s = _position else {
      return .init(start: nil, count: 0)
    }
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    return .init(start: .init(s._rawValue), count: n)
  }
  @inlinable
  public func withContiguousMutableStorageIfAvailable<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    try withMemoryRebound(to: Element.self) { b in
      var buffer = b
      defer {
        _debugPrecondition(
          (b.baseAddress, b.count) == (buffer.baseAddress, buffer.count),
          "UnsafeMutableRawBufferPointer.withContiguousMutableStorageIfAvailable: replacing the buffer is not allowed"
        )
      }
      return try body(&buffer)
    }
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    try withMemoryRebound(to: Element.self) {
      try body(UnsafeBufferPointer<Element>($0))
    }
  }
}
extension UnsafeMutableRawBufferPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "UnsafeMutableRawBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
extension UnsafeMutableRawBufferPointer {
  @available(*, unavailable, 
    message: "use 'UnsafeMutableRawBufferPointer(rebasing:)' to convert a slice into a zero-based raw buffer.")
  public subscript(bounds: Range<Int>) -> UnsafeMutableRawBufferPointer {
    get { return UnsafeMutableRawBufferPointer(start: nil, count: 0) }
    nonmutating set {}
  }
  @available(*, unavailable, 
    message: "use 'UnsafeRawBufferPointer(rebasing:)' to convert a slice into a zero-based raw buffer.")
  public subscript(bounds: Range<Int>) -> UnsafeRawBufferPointer {
    get { return UnsafeRawBufferPointer(start: nil, count: 0) }
    nonmutating set {}
  }
}
@frozen
public struct UnsafeRawBufferPointer {
  @usableFromInline
  internal let _position, _end: UnsafeRawPointer?
  @inlinable
  public init(
  ) {
    _debugPrecondition(count >= 0, "UnsafeRawBufferPointer with negative count")
    _debugPrecondition(count == 0 || start != nil,
      "UnsafeRawBufferPointer has a nil start and nonzero count")
    _position = start
    _end = start.map { $0 + _assumeNonNegative(count) }
  }
}
extension UnsafeRawBufferPointer {
  @frozen
  public struct Iterator {
    @usableFromInline
    internal var _position, _end: UnsafeRawPointer?
    @inlinable
    internal init(_position: UnsafeRawPointer?, _end: UnsafeRawPointer?) {
      self._position = _position
      self._end = _end
    }
  }
}
extension UnsafeRawBufferPointer.Iterator: IteratorProtocol, Sequence {
  @inlinable
  public mutating func next() -> UInt8? {
    if _position == _end { return nil }
    _debugPrecondition(_position! < _end!)
    let position = _position._unsafelyUnwrappedUnchecked
    let result = position.load(as: UInt8.self)
    _position = position + 1
    return result
  }
}
extension UnsafeRawBufferPointer: Sequence {
  public typealias SubSequence = Slice<UnsafeRawBufferPointer>
  @inlinable
  public func makeIterator() -> Iterator {
    return Iterator(_position: _position, _end: _end)
  }
  @inlinable 
  public func _copyContents(
    initializing destination: UnsafeMutableBufferPointer<UInt8>
  ) -> (Iterator, UnsafeMutableBufferPointer<UInt8>.Index) {
    guard let s = _position, let e = _end, e > s, !destination.isEmpty else {
      return (makeIterator(), 0)
    }
    let destinationAddress = destination.baseAddress._unsafelyUnwrappedUnchecked
    let d = UnsafeMutableRawPointer(destinationAddress)
    let n = Swift.min(destination.count, s.distance(to: e))
    d.copyMemory(from: s, byteCount: n)
    return (Iterator(_position: s.advanced(by: n), _end: e), n)
  }
}
extension UnsafeRawBufferPointer: Collection {
  public typealias Element = UInt8
  public typealias Index = Int
  public typealias Indices = Range<Int>
  @inlinable
  public var startIndex: Index {
    return 0
  }
  @inlinable
  public var endIndex: Index {
    return count
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
      return _position._unsafelyUnwrappedUnchecked.load(fromByteOffset: i, as: UInt8.self)
    }
  }
  @inlinable
  public subscript(bounds: Range<Int>) -> SubSequence {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(base: self, bounds: bounds)
    }
  }
  @inlinable
  public var count: Int {
    if let pos = _position {
      _internalInvariant(_end != nil)
      return _assumeNonNegative(_end._unsafelyUnwrappedUnchecked - pos)
    }
    return 0
  }
}
extension UnsafeRawBufferPointer: RandomAccessCollection { }
extension UnsafeRawBufferPointer {
  @inlinable
  public func deallocate() {
    _position?.deallocate()
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(offset >= 0, "UnsafeRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeRawBufferPointer.load out of bounds")
    return baseAddress!.load(fromByteOffset: offset, as: T.self)
  }
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(offset >= 0, "UnsafeRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeRawBufferPointer.load out of bounds")
    return baseAddress!.loadUnaligned(fromByteOffset: offset, as: T.self)
  }
  @inlinable
  public init(_ bytes: UnsafeMutableRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }
  @inlinable
  public init(_ bytes: UnsafeRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }
  @inlinable
  public init<T>(_ buffer: UnsafeMutableBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }
  @inlinable
  public init<T>(_ buffer: UnsafeBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }
  @inlinable
  public init(rebasing slice: Slice<UnsafeRawBufferPointer>) {
    _debugPrecondition(
      slice.startIndex >= 0 && slice.endIndex <= slice.base.count,
      "Invalid slice")
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable
  public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
  @inlinable
  public var baseAddress: UnsafeRawPointer? {
    return _position
  }
  @discardableResult
  public func bindMemory<T>(
    to type: T.Type
  ) -> UnsafeBufferPointer<T> {
    guard let base = _position else {
      return UnsafeBufferPointer<T>(start: nil, count: 0)
    }
    let capacity = count / MemoryLayout<T>.stride
    Builtin.bindMemory(base._rawValue, capacity._builtinWordValue, type)
    return UnsafeBufferPointer<T>(
      start: UnsafePointer<T>(base._rawValue), count: capacity)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (_ buffer: UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    guard let s = _position else {
      return try body(.init(start: nil, count: 0))
    }
    _debugPrecondition(
      Int(bitPattern: s) & (MemoryLayout<T>.alignment-1) == 0,
      "baseAddress must be a properly aligned pointer for type T"
    )
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    let binding = Builtin.bindMemory(s._rawValue, n._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(s._rawValue, binding) }
    return try body(.init(start: .init(s._rawValue), count: n))
  }
  @inlinable
  public func assumingMemoryBound<T>(
    to: T.Type
  ) -> UnsafeBufferPointer<T> {
    guard let s = _position else {
      return .init(start: nil, count: 0)
    }
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    return .init(start: .init(s._rawValue), count: n)
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    try withMemoryRebound(to: Element.self) {
      try body($0)
    }
  }
}
extension UnsafeRawBufferPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "UnsafeRawBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
extension UnsafeRawBufferPointer {
  @available(*, unavailable, 
    message: "use 'UnsafeRawBufferPointer(rebasing:)' to convert a slice into a zero-based raw buffer.")
  public subscript(bounds: Range<Int>) -> UnsafeRawBufferPointer {
    get { return UnsafeRawBufferPointer(start: nil, count: 0) }
  }
}
@inlinable
public func withUnsafeMutableBytes<T, Result>(
  of value: inout T,
  _ body: (UnsafeMutableRawBufferPointer) throws -> Result
) rethrows -> Result
{
  return try withUnsafeMutablePointer(to: &value) {
    return try body(UnsafeMutableRawBufferPointer(
        start: $0, count: MemoryLayout<T>.size))
  }
}
@inlinable
public func withUnsafeBytes<T, Result>(
  of value: inout T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result
{
  return try withUnsafePointer(to: &value) {
    try body(UnsafeRawBufferPointer(start: $0, count: MemoryLayout<T>.size))
  }
}
public func _withUnprotectedUnsafeBytes<T, Result>(
  of value: inout T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result
{
  return try _withUnprotectedUnsafePointer(to: &value) {
    try body(UnsafeRawBufferPointer(start: $0, count: MemoryLayout<T>.size))
  }
}
@inlinable
public func withUnsafeBytes<T, Result>(
  of value: T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result {
  let addr = UnsafeRawPointer(Builtin.addressOfBorrow(value))
  let buffer = UnsafeRawBufferPointer(start: addr, count: MemoryLayout<T>.size)
  return try body(buffer)
}
public func _withUnprotectedUnsafeBytes<T, Result>(
  of value: T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result {
#if $BuiltinUnprotectedAddressOf
  let addr = UnsafeRawPointer(Builtin.unprotectedAddressOfBorrow(value))
#else
  let addr = UnsafeRawPointer(Builtin.addressOfBorrow(value))
#endif
  let buffer = UnsafeRawBufferPointer(start: addr, count: MemoryLayout<T>.size)
  return try body(buffer)
}
