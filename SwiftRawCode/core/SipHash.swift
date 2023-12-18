extension Hasher {
  @usableFromInline @frozen
  internal struct _State {
    private var v0: UInt64 = 0x736f6d6570736575
    private var v1: UInt64 = 0x646f72616e646f6d
    private var v2: UInt64 = 0x6c7967656e657261
    private var v3: UInt64 = 0x7465646279746573
    private var v4: UInt64 = 0
    private var v5: UInt64 = 0
    private var v6: UInt64 = 0
    private var v7: UInt64 = 0
    @inline(__always)
    internal init(rawSeed: (UInt64, UInt64)) {
      v3 ^= rawSeed.1
      v2 ^= rawSeed.0
      v1 ^= rawSeed.1
      v0 ^= rawSeed.0
    }
  }
}
extension Hasher._State {
  @inline(__always)
  private static func _rotateLeft(_ x: UInt64, by amount: UInt64) -> UInt64 {
    return (x &<< amount) | (x &>> (64 - amount))
  }
  @inline(__always)
  private mutating func _round() {
    v0 = v0 &+ v1
    v1 = Hasher._State._rotateLeft(v1, by: 13)
    v1 ^= v0
    v0 = Hasher._State._rotateLeft(v0, by: 32)
    v2 = v2 &+ v3
    v3 = Hasher._State._rotateLeft(v3, by: 16)
    v3 ^= v2
    v0 = v0 &+ v3
    v3 = Hasher._State._rotateLeft(v3, by: 21)
    v3 ^= v0
    v2 = v2 &+ v1
    v1 = Hasher._State._rotateLeft(v1, by: 17)
    v1 ^= v2
    v2 = Hasher._State._rotateLeft(v2, by: 32)
  }
  @inline(__always)
  private func _extract() -> UInt64 {
    return v0 ^ v1 ^ v2 ^ v3
  }
}
extension Hasher._State {
  @inline(__always)
  internal mutating func compress(_ m: UInt64) {
    v3 ^= m
    _round()
    v0 ^= m
  }
  @inline(__always)
  internal mutating func finalize(tailAndByteCount: UInt64) -> UInt64 {
    compress(tailAndByteCount)
    v2 ^= 0xff
    for _ in 0..<3 {
      _round()
    }
    return _extract()
  }
}
extension Hasher._State {
  @inline(__always)
  internal init() {
    self.init(rawSeed: Hasher._executionSeed)
  }
  @inline(__always)
  internal init(seed: Int) {
    let executionSeed = Hasher._executionSeed
    let seed = UInt(bitPattern: seed)
    self.init(rawSeed: (
        executionSeed.0 ^ UInt64(truncatingIfNeeded: seed),
        executionSeed.1))
  }
}
