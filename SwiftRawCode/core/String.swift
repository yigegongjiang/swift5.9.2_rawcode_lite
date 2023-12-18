import SwiftShims
internal func unimplemented_utf8_32bit(
  _ message: String = "",
  file: StaticString = #file, line: UInt = #line
) -> Never {
  fatalError("32-bit: Unimplemented for UTF-8 support", file: file, line: line)
}
@frozen
public struct String {
  public 
  var _guts: _StringGuts
  @inlinable @inline(__always)
  internal init(_ _guts: _StringGuts) {
    self._guts = _guts
    _invariantCheck()
  }
  @inlinable
  internal static func _createEmpty(withInitialCapacity: Int) -> String {
    return String(_StringGuts(_initialCapacity: withInitialCapacity))
  }
  @inlinable @inline(__always)
  public init() { self.init(_StringGuts()) }
}
extension String: Sendable { }
extension String {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
  }
  #endif 
  public func _dump() {
    #if INTERNAL_CHECKS_ENABLED
    _guts._dump()
    #endif 
  }
}
extension String {
  public func _isIdentical(to other: Self) -> Bool {
    self._guts.rawBits == other._guts.rawBits
  }
}
extension String {
  @inline(never) 
  private static func _fromNonContiguousUnsafeBitcastUTF8Repairing<
    C: Collection
  >(_ input: C) -> (result: String, repairsMade: Bool) {
    _internalInvariant(C.Element.self == UInt8.self)
    return Array(input).withUnsafeBufferPointer {
      let raw = UnsafeRawBufferPointer($0)
      return String._fromUTF8Repairing(raw.bindMemory(to: UInt8.self))
    }
  }
  @inlinable
  @inline(__always) 
  public init<C: Collection, Encoding: Unicode.Encoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  ) where C.Iterator.Element == Encoding.CodeUnit {
    guard _fastPath(sourceEncoding == UTF8.self) else {
      self = String._fromCodeUnits(
        codeUnits, encoding: sourceEncoding, repair: true)!.0
      return
    }
    if let str = codeUnits.withContiguousStorageIfAvailable({
      (buffer: UnsafeBufferPointer<C.Element>) -> String in
      Builtin.onFastPath() 
      let rawBufPtr = UnsafeRawBufferPointer(buffer)
      return String._fromUTF8Repairing(
        UnsafeBufferPointer(
          start: rawBufPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
          count: rawBufPtr.count)).0
    }) {
      self = str
      return
    }
    if let contigBytes = codeUnits as? _HasContiguousBytes,
      contigBytes._providesContiguousBytesNoCopy
    {
      self = contigBytes.withUnsafeBytes { rawBufPtr in
        Builtin.onFastPath() 
        return String._fromUTF8Repairing(
          UnsafeBufferPointer(
            start: rawBufPtr.baseAddress?.assumingMemoryBound(to: UInt8.self),
            count: rawBufPtr.count)).0
      }
      return
    }
    self = String._fromNonContiguousUnsafeBitcastUTF8Repairing(codeUnits).0
  }
  @inline(__always)
  @available(SwiftStdlib 5.3, *)
  public init(
    unsafeUninitializedCapacity capacity: Int,
    initializingUTF8With initializer: (
      _ buffer: UnsafeMutableBufferPointer<UInt8>
    ) throws -> Int
  ) rethrows {
    self = try String(
      _uninitializedCapacity: capacity,
      initializingUTF8With: initializer
    )
  }
  @inline(__always)
  internal init(
    _uninitializedCapacity capacity: Int,
    initializingUTF8With initializer: (
      _ buffer: UnsafeMutableBufferPointer<UInt8>
    ) throws -> Int
  ) rethrows {
    if _fastPath(capacity <= _SmallString.capacity) {
      let smol = try _SmallString(initializingUTF8With: initializer)
      if _fastPath(smol.isASCII) {
        self = String(_StringGuts(smol))
      } else {
        self = smol.withUTF8 { String._fromUTF8Repairing($0).result }
      }
      return
    }
    self = try String._fromLargeUTF8Repairing(
      uninitializedCapacity: capacity,
      initializingWith: initializer)
  }
  @inlinable
  @inline(__always) 
  public func withCString<Result, TargetEncoding: Unicode.Encoding>(
    encodedAs targetEncoding: TargetEncoding.Type,
    _ body: (UnsafePointer<TargetEncoding.CodeUnit>) throws -> Result
  ) rethrows -> Result {
    if targetEncoding == UTF8.self {
      return try self.withCString {
        (cPtr: UnsafePointer<CChar>) -> Result  in
        _internalInvariant(UInt8.self == TargetEncoding.CodeUnit.self)
        let ptr = UnsafeRawPointer(cPtr).assumingMemoryBound(
          to: TargetEncoding.CodeUnit.self)
        return try body(ptr)
      }
    }
    return try _slowWithCString(encodedAs: targetEncoding, body)
  }
  @usableFromInline @inline(never) 
  internal func _slowWithCString<Result, TargetEncoding: Unicode.Encoding>(
    encodedAs targetEncoding: TargetEncoding.Type,
    _ body: (UnsafePointer<TargetEncoding.CodeUnit>) throws -> Result
  ) rethrows -> Result {
    var copy = self
    return try copy.withUTF8 { utf8 in
      var arg = Array<TargetEncoding.CodeUnit>()
      arg.reserveCapacity(1 &+ self._guts.count / 4)
      let repaired = transcode(
        utf8.makeIterator(),
        from: UTF8.self,
        to: targetEncoding,
        stoppingOnError: false,
        into: { arg.append($0) })
      arg.append(TargetEncoding.CodeUnit(0))
      _internalInvariant(!repaired)
      return try body(arg)
    }
  }
}
extension String: _ExpressibleByBuiltinUnicodeScalarLiteral {
  @inlinable @inline(__always)
  public init(_builtinUnicodeScalarLiteral value: Builtin.Int32) {
    self.init(Unicode.Scalar(_unchecked: UInt32(value)))
  }
  @inlinable @inline(__always)
  public init(_ scalar: Unicode.Scalar) {
    self = scalar.withUTF8CodeUnits { String._uncheckedFromUTF8($0) }
  }
}
extension String: _ExpressibleByBuiltinExtendedGraphemeClusterLiteral {
  @inlinable @inline(__always)
  public init(
    _builtinExtendedGraphemeClusterLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
  ) {
    self.init(
      _builtinStringLiteral: start,
      utf8CodeUnitCount: utf8CodeUnitCount,
      isASCII: isASCII)
  }
}
extension String: _ExpressibleByBuiltinStringLiteral {
  @inlinable @inline(__always)
  public init(
    _builtinStringLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
    ) {
    let bufPtr = UnsafeBufferPointer(
      start: UnsafeRawPointer(start).assumingMemoryBound(to: UInt8.self),
      count: Int(utf8CodeUnitCount))
    if let smol = _SmallString(bufPtr) {
      self = String(_StringGuts(smol))
      return
    }
    self.init(_StringGuts(bufPtr, isASCII: Bool(isASCII)))
  }
}
extension String: ExpressibleByStringLiteral {
  @inlinable @inline(__always)
  public init(stringLiteral value: String) {
    self = value
  }
}
extension String: CustomDebugStringConvertible {
  public var debugDescription: String {
    func hasBreak(between left: String, and right: Unicode.Scalar) -> Bool {
      var state = _GraphemeBreakingState()
      return state.shouldBreak(between: left.unicodeScalars.last!, and: right)
    }
    var result = "\""
    var wantBreak = true 
    for us in self.unicodeScalars {
      if let escaped = us._escaped(asASCII: false) {
        result += escaped
        wantBreak = true
      } else if wantBreak && !hasBreak(between: result, and: us) {
        result += us.escaped(asASCII: true)
        wantBreak = true
      } else {
        result.unicodeScalars.append(us)
        wantBreak = false
      }
    }
    var suffix = "\"".unicodeScalars
    while !result.isEmpty {
      result.unicodeScalars.append(suffix.first!)
      let i = result.index(before: result.endIndex)
      let j = result.unicodeScalars.index(before: result.endIndex)
      if i >= j {
        result.unicodeScalars.append(contentsOf: suffix.dropFirst())
        break
      }
      result.unicodeScalars.removeLast()
      let last = result.unicodeScalars.removeLast()
      suffix.insert(
        contentsOf: last.escaped(asASCII: true).unicodeScalars,
        at: suffix.startIndex)
    }
    return result
  }
}
extension String {
  @inlinable 
  public static func + (lhs: String, rhs: String) -> String {
    var result = lhs
    result.append(rhs)
    return result
  }
  @inlinable 
  public static func += (lhs: inout String, rhs: String) {
    lhs.append(rhs)
  }
}
extension Sequence where Element: StringProtocol {
  public func joined(separator: String = "") -> String {
    return _joined(separator: separator)
  }
  @inline(__always) 
  internal func _joined(separator: String) -> String {
    let underestimatedCap =
      (1 &+ separator._guts.count) &* self.underestimatedCount
    var result = ""
    result.reserveCapacity(underestimatedCap)
    if separator.isEmpty {
      for x in self {
        result.append(x._ephemeralString)
      }
      return result
    }
    var iter = makeIterator()
    if let first = iter.next() {
      result.append(first._ephemeralString)
      while let next = iter.next() {
        result.append(separator)
        result.append(next._ephemeralString)
      }
    }
    return result
  }
}
extension BidirectionalCollection where Element == String {
  public func joined(separator: String = "") -> String {
    return _joined(separator: separator)
  }
}
extension String {
  @inline(__always)
  internal func _uppercaseASCII(_ x: UInt8) -> UInt8 {
    let _lowercaseTable: UInt64 =
      0b0001_1111_1111_1111_0000_0000_0000_0000 &<< 32
    let isLower = _lowercaseTable &>> UInt64(((x &- 1) & 0b0111_1111) &>> 1)
    let toSubtract = (isLower & 0x1) &<< 5
    return x &- UInt8(truncatingIfNeeded: toSubtract)
  }
  @inline(__always)
  internal func _lowercaseASCII(_ x: UInt8) -> UInt8 {
    let _uppercaseTable: UInt64 =
      0b0000_0000_0000_0000_0001_1111_1111_1111 &<< 32
    let isUpper = _uppercaseTable &>> UInt64(((x &- 1) & 0b0111_1111) &>> 1)
    let toAdd = (isUpper & 0x1) &<< 5
    return x &+ UInt8(truncatingIfNeeded: toAdd)
  }
  public func lowercased() -> String {
    if _fastPath(_guts.isFastASCII) {
      return _guts.withFastUTF8 { utf8 in
        return String(_uninitializedCapacity: utf8.count) { buffer in
          for i in 0 ..< utf8.count {
            buffer[i] = _lowercaseASCII(utf8[i])
          }
          return utf8.count
        }
      }
    }
    var result = ""
    result.reserveCapacity(utf8.count)
    for scalar in unicodeScalars {
      result += scalar.properties.lowercaseMapping
    }
    return result
  }
  public func uppercased() -> String {
    if _fastPath(_guts.isFastASCII) {
      return _guts.withFastUTF8 { utf8 in
        return String(_uninitializedCapacity: utf8.count) { buffer in
          for i in 0 ..< utf8.count {
            buffer[i] = _uppercaseASCII(utf8[i])
          }
          return utf8.count
        }
      }
    }
    var result = ""
    result.reserveCapacity(utf8.count)
    for scalar in unicodeScalars {
      result += scalar.properties.uppercaseMapping
    }
    return result
  }
  @inlinable @inline(__always)
  public init<T: LosslessStringConvertible>(_ value: T) {
    self = value.description
  }
}
extension String: CustomStringConvertible {
  @inlinable
  public var description: String { return self }
}
extension String {
  public 
  var _nfcCodeUnits: [UInt8] {
    var codeUnits = [UInt8]()
    _withNFCCodeUnits {
      codeUnits.append($0)
    }
    return codeUnits
  }
  public 
  func _withNFCCodeUnits(_ f: (UInt8) throws -> Void) rethrows {
    try _gutsSlice._withNFCCodeUnits(f)
  }
}
extension _StringGutsSlice {
  internal func _isScalarNFCQC(
    _ scalar: Unicode.Scalar,
    _ prevCCC: inout UInt8
  ) -> Bool {
    let normData = Unicode._NormData(scalar, fastUpperbound: 0x300)
    if prevCCC > normData.ccc, normData.ccc != 0 {
      return false
    }
    if !normData.isNFCQC {
      return false
    }
    prevCCC = normData.ccc
    return true
  }
  internal func _withNFCCodeUnits(_ f: (UInt8) throws -> Void) rethrows {
    let substring = String(_guts)[range]
    if _fastPath(_guts.isNFC) {
      try substring.utf8.forEach(f)
      return
    }
    var isNFCQC = true
    var prevCCC: UInt8 = 0
    if _guts.isFastUTF8 {
      _fastNFCCheck(&isNFCQC, &prevCCC)
      if isNFCQC {
        try withFastUTF8 {
          for byte in $0 {
            try f(byte)
          }
        }
        return
      }
    } else {
      for scalar in substring.unicodeScalars {
        if !_isScalarNFCQC(scalar, &prevCCC) {
          isNFCQC = false
          break
        }
      }
      if isNFCQC {
        for byte in substring.utf8 {
          try f(byte)
        }
        return
      }
    }
    for scalar in substring._internalNFC {
      try scalar.withUTF8CodeUnits {
        for byte in $0 {
          try f(byte)
        }
      }
    }
  }
  internal func _fastNFCCheck(_ isNFCQC: inout Bool, _ prevCCC: inout UInt8) {
    _guts.withFastUTF8 { utf8 in
      var position = 0
      while position < utf8.count {
        if utf8[position] < 0xCC {
          if utf8[position] < 0xC0 {
            position &+= 1
          } else {
            position &+= 2
          }
          prevCCC = 0
          continue
        }
        let (scalar, len) = _decodeScalar(utf8, startingAt: position)
        if !_isScalarNFCQC(scalar, &prevCCC) {
          isNFCQC = false
          return
        }
        position &+= len
      }
    }
  }
}
