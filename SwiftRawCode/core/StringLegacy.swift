import SwiftShims
extension String {
  public init(repeating repeatedValue: String, count: Int) {
    _precondition(count >= 0, "Negative count not allowed")
    guard count > 1 else {
      self = count == 0 ? "" : repeatedValue
      return
    }
    var result = String()
    result.reserveCapacity(repeatedValue._guts.count &* count)
    for _ in 0..<count {
      result += repeatedValue
    }
    self = result
  }
  @inlinable
  public var isEmpty: Bool {
    @inline(__always) get { return _guts.isEmpty }
  }
}
extension StringProtocol {
  @inlinable
  public func hasPrefix<Prefix: StringProtocol>(_ prefix: Prefix) -> Bool {
    return self.starts(with: prefix)
  }
  @inlinable
  public func hasSuffix<Suffix: StringProtocol>(_ suffix: Suffix) -> Bool {
    return self.reversed().starts(with: suffix.reversed())
  }
}
extension String {
  public func hasPrefix(_ prefix: String) -> Bool {
    if _fastPath(self._guts.isNFCFastUTF8 && prefix._guts.isNFCFastUTF8) {
      guard prefix._guts.count <= self._guts.count else { return false }
      return prefix._guts.withFastUTF8 { nfcPrefix in
        let prefixEnd = nfcPrefix.count
        return self._guts.withFastUTF8(range: 0..<prefixEnd) { nfcSlicedSelf in
          return _binaryCompare(nfcSlicedSelf, nfcPrefix) == 0
        }
      }
    }
    return starts(with: prefix)
  }
  public func hasSuffix(_ suffix: String) -> Bool {
    if _fastPath(self._guts.isNFCFastUTF8 && suffix._guts.isNFCFastUTF8) {
      guard suffix._guts.count <= self._guts.count else { return false }
      return suffix._guts.withFastUTF8 { nfcSuffix in
        let suffixStart = self._guts.count - nfcSuffix.count
        return self._guts.withFastUTF8(range: suffixStart..<self._guts.count) {
          nfcSlicedSelf in return _binaryCompare(nfcSlicedSelf, nfcSuffix) == 0
        }
      }
    }
    return self.reversed().starts(with: suffix.reversed())
  }
}
extension String {
  public init<T: BinaryInteger>(
    _ value: T, radix: Int = 10, uppercase: Bool = false
  ) {
    self = value._description(radix: radix, uppercase: uppercase)
  }
}
