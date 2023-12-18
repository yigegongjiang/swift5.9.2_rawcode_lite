@available(SwiftStdlib 5.7, *)
public struct AnyRegexOutput {
  internal let input: String
  internal var _elements: [ElementRepresentation]
}
@available(SwiftStdlib 5.7, *)
extension AnyRegexOutput {
  public init<Output>(_ match: Regex<Output>.Match) {
    self = match.anyRegexOutput
  }
  public func extractValues<Output>(
    as outputType: Output.Type = Output.self
  ) -> Output? {
    let elements = map {
      $0.existentialOutputComponent(from: input)
    }
    return TypeConstruction.tuple(of: elements) as? Output
  }
}
@available(SwiftStdlib 5.7, *)
extension AnyRegexOutput: RandomAccessCollection {
  public struct Element {
    internal let representation: ElementRepresentation
    internal let input: String
    public var range: Range<String.Index>? {
      representation.content?.range
    }
    public var substring: Substring? {
      range.map { input[$0] }
    }
    public var value: Any? {
      representation.value(forInput: input)
    }
    public var type: Any.Type {
      representation.type
    }
    public var name: String? {
      representation.name
    }
    var isOptional: Bool {
      representation.optionalDepth != 0
    }
  }
  public var startIndex: Int {
    _elements.startIndex
  }
  public var endIndex: Int {
    _elements.endIndex
  }
  public var count: Int {
    _elements.count
  }
  public func index(after i: Int) -> Int {
    _elements.index(after: i)
  }
  public func index(before i: Int) -> Int {
    _elements.index(before: i)
  }
  public subscript(position: Int) -> Element {
    .init(representation: _elements[position], input: input)
  }
}
@available(SwiftStdlib 5.7, *)
extension AnyRegexOutput {
  public subscript(name: String) -> Element? {
    first {
      $0.name == name
    }
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex.Match where Output == AnyRegexOutput {
  public subscript(
    dynamicMember _keyPath: KeyPath<(Substring, _doNotUse: ()), Substring>
  ) -> Substring {
    anyRegexOutput.input[range]
  }
  public subscript(name: String) -> AnyRegexOutput.Element? {
    anyRegexOutput.first {
      $0.name == name
    }
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex where Output == AnyRegexOutput {
  public init(_ pattern: String) throws {
    self.init(ast: try parse(pattern, .traditional))
  }
  internal init(_ pattern: String, syntax: SyntaxOptions) throws {
    self.init(ast: try parse(pattern, syntax))
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  public init(
    _ pattern: String,
    as outputType: Output.Type = Output.self
  ) throws {
    let regex = Regex(ast: try parse(pattern, .traditional))
    let (isSuccess, correctType) = regex._verifyType()
    guard isSuccess else {
      throw RegexCompilationError.incorrectOutputType(
        incorrect: Output.self,
        correct: correctType
      )
    }
    self = regex
  }
  public init(verbatim verbatimString: String) {
    self.init(node: .quotedLiteral(verbatimString))
  }
  public func contains(captureNamed name: String) -> Bool {
    program.tree.captureList.captures.contains(where: {
      $0.name == name
    })
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex where Output == AnyRegexOutput {
  public init<OtherOutput>(_ regex: Regex<OtherOutput>) {
    self.init(node: regex.root)
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex.Match where Output == AnyRegexOutput {
  public init<OtherOutput>(_ match: Regex<OtherOutput>.Match) {
    self.init(
      anyRegexOutput: match.anyRegexOutput,
      range: match.range
    )
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  public init?(
    _ regex: Regex<AnyRegexOutput>,
    as outputType: Output.Type = Output.self
  ) {
    self.init(node: regex.root)
    guard _verifyType().0 else {
      return nil
    }
  }
}
@available(SwiftStdlib 5.7, *)
extension AnyRegexOutput {
  internal struct ElementRepresentation {
    let optionalDepth: Int
    let content: (range: Range<String.Index>, value: Any?)?
    var name: String? = nil
    var referenceID: ReferenceID? = nil
    var visibleInTypedOutput: Bool
  }
  internal init(input: String, elements: [ElementRepresentation]) {
    self.init(input: input, _elements: elements)
  }
}
@available(SwiftStdlib 5.7, *)
extension AnyRegexOutput.ElementRepresentation {
  fileprivate func value(forInput input: String) -> Any {
    constructExistentialOutputComponent(
      from: input,
      component: content,
      optionalCount: optionalDepth
    )
  }
  var type: Any.Type {
    content?.value.map { Swift.type(of: $0) }
      ?? TypeConstruction.optionalType(of: Substring.self, depth: optionalDepth)
  }
}
