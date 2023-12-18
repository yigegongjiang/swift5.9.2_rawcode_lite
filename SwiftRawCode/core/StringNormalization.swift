import SwiftShims
extension Unicode.Scalar {
  internal var _isNFCStarter: Bool {
    if value < 0x300 {
      return true
    }
    let normData = _swift_stdlib_getNormData(value)
    let ccc = normData >> 3
    let isNFCQC = normData & 0x6 == 0
    return ccc == 0 && isNFCQC
  }
}
extension UnsafeBufferPointer where Element == UInt8 {
  internal func hasNormalizationBoundary(before offset: Int) -> Bool {
    if offset == 0 || offset == count {
      return true
    }
    _internalInvariant(!UTF8.isContinuation(self[_unchecked: offset]))
    if self[_unchecked: offset] < 0xCC { return true }
    let cu = _decodeScalar(self, startingAt: offset).0
    return cu._isNFCStarter
  }
  internal func isOnUnicodeScalarBoundary(_ offset: Int) -> Bool {
    guard offset < count else {
      _internalInvariant(offset == count)
      return true
    }
    return !UTF8.isContinuation(self[offset])
  }
}
