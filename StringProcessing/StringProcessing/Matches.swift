struct MatchesCollection<Searcher: MatchingCollectionSearcher> {
  public typealias Base = Searcher.Searched
  let base: Base
  let searcher: Searcher
  private(set) public var startIndex: Index
  init(base: Base, searcher: Searcher) {
    self.base = base
    self.searcher = searcher
    var state = searcher.state(for: base, in: base.startIndex..<base.endIndex)
    self.startIndex = Index(match: nil, state: state)
    if let match = searcher.matchingSearch(base, &state) {
      self.startIndex = Index(match: match, state: state)
    } else {
      self.startIndex = endIndex
    }
  }
}
struct MatchesIterator<
  Searcher: MatchingCollectionSearcher
>: IteratorProtocol {
  public typealias Base = Searcher.Searched
  let base: Base
  let searcher: Searcher
  var state: Searcher.State
  init(base: Base, searcher: Searcher) {
    self.base = base
    self.searcher = searcher
    self.state = searcher.state(for: base, in: base.startIndex..<base.endIndex)
  }
  public mutating func next() -> _MatchResult<Searcher>? {
    searcher.matchingSearch(base, &state).map { range, result in
      _MatchResult(match: base[range], result: result)
    }
  }
}
extension MatchesCollection: Sequence {
  public func makeIterator() -> MatchesIterator<Searcher> {
    Iterator(base: base, searcher: searcher)
  }
}
extension MatchesCollection: Collection {
  struct Index {
    var match: (range: Range<Base.Index>, match: Searcher.Match)?
    var state: Searcher.State
  }
  public var endIndex: Index {
    Index(
      match: nil,
      state: searcher.state(for: base, in: base.startIndex..<base.endIndex))
  }
  public func formIndex(after index: inout Index) {
    guard index != endIndex else { fatalError("Cannot advance past endIndex") }
    index.match = searcher.matchingSearch(base, &index.state)
  }
  public func index(after index: Index) -> Index {
    var index = index
    formIndex(after: &index)
    return index
  }
  public subscript(index: Index) -> _MatchResult<Searcher> {
    guard let (range, result) = index.match else {
      fatalError("Cannot subscript using endIndex")
    }
    return _MatchResult(match: base[range], result: result)
  }
}
extension MatchesCollection.Index: Comparable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.match?.range, rhs.match?.range) {
    case (nil, nil):
      return true
    case (nil, _?), (_?, nil):
      return false
    case (let lhs?, let rhs?):
      return lhs.lowerBound == rhs.lowerBound
    }
  }
  public static func < (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.match?.range, rhs.match?.range) {
    case (nil, _):
      return false
    case (_, nil):
      return true
    case (let lhs?, let rhs?):
      return lhs.lowerBound < rhs.lowerBound
    }
  }
}
struct ReversedMatchesCollection<
  Searcher: BackwardMatchingCollectionSearcher
> {
  public typealias Base = Searcher.BackwardSearched
  let base: Base
  let searcher: Searcher
  init(base: Base, searcher: Searcher) {
    self.base = base
    self.searcher = searcher
  }
}
extension ReversedMatchesCollection: Sequence {
  struct Iterator: IteratorProtocol {
    let base: Base
    let searcher: Searcher
    var state: Searcher.BackwardState
    init(base: Base, searcher: Searcher) {
      self.base = base
      self.searcher = searcher
      self.state = searcher.backwardState(
        for: base, in: base.startIndex..<base.endIndex)
    }
    public mutating func next() -> _BackwardMatchResult<Searcher>? {
      searcher.matchingSearchBack(base, &state).map { range, result in
        _BackwardMatchResult(match: base[range], result: result)
      }
    }
  }
  public func makeIterator() -> Iterator {
    Iterator(base: base, searcher: searcher)
  }
}
extension Collection {
  func _matches<S: MatchingCollectionSearcher>(
    of searcher: S
  ) -> MatchesCollection<S> where S.Searched == Self {
    MatchesCollection(base: self, searcher: searcher)
  }
}
extension BidirectionalCollection {
  func _matchesFromBack<S: BackwardMatchingCollectionSearcher>(
    of searcher: S
  ) -> ReversedMatchesCollection<S> where S.BackwardSearched == Self {
    ReversedMatchesCollection(base: self, searcher: searcher)
  }
}
@available(SwiftStdlib 5.7, *)
struct RegexMatchesCollection<Output> {
  let input: String
  let subjectBounds: Range<String.Index>
  let searchBounds: Range<String.Index>
  let regex: Regex<Output>
  let startIndex: Index
  init(
    input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>,
    regex: Regex<Output>
  ) {
    self.input = input
    self.subjectBounds = subjectBounds
    self.searchBounds = searchBounds
    self.regex = regex
    self.startIndex = (try? regex._firstMatch(
      input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds)).map(Index.match) ?? .end
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexMatchesCollection: Sequence {
  fileprivate func searchIndex(after match: Regex<Output>.Match) -> String.Index? {
    if !match.range.isEmpty {
      return match.range.upperBound
    }
    if match.range.lowerBound == input.endIndex {
      return nil
    }
    switch regex.initialOptions.semanticLevel {
    case .graphemeCluster:
      return input.index(after: match.range.upperBound)
    case .unicodeScalar:
      return input.unicodeScalars.index(after: match.range.upperBound)
    }
  }
  struct Iterator: IteratorProtocol {
    let base: RegexMatchesCollection
    var initialIteration = true
    var nextStart: String.Index?
    init(_ matches: RegexMatchesCollection) {
      self.base = matches
      self.nextStart = base.startIndex.match.flatMap(base.searchIndex(after:))
    }
    mutating func next() -> Regex<Output>.Match? {
      if initialIteration {
        initialIteration = false
        return base.startIndex.match
      }
      guard let start = nextStart, start <= base.searchBounds.upperBound else {
        return nil
      }
      let match = try? base.regex._firstMatch(
        base.input,
        subjectBounds: base.subjectBounds,
        searchBounds: start..<base.searchBounds.upperBound)
      nextStart = match.flatMap(base.searchIndex(after:))
      return match
    }
  }
  func makeIterator() -> Iterator {
    Iterator(self)
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexMatchesCollection: Collection {
  enum Index: Comparable {
    case match(Regex<Output>.Match)
    case end
    var match: Regex<Output>.Match? {
      switch self {
      case .match(let match): return match
      case .end: return nil
      }
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.match(let lhs), .match(let rhs)):
        return lhs.range == rhs.range
      case (.end, .end):
        return true
      case (.end, .match), (.match, .end):
        return false
      }
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.match(let lhs), .match(let rhs)):
        return (lhs.range.lowerBound, lhs.range.upperBound)
          < (rhs.range.lowerBound, rhs.range.upperBound)
      case (.match, .end):
        return true
      case (.end, .match), (.end, .end):
        return false
      }
    }
  }
  var endIndex: Index {
    Index.end
  }
  func index(after i: Index) -> Index {
    guard let currentMatch = i.match else {
      fatalError("Can't advance past the 'endIndex' of a match collection.")
    }
    guard
      let start = searchIndex(after: currentMatch),
      start <= searchBounds.upperBound,
      let nextMatch = try? regex._firstMatch(
        input,
        subjectBounds: subjectBounds,
        searchBounds: start..<searchBounds.upperBound)
    else {
      return .end
    }
    return Index.match(nextMatch)
  }
  subscript(position: Index) -> Regex<Output>.Match {
    guard let match = position.match else {
      fatalError("Can't subscript the 'endIndex' of a match collection.")
    }
    return match
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  func _matches<R: RegexComponent>(
    of regex: R
  ) -> RegexMatchesCollection<R.RegexOutput> {
    RegexMatchesCollection(
      input: self[...].base,
      subjectBounds: startIndex..<endIndex,
      searchBounds: startIndex..<endIndex,
      regex: regex.regex)
  }
  @available(SwiftStdlib 5.7, *)
  public func matches<Output>(
    of r: some RegexComponent<Output>
  ) -> [Regex<Output>.Match] {
    var result = Array<Regex<Output>.Match>()
    for match in _matches(of: r) {
      result.append(match)
    }
    return result
  }
}
