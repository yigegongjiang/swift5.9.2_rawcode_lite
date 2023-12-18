@frozen
public struct UnsafeRawPointer: _Pointer {
  public typealias Pointee = UInt8
  public let _rawValue: Builtin.RawPointer
  public init(_ _rawValue: Builtin.RawPointer) {
    self._rawValue = _rawValue
  }
    _rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    _rawValue = unwrapped._rawValue
  }
    _rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    _rawValue = unwrapped._rawValue
  }
    _rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    _rawValue = unwrapped._rawValue
  }
  @inlinable
  public func deallocate() {
    Builtin.deallocRaw(_rawValue, (-1)._builtinWordValue, (0)._builtinWordValue)
  }
  @discardableResult
  public func bindMemory<T>(
    to type: T.Type, capacity count: Int
  ) -> UnsafePointer<T> {
    Builtin.bindMemory(_rawValue, count._builtinWordValue, type)
    return UnsafePointer<T>(_rawValue)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (_ pointer: UnsafePointer<T>) throws -> Result
  ) rethrows -> Result {
    _debugPrecondition(
      Int(bitPattern: self) & (MemoryLayout<T>.alignment-1) == 0,
      "self must be a properly aligned pointer for type T"
    )
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  public func assumingMemoryBound<T>(to: T.Type) -> UnsafePointer<T> {
    return UnsafePointer<T>(_rawValue)
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(0 == (UInt(bitPattern: self + offset)
        & (UInt(MemoryLayout<T>.alignment) - 1)),
      "load from misaligned raw pointer")
    let rawPointer = (self + offset)._rawValue
#if compiler(>=5.5) && $BuiltinAssumeAlignment
    let alignedPointer =
      Builtin.assumeAlignment(rawPointer,
                              MemoryLayout<T>.alignment._builtinWordValue)
    return Builtin.loadRaw(alignedPointer)
#else
    return Builtin.loadRaw(rawPointer)
#endif
  }
  @inlinable
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(_isPOD(T.self))
    return _withUnprotectedUnsafeTemporaryAllocation(of: T.self, capacity: 1) {
      let temporary = $0.baseAddress._unsafelyUnwrappedUnchecked
      Builtin.int_memcpy_RawPointer_RawPointer_Int64(
        temporary._rawValue,
        (self + offset)._rawValue,
        UInt64(MemoryLayout<T>.size)._value,
         false._value
      )
      return temporary.pointee
    }
  }
}
extension UnsafeRawPointer: Strideable {
  public func advanced(by n: Int) -> UnsafeRawPointer {
    return UnsafeRawPointer(Builtin.gepRaw_Word(_rawValue, n._builtinWordValue))
  }
}
extension UnsafeRawPointer {
  @inlinable
  public func alignedUp<T>(for type: T.Type) -> Self {
    let mask = UInt(Builtin.alignof(T.self)) &- 1
    let bits = (UInt(Builtin.ptrtoint_Word(_rawValue)) &+ mask) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedDown<T>(for type: T.Type) -> Self {
    let mask = UInt(Builtin.alignof(T.self)) &- 1
    let bits = UInt(Builtin.ptrtoint_Word(_rawValue)) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedUp(toMultipleOf alignment: Int) -> Self {
    let mask = UInt(alignment._builtinWordValue) &- 1
    _debugPrecondition(
      alignment > 0 && UInt(alignment._builtinWordValue) & mask == 0,
      "alignment must be a whole power of 2."
    )
    let bits = (UInt(Builtin.ptrtoint_Word(_rawValue)) &+ mask) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedDown(toMultipleOf alignment: Int) -> Self {
    let mask = UInt(alignment._builtinWordValue) &- 1
    _debugPrecondition(
      alignment > 0 && UInt(alignment._builtinWordValue) & mask == 0,
      "alignment must be a whole power of 2."
    )
    let bits = UInt(Builtin.ptrtoint_Word(_rawValue)) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
}
@frozen
public struct UnsafeMutableRawPointer: _Pointer {
  public typealias Pointee = UInt8
  public let _rawValue: Builtin.RawPointer
  public init(_ _rawValue: Builtin.RawPointer) {
    self._rawValue = _rawValue
  }
    _rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    _rawValue = unwrapped._rawValue
  }
    _rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    _rawValue = unwrapped._rawValue
  }
  @inlinable
  public static func allocate(
    byteCount: Int, alignment: Int
  ) -> UnsafeMutableRawPointer {
    var alignment = alignment
    if alignment <= _minAllocationAlignment() {
      alignment = 0
    }
    return UnsafeMutableRawPointer(Builtin.allocRaw(
        byteCount._builtinWordValue, alignment._builtinWordValue))
  }
  @inlinable
  public func deallocate() {
    Builtin.deallocRaw(_rawValue, (-1)._builtinWordValue, (0)._builtinWordValue)
  }
  @discardableResult
  public func bindMemory<T>(
    to type: T.Type, capacity count: Int
  ) -> UnsafeMutablePointer<T> {
    Builtin.bindMemory(_rawValue, count._builtinWordValue, type)
    return UnsafeMutablePointer<T>(_rawValue)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (_ pointer: UnsafeMutablePointer<T>) throws -> Result
  ) rethrows -> Result {
    _debugPrecondition(
      Int(bitPattern: self) & (MemoryLayout<T>.alignment-1) == 0,
      "self must be a properly aligned pointer for type T"
    )
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  public func assumingMemoryBound<T>(to: T.Type) -> UnsafeMutablePointer<T> {
    return UnsafeMutablePointer<T>(_rawValue)
  }
  @discardableResult
  @inlinable
  public func initializeMemory<T>(
    as type: T.Type, to value: T
  ) -> UnsafeMutablePointer<T> {
    Builtin.bindMemory(_rawValue, (1)._builtinWordValue, type)
    Builtin.initialize(value, _rawValue)
    return UnsafeMutablePointer(_rawValue)
  }
  @inlinable
  @discardableResult
  public func initializeMemory<T>(
    as type: T.Type, repeating repeatedValue: T, count: Int
  ) -> UnsafeMutablePointer<T> {
    _debugPrecondition(count >= 0,
      "UnsafeMutableRawPointer.initializeMemory: negative count")
    Builtin.bindMemory(_rawValue, count._builtinWordValue, type)
    var nextPtr = self
    for _ in 0..<count {
      Builtin.initialize(repeatedValue, nextPtr._rawValue)
      nextPtr += MemoryLayout<T>.stride
    }
    return UnsafeMutablePointer(_rawValue)
  }
  @inlinable
  @discardableResult
  public func initializeMemory<T>(
    as type: T.Type, from source: UnsafePointer<T>, count: Int
  ) -> UnsafeMutablePointer<T> {
    _debugPrecondition(
      count >= 0,
      "UnsafeMutableRawPointer.initializeMemory with negative count")
    _debugPrecondition(
      (UnsafeRawPointer(self + count * MemoryLayout<T>.stride)
        <= UnsafeRawPointer(source))
      || UnsafeRawPointer(source + count) <= UnsafeRawPointer(self),
      "UnsafeMutableRawPointer.initializeMemory overlapping range")
    Builtin.bindMemory(_rawValue, count._builtinWordValue, type)
    Builtin.copyArray(
      T.self, self._rawValue, source._rawValue, count._builtinWordValue)
    return UnsafeMutablePointer(_rawValue)
  }
  @inlinable
  @discardableResult
  public func moveInitializeMemory<T>(
    as type: T.Type, from source: UnsafeMutablePointer<T>, count: Int
  ) -> UnsafeMutablePointer<T> {
    _debugPrecondition(
      count >= 0,
      "UnsafeMutableRawPointer.moveInitializeMemory with negative count")
    Builtin.bindMemory(_rawValue, count._builtinWordValue, type)
    if self < UnsafeMutableRawPointer(source)
       || self >= UnsafeMutableRawPointer(source + count) {
      Builtin.takeArrayFrontToBack(
        T.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
    else {
      Builtin.takeArrayBackToFront(
        T.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
    return UnsafeMutablePointer(_rawValue)
  }
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(0 == (UInt(bitPattern: self + offset)
        & (UInt(MemoryLayout<T>.alignment) - 1)),
      "load from misaligned raw pointer")
    let rawPointer = (self + offset)._rawValue
#if compiler(>=5.5) && $BuiltinAssumeAlignment
    let alignedPointer =
      Builtin.assumeAlignment(rawPointer,
                              MemoryLayout<T>.alignment._builtinWordValue)
    return Builtin.loadRaw(alignedPointer)
#else
    return Builtin.loadRaw(rawPointer)
#endif
  }
  @inlinable
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(_isPOD(T.self))
    return _withUnprotectedUnsafeTemporaryAllocation(of: T.self, capacity: 1) {
      let temporary = $0.baseAddress._unsafelyUnwrappedUnchecked
      Builtin.int_memcpy_RawPointer_RawPointer_Int64(
        temporary._rawValue,
        (self + offset)._rawValue,
        UInt64(MemoryLayout<T>.size)._value,
         false._value
      )
      return temporary.pointee
    }
  }
  @inlinable
  public func storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _debugPrecondition(_isPOD(T.self))
    withUnsafePointer(to: value) { source in
      Builtin.int_memcpy_RawPointer_RawPointer_Int64(
        (self + offset)._rawValue,
        source._rawValue,
        UInt64(MemoryLayout<T>.size)._value,
         false._value
      )
    }
  }
  @available(*, unavailable)
  @usableFromInline func _legacy_se0349_storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _legacy_se0349_storeBytes_internal(
      of: value, toByteOffset: offset, as: T.self
    )
  }
  internal func _legacy_se0349_storeBytes_internal<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _debugPrecondition(0 == (UInt(bitPattern: self + offset)
        & (UInt(MemoryLayout<T>.alignment) - 1)),
      "storeBytes to misaligned raw pointer")
    var temp = value
    withUnsafeMutablePointer(to: &temp) { source in
      let rawSrc = UnsafeMutableRawPointer(source)._rawValue
      Builtin.int_memcpy_RawPointer_RawPointer_Int64(
        (self + offset)._rawValue, rawSrc, UInt64(MemoryLayout<T>.size)._value,
         false._value)
    }
  }
  @inlinable
  public func copyMemory(from source: UnsafeRawPointer, byteCount: Int) {
    _debugPrecondition(
      byteCount >= 0, "UnsafeMutableRawPointer.copyMemory with negative count")
    _memmove(dest: self, src: source, size: UInt(byteCount))
  }
}
extension UnsafeMutableRawPointer: Strideable {
  public func advanced(by n: Int) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Builtin.gepRaw_Word(_rawValue, n._builtinWordValue))
  }
}
extension UnsafeMutableRawPointer {
  @inlinable
  public func alignedUp<T>(for type: T.Type) -> Self {
    let mask = UInt(Builtin.alignof(T.self)) &- 1
    let bits = (UInt(Builtin.ptrtoint_Word(_rawValue)) &+ mask) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedDown<T>(for type: T.Type) -> Self {
    let mask = UInt(Builtin.alignof(T.self)) &- 1
    let bits = UInt(Builtin.ptrtoint_Word(_rawValue)) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedUp(toMultipleOf alignment: Int) -> Self {
    let mask = UInt(alignment._builtinWordValue) &- 1
    _debugPrecondition(
      alignment > 0 && UInt(alignment._builtinWordValue) & mask == 0,
      "alignment must be a whole power of 2."
    )
    let bits = (UInt(Builtin.ptrtoint_Word(_rawValue)) &+ mask) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
  @inlinable
  public func alignedDown(toMultipleOf alignment: Int) -> Self {
    let mask = UInt(alignment._builtinWordValue) &- 1
    _debugPrecondition(
      alignment > 0 && UInt(alignment._builtinWordValue) & mask == 0,
      "alignment must be a whole power of 2."
    )
    let bits = UInt(Builtin.ptrtoint_Word(_rawValue)) & ~mask
    _debugPrecondition(bits != 0, "Overflow in pointer arithmetic")
    return .init(Builtin.inttoptr_Word(bits._builtinWordValue))
  }
}
extension OpaquePointer {
    self._rawValue = from._rawValue
  }
    guard let unwrapped = from else { return nil }
    self._rawValue = unwrapped._rawValue
  }
    self._rawValue = from._rawValue
  }
    guard let unwrapped = from else { return nil }
    self._rawValue = unwrapped._rawValue
  }
}
