struct MatchingOptions {
  fileprivate var stack: [Representation]
  fileprivate func _invariantCheck() {
    assert(!stack.isEmpty, "Unbalanced call to endScope")
    assert(stack.last!.intersection(.textSegmentOptions).rawValue.nonzeroBitCount == 1)
    assert(stack.last!.intersection(.semanticMatchingLevels).rawValue.nonzeroBitCount == 1)
    assert(stack.last!.intersection(.repetitionBehaviors).rawValue.nonzeroBitCount <= 1)
  }
}
extension MatchingOptions {
  init() {
    self.stack = [.default]
    _invariantCheck()
  }
  mutating func beginScope() {
    stack.append(stack.last!)
    _invariantCheck()
  }
  mutating func endScope() {
    _ = stack.removeLast()
    _invariantCheck()
  }
  mutating func apply(_ sequence: AST.MatchingOptionSequence) {
    stack[stack.count - 1].apply(sequence)
    _invariantCheck()
  }
  func _equal(to other: MatchingOptions) -> Bool {
    stack.last == other.stack.last
  }
}
extension MatchingOptions {
  var isCaseInsensitive: Bool {
    stack.last!.contains(.caseInsensitive)
  }
  var isReluctantByDefault: Bool {
    stack.last!.contains(.reluctantByDefault)
  }
  var defaultQuantificationKind: AST.Quantification.Kind {
    if stack.last!.contains(.possessiveByDefault) {
      return .possessive
    } else if stack.last!.contains(.reluctantByDefault) {
      return .reluctant
    } else {
      return .eager
    }
  }
  var dotMatchesNewline: Bool {
    stack.last!.contains(.singleLine)
  }
  var anchorsMatchNewlines: Bool {
    stack.last!.contains(.multiline)
  }
  var usesASCIIWord: Bool {
    stack.last!.contains(.asciiOnlyWord)
      || stack.last!.contains(.asciiOnlyPOSIXProps)
  }
  var usesASCIIDigits: Bool {
    stack.last!.contains(.asciiOnlyDigit)
      || stack.last!.contains(.asciiOnlyPOSIXProps)
  }
  var usesASCIISpaces: Bool {
    stack.last!.contains(.asciiOnlySpace)
      || stack.last!.contains(.asciiOnlyPOSIXProps)
  }
  var usesSimpleUnicodeBoundaries: Bool {
    !stack.last!.contains(.unicodeWordBoundaries)
  }
  enum SemanticLevel {
    case graphemeCluster
    case unicodeScalar
  }
  var semanticLevel: SemanticLevel {
    stack.last!.contains(.graphemeClusterSemantics)
      ? .graphemeCluster
      : .unicodeScalar
  }
}
extension MatchingOptions {
  fileprivate enum Option: Int {
    case caseInsensitive
    case allowDuplicateGroupNames
    case multiline
    case namedCapturesOnly
    case singleLine
    case reluctantByDefault
    case unicodeWordBoundaries
    case transparentBounds
    case withoutAnchoringBounds
    case asciiOnlyDigit
    case asciiOnlyPOSIXProps
    case asciiOnlySpace
    case asciiOnlyWord
    case textSegmentGraphemeMode
    case textSegmentWordMode
    case graphemeClusterSemantics
    case unicodeScalarSemantics
    case byteSemantics
    case possessiveByDefault
    init?(_ astKind: AST.MatchingOption.Kind) {
      switch astKind {
      case .caseInsensitive:
        self = .caseInsensitive
      case .allowDuplicateGroupNames:
        self = .allowDuplicateGroupNames
      case .multiline:
        self = .multiline
      case .namedCapturesOnly:
        self = .namedCapturesOnly
      case .singleLine:
        self = .singleLine
      case .reluctantByDefault:
        self = .reluctantByDefault
      case .unicodeWordBoundaries:
        self = .unicodeWordBoundaries
      case .asciiOnlyDigit:
        self = .asciiOnlyDigit
      case .asciiOnlyPOSIXProps:
        self = .asciiOnlyPOSIXProps
      case .asciiOnlySpace:
        self = .asciiOnlySpace
      case .asciiOnlyWord:
        self = .asciiOnlyWord
      case .textSegmentGraphemeMode:
        self = .textSegmentGraphemeMode
      case .textSegmentWordMode:
        self = .textSegmentWordMode
      case .graphemeClusterSemantics:
        self = .graphemeClusterSemantics
      case .unicodeScalarSemantics:
        self = .unicodeScalarSemantics
      case .byteSemantics:
        self = .byteSemantics
      case .possessiveByDefault:
        self = .possessiveByDefault
      case .extended, .extraExtended:
        return nil
      }
    }
    fileprivate var representation: Representation {
      return .init(self)
    }
  }
}
extension MatchingOptions {
  fileprivate struct Representation: OptionSet, RawRepresentable {
    var rawValue: UInt32
    func contains(_ kind: Option) -> Bool {
      contains(.init(kind))
    }
    mutating func add(_ opt: Option) {
      if Self.semanticMatchingLevels.contains(opt.representation) {
        remove(.semanticMatchingLevels)
      }
      if Self.textSegmentOptions.contains(opt.representation) {
        remove(.textSegmentOptions)
      }
      if Self.repetitionBehaviors.contains(opt.representation) {
        remove(.repetitionBehaviors)
      }
      insert(opt.representation)
    }
    mutating func apply(_ sequence: AST.MatchingOptionSequence) {
      if sequence.caretLoc != nil {
        self = .default
      }
      for opt in sequence.adding {
        guard let opt = Option(opt.kind) else {
          continue
        }
        add(opt)
      }
      for opt in sequence.removing {
        guard let opt = Option(opt.kind) else {
          continue
        }
        if Self.repetitionBehaviors.contains(opt.representation) {
          remove(.repetitionBehaviors)
        }
        remove(opt.representation)
      }
    }
  }
}
extension MatchingOptions.Representation {
  fileprivate init(_ kind: MatchingOptions.Option) {
    self.rawValue = 1 << kind.rawValue
  }
  static var caseInsensitive: Self { .init(.caseInsensitive) }
  static var textSegmentGraphemeMode: Self { .init(.textSegmentGraphemeMode) }
  static var textSegmentWordMode: Self { .init(.textSegmentWordMode) }
  static var textSegmentOptions: Self {
    [.textSegmentGraphemeMode, .textSegmentWordMode]
  }
  static var graphemeClusterSemantics: Self { .init(.graphemeClusterSemantics) }
  static var unicodeScalarSemantics: Self { .init(.unicodeScalarSemantics) }
  static var byteSemantics: Self { .init(.byteSemantics) }
  static var semanticMatchingLevels: Self {
    [.graphemeClusterSemantics, .unicodeScalarSemantics, .byteSemantics]
  }
  static var reluctantByDefault: Self { .init(.reluctantByDefault) }
  static var possessiveByDefault: Self { .init(.possessiveByDefault) }
  static var repetitionBehaviors: Self {
    [.reluctantByDefault, .possessiveByDefault]
  }
  static var unicodeWordBoundaries: Self { .init(.unicodeWordBoundaries) }
  static var `default`: Self {
    [.graphemeClusterSemantics, .textSegmentGraphemeMode, .unicodeWordBoundaries]
  }
}
extension AST.Quantification.Kind {
  func applying(_ options: MatchingOptions) -> Self {
    if options.isReluctantByDefault && self != .possessive {
      return self == .eager ? .reluctant : .eager
    }
    return self
  }
}
