// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1)
//===--- UnsafeRawBufferPointer.swift.gyb ---------------------*- swift -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 14)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 18)

/// A mutable nonowning collection interface to the bytes in a
/// region of memory.
///
/// You can use an `UnsafeMutableRawBufferPointer` instance in low-level operations to eliminate
/// uniqueness checks and release mode bounds checks. Bounds checks are always
/// performed in debug mode.
///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 27)
/// An `UnsafeMutableRawBufferPointer` instance is a view of the raw bytes in a region of memory.
/// Each byte in memory is viewed as a `UInt8` value independent of the type
/// of values held in that memory. Reading from and writing to memory through
/// a raw buffer are untyped operations. Accessing this collection's bytes
/// does not bind the underlying memory to `UInt8`.
///
/// In addition to its collection interface, an `UnsafeMutableRawBufferPointer`
/// instance also supports the following methods provided by
/// `UnsafeMutableRawPointer`, including bounds checks in debug mode:
///
/// - `load(fromByteOffset:as:)`
/// - `loadUnaligned(fromByteOffset:as:)`
/// - `storeBytes(of:toByteOffset:as:)`
/// - `copyMemory(from:)`
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 52)
///
/// To access the underlying memory through typed operations, the memory must
/// be bound to a trivial type.
///
/// - Note: A *trivial type* can be copied bit for bit with no indirection
///   or reference-counting operations. Generally, native Swift types that do
///   not contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enums. Copying memory that
///   contains values of nontrivial types can only be done safely with a typed
///   pointer. Copying bytes directly from nontrivial, in-memory values does
///   not produce valid copies and can only be done by calling a C API, such as
///   `memmove()`.
///
/// UnsafeMutableRawBufferPointer Semantics
/// =================
///
/// An `UnsafeMutableRawBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a variable or constant of type `UnsafeMutableRawBufferPointer` does
/// not copy the underlying memory. However, initializing another collection
/// with an `UnsafeMutableRawBufferPointer` instance copies bytes out of the referenced memory and
/// into the new collection.
///
/// The following example uses `someBytes`, an `UnsafeMutableRawBufferPointer` instance, to
/// demonstrate the difference between assigning a buffer pointer and using a
/// buffer pointer as the source for another collection's elements. Here, the
/// assignment to `destBytes` creates a new, nonowning buffer pointer
/// covering the first `n` bytes of the memory that `someBytes`
/// references---nothing is copied:
///
///     var destBytes = someBytes[0..<n]
///
/// Next, the bytes referenced by `destBytes` are copied into `byteArray`, a
/// new `[UInt8]` array, and then the remainder of `someBytes` is appended to
/// `byteArray`:
///
///     var byteArray: [UInt8] = Array(destBytes)
///     byteArray += someBytes[n..<someBytes.count]
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 90)
///
/// Assigning into a ranged subscript of an `UnsafeMutableRawBufferPointer` instance copies bytes
/// into the memory. The next `n` bytes of the memory that `someBytes`
/// references are copied in this code:
///
///     destBytes[0..<n] = someBytes[n..<(n + n)]
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 97)
@frozen
public struct UnsafeMutableRawBufferPointer {
  @usableFromInline
  internal let _position, _end: UnsafeMutableRawPointer?

  /// Creates a buffer over the specified number of contiguous bytes starting
  /// at the given pointer.
  ///
  /// - Parameters:
  ///   - start: The address of the memory that starts the buffer. If `starts`
  ///     is `nil`, `count` must be zero. However, `count` may be zero even
  ///     for a non-`nil` `start`.
  ///   - count: The number of bytes to include in the buffer. `count` must not
  ///     be negative.
  @inlinable
  public init(
    @_nonEphemeral start: UnsafeMutableRawPointer?, count: Int
  ) {
    _debugPrecondition(count >= 0, "UnsafeMutableRawBufferPointer with negative count")
    _debugPrecondition(count == 0 || start != nil,
      "UnsafeMutableRawBufferPointer has a nil start and nonzero count")
    _position = start
    _end = start.map { $0 + _assumeNonNegative(count) }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 170)
extension UnsafeMutableRawBufferPointer {
  public typealias Iterator = UnsafeRawBufferPointer.Iterator
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 174)

extension UnsafeMutableRawBufferPointer: Sequence {
  public typealias SubSequence = Slice<UnsafeMutableRawBufferPointer>

  /// Returns an iterator over the bytes of this sequence.
  @inlinable
  public func makeIterator() -> Iterator {
    return Iterator(_position: _position, _end: _end)
  }

  /// Copies the elements of `self` to the memory at `destination.baseAddress`,
  /// stopping when either `self` or `destination` is exhausted.
  ///
  /// - Returns: an iterator over any remaining elements of `self` and the
  ///   number of elements copied.
  @inlinable // unsafe-performance
  @_alwaysEmitIntoClient
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
  // TODO: Specialize `index` and `formIndex` and
  // `_failEarlyRangeCheck` as in `UnsafeBufferPointer`.
  public typealias Element = UInt8
  public typealias Index = Int
  public typealias Indices = Range<Int>

  /// Always zero, which is the index of the first byte in a nonempty buffer.
  @inlinable
  public var startIndex: Index {
    return 0
  }

  /// The "past the end" position---that is, the position one greater than the
  /// last valid subscript argument.
  ///
  /// The `endIndex` property of an `UnsafeMutableRawBufferPointer`
  /// instance is always identical to `count`.
  @inlinable
  public var endIndex: Index {
    return count
  }

  @inlinable
  public var indices: Indices {
    // Not checked because init forbids negative count.
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }

  /// Accesses the byte at the given offset in the memory region as a `UInt8`
  /// value.
  ///
  /// - Parameter i: The offset of the byte to access. `i` must be in the range
  ///   `0..<count`.
  @inlinable
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked.load(fromByteOffset: i, as: UInt8.self)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 247)
    nonmutating set {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      _position._unsafelyUnwrappedUnchecked.storeBytes(of: newValue, toByteOffset: i, as: UInt8.self)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 253)
  }

  /// Accesses the bytes in the specified memory region.
  ///
  /// - Parameter bounds: The range of byte offsets to access. The upper and
  ///   lower bounds of the range must be in the range `0...count`.
  @inlinable
  public subscript(bounds: Range<Int>) -> SubSequence {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(base: self, bounds: bounds)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 267)
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 279)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 282)
  /// Exchanges the byte values at the specified indices
  /// in this buffer's memory.
  ///
  /// Both parameters must be valid indices of the buffer, and not
  /// equal to `endIndex`. Passing the same index as both `i` and `j` has no
  /// effect.
  ///
  /// - Parameters:
  ///   - i: The index of the first byte to swap.
  ///   - j: The index of the second byte to swap.
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

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 305)
  /// The number of bytes in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable
  public var count: Int {
    if let pos = _position {
      // Unsafely unwrapped because init forbids end being nil if _position
      // isn't.
      _internalInvariant(_end != nil)
      return _assumeNonNegative(_end._unsafelyUnwrappedUnchecked - pos)
    }
    return 0
  }
}

extension UnsafeMutableRawBufferPointer: RandomAccessCollection { }

extension UnsafeMutableRawBufferPointer {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 325)
  /// Allocates uninitialized memory with the specified size and alignment.
  ///
  /// You are in charge of managing the allocated memory. Be sure to deallocate
  /// any memory that you manually allocate.
  ///
  /// The allocated memory is not bound to any specific type and must be bound
  /// before performing any typed operations. If you are using the memory for
  /// a specific type, allocate memory using the
  /// `UnsafeMutablePointerBuffer.allocate(capacity:)` static method instead.
  ///
  /// - Parameters:
  ///   - byteCount: The number of bytes to allocate. `byteCount` must not be
  ///     negative.
  ///   - alignment: The alignment of the new region of allocated memory, in
  ///     bytes. `alignment` must be a whole power of 2.
  /// - Returns: A buffer pointer to a newly allocated region of memory aligned 
  ///     to `alignment`.
  @inlinable
  public static func allocate(
    byteCount: Int, alignment: Int
  ) -> UnsafeMutableRawBufferPointer {
    let base = UnsafeMutableRawPointer.allocate(
      byteCount: byteCount, alignment: alignment)
    return UnsafeMutableRawBufferPointer(start: base, count: byteCount)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 351)

  /// Deallocates the memory block previously allocated at this buffer pointer’s 
  /// base address. 
  ///
  /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory 
  /// block previously returned by a Swift allocation method. If `baseAddress` is 
  /// `nil`, this function does nothing. Otherwise, the memory must not be initialized 
  /// or `Pointee` must be a trivial type. This buffer pointer's byte `count` must 
  /// be equal to the originally allocated size of the memory block.
  @inlinable
  public func deallocate() {
    _position?.deallocate()
  }

  /// Returns a new instance of the given type, read from the buffer pointer's
  /// raw memory at the specified byte offset.
  ///
  /// The memory at `offset` bytes from this buffer pointer's `baseAddress`
  /// must be properly aligned for accessing `T` and initialized to `T` or
  /// another type that is layout compatible with `T`.
  ///
  /// You can use this method to create new values from the buffer pointer's
  /// underlying bytes. The following example creates two new `Int32`
  /// instances from the memory referenced by the buffer pointer `someBytes`.
  /// The bytes for `a` are copied from the first four bytes of `someBytes`,
  /// and the bytes for `b` are copied from the next four bytes.
  ///
  ///     let a = someBytes.load(as: Int32.self)
  ///     let b = someBytes.load(fromByteOffset: 4, as: Int32.self)
  ///
  /// The memory to read for the new instance must not extend beyond the buffer
  /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
  /// be less than or equal to the buffer pointer's `count`.
  ///
  /// - Parameters:
  ///   - offset: The offset, in bytes, into the buffer pointer's memory at
  ///     which to begin reading data for the new instance. The buffer pointer
  ///     plus `offset` must be properly aligned for accessing an instance of
  ///     type `T`. The default is zero.
  ///   - type: The type to use for the newly constructed instance. The memory
  ///     must be initialized to a value of a type that is layout compatible
  ///     with `type`.
  /// - Returns: A new instance of type `T`, copied from the buffer pointer's
  ///   memory.
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.load out of bounds")
    return baseAddress!.load(fromByteOffset: offset, as: T.self)
  }

  /// Returns a new instance of the given type, constructed from the raw memory
  /// at the specified offset.
  ///
  /// This function only supports loading trivial types.
  /// A trivial type does not contain any reference-counted property
  /// within its in-memory stored representation.
  /// The memory at `offset` bytes into the buffer must be laid out
  /// identically to the in-memory representation of `T`.
  ///
  /// You can use this method to create new values from the buffer pointer's
  /// underlying bytes. The following example creates two new `Int32`
  /// instances from the memory referenced by the buffer pointer `someBytes`.
  /// The bytes for `a` are copied from the first four bytes of `someBytes`,
  /// and the bytes for `b` are copied from the fourth through seventh bytes.
  ///
  ///     let a = someBytes.loadUnaligned(as: Int32.self)
  ///     let b = someBytes.loadUnaligned(fromByteOffset: 3, as: Int32.self)
  ///
  /// The memory to read for the new instance must not extend beyond the buffer
  /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
  /// be less than or equal to the buffer pointer's `count`.
  ///
  /// - Parameters:
  ///   - offset: The offset, in bytes, into the buffer pointer's memory at
  ///     which to begin reading data for the new instance. The default is zero.
  ///   - type: The type to use for the newly constructed instance. The memory
  ///     must be initialized to a value of a type that is layout compatible
  ///     with `type`.
  /// - Returns: A new instance of type `T`, copied from the buffer pointer's
  ///   memory.
  @_alwaysEmitIntoClient
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.load out of bounds")
    return baseAddress!.loadUnaligned(fromByteOffset: offset, as: T.self)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 445)
  /// Stores a value's bytes into the buffer pointer's raw memory at the
  /// specified byte offset.
  ///
  /// The type `T` to be stored must be a trivial type. The memory must also be
  /// uninitialized, initialized to `T`, or initialized to another trivial
  /// type that is layout compatible with `T`.
  ///
  /// The memory written to must not extend beyond the buffer pointer's memory
  /// region---that is, `offset + MemoryLayout<T>.size` must be less than or
  /// equal to the buffer pointer's `count`.
  ///
  /// After calling `storeBytes(of:toByteOffset:as:)`, the memory is
  /// initialized to the raw bytes of `value`. If the memory is bound to a
  /// type `U` that is layout compatible with `T`, then it contains a value of
  /// type `U`. Calling `storeBytes(of:toByteOffset:as:)` does not change the
  /// bound type of the memory.
  ///
  /// - Note: A trivial type can be copied with just a bit-for-bit copy without
  ///   any indirection or reference-counting operations. Generally, native
  ///   Swift types that do not contain strong or weak references or other
  ///   forms of indirection are trivial, as are imported C structs and enums.
  ///
  /// If you need to store into memory a copy of a value of a type that isn't
  /// trivial, you cannot use the `storeBytes(of:toByteOffset:as:)` method.
  /// Instead, you must know either initialize the memory or,
  /// if you know the memory was already bound to `type`, assign to the memory.
  ///
  /// - Parameters:
  ///   - value: The value to store as raw bytes.
  ///   - offset: The offset in bytes into the buffer pointer's memory to begin
  ///     writing bytes from the value. The default is zero.
  ///   - type: The type to use for the newly constructed instance. The memory
  ///     must be initialized to a value of a type that is layout compatible
  ///     with `type`.
  @inlinable
  @_alwaysEmitIntoClient
  // This custom silgen name is chosen to not interfere with the old ABI
  @_silgen_name("_swift_se0349_UnsafeMutableRawBufferPointer_storeBytes")
  public func storeBytes<T>(
    of value: T, toByteOffset offset: Int = 0, as type: T.Type
  ) {
    _debugPrecondition(offset >= 0, "UnsafeMutableRawBufferPointer.storeBytes with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeMutableRawBufferPointer.storeBytes out of bounds")

    let pointer = baseAddress._unsafelyUnwrappedUnchecked
    pointer.storeBytes(of: value, toByteOffset: offset, as: T.self)
  }

  // This unavailable implementation uses the expected mangled name
  // of `storeBytes<T>(of:toByteOffset:as:)`, and provides an entry point for
  // any binary linked against the stdlib binary for Swift 5.6 and older.
  @available(*, unavailable)
  @_silgen_name("$sSw10storeBytes2of12toByteOffset2asyx_SixmtlF")
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

  /// Copies the bytes from the given buffer to this buffer's memory.
  ///
  /// If the `source.count` bytes of memory referenced by this buffer are bound
  /// to a type `T`, then `T` must be a trivial type, the underlying pointer
  /// must be properly aligned for accessing `T`, and `source.count` must be a
  /// multiple of `MemoryLayout<T>.stride`.
  ///
  /// The memory referenced by `source` may overlap with the memory referenced 
  /// by this buffer.
  ///
  /// After calling `copyMemory(from:)`, the first `source.count` bytes of
  /// memory referenced by this buffer are initialized to raw bytes. If the
  /// memory is bound to type `T`, then it contains values of type `T`.
  ///
  /// - Parameter source: A buffer of raw bytes. `source.count` must
  ///   be less than or equal to this buffer's `count`.
  @inlinable
  public func copyMemory(from source: UnsafeRawBufferPointer) {
    _debugPrecondition(source.count <= self.count,
      "UnsafeMutableRawBufferPointer.copyMemory source has too many elements")
    if let baseAddress = baseAddress, let sourceAddress = source.baseAddress {
      baseAddress.copyMemory(from: sourceAddress, byteCount: source.count)
    }
  }

  /// Copies from a collection of `UInt8` into this buffer's memory.
  ///
  /// If the first `source.count` bytes of memory referenced by this buffer
  /// are bound to a type `T`, then `T` must be a trivial type,
  /// the underlying pointer must be properly aligned for accessing `T`,
  /// and `source.count` must be a multiple of `MemoryLayout<T>.stride`.
  ///
  /// After calling `copyBytes(from:)`, the first `source.count` bytes of memory
  /// referenced by this buffer are initialized to raw bytes. If the memory is
  /// bound to type `T`, then it contains values of type `T`.
  ///
  /// - Parameter source: A collection of `UInt8` elements. `source.count` must
  ///   be less than or equal to this buffer's `count`.
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 576)

  /// Creates a new buffer over the same memory as the given buffer.
  ///
  /// - Parameter bytes: The buffer to convert.
  @inlinable
  public init(_ bytes: UnsafeMutableRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 586)
  /// Creates a new mutable buffer over the same memory as the given buffer.
  ///
  /// - Parameter bytes: The buffer to convert.
  @inlinable
  public init(mutating bytes: UnsafeRawBufferPointer) {
    self.init(start: UnsafeMutableRawPointer(mutating: bytes.baseAddress),
      count: bytes.count)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 603)

  /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
  ///
  /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
  ///   buffer's type `T` must be a trivial type.
  @inlinable
  public init<T>(_ buffer: UnsafeMutableBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 625)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 665)

  /// Creates a raw buffer over the same memory as the given raw buffer slice,
  /// with the indices rebased to zero.
  ///
  /// The new buffer represents the same region of memory as the slice, but its
  /// indices start at zero instead of at the beginning of the slice in the
  /// original buffer. The following code creates `slice`, a slice covering
  /// part of an existing buffer instance, then rebases it into a new `rebased`
  /// buffer.
  ///
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
  ///
  /// After this code has executed, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The raw buffer slice to rebase.
  @inlinable
  public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }

  /// A pointer to the first byte of the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable
  public var baseAddress: UnsafeMutableRawPointer? {
    return _position
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 703)
  
  /// Initializes the memory referenced by this buffer with the given value,
  /// binds the memory to the value's type, and returns a typed buffer of the
  /// initialized memory.
  ///
  /// The memory referenced by this buffer must be uninitialized or
  /// initialized to a trivial type, and must be properly aligned for
  /// accessing `T`.
  ///
  /// After calling this method on a raw buffer with non-nil `baseAddress` `b`, 
  /// the region starting at `b` and continuing up to
  /// `b + self.count - self.count % MemoryLayout<T>.stride` is bound
  /// to type `T` and is initialized. If `T` is a nontrivial type, you must
  /// eventually deinitialize or move the values in this region to avoid leaks.
  /// If `baseAddress` is `nil`, this function does nothing
  /// and returns an empty buffer pointer.
  ///
  /// - Parameters:
  ///   - type: The type to bind this buffer’s memory to.
  ///   - repeatedValue: The instance to copy into memory.
  /// - Returns: A typed buffer of the memory referenced by this raw buffer. 
  ///     The typed buffer contains `self.count / MemoryLayout<T>.stride` 
  ///     instances of `T`.
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

  /// Initializes the buffer's memory with the given elements, binding the
  /// initialized memory to the elements' type.
  ///
  /// When calling the `initializeMemory(as:from:)` method on a buffer `b`,
  /// the memory referenced by `b` must be uninitialized or initialized to a
  /// trivial type, and must be properly aligned for accessing `S.Element`.
  /// The buffer must contain sufficient memory to accommodate
  /// `source.underestimatedCount`.
  ///
  /// This method initializes the buffer with elements from `source` until
  /// `source` is exhausted or, if `source` is a sequence but not a collection,
  /// the buffer has no more room for source's elements. After calling
  /// `initializeMemory(as:from:)`, the memory referenced by the returned
  /// `UnsafeMutableBufferPointer` instance is bound and initialized to type
  /// `S.Element`. This method does not change
  /// the binding state of the unused portion of `b`, if any.
  ///
  /// - Parameters:
  ///   - type: The type of element to which this buffer's memory will be bound.
  ///   - source: A sequence of elements with which to initialize the buffer.
  /// - Returns: An iterator to any elements of `source` that didn't fit in the
  ///   buffer, and a typed buffer of the written elements. The returned
  ///   buffer references memory starting at the same base address as this
  ///   buffer.
  @inlinable
  public func initializeMemory<S: Sequence>(
    as type: S.Element.Type, from source: S
  ) -> (unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>) {
    var it = source.makeIterator()
    var idx = startIndex
    let elementStride = MemoryLayout<S.Element>.stride
    
    // This has to be a debug precondition due to the cost of walking over some collections.
    _debugPrecondition(source.underestimatedCount <= (count / elementStride),
      "insufficient space to accommodate source.underestimatedCount elements")
    guard let base = baseAddress else {
      // this can be a precondition since only an invalid argument should be costly
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
      // only advance to as far as the last element that will fit
      to: _end._unsafelyUnwrappedUnchecked - elementStride + 1, 
      by: elementStride
    ) {
      // underflow is permitted -- e.g. a sequence into
      // the spare capacity of an Array buffer
      guard let x = it.next() else { break }
      p.initializeMemory(as: S.Element.self, repeating: x, count: 1)
      formIndex(&idx, offsetBy: elementStride)
    }

    return (it, UnsafeMutableBufferPointer(
                  start: base.assumingMemoryBound(to: S.Element.self), 
                  count: idx / elementStride))
  }

  /// Initializes the buffer's memory with every element of the source,
  /// binding the initialized memory to the elements' type.
  ///
  /// When calling the `initializeMemory(as:fromContentsOf:)` method,
  /// the memory referenced by the buffer must be uninitialized, or initialized
  /// to a trivial type. The buffer must reference enough memory to store
  /// `source.count` elements, and its `baseAddress` must be properly aligned
  /// for accessing `C.Element`.
  ///
  /// This method initializes the buffer with the contents of `source`
  /// until `source` is exhausted.
  /// After calling `initializeMemory(as:fromContentsOf:)`, the memory
  /// referenced by the returned `UnsafeMutableBufferPointer` instance is bound
  /// to the type `C.Element` and is initialized. This method does not change
  /// the binding state of the unused portion of the buffer, if any.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     must not overlap.
  ///
  /// - Parameters:
  ///   - type: The type of element to which this buffer's memory will be bound.
  ///   - source: A collection of elements to be used to
  ///     initialize the buffer's storage.
  /// - Returns: A typed buffer referencing the initialized elements.
  ///     The returned buffer references memory starting at the same
  ///     base address as this buffer, and its count is equal to `source.count`
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Moves every element of an initialized source buffer into the
  /// uninitialized memory referenced by this buffer, leaving the source memory
  /// uninitialized and this buffer's memory initialized.
  ///
  /// When calling the `moveInitializeMemory(as:fromContentsOf:)` method,
  /// the memory referenced by the buffer must be uninitialized, or initialized
  /// to a trivial type. The buffer must reference enough memory to store
  /// `source.count` elements, and its `baseAddress` must be properly aligned
  /// for accessing `C.Element`. After the method returns,
  /// the memory referenced by the returned buffer is initialized and the
  /// memory region underlying `source` is uninitialized.
  ///
  /// This method initializes the buffer with the contents of `source`
  /// until `source` is exhausted.
  /// After calling `initializeMemory(as:fromContentsOf:)`, the memory
  /// referenced by the returned `UnsafeMutableBufferPointer` instance is bound
  /// to the type `T` and is initialized. This method does not change
  /// the binding state of the unused portion of the buffer, if any.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     may overlap.
  ///
  /// - Parameters:
  ///   - type: The type of element to which this buffer's memory will be bound.
  ///   - source: A buffer referencing the values to copy.
  ///     The memory region underlying `source` must be initialized.
  /// - Returns: A typed buffer referencing the initialized elements.
  ///     The returned buffer references memory starting at the same
  ///     base address as this buffer, and its count is equal to `source.count`.
  @discardableResult
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Moves every element of an initialized source buffer slice into the
  /// uninitialized memory referenced by this buffer, leaving the source memory
  /// uninitialized and this buffer's memory initialized.
  ///
  /// When calling the `moveInitializeMemory(as:fromContentsOf:)` method,
  /// the memory referenced by the buffer must be uninitialized, or initialized
  /// to a trivial type. The buffer must reference enough memory to store
  /// `source.count` elements, and its `baseAddress` must be properly aligned
  /// for accessing `C.Element`. After the method returns,
  /// the memory referenced by the returned buffer is initialized and the
  /// memory region underlying `source` is uninitialized.
  ///
  /// This method initializes the buffer with the contents of `source`
  /// until `source` is exhausted.
  /// After calling `initializeMemory(as:fromContentsOf:)`, the memory
  /// referenced by the returned `UnsafeMutableBufferPointer` instance is bound
  /// to the type `T` and is initialized. This method does not change
  /// the binding state of the unused portion of the buffer, if any.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     may overlap.
  ///
  /// - Parameters:
  ///   - type: The type of element to which this buffer's memory will be bound.
  ///   - source: A buffer referencing the values to copy.
  ///     The memory region underlying `source` must be initialized.
  /// - Returns: A typed buffer referencing the initialized elements.
  ///     The returned buffer references memory starting at the same
  ///     base address as this buffer, and its count is equal to `source.count`.
  @discardableResult
  @inlinable
  @_alwaysEmitIntoClient
  public func moveInitializeMemory<T>(
    as type: T.Type,
    fromContentsOf source: Slice<UnsafeMutableBufferPointer<T>>
  ) -> UnsafeMutableBufferPointer<T> {
    let rebased = UnsafeMutableBufferPointer(rebasing: source)
    return moveInitializeMemory(as: T.self, fromContentsOf: rebased)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 985)

  /// Binds this buffer’s memory to the specified type and returns a typed buffer 
  /// of the bound memory.
  ///
  /// Use the `bindMemory(to:)` method to bind the memory referenced
  /// by this buffer to the type `T`. The memory must be uninitialized or
  /// initialized to a type that is layout compatible with `T`. If the memory
  /// is uninitialized, it is still uninitialized after being bound to `T`.
  ///
  /// - Warning: A memory location may only be bound to one type at a time. The
  ///   behavior of accessing memory as a type unrelated to its bound type is
  ///   undefined.
  ///
  /// - Parameters:
  ///   - type: The type `T` to bind the memory to.
  /// - Returns: A typed buffer of the newly bound memory. The memory in this
  ///   region is bound to `T`, but has not been modified in any other way.
  ///   The typed buffer references `self.count / MemoryLayout<T>.stride`
  ///   instances of `T`.
  @_transparent
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

  /// Executes the given closure while temporarily binding the buffer to
  /// instances of type `T`.
  ///
  /// Use this method when you have a buffer to raw memory and you need
  /// to access that memory as instances of a given type `T`. Accessing
  /// memory as a type `T` requires that the memory be bound to that type.
  /// A memory location may only be bound to one type at a time, so accessing
  /// the same memory as an unrelated type without first rebinding the memory
  /// is undefined.
  ///
  /// Any instance of `T` within the re-bound region may be initialized or
  /// uninitialized. The memory underlying any individual instance of `T`
  /// must have the same initialization state (i.e.  initialized or
  /// uninitialized.) Accessing a `T` whose underlying memory
  /// is in a mixed initialization state shall be undefined behaviour.
  ///
  /// If the byte count of the original buffer is not a multiple of
  /// the stride of `T`, then the re-bound buffer is shorter
  /// than the original buffer.
  ///
  /// After executing `body`, this method rebinds memory back to its original
  /// binding state. This can be unbound memory, or bound to a different type.
  ///
  /// - Note: The buffer's base address must match the
  ///   alignment of `T` (as reported by `MemoryLayout<T>.alignment`).
  ///   That is, `Int(bitPattern: self.baseAddress) % MemoryLayout<T>.alignment`
  ///   must equal zero.
  ///
  /// - Note: A raw buffer may represent memory that has been bound to a type.
  ///   If that is the case, then `T` must be layout compatible with the
  ///   type to which the memory has been bound. This requirement does not
  ///   apply if the raw buffer represents memory that has not been bound
  ///   to any type.
  ///
  /// - Parameters:
  ///   - type: The type to temporarily bind the memory referenced by this
  ///     buffer.
  ///   - body: A closure that takes a typed pointer to the
  ///     same memory as this pointer, only bound to type `T`. The closure's
  ///     pointer argument is valid only for the duration of the closure's
  ///     execution. If `body` has a return value, that value is also used as
  ///     the return value for the `withMemoryRebound(to:capacity:_:)` method.
  ///   - buffer: The buffer temporarily bound to instances of `T`.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  @inlinable
  @_alwaysEmitIntoClient
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
    // initializer ensures _end is nil only when _position is nil.
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    let binding = Builtin.bindMemory(s._rawValue, n._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(s._rawValue, binding) }
    return try body(.init(start: .init(s._rawValue), count: n))
  }

  /// Returns a typed buffer to the memory referenced by this buffer,
  /// assuming that the memory is already bound to the specified type.
  ///
  /// Use this method when you have a raw buffer to memory that has already
  /// been bound to the specified type. The memory starting at this pointer
  /// must be bound to the type `T`. Accessing memory through the returned
  /// pointer is undefined if the memory has not been bound to `T`. To bind
  /// memory to `T`, use `bindMemory(to:capacity:)` instead of this method.
  ///
  /// - Note: The buffer's base address must match the
  ///   alignment of `T` (as reported by `MemoryLayout<T>.alignment`).
  ///   That is, `Int(bitPattern: self.baseAddress) % MemoryLayout<T>.alignment`
  ///   must equal zero.
  ///
  /// - Parameter to: The type `T` that the memory has already been bound to.
  /// - Returns: A typed pointer to the same memory as this raw pointer.
  @inlinable
  @_alwaysEmitIntoClient
  public func assumingMemoryBound<T>(
    to: T.Type
  ) -> UnsafeMutableBufferPointer<T> {
    guard let s = _position else {
      return .init(start: nil, count: 0)
    }
    // initializer ensures _end is nil only when _position is nil.
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    return .init(start: .init(s._rawValue), count: n)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1117)
  @inlinable
  @_alwaysEmitIntoClient
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

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1135)
  @inlinable
  @_alwaysEmitIntoClient
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    try withMemoryRebound(to: Element.self) {
      try body(UnsafeBufferPointer<Element>($0))
    }
  }
}

extension UnsafeMutableRawBufferPointer: CustomDebugStringConvertible {
  /// A textual representation of the buffer, suitable for debugging.
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1160)
    nonmutating set {}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1162)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1165)
  @available(*, unavailable, 
    message: "use 'UnsafeRawBufferPointer(rebasing:)' to convert a slice into a zero-based raw buffer.")
  public subscript(bounds: Range<Int>) -> UnsafeRawBufferPointer {
    get { return UnsafeRawBufferPointer(start: nil, count: 0) }
    nonmutating set {}
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1172)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 18)

/// A  nonowning collection interface to the bytes in a
/// region of memory.
///
/// You can use an `UnsafeRawBufferPointer` instance in low-level operations to eliminate
/// uniqueness checks and release mode bounds checks. Bounds checks are always
/// performed in debug mode.
///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 42)
/// An `UnsafeRawBufferPointer` instance is a view of the raw bytes in a region of memory.
/// Each byte in memory is viewed as a `UInt8` value independent of the type
/// of values held in that memory. Reading from memory through a raw buffer is
/// an untyped operation.
///
/// In addition to its collection interface, an `UnsafeRawBufferPointer`
/// instance also supports the `load(fromByteOffset:as:)`
/// and `loadUnaligned(fromByteOffset:as:)` methods provided by
/// `UnsafeRawPointer`, including bounds checks in debug mode.
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 52)
///
/// To access the underlying memory through typed operations, the memory must
/// be bound to a trivial type.
///
/// - Note: A *trivial type* can be copied bit for bit with no indirection
///   or reference-counting operations. Generally, native Swift types that do
///   not contain strong or weak references or other forms of indirection are
///   trivial, as are imported C structs and enums. Copying memory that
///   contains values of nontrivial types can only be done safely with a typed
///   pointer. Copying bytes directly from nontrivial, in-memory values does
///   not produce valid copies and can only be done by calling a C API, such as
///   `memmove()`.
///
/// UnsafeRawBufferPointer Semantics
/// =================
///
/// An `UnsafeRawBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a variable or constant of type `UnsafeRawBufferPointer` does
/// not copy the underlying memory. However, initializing another collection
/// with an `UnsafeRawBufferPointer` instance copies bytes out of the referenced memory and
/// into the new collection.
///
/// The following example uses `someBytes`, an `UnsafeRawBufferPointer` instance, to
/// demonstrate the difference between assigning a buffer pointer and using a
/// buffer pointer as the source for another collection's elements. Here, the
/// assignment to `destBytes` creates a new, nonowning buffer pointer
/// covering the first `n` bytes of the memory that `someBytes`
/// references---nothing is copied:
///
///     var destBytes = someBytes[0..<n]
///
/// Next, the bytes referenced by `destBytes` are copied into `byteArray`, a
/// new `[UInt8]` array, and then the remainder of `someBytes` is appended to
/// `byteArray`:
///
///     var byteArray: [UInt8] = Array(destBytes)
///     byteArray += someBytes[n..<someBytes.count]
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 97)
@frozen
public struct UnsafeRawBufferPointer {
  @usableFromInline
  internal let _position, _end: UnsafeRawPointer?

  /// Creates a buffer over the specified number of contiguous bytes starting
  /// at the given pointer.
  ///
  /// - Parameters:
  ///   - start: The address of the memory that starts the buffer. If `starts`
  ///     is `nil`, `count` must be zero. However, `count` may be zero even
  ///     for a non-`nil` `start`.
  ///   - count: The number of bytes to include in the buffer. `count` must not
  ///     be negative.
  @inlinable
  public init(
    @_nonEphemeral start: UnsafeRawPointer?, count: Int
  ) {
    _debugPrecondition(count >= 0, "UnsafeRawBufferPointer with negative count")
    _debugPrecondition(count == 0 || start != nil,
      "UnsafeRawBufferPointer has a nil start and nonzero count")
    _position = start
    _end = start.map { $0 + _assumeNonNegative(count) }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 124)
extension UnsafeRawBufferPointer {
  /// An iterator over the bytes viewed by a raw buffer pointer.
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
  /// Advances to the next byte and returns it, or `nil` if no next byte
  /// exists.
  ///
  /// Once `nil` has been returned, all subsequent calls return `nil`.
  ///
  /// - Returns: The next sequential byte in the raw buffer if another byte
  ///   exists; otherwise, `nil`.
  @inlinable
  public mutating func next() -> UInt8? {
    if _position == _end { return nil }

    // We can do an unchecked unwrap here by borrowing invariants from the pointer.
    // For a validly constructed buffer pointer, the only way _position can be nil is
    // if _end is also nil. We checked that case above. Thus, we can safely do an
    // unchecked unwrap here.
    //
    // Additionally, validly constructed buffer pointers also have an _end that is
    // strictly greater than or equal to _position, and so we do not need to do checked
    // arithmetic here as we cannot possibly overflow.
    //
    // We check these invariants in debug builds to defend against invalidly constructed
    // pointers.
    _debugPrecondition(_position! < _end!)
    let position = _position._unsafelyUnwrappedUnchecked
    let result = position.load(as: UInt8.self)
    _position = position + 1
    return result
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 174)

extension UnsafeRawBufferPointer: Sequence {
  public typealias SubSequence = Slice<UnsafeRawBufferPointer>

  /// Returns an iterator over the bytes of this sequence.
  @inlinable
  public func makeIterator() -> Iterator {
    return Iterator(_position: _position, _end: _end)
  }

  /// Copies the elements of `self` to the memory at `destination.baseAddress`,
  /// stopping when either `self` or `destination` is exhausted.
  ///
  /// - Returns: an iterator over any remaining elements of `self` and the
  ///   number of elements copied.
  @inlinable // unsafe-performance
  @_alwaysEmitIntoClient
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
  // TODO: Specialize `index` and `formIndex` and
  // `_failEarlyRangeCheck` as in `UnsafeBufferPointer`.
  public typealias Element = UInt8
  public typealias Index = Int
  public typealias Indices = Range<Int>

  /// Always zero, which is the index of the first byte in a nonempty buffer.
  @inlinable
  public var startIndex: Index {
    return 0
  }

  /// The "past the end" position---that is, the position one greater than the
  /// last valid subscript argument.
  ///
  /// The `endIndex` property of an `UnsafeRawBufferPointer`
  /// instance is always identical to `count`.
  @inlinable
  public var endIndex: Index {
    return count
  }

  @inlinable
  public var indices: Indices {
    // Not checked because init forbids negative count.
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }

  /// Accesses the byte at the given offset in the memory region as a `UInt8`
  /// value.
  ///
  /// - Parameter i: The offset of the byte to access. `i` must be in the range
  ///   `0..<count`.
  @inlinable
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked.load(fromByteOffset: i, as: UInt8.self)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 253)
  }

  /// Accesses the bytes in the specified memory region.
  ///
  /// - Parameter bounds: The range of byte offsets to access. The upper and
  ///   lower bounds of the range must be in the range `0...count`.
  @inlinable
  public subscript(bounds: Range<Int>) -> SubSequence {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(base: self, bounds: bounds)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 279)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 305)
  /// The number of bytes in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable
  public var count: Int {
    if let pos = _position {
      // Unsafely unwrapped because init forbids end being nil if _position
      // isn't.
      _internalInvariant(_end != nil)
      return _assumeNonNegative(_end._unsafelyUnwrappedUnchecked - pos)
    }
    return 0
  }
}

extension UnsafeRawBufferPointer: RandomAccessCollection { }

extension UnsafeRawBufferPointer {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 351)

  /// Deallocates the memory block previously allocated at this buffer pointer’s 
  /// base address. 
  ///
  /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory 
  /// block previously returned by a Swift allocation method. If `baseAddress` is 
  /// `nil`, this function does nothing. Otherwise, the memory must not be initialized 
  /// or `Pointee` must be a trivial type. This buffer pointer's byte `count` must 
  /// be equal to the originally allocated size of the memory block.
  @inlinable
  public func deallocate() {
    _position?.deallocate()
  }

  /// Returns a new instance of the given type, read from the buffer pointer's
  /// raw memory at the specified byte offset.
  ///
  /// The memory at `offset` bytes from this buffer pointer's `baseAddress`
  /// must be properly aligned for accessing `T` and initialized to `T` or
  /// another type that is layout compatible with `T`.
  ///
  /// You can use this method to create new values from the buffer pointer's
  /// underlying bytes. The following example creates two new `Int32`
  /// instances from the memory referenced by the buffer pointer `someBytes`.
  /// The bytes for `a` are copied from the first four bytes of `someBytes`,
  /// and the bytes for `b` are copied from the next four bytes.
  ///
  ///     let a = someBytes.load(as: Int32.self)
  ///     let b = someBytes.load(fromByteOffset: 4, as: Int32.self)
  ///
  /// The memory to read for the new instance must not extend beyond the buffer
  /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
  /// be less than or equal to the buffer pointer's `count`.
  ///
  /// - Parameters:
  ///   - offset: The offset, in bytes, into the buffer pointer's memory at
  ///     which to begin reading data for the new instance. The buffer pointer
  ///     plus `offset` must be properly aligned for accessing an instance of
  ///     type `T`. The default is zero.
  ///   - type: The type to use for the newly constructed instance. The memory
  ///     must be initialized to a value of a type that is layout compatible
  ///     with `type`.
  /// - Returns: A new instance of type `T`, copied from the buffer pointer's
  ///   memory.
  @inlinable
  public func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T {
    _debugPrecondition(offset >= 0, "UnsafeRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeRawBufferPointer.load out of bounds")
    return baseAddress!.load(fromByteOffset: offset, as: T.self)
  }

  /// Returns a new instance of the given type, constructed from the raw memory
  /// at the specified offset.
  ///
  /// This function only supports loading trivial types.
  /// A trivial type does not contain any reference-counted property
  /// within its in-memory stored representation.
  /// The memory at `offset` bytes into the buffer must be laid out
  /// identically to the in-memory representation of `T`.
  ///
  /// You can use this method to create new values from the buffer pointer's
  /// underlying bytes. The following example creates two new `Int32`
  /// instances from the memory referenced by the buffer pointer `someBytes`.
  /// The bytes for `a` are copied from the first four bytes of `someBytes`,
  /// and the bytes for `b` are copied from the fourth through seventh bytes.
  ///
  ///     let a = someBytes.loadUnaligned(as: Int32.self)
  ///     let b = someBytes.loadUnaligned(fromByteOffset: 3, as: Int32.self)
  ///
  /// The memory to read for the new instance must not extend beyond the buffer
  /// pointer's memory region---that is, `offset + MemoryLayout<T>.size` must
  /// be less than or equal to the buffer pointer's `count`.
  ///
  /// - Parameters:
  ///   - offset: The offset, in bytes, into the buffer pointer's memory at
  ///     which to begin reading data for the new instance. The default is zero.
  ///   - type: The type to use for the newly constructed instance. The memory
  ///     must be initialized to a value of a type that is layout compatible
  ///     with `type`.
  /// - Returns: A new instance of type `T`, copied from the buffer pointer's
  ///   memory.
  @_alwaysEmitIntoClient
  public func loadUnaligned<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type
  ) -> T {
    _debugPrecondition(offset >= 0, "UnsafeRawBufferPointer.load with negative offset")
    _debugPrecondition(offset + MemoryLayout<T>.size <= self.count,
      "UnsafeRawBufferPointer.load out of bounds")
    return baseAddress!.loadUnaligned(fromByteOffset: offset, as: T.self)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 576)

  /// Creates a new buffer over the same memory as the given buffer.
  ///
  /// - Parameter bytes: The buffer to convert.
  @inlinable
  public init(_ bytes: UnsafeMutableRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 595)
  /// Creates a new buffer over the same memory as the given buffer.
  ///
  /// - Parameter bytes: The buffer to convert.
  @inlinable
  public init(_ bytes: UnsafeRawBufferPointer) {
    self.init(start: bytes.baseAddress, count: bytes.count)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 603)

  /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
  ///
  /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
  ///   buffer's type `T` must be a trivial type.
  @inlinable
  public init<T>(_ buffer: UnsafeMutableBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 615)
  /// Creates a raw buffer over the contiguous bytes in the given typed buffer.
  ///
  /// - Parameter buffer: The typed buffer to convert to a raw buffer. The
  ///   buffer's type `T` must be a trivial type.
  @inlinable
  public init<T>(_ buffer: UnsafeBufferPointer<T>) {
    self.init(start: buffer.baseAddress,
      count: buffer.count * MemoryLayout<T>.stride)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 625)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 627)
  /// Creates a raw buffer over the same memory as the given raw buffer slice,
  /// with the indices rebased to zero.
  ///
  /// The new buffer represents the same region of memory as the slice, but its
  /// indices start at zero instead of at the beginning of the slice in the
  /// original buffer. The following code creates `slice`, a slice covering
  /// part of an existing buffer instance, then rebases it into a new `rebased`
  /// buffer.
  ///
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
  ///
  /// After this code has executed, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The raw buffer slice to rebase.
  @inlinable
  public init(rebasing slice: Slice<UnsafeRawBufferPointer>) {
    // NOTE: `Slice` does not guarantee that its start/end indices are valid
    // in `base` -- it merely ensures that `startIndex <= endIndex`.
    // We need manually check that we aren't given an invalid slice,
    // or the resulting collection would allow access that was
    // out-of-bounds with respect to the original base buffer.
    // We only do this in debug builds to prevent a measurable performance
    // degradation wrt passing around pointers not wrapped in a BufferPointer
    // construct.
    _debugPrecondition(
      slice.startIndex >= 0 && slice.endIndex <= slice.base.count,
      "Invalid slice")
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 665)

  /// Creates a raw buffer over the same memory as the given raw buffer slice,
  /// with the indices rebased to zero.
  ///
  /// The new buffer represents the same region of memory as the slice, but its
  /// indices start at zero instead of at the beginning of the slice in the
  /// original buffer. The following code creates `slice`, a slice covering
  /// part of an existing buffer instance, then rebases it into a new `rebased`
  /// buffer.
  ///
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeRawBufferPointer(rebasing: slice)
  ///
  /// After this code has executed, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The raw buffer slice to rebase.
  @inlinable
  public init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }

  /// A pointer to the first byte of the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable
  public var baseAddress: UnsafeRawPointer? {
    return _position
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 985)

  /// Binds this buffer’s memory to the specified type and returns a typed buffer 
  /// of the bound memory.
  ///
  /// Use the `bindMemory(to:)` method to bind the memory referenced
  /// by this buffer to the type `T`. The memory must be uninitialized or
  /// initialized to a type that is layout compatible with `T`. If the memory
  /// is uninitialized, it is still uninitialized after being bound to `T`.
  ///
  /// - Warning: A memory location may only be bound to one type at a time. The
  ///   behavior of accessing memory as a type unrelated to its bound type is
  ///   undefined.
  ///
  /// - Parameters:
  ///   - type: The type `T` to bind the memory to.
  /// - Returns: A typed buffer of the newly bound memory. The memory in this
  ///   region is bound to `T`, but has not been modified in any other way.
  ///   The typed buffer references `self.count / MemoryLayout<T>.stride`
  ///   instances of `T`.
  @_transparent
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

  /// Executes the given closure while temporarily binding the buffer to
  /// instances of type `T`.
  ///
  /// Use this method when you have a buffer to raw memory and you need
  /// to access that memory as instances of a given type `T`. Accessing
  /// memory as a type `T` requires that the memory be bound to that type.
  /// A memory location may only be bound to one type at a time, so accessing
  /// the same memory as an unrelated type without first rebinding the memory
  /// is undefined.
  ///
  /// Any instance of `T` within the re-bound region may be initialized or
  /// uninitialized. The memory underlying any individual instance of `T`
  /// must have the same initialization state (i.e.  initialized or
  /// uninitialized.) Accessing a `T` whose underlying memory
  /// is in a mixed initialization state shall be undefined behaviour.
  ///
  /// If the byte count of the original buffer is not a multiple of
  /// the stride of `T`, then the re-bound buffer is shorter
  /// than the original buffer.
  ///
  /// After executing `body`, this method rebinds memory back to its original
  /// binding state. This can be unbound memory, or bound to a different type.
  ///
  /// - Note: The buffer's base address must match the
  ///   alignment of `T` (as reported by `MemoryLayout<T>.alignment`).
  ///   That is, `Int(bitPattern: self.baseAddress) % MemoryLayout<T>.alignment`
  ///   must equal zero.
  ///
  /// - Note: A raw buffer may represent memory that has been bound to a type.
  ///   If that is the case, then `T` must be layout compatible with the
  ///   type to which the memory has been bound. This requirement does not
  ///   apply if the raw buffer represents memory that has not been bound
  ///   to any type.
  ///
  /// - Parameters:
  ///   - type: The type to temporarily bind the memory referenced by this
  ///     buffer.
  ///   - body: A closure that takes a typed pointer to the
  ///     same memory as this pointer, only bound to type `T`. The closure's
  ///     pointer argument is valid only for the duration of the closure's
  ///     execution. If `body` has a return value, that value is also used as
  ///     the return value for the `withMemoryRebound(to:capacity:_:)` method.
  ///   - buffer: The buffer temporarily bound to instances of `T`.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  @inlinable
  @_alwaysEmitIntoClient
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
    // initializer ensures _end is nil only when _position is nil.
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    let binding = Builtin.bindMemory(s._rawValue, n._builtinWordValue, T.self)
    defer { Builtin.rebindMemory(s._rawValue, binding) }
    return try body(.init(start: .init(s._rawValue), count: n))
  }

  /// Returns a typed buffer to the memory referenced by this buffer,
  /// assuming that the memory is already bound to the specified type.
  ///
  /// Use this method when you have a raw buffer to memory that has already
  /// been bound to the specified type. The memory starting at this pointer
  /// must be bound to the type `T`. Accessing memory through the returned
  /// pointer is undefined if the memory has not been bound to `T`. To bind
  /// memory to `T`, use `bindMemory(to:capacity:)` instead of this method.
  ///
  /// - Note: The buffer's base address must match the
  ///   alignment of `T` (as reported by `MemoryLayout<T>.alignment`).
  ///   That is, `Int(bitPattern: self.baseAddress) % MemoryLayout<T>.alignment`
  ///   must equal zero.
  ///
  /// - Parameter to: The type `T` that the memory has already been bound to.
  /// - Returns: A typed pointer to the same memory as this raw pointer.
  @inlinable
  @_alwaysEmitIntoClient
  public func assumingMemoryBound<T>(
    to: T.Type
  ) -> UnsafeBufferPointer<T> {
    guard let s = _position else {
      return .init(start: nil, count: 0)
    }
    // initializer ensures _end is nil only when _position is nil.
    _internalInvariant(_end != nil)
    let c = _assumeNonNegative(s.distance(to: _end._unsafelyUnwrappedUnchecked))
    let n = c / MemoryLayout<T>.stride
    return .init(start: .init(s._rawValue), count: n)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1135)
  @inlinable
  @_alwaysEmitIntoClient
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    try withMemoryRebound(to: Element.self) {
      try body($0)
    }
  }
}

extension UnsafeRawBufferPointer: CustomDebugStringConvertible {
  /// A textual representation of the buffer, suitable for debugging.
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1162)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1172)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeRawBufferPointer.swift.gyb", line: 1175)

/// Invokes the given closure with a mutable buffer pointer covering the raw
/// bytes of the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a mutable raw buffer
///     pointer.
///     Note that the `inout` exclusivity rules mean that, like any other
///     `inout` argument, `value` cannot be directly accessed by other code
///     for the duration of `body`. Access must only occur through the pointer
///     argument to `body` until `body` returns.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeMutableBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution.
/// - Returns: The return value, if any, of the `body` closure.
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

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a raw buffer pointer.
///     Note that the `inout` exclusivity rules mean that, like any other
///     `inout` argument, `value` cannot be directly accessed by other code
///     for the duration of `body`. Access must only occur through the pointer
///     argument to `body` until `body` returns.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution. It is undefined behavior to attempt to
///     mutate through the pointer by conversion to
///     `UnsafeMutableRawBufferPointer` or any other mutable pointer type.
///     If you want to mutate a value by writing through a pointer, use
///     `withUnsafeMutableBytes(of:_:)` instead.
/// - Returns: The return value, if any, of the `body` closure.
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

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// This function is similar to `withUnsafeBytes`, except that it
/// doesn't trigger stack protection for the pointer.
@_alwaysEmitIntoClient
public func _withUnprotectedUnsafeBytes<T, Result>(
  of value: inout T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result
{
  return try _withUnprotectedUnsafePointer(to: &value) {
    try body(UnsafeRawBufferPointer(start: $0, count: MemoryLayout<T>.size))
  }
}

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// The buffer pointer argument to the `body` closure provides a collection
/// interface to the raw bytes of `value`. The buffer is the size of the
/// instance passed as `value` and does not include any remote storage.
///
/// - Parameters:
///   - value: An instance to temporarily access through a raw buffer pointer.
///   - body: A closure that takes a raw buffer pointer to the bytes of `value`
///     as its sole argument. If the closure has a return value, that value is
///     also used as the return value of the `withUnsafeBytes(of:_:)`
///     function. The buffer pointer argument is valid only for the duration
///     of the closure's execution. It is undefined behavior to attempt to
///     mutate through the pointer by conversion to
///     `UnsafeMutableRawBufferPointer` or any other mutable pointer type.
///     If you want to mutate a value by writing through a pointer, use
///     `withUnsafeMutableBytes(of:_:)` instead.
/// - Returns: The return value, if any, of the `body` closure.
@inlinable
public func withUnsafeBytes<T, Result>(
  of value: T,
  _ body: (UnsafeRawBufferPointer) throws -> Result
) rethrows -> Result {
  let addr = UnsafeRawPointer(Builtin.addressOfBorrow(value))
  let buffer = UnsafeRawBufferPointer(start: addr, count: MemoryLayout<T>.size)
  return try body(buffer)
}

/// Invokes the given closure with a buffer pointer covering the raw bytes of
/// the given argument.
///
/// This function is similar to `withUnsafeBytes`, except that it
/// doesn't trigger stack protection for the pointer.
@_alwaysEmitIntoClient
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

// Local Variables:
// eval: (read-only-mode 1)
// End:
