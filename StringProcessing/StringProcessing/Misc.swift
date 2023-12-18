extension Array {
  func coalescing<T>(
    with initialAccumulator: T, into finish: (T) -> Self,
    accumulate: (inout T, Element) -> Bool
  ) -> Self {
    var didAccumulate = false
    var accumulator = initialAccumulator
    var result = Self()
    for elt in self {
      if accumulate(&accumulator, elt) {
        didAccumulate = true
        continue
      }
      if didAccumulate {
        result += finish(accumulator)
        accumulator = initialAccumulator
        didAccumulate = false
      }
      result.append(elt)
    }
    if didAccumulate {
      result += finish(accumulator)
    }
    return result
  }
  func coalescing<T>(
    with initialAccumulator: T, into finish: (T) -> Element,
    accumulate: (inout T, Element) -> Bool
  ) -> Self {
    coalescing(
      with: initialAccumulator, into: { [finish($0) ]}, accumulate: accumulate)
  }
}
enum QuickResult<R> {
  case definite(_ r: R)
  case unknown
}
