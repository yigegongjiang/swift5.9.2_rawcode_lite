import Swift
extension UInt8 {
  var _isSub300StartingByte: Bool { self < 0xCC }
}
extension UnicodeScalar {
  var isNFC: Bool { Character(self).singleNFCScalar == self }
}
extension Character {
  var singleNFCScalar: UnicodeScalar? {
    guard #available(SwiftStdlib 5.7, *) else { return nil }
    var nfcIter = String(self)._nfc.makeIterator()
    guard let scalar = nfcIter.next(), nfcIter.next() == nil else { return nil }
    return scalar
  }
  var singleScalar: UnicodeScalar? {
    hasExactlyOneScalar ? unicodeScalars.first! : nil
  }
}
extension String {
  var singleNFCScalar: UnicodeScalar? {
    guard !isEmpty && index(after: startIndex) == endIndex else { return nil }
    return first!.singleNFCScalar
  }
  var singleScalar: UnicodeScalar? {
    let scalars = unicodeScalars
    guard !scalars.isEmpty &&
          scalars.index(after: scalars.startIndex) == scalars.endIndex
    else { return nil }
    return scalars.first!
  }
}
