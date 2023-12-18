@frozen 
public struct UnsafePointer<Pointee>: _Pointer {
  public typealias Distance = Int
  public let _rawValue: Builtin.RawPointer
  public init(_ _rawValue: Builtin.RawPointer) {
    self._rawValue = _rawValue
  }
  @inlinable
  public func deallocate() {
    Builtin.deallocRaw(_rawValue, (-1)._builtinWordValue, (0)._builtinWordValue)
  }
  @inlinable 
  public var pointee: Pointee {
      return self
    }
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (_ pointer: UnsafePointer<T>) throws -> Result
  ) rethrows -> Result {
    _debugPrecondition(
      Int(bitPattern: .init(_rawValue)) & (MemoryLayout<T>.alignment-1) == 0 &&
      ( count == 1 ||
        ( MemoryLayout<Pointee>.stride > MemoryLayout<T>.stride
          ? MemoryLayout<Pointee>.stride % MemoryLayout<T>.stride == 0
          : MemoryLayout<T>.stride % MemoryLayout<Pointee>.stride == 0
        )
      ),
      "self must be a properly aligned pointer for types Pointee and T"
    )
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  @available(*, unavailable)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (UnsafePointer<T>) throws -> Result
  ) rethrows -> Result {
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  @inlinable
  public subscript(i: Int) -> Pointee {
    unsafeAddress {
      return self + i
    }
  }
  @inlinable
  public func pointer<Property>(
    to property: KeyPath<Pointee, Property>
  ) -> UnsafePointer<Property>? {
    guard let o = property._storedInlineOffset else { return nil }
    _internalInvariant(o >= 0)
    _debugPrecondition(
      o == 0 || UnsafeRawPointer(self) < UnsafeRawPointer(bitPattern: 0 &- o)!,
      "Overflow in pointer arithmetic"
    )
    return .init(Builtin.gepRaw_Word(_rawValue, o._builtinWordValue))
  }
  @inlinable 
  internal static var _max: UnsafePointer {
    return UnsafePointer(
      bitPattern: 0 as Int &- MemoryLayout<Pointee>.stride
    )._unsafelyUnwrappedUnchecked
  }
}
@frozen 
public struct UnsafeMutablePointer<Pointee>: _Pointer {
  public typealias Distance = Int
  public let _rawValue: Builtin.RawPointer
  public init(_ _rawValue: Builtin.RawPointer) {
    self._rawValue = _rawValue
  }
    self._rawValue = other._rawValue
  }
    guard let unwrapped = other else { return nil }
    self.init(mutating: unwrapped)
  }
   self._rawValue = other._rawValue
  }
   guard let unwrapped = other else { return nil }
   self.init(unwrapped)
  }
  @inlinable
  public static func allocate(capacity count: Int)
    -> UnsafeMutablePointer<Pointee> {
    let size = MemoryLayout<Pointee>.stride * count
    var align = Builtin.alignof(Pointee.self)
    if Int(align) <= _minAllocationAlignment() {
      align = (0)._builtinWordValue
    }
    let rawPtr = Builtin.allocRaw(size._builtinWordValue, align)
    Builtin.bindMemory(rawPtr, count._builtinWordValue, Pointee.self)
    return UnsafeMutablePointer(rawPtr)
  }
  @inlinable
  public func deallocate() {
    Builtin.deallocRaw(_rawValue, (-1)._builtinWordValue, (0)._builtinWordValue)
  }
  @inlinable 
  public var pointee: Pointee {
      return UnsafePointer(self)
    }
      return self
    }
  }
  @inlinable
  public func initialize(repeating repeatedValue: Pointee, count: Int) {
    _debugPrecondition(count >= 0,
      "UnsafeMutablePointer.initialize(repeating:count:): negative count")
    for offset in 0..<count {
      Builtin.initialize(repeatedValue, (self + offset)._rawValue)
    }
  }
  @inlinable
  public func initialize(to value: Pointee) {
    Builtin.initialize(value, self._rawValue)
  }
  @inlinable
  public func move() -> Pointee {
    return Builtin.take(_rawValue)
  }
  @inlinable
  public func update(repeating repeatedValue: Pointee, count: Int) {
    _debugPrecondition(count >= 0, "UnsafeMutablePointer.update(repeating:count:) with negative count")
    for i in 0..<count {
      self[i] = repeatedValue
    }
  }
  @inlinable
  @available(*, deprecated, renamed: "update(repeating:count:)")
  public func assign(repeating repeatedValue: Pointee, count: Int) {
    update(repeating: repeatedValue, count: count)
  }
  @inlinable
  public func update(from source: UnsafePointer<Pointee>, count: Int) {
    _debugPrecondition(
      count >= 0, "UnsafeMutablePointer.update with negative count")
    if UnsafePointer(self) < source || UnsafePointer(self) >= source + count {
      Builtin.assignCopyArrayFrontToBack(
        Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
    else if UnsafePointer(self) != source {
      Builtin.assignCopyArrayBackToFront(
        Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
  }
  @inlinable
  @available(*, deprecated, renamed: "update(from:count:)")
  public func assign(from source: UnsafePointer<Pointee>, count: Int) {
    update(from: source, count: count)
  }
  @inlinable
  public func moveInitialize(
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeMutablePointer.moveInitialize with negative count")
    if self < source || self >= source + count {
      Builtin.takeArrayFrontToBack(
        Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
    else if self != source {
      Builtin.takeArrayBackToFront(
        Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
    }
  }
  @inlinable
  public func initialize(from source: UnsafePointer<Pointee>, count: Int) {
    _debugPrecondition(
      count >= 0, "UnsafeMutablePointer.initialize with negative count")
    _debugPrecondition(
      UnsafePointer(self) + count <= source ||
      source + count <= UnsafePointer(self),
      "UnsafeMutablePointer.initialize overlapping range")
    Builtin.copyArray(
      Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
  }
  @inlinable
  public func moveUpdate(
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeMutablePointer.moveUpdate(from:) with negative count")
    _debugPrecondition(
      self + count <= source || source + count <= self,
      "moveUpdate overlapping range")
    Builtin.assignTakeArray(
      Pointee.self, self._rawValue, source._rawValue, count._builtinWordValue)
  }
  @inlinable
  @available(*, deprecated, renamed: "moveUpdate(from:count:)")
  public func moveAssign(
  ) {
    moveUpdate(from: source, count: count)
  }
  @inlinable
  @discardableResult
  public func deinitialize(count: Int) -> UnsafeMutableRawPointer {
    _debugPrecondition(count >= 0, "UnsafeMutablePointer.deinitialize with negative count")
    Builtin.destroyArray(Pointee.self, _rawValue, count._builtinWordValue)
    return UnsafeMutableRawPointer(self)
  }
  @inlinable
  public func withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (_ pointer: UnsafeMutablePointer<T>) throws -> Result
  ) rethrows -> Result {
    _debugPrecondition(
      Int(bitPattern: .init(_rawValue)) & (MemoryLayout<T>.alignment-1) == 0 &&
      ( count == 1 ||
        ( MemoryLayout<Pointee>.stride > MemoryLayout<T>.stride
          ? MemoryLayout<Pointee>.stride % MemoryLayout<T>.stride == 0
          : MemoryLayout<T>.stride % MemoryLayout<Pointee>.stride == 0
        )
      ),
      "self must be a properly aligned pointer for types Pointee and T"
    )
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  @available(*, unavailable)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    capacity count: Int,
    _ body: (UnsafeMutablePointer<T>) throws -> Result
  ) rethrows -> Result {
    let binding = Builtin.bindMemory(_rawValue, count._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(_rawValue, binding) }
    return try body(.init(_rawValue))
  }
  @inlinable
  public subscript(i: Int) -> Pointee {
    unsafeAddress {
      return UnsafePointer(self + i)
    }
    nonmutating unsafeMutableAddress {
      return self + i
    }
  }
  @inlinable
  public func pointer<Property>(
    to property: KeyPath<Pointee, Property>
  ) -> UnsafePointer<Property>? {
    guard let o = property._storedInlineOffset else { return nil }
    _internalInvariant(o >= 0)
    _debugPrecondition(
      o == 0 || UnsafeRawPointer(self) < UnsafeRawPointer(bitPattern: 0 &- o)!,
      "Overflow in pointer arithmetic"
    )
    return .init(Builtin.gepRaw_Word(_rawValue, o._builtinWordValue))
  }
  @inlinable
  public func pointer<Property>(
    to property: WritableKeyPath<Pointee, Property>
  ) -> UnsafeMutablePointer<Property>? {
    guard let o = property._storedInlineOffset else { return nil }
    _internalInvariant(o >= 0)
    _debugPrecondition(
      o == 0 || UnsafeRawPointer(self) < UnsafeRawPointer(bitPattern: 0 &- o)!,
      "Overflow in pointer arithmetic"
    )
    return .init(Builtin.gepRaw_Word(_rawValue, o._builtinWordValue))
  }
  @inlinable 
  internal static var _max: UnsafeMutablePointer {
    return UnsafeMutablePointer(
      bitPattern: 0 as Int &- MemoryLayout<Pointee>.stride
    )._unsafelyUnwrappedUnchecked
  }
}
