// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1)
//===--- UnsafeBufferPointer.swift.gyb ------------------------*- swift -*-===//
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


// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 17)
/// A nonowning collection interface to a buffer of mutable
/// elements stored contiguously in memory.
///
/// You can use an `UnsafeMutableBufferPointer` instance in low level operations to eliminate
/// uniqueness checks and, in release mode, bounds checks. Bounds checks are
/// always performed in debug mode.
///
/// UnsafeMutableBufferPointer Semantics
/// =================
///
/// An `UnsafeMutableBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a value of type `UnsafeMutableBufferPointer` does not copy the
/// instances stored in the underlying memory. However, initializing another
/// collection with an `UnsafeMutableBufferPointer` instance copies the instances out of the
/// referenced memory and into the new collection.
@frozen // unsafe-performance
public struct UnsafeMutableBufferPointer<Element> {

  @usableFromInline
  let _position: UnsafeMutablePointer<Element>?

  /// The number of elements in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  public let count: Int

    // This works around _debugPrecondition() impacting the performance of
  // optimized code. (rdar://72246338)
  @_alwaysEmitIntoClient
  internal init(
    @_nonEphemeral _uncheckedStart start: UnsafeMutablePointer<Element>?,
    count: Int
  ) {
    _position = start
    self.count = count
  }

  /// Creates a new buffer pointer over the specified number of contiguous
  /// instances beginning at the given pointer.
  ///
  /// - Parameters:
  ///   - start: A pointer to the start of the buffer, or `nil`. If `start` is
  ///     `nil`, `count` must be zero. However, `count` may be zero even for a
  ///     non-`nil` `start`. The pointer passed as `start` must be aligned to
  ///     `MemoryLayout<Element>.alignment`.
  ///   - count: The number of instances in the buffer. `count` must not be
  ///     negative.
  @inlinable // unsafe-performance
  public init(
    @_nonEphemeral start: UnsafeMutablePointer<Element>?, count: Int
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeMutableBufferPointer with negative count")
    _debugPrecondition(
      count == 0 || start != nil,
      "UnsafeMutableBufferPointer has a nil start and nonzero count")
    self.init(_uncheckedStart: start, count: _assumeNonNegative(count))
  }

  @inlinable // unsafe-performance
  public init(_empty: ()) {
    _position = nil
    count = 0
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 84)

  /// Creates a mutable typed buffer pointer referencing the same memory as the 
  /// given immutable buffer pointer.
  ///
  /// - Parameter other: The immutable buffer pointer to convert.
  @inlinable // unsafe-performance
  public init(mutating other: UnsafeBufferPointer<Element>) {
    _position = UnsafeMutablePointer<Element>(mutating: other._position)
    count = other.count
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 105)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 144)
extension UnsafeMutableBufferPointer {
  public typealias Iterator = UnsafeBufferPointer<Element>.Iterator
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 148)

extension UnsafeMutableBufferPointer: Sequence {
  /// Returns an iterator over the elements of this buffer.
  ///
  /// - Returns: An iterator over the elements of this buffer.
  @inlinable // unsafe-performance
  public func makeIterator() -> Iterator {
    guard let start = _position else {
      return Iterator(_position: nil, _end: nil)
    }
    return Iterator(_position: start, _end: start + count)
  }

  /// Initializes the memory at `destination.baseAddress` with elements of `self`,
  /// stopping when either `self` or `destination` is exhausted.
  ///
  /// - Returns: an iterator over any remaining elements of `self` and the
  ///   number of elements initialized.
  @inlinable // unsafe-performance
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

  /// The index of the first element in a nonempty buffer.
  ///
  /// The `startIndex` property of an `UnsafeMutableBufferPointer` instance
  /// is always zero.
  @inlinable // unsafe-performance
  public var startIndex: Int { return 0 }

  /// The "past the end" position---that is, the position one greater than the
  /// last valid subscript argument.
  ///
  /// The `endIndex` property of an `UnsafeMutableBufferPointer` instance is
  /// always identical to `count`.
  @inlinable // unsafe-performance
  public var endIndex: Int { return count }

  @inlinable // unsafe-performance
  public func index(after i: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // NOTE: Wrapping math because we allow unsafe buffer pointers not to verify
    // index preconditions in release builds. Our (optimistic) assumption is
    // that the caller is already ensuring that indices are valid, so we can
    // elide the usual checks to help the optimizer generate better code.
    // However, we still check for overflow in debug mode.
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func formIndex(after i: inout Int) {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(before i: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func formIndex(before i: inout Int) {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(_ i: Int, offsetBy n: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
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

  @inlinable // unsafe-performance
  public func distance(from start: Int, to end: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // NOTE: We allow the subtraction to silently overflow in release builds
    // to eliminate a superfluous check when `start` and `end` are both valid
    // indices. (The operation can only overflow if `start` is negative, which
    // implies it's an invalid index.) `Collection` does not specify what
    // `distance` should return when given an invalid index pair.
    let result = end.subtractingReportingOverflow(start)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func _failEarlyRangeCheck(_ index: Int, bounds: Range<Int>) {
    // NOTE: In release mode, this method is a no-op for performance reasons.
    _debugPrecondition(index >= bounds.lowerBound)
    _debugPrecondition(index < bounds.upperBound)
  }

  @inlinable // unsafe-performance
  public func _failEarlyRangeCheck(_ range: Range<Int>, bounds: Range<Int>) {
    // NOTE: In release mode, this method is a no-op for performance reasons.
    _debugPrecondition(range.lowerBound >= bounds.lowerBound)
    _debugPrecondition(range.upperBound <= bounds.upperBound)
  }

  @inlinable // unsafe-performance
  public var indices: Indices {
    // Not checked because init forbids negative count.
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }

  /// Accesses the element at the specified position.
  ///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 328)
  /// The following example uses the buffer pointer's subscript to access and
  /// modify the elements of a mutable buffer pointing to the contiguous
  /// contents of an array:
  ///
  ///     var numbers = [1, 2, 3, 4, 5]
  ///     numbers.withUnsafeMutableBufferPointer { buffer in
  ///         for i in stride(from: buffer.startIndex, to: buffer.endIndex - 1, by: 2) {
  ///             let x = buffer[i]
  ///             buffer[i + 1] = buffer[i]
  ///             buffer[i] = x
  ///         }
  ///     }
  ///     print(numbers)
  ///     // Prints "[2, 1, 4, 3, 5]"
  ///
  ///     Uninitialized memory cannot be initialized to a nontrivial type
  ///     using this subscript. Instead, use an initializing method, such as
  ///     `initializeElement(at:to:)`
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 360)
  ///
  /// - Note: Bounds checks for `i` are performed only in debug mode.
  ///
  /// - Parameter i: The position of the element to access. `i` must be in the
  ///   range `0..<count`.
  @inlinable // unsafe-performance
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 373)
    nonmutating _modify {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      yield &_position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 379)
  }

  // Skip all debug and runtime checks

  @inlinable // unsafe-performance
  internal subscript(_unchecked i: Int) -> Element {
    get {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 391)
    nonmutating _modify {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      yield &_position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 397)
  }

  /// Accesses a contiguous subrange of the buffer's elements.
  ///
  /// The accessed slice uses the same indices for the same elements as the
  /// original buffer uses. Always use the slice's `startIndex` property
  /// instead of assuming that its indices start at a particular value.
  ///
  /// This example demonstrates getting a slice from a buffer of strings, finding
  /// the index of one of the strings in the slice, and then using that index
  /// in the original buffer.
  ///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 410)
  ///     var streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
  ///     streets.withUnsafeMutableBufferPointer { buffer in
  ///         let streetSlice = buffer[2..<buffer.endIndex]
  ///         print(Array(streetSlice))
  ///         // Prints "["Channing", "Douglas", "Evarts"]"
  ///         let index = streetSlice.firstIndex(of: "Evarts")    // 4
  ///         buffer[index!] = "Eustace"
  ///     }
  ///     print(streets.last!)
  ///     // Prints "Eustace"
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 431)
  ///
  /// - Note: Bounds checks for `bounds` are performed only in debug mode.
  ///
  /// - Parameter bounds: A range of the buffer's indices. The bounds of
  ///   the range must be valid indices of the buffer.
  @inlinable // unsafe-performance
  public subscript(bounds: Range<Int>)
    -> Slice<UnsafeMutableBufferPointer<Element>>
  {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(
        base: self, bounds: bounds)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 447)
    nonmutating set {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      _debugPrecondition(bounds.count == newValue.count)

      // FIXME: swift-3-indexing-model: tests.
      if !newValue.isEmpty {
        (_position! + bounds.lowerBound).update(
          from: newValue.base._position! + newValue.startIndex,
          count: newValue.count)
      }
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 460)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 462)

  /// Exchanges the values at the specified indices of the buffer.
  ///
  /// Both parameters must be valid indices of the buffer, and not
  /// equal to `endIndex`. Passing the same index as both `i` and `j` has no
  /// effect.
  ///
  /// - Parameters:
  ///   - i: The index of the first value to swap.
  ///   - j: The index of the second value to swap.
  @inlinable // unsafe-performance
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 484)
}

extension UnsafeMutableBufferPointer {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 488)
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

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 525)
  
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 566)

  /// Creates a buffer over the same memory as the given buffer slice.
  ///
  /// The new buffer represents the same region of memory as `slice`, but is
  /// indexed starting at zero instead of sharing indices with the original
  /// buffer. For example:
  ///
  ///     let buffer = returnsABuffer()
  ///     let n = 5
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeMutableBufferPointer(rebasing: slice)
  ///
  /// After rebasing `slice` as the `rebased` buffer, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The buffer slice to rebase.
  @inlinable // unsafe-performance
  public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }

  /// Deallocates the memory block previously allocated at this buffer pointer’s 
  /// base address. 
  ///
  /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory 
  /// block previously returned by a Swift allocation method. If `baseAddress` is 
  /// `nil`, this function does nothing. Otherwise, the memory must not be initialized 
  /// or `Pointee` must be a trivial type. This buffer pointer's `count` must 
  /// be equal to the originally allocated size of the memory block.
  @inlinable // unsafe-performance
  public func deallocate() {
    _position?.deallocate()
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 607)

  /// Allocates uninitialized memory for the specified number of instances of
  /// type `Element`.
  ///
  /// The resulting buffer references a region of memory that is bound to
  /// `Element` and is `count * MemoryLayout<Element>.stride` bytes in size.
  /// 
  /// The following example allocates a buffer that can store four `Int` 
  /// instances and then initializes that memory with the elements of a range:
  /// 
  ///     let buffer = UnsafeMutableBufferPointer<Int>.allocate(capacity: 4)
  ///     _ = buffer.initialize(from: 1...4)
  ///     print(buffer[2])
  ///     // Prints "3"
  ///
  /// When you allocate memory, always remember to deallocate once you're
  /// finished.
  ///
  ///     buffer.deallocate()
  ///
  /// - Parameter count: The amount of memory to allocate, counted in instances
  ///   of `Element`. 
  @inlinable // unsafe-performance
  public static func allocate(capacity count: Int) 
    -> UnsafeMutableBufferPointer<Element> {
    let base  = UnsafeMutablePointer<Element>.allocate(capacity: count)
    return UnsafeMutableBufferPointer(start: base, count: count)
  }
  
  /// Initializes every element in this buffer's memory to
  /// a copy of the given value.
  ///
  /// The destination memory must be uninitialized or the buffer's `Element`
  /// must be a trivial type. After a call to `initialize(repeating:)`, the
  /// entire region of memory referenced by this buffer is initialized.
  ///
  /// - Parameters:
  ///   - repeatedValue: The instance to initialize this buffer's memory with.
  @inlinable // unsafe-performance
  public func initialize(repeating repeatedValue: Element) {
    guard let dstBase = _position else {
      return
    }

    dstBase.initialize(repeating: repeatedValue, count: count)
  }

  /// Initializes the buffer's memory with the given elements.
  ///
  /// Prior to calling the `initialize(from:)` method on a buffer,
  /// the memory it references must be uninitialized,
  /// or its `Element` type must be a trivial type. After the call,
  /// the memory referenced by the buffer up to, but not including,
  /// the returned index is initialized.
  /// The buffer must contain sufficient memory to accommodate
  /// `source.underestimatedCount`.
  ///
  /// The returned index is the position of the next uninitialized element
  /// in the buffer, which is one past the last element written.
  /// If `source` contains no elements, the returned index is equal to
  /// the buffer's `startIndex`. If `source` contains an equal or greater number
  /// of elements than the buffer can hold, the returned index is equal to
  /// the buffer's `endIndex`.
  ///
  /// - Parameter source: A sequence of elements with which to initialize the
  ///   buffer.
  /// - Returns: An iterator to any elements of `source` that didn't fit in the
  ///   buffer, and an index to the next uninitialized element in the buffer.
  @inlinable // unsafe-performance
  @_silgen_name("$sSr10initialize4from8IteratorQyd___Sitqd___t7ElementQyd__RszSTRd__lF")
  public func initialize<S: Sequence>(
    from source: S
  ) -> (unwritten: S.Iterator, index: Index) where S.Element == Element {
    return source._copyContents(initializing: self)
  }

  /// Initializes the buffer's memory with
  /// every element of the source.
  ///
  /// Prior to calling the `initialize(fromContentsOf:)` method on a buffer,
  /// the memory referenced by the buffer must be uninitialized,
  /// or the `Element` type must be a trivial type. After the call,
  /// the memory referenced by the buffer up to, but not including,
  /// the returned index is initialized.
  /// The buffer must reference enough memory to accommodate
  /// `source.count` elements.
  ///
  /// The returned index is the position of the next uninitialized element
  /// in the buffer, one past the index of the last element written.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     must not overlap.
  ///
  /// - Parameter source: A collection of elements to be used to
  ///     initialize the buffer's storage.
  /// - Returns: The index one past the last element of the buffer initialized
  ///     by this function.
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Updates every element of this buffer's initialized memory.
  ///
  /// The buffer’s memory must be initialized or its `Element` type
  /// must be a trivial type.
  ///
  /// - Note: All buffer elements must already be initialized.
  ///
  /// - Parameters:
  ///   - repeatedValue: The value used when updating this pointer's memory.
  @inlinable // unsafe-performance
  @_silgen_name("$sSr6assign9repeatingyx_tF")
  public func update(repeating repeatedValue: Element) {
    guard let dstBase = _position else {
      return
    }

    dstBase.update(repeating: repeatedValue, count: count)
  }

  @inlinable
  @_alwaysEmitIntoClient
  @available(*, deprecated, renamed: "update(repeating:)")
  @_silgen_name("_swift_se0370_UnsafeMutableBufferPointer_assign_repeating")
  public func assign(repeating repeatedValue: Element) {
    update(repeating: repeatedValue)
  }

  /// Updates the buffer's initialized memory with the given elements.
  ///
  /// The buffer’s memory must be initialized or its `Element` type
  /// must be a trivial type.
  ///
  /// - Parameter source: A sequence of elements to be used to update
  ///   the buffer's contents.
  /// - Returns: An iterator to any elements of `source` that didn't fit in the
  ///   buffer, and the index one past the last updated element in the buffer.
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Updates the buffer's initialized memory with
  /// every element of the source.
  ///
  /// Prior to calling the `update(fromContentsOf:)` method on a buffer,
  /// the first `source.count` elements of the buffer's memory must be
  /// initialized, or the buffer's `Element` type must be a trivial type.
  /// The buffer must reference enough initialized memory to accommodate
  /// `source.count` elements.
  ///
  /// The returned index is one past the index of the last element updated.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     may overlap.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Parameter source: A collection of elements to be used to update
  ///   the buffer's contents.
  /// - Returns: An index one past the index of the last element updated.
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Moves every element of an initialized source buffer into the
  /// uninitialized memory referenced by this buffer, leaving the source memory
  /// uninitialized and this buffer's memory initialized.
  ///
  /// Prior to calling the `moveInitialize(fromContentsOf:)` method on a buffer,
  /// the memory it references must be uninitialized,
  /// or its `Element` type must be a trivial type. After the call,
  /// the memory referenced by the buffer up to, but not including,
  /// the returned index is initialized. The memory referenced by
  /// `source` is uninitialized after the function returns.
  /// The buffer must reference enough memory to accommodate
  /// `source.count` elements.
  ///
  /// The returned index is the position of the next uninitialized element
  /// in the buffer, one past the index of the last element written.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     may overlap.
  ///
  /// - Parameter source: A buffer containing the values to copy. The memory
  ///     region underlying `source` must be initialized.
  /// - Returns: The index one past the last element of the buffer initialized
  ///     by this function.
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Moves every element of an initialized source buffer into the
  /// uninitialized memory referenced by this buffer, leaving the source memory
  /// uninitialized and this buffer's memory initialized.
  ///
  /// Prior to calling the `moveInitialize(fromContentsOf:)` method on a buffer,
  /// the memory it references must be uninitialized,
  /// or its `Element` type must be a trivial type. After the call,
  /// the memory referenced by the buffer up to, but not including,
  /// the returned index is initialized. The memory referenced by
  /// `source` is uninitialized after the function returns.
  /// The buffer must reference enough memory to accommodate
  /// `source.count` elements.
  ///
  /// The returned index is the position of the next uninitialized element
  /// in the buffer, one past the index of the last element written.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     may overlap.
  ///
  /// - Parameter source: A buffer containing the values to copy. The memory
  ///     region underlying `source` must be initialized.
  /// - Returns: The index one past the last element of the buffer initialized
  ///     by this function.
  @inlinable
  @_alwaysEmitIntoClient
  public func moveInitialize(fromContentsOf source: Slice<Self>) -> Index {
    return moveInitialize(fromContentsOf: Self(rebasing: source))
  }

  /// Updates this buffer's initialized memory initialized memory by
  /// moving every element from the source buffer,
  /// leaving the source memory uninitialized.
  ///
  /// Prior to calling the `moveUpdate(fromContentsOf:)` method on a buffer,
  /// the first `source.count` elements of the buffer's memory must be
  /// initialized, or the buffer's `Element` type must be a trivial type.
  /// The memory referenced by `source` is uninitialized after the function
  /// returns. The buffer must reference enough initialized memory
  /// to accommodate `source.count` elements.
  ///
  /// The returned index is one past the index of the last element updated.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     must not overlap.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Parameter source: A buffer containing the values to move.
  ///     The memory region underlying `source` must be initialized.
  /// - Returns: An index one past the index of the last element updated.
  @inlinable
  @_alwaysEmitIntoClient
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

  /// Updates this buffer's initialized memory initialized memory by
  /// moving every element from the source buffer slice,
  /// leaving the source memory uninitialized.
  ///
  /// Prior to calling the `moveUpdate(fromContentsOf:)` method on a buffer,
  /// the first `source.count` elements of the buffer's memory must be
  /// initialized, or the buffer's `Element` type must be a trivial type.
  /// The memory referenced by `source` is uninitialized after the function
  /// returns. The buffer must reference enough initialized memory
  /// to accommodate `source.count` elements.
  ///
  /// The returned index is one past the index of the last element updated.
  /// If `source` contains no elements, the returned index is equal to the
  /// buffer's `startIndex`. If `source` contains as many elements as the buffer
  /// can hold, the returned index is equal to the buffer's `endIndex`.
  ///
  /// - Note: The memory regions referenced by `source` and this buffer
  ///     must not overlap.
  ///
  /// - Precondition: `self.count` >= `source.count`
  ///
  /// - Parameter source: A buffer slice containing the values to move.
  ///     The memory region underlying `source` must be initialized.
  /// - Returns: An index one past the index of the last element updated.
  @inlinable
  @_alwaysEmitIntoClient
  public func moveUpdate(fromContentsOf source: Slice<Self>) -> Index {
    return moveUpdate(fromContentsOf: Self(rebasing: source))
  }

  /// Deinitializes every instance in this buffer.
  ///
  /// The region of memory underlying this buffer must be fully initialized.
  /// After calling `deinitialize(count:)`, the memory is uninitialized,
  /// but still bound to the `Element` type.
  ///
  /// - Note: All buffer elements must already be initialized.
  ///
  /// - Returns: A raw buffer to the same range of memory as this buffer.
  ///   The range of memory is still bound to `Element`.
  @discardableResult
  @inlinable
  @_alwaysEmitIntoClient
  public func deinitialize() -> UnsafeMutableRawBufferPointer {
    guard let rawValue = baseAddress?._rawValue
      else { return .init(start: nil, count: 0) }
    Builtin.destroyArray(Element.self, rawValue, count._builtinWordValue)
    return .init(start: UnsafeMutableRawPointer(rawValue),
                 count: count*MemoryLayout<Element>.stride)
   }

  /// Initializes the element at `index` to the given value.
  ///
  /// The memory underlying the destination element must be uninitialized,
  /// or `Element` must be a trivial type. After a call to `initialize(to:)`,
  /// the memory underlying this element of the buffer is initialized.
  ///
  /// - Parameters:
  ///   - value: The value used to initialize the buffer element's memory.
  ///   - index: The index of the element to initialize
  @inlinable
  @_alwaysEmitIntoClient
  public func initializeElement(at index: Index, to value: Element) {
    _debugPrecondition(startIndex <= index && index < endIndex)
    let p = baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index)
    p.initialize(to: value)
  }

  /// Retrieves and returns the element at `index`,
  /// leaving that element's underlying memory uninitialized.
  ///
  /// The memory underlying the element at `index` must be initialized.
  /// After calling `moveElement(from:)`, the memory underlying this element
  /// of the buffer is uninitialized, and still bound to type `Element`.
  ///
  /// - Parameters:
  ///   - index: The index of the buffer element to retrieve and deinitialize.
  /// - Returns: The instance referenced by this index in this buffer.
  @inlinable
  @_alwaysEmitIntoClient
  public func moveElement(from index: Index) -> Element {
    _debugPrecondition(startIndex <= index && index < endIndex)
    return baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index).move()
  }

  /// Deinitializes the memory underlying the element at `index`.
  ///
  /// The memory underlying the element at `index` must be initialized.
  /// After calling `deinitializeElement()`, the memory underlying this element
  /// of the buffer is uninitialized, and still bound to type `Element`.
  ///
  /// - Parameters:
  ///   - index: The index of the buffer element to deinitialize.
  @inlinable
  @_alwaysEmitIntoClient
  public func deinitializeElement(at index: Index) {
    _debugPrecondition(startIndex <= index && index < endIndex)
    let p = baseAddress._unsafelyUnwrappedUnchecked.advanced(by: index)
    p.deinitialize(count: 1)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1071)

  /// Executes the given closure while temporarily binding the memory referenced 
  /// by this buffer to the given type.
  ///
  /// Use this method when you have a buffer of memory bound to one type and
  /// you need to access that memory as a buffer of another type. Accessing
  /// memory as type `T` requires that the memory be bound to that type. A
  /// memory location may only be bound to one type at a time, so accessing
  /// the same memory as an unrelated type without first rebinding the memory
  /// is undefined.
  ///
  /// The number of instances of `T` referenced by the rebound buffer may be
  /// different than the number of instances of `Element` referenced by the
  /// original buffer. The number of instances of `T` will be calculated
  /// at runtime.
  /// 
  /// Any instance of `T` within the re-bound region may be initialized or
  /// uninitialized. Every instance of `Pointee` overlapping with a given
  /// instance of `T` should have the same initialization state (i.e.
  /// initialized or uninitialized.) Accessing a `T` whose underlying
  /// `Pointee` storage is in a mixed initialization state shall be
  /// undefined behaviour.
  ///
  /// Because this buffer's memory is no longer bound to its `Element` type
  /// while the `body` closure executes, do not access memory using the
  /// original buffer from within `body`. Instead, use the `body` closure's
  /// buffer argument to access the values in memory as instances of type
  /// `T`.
  ///
  /// After executing `body`, this method rebinds memory back to the original
  /// `Element` type.
  ///
  /// - Note: Only use this method to rebind the buffer's memory to a type
  ///   that is layout compatible with the currently bound `Element` type.
  ///   The stride of the temporary type (`T`) may be an integer multiple
  ///   or a whole fraction of `Element`'s stride.
  ///   To bind a region of memory to a type that does not match these
  ///   requirements, convert the buffer to a raw buffer and use the
  ///   raw buffer's `withMemoryRebound(to:)` method.
  ///   If `T` and `Element` have different alignments, this buffer's
  ///   `baseAddress` must be aligned with the larger of the two alignments.
  ///
  /// - Parameters:
  ///   - type: The type to temporarily bind the memory referenced by this
  ///     buffer. The type `T` must be layout compatible
  ///     with the pointer's `Element` type.
  ///   - body: A closure that takes a mutable typed buffer to the
  ///     same memory as this buffer, only bound to type `T`. The buffer
  ///     parameter contains a number of complete instances of `T` based
  ///     on the capacity of the original buffer and the stride of `Element`.
  ///     The closure's buffer argument is valid only for the duration of the
  ///     closure's execution. If `body` has a return value, that value
  ///     is also used as the return value for the `withMemoryRebound(to:_:)`
  ///     method.
  ///   - buffer: The buffer temporarily bound to `T`.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  @inlinable // unsafe-performance
  @_alwaysEmitIntoClient
  // This custom silgen name is chosen to not interfere with the old ABI
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1131)
  @_silgen_name("_swift_se0333_UnsafeMutableBufferPointer_withMemoryRebound")
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1135)
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

  // This unavailable implementation uses the expected mangled name
  // of `withMemoryRebound<T, Result>(to:_:)`, and provides
  // an entry point for any binary linked against the stdlib binary
  // for Swift 5.6 and older.
  @available(*, unavailable)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1171)
  @_silgen_name("$sSr17withMemoryRebound2to_qd_0_qd__m_qd_0_Sryqd__GKXEtKr0_lF")
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1175)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (UnsafeMutableBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    return try withMemoryRebound(to: T.self, body)
  }

  /// A pointer to the first element of the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable // unsafe-performance
  public var baseAddress: UnsafeMutablePointer<Element>? {
    return _position
  }
}

extension UnsafeMutableBufferPointer: CustomDebugStringConvertible {
  /// A textual representation of the buffer, suitable for debugging.
  public var debugDescription: String {
    return "UnsafeMutableBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 17)
/// A nonowning collection interface to a buffer of 
/// elements stored contiguously in memory.
///
/// You can use an `UnsafeBufferPointer` instance in low level operations to eliminate
/// uniqueness checks and, in release mode, bounds checks. Bounds checks are
/// always performed in debug mode.
///
/// UnsafeBufferPointer Semantics
/// =================
///
/// An `UnsafeBufferPointer` instance is a view into memory and does not own the memory
/// that it references. Copying a value of type `UnsafeBufferPointer` does not copy the
/// instances stored in the underlying memory. However, initializing another
/// collection with an `UnsafeBufferPointer` instance copies the instances out of the
/// referenced memory and into the new collection.
@frozen // unsafe-performance
public struct UnsafeBufferPointer<Element> {

  @usableFromInline
  let _position: UnsafePointer<Element>?

  /// The number of elements in the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  public let count: Int

    // This works around _debugPrecondition() impacting the performance of
  // optimized code. (rdar://72246338)
  @_alwaysEmitIntoClient
  internal init(
    @_nonEphemeral _uncheckedStart start: UnsafePointer<Element>?,
    count: Int
  ) {
    _position = start
    self.count = count
  }

  /// Creates a new buffer pointer over the specified number of contiguous
  /// instances beginning at the given pointer.
  ///
  /// - Parameters:
  ///   - start: A pointer to the start of the buffer, or `nil`. If `start` is
  ///     `nil`, `count` must be zero. However, `count` may be zero even for a
  ///     non-`nil` `start`. The pointer passed as `start` must be aligned to
  ///     `MemoryLayout<Element>.alignment`.
  ///   - count: The number of instances in the buffer. `count` must not be
  ///     negative.
  @inlinable // unsafe-performance
  public init(
    @_nonEphemeral start: UnsafePointer<Element>?, count: Int
  ) {
    _debugPrecondition(
      count >= 0, "UnsafeBufferPointer with negative count")
    _debugPrecondition(
      count == 0 || start != nil,
      "UnsafeBufferPointer has a nil start and nonzero count")
    self.init(_uncheckedStart: start, count: _assumeNonNegative(count))
  }

  @inlinable // unsafe-performance
  public init(_empty: ()) {
    _position = nil
    count = 0
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 95)
  /// Creates an immutable typed buffer pointer referencing the same memory as the 
  /// given mutable buffer pointer.
  ///
  /// - Parameter other: The mutable buffer pointer to convert.
  @inlinable // unsafe-performance
  public init(_ other: UnsafeMutableBufferPointer<Element>) {
    _position = UnsafePointer<Element>(other._position)
    count = other.count
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 105)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 108)
extension UnsafeBufferPointer {
  /// An iterator for the elements in the buffer referenced by an
  /// `UnsafeBufferPointer` or `UnsafeMutableBufferPointer` instance.
  @frozen // unsafe-performance
  public struct Iterator {
    @usableFromInline
    internal var _position, _end: UnsafePointer<Element>?

    @inlinable // unsafe-performance
    public init(_position: UnsafePointer<Element>?, _end: UnsafePointer<Element>?) {
        self._position = _position
        self._end = _end
    }
  }
}

extension UnsafeBufferPointer.Iterator: IteratorProtocol {
  /// Advances to the next element and returns it, or `nil` if no next element
  /// exists.
  ///
  /// Once `nil` has been returned, all subsequent calls return `nil`.
  @inlinable // unsafe-performance
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
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 148)

extension UnsafeBufferPointer: Sequence {
  /// Returns an iterator over the elements of this buffer.
  ///
  /// - Returns: An iterator over the elements of this buffer.
  @inlinable // unsafe-performance
  public func makeIterator() -> Iterator {
    guard let start = _position else {
      return Iterator(_position: nil, _end: nil)
    }
    return Iterator(_position: start, _end: start + count)
  }

  /// Initializes the memory at `destination.baseAddress` with elements of `self`,
  /// stopping when either `self` or `destination` is exhausted.
  ///
  /// - Returns: an iterator over any remaining elements of `self` and the
  ///   number of elements initialized.
  @inlinable // unsafe-performance
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

  /// The index of the first element in a nonempty buffer.
  ///
  /// The `startIndex` property of an `UnsafeBufferPointer` instance
  /// is always zero.
  @inlinable // unsafe-performance
  public var startIndex: Int { return 0 }

  /// The "past the end" position---that is, the position one greater than the
  /// last valid subscript argument.
  ///
  /// The `endIndex` property of an `UnsafeBufferPointer` instance is
  /// always identical to `count`.
  @inlinable // unsafe-performance
  public var endIndex: Int { return count }

  @inlinable // unsafe-performance
  public func index(after i: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // NOTE: Wrapping math because we allow unsafe buffer pointers not to verify
    // index preconditions in release builds. Our (optimistic) assumption is
    // that the caller is already ensuring that indices are valid, so we can
    // elide the usual checks to help the optimizer generate better code.
    // However, we still check for overflow in debug mode.
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func formIndex(after i: inout Int) {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.addingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(before i: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func formIndex(before i: inout Int) {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.subtractingReportingOverflow(1)
    _debugPrecondition(!result.overflow)
    i = result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(_ i: Int, offsetBy n: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
    let result = i.addingReportingOverflow(n)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // See note on wrapping arithmetic in `index(after:)` above.
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

  @inlinable // unsafe-performance
  public func distance(from start: Int, to end: Int) -> Int {
    // NOTE: this is a manual specialization of index movement for a Strideable
    // index that is required for UnsafeBufferPointer performance. The
    // optimizer is not capable of creating partial specializations yet.
    // NOTE: Range checks are not performed here, because it is done later by
    // the subscript function.
    // NOTE: We allow the subtraction to silently overflow in release builds
    // to eliminate a superfluous check when `start` and `end` are both valid
    // indices. (The operation can only overflow if `start` is negative, which
    // implies it's an invalid index.) `Collection` does not specify what
    // `distance` should return when given an invalid index pair.
    let result = end.subtractingReportingOverflow(start)
    _debugPrecondition(!result.overflow)
    return result.partialValue
  }

  @inlinable // unsafe-performance
  public func _failEarlyRangeCheck(_ index: Int, bounds: Range<Int>) {
    // NOTE: In release mode, this method is a no-op for performance reasons.
    _debugPrecondition(index >= bounds.lowerBound)
    _debugPrecondition(index < bounds.upperBound)
  }

  @inlinable // unsafe-performance
  public func _failEarlyRangeCheck(_ range: Range<Int>, bounds: Range<Int>) {
    // NOTE: In release mode, this method is a no-op for performance reasons.
    _debugPrecondition(range.lowerBound >= bounds.lowerBound)
    _debugPrecondition(range.upperBound <= bounds.upperBound)
  }

  @inlinable // unsafe-performance
  public var indices: Indices {
    // Not checked because init forbids negative count.
    return Indices(uncheckedBounds: (startIndex, endIndex))
  }

  /// Accesses the element at the specified position.
  ///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 347)
  /// The following example uses the buffer pointer's subscript to access every
  /// other element of the buffer:
  ///
  ///     let numbers = [1, 2, 3, 4, 5]
  ///     let sum = numbers.withUnsafeBufferPointer { buffer -> Int in
  ///         var result = 0
  ///         for i in stride(from: buffer.startIndex, to: buffer.endIndex, by: 2) {
  ///             result += buffer[i]
  ///         }
  ///         return result
  ///     }
  ///     // 'sum' == 9
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 360)
  ///
  /// - Note: Bounds checks for `i` are performed only in debug mode.
  ///
  /// - Parameter i: The position of the element to access. `i` must be in the
  ///   range `0..<count`.
  @inlinable // unsafe-performance
  public subscript(i: Int) -> Element {
    get {
      _debugPrecondition(i >= 0)
      _debugPrecondition(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 379)
  }

  // Skip all debug and runtime checks

  @inlinable // unsafe-performance
  internal subscript(_unchecked i: Int) -> Element {
    get {
      _internalInvariant(i >= 0)
      _internalInvariant(i < endIndex)
      return _position._unsafelyUnwrappedUnchecked[i]
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 397)
  }

  /// Accesses a contiguous subrange of the buffer's elements.
  ///
  /// The accessed slice uses the same indices for the same elements as the
  /// original buffer uses. Always use the slice's `startIndex` property
  /// instead of assuming that its indices start at a particular value.
  ///
  /// This example demonstrates getting a slice from a buffer of strings, finding
  /// the index of one of the strings in the slice, and then using that index
  /// in the original buffer.
  ///
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 421)
  ///     let streets = ["Adams", "Bryant", "Channing", "Douglas", "Evarts"]
  ///     streets.withUnsafeBufferPointer { buffer in
  ///         let streetSlice = buffer[2..<buffer.endIndex]
  ///         print(Array(streetSlice))
  ///         // Prints "["Channing", "Douglas", "Evarts"]"
  ///         let index = streetSlice.firstIndex(of: "Evarts")    // 4
  ///         print(buffer[index!])
  ///         // Prints "Evarts"
  ///     }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 431)
  ///
  /// - Note: Bounds checks for `bounds` are performed only in debug mode.
  ///
  /// - Parameter bounds: A range of the buffer's indices. The bounds of
  ///   the range must be valid indices of the buffer.
  @inlinable // unsafe-performance
  public subscript(bounds: Range<Int>)
    -> Slice<UnsafeBufferPointer<Element>>
  {
    get {
      _debugPrecondition(bounds.lowerBound >= startIndex)
      _debugPrecondition(bounds.upperBound <= endIndex)
      return Slice(
        base: self, bounds: bounds)
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 460)
  }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 484)
}

extension UnsafeBufferPointer {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 516)

  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try body(self)
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 525)
  
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 527)

  /// Creates a buffer over the same memory as the given buffer slice.
  ///
  /// The new buffer represents the same region of memory as `slice`, but is
  /// indexed starting at zero instead of sharing indices with the original
  /// buffer. For example:
  ///
  ///     let buffer = returnsABuffer()
  ///     let n = 5
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeBufferPointer(rebasing: slice)
  ///
  /// After rebasing `slice` as the `rebased` buffer, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The buffer slice to rebase.
  @inlinable // unsafe-performance
  public init(rebasing slice: Slice<UnsafeBufferPointer<Element>>) {
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

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 566)

  /// Creates a buffer over the same memory as the given buffer slice.
  ///
  /// The new buffer represents the same region of memory as `slice`, but is
  /// indexed starting at zero instead of sharing indices with the original
  /// buffer. For example:
  ///
  ///     let buffer = returnsABuffer()
  ///     let n = 5
  ///     let slice = buffer[n...]
  ///     let rebased = UnsafeBufferPointer(rebasing: slice)
  ///
  /// After rebasing `slice` as the `rebased` buffer, the following are true:
  ///
  /// - `rebased.startIndex == 0`
  /// - `rebased[0] == slice[n]`
  /// - `rebased[0] == buffer[n]`
  /// - `rebased.count == slice.count`
  ///
  /// - Parameter slice: The buffer slice to rebase.
  @inlinable // unsafe-performance
  public init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) {
    let base = slice.base.baseAddress?.advanced(by: slice.startIndex)
    let count = slice.endIndex &- slice.startIndex
    self.init(start: base, count: count)
  }

  /// Deallocates the memory block previously allocated at this buffer pointer’s 
  /// base address. 
  ///
  /// This buffer pointer's `baseAddress` must be `nil` or a pointer to a memory 
  /// block previously returned by a Swift allocation method. If `baseAddress` is 
  /// `nil`, this function does nothing. Otherwise, the memory must not be initialized 
  /// or `Pointee` must be a trivial type. This buffer pointer's `count` must 
  /// be equal to the originally allocated size of the memory block.
  @inlinable // unsafe-performance
  public func deallocate() {
    _position?.deallocate()
  }

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1071)

  /// Executes the given closure while temporarily binding the memory referenced 
  /// by this buffer to the given type.
  ///
  /// Use this method when you have a buffer of memory bound to one type and
  /// you need to access that memory as a buffer of another type. Accessing
  /// memory as type `T` requires that the memory be bound to that type. A
  /// memory location may only be bound to one type at a time, so accessing
  /// the same memory as an unrelated type without first rebinding the memory
  /// is undefined.
  ///
  /// The number of instances of `T` referenced by the rebound buffer may be
  /// different than the number of instances of `Element` referenced by the
  /// original buffer. The number of instances of `T` will be calculated
  /// at runtime.
  /// 
  /// Any instance of `T` within the re-bound region may be initialized or
  /// uninitialized. Every instance of `Pointee` overlapping with a given
  /// instance of `T` should have the same initialization state (i.e.
  /// initialized or uninitialized.) Accessing a `T` whose underlying
  /// `Pointee` storage is in a mixed initialization state shall be
  /// undefined behaviour.
  ///
  /// Because this buffer's memory is no longer bound to its `Element` type
  /// while the `body` closure executes, do not access memory using the
  /// original buffer from within `body`. Instead, use the `body` closure's
  /// buffer argument to access the values in memory as instances of type
  /// `T`.
  ///
  /// After executing `body`, this method rebinds memory back to the original
  /// `Element` type.
  ///
  /// - Note: Only use this method to rebind the buffer's memory to a type
  ///   that is layout compatible with the currently bound `Element` type.
  ///   The stride of the temporary type (`T`) may be an integer multiple
  ///   or a whole fraction of `Element`'s stride.
  ///   To bind a region of memory to a type that does not match these
  ///   requirements, convert the buffer to a raw buffer and use the
  ///   raw buffer's `withMemoryRebound(to:)` method.
  ///   If `T` and `Element` have different alignments, this buffer's
  ///   `baseAddress` must be aligned with the larger of the two alignments.
  ///
  /// - Parameters:
  ///   - type: The type to temporarily bind the memory referenced by this
  ///     buffer. The type `T` must be layout compatible
  ///     with the pointer's `Element` type.
  ///   - body: A closure that takes a  typed buffer to the
  ///     same memory as this buffer, only bound to type `T`. The buffer
  ///     parameter contains a number of complete instances of `T` based
  ///     on the capacity of the original buffer and the stride of `Element`.
  ///     The closure's buffer argument is valid only for the duration of the
  ///     closure's execution. If `body` has a return value, that value
  ///     is also used as the return value for the `withMemoryRebound(to:_:)`
  ///     method.
  ///   - buffer: The buffer temporarily bound to `T`.
  /// - Returns: The return value, if any, of the `body` closure parameter.
  @inlinable // unsafe-performance
  @_alwaysEmitIntoClient
  // This custom silgen name is chosen to not interfere with the old ABI
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1133)
  @_silgen_name("_swift_se0333_UnsafeBufferPointer_withMemoryRebound")
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1135)
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

  // This unavailable implementation uses the expected mangled name
  // of `withMemoryRebound<T, Result>(to:_:)`, and provides
  // an entry point for any binary linked against the stdlib binary
  // for Swift 5.6 and older.
  @available(*, unavailable)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1173)
  @_silgen_name("$sSR17withMemoryRebound2to_qd_0_qd__m_qd_0_SRyqd__GKXEtKr0_lF")
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1175)
  @usableFromInline
  internal func _legacy_se0333_withMemoryRebound<T, Result>(
    to type: T.Type,
    _ body: (UnsafeBufferPointer<T>) throws -> Result
  ) rethrows -> Result {
    return try withMemoryRebound(to: T.self, body)
  }

  /// A pointer to the first element of the buffer.
  ///
  /// If the `baseAddress` of this buffer is `nil`, the count is zero. However,
  /// a buffer can have a `count` of zero even with a non-`nil` base address.
  @inlinable // unsafe-performance
  public var baseAddress: UnsafePointer<Element>? {
    return _position
  }
}

extension UnsafeBufferPointer: CustomDebugStringConvertible {
  /// A textual representation of the buffer, suitable for debugging.
  public var debugDescription: String {
    return "UnsafeBufferPointer"
      + "(start: \(_position.map(String.init(describing:)) ?? "nil"), count: \(count))"
  }
}
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/UnsafeBufferPointer.swift.gyb", line: 1201)


// Local Variables:
// eval: (read-only-mode 1)
// End:
