import SwiftShims
internal typealias ScalarAndNormData = (
  scalar: Unicode.Scalar,
  normData: Unicode._NormData
)
extension Unicode {
  internal struct _NormData {
    var rawValue: UInt16
    var ccc: UInt8 {
      UInt8(truncatingIfNeeded: rawValue >> 3)
    }
    var isNFCQC: Bool {
      rawValue & 0x6 == 0
    }
    var isNFDQC: Bool {
      rawValue & 0x1 == 0
    }
    init(_ scalar: Unicode.Scalar, fastUpperbound: UInt32 = 0xC0) {
      if _fastPath(scalar.value < fastUpperbound) {
        rawValue = 0
      } else {
        rawValue = _swift_stdlib_getNormData(scalar.value)
        if (0xAC00 ... 0xD7A3).contains(scalar.value) {
          rawValue |= 0x1
        }
      }
    }
    init(rawValue: UInt16) {
      self.rawValue = rawValue
    }
  }
}
extension Unicode {
  internal struct _NormDataBuffer {
    var storage: [ScalarAndNormData] = []
    var isReversed = false
    var isEmpty: Bool {
      storage.isEmpty
    }
    var last: ScalarAndNormData? {
      storage.last
    }
    mutating func append(_ scalarAndNormData: ScalarAndNormData) {
      _internalInvariant(!isReversed)
      storage.append(scalarAndNormData)
    }
    mutating func next() -> ScalarAndNormData? {
      guard !storage.isEmpty else {
        isReversed = false
        return nil
      }
      if !isReversed {
        storage.reverse()
        isReversed = true
      }
      return storage.removeLast()
    }
    mutating func sort() {
      storage._insertionSort(within: storage.indices) {
        $0.normData.ccc < $1.normData.ccc
      }
    }
  }
}
extension Unicode {
  internal struct _DecompositionEntry {
    let rawValue: UInt32
    var hashedScalar: Unicode.Scalar {
      Unicode.Scalar(_value: (rawValue << 14) >> 14)
    }
    var index: Int {
      Int(truncatingIfNeeded: rawValue >> 18)
    }
    var utf8: UnsafeBufferPointer<UInt8> {
      let decompPtr = _swift_stdlib_nfd_decompositions._unsafelyUnwrappedUnchecked
      let size = Int(truncatingIfNeeded: decompPtr[index])
      return UnsafeBufferPointer(
        start: decompPtr + index + 1,
        count: size
      )
    }
    init(_ scalar: Unicode.Scalar) {
      rawValue = _swift_stdlib_getDecompositionEntry(scalar.value)
    }
  }
}
