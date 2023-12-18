extension Collection {
  func _firstRange<S: CollectionSearcher>(
    of searcher: S
  ) -> Range<Index>? where S.Searched == Self {
    var state = searcher.state(for: self, in: startIndex..<endIndex)
    return searcher.search(self, &state)
  }
}
extension Collection where Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public func firstRange<C: Collection>(
    of other: C
  ) -> Range<Index>? where C.Element == Element {
    let searcher = ZSearcher<SubSequence>(pattern: Array(other), by: ==)
    return searcher.search(self[...], in: startIndex..<endIndex)
  }
}
extension BidirectionalCollection where Element: Comparable {
  @available(SwiftStdlib 5.7, *)
  public func firstRange<C: Collection>(
    of other: C
  ) -> Range<Index>? where C.Element == Element {
    let searcher = ZSearcher<SubSequence>(pattern: Array(other), by: ==)
    return searcher.search(self[...], in: startIndex..<endIndex)
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func firstRange(of regex: some RegexComponent) -> Range<Index>? {
    let s = self[...]
    return try? regex.regex.firstMatch(in: s)?.range
  }
}
