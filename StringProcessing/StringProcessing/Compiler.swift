class Compiler {
  let tree: DSLTree
  var options = MatchingOptions()
  private var compileOptions: _CompileOptions = .default
  init(ast: AST) {
    self.tree = ast.dslTree
  }
  init(tree: DSLTree) {
    self.tree = tree
  }
  init(tree: DSLTree, compileOptions: _CompileOptions) {
    self.tree = tree
    self.compileOptions = compileOptions
  }
  __consuming func emit() throws -> MEProgram {
    var codegen = ByteCodeGen(
      options: options,
      compileOptions:
        compileOptions,
      captureList: tree.captureList)
    return try codegen.emitRoot(tree.root)
  }
}
struct AnyHashableType: CustomStringConvertible, Hashable {
  var ty: Any.Type
  init(_ ty: Any.Type) {
    self.ty = ty
  }
  var description: String { "\(ty)" }
  static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.ty == rhs.ty
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(ty))
  }
}
enum RegexCompilationError: Error, Hashable, CustomStringConvertible {
  case uncapturedReference
  case incorrectOutputType(incorrect: AnyHashableType, correct: AnyHashableType)
  case invalidCharacterClassRangeOperand(Character)
  static func incorrectOutputType(
    incorrect: Any.Type, correct: Any.Type
  ) -> Self {
    .incorrectOutputType(incorrect: .init(incorrect), correct: .init(correct))
  }
  var description: String {
    switch self {
    case .uncapturedReference:
      return "Found a reference used before it captured any match."
    case .incorrectOutputType(let incorrect, let correct):
      return "Cast to incorrect type 'Regex<\(incorrect)>', expected 'Regex<\(correct)>'"
    case .invalidCharacterClassRangeOperand(let c):
      return "'\(c)' is an invalid bound for character class range"
    }
  }
}
@available(SwiftStdlib 5.7, *)
func _compileRegex(
  _ regex: String,
  _ syntax: SyntaxOptions = .traditional,
  _ semanticLevel: RegexSemanticLevel? = nil
) throws -> Executor {
  let ast = try parse(regex, syntax)
  let dsl: DSLTree
  switch semanticLevel?.base {
  case .graphemeCluster:
    let sequence = AST.MatchingOptionSequence(adding: [.init(.graphemeClusterSemantics, location: .fake)])
    dsl = DSLTree(.nonCapturingGroup(.init(ast: .changeMatchingOptions(sequence)), ast.dslTree.root))
  case .unicodeScalar:
    let sequence = AST.MatchingOptionSequence(adding: [.init(.unicodeScalarSemantics, location: .fake)])
    dsl = DSLTree(.nonCapturingGroup(.init(ast: .changeMatchingOptions(sequence)), ast.dslTree.root))
  case .none:
    dsl = ast.dslTree
  }
  let program = try Compiler(tree: dsl).emit()
  return Executor(program: program)
}
public struct _CompileOptions: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  public static let disableOptimizations = _CompileOptions(rawValue: 1 << 0)
  public static let enableTracing = _CompileOptions(rawValue: 1 << 1)
  public static let enableMetrics = _CompileOptions(rawValue: 1 << 2)
  public static let `default`: _CompileOptions = []
}
