extension Slice where Base == UnsafeMutableRawBufferPointer {
  @inlinable
  public func copyBytes<C: Collection>(
    from source: C
  ) where C.Element == UInt8 {
    let buffer = Base(rebasing: self)
    buffer.copyBytes(from: source)
  }
  @discardableResult
  @inlinable
  public func initializeMemory<T>(
    as type: T.Type, repeating repeatedValue: T
  ) -> UnsafeMutableBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.initializeMemory(as: T.self, repeating: repeatedValue)
  }
  @inlinable
  public func initializeMemory<S: Sequence>(
    as type: S.Element.Type, from source: S
  ) -> (unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>) {
    let buffer = Base(rebasing: self)
    return buffer.initializeMemory(as: S.Element.self, from: source)
  }
  @inlinable
  public func initializeMemory<C: Collection>(
    as type: C.Element.Type,
    fromContentsOf source: C
  ) -> UnsafeMutableBufferPointer<C.Element> {
    let buffer = Base(rebasing: self)
    return buffer.initializeMemory(as: C.Element.self, fromContentsOf: source)
  }
  @discardableResult
  @inlinable
  public func moveInitializeMemory<T>(
    as type: T.Type,
    fromContentsOf source: UnsafeMutableBufferPointer<T>
  ) -> UnsafeMutableBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.moveInitializeMemory(as: T.self, fromContentsOf: source)
  }
  @discardableResult
  @inlinable
  public func moveInitializeMemory<T>(
    as type: T.Type,
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<T>>
  ) -> UnsafeMutableBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.moveInitializeMemory(as: T.self, fromContentsOf: source)
  }
  @discardableResult
  @inlinable
  public func bindMemory<T>(to type: T.Type) -> UnsafeMutableBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.bindMemory(to: T.self)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    let buffer = Base(rebasing: self)
    return try buffer.withMemoryRebound(to: T.self, body)
  }
  @inlinable
  public func assumingMemoryBound<T>(
    to type: T.Type
  ) -> UnsafeMutableBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.assumingMemoryBound(to: T.self)
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    let buffer = Base(rebasing: self)
    return buffer.load(fromByteOffset: offset, as: T.self)
  }
  @inlinable
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    let buffer = Base(rebasing: self)
    return buffer.loadUnaligned(fromByteOffset: offset, as: T.self)
  }
  @inlinable
  public func storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    let buffer = Base(rebasing: self)
    buffer.storeBytes(of: value, toByteOffset: offset, as: T.self)
  }
}
extension Slice where Base == UnsafeRawBufferPointer {
  @discardableResult
  @inlinable
  public func bindMemory<T>(to type: T.Type) -> UnsafeBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.bindMemory(to: T.self)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    let buffer = Base(rebasing: self)
    return try buffer.withMemoryRebound(to: T.self, body)
  }
  @inlinable
  public func assumingMemoryBound<T>(
    to type: T.Type
  ) -> UnsafeBufferPointer<T> {
    let buffer = Base(rebasing: self)
    return buffer.assumingMemoryBound(to: T.self)
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    let buffer = Base(rebasing: self)
    return buffer.load(fromByteOffset: offset, as: T.self)
  }
  @inlinable
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    let buffer = Base(rebasing: self)
    return buffer.loadUnaligned(fromByteOffset: offset, as: T.self)
  }
}
extension Slice {
  @inlinable
  public func withMemoryRebound<T, Result, Element>(
    to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result where Base == UnsafeBufferPointer<Element> {
    let rebased = UnsafeBufferPointer<Element>(rebasing: self)
    return try rebased.withMemoryRebound(to: T.self, body)
  }
}
extension Slice {
  @inlinable
  public func initialize<Element>(repeating repeatedValue: Element)
    where Base == UnsafeMutableBufferPointer<Element> {
    Base(rebasing: self).initialize(repeating: repeatedValue)
  }
  @inlinable
  public func initialize<S>(
    from source: S
  ) -> (unwritten: S.Iterator, index: Index)
    where S: Sequence, Base == UnsafeMutableBufferPointer<S.Element> {
    let buffer = Base(rebasing: self)
    let (iterator, index) = buffer.initialize(from: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return (iterator, startIndex.advanced(by: distance))
  }
  @inlinable
  public func initialize<C: Collection>(
    fromContentsOf source: C
  ) -> Index where Base == UnsafeMutableBufferPointer<C.Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.initialize(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @inlinable
  public func update<Element>(repeating repeatedValue: Element)
    where Base == UnsafeMutableBufferPointer<Element> {
    Base(rebasing: self).update(repeating: repeatedValue)
  }
  @inlinable
  public func update<S>(
    from source: S
  ) -> (unwritten: S.Iterator, index: Index)
    where S: Sequence, Base == UnsafeMutableBufferPointer<S.Element> {
    let buffer = Base(rebasing: self)
    let (iterator, index) = buffer.update(from: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return (iterator, startIndex.advanced(by: distance))
  }
  @inlinable
  public func update<C: Collection>(
    fromContentsOf source: C
  ) -> Index where Base == UnsafeMutableBufferPointer<C.Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.update(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @inlinable
  public func moveInitialize<Element>(
    fromContentsOf source: UnsafeMutableBufferPointer<Element>
  ) -> Index where Base == UnsafeMutableBufferPointer<Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.moveInitialize(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @inlinable
  public func moveInitialize<Element>(
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>
  ) -> Index where Base == UnsafeMutableBufferPointer<Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.moveInitialize(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @inlinable
  public func moveUpdate<Element>(
    fromContentsOf source: UnsafeMutableBufferPointer<Element>
  ) -> Index where Base == UnsafeMutableBufferPointer<Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.moveUpdate(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @inlinable
  public func moveUpdate<Element>(
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>
  ) -> Index where Base == UnsafeMutableBufferPointer<Element> {
    let buffer = Base(rebasing: self)
    let index = buffer.moveUpdate(fromContentsOf: source)
    let distance = buffer.distance(from: buffer.startIndex, to: index)
    return startIndex.advanced(by: distance)
  }
  @discardableResult
  @inlinable
  public func deinitialize<Element>() -> UnsafeMutableRawBufferPointer
    where Base == UnsafeMutableBufferPointer<Element> {
    Base(rebasing: self).deinitialize()
  }
  @inlinable
  public func initializeElement<Element>(at index: Int, to value: Element)
    where Base == UnsafeMutableBufferPointer<Element> {
    assert(startIndex <= index && index < endIndex)
    base.baseAddress.unsafelyUnwrapped.advanced(by: index).initialize(to: value)
  }
  @inlinable
  public func moveElement<Element>(from index: Index) -> Element
    where Base == UnsafeMutableBufferPointer<Element> {
    assert(startIndex <= index && index < endIndex)
    return base.baseAddress.unsafelyUnwrapped.advanced(by: index).move()
  }
  @inlinable
  public func deinitializeElement<Element>(at index: Base.Index)
    where Base == UnsafeMutableBufferPointer<Element> {
    assert(startIndex <= index && index < endIndex)
    base.baseAddress.unsafelyUnwrapped.advanced(by: index).deinitialize(count: 1)
  }
  @inlinable
  public func withMemoryRebound<T, Result, Element>(
    to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result where Base == UnsafeMutableBufferPointer<Element> {
    try Base(rebasing: self).withMemoryRebound(to: T.self, body)
  }
  @inlinable
  public func withContiguousMutableStorageIfAvailable<R, Element>(
    _ body: (_ buffer: inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? where Base == UnsafeMutableBufferPointer<Element> {
    try base.withContiguousStorageIfAvailable { buffer in
      let start = base.baseAddress?.advanced(by: startIndex)
      var slice = UnsafeMutableBufferPointer(start: start, count: count)
      let (b,c) = (slice.baseAddress, slice.count)
      defer {
        _precondition(
          slice.baseAddress == b && slice.count == c,
          "withContiguousMutableStorageIfAvailable: replacing the buffer is not allowed")
      }
      return try body(&slice)
    }
  }
}
