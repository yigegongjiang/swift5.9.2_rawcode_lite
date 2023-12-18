extension Collection {
  func _firstMatch<S: MatchingCollectionSearcher>(
    of searcher: S
  ) -> _MatchResult<S>? where S.Searched == Self {
    var state = searcher.state(for: self, in: startIndex..<endIndex)
    return searcher.matchingSearch(self, &state).map { range, result in
      _MatchResult(match: self[range], result: result)
    }
  }
}
extension BidirectionalCollection {
  func lastMatch<S: BackwardMatchingCollectionSearcher>(
    of searcher: S
  ) -> _BackwardMatchResult<S>?
    where S.BackwardSearched == Self
  {
    var state = searcher.backwardState(for: self, in: startIndex..<endIndex)
    return searcher.matchingSearchBack(self, &state).map { range, result in
      _BackwardMatchResult(match: self[range], result: result)
    }
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func firstMatch<Output>(
    of r: some RegexComponent<Output>
  ) -> Regex<Output>.Match? {
    let slice = self[...]
    return try? r.regex.firstMatch(in: slice)
  }
}
