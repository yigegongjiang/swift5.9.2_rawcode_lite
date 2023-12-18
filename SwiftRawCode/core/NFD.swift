extension Unicode {
  internal struct _InternalNFD<S: StringProtocol> {
    let base: S.UnicodeScalarView
  }
}
extension Unicode._InternalNFD {
  internal struct Iterator {
    var buffer = Unicode._NormDataBuffer()
    var index: S.UnicodeScalarView.Index
    let unicodeScalars: S.UnicodeScalarView
  }
}
extension Unicode._InternalNFD.Iterator: IteratorProtocol {
  internal mutating func decompose(
    _ scalar: Unicode.Scalar,
    with normData: Unicode._NormData
  ) {
    if _fastPath(scalar.value < 0xC0) {
      buffer.append((scalar, normData))
      return
    }
    if (0xAC00 ... 0xD7A3).contains(scalar.value) {
      decomposeHangul(scalar)
      return
    }
    decomposeSlow(scalar, with: normData)
  }
  @inline(never)
  internal mutating func decomposeHangul(_ scalar: Unicode.Scalar) {
    let L: (base: UInt32, count: UInt32) = (base: 0x1100, count: 19)
    let V: (base: UInt32, count: UInt32) = (base: 0x1161, count: 21)
    let T: (base: UInt32, count: UInt32) = (base: 0x11A7, count: 28)
    let N: (base: UInt32, count: UInt32) = (base: 0x0, count: 588)
    let S: (base: UInt32, count: UInt32) = (base: 0xAC00, count: 11172)
    let sIdx = scalar.value &- S.base
    let lIdx = sIdx / N.count
    let l = Unicode.Scalar(_value: L.base &+ lIdx)
    buffer.append((scalar: l, normData: .init(rawValue: 0)))
    let vIdx = (sIdx % N.count) / T.count
    let v = Unicode.Scalar(_value: V.base &+ vIdx)
    buffer.append((scalar: v, normData: .init(rawValue: 4)))
    let tIdx = sIdx % T.count
    if tIdx != 0 {
      let t = Unicode.Scalar(_value: T.base &+ tIdx)
      buffer.append((scalar: t, normData: .init(rawValue: 4)))
    }
  }
  @inline(never)
  internal mutating func decomposeSlow(
    _ scalar: Unicode.Scalar,
    with normData: Unicode._NormData
  ) {
    let decompEntry = Unicode._DecompositionEntry(scalar)
    guard scalar == decompEntry.hashedScalar else {
      buffer.append((scalar, normData))
      return
    }
    var utf8 = decompEntry.utf8
    while utf8.count > 0 {
      let (scalar, len) = _decodeScalar(utf8, startingAt: 0)
      utf8 = UnsafeBufferPointer(rebasing: utf8[len...])
      let normData = Unicode._NormData(scalar, fastUpperbound: 0x300)
      buffer.append((scalar, normData))
    }
  }
  internal mutating func next() -> ScalarAndNormData? {
    if let nextBuffered = buffer.next() {
      return nextBuffered
    }
    while index < unicodeScalars.endIndex {
      let scalar = unicodeScalars[index]
      let normData = Unicode._NormData(scalar)
      if normData.ccc == 0, !buffer.isEmpty {
        break
      }
      unicodeScalars.formIndex(after: &index)
      if normData.isNFDQC {
        if normData.ccc == 0 {
          return (scalar, normData)
        }
        buffer.append((scalar, normData))
      } else {
        decompose(scalar, with: normData)
      }
    }
    buffer.sort()
    return buffer.next()
  }
}
extension Unicode._InternalNFD: Sequence {
  internal func makeIterator() -> Iterator {
    Iterator(
      index: base.startIndex,
      unicodeScalars: base
    )
  }
}
extension StringProtocol {
  internal var _internalNFD: Unicode._InternalNFD<Self> {
    Unicode._InternalNFD(base: unicodeScalars)
  }
}
