import SwiftShims
extension String: Hashable {
  public func hash(into hasher: inout Hasher) {
    if _fastPath(self._guts.isNFCFastUTF8) {
      self._guts.withFastUTF8 {
        hasher.combine(bytes: UnsafeRawBufferPointer($0))
      }
      hasher.combine(0xFF as UInt8) 
    } else {
      _gutsSlice._normalizedHash(into: &hasher)
    }
  }
}
extension StringProtocol {
  public func hash(into hasher: inout Hasher) {
    _gutsSlice._normalizedHash(into: &hasher)
  }
}
extension _StringGutsSlice {
  internal func _normalizedHash(into hasher: inout Hasher) {
    if self.isNFCFastUTF8 {
      self.withFastUTF8 {
        hasher.combine(bytes: UnsafeRawBufferPointer($0))
      }
    } else {
      _withNFCCodeUnits {
        hasher.combine($0)
      }
    }
    hasher.combine(0xFF as UInt8) 
  }
}
