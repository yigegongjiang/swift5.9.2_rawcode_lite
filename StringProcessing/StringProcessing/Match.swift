@available(SwiftStdlib 5.7, *)
extension Regex {
  @dynamicMemberLookup
  public struct Match {
    let anyRegexOutput: AnyRegexOutput
    public let range: Range<String.Index>
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex.Match {
  var input: String {
    anyRegexOutput.input
  }
  public var output: Output {
    if Output.self == AnyRegexOutput.self {
      return anyRegexOutput as! Output
    }
    let typeErasedMatch = anyRegexOutput.existentialOutput(
      from: anyRegexOutput.input
    )
    return typeErasedMatch as! Output
  }
  public subscript<T>(dynamicMember keyPath: KeyPath<Output, T>) -> T {
    guard let outputTupleOffset = MemoryLayout.tupleElementIndex(
      of: keyPath, elementTypes: anyRegexOutput.map(\.type)
    ) else {
      return output[keyPath: keyPath]
    }
    return anyRegexOutput[outputTupleOffset].value as! T
  }
  public subscript(
    dynamicMember _keyPath: KeyPath<(Output, _doNotUse: ()), Output>
  ) -> Output {
    output
  }
  public subscript<Capture>(_ id: ReferenceID) -> Capture {
    guard let element = anyRegexOutput.first(
      where: { $0.representation.referenceID == id }
    ) else {
      preconditionFailure("Reference did not capture any match in the regex")
    }
    return element.existentialOutputComponent(
      from: input
    ) as! Capture
  }
}
@available(SwiftStdlib 5.7, *)
extension Regex {
  public func wholeMatch(in string: String) throws -> Regex<Output>.Match? {
    try _match(string, in: string.startIndex..<string.endIndex, mode: .wholeString)
  }
  public func prefixMatch(in string: String) throws -> Regex<Output>.Match? {
    try _match(string, in: string.startIndex..<string.endIndex, mode: .partialFromFront)
  }
  public func firstMatch(in string: String) throws -> Regex<Output>.Match? {
    try _firstMatch(string, in: string.startIndex..<string.endIndex)
  }
  public func wholeMatch(in string: Substring) throws -> Regex<Output>.Match? {
    try _match(string.base, in: string.startIndex..<string.endIndex, mode: .wholeString)
  }
  public func prefixMatch(in string: Substring) throws -> Regex<Output>.Match? {
    try _match(string.base, in: string.startIndex..<string.endIndex, mode: .partialFromFront)
  }
  public func firstMatch(in string: Substring) throws -> Regex<Output>.Match? {
    try _firstMatch(string.base, in: string.startIndex..<string.endIndex)
  }
  func _match(
    _ input: String,
    in subjectBounds: Range<String.Index>,
    mode: MatchMode = .wholeString
  ) throws -> Regex<Output>.Match? {
    let executor = Executor(program: regex.program.loweredProgram)
    return try executor.match(input, in: subjectBounds, mode)
  }
  func _firstMatch(
    _ input: String,
    in subjectBounds: Range<String.Index>
  ) throws -> Regex<Output>.Match? {
    try regex.program.loweredProgram.canOnlyMatchAtStart
      ? _match(input, in: subjectBounds, mode: .partialFromFront)
      : _firstMatch(input, subjectBounds: subjectBounds, searchBounds: subjectBounds)
  }
  func _firstMatch(
    _ input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>
  ) throws -> Regex<Output>.Match? {
    let executor = Executor(program: regex.program.loweredProgram)
    let graphemeSemantic = regex.initialOptions.semanticLevel == .graphemeCluster
    return try executor.firstMatch(
      input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds,
      graphemeSemantic: graphemeSemantic)
  }
}
@available(SwiftStdlib 5.7, *)
extension BidirectionalCollection where SubSequence == Substring {
  public func wholeMatch<R: RegexComponent>(
    of regex: R
  ) -> Regex<R.RegexOutput>.Match? {
    try? regex.regex.wholeMatch(in: self[...])
  }
  public func prefixMatch<R: RegexComponent>(
    of regex: R
  ) -> Regex<R.RegexOutput>.Match? {
    try? regex.regex.prefixMatch(in: self[...])
  }
}
