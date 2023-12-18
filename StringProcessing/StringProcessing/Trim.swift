extension Collection {
  func _trimmingPrefix<Consumer: CollectionConsumer>(
    _ consumer: Consumer
  ) -> SubSequence where Consumer.Consumed == Self {
    let start = consumer.consuming(self) ?? startIndex
    return self[start...]
  }
}
extension Collection where SubSequence == Self {
  mutating func _trimPrefix<Consumer: CollectionConsumer>(
    _ consumer: Consumer
  ) where Consumer.Consumed == Self {
    _ = consumer.consume(&self)
  }
}
extension RangeReplaceableCollection {
  mutating func _trimPrefix<Consumer: CollectionConsumer>(
    _ consumer: Consumer
  ) where Consumer.Consumed == Self {
    if let start = consumer.consuming(self) {
      removeSubrange(..<start)
    }
  }
}
extension Collection {
  fileprivate func endOfPrefix(while predicate: (Element) throws -> Bool) rethrows -> Index {
    try firstIndex(where: { try !predicate($0) }) ?? endIndex
  }
  @available(SwiftStdlib 5.7, *)
  public func trimmingPrefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> SubSequence {
    let end = try endOfPrefix(while: predicate)
    return self[end...]
  }
}
extension Collection where SubSequence == Self {
  @available(SwiftStdlib 5.7, *)
  public mutating func trimPrefix(
    while predicate: (Element) throws -> Bool
  ) throws {
    let end = try endOfPrefix(while: predicate)
    self = self[end...]
  }
}
extension RangeReplaceableCollection {
  @available(SwiftStdlib 5.7, *)
  public mutating func trimPrefix(
    while predicate: (Element) throws -> Bool
  ) rethrows {
    let end = try endOfPrefix(while: predicate)
    removeSubrange(startIndex..<end)
  }
}
extension Collection where Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public func trimmingPrefix<Prefix: Sequence>(
    _ prefix: Prefix
  ) -> SubSequence where Prefix.Element == Element {
    _trimmingPrefix(FixedPatternConsumer(pattern: prefix))
  }
}
extension Collection where SubSequence == Self, Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public mutating func trimPrefix<Prefix: Sequence>(
    _ prefix: Prefix
  ) where Prefix.Element == Element {
    _trimPrefix(FixedPatternConsumer<SubSequence, Prefix>(pattern: prefix))
  }
}
extension RangeReplaceableCollection where Element: Equatable {
  @available(SwiftStdlib 5.7, *)
  public mutating func trimPrefix<Prefix: Sequence>(
    _ prefix: Prefix
  ) where Prefix.Element == Element {
    _trimPrefix(FixedPatternConsumer(pattern: prefix))
  }
}
extension BidirectionalCollection where SubSequence == Substring {
  @available(SwiftStdlib 5.7, *)
  public func trimmingPrefix(_ regex: some RegexComponent) -> SubSequence {
    let s = self[...]
    guard let prefix = try? regex.regex.prefixMatch(in: s) else {
      return s
    }
    return s[prefix.range.upperBound...]
  }
}
extension RangeReplaceableCollection
  where Self: BidirectionalCollection, SubSequence == Substring
{
  @available(SwiftStdlib 5.7, *)
  public mutating func trimPrefix(_ regex: some RegexComponent) {
    let s = self[...]
    guard let prefix = try? regex.regex.prefixMatch(in: s) else {
      return
    }
    self.removeSubrange(prefix.range)
  }
}
