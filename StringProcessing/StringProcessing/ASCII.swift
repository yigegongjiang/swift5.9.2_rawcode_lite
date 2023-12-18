extension UInt8 {
  static var _lineFeed: UInt8 { 0x0A }
  static var _carriageReturn: UInt8 { 0x0D }
  static var _lineTab: UInt8 { 0x0B }
  static var _formFeed: UInt8 { 0x0C }
  static var _space: UInt8 { 0x20 }
  static var _tab: UInt8 { 0x09 }
  static var _underscore: UInt8 { 0x5F }
}
private var _0: UInt8 { 0x30 }
private var _9: UInt8 { 0x39 }
private var _a: UInt8 { 0x61 }
private var _z: UInt8 { 0x7A }
private var _A: UInt8 { 0x41 }
private var _Z: UInt8 { 0x5A }
extension UInt8 {
  var _isASCII: Bool { self < 0x80 }
  var _asciiIsDigit: Bool {
    assert(_isASCII)
    return(_0..._9).contains(self)
  }
  var _asciiIsHorizontalWhitespace: Bool {
    assert(_isASCII)
    return self == ._space || self == ._tab
  }
  var _asciiIsVerticalWhitespace: Bool {
    assert(_isASCII)
    switch self {
    case ._lineFeed, ._carriageReturn, ._lineTab, ._formFeed:
      return true
    default:
      return false
    }
  }
  var _asciiIsWhitespace: Bool {
    assert(_isASCII)
    switch self {
    case ._space, ._tab, ._lineFeed, ._lineTab, ._formFeed, ._carriageReturn:
      return true
    default:
      return false
    }
  }
  var _asciiIsLetter: Bool {
    assert(_isASCII)
    return (_a..._z).contains(self) || (_A..._Z).contains(self)
  }
  var _asciiIsWord: Bool {
    assert(_isASCII)
    return _asciiIsDigit || _asciiIsLetter || self == ._underscore
  }
}
extension String {
  func _quickASCIICharacter(
    at idx: Index,
    limitedBy end: Index
  ) -> (first: UInt8, next: Index, crLF: Bool)? {
    assert(String.Index(idx, within: unicodeScalars) != nil)
    assert(idx <= end)
    if idx == end {
      return nil
    }
    let base = utf8[idx]
    guard base._isASCII else {
      assert(!self[idx].isASCII)
      return nil
    }
    var next = utf8.index(after: idx)
    if next == end {
      return (first: base, next: next, crLF: false)
    }
    let tail = utf8[next]
    guard tail._isSub300StartingByte else { return nil }
    if base == ._carriageReturn && tail == ._lineFeed {
      utf8.formIndex(after: &next)
      guard next == end || utf8[next]._isSub300StartingByte else {
        return nil
      }
      return (first: base, next: next, crLF: true)
    }
    assert(self[idx].isASCII && self[idx] != "\r\n")
    return (first: base, next: next, crLF: false)
  }
  func _quickMatch(
    _ cc: _CharacterClassModel.Representation,
    at idx: Index,
    limitedBy end: Index,
    isScalarSemantics: Bool
  ) -> (next: Index, matchResult: Bool)? {
    guard let (asciiValue, next, isCRLF) = _quickASCIICharacter(
      at: idx, limitedBy: end
    ) else {
      return nil
    }
    switch cc {
    case .any, .anyGrapheme:
      return (next, true)
    case .digit:
      return (next, asciiValue._asciiIsDigit)
    case .horizontalWhitespace:
      return (next, asciiValue._asciiIsHorizontalWhitespace)
    case .verticalWhitespace, .newlineSequence:
      if asciiValue._asciiIsVerticalWhitespace {
        if isScalarSemantics && isCRLF && cc == .verticalWhitespace {
          return (utf8.index(before: next), true)
        }
        return (next, true)
      }
      return (next, false)
    case .whitespace:
      if asciiValue._asciiIsWhitespace {
        if isScalarSemantics && isCRLF {
          return (utf8.index(before: next), true)
        }
        return (next, true)
      }
      return (next, false)
    case .word:
      return (next, asciiValue._asciiIsWord)
    }
  }
}
