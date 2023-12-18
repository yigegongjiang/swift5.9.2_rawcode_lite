@available(SwiftStdlib 5.7, *)
public protocol CustomConsumingRegexComponent: RegexComponent {
  func consuming(
    _ input: String,
    startingAt index: String.Index,
    in bounds: Range<String.Index>
  ) throws -> (upperBound: String.Index, output: RegexOutput)?
}
@available(SwiftStdlib 5.7, *)
extension CustomConsumingRegexComponent {
  public var regex: Regex<RegexOutput> {
    let node: DSLTree.Node = .matcher(RegexOutput.self, { input, index, bounds in
      try consuming(input, startingAt: index, in: bounds)
    })
    return Regex(node: node)
  }
}
