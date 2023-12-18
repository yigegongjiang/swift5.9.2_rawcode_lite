import SwiftShims
extension Unicode {
  internal struct _InternalNFC<S: StringProtocol> {
    let base: S
  }
}
extension Unicode._InternalNFC {
  internal struct Iterator {
    var buffer = Unicode._NormDataBuffer()
    var composee: Unicode.Scalar? = nil
    var iterator: Unicode._InternalNFD<S>.Iterator
  }
}
extension Unicode._InternalNFC.Iterator: IteratorProtocol {
  internal func compose(
    _ x: Unicode.Scalar,
    and y: Unicode.Scalar
  ) -> Unicode.Scalar? {
    if _fastPath(y.value < 0x300) {
      return nil
    }
    if let hangul = composeHangul(x, and: y) {
      return hangul
    }
    let composition = _swift_stdlib_getComposition(x.value, y.value)
    guard composition != .max else {
      return nil
    }
    return Unicode.Scalar(_value: composition)
  }
  @inline(never)
  internal func composeHangul(
    _ x: Unicode.Scalar,
    and y: Unicode.Scalar
  ) -> Unicode.Scalar? {
    let L: (base: UInt32, count: UInt32) = (base: 0x1100, count: 19)
    let V: (base: UInt32, count: UInt32) = (base: 0x1161, count: 21)
    let T: (base: UInt32, count: UInt32) = (base: 0x11A7, count: 28)
    let N: (base: UInt32, count: UInt32) = (base: 0x0, count: 588)
    let S: (base: UInt32, count: UInt32) = (base: 0xAC00, count: 11172)
    switch (x.value, y.value) {
    case (L.base ..< L.base &+ L.count, V.base ..< V.base &+ V.count):
      let lIdx = x.value &- L.base
      let vIdx = y.value &- V.base
      let lvIdx = lIdx &* N.count &+ vIdx &* T.count
      let s = S.base &+ lvIdx
      return Unicode.Scalar(_value: s)
    case (S.base ..< S.base &+ S.count, T.base &+ 1 ..< T.base &+ T.count):
      if (x.value &- S.base) % T.count == 0 {
        return Unicode.Scalar(_value: x.value &+ y.value &- T.base)
      } else {
        fallthrough
      }
    default:
      return nil
    }
  }
  internal mutating func next() -> Unicode.Scalar? {
    if let nextBuffered = buffer.next() {
      return nextBuffered.scalar
    }
    while let current = iterator.next() {
      guard let currentComposee = composee else {
        if current.normData.ccc == 0 {
          composee = current.scalar
          continue
        } else {
          return current.scalar
        }
      }
      guard let lastBufferedNormData = buffer.last?.normData else {
        guard !current.normData.isNFCQC,
            let composed = compose(currentComposee, and: current.scalar) else {
          if current.normData.ccc == 0 {
            composee = current.scalar
            return currentComposee
          }
          buffer.append(current)
          continue
        }
        composee = composed
        continue
      }
      guard lastBufferedNormData.ccc < current.normData.ccc else {
        if current.normData.ccc == 0 {
          composee = current.scalar
          return currentComposee
        }
        _internalInvariant(current.normData.ccc == lastBufferedNormData.ccc)
        buffer.append(current)
        continue
      }
      guard !current.normData.isNFCQC,
            let composed = compose(currentComposee, and: current.scalar) else {
        buffer.append(current)
        continue
      }
      composee = composed
    }
    return composee._take()
  }
}
extension Unicode._InternalNFC: Sequence {
  internal func makeIterator() -> Iterator {
    Iterator(iterator: base._internalNFD.makeIterator())
  }
}
extension StringProtocol {
  internal var _internalNFC: Unicode._InternalNFC<Self> {
    Unicode._InternalNFC(base: self)
  }
}
