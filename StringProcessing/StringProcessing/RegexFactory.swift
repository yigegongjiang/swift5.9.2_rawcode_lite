@available(SwiftStdlib 5.7, *)
public struct _RegexFactory {
  public init() {}
  @available(SwiftStdlib 5.8, *)
  public func ignoreCapturesInTypedOutput(
    _ child: some RegexComponent
  ) -> Regex<Substring> {
    child.regex.root.hasChildNodes
      ? .init(node: .ignoreCapturesInTypedOutput(child.regex.root))
      : .init(node: child.regex.root)
  }
  @available(SwiftStdlib 5.7, *)
  public func accumulate<Output>(
    _ left: some RegexComponent,
    _ right: some RegexComponent
  ) -> Regex<Output> {
    .init(node: left.regex.root.appending(right.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func accumulateAlternation<Output>(
    _ left: some RegexComponent,
    _ right: some RegexComponent
  ) -> Regex<Output> {
    .init(node: left.regex.root.appendingAlternationCase(right.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func assertion<Output>(
    _ kind: DSLTree.Atom.Assertion
  ) -> Regex<Output> {
    .init(node: .atom(.assertion(kind)))
  }
  @available(SwiftStdlib 5.7, *)
  public func empty<Output>() -> Regex<Output> {
    .init(node: .empty)
  }
  @available(SwiftStdlib 5.7, *)
  public func scalar<Output>(
    _ scalar: Unicode.Scalar
  ) -> Regex<Output> {
    .init(node: .atom(.scalar(scalar)))
  }
  @available(SwiftStdlib 5.7, *)
  public func characterClass<Output>(
    _ cc: DSLTree.Atom.CharacterClass
  ) -> Regex<Output> {
    .init(node: .atom(.characterClass(cc)))
  }
  @available(SwiftStdlib 5.7, *)
  public func char<Output>(
    _ char: Character
  ) -> Regex<Output> {
    .init(node: .atom(.char(char)))
  }
  @available(SwiftStdlib 5.7, *)
  public func symbolicReference<Output>(
    _ reference: ReferenceID
  ) -> Regex<Output> {
    .init(node: .atom(.symbolicReference(reference)))
  }
  @available(SwiftStdlib 5.7, *)
  public func customCharacterClass<Output>(
    _ ccc: DSLTree.CustomCharacterClass
  ) -> Regex<Output> {
    .init(node: .customCharacterClass(ccc))
  }
  @available(SwiftStdlib 5.7, *)
  public func zeroOrOne<Output>(
    _ component: some RegexComponent,
    _ behavior: RegexRepetitionBehavior? = nil
  ) -> Regex<Output> {
    let kind: DSLTree.QuantificationKind = behavior.map { .explicit($0.dslTreeKind) } ?? .default
    return .init(node: .quantification(.zeroOrOne, kind, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func zeroOrMore<Output>(
    _ component: some RegexComponent,
    _ behavior: RegexRepetitionBehavior? = nil
  ) -> Regex<Output> {
    let kind: DSLTree.QuantificationKind = behavior.map { .explicit($0.dslTreeKind) } ?? .default
    return .init(node: .quantification(.zeroOrMore, kind, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func oneOrMore<Output>(
    _ component: some RegexComponent,
    _ behavior: RegexRepetitionBehavior? = nil
  ) -> Regex<Output> {
    let kind: DSLTree.QuantificationKind = behavior.map { .explicit($0.dslTreeKind) } ?? .default
    return .init(node: .quantification(.oneOrMore, kind, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func exactly<Output>(
    _ count: Int,
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .quantification(.exactly(count), .default, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func repeating<Output>(
    _ range: Range<Int>,
    _ behavior: RegexRepetitionBehavior?,
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .repeating(range, behavior, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func atomicNonCapturing<Output>(
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .nonCapturingGroup(.atomicNonCapturing, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func lookaheadNonCapturing<Output>(
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .nonCapturingGroup(.lookahead, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func negativeLookaheadNonCapturing<Output>(
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .nonCapturingGroup(.negativeLookahead, component.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func orderedChoice<Output>(
    _ component: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .orderedChoice([component.regex.root]))
  }
  @available(SwiftStdlib 5.7, *)
  public func capture<Output>(
    _ r: some RegexComponent
  ) -> Regex<Output> {
    .init(node: .capture(r.regex.root))
  }
  @available(SwiftStdlib 5.7, *)
  public func capture<Output>(
    _ component: some RegexComponent,
    _ reference: Int
  ) -> Regex<Output> {
    .init(node: .capture(
      reference: ReferenceID(reference),
      component.regex.root
    ))
  }
  @available(SwiftStdlib 5.7, *)
  public func capture<Output, W, NewCapture>(
    _ component: some RegexComponent,
    _ reference: Int? = nil,
    _ transform: @escaping (W) throws -> NewCapture
  ) -> Regex<Output> {
    .init(node: .capture(
      reference: reference.map { ReferenceID($0) },
      component.regex.root,
      CaptureTransform(transform)
    ))
  }
  @available(SwiftStdlib 5.7, *)
  public func captureOptional<Output, W, NewCapture>(
    _ component: some RegexComponent,
    _ reference: Int? = nil,
    _ transform: @escaping (W) throws -> NewCapture?
  ) -> Regex<Output> {
    .init(node: .capture(
      reference: reference.map { ReferenceID($0) },
      component.regex.root,
      CaptureTransform(transform)
    ))
  }
}
