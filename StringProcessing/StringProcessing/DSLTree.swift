public struct DSLTree {
  var root: Node
  init(_ r: Node) {
    self.root = r
  }
}
extension DSLTree {
  indirect enum Node {
    case orderedChoice([Node])
    case concatenation([Node])
    case capture(
      name: String? = nil, reference: ReferenceID? = nil, Node,
      CaptureTransform? = nil)
    case nonCapturingGroup(_AST.GroupKind, Node)
    case ignoreCapturesInTypedOutput(Node)
    case conditional(
      _AST.ConditionKind, Node, Node)
    case quantification(
      _AST.QuantificationAmount,
      QuantificationKind,
      Node)
    case customCharacterClass(CustomCharacterClass)
    case atom(Atom)
    case trivia(String)
    case empty
    case quotedLiteral(String)
    case absentFunction(_AST.AbsentFunction)
    case convertedRegexLiteral(Node, _AST.ASTNode)
    case consumer(_ConsumerInterface)
    case matcher(Any.Type, _MatcherInterface)
    case characterPredicate(_CharacterPredicateInterface)
  }
}
extension DSLTree {
  enum QuantificationKind {
    case `default`
    case explicit(_AST.QuantificationKind)
    case syntax(_AST.QuantificationKind)
    var ast: AST.Quantification.Kind? {
      switch self {
      case .default: return nil
      case .explicit(let kind), .syntax(let kind):
        return kind.ast
      }
    }
  }
  public struct CustomCharacterClass {
    var members: [Member]
    var isInverted: Bool
    var containsDot: Bool {
      members.contains { member in
        switch member {
        case .atom(.dot): return true
        case .custom(let ccc): return ccc.containsDot
        default:
          return false
        }
      }
    }
    public init(members: [DSLTree.CustomCharacterClass.Member], isInverted: Bool = false) {
      self.members = members
      self.isInverted = isInverted
    }
    public static func generalCategory(_ category: Unicode.GeneralCategory) -> Self {
      let property = AST.Atom.CharacterProperty(.generalCategory(category.extendedGeneralCategory!), isInverted: false, isPOSIX: false)
      let astAtom = AST.Atom(.property(property), .fake)
      return .init(members: [.atom(.unconverted(.init(ast: astAtom)))])
    }
    public var inverted: CustomCharacterClass {
      var result = self
      result.isInverted.toggle()
      return result
    }
    public enum Member {
      case atom(Atom)
      case range(Atom, Atom)
      case custom(CustomCharacterClass)
      case quotedLiteral(String)
      case trivia(String)
      indirect case intersection(CustomCharacterClass, CustomCharacterClass)
      indirect case subtraction(CustomCharacterClass, CustomCharacterClass)
      indirect case symmetricDifference(CustomCharacterClass, CustomCharacterClass)
    }
  }
  public enum Atom {
    case char(Character)
    case scalar(Unicode.Scalar)
    case any
    case anyNonNewline
    case dot
    case characterClass(CharacterClass)
    case assertion(Assertion)
    case backreference(_AST.Reference)
    case symbolicReference(ReferenceID)
    case changeMatchingOptions(_AST.MatchingOptionSequence)
    case unconverted(_AST.Atom)
  }
}
extension DSLTree.Atom {
  public enum Assertion: UInt64, Hashable {
    case startOfSubject = 0
    case endOfSubjectBeforeNewline
    case endOfSubject
    case resetStartOfMatch
    case firstMatchingPositionInSubject
    case textSegment
    case notTextSegment
    case startOfLine
    case endOfLine
    case caretAnchor
    case dollarAnchor
    case wordBoundary
    case notWordBoundary
  }
  public enum CharacterClass: Hashable {
    case digit
    case notDigit
    case horizontalWhitespace
    case notHorizontalWhitespace
    case newlineSequence
    case notNewline
    case whitespace
    case notWhitespace
    case verticalWhitespace
    case notVerticalWhitespace
    case word
    case notWord
    case anyGrapheme
    case anyUnicodeScalar
  }
}
extension DSLTree.Atom.CharacterClass {
  public var inverted: DSLTree.Atom.CharacterClass? {
    switch self {
    case .anyGrapheme: return nil
    case .digit: return .notDigit
    case .notDigit: return .digit
    case .word: return .notWord
    case .notWord: return .word
    case .horizontalWhitespace: return .notHorizontalWhitespace
    case .notHorizontalWhitespace: return .horizontalWhitespace
    case .newlineSequence: return .notNewline
    case .notNewline: return .newlineSequence
    case .verticalWhitespace: return .notVerticalWhitespace
    case .notVerticalWhitespace: return .verticalWhitespace
    case .whitespace: return .notWhitespace
    case .notWhitespace: return .whitespace
    case .anyUnicodeScalar:
      fatalError("Unsupported")
    }
  }
}
extension Unicode.GeneralCategory {
  var extendedGeneralCategory: Unicode.ExtendedGeneralCategory? {
    switch self {
    case .uppercaseLetter: return .uppercaseLetter
    case .lowercaseLetter: return .lowercaseLetter
    case .titlecaseLetter: return .titlecaseLetter
    case .modifierLetter: return .modifierLetter
    case .otherLetter: return .otherLetter
    case .nonspacingMark: return .nonspacingMark
    case .spacingMark: return .spacingMark
    case .enclosingMark: return .enclosingMark
    case .decimalNumber: return .decimalNumber
    case .letterNumber: return .letterNumber
    case .otherNumber: return .otherNumber
    case .connectorPunctuation: return .connectorPunctuation
    case .dashPunctuation: return .dashPunctuation
    case .openPunctuation: return .openPunctuation
    case .closePunctuation: return .closePunctuation
    case .initialPunctuation: return .initialPunctuation
    case .finalPunctuation: return .finalPunctuation
    case .otherPunctuation: return .otherPunctuation
    case .mathSymbol: return .mathSymbol
    case .currencySymbol: return .currencySymbol
    case .modifierSymbol: return .modifierSymbol
    case .otherSymbol: return .otherSymbol
    case .spaceSeparator: return .spaceSeparator
    case .lineSeparator: return .lineSeparator
    case .paragraphSeparator: return .paragraphSeparator
    case .control: return .control
    case .format: return .format
    case .surrogate: return .surrogate
    case .privateUse: return .privateUse
    case .unassigned: return .unassigned
    @unknown default: return nil
    }
  }
}
typealias _ConsumerInterface = (
  String, Range<String.Index>
) throws -> String.Index?
typealias _MatcherInterface = (
  String, String.Index, Range<String.Index>
) throws -> (String.Index, Any)?
typealias _CharacterPredicateInterface = (
  (Character) -> Bool
)
/*
 TODO: Use of syntactic types, like group kinds, is a
 little suspect. We may want to figure out a model here.
 TODO: Do capturing groups need explicit numbers?
 TODO: Are storing closures better/worse than existentials?
 */
extension DSLTree.Node {
  var hasChildNodes: Bool {
    switch self {
    case .trivia, .empty, .quotedLiteral,
        .consumer, .matcher, .characterPredicate,
        .customCharacterClass, .atom:
      return false
    case .orderedChoice(let c), .concatenation(let c):
      return !c.isEmpty
    case .convertedRegexLiteral, .capture, .nonCapturingGroup,
        .quantification, .ignoreCapturesInTypedOutput, .conditional:
      return true
    case .absentFunction(let abs):
      return !abs.ast.children.isEmpty
    }
  }
  public var children: [DSLTree.Node] {
    switch self {
    case let .orderedChoice(v):   return v
    case let .concatenation(v): return v
    case let .convertedRegexLiteral(n, _):
      return n.children
    case let .capture(_, _, n, _):        return [n]
    case let .nonCapturingGroup(_, n):    return [n]
    case let .quantification(_, _, n):    return [n]
    case let .ignoreCapturesInTypedOutput(n):        return [n]
    case let .conditional(_, t, f): return [t,f]
    case .trivia, .empty, .quotedLiteral,
        .consumer, .matcher, .characterPredicate,
        .customCharacterClass, .atom:
      return []
    case let .absentFunction(abs):
      return abs.ast.children.map(\.dslTreeNode)
    }
  }
}
extension DSLTree.Node {
  var astNode: AST.Node? {
    switch self {
    case let .convertedRegexLiteral(_, literal): return literal.ast
    default: return nil
    }
  }
  var lookingThroughConvertedLiteral: Self {
    switch self {
    case let .convertedRegexLiteral(n, _): return n
    default: return self
    }
  }
}
extension DSLTree.Atom {
  var literalCharacterValue: Character? {
    switch self {
    case let .char(c):   return c
    case let .scalar(s): return Character(s)
    default: return nil
    }
  }
}
extension DSLTree {
  struct Options {
  }
}
extension DSLTree {
  var hasCapture: Bool {
    root.hasCapture
  }
}
extension DSLTree.Node {
  var hasCapture: Bool {
    switch self {
    case .capture:
      return true
    case let .convertedRegexLiteral(n, re):
      assert(n.hasCapture == re.ast.hasCapture)
      return n.hasCapture
    default:
      return self.children.any(\.hasCapture)
    }
  }
}
extension DSLTree.Node {
  func appending(_ newNode: DSLTree.Node) -> DSLTree.Node {
    if case .concatenation(let components) = self {
      return .concatenation(components + [newNode])
    }
    return .concatenation([self, newNode])
  }
  func appendingAlternationCase(
    _ newNode: DSLTree.Node
  ) -> DSLTree.Node {
    if case .orderedChoice(let components) = self {
      return .orderedChoice(components + [newNode])
    }
    return .orderedChoice([self, newNode])
  }
}
public struct ReferenceID: Hashable {
  private static var counter: Int = 0
  var base: Int
  public var _raw: Int {
    base
  }
  public init() {
    base = Self.counter
    Self.counter += 1
  }
  init(_ base: Int) {
    self.base = base
  }
}
struct CaptureTransform: Hashable, CustomStringConvertible {
  enum Closure {
    case failable((Any) throws -> Any?)
    case substringFailable((Substring) throws -> Any?)
    case nonfailable((Any) throws -> Any)
    case substringNonfailable((Substring) throws -> Any?)
  }
  let argumentType: Any.Type
  let resultType: Any.Type
  let closure: Closure
  init(argumentType: Any.Type, resultType: Any.Type, closure: Closure) {
    self.argumentType = argumentType
    self.resultType = resultType
    self.closure = closure
  }
  init<Argument, Result>(
    _ userSpecifiedTransform: @escaping (Argument) throws -> Result
  ) {
    let closure: Closure
    if let substringTransform = userSpecifiedTransform
      as? (Substring) throws -> Result {
      closure = .substringNonfailable(substringTransform)
    } else {
      closure = .nonfailable {
        try userSpecifiedTransform($0 as! Argument) as Any
      }
    }
    self.init(
      argumentType: Argument.self,
      resultType: Result.self,
      closure: closure)
  }
  init<Argument, Result>(
    _ userSpecifiedTransform: @escaping (Argument) throws -> Result?
  ) {
    let closure: Closure
    if let substringTransform = userSpecifiedTransform
      as? (Substring) throws -> Result? {
      closure = .substringFailable(substringTransform)
    } else {
      closure = .failable {
        try userSpecifiedTransform($0 as! Argument) as Any?
      }
    }
    self.init(
      argumentType: Argument.self,
      resultType: Result.self,
      closure: closure)
  }
  func callAsFunction(_ input: Any) throws -> Any? {
    switch closure {
    case .nonfailable(let transform):
      let result = try transform(input)
      assert(type(of: result) == resultType)
      return result
    case .substringNonfailable(let transform):
      let result = try transform(input as! Substring)
      assert(type(of: result) == resultType)
      return result
    case .failable(let transform):
      guard let result = try transform(input) else {
        return nil
      }
      assert(type(of: result) == resultType)
      return result
    case .substringFailable(let transform):
      guard let result = try transform(input as! Substring) else {
        return nil
      }
      assert(type(of: result) == resultType)
      return result
    }
  }
  func callAsFunction(_ input: Substring) throws -> Any? {
    switch closure {
    case .substringFailable(let transform):
      return try transform(input)
    case .substringNonfailable(let transform):
      return try transform(input)
    case .failable(let transform):
      return try transform(input)
    case .nonfailable(let transform):
      return try transform(input)
    }
  }
  static func == (lhs: CaptureTransform, rhs: CaptureTransform) -> Bool {
    unsafeBitCast(lhs.closure, to: (Int, Int).self) ==
      unsafeBitCast(rhs.closure, to: (Int, Int).self)
  }
  func hash(into hasher: inout Hasher) {
    let (fn, ctx) = unsafeBitCast(closure, to: (Int, Int).self)
    hasher.combine(fn)
    hasher.combine(ctx)
  }
  var description: String {
    "<transform argument_type=\(argumentType) result_type=\(resultType)>"
  }
}
extension CaptureList.Builder {
  mutating func addCaptures(
    of node: DSLTree.Node, optionalNesting nesting: OptionalNesting, visibleInTypedOutput: Bool
  ) {
    switch node {
    case let .orderedChoice(children):
      for child in children {
        addCaptures(of: child, optionalNesting: nesting.addingOptional, visibleInTypedOutput: visibleInTypedOutput)
      }
    case let .concatenation(children):
      for child in children {
        addCaptures(of: child, optionalNesting: nesting, visibleInTypedOutput: visibleInTypedOutput)
      }
    case let .capture(name, _, child, transform):
      captures.append(.init(
        name: name,
        type: transform?.resultType ?? child.wholeMatchType,
        optionalDepth: nesting.depth, visibleInTypedOutput: visibleInTypedOutput, .fake))
      addCaptures(of: child, optionalNesting: nesting, visibleInTypedOutput: visibleInTypedOutput)
    case let .nonCapturingGroup(kind, child):
      assert(!kind.ast.isCapturing)
      addCaptures(of: child, optionalNesting: nesting, visibleInTypedOutput: visibleInTypedOutput)
    case let .ignoreCapturesInTypedOutput(child):
      addCaptures(of: child, optionalNesting: nesting, visibleInTypedOutput: false)
    case let .conditional(cond, trueBranch, falseBranch):
      switch cond.ast {
      case .group(let g):
        addCaptures(of: .group(g), optionalNesting: nesting, visibleInTypedOutput: visibleInTypedOutput)
      default:
        break
      }
      addCaptures(of: trueBranch, optionalNesting: nesting.addingOptional, visibleInTypedOutput: visibleInTypedOutput)
      addCaptures(of: falseBranch, optionalNesting: nesting.addingOptional, visibleInTypedOutput: visibleInTypedOutput)
    case let .quantification(amount, _, child):
      var optNesting = nesting
      if amount.ast.bounds.atLeast == 0 {
        optNesting = optNesting.addingOptional
      }
      addCaptures(of: child, optionalNesting: optNesting, visibleInTypedOutput: visibleInTypedOutput)
    case let .absentFunction(abs):
      switch abs.ast.kind {
      case .expression(_, _, let child):
        addCaptures(of: child, optionalNesting: nesting, visibleInTypedOutput: visibleInTypedOutput)
      case .clearer, .repeater, .stopper:
        break
      }
    case let .convertedRegexLiteral(n, _):
      return addCaptures(of: n, optionalNesting: nesting.disablingNesting, visibleInTypedOutput: visibleInTypedOutput)
    case .matcher:
      break
    case .customCharacterClass, .atom, .trivia, .empty,
        .quotedLiteral, .consumer, .characterPredicate:
      break
    }
  }
  static func build(_ dsl: DSLTree) -> CaptureList {
    var builder = Self()
    builder.captures.append(
      .init(type: dsl.root.wholeMatchType, optionalDepth: 0, visibleInTypedOutput: true, .fake))
    builder.addCaptures(of: dsl.root, optionalNesting: .init(canNest: true), visibleInTypedOutput: true)
    return builder.captures
  }
}
extension DSLTree.Node {
  var isOutputForwarding: Bool {
    switch self {
    case .nonCapturingGroup, .ignoreCapturesInTypedOutput:
      return true
    case .orderedChoice, .concatenation, .capture,
         .conditional, .quantification, .customCharacterClass, .atom,
         .trivia, .empty, .quotedLiteral, .absentFunction,
         .convertedRegexLiteral, .consumer,
         .characterPredicate, .matcher:
      return false
    }
  }
  var outputDefiningNode: Self {
    if isOutputForwarding {
      assert(children.count == 1)
      return children[0].outputDefiningNode
    }
    return self
  }
  var wholeMatchType: Any.Type {
    if case .matcher(let type, _) = outputDefiningNode {
      return type
    }
    return Substring.self
  }
}
extension DSLTree.Node {
  private func _canOnlyMatchAtStartImpl(_ options: inout MatchingOptions) -> Bool? {
    switch self {
    case .atom(.assertion(.startOfSubject)):
      return true
    case .atom(.assertion(.caretAnchor)):
      return !options.anchorsMatchNewlines
    case .atom(.changeMatchingOptions(let sequence)):
      options.apply(sequence.ast)
      return nil
    case .atom, .customCharacterClass, .quotedLiteral:
      return false
    case .trivia, .empty:
      return nil
    case .orderedChoice(let children):
      return children.allSatisfy { $0._canOnlyMatchAtStartImpl(&options) == true }
    case .concatenation(let children):
      for child in children {
        if let result = child._canOnlyMatchAtStartImpl(&options) {
          return result
        }
      }
      return false
    case .nonCapturingGroup(let kind, let child):
      options.beginScope()
      defer { options.endScope() }
      if case .changeMatchingOptions(let sequence) = kind.ast {
        options.apply(sequence)
      }
      return child._canOnlyMatchAtStartImpl(&options)
    case .capture(_, _, let child, _):
      options.beginScope()
      defer { options.endScope() }
      return child._canOnlyMatchAtStartImpl(&options)
    case .ignoreCapturesInTypedOutput(let child),
        .convertedRegexLiteral(let child, _):
      return child._canOnlyMatchAtStartImpl(&options)
    case .quantification(let amount, _, let child):
      return amount.requiresAtLeastOne
        ? child._canOnlyMatchAtStartImpl(&options)
        : nil
    case .conditional(_, let child1, let child2):
      return child1._canOnlyMatchAtStartImpl(&options) == true
        && child2._canOnlyMatchAtStartImpl(&options) == true
    case .consumer, .matcher, .characterPredicate, .absentFunction:
      return false
    }
  }
  internal func canOnlyMatchAtStart() -> Bool {
    var options = MatchingOptions()
    return _canOnlyMatchAtStartImpl(&options) ?? false
  }
}
extension DSLTree {
  var captureList: CaptureList { .Builder.build(self) }
  struct _Tree: _TreeNode {
    var node: DSLTree.Node
    init(_ node: DSLTree.Node) {
      self.node = node
    }
    var children: [_Tree]? {
      switch node {
      case let .orderedChoice(v): return v.map(_Tree.init)
      case let .concatenation(v): return v.map(_Tree.init)
      case let .convertedRegexLiteral(n, _):
        return _Tree(n).children
      case let .capture(_, _, n, _):        return [_Tree(n)]
      case let .nonCapturingGroup(_, n):    return [_Tree(n)]
      case let .quantification(_, _, n):    return [_Tree(n)]
      case let .ignoreCapturesInTypedOutput(n):        return [_Tree(n)]
      case let .conditional(_, t, f): return [_Tree(t), _Tree(f)]
      case .trivia, .empty, .quotedLiteral,
          .consumer, .matcher, .characterPredicate,
          .customCharacterClass, .atom:
        return []
      case let .absentFunction(abs):
        return abs.ast.children.map(\.dslTreeNode).map(_Tree.init)
      }
    }
  }
  public enum _AST {
    public struct GroupKind {
      internal var ast: AST.Group.Kind
      public static var atomicNonCapturing: Self {
        .init(ast: .atomicNonCapturing)
      }
      public static var lookahead: Self {
        .init(ast: .lookahead)
      }
      public static var negativeLookahead: Self {
        .init(ast: .negativeLookahead)
      }
    }
    public struct ConditionKind {
      internal var ast: AST.Conditional.Condition.Kind
    }
    public struct QuantificationKind {
      internal var ast: AST.Quantification.Kind
      public static var eager: Self {
        .init(ast: .eager)
      }
      public static var reluctant: Self {
        .init(ast: .reluctant)
      }
      public static var possessive: Self {
        .init(ast: .possessive)
      }
    }
    public struct QuantificationAmount {
      internal var ast: AST.Quantification.Amount
      public static var zeroOrMore: Self {
        .init(ast: .zeroOrMore)
      }
      public static var oneOrMore: Self {
        .init(ast: .oneOrMore)
      }
      public static var zeroOrOne: Self {
        .init(ast: .zeroOrOne)
      }
      public static func exactly(_ n: Int) -> Self {
        .init(ast: .exactly(.init(n, at: .fake)))
      }
      public static func nOrMore(_ n: Int) -> Self {
        .init(ast: .nOrMore(.init(n, at: .fake)))
      }
      public static func upToN(_ n: Int) -> Self {
        .init(ast: .upToN(.init(n, at: .fake)))
      }
      public static func range(_ lower: Int, _ upper: Int) -> Self {
        .init(ast: .range(.init(lower, at: .fake), .init(upper, at: .fake)))
      }
      internal var requiresAtLeastOne: Bool {
        switch ast {
        case .zeroOrOne, .zeroOrMore, .upToN:
          return false
        case .oneOrMore:
          return true
        case .exactly(let num), .nOrMore(let num), .range(let num, _):
          return num.value.map { $0 > 0 } ?? false
        }
      }
    }
    public struct ASTNode {
      internal var ast: AST.Node
    }
    public struct AbsentFunction {
      internal var ast: AST.AbsentFunction
    }
    public struct Reference {
      internal var ast: AST.Reference
    }
    public struct MatchingOptionSequence {
      internal var ast: AST.MatchingOptionSequence
    }
    public struct Atom {
      internal var ast: AST.Atom
    }
  }
}
extension DSLTree.Atom {
  var isMatchable: Bool {
    switch self {
    case .changeMatchingOptions, .assertion:
      return false
    case .char, .scalar, .any, .anyNonNewline, .dot, .backreference,
        .symbolicReference, .unconverted, .characterClass:
      return true
    }
  }
}
extension DSLTree.Node {
  @available(SwiftStdlib 5.7, *)
  static func repeating(
    _ range: Range<Int>,
    _ behavior: RegexRepetitionBehavior?,
    _ node: DSLTree.Node
  ) -> DSLTree.Node {
    precondition(range.lowerBound >= 0, "Cannot specify a negative lower bound")
    precondition(!range.isEmpty, "Cannot specify an empty range")
    let kind: DSLTree.QuantificationKind = behavior
      .map { .explicit($0.dslTreeKind) } ?? .default
    let lower = range.lowerBound
    let upperInclusive = range.upperBound - 1
    if range.upperBound == Int.max {
      switch lower {
      case 0: 
        return .quantification(.zeroOrMore, kind, node)
      case 1: 
        return .quantification(.oneOrMore, kind, node)
      default: 
        return .quantification(.nOrMore(lower), kind, node)
      }
    }
    if range.count == 1 {
      return .quantification(.exactly(lower), .default, node)
    }
    switch lower {
    case 0: 
      return .quantification(.upToN(upperInclusive), kind, node)
    default:
      return .quantification(.range(lower, upperInclusive), kind, node)
    }
  }
}
