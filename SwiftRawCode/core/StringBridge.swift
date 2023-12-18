import SwiftShims
@usableFromInline
internal typealias _CocoaString = AnyObject
#if _runtime(_ObjC)
@objc private protocol _StringSelectorHolder : _NSCopying {
  @objc var length: Int { get }
  @objc var hash: UInt { get }
  @objc(characterAtIndex:)
  func character(at offset: Int) -> UInt16
  @objc(getCharacters:range:)
  func getCharacters(
   _ buffer: UnsafeMutablePointer<UInt16>, range aRange: _SwiftNSRange
  )
  @objc(_fastCStringContents:)
  func _fastCStringContents(
    _ requiresNulTermination: Int8
  ) -> UnsafePointer<CChar>?
  @objc(_fastCharacterContents)
  func _fastCharacterContents() -> UnsafePointer<UInt16>?
  @objc(getBytes:maxLength:usedLength:encoding:options:range:remainingRange:)
  func getBytes(_ buffer: UnsafeMutableRawPointer?,
   maxLength maxBufferCount: Int,
  usedLength usedBufferCount: UnsafeMutablePointer<Int>?,
    encoding: UInt,
     options: UInt,
       range: _SwiftNSRange,
       remaining leftover: UnsafeMutablePointer<_SwiftNSRange>?) -> Int8
  @objc(compare:options:range:locale:)
  func compare(_ string: _CocoaString,
               options: UInt,
               range: _SwiftNSRange,
               locale: AnyObject?) -> Int
  @objc(newTaggedNSStringWithASCIIBytes_:length_:)
  func createTaggedString(bytes: UnsafePointer<UInt8>,
                          count: Int) -> AnyObject?
}
/*
 Passing a _CocoaString through _objc() lets you call ObjC methods that the
 compiler doesn't know about, via the protocol above. In order to get good
 performance, you need a double indirection like this:
  func a -> _objc -> func a'
 knowledge that the _CocoaString and _StringSelectorHolder are the same object.
 */
@inline(__always)
private func _objc(_ str: _CocoaString) -> _StringSelectorHolder {
  return unsafeBitCast(str, to: _StringSelectorHolder.self)
}
private func _copyNSString(_ str: _StringSelectorHolder) -> _CocoaString {
  return str.copy(with: nil)
}
@usableFromInline 
internal func _stdlib_binary_CFStringCreateCopy(
  _ source: _CocoaString
) -> _CocoaString {
  return _copyNSString(_objc(source))
}
private func _NSStringLen(_ str: _StringSelectorHolder) -> Int {
  return str.length
}
@usableFromInline 
internal func _stdlib_binary_CFStringGetLength(
  _ source: _CocoaString
) -> Int {
  if let len = getConstantTaggedCocoaContents(source)?.utf16Length {
    return len
  }
  return _NSStringLen(_objc(source))
}
internal func _isNSString(_ str:AnyObject) -> Bool {
  if getConstantTaggedCocoaContents(str) != nil {
    return true
  }
  return _swift_stdlib_isNSString(str) != 0
}
private func _NSStringCharactersPtr(_ str: _StringSelectorHolder) -> UnsafeMutablePointer<UTF16.CodeUnit>? {
  return UnsafeMutablePointer(mutating: str._fastCharacterContents())
}
@usableFromInline 
internal func _stdlib_binary_CFStringGetCharactersPtr(
  _ source: _CocoaString
) -> UnsafeMutablePointer<UTF16.CodeUnit>? {
  return _NSStringCharactersPtr(_objc(source))
}
private func _NSStringGetCharacters(
  from source: _StringSelectorHolder,
  range: Range<Int>,
  into destination: UnsafeMutablePointer<UTF16.CodeUnit>
) {
  source.getCharacters(destination, range: _SwiftNSRange(
    location: range.startIndex,
    length: range.count)
  )
}
internal func _cocoaStringCopyCharacters(
  from source: _CocoaString,
  range: Range<Int>,
  into destination: UnsafeMutablePointer<UTF16.CodeUnit>
) {
  _NSStringGetCharacters(from: _objc(source), range: range, into: destination)
}
private func _NSStringGetCharacter(
  _ target: _StringSelectorHolder, _ position: Int
) -> UTF16.CodeUnit {
  return target.character(at: position)
}
internal func _cocoaStringSubscript(
  _ target: _CocoaString, _ position: Int
) -> UTF16.CodeUnit {
  return _NSStringGetCharacter(_objc(target), position)
}
private func _NSStringCopyBytes(
  _ o: _StringSelectorHolder,
  encoding: UInt,
  into bufPtr: UnsafeMutableRawBufferPointer
) -> Int? {
  let ptr = bufPtr.baseAddress._unsafelyUnwrappedUnchecked
  let len = o.length
  var remainingRange = _SwiftNSRange(location: 0, length: 0)
  var usedLen = 0
  let success = 0 != o.getBytes(
    ptr,
    maxLength: bufPtr.count,
    usedLength: &usedLen,
    encoding: encoding,
    options: 0,
    range: _SwiftNSRange(location: 0, length: len),
    remaining: &remainingRange
  )
  if success && remainingRange.length == 0 {
    return usedLen
  }
  return nil
}
internal func _cocoaStringCopyUTF8(
  _ target: _CocoaString,
  into bufPtr: UnsafeMutableRawBufferPointer
) -> Int? {
  return _NSStringCopyBytes(
    _objc(target),
    encoding: _cocoaUTF8Encoding,
    into: bufPtr
  )
}
internal func _cocoaStringCopyASCII(
  _ target: _CocoaString,
  into bufPtr: UnsafeMutableRawBufferPointer
) -> Int? {
  return _NSStringCopyBytes(
    _objc(target),
    encoding: _cocoaASCIIEncoding,
    into: bufPtr
  )
}
private func _NSStringUTF8Count(
  _ o: _StringSelectorHolder,
  range: Range<Int>
) -> Int? {
  var remainingRange = _SwiftNSRange(location: 0, length: 0)
  var usedLen = 0
  let success = 0 != o.getBytes(
    UnsafeMutableRawPointer(Builtin.inttoptr_Word(0._builtinWordValue)),
    maxLength: 0,
    usedLength: &usedLen,
    encoding: _cocoaUTF8Encoding,
    options: 0,
    range: _SwiftNSRange(location: range.startIndex, length: range.count),
    remaining: &remainingRange
  )
  if success && remainingRange.length == 0 {
    return usedLen
  }
  return nil
}
internal func _cocoaStringUTF8Count(
  _ target: _CocoaString,
  range: Range<Int>
) -> Int? {
  if range.isEmpty { return 0 }
  return _NSStringUTF8Count(_objc(target), range: range)
}
private func _NSStringCompare(
  _ o: _StringSelectorHolder, _ other: _CocoaString
) -> Int {
  let range = _SwiftNSRange(location: 0, length: o.length)
  let options = UInt(2) 
  return o.compare(other, options: options, range: range, locale: nil)
}
internal func _cocoaStringCompare(
  _ string: _CocoaString, _ other: _CocoaString
) -> Int {
  return _NSStringCompare(_objc(string), other)
}
internal func _cocoaHashString(
  _ string: _CocoaString
) -> UInt {
  return _swift_stdlib_CFStringHashNSString(string)
}
internal func _cocoaHashASCIIBytes(
  _ bytes: UnsafePointer<UInt8>, length: Int
) -> UInt {
  return _swift_stdlib_CFStringHashCString(bytes, length)
}
internal func _cocoaCStringUsingEncodingTrampoline(
  _ string: _CocoaString, _ encoding: UInt
) -> UnsafePointer<UInt8>? {
  return _swift_stdlib_NSStringCStringUsingEncodingTrampoline(string, encoding)
}
internal func _cocoaGetCStringTrampoline(
  _ string: _CocoaString,
  _ buffer: UnsafeMutablePointer<UInt8>,
  _ maxLength: Int,
  _ encoding: UInt
) -> Int8 {
  return Int8(_swift_stdlib_NSStringGetCStringTrampoline(
    string, buffer, maxLength, encoding))
}
private var kCFStringEncodingASCII: _swift_shims_CFStringEncoding {
  @inline(__always) get { return 0x0600 }
}
private var kCFStringEncodingUTF8: _swift_shims_CFStringEncoding {
  @inline(__always) get { return 0x8000100 }
}
internal enum _KnownCocoaString {
  case storage
  case shared
  case cocoa
#if !(arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32))
  case tagged
#endif
#if arch(arm64)
  case constantTagged
#endif
  @inline(__always)
  init(_ str: _CocoaString) {
#if !(arch(i386) || arch(arm) || arch(arm64_32))
    if _isObjCTaggedPointer(str) {
#if arch(arm64)
      if let _ = getConstantTaggedCocoaContents(str) {
        self = .constantTagged
      } else {
        self = .tagged
      }
#else
      self = .tagged
#endif
      return
    }
#endif
    switch unsafeBitCast(_swift_classOfObjCHeapObject(str), to: UInt.self) {
    case unsafeBitCast(__StringStorage.self, to: UInt.self):
      self = .storage
    case unsafeBitCast(__SharedStringStorage.self, to: UInt.self):
      self = .shared
    default:
      self = .cocoa
    }
  }
}
#if !(arch(i386) || arch(arm) || arch(arm64_32))
internal func _bridgeTagged(
  _ cocoa: _CocoaString,
  intoUTF8 bufPtr: UnsafeMutableRawBufferPointer
) -> Int? {
  _internalInvariant(_isObjCTaggedPointer(cocoa))
  return _cocoaStringCopyUTF8(cocoa, into: bufPtr)
}
internal func _bridgeTaggedASCII(
  _ cocoa: _CocoaString,
  intoUTF8 bufPtr: UnsafeMutableRawBufferPointer
) -> Int? {
  _internalInvariant(_isObjCTaggedPointer(cocoa))
  return _cocoaStringCopyASCII(cocoa, into: bufPtr)
}
#endif
private func _NSStringASCIIPointer(_ str: _StringSelectorHolder) -> UnsafePointer<UInt8>? {
  return str._fastCStringContents(1)?._asUInt8
}
private func _NSStringUTF8Pointer(_ str: _StringSelectorHolder) -> UnsafePointer<UInt8>? {
  return _NSStringASCIIPointer(str)
}
private func _withCocoaASCIIPointer<R>(
  _ str: _CocoaString,
  requireStableAddress: Bool,
  work: (UnsafePointer<UInt8>) -> R?
) -> R? {
  #if !(arch(i386) || arch(arm) || arch(arm64_32))
  if _isObjCTaggedPointer(str) {
    if let ptr = getConstantTaggedCocoaContents(str)?.asciiContentsPointer {
      return work(ptr)
    }
    if requireStableAddress {
      return nil 
    }
    if let smol = _SmallString(taggedASCIICocoa: str) {
      return _StringGuts(smol).withFastUTF8 {
        work($0.baseAddress._unsafelyUnwrappedUnchecked)
      }
    }
  }
  #endif
  defer { _fixLifetime(str) }
  if let ptr = _NSStringASCIIPointer(_objc(str)) {
    return work(ptr)
  }
  return nil
}
private func _withCocoaUTF8Pointer<R>(
  _ str: _CocoaString,
  requireStableAddress: Bool,
  work: (UnsafePointer<UInt8>) -> R?
) -> R? {
  #if !(arch(i386) || arch(arm) || arch(arm64_32))
  if _isObjCTaggedPointer(str) {
    if let ptr = getConstantTaggedCocoaContents(str)?.asciiContentsPointer {
      return work(ptr)
    }
    if requireStableAddress {
      return nil 
    }
    if let smol = _SmallString(taggedCocoa: str) {
      return _StringGuts(smol).withFastUTF8 {
        work($0.baseAddress._unsafelyUnwrappedUnchecked)
      }
    }
  }
  #endif
  defer { _fixLifetime(str) }
  if let ptr = _NSStringUTF8Pointer(_objc(str)) {
    return work(ptr)
  }
  return nil
}
internal func withCocoaASCIIPointer<R>(
  _ str: _CocoaString,
  work: (UnsafePointer<UInt8>) -> R?
) -> R? {
  return _withCocoaASCIIPointer(str, requireStableAddress: false, work: work)
}
internal func withCocoaUTF8Pointer<R>(
  _ str: _CocoaString,
  work: (UnsafePointer<UInt8>) -> R?
) -> R? {
  return _withCocoaUTF8Pointer(str, requireStableAddress: false, work: work)
}
internal func stableCocoaASCIIPointer(_ str: _CocoaString)
  -> UnsafePointer<UInt8>? {
  return _withCocoaASCIIPointer(str, requireStableAddress: true, work: { $0 })
}
internal func stableCocoaUTF8Pointer(_ str: _CocoaString)
  -> UnsafePointer<UInt8>? {
  return _withCocoaUTF8Pointer(str, requireStableAddress: true, work: { $0 })
}
private enum CocoaStringPointer {
  case ascii(UnsafePointer<UInt8>)
  case utf8(UnsafePointer<UInt8>)
  case utf16(UnsafePointer<UInt16>)
  case none
}
private func _getCocoaStringPointer(
  _ cfImmutableValue: _CocoaString
) -> CocoaStringPointer {
  if let ascii = stableCocoaASCIIPointer(cfImmutableValue) {
    return .ascii(ascii)
  }
  return .none
}
#if arch(arm64)
private var constantTagMask:UInt {
  0b1111_1111_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111
}
private var expectedConstantTagValue:UInt {
  0b1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111
}
#endif
@inline(__always)
private func formConstantTaggedCocoaString(
  untaggedCocoa: _CocoaString
) -> AnyObject? {
#if !arch(arm64)
  return nil
#else
  let constantPtr:UnsafeRawPointer = Builtin.reinterpretCast(untaggedCocoa)
  guard _swift_stdlib_dyld_is_objc_constant_string(constantPtr) == 1 else {
    return nil
  }
  let retaggedPointer = UInt(bitPattern: constantPtr) | expectedConstantTagValue
  return unsafeBitCast(retaggedPointer, to: AnyObject.self)
#endif
}
@inline(__always)
private func getConstantTaggedCocoaContents(_ cocoaString: _CocoaString) ->
    (utf16Length: Int,
     asciiContentsPointer: UnsafePointer<UInt8>,
     untaggedCocoa: _CocoaString)? {
#if !arch(arm64)
  return nil
#else
  guard _isObjCTaggedPointer(cocoaString) else {
    return nil
  }
  let taggedValue = unsafeBitCast(cocoaString, to: UInt.self)
  guard taggedValue & constantTagMask == expectedConstantTagValue else {
    return nil
  }
  let payloadMask = ~constantTagMask
  let payload = taggedValue & payloadMask
  let ivarPointer = UnsafePointer<_swift_shims_builtin_CFString>(
    bitPattern: payload
  )!
  guard _swift_stdlib_dyld_is_objc_constant_string(
    UnsafeRawPointer(ivarPointer)
  ) == 1 else {
    return nil
  }
  let length = ivarPointer.pointee.length
  let isUTF16Mask:UInt = 0x0000_0000_0000_0004 
  let isASCII = ivarPointer.pointee.flags & isUTF16Mask == 0
  _precondition(isASCII) 
  let contentsPtr = ivarPointer.pointee.str
  return (
    utf16Length: Int(length),
    asciiContentsPointer: contentsPtr,
    untaggedCocoa: Builtin.reinterpretCast(ivarPointer)
  )
#endif
}
@usableFromInline
internal func _bridgeCocoaString(_ cocoaString: _CocoaString) -> _StringGuts {
  switch _KnownCocoaString(cocoaString) {
  case .storage:
    return _unsafeUncheckedDowncast(
      cocoaString, to: __StringStorage.self).asString._guts
  case .shared:
    return _unsafeUncheckedDowncast(
      cocoaString, to: __SharedStringStorage.self).asString._guts
#if !(arch(i386) || arch(arm) || arch(arm64_32))
  case .tagged:
    return _StringGuts(_SmallString(taggedCocoa: cocoaString)!)
#if arch(arm64)
  case .constantTagged:
    let taggedContents = getConstantTaggedCocoaContents(cocoaString)!
    return _StringGuts(
      cocoa: taggedContents.untaggedCocoa,
      providesFastUTF8: false, 
      isASCII: true,
      length: taggedContents.utf16Length
    )
#endif
#endif
  case .cocoa:
    let immutableCopy
      = _stdlib_binary_CFStringCreateCopy(cocoaString)
#if !(arch(i386) || arch(arm) || arch(arm64_32))
    if _isObjCTaggedPointer(immutableCopy) {
      return _StringGuts(
        _SmallString(taggedCocoa: immutableCopy).unsafelyUnwrapped
      )
    }
#endif
    let (fastUTF8, isASCII): (Bool, Bool)
    switch _getCocoaStringPointer(immutableCopy) {
    case .ascii(_): (fastUTF8, isASCII) = (true, true)
    case .utf8(_): (fastUTF8, isASCII) = (true, false)
    default:  (fastUTF8, isASCII) = (false, false)
    }
    let length = _stdlib_binary_CFStringGetLength(immutableCopy)
    return _StringGuts(
      cocoa: immutableCopy,
      providesFastUTF8: fastUTF8,
      isASCII: isASCII,
      length: length)
  }
}
extension String {
  public init(_cocoaString: AnyObject) {
    self._guts = _bridgeCocoaString(_cocoaString)
  }
}
private func _createNSString(
  _ receiver: _StringSelectorHolder,
  _ ptr: UnsafePointer<UInt8>,
  _ count: Int,
  _ encoding: UInt32
) -> AnyObject? {
  return receiver.createTaggedString(bytes: ptr, count: count)
}
private func _createCFString(
  _ ptr: UnsafePointer<UInt8>,
  _ count: Int,
  _ encoding: UInt32
) -> AnyObject? {
  return _createNSString(
    unsafeBitCast(__StringStorage.self as AnyClass, to: _StringSelectorHolder.self),
    ptr,
    count,
    encoding
  )
}
extension String {
  public 
  func _bridgeToObjectiveCImpl() -> AnyObject {
    _connectOrphanedFoundationSubclassesIfNeeded()
    if _guts.isSmallASCII {
      let maybeTagged = _guts.asSmall.withUTF8 { bufPtr in
        return _createCFString(
          bufPtr.baseAddress._unsafelyUnwrappedUnchecked,
          bufPtr.count,
          kCFStringEncodingUTF8
        )
      }
      if let tagged = maybeTagged { return tagged }
    }
    if _guts.isSmall {
        var copy = self
        copy._guts.grow(_SmallString.capacity + 1)
        _internalInvariant(!copy._guts.isSmall)
        return copy._bridgeToObjectiveCImpl()
    }
    if _guts._object.isImmortal {
      let gutsCountAndFlags = _guts._object._countAndFlags
      return __SharedStringStorage(
        immortal: _guts._object.fastUTF8.baseAddress!,
        countAndFlags: _StringObject.CountAndFlags(
          sharedCount: _guts.count, isASCII: gutsCountAndFlags.isASCII))
    }
    _internalInvariant(_guts._object.hasObjCBridgeableObject,
      "Unknown non-bridgeable object case")
    let result = _guts._object.objCBridgeableObject
    return formConstantTaggedCocoaString(untaggedCocoa: result) ?? result
  }
}
@available(SwiftStdlib 5.2, *)
@usableFromInline
internal func _SwiftCreateBridgedString_DoNotCall(
  bytes: UnsafePointer<UInt8>,
  length: Int,
  encoding: _swift_shims_CFStringEncoding
) -> Unmanaged<AnyObject> {
  let bufPtr = UnsafeBufferPointer(start: bytes, count: length)
  let str:String
  switch encoding {
  case kCFStringEncodingUTF8:
    str = String(decoding: bufPtr, as: Unicode.UTF8.self)
  case kCFStringEncodingASCII:
    str = String(decoding: bufPtr, as: Unicode.ASCII.self)
  default:
    fatalError("Unsupported encoding in shim")
  }
  return Unmanaged<AnyObject>.passRetained(str._bridgeToObjectiveCImpl())
}
  @objc internal init() {}
  deinit {}
}
public func _getDescription<T>(_ x: T) -> AnyObject {
  return String(reflecting: x)._bridgeToObjectiveCImpl()
}
@usableFromInline 
@available(SwiftStdlib 5.2, *)
internal func _NSStringFromUTF8(_ s: UnsafePointer<UInt8>, _ len: Int)
  -> AnyObject {
  return String(
    decoding: UnsafeBufferPointer(start: s, count: len),
    as: UTF8.self
  )._bridgeToObjectiveCImpl()
}
#else 
internal class __SwiftNativeNSString {
  internal init() {}
  deinit {}
}
#endif
extension StringProtocol {
  public 
  func _toUTF16Offset(_ idx: Index) -> Int {
    return self.utf16.distance(from: self.utf16.startIndex, to: idx)
  }
  public 
  func _toUTF16Index(_ offset: Int) -> Index {
    return self.utf16.index(self.utf16.startIndex, offsetBy: offset)
  }
  public 
  func _toUTF16Offsets(_ indices: Range<Index>) -> Range<Int> {
    if Self.self == String.self {
      let s = unsafeBitCast(self, to: String.self)
      return s.utf16._offsetRange(for: indices, from: s.startIndex)
    }
    if Self.self == Substring.self {
      let s = unsafeBitCast(self, to: Substring.self)
      return s._slice._base.utf16._offsetRange(for: indices, from: s.startIndex)
    }
    let startOffset = _toUTF16Offset(indices.lowerBound)
    let endOffset = _toUTF16Offset(indices.upperBound)
    return Range(uncheckedBounds: (lower: startOffset, upper: endOffset))
  }
  public 
  func _toUTF16Indices(_ range: Range<Int>) -> Range<Index> {
    if Self.self == String.self {
      let s = unsafeBitCast(self, to: String.self)
      return s.utf16._indexRange(for: range, from: s.startIndex)
    }
    if Self.self == Substring.self {
      let s = unsafeBitCast(self, to: Substring.self)
      return s._slice._base.utf16._indexRange(for: range, from: s.startIndex)
    }
    let lowerbound = _toUTF16Index(range.lowerBound)
    let upperbound = _toUTF16Index(range.upperBound)
    return Range(uncheckedBounds: (lower: lowerbound, upper: upperbound))
  }
}
extension String {
  public 
  func _copyUTF16CodeUnits(
    into buffer: UnsafeMutableBufferPointer<UInt16>,
    range: Range<Int>
  ) {
    _internalInvariant(buffer.count >= range.count)
    let indexRange = self._toUTF16Indices(range)
    self.utf16._nativeCopy(into: buffer, alignedRange: indexRange)
  }
}
