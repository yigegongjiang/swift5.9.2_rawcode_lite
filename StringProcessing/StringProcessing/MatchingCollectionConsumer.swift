protocol MatchingCollectionConsumer: CollectionConsumer {
  associatedtype Match
  func matchingConsuming(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> (upperBound: Consumed.Index, match: Match)?
}
extension MatchingCollectionConsumer {
  func consuming(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> Consumed.Index? {
    matchingConsuming(consumed, in: range)?.upperBound
  }
}
protocol BidirectionalMatchingCollectionConsumer:
  MatchingCollectionConsumer, BidirectionalCollectionConsumer
{
  func matchingConsumingBack(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> (lowerBound: Consumed.Index, match: Match)?
}
extension BidirectionalMatchingCollectionConsumer {
  func consumingBack(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> Consumed.Index? {
    matchingConsumingBack(consumed, in: range)?.lowerBound
  }
}
