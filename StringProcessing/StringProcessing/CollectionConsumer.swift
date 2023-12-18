protocol CollectionConsumer {
  associatedtype Consumed: Collection
  func consuming(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> Consumed.Index?
}
extension CollectionConsumer {
  func consuming(_ consumed: Consumed) -> Consumed.Index? {
    consuming(consumed, in: consumed.startIndex..<consumed.endIndex)
  }
  func consume(_ consumed: inout Consumed) -> Bool
    where Consumed.SubSequence == Consumed
  {
    guard let index = consuming(consumed) else { return false }
    consumed = consumed[index...]
    return true
  }
}
protocol BidirectionalCollectionConsumer: CollectionConsumer
  where Consumed: BidirectionalCollection
{
  func consumingBack(
    _ consumed: Consumed,
    in range: Range<Consumed.Index>
  ) -> Consumed.Index?
}
extension BidirectionalCollectionConsumer {
  func consumingBack(_ consumed: Consumed) -> Consumed.Index? {
    consumingBack(consumed, in: consumed.startIndex..<consumed.endIndex)
  }
  func consumeBack(_ consumed: inout Consumed) -> Bool
    where Consumed.SubSequence == Consumed
  {
    guard let index = consumingBack(consumed) else { return false }
    consumed = consumed[..<index]
    return true
  }
}
