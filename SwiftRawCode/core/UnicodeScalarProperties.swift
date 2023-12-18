import SwiftShims
extension Unicode.Scalar {
  public struct Properties: Sendable {
    @usableFromInline
    internal var _scalar: Unicode.Scalar
    internal init(_ scalar: Unicode.Scalar) {
      self._scalar = scalar
    }
  }
  public var properties: Properties {
    return Properties(self)
  }
}
extension Unicode.Scalar.Properties {
  fileprivate struct _BinaryProperties: OptionSet {
    let rawValue: UInt64
    private init(_ rawValue: UInt64) {
      self.rawValue = rawValue
    }
    init(rawValue: UInt64) {
      self.rawValue = rawValue
    }
    static var changesWhenCaseFolded       : Self { Self(1 &<<  0) }
    static var changesWhenCaseMapped       : Self { Self(1 &<<  1) }
    static var changesWhenLowercased       : Self { Self(1 &<<  2) }
    static var changesWhenNFKCCaseFolded   : Self { Self(1 &<<  3) }
    static var changesWhenTitlecased       : Self { Self(1 &<<  4) }
    static var changesWhenUppercased       : Self { Self(1 &<<  5) }
    static var isASCIIHexDigit             : Self { Self(1 &<<  6) }
    static var isAlphabetic                : Self { Self(1 &<<  7) }
    static var isBidiControl               : Self { Self(1 &<<  8) }
    static var isBidiMirrored              : Self { Self(1 &<<  9) }
    static var isCaseIgnorable             : Self { Self(1 &<< 10) }
    static var isCased                     : Self { Self(1 &<< 11) }
    static var isDash                      : Self { Self(1 &<< 12) }
    static var isDefaultIgnorableCodePoint : Self { Self(1 &<< 13) }
    static var isDeprecated                : Self { Self(1 &<< 14) }
    static var isDiacritic                 : Self { Self(1 &<< 15) }
    static var isEmoji                     : Self { Self(1 &<< 16) }
    static var isEmojiModifier             : Self { Self(1 &<< 17) }
    static var isEmojiModifierBase         : Self { Self(1 &<< 18) }
    static var isEmojiPresentation         : Self { Self(1 &<< 19) }
    static var isExtender                  : Self { Self(1 &<< 20) }
    static var isFullCompositionExclusion  : Self { Self(1 &<< 21) }
    static var isGraphemeBase              : Self { Self(1 &<< 22) }
    static var isGraphemeExtend            : Self { Self(1 &<< 23) }
    static var isHexDigit                  : Self { Self(1 &<< 24) }
    static var isIDContinue                : Self { Self(1 &<< 25) }
    static var isIDSBinaryOperator         : Self { Self(1 &<< 26) }
    static var isIDSTrinaryOperator        : Self { Self(1 &<< 27) }
    static var isIDStart                   : Self { Self(1 &<< 28) }
    static var isIdeographic               : Self { Self(1 &<< 29) }
    static var isJoinControl               : Self { Self(1 &<< 30) }
    static var isLogicalOrderException     : Self { Self(1 &<< 31) }
    static var isLowercase                 : Self { Self(1 &<< 32) }
    static var isMath                      : Self { Self(1 &<< 33) }
    static var isNoncharacterCodePoint     : Self { Self(1 &<< 34) }
    static var isPatternSyntax             : Self { Self(1 &<< 35) }
    static var isPatternWhitespace         : Self { Self(1 &<< 36) }
    static var isQuotationMark             : Self { Self(1 &<< 37) }
    static var isRadical                   : Self { Self(1 &<< 38) }
    static var isSentenceTerminal          : Self { Self(1 &<< 39) }
    static var isSoftDotted                : Self { Self(1 &<< 40) }
    static var isTerminalPunctuation       : Self { Self(1 &<< 41) }
    static var isUnifiedIdeograph          : Self { Self(1 &<< 42) }
    static var isUppercase                 : Self { Self(1 &<< 43) }
    static var isVariationSelector         : Self { Self(1 &<< 44) }
    static var isWhitespace                : Self { Self(1 &<< 45) }
    static var isXIDContinue               : Self { Self(1 &<< 46) }
    static var isXIDStart                  : Self { Self(1 &<< 47) }
  }
}
extension Unicode.Scalar.Properties {
  fileprivate var _binaryProperties: _BinaryProperties {
    _BinaryProperties(
      rawValue: _swift_stdlib_getBinaryProperties(_scalar.value)
    )
  }
  public var isAlphabetic: Bool {
    _binaryProperties.contains(.isAlphabetic)
  }
  public var isASCIIHexDigit: Bool {
    _binaryProperties.contains(.isASCIIHexDigit)
  }
  public var isBidiControl: Bool {
    _binaryProperties.contains(.isBidiControl)
  }
  public var isBidiMirrored: Bool {
    _binaryProperties.contains(.isBidiMirrored)
  }
  public var isDash: Bool {
    _binaryProperties.contains(.isDash)
  }
  public var isDefaultIgnorableCodePoint: Bool {
    _binaryProperties.contains(.isDefaultIgnorableCodePoint)
  }
  public var isDeprecated: Bool {
    _binaryProperties.contains(.isDeprecated)
  }
  public var isDiacritic: Bool {
    _binaryProperties.contains(.isDiacritic)
  }
  public var isExtender: Bool {
    _binaryProperties.contains(.isExtender)
  }
  public var isFullCompositionExclusion: Bool {
    _binaryProperties.contains(.isFullCompositionExclusion)
  }
  public var isGraphemeBase: Bool {
    _binaryProperties.contains(.isGraphemeBase)
  }
  public var isGraphemeExtend: Bool {
    _binaryProperties.contains(.isGraphemeExtend)
  }
  public var isHexDigit: Bool {
    _binaryProperties.contains(.isHexDigit)
  }
  public var isIDContinue: Bool {
    _binaryProperties.contains(.isIDContinue)
  }
  public var isIDStart: Bool {
    _binaryProperties.contains(.isIDStart)
  }
  public var isIdeographic: Bool {
    _binaryProperties.contains(.isIdeographic)
  }
  public var isIDSBinaryOperator: Bool {
    _binaryProperties.contains(.isIDSBinaryOperator)
  }
  public var isIDSTrinaryOperator: Bool {
    _binaryProperties.contains(.isIDSTrinaryOperator)
  }
  public var isJoinControl: Bool {
    _binaryProperties.contains(.isJoinControl)
  }
  public var isLogicalOrderException: Bool {
    _binaryProperties.contains(.isLogicalOrderException)
  }
  public var isLowercase: Bool {
    _binaryProperties.contains(.isLowercase)
  }
  public var isMath: Bool {
    _binaryProperties.contains(.isMath)
  }
  public var isNoncharacterCodePoint: Bool {
    _binaryProperties.contains(.isNoncharacterCodePoint)
  }
  public var isQuotationMark: Bool {
    _binaryProperties.contains(.isQuotationMark)
  }
  public var isRadical: Bool {
    _binaryProperties.contains(.isRadical)
  }
  public var isSoftDotted: Bool {
    _binaryProperties.contains(.isSoftDotted)
  }
  public var isTerminalPunctuation: Bool {
    _binaryProperties.contains(.isTerminalPunctuation)
  }
  public var isUnifiedIdeograph: Bool {
    _binaryProperties.contains(.isUnifiedIdeograph)
  }
  public var isUppercase: Bool {
    _binaryProperties.contains(.isUppercase)
  }
  public var isWhitespace: Bool {
    _binaryProperties.contains(.isWhitespace)
  }
  public var isXIDContinue: Bool {
    _binaryProperties.contains(.isXIDContinue)
  }
  public var isXIDStart: Bool {
    _binaryProperties.contains(.isXIDStart)
  }
  public var isSentenceTerminal: Bool {
    _binaryProperties.contains(.isSentenceTerminal)
  }
  public var isVariationSelector: Bool {
    _binaryProperties.contains(.isVariationSelector)
  }
  public var isPatternSyntax: Bool {
    _binaryProperties.contains(.isPatternSyntax)
  }
  public var isPatternWhitespace: Bool {
    _binaryProperties.contains(.isPatternWhitespace)
  }
  public var isCased: Bool {
    _binaryProperties.contains(.isCased)
  }
  public var isCaseIgnorable: Bool {
    _binaryProperties.contains(.isCaseIgnorable)
  }
  public var changesWhenLowercased: Bool {
    _binaryProperties.contains(.changesWhenLowercased)
  }
  public var changesWhenUppercased: Bool {
    _binaryProperties.contains(.changesWhenUppercased)
  }
  public var changesWhenTitlecased: Bool {
    _binaryProperties.contains(.changesWhenTitlecased)
  }
  public var changesWhenCaseFolded: Bool {
    _binaryProperties.contains(.changesWhenCaseFolded)
  }
  public var changesWhenCaseMapped: Bool {
    _binaryProperties.contains(.changesWhenCaseMapped)
  }
  public var changesWhenNFKCCaseFolded: Bool {
    _binaryProperties.contains(.changesWhenNFKCCaseFolded)
  }
  @available(macOS 10.12.2, iOS 10.2, tvOS 10.1, watchOS 3.1.1, *)
  public var isEmoji: Bool {
    _binaryProperties.contains(.isEmoji)
  }
  @available(macOS 10.12.2, iOS 10.2, tvOS 10.1, watchOS 3.1.1, *)
  public var isEmojiPresentation: Bool {
    _binaryProperties.contains(.isEmojiPresentation)
  }
  @available(macOS 10.12.2, iOS 10.2, tvOS 10.1, watchOS 3.1.1, *)
  public var isEmojiModifier: Bool {
    _binaryProperties.contains(.isEmojiModifier)
  }
  @available(macOS 10.12.2, iOS 10.2, tvOS 10.1, watchOS 3.1.1, *)
  public var isEmojiModifierBase: Bool {
    _binaryProperties.contains(.isEmojiModifierBase)
  }
}
extension Unicode.Scalar.Properties {
  fileprivate struct _CaseMapping {
    let rawValue: UInt8
    static let uppercase = _CaseMapping(rawValue: 0)
    static let lowercase = _CaseMapping(rawValue: 1)
    static let titlecase = _CaseMapping(rawValue: 2)
  }
  fileprivate func _getMapping(_ mapping: _CaseMapping) -> String {
    var specialMappingLength = 0
    let specialMappingPtr = _swift_stdlib_getSpecialMapping(
      _scalar.value,
      mapping.rawValue,
      &specialMappingLength
    )
    if let specialMapping = specialMappingPtr, specialMappingLength != 0 {
      let buffer = UnsafeBufferPointer<UInt8>(
        start: specialMapping,
        count: specialMappingLength
      )
      return String._uncheckedFromUTF8(buffer, isASCII: false)
    }
    let mappingDistance = _swift_stdlib_getMapping(
      _scalar.value,
      mapping.rawValue
    )
    if mappingDistance != 0 {
      let scalar = Unicode.Scalar(
        _unchecked: UInt32(Int(_scalar.value) &+ Int(mappingDistance))
      )
      return String(scalar)
    }
    return String(_scalar)
  }
  public var lowercaseMapping: String {
    _getMapping(.lowercase)
  }
  public var titlecaseMapping: String {
    _getMapping(.titlecase)
  }
  public var uppercaseMapping: String {
    _getMapping(.uppercase)
  }
}
extension Unicode {
  public typealias Version = (major: Int, minor: Int)
}
extension Unicode.Scalar.Properties {
  public var age: Unicode.Version? {
    let age: UInt16 = _swift_stdlib_getAge(_scalar.value)
    if age == .max {
      return nil
    }
    let major = age & 0xFF
    let minor = (age & 0xFF00) >> 8
    return (major: Int(major), minor: Int(minor))
  }
}
extension Unicode {
  public enum GeneralCategory: Sendable {
    case uppercaseLetter
    case lowercaseLetter
    case titlecaseLetter
    case modifierLetter
    case otherLetter
    case nonspacingMark
    case spacingMark
    case enclosingMark
    case decimalNumber
    case letterNumber
    case otherNumber
    case connectorPunctuation
    case dashPunctuation
    case openPunctuation
    case closePunctuation
    case initialPunctuation
    case finalPunctuation
    case otherPunctuation
    case mathSymbol
    case currencySymbol
    case modifierSymbol
    case otherSymbol
    case spaceSeparator
    case lineSeparator
    case paragraphSeparator
    case control
    case format
    case surrogate
    case privateUse
    case unassigned
    internal init(rawValue: UInt8) {
      switch rawValue {
      case 0: self = .uppercaseLetter
      case 1: self = .lowercaseLetter
      case 2: self = .titlecaseLetter
      case 3: self = .modifierLetter
      case 4: self = .otherLetter
      case 5: self = .nonspacingMark
      case 6: self = .spacingMark
      case 7: self = .enclosingMark
      case 8: self = .decimalNumber
      case 9: self = .letterNumber
      case 10: self = .otherNumber
      case 11: self = .connectorPunctuation
      case 12: self = .dashPunctuation
      case 13: self = .openPunctuation
      case 14: self = .closePunctuation
      case 15: self = .initialPunctuation
      case 16: self = .finalPunctuation
      case 17: self = .otherPunctuation
      case 18: self = .mathSymbol
      case 19: self = .currencySymbol
      case 20: self = .modifierSymbol
      case 21: self = .otherSymbol
      case 22: self = .spaceSeparator
      case 23: self = .lineSeparator
      case 24: self = .paragraphSeparator
      case 25: self = .control
      case 26: self = .format
      case 27: self = .surrogate
      case 28: self = .privateUse
      case 29: self = .unassigned
      default: fatalError("Unknown general category \(rawValue)")
      }
    }
  }
}
extension Unicode.GeneralCategory {
  internal var _isSymbol: Bool {
    switch self {
      case .mathSymbol, .currencySymbol, .modifierSymbol, .otherSymbol:
        return true
      default: return false
    }
  }
  internal var _isPunctuation: Bool {
    switch self {
      case .connectorPunctuation, .dashPunctuation, .openPunctuation,
           .closePunctuation, .initialPunctuation, .finalPunctuation,
           .otherPunctuation:
        return true
      default: return false
    }
  }
}
extension Unicode.Scalar.Properties {
  public var generalCategory: Unicode.GeneralCategory {
    let rawValue = _swift_stdlib_getGeneralCategory(_scalar.value)
    return Unicode.GeneralCategory(rawValue: rawValue)
  }
}
extension Unicode.Scalar.Properties {
  internal func _hangulName() -> String {
    let T: (base: UInt32, count: UInt32) = (base: 0x11A7, count: 28)
    let N: (base: UInt32, count: UInt32) = (base: 0x0, count: 588)
    let S: (base: UInt32, count: UInt32) = (base: 0xAC00, count: 11172)
    let hangulLTable = ["G", "GG", "N", "D", "DD", "R", "M", "B", "BB", "S",
                        "SS", "", "J", "JJ", "C", "K", "T", "P", "H"]
    let hangulVTable = ["A", "AE", "YA", "YAE", "EO", "E", "YEO", "YE", "O",
                        "WA", "WAE", "OE", "YO", "U", "WEO", "WE", "WI", "YU",
                        "EU", "YI", "I"]
    let hangulTTable = ["", "G", "GG", "GS", "N", "NJ", "NH", "D", "L", "LG",
                        "LM", "LB", "LS", "LT", "LP", "LH", "M", "B", "BS", "S",
                        "SS", "NG", "J", "C", "K", "T", "P", "H"]
    let sIdx = _scalar.value &- S.base
    let lIdx = Int(sIdx / N.count)
    let vIdx = Int((sIdx % N.count) / T.count)
    let tIdx = Int(sIdx % T.count)
    let scalarName = hangulLTable[lIdx] + hangulVTable[vIdx] + hangulTTable[tIdx]
    return "HANGUL SYLLABLE \(scalarName)"
  }
  internal func _fastScalarName() -> String? {
    let scalarName = String(_scalar.value, radix: 16, uppercase: true)
    switch _scalar.value {
    case (0xAC00 ... 0xD7A3):
      return _hangulName()
    case (0xE0100 ... 0xE01EF):
      return "VARIATION SELECTOR-\(_scalar.value - 0xE0100 + 17)"
    case (0x3400 ... 0x4DBF),
         (0x4E00 ... 0x9FFF),
         (0x20000 ... 0x2A6DF),
         (0x2A700 ... 0x2B739),
         (0x2B740 ... 0x2B81D),
         (0x2B820 ... 0x2CEA1),
         (0x2CEB0 ... 0x2EBE0),
         (0x30000 ... 0x3134A),
         (0x31350 ... 0x323AF):
      return "CJK UNIFIED IDEOGRAPH-\(scalarName)"
    case (0xF900 ... 0xFA6D),
         (0xFA70 ... 0xFAD9),
         (0x2F800 ... 0x2FA1D):
      return "CJK COMPATIBILITY IDEOGRAPH-\(scalarName)"
    case (0x17000 ... 0x187F7),
         (0x18D00 ... 0x18D08):
      return "TANGUT IDEOGRAPH-\(scalarName)"
    case (0x18B00 ... 0x18CD5):
      return "KHITAN SMALL SCRIPT CHARACTER-\(scalarName)"
    case (0x1B170 ... 0x1B2FB):
      return "NUSHU CHARACTER-\(scalarName)"
    default:
      return nil
    }
  }
  public var name: String? {
    if let fastName = _fastScalarName() {
      return fastName
    }
    let largestCount = Int(SWIFT_STDLIB_LARGEST_NAME_COUNT)
    let name = String(_uninitializedCapacity: largestCount) { buffer in
      _swift_stdlib_getScalarName(
        _scalar.value,
        buffer.baseAddress,
        buffer.count
      )
    }
    return name.isEmpty ? nil : name
  }
  public var nameAlias: String? {
    guard let nameAliasPtr = _swift_stdlib_getNameAlias(_scalar.value) else {
      return nil
    }
    return String(cString: nameAliasPtr)
  }
}
extension Unicode {
  public struct CanonicalCombiningClass:
    Comparable, Hashable, RawRepresentable, Sendable
  {
    public static let notReordered = CanonicalCombiningClass(rawValue: 0)
    public static let overlay = CanonicalCombiningClass(rawValue: 1)
    public static let nukta = CanonicalCombiningClass(rawValue: 7)
    public static let kanaVoicing = CanonicalCombiningClass(rawValue: 8)
    public static let virama = CanonicalCombiningClass(rawValue: 9)
    public static let attachedBelowLeft = CanonicalCombiningClass(rawValue: 200)
    public static let attachedBelow = CanonicalCombiningClass(rawValue: 202)
    public static let attachedAbove = CanonicalCombiningClass(rawValue: 214)
    public static let attachedAboveRight =
      CanonicalCombiningClass(rawValue: 216)
    public static let belowLeft = CanonicalCombiningClass(rawValue: 218)
    public static let below = CanonicalCombiningClass(rawValue: 220)
    public static let belowRight = CanonicalCombiningClass(rawValue: 222)
    public static let left = CanonicalCombiningClass(rawValue: 224)
    public static let right = CanonicalCombiningClass(rawValue: 226)
    public static let aboveLeft = CanonicalCombiningClass(rawValue: 228)
    public static let above = CanonicalCombiningClass(rawValue: 230)
    public static let aboveRight = CanonicalCombiningClass(rawValue: 232)
    public static let doubleBelow = CanonicalCombiningClass(rawValue: 233)
    public static let doubleAbove = CanonicalCombiningClass(rawValue: 234)
    public static let iotaSubscript = CanonicalCombiningClass(rawValue: 240)
    public let rawValue: UInt8
    public init(rawValue: UInt8) {
      self.rawValue = rawValue
    }
    public static func == (
      lhs: CanonicalCombiningClass,
      rhs: CanonicalCombiningClass
    ) -> Bool {
      return lhs.rawValue == rhs.rawValue
    }
    public static func < (
      lhs: CanonicalCombiningClass,
      rhs: CanonicalCombiningClass
    ) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
    public var hashValue: Int {
      return rawValue.hashValue
    }
    public func hash(into hasher: inout Hasher) {
      hasher.combine(rawValue)
    }
  }
}
extension Unicode.Scalar.Properties {
  public var canonicalCombiningClass: Unicode.CanonicalCombiningClass {
    let normData = Unicode._NormData(_scalar)
    return Unicode.CanonicalCombiningClass(rawValue: normData.ccc)
  }
}
extension Unicode {
  public enum NumericType: Sendable {
    case decimal
    case digit
    case numeric
    internal init(rawValue: UInt8) {
      switch rawValue {
      case 0:
        self = .numeric
      case 1:
        self = .digit
      case 2:
        self = .decimal
      default:
        fatalError("Unknown numeric type \(rawValue)")
      }
    }
  }
}
extension Unicode.Scalar.Properties {
  public var numericType: Unicode.NumericType? {
    let rawValue = _swift_stdlib_getNumericType(_scalar.value)
    guard rawValue != .max else {
      return nil
    }
    return Unicode.NumericType(rawValue: rawValue)
  }
  public var numericValue: Double? {
    guard numericType != nil else {
      return nil
    }
    return _swift_stdlib_getNumericValue(_scalar.value)
  }
}
