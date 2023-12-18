extension Character {
  @inlinable
  internal var _firstScalar: Unicode.Scalar {
    return self.unicodeScalars.first!
  }
  @inlinable
  internal var _isSingleScalar: Bool {
    return self.unicodeScalars.index(
      after: self.unicodeScalars.startIndex
    ) == self.unicodeScalars.endIndex
  }
  @inlinable
  public var isASCII: Bool {
    return asciiValue != nil
  }
  @inlinable
  public var asciiValue: UInt8? {
    if _slowPath(self == "\r\n") { return 0x000A  }
    if _slowPath(!_isSingleScalar || _firstScalar.value >= 0x80) { return nil }
    return UInt8(_firstScalar.value)
  }
  public var isWhitespace: Bool {
    return _firstScalar.properties.isWhitespace
  }
  @inlinable
  public var isNewline: Bool {
    switch _firstScalar.value {
      case 0x000A...0x000D : return true
      case 0x0085 : return true
      case 0x2028 : return true
      case 0x2029 : return true
      default: return false
    }
  }
  public var isNumber: Bool {
    return _firstScalar.properties.numericType != nil
  }
  @inlinable
  public var isWholeNumber: Bool {
    return wholeNumberValue != nil
  }
  public var wholeNumberValue: Int? {
    guard _isSingleScalar else { return nil }
    guard let value = _firstScalar.properties.numericValue else { return nil }
    return Int(exactly: value)
  }
  @inlinable
  public var isHexDigit: Bool {
    return hexDigitValue != nil
  }
  public var hexDigitValue: Int? {
    guard _isSingleScalar else { return nil }
    let value = _firstScalar.value
    switch value {
      case 0x0030...0x0039: return Int(value &- 0x0030)
      case 0x0041...0x0046: return Int((value &+ 10) &- 0x0041)
      case 0x0061...0x0066: return Int((value &+ 10) &- 0x0061)
      case 0xFF10...0xFF19: return Int(value &- 0xFF10)
      case 0xFF21...0xFF26: return Int((value &+ 10) &- 0xFF21)
      case 0xFF41...0xFF46: return Int((value &+ 10) &- 0xFF41)
      default: return nil
    }
  }
  public var isLetter: Bool {
    return _firstScalar.properties.isAlphabetic
  }
  public func uppercased() -> String { return String(self).uppercased() }
  public func lowercased() -> String { return String(self).lowercased() }
  @usableFromInline
  internal var _isUppercased: Bool { return String(self) == self.uppercased() }
  @usableFromInline
  internal var _isLowercased: Bool { return String(self) == self.lowercased() }
  @inlinable
  public var isUppercase: Bool {
    if _fastPath(_isSingleScalar && _firstScalar.properties.isUppercase) {
      return true
    }
    return _isUppercased && isCased
  }
  @inlinable
  public var isLowercase: Bool {
    if _fastPath(_isSingleScalar && _firstScalar.properties.isLowercase) {
      return true
    }
    return _isLowercased && isCased
  }
  @inlinable
  public var isCased: Bool {
    if _fastPath(_isSingleScalar && _firstScalar.properties.isCased) {
      return true
    }
    return !_isUppercased || !_isLowercased
  }
  public var isSymbol: Bool {
    return _firstScalar.properties.generalCategory._isSymbol
  }
  public var isMathSymbol: Bool {
    return _firstScalar.properties.isMath
  }
  public var isCurrencySymbol: Bool {
    return _firstScalar.properties.generalCategory == .currencySymbol
  }
  public var isPunctuation: Bool {
    return _firstScalar.properties.generalCategory._isPunctuation
  }
}
