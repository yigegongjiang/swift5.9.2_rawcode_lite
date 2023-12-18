@available(SwiftStdlib 5.7, *)
extension Regex {
  public func ignoresCase(_ ignoresCase: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.caseInsensitive, addingIf: ignoresCase)
  }
  public func asciiOnlyWordCharacters(_ useASCII: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.asciiOnlyWord, addingIf: useASCII)
  }
  public func asciiOnlyDigits(_ useASCII: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.asciiOnlyDigit, addingIf: useASCII)
  }
  public func asciiOnlyWhitespace(_ useASCII: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.asciiOnlySpace, addingIf: useASCII)
  }
  public func asciiOnlyCharacterClasses(_ useASCII: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.asciiOnlyPOSIXProps, addingIf: useASCII)
  }
  public func wordBoundaryKind(_ wordBoundaryKind: RegexWordBoundaryKind) -> Regex<RegexOutput> {
    wrapInOption(.unicodeWordBoundaries, addingIf: wordBoundaryKind == .default)
  }
  public func dotMatchesNewlines(_ dotMatchesNewlines: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.singleLine, addingIf: dotMatchesNewlines)
  }
  public func anchorsMatchLineEndings(_ matchLineEndings: Bool = true) -> Regex<RegexOutput> {
    wrapInOption(.multiline, addingIf: matchLineEndings)
  }
  public func repetitionBehavior(_ behavior: RegexRepetitionBehavior) -> Regex<RegexOutput> {
    if behavior == .possessive {
      return wrapInOption(.possessiveByDefault, addingIf: true)
    } else {
      return wrapInOption(.reluctantByDefault, addingIf: behavior == .reluctant)
    }
  }
  public func matchingSemantics(_ semanticLevel: RegexSemanticLevel) -> Regex<RegexOutput> {
    switch semanticLevel.base {
    case .graphemeCluster:
      return wrapInOption(.graphemeClusterSemantics, addingIf: true)
    case .unicodeScalar:
      return wrapInOption(.unicodeScalarSemantics, addingIf: true)
    }
  }
}
@available(SwiftStdlib 5.7, *)
public struct RegexSemanticLevel: Hashable {
  internal enum Representation {
    case graphemeCluster
    case unicodeScalar
  }
  internal var base: Representation
  public static var graphemeCluster: RegexSemanticLevel {
    .init(base: .graphemeCluster)
  }
  public static var unicodeScalar: RegexSemanticLevel {
    .init(base: .unicodeScalar)
  }
}
@available(SwiftStdlib 5.7, *)
public struct RegexWordBoundaryKind: Hashable {
  internal enum Representation {
    case unicodeLevel1
    case unicodeLevel2
  }
  internal var base: Representation
  public static var simple: Self {
    .init(base: .unicodeLevel1)
  }
  public static var `default`: Self {
    .init(base: .unicodeLevel2)
  }
}
@available(SwiftStdlib 5.7, *)
public struct RegexRepetitionBehavior: Hashable {
  internal enum Kind {
    case eager
    case reluctant
    case possessive
  }
  var kind: Kind
    switch kind {
    case .eager: return .eager
    case .reluctant: return .reluctant
    case .possessive: return .possessive
    }
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexRepetitionBehavior {
  public static var eager: Self {
    .init(kind: .eager)
  }
  public static var reluctant: Self {
    .init(kind: .reluctant)
  }
  public static var possessive: Self {
    .init(kind: .possessive)
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexComponent {
  fileprivate func wrapInOption(
    _ option: AST.MatchingOption.Kind,
    addingIf shouldAdd: Bool) -> Regex<RegexOutput>
  {
    let sequence = shouldAdd
      ? AST.MatchingOptionSequence(adding: [.init(option, location: .fake)])
      : AST.MatchingOptionSequence(removing: [.init(option, location: .fake)])
    return Regex(node: .nonCapturingGroup(
      .init(ast: .changeMatchingOptions(sequence)), regex.root))
  }
}
