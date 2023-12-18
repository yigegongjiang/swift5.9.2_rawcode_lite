import SwiftShims
@frozen
public 
struct _StringGuts: @unchecked Sendable {
  @usableFromInline
  internal var _object: _StringObject
  @inlinable @inline(__always)
  internal init(_ object: _StringObject) {
    self._object = object
    _invariantCheck()
  }
  @inlinable @inline(__always)
  init() {
    self.init(_StringObject(empty: ()))
  }
}
extension _StringGuts {
  @inlinable @inline(__always)
  internal var rawBits: _StringObject.RawBitPattern {
    return _object.rawBits
  }
}
extension _StringGuts {
  @inlinable @inline(__always)
  internal init(_ smol: _SmallString) {
    self.init(_StringObject(smol))
  }
  @inlinable @inline(__always)
  internal init(_ bufPtr: UnsafeBufferPointer<UInt8>, isASCII: Bool) {
    self.init(_StringObject(immortal: bufPtr, isASCII: isASCII))
  }
  @inline(__always)
  internal init(_ storage: __StringStorage) {
    self.init(_StringObject(storage))
  }
  internal init(_ storage: __SharedStringStorage) {
    self.init(_StringObject(storage))
  }
  internal init(
    cocoa: AnyObject, providesFastUTF8: Bool, isASCII: Bool, length: Int
  ) {
    self.init(_StringObject(
      cocoa: cocoa,
      providesFastUTF8: providesFastUTF8,
      isASCII: isASCII,
      length: length))
  }
}
extension _StringGuts {
  @inlinable @inline(__always)
  internal var count: Int { return _object.count }
  @inlinable @inline(__always)
  internal var isEmpty: Bool { return count == 0 }
  @inlinable @inline(__always)
  internal var isSmall: Bool { return _object.isSmall }
  @inline(__always)
  internal var isSmallASCII: Bool {
    return _object.isSmall && _object.smallIsASCII
  }
  @inlinable @inline(__always)
  internal var asSmall: _SmallString {
    return _SmallString(_object)
  }
  @inlinable @inline(__always)
  internal var isASCII: Bool  {
    return _object.isASCII
  }
  @inlinable @inline(__always)
  internal var isFastASCII: Bool  {
    return isFastUTF8 && _object.isASCII
  }
  @inline(__always)
  internal var isNFC: Bool { return _object.isNFC }
  @inline(__always)
  internal var isNFCFastUTF8: Bool {
    return _object.isNFC && isFastUTF8
  }
  internal var hasNativeStorage: Bool { return _object.hasNativeStorage }
  internal var hasSharedStorage: Bool { return _object.hasSharedStorage }
  internal var hasBreadcrumbs: Bool {
    return hasSharedStorage
      || (hasNativeStorage && _object.withNativeStorage { $0.hasBreadcrumbs })
  }
}
extension _StringGuts {
  @inlinable
  internal var isFastUTF8: Bool { return _fastPath(_object.providesFastUTF8) }
  @inlinable @inline(__always)
  internal var isForeign: Bool {
     return _slowPath(_object.isForeign)
  }
  @inlinable @inline(__always)
  internal func withFastUTF8<R>(
    _ f: (UnsafeBufferPointer<UInt8>) throws -> R
  ) rethrows -> R {
    _internalInvariant(isFastUTF8)
    if self.isSmall { return try _SmallString(_object).withUTF8(f) }
    defer { _fixLifetime(self) }
    return try f(_object.fastUTF8)
  }
  @inlinable @inline(__always)
  internal func withFastUTF8<R>(
    range: Range<Int>,
    _ f: (UnsafeBufferPointer<UInt8>) throws -> R
  ) rethrows -> R {
    return try self.withFastUTF8 { wholeUTF8 in
      return try f(UnsafeBufferPointer(rebasing: wholeUTF8[range]))
    }
  }
  @inlinable @inline(__always)
  internal func withFastCChar<R>(
    _ f: (UnsafeBufferPointer<CChar>) throws -> R
  ) rethrows -> R {
    return try self.withFastUTF8 { utf8 in
      return try utf8.withMemoryRebound(to: CChar.self, f)
    }
  }
}
extension _StringGuts {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    #if arch(i386) || arch(arm) || arch(arm64_32) || arch(wasm32)
    _internalInvariant(MemoryLayout<String>.size == 12, """
    the runtime is depending on this, update Reflection.mm and \
    this if you change it
    """)
    #else
    _internalInvariant(MemoryLayout<String>.size == 16, """
    the runtime is depending on this, update Reflection.mm and \
    this if you change it
    """)
    #endif
  }
  #endif 
  internal func _dump() { _object._dump() }
}
extension _StringGuts {
  @inlinable @inline(__always) 
  internal func withCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result {
    if _slowPath(!_object.isFastZeroTerminated) {
      return try _slowWithCString(body)
    }
    return try self.withFastCChar {
      return try body($0.baseAddress._unsafelyUnwrappedUnchecked)
    }
  }
  @inline(never) 
  @usableFromInline
  internal func _slowWithCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result {
    _internalInvariant(!_object.isFastZeroTerminated)
    return try String(self).utf8CString.withUnsafeBufferPointer {
      let ptr = $0.baseAddress._unsafelyUnwrappedUnchecked
      return try body(ptr)
    }
  }
}
extension _StringGuts {
  @inlinable
  internal func copyUTF8(into mbp: UnsafeMutableBufferPointer<UInt8>) -> Int? {
    let ptr = mbp.baseAddress._unsafelyUnwrappedUnchecked
    if _fastPath(self.isFastUTF8) {
      return self.withFastUTF8 { utf8 in
        guard utf8.count <= mbp.count else { return nil }
        let utf8Start = utf8.baseAddress._unsafelyUnwrappedUnchecked
        ptr.initialize(from: utf8Start, count: utf8.count)
        return utf8.count
      }
    }
    return _foreignCopyUTF8(into: mbp)
  }
  @usableFromInline @inline(never) 
  internal func _foreignCopyUTF8(
    into mbp: UnsafeMutableBufferPointer<UInt8>
  ) -> Int? {
    #if _runtime(_ObjC)
    let res = _object.withCocoaObject {
      _cocoaStringCopyUTF8($0, into: UnsafeMutableRawBufferPointer(mbp))
    }
    if let res { return res }
    var ptr = mbp.baseAddress._unsafelyUnwrappedUnchecked
    var numWritten = 0
    for cu in String(self).utf8 {
      guard numWritten < mbp.count else { return nil }
      ptr.initialize(to: cu)
      ptr += 1
      numWritten += 1
    }
    return numWritten
    #else
    fatalError("No foreign strings on Linux in this version of Swift")
    #endif
  }
  @inline(__always)
  internal var utf8Count: Int {
    if _fastPath(self.isFastUTF8) { return count }
    return String(self).utf8.count
  }
}
extension _StringGuts {
  @usableFromInline
  internal typealias Index = String.Index
  @inlinable @inline(__always)
  internal var startIndex: String.Index {
    Index(_encodedOffset: 0)._characterAligned._encodingIndependent
  }
  @inlinable @inline(__always)
  internal var endIndex: String.Index {
    markEncoding(Index(_encodedOffset: self.count)._characterAligned)
  }
}
extension _StringGuts {
  @inline(__always)
  internal var isUTF8: Bool { _object.isUTF8 }
  @inline(__always)
  internal func markEncoding(_ i: String.Index) -> String.Index {
    isUTF8 ? i._knownUTF8 : i._knownUTF16
  }
  internal func hasMatchingEncoding(_ i: String.Index) -> Bool {
    i._hasMatchingEncoding(isUTF8: isUTF8)
  }
  @inline(__always)
  internal func ensureMatchingEncoding(_ i: Index) -> Index {
    if _fastPath(hasMatchingEncoding(i)) { return i }
    return _slowEnsureMatchingEncoding(i)
  }
  @inline(never)
  internal func _slowEnsureMatchingEncoding(_ i: Index) -> Index {
    if isUTF8 {
      let utf16 = String.UTF16View(self)
      var r = utf16.index(utf16.startIndex, offsetBy: i._encodedOffset)
      if i.transcodedOffset != 0 {
        r = r.encoded(offsetBy: i.transcodedOffset)
      } else {
        r = r._copyingAlignment(from: i)
      }
      return r._knownUTF8
    }
    let utf8 = String.UTF8View(self)
    var r = utf8.index(utf8.startIndex, offsetBy: i._encodedOffset)
    if i.transcodedOffset != 0 {
      r = r.encoded(offsetBy: i.transcodedOffset)
    } else {
      r = r._copyingAlignment(from: i)
    }
    return r._knownUTF16
  }
}
extension _StringGuts {
  @available(*, deprecated)
  public 
  var _isContiguousASCII: Bool {
    return !isSmall && isFastUTF8 && isASCII
  }
  @available(*, unavailable)
  public var _isContiguousUTF16: Bool {
    return false
  }
  @available(*, deprecated)
  public var startASCII: UnsafeMutablePointer<UInt8> {
    return UnsafeMutablePointer(mutating: _object.fastUTF8.baseAddress!)
  }
  @available(*, unavailable)
  public var startUTF16: UnsafeMutablePointer<UTF16.CodeUnit> {
    fatalError("Not contiguous UTF-16")
  }
}
@available(*, unavailable)
public func _persistCString(_ p: UnsafePointer<CChar>?) -> [CChar]? {
  guard let s = p else { return nil }
  let bytesToCopy = UTF8._nullCodeUnitOffset(in: s) + 1 
  let result = [CChar](unsafeUninitializedCapacity: bytesToCopy) { buf, initedCount in
    buf.baseAddress!.update(from: s, count: bytesToCopy)
    initedCount = bytesToCopy
  }
  return result
}
