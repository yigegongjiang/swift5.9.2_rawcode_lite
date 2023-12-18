@available(SwiftStdlib 5.7, *)
extension BidirectionalCollection where SubSequence == Substring {
  public func starts(with regex: some RegexComponent) -> Bool {
    let s = self[...]
    return (try? regex.regex.prefixMatch(in: s)) != nil
  }
}
