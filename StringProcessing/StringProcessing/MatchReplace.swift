extension RangeReplaceableCollection {
  func _replacing<
    Searcher: MatchingCollectionSearcher, Replacement: Collection
  >(
    _ searcher: Searcher,
    with replacement: (_MatchResult<Searcher>) throws -> Replacement,
    subrange: Range<Index>,
    maxReplacements: Int = .max
  ) rethrows -> Self where Searcher.Searched == SubSequence,
                  Replacement.Element == Element
  {
    precondition(maxReplacements >= 0)
    var index = subrange.lowerBound
    var result = Self()
    result.append(contentsOf: self[..<index])
    for match in self[subrange]._matches(of: searcher)
          .prefix(maxReplacements)
    {
      result.append(contentsOf: self[index..<match.range.lowerBound])
      result.append(contentsOf: try replacement(match))
      index = match.range.upperBound
    }
    result.append(contentsOf: self[index...])
    return result
  }
  func _replacing<
    Searcher: MatchingCollectionSearcher, Replacement: Collection
  >(
    _ searcher: Searcher,
    with replacement: (_MatchResult<Searcher>) throws -> Replacement,
    maxReplacements: Int = .max
  ) rethrows -> Self where Searcher.Searched == SubSequence,
                           Replacement.Element == Element
  {
    try _replacing(
      searcher,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
  mutating func _replace<
    Searcher: MatchingCollectionSearcher, Replacement: Collection
  >(
    _ searcher: Searcher,
    with replacement: (_MatchResult<Searcher>) throws -> Replacement,
    maxReplacements: Int = .max
  ) rethrows where Searcher.Searched == SubSequence,
                   Replacement.Element == Element
  {
    self = try _replacing(
      searcher,
      with: replacement,
      maxReplacements: maxReplacements)
  }
}
extension RangeReplaceableCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func replacing<Output, Replacement: Collection>(
    _ regex: some RegexComponent<Output>,
    subrange: Range<Index>,
    maxReplacements: Int = .max,
    with replacement: (Regex<Output>.Match) throws -> Replacement
  ) rethrows -> Self where Replacement.Element == Element {
    precondition(maxReplacements >= 0)
    var index = subrange.lowerBound
    var result = Self()
    result.append(contentsOf: self[..<index])
    for match in self[subrange].matches(of: regex)
      .prefix(maxReplacements)
    {
      result.append(contentsOf: self[index..<match.range.lowerBound])
      result.append(contentsOf: try replacement(match))
      index = match.range.upperBound
    }
    result.append(contentsOf: self[index...])
    return result
  }
  @available(SwiftStdlib 5.7, *)
  public func replacing<Output, Replacement: Collection>(
    _ regex: some RegexComponent<Output>,
    maxReplacements: Int = .max,
    with replacement: (Regex<Output>.Match) throws -> Replacement
  ) rethrows -> Self where Replacement.Element == Element {
    try replacing(
      regex,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements,
      with: replacement)
  }
  @available(SwiftStdlib 5.7, *)
  public mutating func replace<Output, Replacement: Collection>(
    _ regex: some RegexComponent<Output>,
    maxReplacements: Int = .max,
    with replacement: (Regex<Output>.Match) throws -> Replacement
  ) rethrows where Replacement.Element == Element {
    self = try replacing(
      regex,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements,
      with: replacement)
  }
}
