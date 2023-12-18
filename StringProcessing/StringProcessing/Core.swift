@available(SwiftStdlib 5.7, *)
public protocol RegexComponent<RegexOutput> {
  associatedtype RegexOutput
  var regex: Regex<RegexOutput> { get }
}
@available(SwiftStdlib 5.7, *)
public struct Regex<Output>: RegexComponent {
  let program: Program
  var hasCapture: Bool {
    program.tree.hasCapture
  }
  init(ast: AST) {
    self.program = Program(ast: ast)
  }
  init(ast: AST.Node) {
    self.program = Program(ast:
        .init(ast, globalOptions: nil, diags: Diagnostics()))
  }
  @usableFromInline
  init(_regexString pattern: String) {
    self.init(ast: try! parse(pattern, .traditional))
  }
  @usableFromInline
  init(_regexString pattern: String, version: Int) {
    assert(version == currentRegexLiteralFormatVersion)
    self.init(ast: try! parseWithDelimiters(pattern))
  }
  public var regex: Regex<Output> {
    self
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  @available(*, deprecated, renamed: "init(verbatim:)")
  public init(quoting _string: String) {
    self.init(node: .quotedLiteral(_string))
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  internal final class Program {
    let tree: DSLTree
    fileprivate var compileOptions: _CompileOptions = .default
    private final class ProgramBox {
      let value: MEProgram
      init(_ value: MEProgram) { self.value = value }
    }
    fileprivate var _loweredProgramStorage: AnyObject? = nil
    var loweredProgram: MEProgram {
      func loadProgram() -> MEProgram? {
        guard let loweredObject = _stdlib_atomicLoadARCRef(object: &_loweredProgramStorage)
          else { return nil }
        return unsafeDowncast(loweredObject, to: ProgramBox.self).value
      }
      if let program = loadProgram() {
        return program
      }
      let compiledProgram = try! Compiler(tree: tree, compileOptions: compileOptions).emit()
      let storedNewProgram = _stdlib_atomicInitializeARCRef(
        object: &_loweredProgramStorage,
        desired: ProgramBox(compiledProgram))
      return storedNewProgram
        ? compiledProgram
        : loadProgram()!
    }
    init(ast: AST) {
      self.tree = ast.dslTree
    }
    init(tree: DSLTree) {
      self.tree = tree
    }
  }
  var initialOptions: MatchingOptions {
    program.loweredProgram.initialOptions
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  var root: DSLTree.Node {
    program.tree.root
  }
  init(node: DSLTree.Node) {
    self.program = Program(tree: .init(node))
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  public enum _RegexInternalAction {
    case recompile
    case addOptions(_CompileOptions)
  }
  public mutating func _forceAction(_ action: _RegexInternalAction) -> Bool {
    do {
      switch action {
      case .addOptions(let opts):
        program.compileOptions.insert(opts)
        program._loweredProgramStorage = nil
        return true
      case .recompile:
        let _ = try Compiler(
          tree: program.tree,
          compileOptions: program.compileOptions).emit()
        return true
      }
    } catch {
      return false
    }
  }
}
