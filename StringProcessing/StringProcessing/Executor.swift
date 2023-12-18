struct Executor {
  var engine: Engine
  init(program: MEProgram) {
    self.engine = Engine(program)
  }
  @available(SwiftStdlib 5.7, *)
  func firstMatch<Output>(
    _ input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>,
    graphemeSemantic: Bool
  ) throws -> Regex<Output>.Match? {
    var cpu = engine.makeFirstMatchProcessor(
      input: input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds)
#if PROCESSOR_MEASUREMENTS_ENABLED
    defer { if cpu.metrics.shouldMeasureMetrics { cpu.printMetrics() } }
#endif
    var low = searchBounds.lowerBound
    let high = searchBounds.upperBound
    while true {
      if let m: Regex<Output>.Match = try _match(
        input, from: low, using: &cpu
      ) {
        return m
      }
      if low >= high { return nil }
      if graphemeSemantic {
        low = input.index(
          low, offsetBy: 1, limitedBy: searchBounds.upperBound) ?? searchBounds.upperBound
      } else {
        input.unicodeScalars.formIndex(after: &low)
      }
      cpu.reset(currentPosition: low)
    }
  }
  @available(SwiftStdlib 5.7, *)
  func match<Output>(
    _ input: String,
    in subjectBounds: Range<String.Index>,
    _ mode: MatchMode
  ) throws -> Regex<Output>.Match? {
    var cpu = engine.makeProcessor(
      input: input, bounds: subjectBounds, matchMode: mode)
#if PROCESSOR_MEASUREMENTS_ENABLED
    defer { if cpu.metrics.shouldMeasureMetrics { cpu.printMetrics() } }
#endif
    return try _match(input, from: subjectBounds.lowerBound, using: &cpu)
  }
  @available(SwiftStdlib 5.7, *)
  func _match<Output>(
    _ input: String,
    from currentPosition: String.Index,
    using cpu: inout Processor
  ) throws -> Regex<Output>.Match? {
    guard let endIdx = cpu.consume() else {
      if let e = cpu.failureReason {
        throw e
      }
      return nil
    }
    let capList = MECaptureList(
      values: cpu.storedCaptures,
      referencedCaptureOffsets: engine.program.referencedCaptureOffsets)
    let range = currentPosition..<endIdx
    let caps = engine.program.captureList.createElements(capList)
    let anyRegexOutput = AnyRegexOutput(input: input, elements: caps)
    return .init(anyRegexOutput: anyRegexOutput, range: range)
  }
  @available(SwiftStdlib 5.7, *)
  func dynamicMatch(
    _ input: String,
    in subjectBounds: Range<String.Index>,
    _ mode: MatchMode
  ) throws -> Regex<AnyRegexOutput>.Match? {
    try match(input, in: subjectBounds, mode)
  }
}
