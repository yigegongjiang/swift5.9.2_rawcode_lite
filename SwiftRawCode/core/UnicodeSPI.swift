import SwiftShims
extension Unicode {
  @available(SwiftStdlib 5.7, *)
  public struct _NFD {
    let base: Substring.UnicodeScalarView
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFD {
  @available(SwiftStdlib 5.7, *)
  public struct Iterator {
    var base: Unicode._InternalNFD<Substring>.Iterator
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFD.Iterator: IteratorProtocol {
  @available(SwiftStdlib 5.7, *)
  public mutating func next() -> Unicode.Scalar? {
    base.next()?.scalar
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFD: Sequence {
  @available(SwiftStdlib 5.7, *)
  public func makeIterator() -> Iterator {
    Iterator(base: Unicode._InternalNFD(base: base).makeIterator())
  }
}
extension String {
  @available(SwiftStdlib 5.7, *)
  public var _nfd: Unicode._NFD {
    Unicode._NFD(base: self[...].unicodeScalars)
  }
}
extension Substring {
  @available(SwiftStdlib 5.7, *)
  public var _nfd: Unicode._NFD {
    Unicode._NFD(base: unicodeScalars)
  }
}
extension Unicode {
  @available(SwiftStdlib 5.7, *)
  public struct _NFC {
    let base: Substring.UnicodeScalarView
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFC {
  @available(SwiftStdlib 5.7, *)
  public struct Iterator {
    var base: Unicode._InternalNFC<Substring>.Iterator
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFC.Iterator: IteratorProtocol {
  @available(SwiftStdlib 5.7, *)
  public mutating func next() -> Unicode.Scalar? {
    base.next()
  }
}
@available(SwiftStdlib 5.7, *)
extension Unicode._NFC: Sequence {
  @available(SwiftStdlib 5.7, *)
  public func makeIterator() -> Iterator {
    Iterator(
      base: Unicode._InternalNFC<Substring>.Iterator(
        iterator: Unicode._InternalNFD<Substring>(base: base).makeIterator()
      )
    )
  }
}
extension String {
  @available(SwiftStdlib 5.7, *)
  public var _nfc: Unicode._NFC {
    Unicode._NFC(base: self[...].unicodeScalars)
  }
}
extension Substring {
  @available(SwiftStdlib 5.7, *)
  public var _nfc: Unicode._NFC {
    Unicode._NFC(base: unicodeScalars)
  }
}
extension Unicode.Scalar.Properties {
  @available(SwiftStdlib 5.7, *)
  public var _script: UInt8 {
    let rawValue = _swift_stdlib_getScript(_scalar.value)
    _internalInvariant(rawValue != .max, "Unknown script rawValue")
    return rawValue
  }
  @available(SwiftStdlib 5.7, *)
  public var _scriptExtensions: [UInt8] {
    var count: UInt8 = 0
    let pointer = _swift_stdlib_getScriptExtensions(_scalar.value, &count)
    guard let pointer = pointer else {
      return [_script]
    }
    var result: [UInt8] = []
    result.reserveCapacity(Int(count))
    for i in 0 ..< count {
      let rawValue = pointer[Int(i)]
      _internalInvariant(rawValue != .max, "Unknown script rawValue")
      result.append(rawValue)
    }
    return result
  }
}
extension Unicode.Scalar.Properties {
  @available(SwiftStdlib 5.7, *)
  public var _caseFolded: String {
    var buffer: (UInt32, UInt32, UInt32) = (.max, .max, .max)
    withUnsafeMutableBytes(of: &buffer) {
      let ptr = $0.baseAddress!.assumingMemoryBound(to: UInt32.self)
      _swift_stdlib_getCaseMapping(_scalar.value, ptr)
    }
    var result = ""
    result.reserveCapacity(12)
    withUnsafeBytes(of: &buffer) {
      for scalar in $0.bindMemory(to: UInt32.self) {
        guard scalar != .max else {
          break
        }
        result.unicodeScalars.append(Unicode.Scalar(scalar)!)
      }
    }
    return result
  }
}
extension String {
  @available(SwiftStdlib 5.7, *)
  public func _wordIndex(after i: String.Index) -> String.Index {
    let i = _guts.validateWordIndex(i)
    let next = _guts.nextWordIndex(startingAt: i._encodedOffset)
    return String.Index(_encodedOffset: next)
  }
  @available(SwiftStdlib 5.7, *)
  public func _wordIndex(before i: String.Index) -> String.Index {
    let i = _guts.validateInclusiveWordIndex(i)
    _precondition(i > startIndex, "String index is out of bounds")
    let previous = _guts.previousWordIndex(endingAt: i._encodedOffset)
    return String.Index(_encodedOffset: previous)
  }
  @available(SwiftStdlib 5.7, *)
  public func _nearestWordIndex(atOrBelow i: String.Index) -> String.Index {
    _guts.validateInclusiveWordIndex(i)
  }
}
