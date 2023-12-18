import SwiftShims
/*
String's Index has the following layout:
 ┌──────────┬────────────────╥────────────────┬───────╥───────┐
 │ b63:b16  │      b15:b14   ║     b13:b8     │ b7:b4 ║ b3:b0 │
 ├──────────┼────────────────╫────────────────┼───────╫───────┤
 │ position │ transc. offset ║ grapheme cache │ rsvd  ║ flags │
 └──────────┴────────────────╨────────────────┴───────╨───────┘
                             └────── resilient ───────┘
Position, transcoded offset, and flags are fully exposed in the ABI. Grapheme
cache and reserved bits are partially resilient: the fact that there are 11 bits
with a default value of `0` is ABI, but not the layout, construction, or
interpretation of those bits. All use of grapheme cache should be behind
non-inlinable function calls. Inlinable code should not set a non-zero value to
resilient bits: doing so breaks future evolution as the meaning of those bits
isn't frozen.
- position aka `encodedOffset`: A 48-bit offset into the string's code units
- transcoded offset: a 2-bit sub-scalar offset, derived from transcoding
<resilience barrier>
- grapheme cache: A 6-bit value remembering the distance to the next extended
  grapheme cluster boundary, or 0 if unknown. The value stored (if any) must be
  calculated assuming that the index addresses a boundary itself, i.e., without
  looking back at scalars preceding the index. (Substrings that don't start on a
  `Character` boundary heavily rely on this.)
- reserved: 4 unused bits available for future flags etc. The meaning of each
  bit may change between stdlib versions. These must be set to zero if
  constructing an index in inlinable code.
<resilience barrier>
  * b0: `_isScalarAligned`
    If set, index is known to be on a Unicode scalar boundary (see below).
    (Introduced in Swift 5.1)
  * b1: `_isCharacterAligned`
    If set, the index is known to be on an extended grapheme cluster
    boundary (i.e., on a Swift `Character`.)
    (Introduced in Swift 5.7)
  * b2: UTF-8 encoding
    If set, the position is known to be expressed in UTF-8 code units.
    (Introduced in Swift 5.7)
  * b3: UTF-16 encoding
    If set, the position is known to be expressed in UTF-16 code units.
    (Introduced in Swift 5.7)
Before Swift 5.7, bits b1, b2 and b3 used to be part of the resilient slice. See
the notes on Character Alignment and Index Encoding below to see how this works.
*/
extension String {
  @frozen
  public struct Index: Sendable {
    @usableFromInline
    internal var _rawBits: UInt64
    @inlinable @inline(__always)
    init(_ raw: UInt64) {
      self._rawBits = raw
      self._invariantCheck()
    }
  }
}
extension String.Index {
  @inlinable @inline(__always)
  internal var orderingValue: UInt64 { return _rawBits &>> 14 }
  @inlinable @inline(__always)
  internal var isZeroPosition: Bool { return orderingValue == 0 }
  public func utf16Offset<S: StringProtocol>(in s: S) -> Int {
    return s.utf16.distance(from: s.utf16.startIndex, to: self)
  }
  @available(swift, deprecated: 4.2, message: """
    encodedOffset has been deprecated as most common usage is incorrect. \
    Use utf16Offset(in:) to achieve the same behavior.
    """)
  @inlinable
  public var encodedOffset: Int { return _encodedOffset }
  @inlinable @inline(__always)
  internal var _encodedOffset: Int {
    return Int(truncatingIfNeeded: _rawBits &>> 16)
  }
  @inlinable @inline(__always)
  internal var transcodedOffset: Int {
    return Int(truncatingIfNeeded: orderingValue & 0x3)
  }
  @usableFromInline
  internal var characterStride: Int? {
    let value = (_rawBits & 0x3F00) &>> 8
    return value > 0 ? Int(truncatingIfNeeded: value) : nil
  }
  @inlinable @inline(__always)
  internal init(encodedOffset: Int, transcodedOffset: Int) {
    let pos = UInt64(truncatingIfNeeded: encodedOffset)
    let trans = UInt64(truncatingIfNeeded: transcodedOffset)
    _internalInvariant(pos == pos & 0x0000_FFFF_FFFF_FFFF)
    _internalInvariant(trans <= 3)
    self.init((pos &<< 16) | (trans &<< 14))
  }
  public init<S: StringProtocol>(utf16Offset offset: Int, in s: S) {
    let (start, end) = (s.utf16.startIndex, s.utf16.endIndex)
    guard offset >= 0,
          let idx = s.utf16.index(start, offsetBy: offset, limitedBy: end)
    else {
      self = end.nextEncoded
      return
    }
    self = idx
  }
  @available(swift, deprecated: 4.2, message: """
    encodedOffset has been deprecated as most common usage is incorrect. \
    Use String.Index(utf16Offset:in:) to achieve the same behavior.
    """)
  @inlinable
  public init(encodedOffset offset: Int) {
    self.init(_encodedOffset: offset)
  }
  @inlinable @inline(__always)
  internal init(_encodedOffset offset: Int) {
    self.init(encodedOffset: offset, transcodedOffset: 0)
  }
  @usableFromInline
  internal init(
    encodedOffset: Int, transcodedOffset: Int, characterStride: Int
  ) {
    self.init(encodedOffset: encodedOffset, transcodedOffset: transcodedOffset)
    if _slowPath(characterStride > 0x3F) { return }
    self._rawBits |= UInt64(truncatingIfNeeded: characterStride &<< 8)
    self._invariantCheck()
  }
  @usableFromInline
  internal init(encodedOffset pos: Int, characterStride char: Int) {
    self.init(encodedOffset: pos, transcodedOffset: 0, characterStride: char)
  }
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    _internalInvariant(_encodedOffset >= 0)
    if self._isCharacterAligned {
      _internalInvariant(_isScalarAligned)
    }
    if self._isScalarAligned {
      _internalInvariant_5_1(transcodedOffset == 0)
    }
  }
  #endif 
}
extension String.Index {
  @inlinable @inline(__always)
  internal var strippingTranscoding: String.Index {
    return String.Index(_encodedOffset: self._encodedOffset)
  }
  @inlinable @inline(__always)
  internal var nextEncoded: String.Index {
    _internalInvariant(self.transcodedOffset == 0)
    return String.Index(_encodedOffset: self._encodedOffset &+ 1)
  }
  @inlinable @inline(__always)
  internal var priorEncoded: String.Index {
    _internalInvariant(self.transcodedOffset == 0)
    return String.Index(_encodedOffset: self._encodedOffset &- 1)
  }
  @inlinable @inline(__always)
  internal var nextTranscoded: String.Index {
    return String.Index(
      encodedOffset: self._encodedOffset,
      transcodedOffset: self.transcodedOffset &+ 1)
  }
  @inlinable @inline(__always)
  internal var priorTranscoded: String.Index {
    return String.Index(
      encodedOffset: self._encodedOffset,
      transcodedOffset: self.transcodedOffset &- 1)
  }
  @inlinable @inline(__always)
  internal func encoded(offsetBy n: Int) -> String.Index {
    return String.Index(_encodedOffset: self._encodedOffset &+ n)
  }
  @inlinable @inline(__always)
  internal func transcoded(withOffset n: Int) -> String.Index {
    _internalInvariant(self.transcodedOffset == 0)
    return String.Index(encodedOffset: self._encodedOffset, transcodedOffset: n)
  }
}
extension String.Index {
  internal static var __scalarAlignmentBit: UInt64 { 0x1 }
  internal static var __characterAlignmentBit: UInt64 { 0x2 }
  internal static var __utf8Bit: UInt64 { 0x4 }
  internal static var __utf16Bit: UInt64 { 0x8 }
  internal static func __encodingBit(utf16: Bool) -> UInt64 {
    let utf16 = Int8(Builtin.zext_Int1_Int8(utf16._value))
    return __utf8Bit &<< utf16
  }
}
/*
  Index Scalar Alignment
  SE-0180 unifies the Index type of String and all its views and allows
  non-scalar-aligned indices to be used across views. In order to guarantee
  behavior, we often have to check and perform scalar alignment. To speed up
  these checks, we allocate a bit denoting known-to-be-scalar-aligned, so that
  the alignment check can skip the load. The below shows what views need to
  check for alignment before they can operate, and whether the indices they
  produce are aligned.
  ┌───────────────╥───────────────────────────┬─────────────────────────┐
  │ View          ║ Requires Scalar Alignment │ Produces Scalar Aligned │
  ╞═══════════════╬═══════════════════════════╪═════════════════════════╡
  │ Native UTF8   ║ no                        │ no                      │
  ├───────────────╫───────────────────────────┼─────────────────────────┤
  │ Native UTF16  ║ yes                       │ no                      │
  ╞═══════════════╬═══════════════════════════╪═════════════════════════╡
  │ Foreign UTF8  ║ yes                       │ no                      │
  ├───────────────╫───────────────────────────┼─────────────────────────┤
  │ Foreign UTF16 ║ no                        │ no                      │
  ╞═══════════════╬═══════════════════════════╪═════════════════════════╡
  │ UnicodeScalar ║ yes                       │ yes                     │
  ├───────────────╫───────────────────────────┼─────────────────────────┤
  │ Character     ║ yes                       │ yes                     │
  └───────────────╨───────────────────────────┴─────────────────────────┘
  The "requires scalar alignment" applies to any operation taking a String.Index
  that's not defined entirely in terms of other operations taking a
  String.Index. These include:
  * index(after:)
  * index(before:)
  * subscript
  * distance(from:to:) (since `to` is compared against directly)
  * UTF16View._nativeGetOffset(for:)
*/
extension String.Index {
  @inline(__always)
  internal var _isScalarAligned: Bool {
    0 != _rawBits & Self.__scalarAlignmentBit
  }
  @inline(__always)
  internal var _scalarAligned: String.Index {
    var idx = self
    idx._rawBits |= Self.__scalarAlignmentBit
    idx._invariantCheck()
    return idx
  }
}
extension String.Index {
  @inline(__always)
  internal var _isCharacterAligned: Bool {
    0 != _rawBits & Self.__characterAlignmentBit
  }
  @inline(__always)
  internal var _characterAligned: String.Index {
    let r = _rawBits | Self.__characterAlignmentBit | Self.__scalarAlignmentBit
    let idx = Self(r)
    idx._invariantCheck()
    return idx
  }
}
extension String.Index {
  internal func _copyingAlignment(from index: Self) -> Self {
    let mask = Self.__scalarAlignmentBit | Self.__characterAlignmentBit
    return Self((_rawBits & ~mask) | (index._rawBits & mask))
  }
}
extension String.Index {
  @inline(__always)
  internal var _encodingBits: UInt64 {
    _rawBits & (Self.__utf8Bit | Self.__utf16Bit)
  }
  @inline(__always)
  internal var _canBeUTF8: Bool {
    _encodingBits != Self.__utf16Bit
  }
  @inline(__always)
  internal var _canBeUTF16: Bool {
    _encodingBits != Self.__utf8Bit
  }
  @inline(__always)
  internal func _hasMatchingEncoding(isUTF8 utf8: Bool) -> Bool {
    _encodingBits != Self.__encodingBit(utf16: utf8)
  }
  @inline(__always)
  internal var _knownUTF8: Self { Self(_rawBits | Self.__utf8Bit) }
  @inline(__always)
  internal var _knownUTF16: Self { Self(_rawBits | Self.__utf16Bit) }
  @inline(__always)
  internal var _encodingIndependent: Self {
    Self(_rawBits | Self.__utf8Bit | Self.__utf16Bit)
  }
  internal func _copyingEncoding(from index: Self) -> Self {
    let mask = Self.__utf8Bit | Self.__utf16Bit
    return Self((_rawBits & ~mask) | (index._rawBits & mask))
  }
}
extension String.Index: Equatable {
  @inlinable @inline(__always)
  public static func == (lhs: String.Index, rhs: String.Index) -> Bool {
    return lhs.orderingValue == rhs.orderingValue
  }
}
extension String.Index: Comparable {
  @inlinable @inline(__always)
  public static func < (lhs: String.Index, rhs: String.Index) -> Bool {
    return lhs.orderingValue < rhs.orderingValue
  }
}
extension String.Index: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(orderingValue)
  }
}
extension String.Index {
  internal var _encodingDescription: String {
    switch (_rawBits & Self.__utf8Bit != 0, _rawBits & Self.__utf16Bit != 0) {
    case (false, false): return "unknown"
    case (true, false): return "utf8"
    case (false, true): return "utf16"
    case (true, true): return "any"
    }
  }
  @inline(never)
  public var _description: String {
    var d = "\(_encodedOffset)[\(_encodingDescription)]"
    if transcodedOffset != 0 {
      d += "+\(transcodedOffset)"
    }
    return d
  }
  @inline(never)
  public var _debugDescription: String {
    var d = "String.Index("
    d += "offset: \(_encodedOffset)[\(_encodingDescription)]"
    if transcodedOffset != 0 {
      d += "+\(transcodedOffset)"
    }
    if _isCharacterAligned {
      d += ", aligned: character"
    } else if _isScalarAligned {
      d += ", aligned: scalar"
    }
    if let stride = characterStride {
      d += ", stride: \(stride)"
    }
    d += ")"
    return d
  }
}
