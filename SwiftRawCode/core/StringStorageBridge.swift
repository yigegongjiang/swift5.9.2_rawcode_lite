import SwiftShims
#if _runtime(_ObjC)
internal var _cocoaASCIIEncoding:UInt { 1 } 
internal var _cocoaUTF8Encoding:UInt { 4 } 
extension String {
  @available(SwiftStdlib 5.6, *)
  public init?(_nativeStorage: AnyObject) {
    let knownOther = _KnownCocoaString(_nativeStorage)
    switch knownOther {
    case .storage:
      self = _unsafeUncheckedDowncast(
        _nativeStorage,
        to: __StringStorage.self
      ).asString
    case .shared:
      self = _unsafeUncheckedDowncast(
        _nativeStorage,
        to: __SharedStringStorage.self
      ).asString
    default:
      return nil
    }
  }
}
extension _AbstractStringStorage {
  @inline(__always)
  internal func _getCharacters(
    _ buffer: UnsafeMutablePointer<UInt16>, _ aRange: _SwiftNSRange
  ) {
    _precondition(aRange.location >= 0 && aRange.length >= 0,
                  "Range out of bounds")
    _precondition(aRange.location + aRange.length <= Int(count),
                  "Range out of bounds")
    let range = Range(
      _uncheckedBounds: (aRange.location, aRange.location+aRange.length))
    let str = asString
    str._copyUTF16CodeUnits(
      into: UnsafeMutableBufferPointer(start: buffer, count: range.count),
      range: range)
  }
  @inline(__always)
  internal func _getCString(
    _ outputPtr: UnsafeMutablePointer<UInt8>, _ maxLength: Int, _ encoding: UInt
  ) -> Int8 {
    switch (encoding, isASCII) {
    case (_cocoaASCIIEncoding, true),
         (_cocoaUTF8Encoding, _):
      guard maxLength >= count + 1 else { return 0 }
      outputPtr.initialize(from: start, count: count)
      outputPtr[count] = 0
      return 1
    default:
      return  _cocoaGetCStringTrampoline(self, outputPtr, maxLength, encoding)
    }
  }
  @inline(__always)
  internal func _cString(encoding: UInt) -> UnsafePointer<UInt8>? {
    switch (encoding, isASCII) {
    case (_cocoaASCIIEncoding, true),
         (_cocoaUTF8Encoding, _):
      return start
    default:
      return _cocoaCStringUsingEncodingTrampoline(self, encoding)
    }
  }
  internal func _nativeIsEqual<T:_AbstractStringStorage>(
    _ nativeOther: T
  ) -> Int8 {
    if count != nativeOther.count {
      return 0
    }
    return (start == nativeOther.start ||
      (memcmp(start, nativeOther.start, count) == 0)) ? 1 : 0
  }
  @inline(__always)
  internal func _isEqual(_ other: AnyObject?) -> Int8 {
    guard let other = other else {
      return 0
    }
    if self === other {
      return 1
    }
    let knownOther = _KnownCocoaString(other)
    switch knownOther {
    case .storage:
      return _nativeIsEqual(
        _unsafeUncheckedDowncast(other, to: __StringStorage.self))
    case .shared:
      return _nativeIsEqual(
        _unsafeUncheckedDowncast(other, to: __SharedStringStorage.self))
    default:
      if !_isNSString(other) {
        return 0
      }
      let otherUTF16Length = _stdlib_binary_CFStringGetLength(other)
      if let asciiEqual = withCocoaASCIIPointer(other, work: { (ascii) -> Bool in
        if otherUTF16Length == self.count {
          return (start == ascii || (memcmp(start, ascii, self.count) == 0))
        }
        return false
      }) {
        return asciiEqual ? 1 : 0
      }
      if self.UTF16Length != otherUTF16Length {
        return 0
      }
      /*
      The abstract implementation of -isEqualToString: falls back to -compare:
      immediately, so when we run out of fast options to try, do the same.
      We can likely be more clever here if need be
      */
      return _cocoaStringCompare(self, other) == 0 ? 1 : 0
    }
  }
}
extension __StringStorage {
  @objc(length)
  final internal var UTF16Length: Int {
      return asString.utf16.count 
    }
  }
  @objc
  final internal var hash: UInt {
      if isASCII {
        return _cocoaHashASCIIBytes(start, length: count)
      }
      return _cocoaHashString(self)
    }
  }
  @objc(characterAtIndex:)
  final internal func character(at offset: Int) -> UInt16 {
    let str = asString
    return str.utf16[str._toUTF16Index(offset)]
  }
  @objc(getCharacters:range:)
  final internal func getCharacters(
   _ buffer: UnsafeMutablePointer<UInt16>, range aRange: _SwiftNSRange
  ) {
    _getCharacters(buffer, aRange)
  }
  @objc(_fastCStringContents:)
  final internal func _fastCStringContents(
    _ requiresNulTermination: Int8
  ) -> UnsafePointer<CChar>? {
    if isASCII {
      return start._asCChar
    }
    return nil
  }
  @objc(UTF8String)
  final internal func _utf8String() -> UnsafePointer<UInt8>? {
    return start
  }
  @objc(cStringUsingEncoding:)
  final internal func cString(encoding: UInt) -> UnsafePointer<UInt8>? {
    return _cString(encoding: encoding)
  }
  @objc(getCString:maxLength:encoding:)
  final internal func getCString(
    _ outputPtr: UnsafeMutablePointer<UInt8>, maxLength: Int, encoding: UInt
  ) -> Int8 {
    return _getCString(outputPtr, maxLength, encoding)
  }
  @objc
  final internal var fastestEncoding: UInt {
      if isASCII {
        return _cocoaASCIIEncoding
      }
      return _cocoaUTF8Encoding
    }
  }
  @objc(isEqualToString:)
  final internal func isEqualToString(to other: AnyObject?) -> Int8 {
    return _isEqual(other)
  }
  @objc(isEqual:)
  final internal func isEqual(to other: AnyObject?) -> Int8 {
    return _isEqual(other)
  }
  @objc(copyWithZone:)
  final internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
}
extension __SharedStringStorage {
  @objc(length)
  final internal var UTF16Length: Int {
      return asString.utf16.count 
    }
  }
  @objc
  final internal var hash: UInt {
      if isASCII {
        return _cocoaHashASCIIBytes(start, length: count)
      }
      return _cocoaHashString(self)
    }
  }
  @objc(characterAtIndex:)
  final internal func character(at offset: Int) -> UInt16 {
    let str = asString
    return str.utf16[str._toUTF16Index(offset)]
  }
  @objc(getCharacters:range:)
  final internal func getCharacters(
    _ buffer: UnsafeMutablePointer<UInt16>, range aRange: _SwiftNSRange
  ) {
    _getCharacters(buffer, aRange)
  }
  @objc
  final internal var fastestEncoding: UInt {
      if isASCII {
        return _cocoaASCIIEncoding
      }
      return _cocoaUTF8Encoding
    }
  }
  @objc(_fastCStringContents:)
  final internal func _fastCStringContents(
    _ requiresNulTermination: Int8
  ) -> UnsafePointer<CChar>? {
    if isASCII {
      return start._asCChar
    }
    return nil
  }
  @objc(UTF8String)
  final internal func _utf8String() -> UnsafePointer<UInt8>? {
    return start
  }
  @objc(cStringUsingEncoding:)
  final internal func cString(encoding: UInt) -> UnsafePointer<UInt8>? {
    return _cString(encoding: encoding)
  }
  @objc(getCString:maxLength:encoding:)
  final internal func getCString(
    _ outputPtr: UnsafeMutablePointer<UInt8>, maxLength: Int, encoding: UInt
  ) -> Int8 {
    return _getCString(outputPtr, maxLength, encoding)
  }
  @objc(isEqualToString:)
  final internal func isEqualToString(to other: AnyObject?) -> Int8 {
    return _isEqual(other)
  }
  @objc(isEqual:)
  final internal func isEqual(to other: AnyObject?) -> Int8 {
    return _isEqual(other)
  }
  @objc(copyWithZone:)
  final internal func copy(with zone: _SwiftNSZone?) -> AnyObject {
    return self
  }
}
#endif 
