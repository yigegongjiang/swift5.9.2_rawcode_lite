import SwiftShims
@usableFromInline
internal typealias _HeapObject = SwiftShims.HeapObject
@usableFromInline
internal func _swift_bufferAllocate(
  bufferType type: AnyClass,
  size: Int,
  alignmentMask: Int
) -> AnyObject
open class ManagedBuffer<Header, Element> {
  public final var header: Header
  @usableFromInline
  internal init(_doNotCallMe: ()) {
    _internalInvariantFailure("Only initialize these by calling create")
  }
}
extension ManagedBuffer {
  @inlinable
  public final class func create(
    minimumCapacity: Int,
    makingHeaderWith factory: (
      ManagedBuffer<Header, Element>) throws -> Header
  ) rethrows -> ManagedBuffer<Header, Element> {
    let p = Builtin.allocWithTailElems_1(
         self,
         minimumCapacity._builtinWordValue, Element.self)
    let initHeaderVal = try factory(p)
    p.headerAddress.initialize(to: initHeaderVal)
    _fixLifetime(p)
    return p
  }
  @inlinable
  @available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
  public final var capacity: Int {
    let storageAddr = UnsafeMutableRawPointer(Builtin.bridgeToRawPointer(self))
    let endAddr = storageAddr + _swift_stdlib_malloc_size(storageAddr)
    let realCapacity = endAddr.assumingMemoryBound(to: Element.self) -
      firstElementAddress
    return realCapacity
  }
  @inlinable
  internal final var firstElementAddress: UnsafeMutablePointer<Element> {
    return UnsafeMutablePointer(
      Builtin.projectTailElems(self, Element.self))
  }
  @inlinable
  internal final var headerAddress: UnsafeMutablePointer<Header> {
    return UnsafeMutablePointer<Header>(Builtin.addressof(&header))
  }
  @inlinable
  public final func withUnsafeMutablePointerToHeader<R>(
    _ body: (UnsafeMutablePointer<Header>) throws -> R
  ) rethrows -> R {
    return try withUnsafeMutablePointers { (v, _) in return try body(v) }
  }
  @inlinable
  public final func withUnsafeMutablePointerToElements<R>(
    _ body: (UnsafeMutablePointer<Element>) throws -> R
  ) rethrows -> R {
    return try withUnsafeMutablePointers { return try body($1) }
  }
  @inlinable
  public final func withUnsafeMutablePointers<R>(
    _ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws -> R
  ) rethrows -> R {
    defer { _fixLifetime(self) }
    return try body(headerAddress, firstElementAddress)
  }
}
@frozen
public struct ManagedBufferPointer<Header, Element> {
  @usableFromInline
  internal var _nativeBuffer: Builtin.NativeObject
  @inlinable
  @available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
  public init(
    bufferClass: AnyClass,
    minimumCapacity: Int,
    makingHeaderWith factory:
      (_ buffer: AnyObject, _ capacity: (AnyObject) -> Int) throws -> Header
  ) rethrows {
    self = ManagedBufferPointer(
      bufferClass: bufferClass, minimumCapacity: minimumCapacity)
    try withUnsafeMutablePointerToHeader {
      $0.initialize(to: 
        try factory(
          self.buffer,
          {
            ManagedBufferPointer(unsafeBufferObject: $0).capacity
          }))
    }
    _ = header
  }
  @inlinable
  public init(unsafeBufferObject buffer: AnyObject) {
    ManagedBufferPointer._checkValidBufferClass(type(of: buffer))
    self._nativeBuffer = Builtin.unsafeCastToNativeObject(buffer)
  }
  @inlinable
  internal init(_uncheckedUnsafeBufferObject buffer: AnyObject) {
    ManagedBufferPointer._internalInvariantValidBufferClass(type(of: buffer))
    self._nativeBuffer = Builtin.unsafeCastToNativeObject(buffer)
  }
  @inlinable
  internal init(
    bufferClass: AnyClass,
    minimumCapacity: Int
  ) {
    ManagedBufferPointer._checkValidBufferClass(bufferClass, creating: true)
    _precondition(
      minimumCapacity >= 0,
      "ManagedBufferPointer must have non-negative capacity")
    self.init(
      _uncheckedBufferClass: bufferClass, minimumCapacity: minimumCapacity)
  }
  @inlinable
  internal init(
    _uncheckedBufferClass: AnyClass,
    minimumCapacity: Int
  ) {
    ManagedBufferPointer._internalInvariantValidBufferClass(_uncheckedBufferClass, creating: true)
    _internalInvariant(
      minimumCapacity >= 0,
      "ManagedBufferPointer must have non-negative capacity")
    let totalSize = ManagedBufferPointer._elementOffset
      +  minimumCapacity * MemoryLayout<Element>.stride
    let newBuffer: AnyObject = _swift_bufferAllocate(
      bufferType: _uncheckedBufferClass,
      size: totalSize,
      alignmentMask: ManagedBufferPointer._alignmentMask)
    self._nativeBuffer = Builtin.unsafeCastToNativeObject(newBuffer)
  }
  @inlinable
  internal init(_ buffer: ManagedBuffer<Header, Element>) {
    _nativeBuffer = Builtin.unsafeCastToNativeObject(buffer)
  }
}
extension ManagedBufferPointer {
  @inlinable
  public var header: Header {
    _read {
      yield _headerPointer.pointee
    }
    _modify {
      yield &_headerPointer.pointee
    }
  }
  @inlinable
  public var buffer: AnyObject {
    return Builtin.castFromNativeObject(_nativeBuffer)
  }
  @inlinable
  @available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
  public var capacity: Int {
    return (
      _capacityInBytes &- ManagedBufferPointer._elementOffset
    ) / MemoryLayout<Element>.stride
  }
  @inlinable
  public func withUnsafeMutablePointerToHeader<R>(
    _ body: (UnsafeMutablePointer<Header>) throws -> R
  ) rethrows -> R {
    return try withUnsafeMutablePointers { (v, _) in return try body(v) }
  }
  @inlinable
  public func withUnsafeMutablePointerToElements<R>(
    _ body: (UnsafeMutablePointer<Element>) throws -> R
  ) rethrows -> R {
    return try withUnsafeMutablePointers { return try body($1) }
  }
  @inlinable
  public func withUnsafeMutablePointers<R>(
    _ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws -> R
  ) rethrows -> R {
    defer { _fixLifetime(_nativeBuffer) }
    return try body(_headerPointer, _elementPointer)
  }
  @inlinable
  public mutating func isUniqueReference() -> Bool {
    return _isUnique(&_nativeBuffer)
  }
}
extension ManagedBufferPointer {
  @inlinable
  internal static func _checkValidBufferClass(
    _ bufferClass: AnyClass, creating: Bool = false
  ) {
    _debugPrecondition(
      _class_getInstancePositiveExtentSize(bufferClass) == MemoryLayout<_HeapObject>.size
      || (
        (!creating || bufferClass is ManagedBuffer<Header, Element>.Type)
        && _class_getInstancePositiveExtentSize(bufferClass)
          == _headerOffset + MemoryLayout<Header>.size),
      "ManagedBufferPointer buffer class has illegal stored properties"
    )
    _debugPrecondition(
      _usesNativeSwiftReferenceCounting(bufferClass),
      "ManagedBufferPointer buffer class must be non-@objc"
    )
  }
  @inlinable
  internal static func _internalInvariantValidBufferClass(
    _ bufferClass: AnyClass, creating: Bool = false
  ) {
    _internalInvariant(
      _class_getInstancePositiveExtentSize(bufferClass) == MemoryLayout<_HeapObject>.size
      || (
        (!creating || bufferClass is ManagedBuffer<Header, Element>.Type)
        && _class_getInstancePositiveExtentSize(bufferClass)
          == _headerOffset + MemoryLayout<Header>.size),
      "ManagedBufferPointer buffer class has illegal stored properties"
    )
    _internalInvariant(
      _usesNativeSwiftReferenceCounting(bufferClass),
      "ManagedBufferPointer buffer class must be non-@objc"
    )
  }
}
extension ManagedBufferPointer {
  @inlinable
  internal static var _alignmentMask: Int {
    return max(
      MemoryLayout<_HeapObject>.alignment,
      max(MemoryLayout<Header>.alignment, MemoryLayout<Element>.alignment)) &- 1
  }
  @inlinable
  @available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
  internal var _capacityInBytes: Int {
    return _swift_stdlib_malloc_size(_address)
  }
  @inlinable
  internal var _address: UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(Builtin.bridgeToRawPointer(_nativeBuffer))
  }
  @inlinable
  internal static var _headerOffset: Int {
    _onFastPath()
    return _roundUp(
      MemoryLayout<_HeapObject>.size,
      toAlignment: MemoryLayout<Header>.alignment)
  }
  @inlinable
  internal var _headerPointer: UnsafeMutablePointer<Header> {
    _onFastPath()
    return (_address + ManagedBufferPointer._headerOffset).assumingMemoryBound(
      to: Header.self)
  }
  @inlinable
  internal var _elementPointer: UnsafeMutablePointer<Element> {
    _onFastPath()
    return (_address + ManagedBufferPointer._elementOffset).assumingMemoryBound(
      to: Element.self)
  }
  @inlinable
  internal static var _elementOffset: Int {
    _onFastPath()
    return _roundUp(
      _headerOffset + MemoryLayout<Header>.size,
      toAlignment: MemoryLayout<Element>.alignment)
  }
}
extension ManagedBufferPointer: Equatable {
  @inlinable
  public static func == (
    lhs: ManagedBufferPointer,
    rhs: ManagedBufferPointer
  ) -> Bool {
    return lhs._address == rhs._address
  }
}
@inlinable
public func isKnownUniquelyReferenced<T: AnyObject>(_ object: inout T) -> Bool
{
  return _isUnique(&object)
}
@inlinable
public func isKnownUniquelyReferenced<T: AnyObject>(
  _ object: inout T?
) -> Bool {
  return _isUnique(&object)
}
