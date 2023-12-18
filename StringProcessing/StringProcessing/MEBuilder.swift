extension MEProgram {
  struct Builder {
    var instructions: [Instruction] = []
    var enableTracing = false
    var enableMetrics = false
    var elements = TypedSetVector<Input.Element, _ElementRegister>()
    var sequences = TypedSetVector<[Input.Element], _SequenceRegister>()
    var asciiBitsets: [DSLTree.CustomCharacterClass.AsciiBitset] = []
    var consumeFunctions: [ConsumeFunction] = []
    var transformFunctions: [TransformFunction] = []
    var matcherFunctions: [MatcherFunction] = []
    var addressTokens: [InstructionAddress?] = []
    var addressFixups: [(InstructionAddress, AddressFixup)] = []
    var nextIntRegister = IntRegister(0)
    var nextCaptureRegister = CaptureRegister(0)
    var nextValueRegister = ValueRegister(0)
    var nextPositionRegister = PositionRegister(0)
    var failAddressToken: AddressToken? = nil
    var captureList = CaptureList()
    var initialOptions = MatchingOptions()
    var canOnlyMatchAtStart = false
    var unresolvedReferences: [ReferenceID: [InstructionAddress]] = [:]
    var referencedCaptureOffsets: [ReferenceID: Int] = [:]
    var captureCount: Int {
      nextCaptureRegister.rawValue
    }
    init() {}
  }
}
extension MEProgram.Builder {
  struct AddressFixup {
    var first: AddressToken
    var second: AddressToken? = nil
    init(_ a: AddressToken) { self.first = a }
    init(_ a: AddressToken, _ b: AddressToken) {
      self.first = a
      self.second = b
    }
  }
}
extension MEProgram.Builder {
  init<S: Sequence>(staticElements: S) where S.Element == Character {
    staticElements.forEach { elements.store($0) }
  }
  var lastInstructionAddress: InstructionAddress {
    .init(instructions.endIndex - 1)
  }
  mutating func buildMoveImmediate(
    _ value: UInt64, into: IntRegister
  ) {
    instructions.append(.init(
      .moveImmediate, .init(immediate: value, int: into)))
  }
  mutating func buildMoveImmediate(
    _ value: Int, into: IntRegister
  ) {
    let uint = UInt64(asserting: value)
    buildMoveImmediate(uint, into: into)
  }
  mutating func buildBranch(to t: AddressToken) {
    instructions.append(.init(.branch))
    fixup(to: t)
  }
  mutating func buildCondBranch(
    to t: AddressToken, ifZeroElseDecrement i: IntRegister
  ) {
    instructions.append(
      .init(.condBranchZeroElseDecrement, .init(int: i)))
    fixup(to: t)
  }
  mutating func buildCondBranch(
    to t: AddressToken,
    ifSamePositionAs r: PositionRegister
  ) {
    instructions.append(.init(.condBranchSamePosition, .init(position: r)))
    fixup(to: t)
  }
  mutating func buildSave(_ t: AddressToken) {
    instructions.append(.init(.save))
    fixup(to: t)
  }
  mutating func buildSaveAddress(_ t: AddressToken) {
    instructions.append(.init(.saveAddress))
    fixup(to: t)
  }
  mutating func buildSplit(
    to: AddressToken, saving: AddressToken
  ) {
    instructions.append(.init(.splitSaving))
    fixup(to: (to, saving))
  }
  mutating func buildClear() {
    instructions.append(.init(.clear))
  }
  mutating func buildClearThrough(_ t: AddressToken) {
    instructions.append(.init(.clearThrough))
    fixup(to: t)
  }
  mutating func buildFail() {
    instructions.append(.init(.fail))
  }
  mutating func buildAdvance(_ n: Distance) {
    instructions.append(.init(.advance, .init(distance: n)))
  }
  mutating func buildAdvanceUnicodeScalar(_ n: Distance) {
    instructions.append(
      .init(.advance, .init(distance: n, isScalarDistance: true)))
  }
  mutating func buildConsumeNonNewline() {
    instructions.append(.init(.matchAnyNonNewline, .init(isScalar: false)))
  }
  mutating func buildConsumeScalarNonNewline() {
    instructions.append(.init(.matchAnyNonNewline, .init(isScalar: true)))
  }
  mutating func buildMatch(_ e: Character, isCaseInsensitive: Bool) {
    instructions.append(.init(
      .match, .init(element: elements.store(e), isCaseInsensitive: isCaseInsensitive)))
  }
  mutating func buildMatchScalar(_ s: Unicode.Scalar, boundaryCheck: Bool) {
    instructions.append(.init(.matchScalar, .init(scalar: s, caseInsensitive: false, boundaryCheck: boundaryCheck)))
  }
  mutating func buildMatchScalarCaseInsensitive(_ s: Unicode.Scalar, boundaryCheck: Bool) {
    instructions.append(.init(.matchScalar, .init(scalar: s, caseInsensitive: true, boundaryCheck: boundaryCheck)))
  }
  mutating func buildMatchAsciiBitset(
    _ b: DSLTree.CustomCharacterClass.AsciiBitset
  ) {
    instructions.append(.init(
      .matchBitset, .init(bitset: makeAsciiBitset(b), isScalar: false)))
  }
  mutating func buildScalarMatchAsciiBitset(
    _ b: DSLTree.CustomCharacterClass.AsciiBitset
  ) {
    instructions.append(.init(
      .matchBitset, .init(bitset: makeAsciiBitset(b), isScalar: true)))
  }
  mutating func buildMatchBuiltin(model: _CharacterClassModel) {
    instructions.append(.init(
      .matchBuiltin, .init(model)))
  }
  mutating func buildConsume(
    by p: @escaping MEProgram.ConsumeFunction
  ) {
    instructions.append(.init(
      .consumeBy, .init(consumer: makeConsumeFunction(p))))
  }
  mutating func buildAssert(
    by kind: DSLTree.Atom.Assertion,
    _ anchorsMatchNewlines: Bool,
    _ usesSimpleUnicodeBoundaries: Bool,
    _ usesASCIIWord: Bool,
    _ semanticLevel: MatchingOptions.SemanticLevel
  ) {
    let payload = AssertionPayload.init(
      kind,
      anchorsMatchNewlines,
      usesSimpleUnicodeBoundaries,
      usesASCIIWord,
      semanticLevel)
    instructions.append(.init(
      .assertBy,
      .init(assertion: payload)))
  }
  mutating func buildQuantify(
    bitset: DSLTree.CustomCharacterClass.AsciiBitset,
    _ kind: AST.Quantification.Kind,
    _ minTrips: Int,
    _ extraTrips: Int?,
    isScalarSemantics: Bool
  ) {
    instructions.append(.init(
      .quantify,
      .init(quantify: .init(bitset: makeAsciiBitset(bitset), kind, minTrips, extraTrips, isScalarSemantics: isScalarSemantics))))
  }
  mutating func buildQuantify(
    asciiChar: UInt8,
    _ kind: AST.Quantification.Kind,
    _ minTrips: Int,
    _ extraTrips: Int?,
    isScalarSemantics: Bool
  ) {
    instructions.append(.init(
      .quantify,
      .init(quantify: .init(asciiChar: asciiChar, kind, minTrips, extraTrips, isScalarSemantics: isScalarSemantics))))
  }
  mutating func buildQuantifyAny(
    matchesNewlines: Bool,
    _ kind: AST.Quantification.Kind,
    _ minTrips: Int,
    _ extraTrips: Int?,
    isScalarSemantics: Bool
  ) {
    instructions.append(.init(
      .quantify,
      .init(quantify: .init(matchesNewlines: matchesNewlines, kind, minTrips, extraTrips, isScalarSemantics: isScalarSemantics))))
  }
  mutating func buildQuantify(
    model: _CharacterClassModel,
    _ kind: AST.Quantification.Kind,
    _ minTrips: Int,
    _ extraTrips: Int?,
    isScalarSemantics: Bool
  ) {
    instructions.append(.init(
      .quantify,
      .init(quantify: .init(model: model,kind, minTrips, extraTrips, isScalarSemantics: isScalarSemantics))))
  }
  mutating func buildAccept() {
    instructions.append(.init(.accept))
  }
  mutating func buildBeginCapture(
    _ cap: CaptureRegister
  ) {
    instructions.append(
      .init(.beginCapture, .init(capture: cap)))
  }
  mutating func buildEndCapture(
    _ cap: CaptureRegister
  ) {
    instructions.append(
      .init(.endCapture, .init(capture: cap)))
  }
  mutating func buildTransformCapture(
    _ cap: CaptureRegister, _ trans: TransformRegister
  ) {
    instructions.append(.init(
      .transformCapture,
      .init(capture: cap, transform: trans)))
  }
  mutating func buildMatcher(
    _ fun: MatcherRegister, into reg: ValueRegister
  ) {
    instructions.append(.init(
      .matchBy,
      .init(matcher: fun, value: reg)))
  }
  mutating func buildMove(
    _ value: ValueRegister, into capture: CaptureRegister
  ) {
    instructions.append(.init(
      .captureValue,
      .init(value: value, capture: capture)))
  }
  mutating func buildMoveCurrentPosition(into r: PositionRegister) {
    instructions.append(.init(.moveCurrentPosition, .init(position: r)))
  }
  mutating func buildBackreference(
    _ cap: CaptureRegister,
    isScalarMode: Bool
  ) {
    instructions.append(
      .init(.backreference, .init(capture: cap, isScalarMode: isScalarMode)))
  }
  mutating func buildUnresolvedReference(id: ReferenceID, isScalarMode: Bool) {
    buildBackreference(.init(0), isScalarMode: isScalarMode)
    unresolvedReferences[id, default: []].append(lastInstructionAddress)
  }
  mutating func buildNamedReference(_ name: String, isScalarMode: Bool) throws {
    guard let index = captureList.indexOfCapture(named: name) else {
      throw RegexCompilationError.uncapturedReference
    }
    buildBackreference(.init(index), isScalarMode: isScalarMode)
  }
  mutating func assemble() throws -> MEProgram {
    try resolveReferences()
    if let tok = failAddressToken {
      label(tok)
      buildFail()
    }
    var instructions = instructions
    for (instAddr, tok) in addressFixups {
      let inst = instructions[instAddr.rawValue]
      let addr = addressTokens[tok.first.rawValue]!
      let payload: Instruction.Payload
      switch inst.opcode {
      case .condBranchZeroElseDecrement:
        payload = .init(addr: addr, int: inst.payload.int)
      case .condBranchSamePosition:
        payload = .init(addr: addr, position: inst.payload.position)
      case .branch, .save, .saveAddress, .clearThrough:
        payload = .init(addr: addr)
      case .splitSaving:
        guard let fix2 = tok.second else {
          throw Unreachable("TODO: reason")
        }
        let saving = addressTokens[fix2.rawValue]!
        payload = .init(addr: addr, addr2: saving)
      default: throw Unreachable("TODO: reason")
      }
      instructions[instAddr.rawValue] = .init(
        inst.opcode, payload)
    }
    var regInfo = MEProgram.RegisterInfo()
    regInfo.elements = elements.count
    regInfo.sequences = sequences.count
    regInfo.ints = nextIntRegister.rawValue
    regInfo.values = nextValueRegister.rawValue
    regInfo.positions = nextPositionRegister.rawValue
    regInfo.bitsets = asciiBitsets.count
    regInfo.consumeFunctions = consumeFunctions.count
    regInfo.transformFunctions = transformFunctions.count
    regInfo.matcherFunctions = matcherFunctions.count
    regInfo.captures = nextCaptureRegister.rawValue
    return MEProgram(
      canOnlyMatchAtStart: canOnlyMatchAtStart,
      instructions: InstructionList(instructions),
      staticElements: elements.stored,
      staticSequences: sequences.stored,
      staticBitsets: asciiBitsets,
      staticConsumeFunctions: consumeFunctions,
      staticTransformFunctions: transformFunctions,
      staticMatcherFunctions: matcherFunctions,
      registerInfo: regInfo,
      enableTracing: enableTracing,
      enableMetrics: enableMetrics,
      captureList: captureList,
      referencedCaptureOffsets: referencedCaptureOffsets,
      initialOptions: initialOptions)
  }
  mutating func reset() { self = Self() }
}
extension MEProgram.Builder {
  enum _AddressToken {}
  typealias AddressToken = TypedInt<_AddressToken>
  mutating func makeAddress() -> AddressToken {
    defer { addressTokens.append(nil) }
    return AddressToken(addressTokens.count)
  }
  mutating func resolve(_ t: AddressToken) {
    assert(!instructions.isEmpty)
    addressTokens[t.rawValue] =
      InstructionAddress(instructions.count &- 1)
  }
  mutating func label(_ t: AddressToken) {
    addressTokens[t.rawValue] =
      InstructionAddress(instructions.count)
  }
  mutating func fixup(to t: AddressToken) {
    assert(!instructions.isEmpty)
    addressFixups.append(
      (InstructionAddress(instructions.endIndex-1), .init(t)))
  }
  mutating func fixup(
    to ts: (AddressToken, AddressToken)
  ) {
    assert(!instructions.isEmpty)
    addressFixups.append((
      InstructionAddress(instructions.endIndex-1),
      .init(ts.0, ts.1)))
  }
  mutating func pushEmptySavePoint() {
    if failAddressToken == nil {
      failAddressToken = makeAddress()
    }
    buildSaveAddress(failAddressToken!)
  }
}
fileprivate extension MEProgram.Builder {
  mutating func resolveReferences() throws {
    for (id, uses) in unresolvedReferences {
      guard let offset = referencedCaptureOffsets[id] else {
        throw RegexCompilationError.uncapturedReference
      }
      for use in uses {
        let (isScalarMode, _) = instructions[use.rawValue].payload.captureAndMode
        instructions[use.rawValue] =
          Instruction(.backreference,
            .init(capture: .init(offset), isScalarMode: isScalarMode))
      }
    }
  }
}
extension MEProgram.Builder {
  mutating func makeCapture(
    id: ReferenceID?, name: String?
  ) -> CaptureRegister {
    defer { nextCaptureRegister.rawValue += 1 }
    if let id = id {
      let preexistingValue = referencedCaptureOffsets.updateValue(
        captureCount, forKey: id)
      assert(preexistingValue == nil)
    }
    if let name = name {
      let index = captureList.indexOfCapture(named: name)
      assert(index == nextCaptureRegister.rawValue)
    }
    assert(nextCaptureRegister.rawValue < captureList.captures.count)
    return nextCaptureRegister
  }
  mutating func makeIntRegister() -> IntRegister {
    defer { nextIntRegister.rawValue += 1 }
    return nextIntRegister
  }
  mutating func makeValueRegister() -> ValueRegister {
    defer { nextValueRegister.rawValue += 1 }
    return nextValueRegister
  }
  mutating func makeIntRegister(
    initialValue: Int
  ) -> IntRegister {
    let r = makeIntRegister()
    self.buildMoveImmediate(initialValue, into: r)
    return r
  }
  mutating func makePositionRegister() -> PositionRegister {
    let r = nextPositionRegister
    defer { nextPositionRegister.rawValue += 1 }
    return r
  }
  mutating func makeAsciiBitset(
    _ b: DSLTree.CustomCharacterClass.AsciiBitset
  ) -> AsciiBitsetRegister {
    defer { asciiBitsets.append(b) }
    return AsciiBitsetRegister(asciiBitsets.count)
  }
  mutating func makeConsumeFunction(
    _ f: @escaping MEProgram.ConsumeFunction
  ) -> ConsumeFunctionRegister {
    defer { consumeFunctions.append(f) }
    return ConsumeFunctionRegister(consumeFunctions.count)
  }
  mutating func makeTransformFunction(
    _ f: @escaping MEProgram.TransformFunction
  ) -> TransformRegister {
    defer { transformFunctions.append(f) }
    return TransformRegister(transformFunctions.count)
  }
  mutating func makeMatcherFunction(
    _ f: @escaping MEProgram.MatcherFunction
  ) -> MatcherRegister {
    defer { matcherFunctions.append(f) }
    return MatcherRegister(matcherFunctions.count)
  }
}
