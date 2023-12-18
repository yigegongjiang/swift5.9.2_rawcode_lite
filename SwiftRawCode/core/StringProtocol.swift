public protocol StringProtocol
  : BidirectionalCollection,
  TextOutputStream, TextOutputStreamable,
  LosslessStringConvertible, ExpressibleByStringInterpolation,
  Hashable, Comparable
  where Iterator.Element == Character,
        Index == String.Index,
        SubSequence: StringProtocol,
        StringInterpolation == DefaultStringInterpolation
{
  associatedtype UTF8View: Collection
  where UTF8View.Element == UInt8, 
        UTF8View.Index == Index
  associatedtype UTF16View: BidirectionalCollection
  where UTF16View.Element == UInt16, 
        UTF16View.Index == Index
  associatedtype UnicodeScalarView: BidirectionalCollection
  where UnicodeScalarView.Element == Unicode.Scalar,
        UnicodeScalarView.Index == Index
  associatedtype SubSequence = Substring
  var utf8: UTF8View { get }
  var utf16: UTF16View { get }
  var unicodeScalars: UnicodeScalarView { get }
  func hasPrefix(_ prefix: String) -> Bool
  func hasSuffix(_ suffix: String) -> Bool
  func lowercased() -> String
  func uppercased() -> String
  init<C: Collection, Encoding: Unicode.Encoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  )
    where C.Iterator.Element == Encoding.CodeUnit
  init(cString nullTerminatedUTF8: UnsafePointer<CChar>)
  init<Encoding: Unicode.Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type)
  func withCString<Result>(
    _ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result
  func withCString<Result, Encoding: Unicode.Encoding>(
    encodedAs targetEncoding: Encoding.Type,
    _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result
  ) rethrows -> Result
}
extension StringProtocol {
  public 
  var _ephemeralString: String {
    get { return String(self) }
  }
  internal var _gutsSlice: _StringGutsSlice {
    @inline(__always) get {
      if let str = self as? String {
        return _StringGutsSlice(str._guts)
      }
      if let subStr = self as? Substring {
        return _StringGutsSlice(subStr._wholeGuts, subStr._offsetRange)
      }
      return _StringGutsSlice(String(self)._guts)
    }
  }
  @inlinable
  internal var _offsetRange: Range<Int> {
    @inline(__always) get {
      let start = startIndex
      let end = endIndex
      _internalInvariant(
        start.transcodedOffset == 0 && end.transcodedOffset == 0)
      return Range(_uncheckedBounds: (start._encodedOffset, end._encodedOffset))
    }
  }
  @inlinable
  internal var _wholeGuts: _StringGuts {
    @inline(__always) get {
      if let str = self as? String {
        return str._guts
      }
      if let subStr = self as? Substring {
        return subStr._wholeGuts
      }
      return String(self)._guts
    }
  }
}
extension String {
  public var isContiguousUTF8: Bool { return _guts.isFastUTF8 }
  public mutating func makeContiguousUTF8() {
    if _fastPath(isContiguousUTF8) { return }
    self = String._copying(self)
  }
  public mutating func withUTF8<R>(
    _ body: (UnsafeBufferPointer<UInt8>) throws -> R
  ) rethrows -> R {
    makeContiguousUTF8()
    return try _guts.withFastUTF8(body)
  }
}
extension Substring {
  public var isContiguousUTF8: Bool { return self.base.isContiguousUTF8 }
  public mutating func makeContiguousUTF8() {
    if isContiguousUTF8 { return }
    return _slowMakeContiguousUTF8()
  }
  @inline(never)
  internal mutating func _slowMakeContiguousUTF8() {
    _internalInvariant(!isContiguousUTF8)
    let scalarOffset = base.unicodeScalars.distance(
      from: base.startIndex, to: startIndex)
    let scalarCount = base.unicodeScalars.distance(
      from: startIndex, to: endIndex)
    let scalars = String._copying(base).unicodeScalars
    var newStart = scalars.index(scalars.startIndex, offsetBy: scalarOffset)
    var newEnd = scalars.index(newStart, offsetBy: scalarCount)
    if startIndex._isCharacterAligned { newStart = newStart._characterAligned }
    if endIndex._isCharacterAligned { newEnd = newEnd._characterAligned }
    self = Substring(_unchecked: scalars._guts, bounds: newStart ..< newEnd)
  }
  public mutating func withUTF8<R>(
    _ body: (UnsafeBufferPointer<UInt8>) throws -> R
  ) rethrows -> R {
    makeContiguousUTF8()
    return try _wholeGuts.withFastUTF8(range: _offsetRange, body)
  }
}
