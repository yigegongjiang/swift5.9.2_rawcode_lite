extension Collection {
  func _contains<Searcher: CollectionSearcher>(
    _ searcher: Searcher
  ) -> Bool where Searcher.Searched == Self {
    _firstRange(of: searcher) != nil
  }
}
extension Collection where Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public func contains<C: Collection>(_ other: C) -> Bool
    where C.Element == Element
  {
    firstRange(of: other) != nil
  }
}
extension BidirectionalCollection where Element: Comparable {
  func _contains<C: Collection>(_ other: C) -> Bool
    where C.Element == Element
  {
    if #available(SwiftStdlib 5.7, *) {
      return firstRange(of: other) != nil
    }
    fatalError()
  }
}
extension StringProtocol {
  @available(SwiftStdlib 5.7, *)
  public func contains(_ other: String) -> Bool {
    firstRange(of: other) != nil
  }
  @available(SwiftStdlib 5.7, *)
  public func contains(_ other: Substring) -> Bool {
    firstRange(of: other) != nil
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func contains(_ regex: some RegexComponent) -> Bool {
    (try? regex.regex.firstMatch(in: self[...])) != nil
  }
}
