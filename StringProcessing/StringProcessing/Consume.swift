var checkComments = true
extension Engine {
  func makeProcessor(
    input: String, bounds: Range<String.Index>, matchMode: MatchMode
  ) -> Processor {
    Processor(
      program: program,
      input: input,
      subjectBounds: bounds,
      searchBounds: bounds,
      matchMode: matchMode,
      isTracingEnabled: enableTracing,
      shouldMeasureMetrics: enableMetrics)
  }
  func makeFirstMatchProcessor(
    input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>
  ) -> Processor {
    Processor(
      program: program,
      input: input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds,
      matchMode: .partialFromFront,
      isTracingEnabled: enableTracing,
      shouldMeasureMetrics: enableMetrics)
  }
}
extension Processor {
  mutating func consume() -> Input.Index? {
    while true {
      switch self.state {
      case .accept:
        return self.currentPosition
      case .fail:
        return nil
      case .inProgress: self.cycle()
      }
    }
  }
}
