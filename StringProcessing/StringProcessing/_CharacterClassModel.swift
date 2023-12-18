struct _CharacterClassModel: Hashable {
  let cc: Representation
  let matchLevel: MatchingOptions.SemanticLevel
  let isStrictASCII: Bool
  let isInverted: Bool
  init(
    cc: Representation,
    options: MatchingOptions,
    isInverted: Bool
  ) {
    self.cc = cc
    self.matchLevel = options.semanticLevel
    self.isStrictASCII = cc.isStrictAscii(options: options)
    self.isInverted = isInverted
  }
  enum Representation: UInt64, Hashable {
    case any = 0
    case anyGrapheme
    case digit
    case horizontalWhitespace
    case newlineSequence
    case verticalWhitespace
    case whitespace
    case word
  }
  func matches(
    in input: String,
    at currentPosition: String.Index,
    limitedBy end: String.Index
  ) -> String.Index? {
    guard currentPosition < end else {
      return nil
    }
    let isScalarSemantics = matchLevel == .unicodeScalar
    return input.matchBuiltinCC(
      cc,
      at: currentPosition,
      limitedBy: end,
      isInverted: isInverted,
      isStrictASCII: isStrictASCII,
      isScalarSemantics: isScalarSemantics)
  }
}
extension _CharacterClassModel.Representation {
  func isStrictAscii(options: MatchingOptions) -> Bool {
    switch self {
    case .digit: return options.usesASCIIDigits
    case .horizontalWhitespace: return options.usesASCIISpaces
    case .newlineSequence: return options.usesASCIISpaces
    case .verticalWhitespace: return options.usesASCIISpaces
    case .whitespace: return options.usesASCIISpaces
    case .word: return options.usesASCIIWord
    default: return false
    }
  }
}
extension _CharacterClassModel.Representation: CustomStringConvertible {
  var description: String {
    switch self {
    case .any: return "<any>"
    case .anyGrapheme: return "<any grapheme>"
    case .digit: return "<digit>"
    case .horizontalWhitespace: return "<horizontal whitespace>"
    case .newlineSequence: return "<newline sequence>"
    case .verticalWhitespace: return "vertical whitespace"
    case .whitespace: return "<whitespace>"
    case .word: return "<word>"
    }
  }
}
extension _CharacterClassModel: CustomStringConvertible {
  var description: String {
    return "\(isInverted ? "not " : "")\(cc)"
  }
}
extension DSLTree.Atom.CharacterClass {
  func asRuntimeModel(_ options: MatchingOptions) -> _CharacterClassModel {
    let cc: _CharacterClassModel.Representation
    var inverted = false
    switch self {
    case .digit:
      cc = .digit
    case .notDigit:
      cc = .digit
      inverted = true
    case .horizontalWhitespace:
      cc = .horizontalWhitespace
    case .notHorizontalWhitespace:
      cc = .horizontalWhitespace
      inverted = true
    case .newlineSequence:
      cc = .newlineSequence
    case .notNewline:
      cc = .newlineSequence
      inverted = true
    case .whitespace:
      cc = .whitespace
    case .notWhitespace:
      cc = .whitespace
      inverted = true
    case .verticalWhitespace:
      cc = .verticalWhitespace
    case .notVerticalWhitespace:
      cc = .verticalWhitespace
      inverted = true
    case .word:
      cc = .word
    case .notWord:
      cc = .word
      inverted = true
    case .anyGrapheme:
      cc = .anyGrapheme
    case .anyUnicodeScalar:
      fatalError("Unsupported")
    }
    return _CharacterClassModel(cc: cc, options: options, isInverted: inverted)
  }
}
