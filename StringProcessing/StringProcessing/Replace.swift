extension RangeReplaceableCollection {
  func _replacing<Ranges: Collection, Replacement: Collection>(
    _ ranges: Ranges,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) -> Self where Ranges.Element == Range<Index>,
                  Replacement.Element == Element
  {
    precondition(maxReplacements >= 0)
    var result = Self()
    var index = startIndex
    let maxRanges = ranges.prefix(maxReplacements)
    for range in maxRanges {
      result.append(contentsOf: self[index..<range.lowerBound])
      result.append(contentsOf: replacement)
      index = range.upperBound
    }
    result.append(contentsOf: self[index...])
    return result
  }
  mutating func _replace<
    Ranges: Collection, Replacement: Collection
  >(
    _ ranges: Ranges,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) where Ranges.Element == Range<Index>, Replacement.Element == Element {
    self = _replacing(
      ranges,
      with: replacement,
      maxReplacements: maxReplacements)
  }
}
extension RangeReplaceableCollection where Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public func replacing<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    subrange: Range<Index>,
    maxReplacements: Int = .max
  ) -> Self where C.Element == Element, Replacement.Element == Element {
    _replacing(
      self[subrange]._ranges(of: other),
      with: replacement,
      maxReplacements: maxReplacements)
  }
  @available(SwiftStdlib 5.7, *)
  public func replacing<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) -> Self where C.Element == Element, Replacement.Element == Element {
    replacing(
      other,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
  @available(SwiftStdlib 5.7, *)
  public mutating func replace<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) where C.Element == Element, Replacement.Element == Element {
    self = replacing(
      other,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
}
extension RangeReplaceableCollection
  where Self: BidirectionalCollection, Element: Comparable
{
  func _replacing<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    subrange: Range<Index>,
    maxReplacements: Int = .max
  ) -> Self where C.Element == Element, Replacement.Element == Element {
    _replacing(
      self[subrange]._ranges(of: other),
      with: replacement,
      maxReplacements: maxReplacements)
  }
  func _replacing<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) -> Self where C.Element == Element, Replacement.Element == Element {
    _replacing(
      other,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
  mutating func _replace<C: Collection, Replacement: Collection>(
    _ other: C,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) where C.Element == Element, Replacement.Element == Element {
    self = _replacing(
      other,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
}
extension RangeReplaceableCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func replacing<Replacement: Collection>(
    _ regex: some RegexComponent,
    with replacement: Replacement,
    subrange: Range<Index>,
    maxReplacements: Int = .max
  ) -> Self where Replacement.Element == Element {
    _replacing(
      self._ranges(
        of: regex,
        subjectBounds: startIndex..<endIndex,
        searchBounds: subrange),
      with: replacement,
      maxReplacements: maxReplacements)
  }
  @available(SwiftStdlib 5.7, *)
  public func replacing<Replacement: Collection>(
    _ regex: some RegexComponent,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) -> Self where Replacement.Element == Element {
    replacing(
      regex,
      with: replacement,
      subrange: startIndex..<endIndex,
      maxReplacements: maxReplacements)
  }
  @available(SwiftStdlib 5.7, *)
  public mutating func replace<Replacement: Collection>(
    _ regex: some RegexComponent,
    with replacement: Replacement,
    maxReplacements: Int = .max
  ) where Replacement.Element == Element {
    self = replacing(
      regex,
      with: replacement,
      maxReplacements: maxReplacements)
  }
}
