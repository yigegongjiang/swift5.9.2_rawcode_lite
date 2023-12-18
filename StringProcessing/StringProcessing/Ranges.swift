struct RangesCollection<Searcher: CollectionSearcher> {
  public typealias Base = Searcher.Searched
  let base: Base
  let searcher: Searcher
  private(set) public var startIndex: Index
  init(base: Base, searcher: Searcher) {
    self.base = base
    self.searcher = searcher
    var state = searcher.state(for: base, in: base.startIndex..<base.endIndex)
    self.startIndex = Index(range: nil, state: state)
    if let range = searcher.search(base, &state) {
      self.startIndex = Index(range: range, state: state)
    } else {
      self.startIndex = endIndex
    }
  }
}
struct RangesIterator<Searcher: CollectionSearcher>: IteratorProtocol {
  public typealias Base = Searcher.Searched
  let base: Base
  let searcher: Searcher
  var state: Searcher.State
  init(base: Base, searcher: Searcher) {
    self.base = base
    self.searcher = searcher
    self.state = searcher.state(for: base, in: base.startIndex..<base.endIndex)
  }
  public mutating func next() -> Range<Base.Index>? {
    searcher.search(base, &state)
  }
}
extension RangesCollection: Sequence {
  public func makeIterator() -> RangesIterator<Searcher> {
    Iterator(base: base, searcher: searcher)
  }
}
extension RangesCollection: Collection {
  public struct Index {
    var range: Range<Searcher.Searched.Index>?
    var state: Searcher.State
  }
  public var endIndex: Index {
    Index(
      range: nil,
      state: searcher.state(for: base, in: base.startIndex..<base.endIndex))
  }
  public func formIndex(after index: inout Index) {
    guard index != endIndex else { fatalError("Cannot advance past endIndex") }
    index.range = searcher.search(base, &index.state)
  }
  public func index(after index: Index) -> Index {
    var index = index
    formIndex(after: &index)
    return index
  }
  public subscript(index: Index) -> Range<Base.Index> {
    guard let range = index.range else {
      fatalError("Cannot subscript using endIndex")
    }
    return range
  }
}
extension RangesCollection.Index: Comparable {
  static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.range, rhs.range) {
    case (nil, nil):
      return true
    case (nil, _?), (_?, nil):
      return false
    case (let lhs?, let rhs?):
      return lhs.lowerBound == rhs.lowerBound
    }
  }
  static func < (lhs: Self, rhs: Self) -> Bool {
    switch (lhs.range, rhs.range) {
    case (nil, _):
      return false
    case (_, nil):
      return true
    case (let lhs?, let rhs?):
      return lhs.lowerBound < rhs.lowerBound
    }
  }
}
extension Collection {
  func _ranges<S: CollectionSearcher>(
    of searcher: S
  ) -> RangesCollection<S> where S.Searched == Self {
    RangesCollection(base: self, searcher: searcher)
  }
}
extension Collection where Element: Equatable {
  func _ranges<C: Collection>(
    of other: C
  ) -> RangesCollection<ZSearcher<Self>> where C.Element == Element {
    _ranges(of: ZSearcher(pattern: Array(other), by: ==))
  }
  @available(SwiftStdlib 5.7, *)
  public func ranges<C: Collection>(
    of other: C
  ) -> [Range<Index>] where C.Element == Element {
    Array(_ranges(of: other))
  }
}
@available(SwiftStdlib 5.7, *)
struct RegexRangesCollection<Output> {
  let base: RegexMatchesCollection<Output>
  init(
    input: String,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>,
    regex: Regex<Output>
  ) {
    self.base = .init(
      input: input,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds,
      regex: regex)
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexRangesCollection: Sequence {
  struct Iterator: IteratorProtocol {
    var matchesBase: RegexMatchesCollection<Output>.Iterator
    mutating func next() -> Range<String.Index>? {
      matchesBase.next().map(\.range)
    }
  }
  func makeIterator() -> Iterator {
    Iterator(matchesBase: base.makeIterator())
  }
}
@available(SwiftStdlib 5.7, *)
extension RegexRangesCollection: Collection {
  typealias Index = RegexMatchesCollection<Output>.Index
  var startIndex: Index { base.startIndex }
  var endIndex: Index { base.endIndex }
  func index(after i: Index) -> Index { base.index(after: i) }
  subscript(position: Index) -> Range<String.Index> { base[position].range }
}
extension Collection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  func _ranges<R: RegexComponent>(
    of regex: R,
    subjectBounds: Range<String.Index>,
    searchBounds: Range<String.Index>
  ) -> RegexRangesCollection<R.RegexOutput> {
    RegexRangesCollection(
      input: self[...].base,
      subjectBounds: subjectBounds,
      searchBounds: searchBounds,
      regex: regex.regex)
  }
  @available(SwiftStdlib 5.7, *)
  func _ranges<R: RegexComponent>(
    of regex: R
  ) -> RegexRangesCollection<R.RegexOutput> {
    _ranges(
      of: regex,
      subjectBounds: startIndex..<endIndex,
      searchBounds: startIndex..<endIndex)
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func ranges(
    of regex: some RegexComponent
  ) -> [Range<Index>] {
    Array(_ranges(of: regex))
  }
}
