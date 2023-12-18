public func renderAsBuilderDSL(
  ast: Any,
  maxTopDownLevels: Int? = nil,
  minBottomUpLevels: Int? = nil
) -> String {
  var printer = PrettyPrinter(
    maxTopDownLevels: maxTopDownLevels,
    minBottomUpLevels: minBottomUpLevels)
  printer.printAsPattern(ast as! AST)
  return printer.finish()
}
extension PrettyPrinter {
  mutating func patternBackoff<T: _TreeNode>(
    _ ast: T
  ) -> Bool {
    if let max = maxTopDownLevels, depth >= max {
      return true
    }
    if let min = minBottomUpLevels, ast.height <= min {
      return true
    }
    return false
  }
  mutating func printBackoff(_ node: DSLTree.Node) {
    precondition(node.astNode != nil, "unconverted node")
    printAsCanonical(
      .init(node.astNode!, globalOptions: nil, diags: Diagnostics()),
      delimiters: true)
  }
  mutating func printAsPattern(_ ast: AST) {
    let node = ast.root.dslTreeNode
    let namedCaptures = node.getNamedCaptures()
    for namedCapture in namedCaptures {
      print("let \(namedCapture) = Reference(Substring.self)")
    }
    printBlock("Regex") { printer in
      printer.printAsPattern(convertedFromAST: node, isTopLevel: true)
    }
  }
  private mutating func printAsPattern(
    convertedFromAST node: DSLTree.Node, isTopLevel: Bool = false
  ) {
    if patternBackoff(DSLTree._Tree(node)) {
      printBackoff(node)
      return
    }
    switch node {
    case let .orderedChoice(a):
      printBlock("ChoiceOf") { printer in
        a.forEach {
          printer.printAsPattern(convertedFromAST: $0)
        }
      }
    case let .concatenation(c):
      printConcatenationAsPattern(c, isTopLevel: isTopLevel)
    case let .nonCapturingGroup(kind, child):
      switch kind.ast {
      case .atomicNonCapturing:
        printBlock("Local") { printer in
          printer.printAsPattern(convertedFromAST: child)
        }
      case .lookahead:
        printBlock("Lookahead") { printer in
          printer.printAsPattern(convertedFromAST: child)
        }
      case .negativeLookahead:
        printBlock("NegativeLookahead") { printer in
          printer.printAsPattern(convertedFromAST: child)
        }
      default:
        printAsPattern(convertedFromAST: child)
      }
    case let .capture(name, _, child, _):
      var cap = "Capture"
      if let n = name {
        cap += "(as: \(n))"
      }
      printBlock(cap) { printer in
        printer.printAsPattern(convertedFromAST: child)
      }
    case let .ignoreCapturesInTypedOutput(child):
      printAsPattern(convertedFromAST: child, isTopLevel: isTopLevel)
    case .conditional:
      print("")
    case let .quantification(amount, kind, child):
      let amountStr = amount.ast._patternBase
      var kind = kind.ast?._patternBase ?? ""
      if quantificationBehavior != .eager {
        kind = quantificationBehavior._patternBase
      }
      var blockName = "\(amountStr)(\(kind))"
      if kind == ".eager" {
        blockName = "\(amountStr)"
      }
      func printAtom(_ pattern: String) {
        indent()
        if kind != ".eager" {
          blockName.removeLast()
          output("\(blockName), ")
        } else {
          output("\(blockName)(")
        }
        output("\(pattern))")
        terminateLine()
      }
      func printSimpleCCC(
        _ ccc: DSLTree.CustomCharacterClass
      ) {
        indent()
        if kind != ".eager" {
          blockName.removeLast()
          output("\(blockName), ")
        } else {
          output("\(blockName)(")
        }
        printAsPattern(ccc, wrap: false, terminateLine: false)
        output(")")
        terminateLine()
      }
      if amount.ast.supportsInlineComponent {
        switch child {
        case let .atom(a):
          if let pattern = a._patternBase(&self), pattern.canBeWrapped {
            printAtom(pattern.0)
            return
          }
          break
        case let .customCharacterClass(ccc):
          if ccc.isSimplePrint {
            printSimpleCCC(ccc)
            return
          }
          break
        case let .convertedRegexLiteral(.atom(a), _):
          if let pattern = a._patternBase(&self), pattern.canBeWrapped {
            printAtom(pattern.0)
            return
          }
          break
        case let .convertedRegexLiteral(.customCharacterClass(ccc), _):
          if ccc.isSimplePrint {
            printSimpleCCC(ccc)
            return
          }
          break
        default:
          break
        }
      }
      printBlock(blockName) { printer in
        printer.printAsPattern(convertedFromAST: child)
      }
    case let .atom(a):
      if case .unconverted(let a) = a, a.ast.isUnprintableAtom {
        print("#/\(a.ast._regexBase)/#")
        return
      }
      if let pattern = a._patternBase(&self) {
        if pattern.canBeWrapped {
          print("One(\(pattern.0))")
        } else {
          print(pattern.0)
        }
      }
    case .trivia:
      break
    case .empty:
      print("")
    case let .quotedLiteral(v):
      print(v._quoted)
    case let .convertedRegexLiteral(n, _):
      printAsPattern(convertedFromAST: n, isTopLevel: isTopLevel)
    case let .customCharacterClass(ccc):
      printAsPattern(ccc)
    case .consumer:
      print("")
    case .matcher:
      print("")
    case .characterPredicate:
      print("")
    case .absentFunction:
      print("")
    }
  }
  enum NodeToPrint {
    case dslNode(DSLTree.Node)
    case stringLiteral(String)
  }
  mutating func printAsPattern(_ node: NodeToPrint) {
    switch node {
    case .dslNode(let n):
      printAsPattern(convertedFromAST: n)
    case .stringLiteral(let str):
      print(str)
    }
  }
  mutating func printConcatenationAsPattern(
    _ nodes: [DSLTree.Node], isTopLevel: Bool
  ) {
    let nodes = nodes
      .map { NodeToPrint.dslNode($0.lookingThroughConvertedLiteral) }
      .coalescing(
        with: StringLiteralBuilder(), into: { .stringLiteral($0.result) }
      ) { literal, node in
        guard case .dslNode(let node) = node else { return false }
        switch node {
        case let .atom(.char(c)):
          literal.append(c)
          return true
        case let .atom(.scalar(s)):
          literal.append(unescaped: s._dslBase)
          return true
        case .quotedLiteral(let q):
          literal.append(q)
          return true
        case .trivia:
          return !literal.isEmpty
        default:
          return false
        }
      }
    if isTopLevel || nodes.count == 1 {
      for n in nodes {
        printAsPattern(n)
      }
      return
    }
    printBlock("Regex") { printer in
      for n in nodes {
        printer.printAsPattern(n)
      }
    }
  }
  mutating func printAsPattern(
    _ ccc: DSLTree.CustomCharacterClass,
    wrap: Bool = true,
    terminateLine: Bool = true
  ) {
    if ccc.hasUnprintableProperty {
      printAsRegex(ccc, terminateLine: terminateLine)
      return
    }
    defer {
      if ccc.isInverted {
        printIndented { printer in
          printer.indent()
          printer.output(".inverted")
          if terminateLine {
            printer.terminateLine()
          }
        }
      }
    }
    if ccc.members.count == 1 {
      printAsPattern(ccc.members[0], wrap: wrap)
      if terminateLine {
        self.terminateLine()
      }
      return
    }
    var charMembers = StringLiteralBuilder()
    let nonCharMembers = ccc.members.filter {
      switch $0 {
      case let .atom(a):
        switch a {
        case let .char(c):
          charMembers.append(c)
          return false
        case let .scalar(s):
          charMembers.append(unescaped: s._dslBase)
          return false
        case .unconverted(_):
          return true
        default:
          return true
        }
      case let .quotedLiteral(s):
        charMembers.append(s)
        return false
      case .trivia(_):
        return false
      default:
        return true
      }
    }
    if !charMembers.isEmpty, nonCharMembers.isEmpty {
      let anyOf = ".anyOf(\(charMembers))"
      indent()
      if wrap {
        output("One(\(anyOf))")
      } else {
        output(anyOf)
      }
      if terminateLine {
        self.terminateLine()
      }
      return
    }
    print("CharacterClass(")
    printIndented { printer in      
      printer.indent()
      if !charMembers.isEmpty {
        printer.output(".anyOf(\(charMembers))")
        if nonCharMembers.count > 0 {
          printer.output(",")
        }
        printer.terminateLine()
      }
      for (i, member) in nonCharMembers.enumerated() {
        printer.printAsPattern(member, wrap: false)
        if i != nonCharMembers.count - 1 {
          printer.output(",")
        }
        printer.terminateLine()
      }
    }
    indent()
    output(")")
    if terminateLine {
      self.terminateLine()
    }
  }
  mutating func printAsPattern(
    _ member: DSLTree.CustomCharacterClass.Member,
    wrap: Bool = true
  ) {
    switch member {
    case let .custom(ccc):
      printAsPattern(ccc, terminateLine: false)
    case let .range(lhs, rhs):
      if let lhs = lhs._patternBase(&self), let rhs = rhs._patternBase(&self) {
        indent()
        output("(")
        output(lhs.0)
        output("...")
        output(rhs.0)
        output(")")
      }
    case let .atom(a):
      indent()
      switch a {
      case let .char(c):
        if wrap {
          output("One(.anyOf(\(String(c)._quoted)))")
        } else {
          output(".anyOf(\(String(c)._quoted))")
        }
      case let .scalar(s):
        if wrap {
          output("One(.anyOf(\(s._dslBase._bareQuoted)))")
        } else {
          output(".anyOf(\(s._dslBase._bareQuoted))")
        }
      case let .unconverted(a):
        let base = a.ast._patternBase
        if base.canBeWrapped, wrap {
          output("One(\(base.0))")
        } else {
          output(base.0)
        }
      case let .characterClass(cc):
        if wrap {
          output("One(\(cc._patternBase))")
        } else {
          output(cc._patternBase)
        }
      default:
        print(" 
      }
    case .quotedLiteral(let s):
      if wrap {
        output("One(.anyOf(\(s._quoted)))")
      } else {
        output(".anyOf(\(s._quoted))")
      }
    case .trivia(_):
      break
    case .intersection(let first, let second):
      if wrap, first.isSimplePrint {
        indent()
        output("One(")
      }
      printAsPattern(first, wrap: false)
      printIndented { printer in
        printer.indent()
        printer.output(".intersection(")
        printer.printAsPattern(second, wrap: false, terminateLine: false)
        printer.output(")")
      }
      if wrap, first.isSimplePrint {
        output(")")
      }
    case .subtraction(let first, let second):
      if wrap, first.isSimplePrint {
        indent()
        output("One(")
      }
      printAsPattern(first, wrap: false)
      printIndented { printer in
        printer.indent()
        printer.output(".subtracting(")
        printer.printAsPattern(second, wrap: false, terminateLine: false)
        printer.output(")")
      }
      if wrap, first.isSimplePrint {
        output(")")
      }
    case .symmetricDifference(let first, let second):
      if wrap, first.isSimplePrint {
        indent()
        output("One(")
      }
      printAsPattern(first, wrap: false)
      printIndented { printer in
        printer.indent()
        printer.output(".symmetricDifference(")
        printer.printAsPattern(second, wrap: false, terminateLine: false)
        printer.output(")")
      }
      if wrap, first.isSimplePrint {
        output(")")
      }
    }
  }
  mutating func printAsRegex(
    _ ccc: DSLTree.CustomCharacterClass,
    asFullRegex: Bool = true,
    terminateLine: Bool = true
  ) {
    indent()
    if asFullRegex {
      output("#/")
    }
    output("[")
    if ccc.isInverted {
      output("^")
    }
    for member in ccc.members {
      printAsRegex(member)
    }
    output("]")
    if asFullRegex {
      if terminateLine {
        print("/#")
      } else {
        output("/#")
      }
    }
  }
  mutating func printAsRegex(_ member: DSLTree.CustomCharacterClass.Member) {
    switch member {
    case let .custom(ccc):
      printAsRegex(ccc, terminateLine: false)
    case let .range(lhs, rhs):
      output(lhs._regexBase)
      output("-")
      output(rhs._regexBase)
    case let .atom(a):
      switch a {
      case let .char(c):
        output(String(c))
      case let .unconverted(a):
        output(a.ast._regexBase)
      default:
        print(" 
      }
    case .quotedLiteral(let s):
      output("\\Q\(s)\\E")
    case .trivia(_):
      break
    case .intersection(let first, let second):
      printAsRegex(first, asFullRegex: false, terminateLine: false)
      output("&&")
      printAsRegex(second, asFullRegex: false, terminateLine: false)
    case .subtraction(let first, let second):
      printAsRegex(first, asFullRegex: false, terminateLine: false)
      output("--")
      printAsRegex(second, asFullRegex: false, terminateLine: false)
    case .symmetricDifference(let first, let second):
      printAsRegex(first, asFullRegex: false, terminateLine: false)
      output("~~")
      printAsRegex(second, asFullRegex: false, terminateLine: false)
    }
  }
}
extension String {
  fileprivate var _escaped: String {
    _replacing(#"\"#, with: #"\\"#)._replacing(#"""#, with: #"\""#)
  }
  fileprivate var _quoted: String {
    _escaped._bareQuoted
  }
  fileprivate var _bareQuoted: String {
    #""\#(self)""#
  }
}
extension UnicodeScalar {
  var _dslBase: String { "\\u{\(String(value, radix: 16, uppercase: true))}" }
}
fileprivate struct StringLiteralBuilder {
  private var contents = ""
  var result: String { contents._bareQuoted }
  var isEmpty: Bool { contents.isEmpty }
  mutating func append(_ str: String) {
    contents += str._escaped
  }
  mutating func append(_ c: Character) {
    contents += String(c)._escaped
  }
  mutating func append(unescaped str: String) {
    contents += str
  }
}
extension StringLiteralBuilder: CustomStringConvertible {
  var description: String { result }
}
extension DSLTree.Atom.Assertion {
  var _patternBase: String {
    switch self {
    case .startOfLine:
      return "Anchor.startOfLine"
    case .endOfLine:
      return "Anchor.endOfLine"
    case .caretAnchor:
      return "/^/"
    case .dollarAnchor:
      return "/$/"
    case .wordBoundary:
      return "Anchor.wordBoundary"
    case .notWordBoundary:
      return "Anchor.wordBoundary.inverted"
    case .startOfSubject:
      return "Anchor.startOfSubject"
    case .endOfSubject:
      return "Anchor.endOfSubject"
    case .endOfSubjectBeforeNewline:
      return "Anchor.endOfSubjectBeforeNewline"
    case .textSegment:
      return "Anchor.textSegmentBoundary"
    case .notTextSegment:
      return "Anchor.textSegmentBoundary.inverted"
    case .firstMatchingPositionInSubject:
      return "Anchor.firstMatchingPositionInSubject"
    case .resetStartOfMatch:
      return "TODO: Assertion resetStartOfMatch"
    }
  }
}
extension DSLTree.Atom.CharacterClass {
  var _patternBase: String {
    switch self {
    case .anyGrapheme:
      return ".anyGraphemeCluster"
    case .digit:
      return ".digit"
    case .notDigit:
      return ".digit.inverted"
    case .word:
      return ".word"
    case .notWord:
      return ".word.inverted"
    case .horizontalWhitespace:
      return ".horizontalWhitespace"
    case .notHorizontalWhitespace:
      return ".horizontalWhitespace.inverted"
    case .newlineSequence:
      return ".newlineSequence"
    case .notNewline:
      return ".newlineSequence.inverted"
    case .verticalWhitespace:
      return ".verticalWhitespace"
    case .notVerticalWhitespace:
      return ".verticalWhitespace.inverted"
    case .whitespace:
      return ".whitespace"
    case .notWhitespace:
      return ".whitespace.inverted"
    case .anyUnicodeScalar:
      fatalError("Unsupported")
    }
  }
}
extension AST.Atom.CharacterProperty {
  var isUnprintableProperty: Bool {
    switch kind {
    case .ascii:
      return true
    case .binary(let b, value: _):
      return isUnprintableBinary(b)
    case .generalCategory(let gc):
      return isUnprintableGeneralCategory(gc)
    case .posix(let p):
      return isUnprintablePOSIX(p)
    case .script(_), .scriptExtension(_):
      return true
    default:
      return false
    }
  }
  func isUnprintableBinary(_ binary: Unicode.BinaryProperty) -> Bool {
    switch binary {
    case .whitespace:
      return false
    default:
      return true
    }
  }
  func isUnprintableGeneralCategory(
    _ gc: Unicode.ExtendedGeneralCategory
  ) -> Bool {
    switch gc {
    case .decimalNumber:
      return false
    default:
      return true
    }
  }
  func isUnprintablePOSIX(_ posix: Unicode.POSIXProperty) -> Bool {
    switch posix {
    case .xdigit:
      return false
    case .word:
      return false
    default:
      return true
    }
  }
}
extension AST.Atom.CharacterProperty {
  var _patternBase: String {
    if isUnprintableProperty {
      return _regexBase
    }
    return _dslBase
  }
  var _dslBase: String {
    switch kind {
    case .binary(let bp, _):
      switch bp {
      case .whitespace:
        return ".whitespace"
      default:
        return ""
      }
    case .generalCategory(let gc):
      switch gc {
      case .decimalNumber:
        return ".digit"
      default:
        return ""
      }
    case .posix(let p):
      switch p {
      case .xdigit:
        return ".hexDigit"
      case .word:
        return ".word"
      default:
        return ""
      }
    default:
      return ""
    }
  }
  var _regexBase: String {
    switch kind {
    case .ascii:
      return "[:\(isInverted ? "^" : "")ascii:]"
    case .binary(let b, value: _):
      if isInverted {
        return "[^\\p{\(b.rawValue)}]"
      } else {
        return "\\p{\(b.rawValue)}"
      }
    case .generalCategory(let gc):
      if isInverted {
        return "[^\\p{\(gc.rawValue)}]"
      } else {
        return "\\p{\(gc.rawValue)}"
      }
    case .posix(let p):
      return "[:\(isInverted ? "^" : "")\(p.rawValue):]"
    case .script(let s):
      return "[:\(isInverted ? "^" : "")script=\(s.rawValue):]"
    case .scriptExtension(let s):
      return "[:\(isInverted ? "^" : "")scx=\(s.rawValue):]"
    default:
      return " 
    }
  }
}
extension AST.Atom {
  var isUnprintableAtom: Bool {
    switch kind {
    case .keyboardControl, .keyboardMeta, .keyboardMetaControl:
      return true
    case .namedCharacter(_):
      return true
    case .property(let p):
      return p.isUnprintableProperty
    default:
      return false
    }
  }
}
extension AST.Atom {
  var _patternBase: (String, canBeWrapped: Bool) {
    if let anchor = self.dslAssertionKind {
      return (anchor._patternBase, false)
    }
    if isUnprintableAtom {
      return (_regexBase, false)
    }
    return _dslBase
  }
  var _dslBase: (String, canBeWrapped: Bool) {
    switch kind {
    case let .char(c):
      return (String(c), false)
    case let .scalar(s):
      return (s.value._dslBase, false)
    case let .scalarSequence(seq):
      return (seq.scalarValues.map(\._dslBase).joined(), false)
    case let .property(p):
      return (p._dslBase, true)
    case let .escaped(e):
      switch e {
      case .wordBoundary:
        return ("Anchor.wordBoundary", false)
      case .notWordBoundary:
        return ("Anchor.wordBoundary.inverted", false)
      case .startOfSubject:
        return ("Anchor.startOfSubject", false)
      case .endOfSubject:
        return ("Anchor.endOfSubject", false)
      case .endOfSubjectBeforeNewline:
        return ("Anchor.endOfSubjectBeforeNewline", false)
      case .firstMatchingPositionInSubject:
        return ("Anchor.firstMatchingPositionInSubject", false)
      case .textSegment:
        return ("Anchor.textSegmentBoundary", false)
      case .notTextSegment:
        return ("Anchor.textSegmentBoundary.inverted", false)
      case .decimalDigit:
        return (".digit", true)
      case .notDecimalDigit:
        return (".digit.inverted", true)
      case .horizontalWhitespace:
        return (".horizontalWhitespace", true)
      case .notHorizontalWhitespace:
        return (".horizontalWhitespace.inverted", true)
      case .whitespace:
        return (".whitespace", true)
      case .notWhitespace:
        return (".whitespace.inverted", true)
      case .wordCharacter:
        return (".word", true)
      case .notWordCharacter:
        return (".word.inverted", true)
      case .graphemeCluster:
        return (".anyGraphemeCluster", true)
      case .newlineSequence:
        return (".newlineSequence", true)
      case .notNewline:
        return (".newlineSequence.inverted", true)
      case .verticalTab:
        return (".verticalWhitespace", true)
      case .notVerticalTab:
        return (".verticalWhitespace.inverted", true)
      default:
        return ("TODO: escaped \(e)", false)
      }
    case .namedCharacter:
      return (" ", false)
    case .dot:
      return ("/./", false)
    case .caretAnchor, .dollarAnchor:
      fatalError("unreachable")
    case .backreference:
      return (" ", false)
    case .subpattern:
      return (" ", false)
    case .callout:
      return (" ", false)
    case .backtrackingDirective:
      return (" ", false)
    case .changeMatchingOptions:
      return ("", false)
    default:
      return ("", false)
    }
  }
  var _regexBase: String {
    switch kind {
    case .char, .scalar, .scalarSequence:
      return literalStringValue!
    case .invalid:
      return "<#value#>"
    case let .property(p):
      return p._regexBase
    case let .escaped(e):
      return "\\\(e.character)"
    case .keyboardControl(let k):
      return "\\c\(k)"
    case .keyboardMeta(let k):
      return "\\M-\(k)"
    case .keyboardMetaControl(let k):
      return "\\M-\\C-\(k)"
    case .namedCharacter(let n):
      return "\\N{\(n)}"
    case .dot:
      return "."
    case .caretAnchor, .dollarAnchor:
      fatalError("unreachable")
    case .backreference:
      return " "
    case .subpattern:
      return " "
    case .callout:
      return " "
    case .backtrackingDirective:
      return " "
    case .changeMatchingOptions:
      return ""
    }
  }
}
extension AST.Atom.Number {
  var _patternBase: String {
    value.map { "\($0)" } ?? "<#number#>"
  }
}
extension AST.Quantification.Amount {
  var _patternBase: String {
    switch self {
    case .zeroOrMore: return "ZeroOrMore"
    case .oneOrMore:  return "OneOrMore"
    case .zeroOrOne:  return "Optionally"
    case let .exactly(n):  return "Repeat(count: \(n._patternBase))"
    case let .nOrMore(n):  return "Repeat(\(n._patternBase)...)"
    case let .upToN(n):    return "Repeat(...\(n._patternBase))"
    case let .range(n, m): return "Repeat(\(n._patternBase)...\(m._patternBase))"
    }
  }
  var supportsInlineComponent: Bool {
    switch self {
    case .zeroOrMore: return true
    case .oneOrMore: return true
    case .zeroOrOne: return true
    default: return false
    }
  }
}
extension AST.Quantification.Kind {
  var _patternBase: String {
    switch self {
    case .eager: return ".eager"
    case .reluctant: return ".reluctant"
    case .possessive: return ".possessive"
    }
  }
}
extension DSLTree.QuantificationKind {
  var _patternBase: String {
    (ast ?? .eager)._patternBase
  }
}
extension DSLTree.CustomCharacterClass.Member {
  var isUnprintableMember: Bool {
    switch self {
    case .atom(.unconverted(let a)):
      return a.ast.isUnprintableAtom
    case .custom(let c):
      return c.hasUnprintableProperty
    case .range(.unconverted(let lhs), .unconverted(let rhs)):
      return lhs.ast.isUnprintableAtom || rhs.ast.isQuantifiable
    case .intersection(let first, let second):
      return first.hasUnprintableProperty || second.hasUnprintableProperty
    case .subtraction(let first, let second):
      return first.hasUnprintableProperty || second.hasUnprintableProperty
    case .symmetricDifference(let first, let second):
      return first.hasUnprintableProperty || second.hasUnprintableProperty
    default:
      return false
    }
  }
}
extension DSLTree.CustomCharacterClass {
  var hasUnprintableProperty: Bool {
    members.contains {
      $0.isUnprintableMember
    }
  }
  var isSimplePrint: Bool {
    if members.count == 1 {
      switch members[0] {
      case .intersection(_, _):
        return false
      case .subtraction(_, _):
        return false
      case .symmetricDifference(_, _):
        return false
      default:
        return true
      }
    }
    let nonCharMembers = members.filter {
      switch $0 {
      case let .atom(a):
        switch a {
        case .char(_):
          return false
        case .scalar(_):
          return false
        case .unconverted(_):
          return true
        default:
          return true
        }
      case .quotedLiteral(_):
        return false
      case .trivia(_):
        return false
      default:
        return true
      }
    }
    if nonCharMembers.isEmpty {
      return true
    }
    return false
  }
}
extension DSLTree.Atom {
  func _patternBase(
    _ printer: inout PrettyPrinter
  ) -> (String, canBeWrapped: Bool)? {
    switch self {
    case .any:
      return (".any", true)
    case .anyNonNewline:
      return (".anyNonNewline", true)
    case .dot:
      return ("/./", false)
    case let .char(c):
      return (String(c)._quoted, false)
    case let .scalar(s):
      let hex = String(s.value, radix: 16, uppercase: true)
      return ("\\u{\(hex)}"._bareQuoted, false)
    case let .unconverted(a):
      if a.ast.isUnprintableAtom {
        return ("#/\(a.ast._regexBase)/#", false)
      } else {
        return a.ast._dslBase
      }
    case .assertion(let a):
      return (a._patternBase, false)
    case .characterClass(let cc):
      return (cc._patternBase, true)
    case .backreference(_):
      return ("", false)
    case .symbolicReference:
      return ("", false)
    case .changeMatchingOptions(let matchingOptions):
      for add in matchingOptions.ast.adding {
        switch add.kind {
        case .reluctantByDefault:
          printer.quantificationBehavior = .reluctant
        default:
          break
        }
      }
    }
    return nil
  }
  var _regexBase: String {
    switch self {
    case .any:
      return "(?s:.)"
    case .anyNonNewline:
      return "(?-s:.)"
    case .dot:
      return "."
    case let .char(c):
      return String(c)
    case let .scalar(s):
      let hex = String(s.value, radix: 16, uppercase: true)
      return "\\u{\(hex)}"._bareQuoted
    case let .unconverted(a):
      return a.ast._regexBase
    case .assertion:
      return ""
    case .characterClass:
      return ""
    case .backreference:
      return ""
    case .symbolicReference:
      return ""
    case .changeMatchingOptions(let matchingOptions):
      var result = ""
      for add in matchingOptions.ast.adding {
        switch add.kind {
        case .reluctantByDefault:
          result += "(?U)"
        default:
          break
        }
      }
      return result
    }
  }
}
extension DSLTree.Node {
  func getNamedCaptures() -> [String] {
    var result: [String] = []
    switch self {
    case .capture(let name?, _, _, _):
      result.append(name)
    case .concatenation(let nodes):
      for node in nodes {
        result += node.getNamedCaptures()
      }
    case .convertedRegexLiteral(let node, _):
      result += node.getNamedCaptures()
    case .quantification(_, _, let node):
      result += node.getNamedCaptures()
    default:
      break
    }
    return result
  }
}
