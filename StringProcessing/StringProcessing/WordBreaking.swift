import Swift
extension Processor {
  func atSimpleBoundary(
    _ usesAsciiWord: Bool,
    _ semanticLevel: MatchingOptions.SemanticLevel
  ) -> Bool {
    func matchesWord(at i: Input.Index) -> Bool {
      switch semanticLevel {
      case .graphemeCluster:
        let c = input[i]
        return c.isWordCharacter && (c.isASCII || !usesAsciiWord)
      case .unicodeScalar:
        let c = input.unicodeScalars[i]
        return (c.properties.isAlphabetic || c == "_") && (c.isASCII || !usesAsciiWord)
      }
    }
    if subjectBounds.isEmpty { return false }
    if currentPosition == subjectBounds.lowerBound {
      return matchesWord(at: currentPosition)
    }
    let priorIdx = semanticLevel == .graphemeCluster
      ? input.index(before: currentPosition)
      : input.unicodeScalars.index(before: currentPosition)
    if currentPosition == subjectBounds.upperBound {
      return matchesWord(at: priorIdx)
    }
    let prior = matchesWord(at: priorIdx)
    let current = matchesWord(at: currentPosition)
    return prior != current
  }
}
extension String {
  func isOnWordBoundary(
    at i: String.Index,
    in range: Range<String.Index>,
    using cache: inout Set<String.Index>?,
    _ maxIndex: inout String.Index?
  ) -> Bool {
    guard i != range.lowerBound, i != range.upperBound else {
      return true
    }
    assert(range.contains(i))
    if let cache = cache, cache.contains(i) {
      return true
    }
    if let maxIndex = maxIndex, i < maxIndex {
      return false
    }
    if #available(SwiftStdlib 5.7, *) {
      var indices: Set<String.Index> = []
      var j = maxIndex ?? range.lowerBound
      while j < range.upperBound, j <= i {
        indices.insert(j)
        j = _wordIndex(after: j)
      }
      cache = indices
      maxIndex = j
      return indices.contains(i)
    } else {
      return false
    }
  }
}
