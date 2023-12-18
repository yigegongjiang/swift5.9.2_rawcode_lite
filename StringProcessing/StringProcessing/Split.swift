struct SplitCollection<Searcher: CollectionSearcher> {
  public typealias Base = Searcher.Searched
  let ranges: RangesCollection<Searcher>
  var maxSplits: Int
  var omittingEmptySubsequences: Bool
  init(
    ranges: RangesCollection<Searcher>,
    maxSplits: Int,
    omittingEmptySubsequences: Bool)
  {
    self.ranges = ranges
    self.maxSplits = maxSplits
    self.omittingEmptySubsequences = omittingEmptySubsequences
  }
  init(
    base: Base,
    searcher: Searcher,
    maxSplits: Int,
    omittingEmptySubsequences: Bool)
  {
    self.ranges = base._ranges(of: searcher)
    self.maxSplits = maxSplits
    self.omittingEmptySubsequences = omittingEmptySubsequences
  }
}
extension SplitCollection: Sequence {
  public struct Iterator: IteratorProtocol {
    let base: Base
    var index: Base.Index
    var ranges: RangesCollection<Searcher>.Iterator
    var maxSplits: Int
    var omittingEmptySubsequences: Bool
    var splitCounter = 0
    var isDone = false
    init(
      ranges: RangesCollection<Searcher>,
      maxSplits: Int,
      omittingEmptySubsequences: Bool
    ) {
      self.base = ranges.base
      self.index = base.startIndex
      self.ranges = ranges.makeIterator()
      self.maxSplits = maxSplits
      self.omittingEmptySubsequences = omittingEmptySubsequences
    }
    public mutating func next() -> Base.SubSequence? {
      guard !isDone else { return nil }
      func finish() -> Base.SubSequence? {
        isDone = true
        return index == base.endIndex && omittingEmptySubsequences
          ? nil
          : base[index...]
      }
      if index == base.endIndex {
        return finish()
      }
      if splitCounter >= maxSplits {
        return finish()
      }
      while true {
        guard let range = ranges.next() else {
          return finish()
        }
        defer { index = range.upperBound }
        if omittingEmptySubsequences && index == range.lowerBound {
          continue
        }
        splitCounter += 1
        return base[index..<range.lowerBound]
      }
    }
  }
  public func makeIterator() -> Iterator {
    Iterator(ranges: ranges, maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
  }
}
extension Collection {
  func split<Searcher: CollectionSearcher>(
    by separator: Searcher,
    maxSplits: Int,
    omittingEmptySubsequences: Bool
  ) -> SplitCollection<Searcher> where Searcher.Searched == Self {
    SplitCollection(
      base: self,
      searcher: separator,
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences)
  }
}
extension Collection where Element: Equatable {
  func split<C: Collection>(
    by separator: C,
    maxSplits: Int,
    omittingEmptySubsequences: Bool
  ) -> SplitCollection<ZSearcher<Self>> where C.Element == Element {
    split(by: ZSearcher(pattern: Array(separator), by: ==), maxSplits: maxSplits, omittingEmptySubsequences: omittingEmptySubsequences)
  }
  @available(SwiftStdlib 5.7, *)
  public func split<C: Collection>(
    separator: C,
    maxSplits: Int = .max,
    omittingEmptySubsequences: Bool = true
  ) -> [SubSequence] where C.Element == Element {
    Array(split(
      by: ZSearcher(pattern: Array(separator), by: ==),
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences))
  }
}
extension StringProtocol where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func _split(
    separator: String,
    maxSplits: Int = .max,
    omittingEmptySubsequences: Bool = true
  ) -> [Substring] {
    Array(split(
      by: ZSearcher(pattern: Array(separator), by: ==),
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences))
  }
  @available(SwiftStdlib 5.7, *)
  public func _split(
    separator: Substring,
    maxSplits: Int = .max,
    omittingEmptySubsequences: Bool = true
  ) -> [Substring] {
    Array(split(
      by: ZSearcher(pattern: Array(separator), by: ==),
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences))
  }
}
@available(SwiftStdlib 5.7, *)
extension BidirectionalCollection where SubSequence == Substring {
  public func split(
    separator: some RegexComponent,
    maxSplits: Int = .max,
    omittingEmptySubsequences: Bool = true
  ) -> [SubSequence] {
    var result: [SubSequence] = []
    var subSequenceStart = startIndex
    func appendSubsequence(end: Index) -> Bool {
      if subSequenceStart == end && omittingEmptySubsequences {
        return false
      }
      result.append(self[subSequenceStart..<end])
      return true
    }
    guard maxSplits > 0 && !isEmpty else {
      _ = appendSubsequence(end: endIndex)
      return result
    }
    for match in _matches(of: separator) {
      defer { subSequenceStart = match.range.upperBound }
      let didAppend = appendSubsequence(end: match.range.lowerBound)
      if didAppend && result.count == maxSplits {
        break
      }
    }
    if subSequenceStart != endIndex || !omittingEmptySubsequences {
      result.append(self[subSequenceStart..<endIndex])
    }
    return result
  }
}
