import SwiftShims
@inline(__always)
internal func _loadPartialUnalignedUInt64LE(
  _ p: UnsafeRawPointer,
  byteCount: Int
) -> UInt64 {
  var result: UInt64 = 0
  switch byteCount {
  case 7:
    result |= UInt64(p.load(fromByteOffset: 6, as: UInt8.self)) &<< 48
    fallthrough
  case 6:
    result |= UInt64(p.load(fromByteOffset: 5, as: UInt8.self)) &<< 40
    fallthrough
  case 5:
    result |= UInt64(p.load(fromByteOffset: 4, as: UInt8.self)) &<< 32
    fallthrough
  case 4:
    result |= UInt64(p.load(fromByteOffset: 3, as: UInt8.self)) &<< 24
    fallthrough
  case 3:
    result |= UInt64(p.load(fromByteOffset: 2, as: UInt8.self)) &<< 16
    fallthrough
  case 2:
    result |= UInt64(p.load(fromByteOffset: 1, as: UInt8.self)) &<< 8
    fallthrough
  case 1:
    result |= UInt64(p.load(fromByteOffset: 0, as: UInt8.self))
    fallthrough
  case 0:
    return result
  default:
    _internalInvariantFailure()
  }
}
extension Hasher {
  @usableFromInline @frozen
  internal struct _TailBuffer {
    internal var value: UInt64
    @inline(__always)
    internal init() {
      self.value = 0
    }
    @inline(__always)
    internal init(tail: UInt64, byteCount: UInt64) {
      let shiftedByteCount: UInt64 = ((byteCount & 7) << 3)
      let mask: UInt64 = (1 << shiftedByteCount - 1)
      _internalInvariant(tail & ~mask == 0)
      self.value = (byteCount &<< 56 | tail)
    }
    @inline(__always)
    internal init(tail: UInt64, byteCount: Int) {
      self.init(tail: tail, byteCount: UInt64(truncatingIfNeeded: byteCount))
    }
    internal var tail: UInt64 {
      @inline(__always)
      get { return value & ~(0xFF &<< 56) }
    }
    internal var byteCount: UInt64 {
      @inline(__always)
      get { return value &>> 56 }
    }
    @inline(__always)
    internal mutating func append(_ bytes: UInt64) -> UInt64 {
      let c = byteCount & 7
      if c == 0 {
        value = value &+ (8 &<< 56)
        return bytes
      }
      let shift = c &<< 3
      let chunk = tail | (bytes &<< shift)
      value = (((value &>> 56) &+ 8) &<< 56) | (bytes &>> (64 - shift))
      return chunk
    }
    @inline(__always)
    internal
    mutating func append(_ bytes: UInt64, count: UInt64) -> UInt64? {
      _internalInvariant(count >= 0 && count < 8)
      _internalInvariant(bytes & ~((1 &<< (count &<< 3)) &- 1) == 0)
      let c = byteCount & 7
      let shift = c &<< 3
      if c + count < 8 {
        value = (value | (bytes &<< shift)) &+ (count &<< 56)
        return nil
      }
      let chunk = tail | (bytes &<< shift)
      value = ((value &>> 56) &+ count) &<< 56
      if c + count > 8 {
        value |= bytes &>> (64 - shift)
      }
      return chunk
    }
  }
}
extension Hasher {
  @usableFromInline @frozen
  internal struct _Core {
    private var _buffer: _TailBuffer
    private var _state: Hasher._State
    @inline(__always)
    internal init(state: Hasher._State) {
      self._buffer = _TailBuffer()
      self._state = state
    }
    @inline(__always)
    internal init() {
      self.init(state: _State())
    }
    @inline(__always)
    internal init(seed: Int) {
      self.init(state: _State(seed: seed))
    }
    @inline(__always)
    internal mutating func combine(_ value: UInt) {
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32)
      combine(UInt32(truncatingIfNeeded: value))
#else
      combine(UInt64(truncatingIfNeeded: value))
#endif
    }
    @inline(__always)
    internal mutating func combine(_ value: UInt64) {
      _state.compress(_buffer.append(value))
    }
    @inline(__always)
    internal mutating func combine(_ value: UInt32) {
      let value = UInt64(truncatingIfNeeded: value)
      if let chunk = _buffer.append(value, count: 4) {
        _state.compress(chunk)
      }
    }
    @inline(__always)
    internal mutating func combine(_ value: UInt16) {
      let value = UInt64(truncatingIfNeeded: value)
      if let chunk = _buffer.append(value, count: 2) {
        _state.compress(chunk)
      }
    }
    @inline(__always)
    internal mutating func combine(_ value: UInt8) {
      let value = UInt64(truncatingIfNeeded: value)
      if let chunk = _buffer.append(value, count: 1) {
        _state.compress(chunk)
      }
    }
    @inline(__always)
    internal mutating func combine(bytes: UInt64, count: Int) {
      _internalInvariant(count >= 0 && count < 8)
      let count = UInt64(truncatingIfNeeded: count)
      if let chunk = _buffer.append(bytes, count: count) {
        _state.compress(chunk)
      }
    }
    @inline(__always)
    internal mutating func combine(bytes: UnsafeRawBufferPointer) {
      var remaining = bytes.count
      guard remaining > 0 else { return }
      var data = bytes.baseAddress!
      do {
        let start = UInt(bitPattern: data)
        let end = _roundUp(start, toAlignment: MemoryLayout<UInt64>.alignment)
        let c = min(remaining, Int(end - start))
        if c > 0 {
          let chunk = _loadPartialUnalignedUInt64LE(data, byteCount: c)
          combine(bytes: chunk, count: c)
          data += c
          remaining -= c
        }
      }
      _internalInvariant(
        remaining == 0 ||
        Int(bitPattern: data) & (MemoryLayout<UInt64>.alignment - 1) == 0)
      while remaining >= MemoryLayout<UInt64>.size {
        combine(UInt64(littleEndian: data.load(as: UInt64.self)))
        data += MemoryLayout<UInt64>.size
        remaining -= MemoryLayout<UInt64>.size
      }
      _internalInvariant(remaining >= 0 && remaining < 8)
      if remaining > 0 {
        let chunk = _loadPartialUnalignedUInt64LE(data, byteCount: remaining)
        combine(bytes: chunk, count: remaining)
      }
    }
    @inline(__always)
    internal mutating func finalize() -> UInt64 {
      return _state.finalize(tailAndByteCount: _buffer.value)
    }
  }
}
@frozen 
public struct Hasher {
  internal var _core: _Core
  public init() {
    self._core = _Core()
  }
  @usableFromInline
  internal init(_seed: Int) {
    self._core = _Core(seed: _seed)
  }
  @usableFromInline 
  internal init(_rawSeed: (UInt64, UInt64)) {
    self._core = _Core(state: _State(rawSeed: _rawSeed))
  }
  @inlinable
  internal static var _isDeterministic: Bool {
    @inline(__always)
    get {
      return _swift_stdlib_Hashing_parameters.deterministic
    }
  }
  @inlinable 
  internal static var _executionSeed: (UInt64, UInt64) {
    @inline(__always)
    get {
      return (
        _swift_stdlib_Hashing_parameters.seed0,
        _swift_stdlib_Hashing_parameters.seed1)
    }
  }
  @inlinable
  @inline(__always)
  public mutating func combine<H: Hashable>(_ value: H) {
    value.hash(into: &self)
  }
  @usableFromInline
  internal mutating func _combine(_ value: UInt) {
    _core.combine(value)
  }
  @usableFromInline
  internal mutating func _combine(_ value: UInt64) {
    _core.combine(value)
  }
  @usableFromInline
  internal mutating func _combine(_ value: UInt32) {
    _core.combine(value)
  }
  @usableFromInline
  internal mutating func _combine(_ value: UInt16) {
    _core.combine(value)
  }
  @usableFromInline
  internal mutating func _combine(_ value: UInt8) {
    _core.combine(value)
  }
  @usableFromInline
  internal mutating func _combine(bytes value: UInt64, count: Int) {
    _core.combine(bytes: value, count: count)
  }
  public mutating func combine(bytes: UnsafeRawBufferPointer) {
    _core.combine(bytes: bytes)
  }
  @usableFromInline
  internal mutating func _finalize() -> Int {
    return Int(truncatingIfNeeded: _core.finalize())
  }
  public __consuming func finalize() -> Int {
    var core = _core
    return Int(truncatingIfNeeded: core.finalize())
  }
  @usableFromInline
  internal static func _hash(seed: Int, _ value: UInt64) -> Int {
    var state = _State(seed: seed)
    state.compress(value)
    let tbc = _TailBuffer(tail: 0, byteCount: 8)
    return Int(truncatingIfNeeded: state.finalize(tailAndByteCount: tbc.value))
  }
  @usableFromInline
  internal static func _hash(seed: Int, _ value: UInt) -> Int {
    var state = _State(seed: seed)
#if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32)
    _internalInvariant(UInt.bitWidth < UInt64.bitWidth)
    let tbc = _TailBuffer(
      tail: UInt64(truncatingIfNeeded: value),
      byteCount: UInt.bitWidth &>> 3)
#else
    _internalInvariant(UInt.bitWidth == UInt64.bitWidth)
    state.compress(UInt64(truncatingIfNeeded: value))
    let tbc = _TailBuffer(tail: 0, byteCount: 8)
#endif
    return Int(truncatingIfNeeded: state.finalize(tailAndByteCount: tbc.value))
  }
  @usableFromInline
  internal static func _hash(
    seed: Int,
    bytes value: UInt64,
    count: Int) -> Int {
    _internalInvariant(count >= 0 && count < 8)
    var state = _State(seed: seed)
    let tbc = _TailBuffer(tail: value, byteCount: count)
    return Int(truncatingIfNeeded: state.finalize(tailAndByteCount: tbc.value))
  }
  @usableFromInline
  internal static func _hash(
    seed: Int,
    bytes: UnsafeRawBufferPointer) -> Int {
    var core = _Core(seed: seed)
    core.combine(bytes: bytes)
    return Int(truncatingIfNeeded: core.finalize())
  }
}
