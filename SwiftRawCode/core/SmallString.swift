@frozen @usableFromInline
internal struct _SmallString {
  @usableFromInline
  internal typealias RawBitPattern = (UInt64, UInt64)
  @usableFromInline
  internal var _storage: RawBitPattern
  @inlinable @inline(__always)
  internal var rawBits: RawBitPattern { return _storage }
  @inlinable
  internal var leadingRawBits: UInt64 {
    @inline(__always) get { return _storage.0 }
    @inline(__always) set { _storage.0 = newValue }
  }
  @inlinable
  internal var trailingRawBits: UInt64 {
    @inline(__always) get { return _storage.1 }
    @inline(__always) set { _storage.1 = newValue }
  }
  @inlinable @inline(__always)
  internal init(rawUnchecked bits: RawBitPattern) {
    self._storage = bits
  }
  @inlinable @inline(__always)
  internal init(raw bits: RawBitPattern) {
    self.init(rawUnchecked: bits)
    _invariantCheck()
  }
  @inlinable @inline(__always)
  internal init(_ object: _StringObject) {
    _internalInvariant(object.isSmall)
    let leading = object.rawBits.0.littleEndian
    let trailing = object.rawBits.1.littleEndian
    self.init(raw: (leading, trailing))
  }
  @inlinable @inline(__always)
  internal init() {
    self.init(_StringObject(empty:()))
  }
}
extension _SmallString {
  @inlinable @inline(__always)
  internal static var capacity: Int {
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32)
    return 10
#elseif os(Android) && arch(arm64)
    return 14
#else
    return 15
#endif
  }
  @inlinable @inline(__always)
  internal var rawDiscriminatedObject: UInt64 {
    return _storage.1.littleEndian
  }
  @inlinable @inline(__always)
  internal var capacity: Int { return _SmallString.capacity }
  @inlinable @inline(__always)
  internal var count: Int {
    return _StringObject.getSmallCount(fromRaw: rawDiscriminatedObject)
  }
  @inlinable @inline(__always)
  internal var unusedCapacity: Int { return capacity &- count }
  @inlinable @inline(__always)
  internal var isASCII: Bool {
    return _StringObject.getSmallIsASCII(fromRaw: rawDiscriminatedObject)
  }
  @inlinable @inline(__always)
  internal var zeroTerminatedRawCodeUnits: RawBitPattern {
#if os(Android) && arch(arm64)
    let smallStringCodeUnitMask = ~UInt64(0xFFFF).bigEndian 
#else
    let smallStringCodeUnitMask = ~UInt64(0xFF).bigEndian 
#endif
    return (self._storage.0, self._storage.1 & smallStringCodeUnitMask)
  }
  internal func computeIsASCII() -> Bool {
    let asciiMask: UInt64 = 0x8080_8080_8080_8080
    let raw = zeroTerminatedRawCodeUnits
    return (raw.0 | raw.1) & asciiMask == 0
  }
}
extension _SmallString {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    _internalInvariant(count <= _SmallString.capacity)
    _internalInvariant(isASCII == computeIsASCII())
    var copy = self
    withUnsafeBytes(of: &copy._storage) {
      _internalInvariant(
        $0[count..<_SmallString.capacity].allSatisfy { $0 == 0 })
    }
  }
  #endif 
  internal func _dump() {
    #if INTERNAL_CHECKS_ENABLED
    print("""
      smallUTF8: count: \(self.count), codeUnits: \(
        self.map { String($0, radix: 16) }.joined()
      )
      """)
    #endif 
  }
}
extension _SmallString: RandomAccessCollection, MutableCollection {
  @usableFromInline
  internal typealias Index = Int
  @usableFromInline
  internal typealias Element = UInt8
  @usableFromInline
  internal typealias SubSequence = _SmallString
  @inlinable @inline(__always)
  internal var startIndex: Int { return 0 }
  @inlinable @inline(__always)
  internal var endIndex: Int { return count }
  @inlinable
  internal subscript(_ idx: Int) -> UInt8 {
    @inline(__always) get {
      _internalInvariant(idx >= 0 && idx <= 15)
      if idx < 8 {
        return leadingRawBits._uncheckedGetByte(at: idx)
      } else {
        return trailingRawBits._uncheckedGetByte(at: idx &- 8)
      }
    }
    @inline(__always) set {
      _internalInvariant(idx >= 0 && idx <= 15)
      if idx < 8 {
        leadingRawBits._uncheckedSetByte(at: idx, to: newValue)
      } else {
        trailingRawBits._uncheckedSetByte(at: idx &- 8, to: newValue)
      }
    }
  }
  @inlinable  @inline(__always)
  internal subscript(_ bounds: Range<Index>) -> SubSequence {
    get {
      return self.withUTF8 { utf8 in
        let rebased = UnsafeBufferPointer(rebasing: utf8[bounds])
        return _SmallString(rebased)._unsafelyUnwrappedUnchecked
      }
    }
  }
}
extension _SmallString {
  @inlinable @inline(__always)
  internal func withUTF8<Result>(
    _ f: (UnsafeBufferPointer<UInt8>) throws -> Result
  ) rethrows -> Result {
    let count = self.count
    var raw = self.zeroTerminatedRawCodeUnits
    return try Swift._withUnprotectedUnsafeBytes(of: &raw) {
      let rawPtr = $0.baseAddress._unsafelyUnwrappedUnchecked
      let ptr = rawPtr.bindMemory(to: UInt8.self, capacity: count)
      defer {
        _ = rawPtr.bindMemory(to: RawBitPattern.self, capacity: 1)
      }
      return try f(UnsafeBufferPointer(_uncheckedStart: ptr, count: count))
    }
  }
  @inline(__always)
  fileprivate mutating func withMutableCapacity(
    _ f: (UnsafeMutableRawBufferPointer) throws -> Int
  ) rethrows {
    let len = try withUnsafeMutableBytes(of: &_storage, f)
    if len <= 0 {
      _debugPrecondition(len == 0)
      self = _SmallString()
      return
    }
    _SmallString.zeroTrailingBytes(of: &_storage, from: len)
    self = _SmallString(leading: _storage.0, trailing: _storage.1, count: len)
  }
  @inlinable
  internal static func zeroTrailingBytes(
    of storage: inout RawBitPattern, from index: Int
  ) {
    _internalInvariant(index > 0)
    _internalInvariant(index <= _SmallString.capacity)
    let mask0 = (UInt64(bitPattern: ~0) &>> (8 &* ( 8 &- Swift.min(index, 8))))
    let mask1 = (UInt64(bitPattern: ~0) &>> (8 &* (16 &- Swift.max(index, 8))))
    storage.0 &= (index <= 0) ? 0 : mask0.littleEndian
    storage.1 &= (index <= 8) ? 0 : mask1.littleEndian
  }
}
extension _SmallString {
  @inlinable @inline(__always)
  internal init(leading: UInt64, trailing: UInt64, count: Int) {
    _internalInvariant(count <= _SmallString.capacity)
    let isASCII = (leading | trailing) & 0x8080_8080_8080_8080 == 0
    let discriminator = _StringObject.Nibbles
      .small(withCount: count, isASCII: isASCII)
      .littleEndian 
    _internalInvariant(trailing & discriminator == 0)
    self.init(raw: (leading, trailing | discriminator))
    _internalInvariant(self.count == count)
  }
  @inlinable @inline(__always)
  internal init?(_ input: UnsafeBufferPointer<UInt8>) {
    if input.isEmpty {
      self.init()
      return
    }
    let count = input.count
    guard count <= _SmallString.capacity else { return nil }
    let ptr = input.baseAddress._unsafelyUnwrappedUnchecked
    let leading = _bytesToUInt64(ptr, Swift.min(input.count, 8))
    let trailing = count > 8 ? _bytesToUInt64(ptr + 8, count &- 8) : 0
    self.init(leading: leading, trailing: trailing, count: count)
  }
  @inline(__always)
  internal init(
    initializingUTF8With initializer: (
      _ buffer: UnsafeMutableBufferPointer<UInt8>
    ) throws -> Int
  ) rethrows {
    self.init()
    try self.withMutableCapacity {
      let capacity = $0.count
      let rawPtr = $0.baseAddress._unsafelyUnwrappedUnchecked
      let ptr = rawPtr.bindMemory(to: UInt8.self, capacity: capacity)
      defer {
        _ = rawPtr.bindMemory(to: RawBitPattern.self, capacity: 1)
      }
      return try initializer(
        UnsafeMutableBufferPointer<UInt8>(start: ptr, count: capacity))
    }
    self._invariantCheck()
  }
  @usableFromInline 
  internal init?(_ base: _SmallString, appending other: _SmallString) {
    let totalCount = base.count + other.count
    guard totalCount <= _SmallString.capacity else { return nil }
    var result = base
    var writeIdx = base.count
    for readIdx in 0..<other.count {
      result[writeIdx] = other[readIdx]
      writeIdx &+= 1
    }
    _internalInvariant(writeIdx == totalCount)
    let (leading, trailing) = result.zeroTerminatedRawCodeUnits
    self.init(leading: leading, trailing: trailing, count: totalCount)
  }
}
#if _runtime(_ObjC) && !(arch(i386) || arch(arm) || arch(arm64_32))
extension _SmallString {
  @usableFromInline 
  internal init?(taggedCocoa cocoa: AnyObject) {
    self.init()
    var success = true
    self.withMutableCapacity {
      /*
       For regular NSTaggedPointerStrings we will always succeed here, but
       tagged NSLocalizedStrings may not fit in a SmallString
       */
      if let len = _bridgeTagged(cocoa, intoUTF8: $0) {
        return len
      }
      success = false
      return 0
    }
    if !success {
      return nil
    }
    self._invariantCheck()
  }
  internal init?(taggedASCIICocoa cocoa: AnyObject) {
    self.init()
    var success = true
    self.withMutableCapacity {
      /*
       For regular NSTaggedPointerStrings we will always succeed here, but
       tagged NSLocalizedStrings may not fit in a SmallString
       */
      if let len = _bridgeTaggedASCII(cocoa, intoUTF8: $0) {
        return len
      }
      success = false
      return 0
    }
    if !success {
      return nil
    }
    self._invariantCheck()
  }
}
#endif
extension UInt64 {
  @inlinable @inline(__always)
  internal func _uncheckedGetByte(at i: Int) -> UInt8 {
    _internalInvariant(i >= 0 && i < MemoryLayout<UInt64>.stride)
#if _endian(big)
    let shift = (7 - UInt64(truncatingIfNeeded: i)) &* 8
#else
    let shift = UInt64(truncatingIfNeeded: i) &* 8
#endif
    return UInt8(truncatingIfNeeded: (self &>> shift))
  }
  @inlinable @inline(__always)
  internal mutating func _uncheckedSetByte(at i: Int, to value: UInt8) {
    _internalInvariant(i >= 0 && i < MemoryLayout<UInt64>.stride)
#if _endian(big)
    let shift = (7 - UInt64(truncatingIfNeeded: i)) &* 8
#else
    let shift = UInt64(truncatingIfNeeded: i) &* 8
#endif
    let valueMask: UInt64 = 0xFF &<< shift
    self = (self & ~valueMask) | (UInt64(truncatingIfNeeded: value) &<< shift)
  }
}
@inlinable @inline(__always)
internal func _bytesToUInt64(
  _ input: UnsafePointer<UInt8>,
  _ c: Int
) -> UInt64 {
  var r: UInt64 = 0
  var shift: Int = 0
  for idx in 0..<c {
    r = r | (UInt64(input[idx]) &<< shift)
    shift = shift &+ 8
  }
  return r.littleEndian
}
