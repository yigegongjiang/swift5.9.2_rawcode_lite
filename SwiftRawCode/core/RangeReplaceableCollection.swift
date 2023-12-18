public protocol RangeReplaceableCollection<Element>: Collection
where SubSequence: RangeReplaceableCollection {
  override associatedtype SubSequence
  init()
  mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: __owned C
  ) where C: Collection, C.Element == Element
  mutating func reserveCapacity(_ n: Int)
  init(repeating repeatedValue: Element, count: Int)
  init<S: Sequence>(_ elements: S)
    where S.Element == Element
  mutating func append(_ newElement: __owned Element)
  mutating func append<S: Sequence>(contentsOf newElements: __owned S)
    where S.Element == Element
  mutating func insert(_ newElement: __owned Element, at i: Index)
  mutating func insert<S: Collection>(contentsOf newElements: __owned S, at i: Index)
    where S.Element == Element
  @discardableResult
  mutating func remove(at i: Index) -> Element
  mutating func removeSubrange(_ bounds: Range<Index>)
  mutating func _customRemoveLast() -> Element?
  mutating func _customRemoveLast(_ n: Int) -> Bool
  @discardableResult
  mutating func removeFirst() -> Element
  mutating func removeFirst(_ k: Int)
  mutating func removeAll(keepingCapacity keepCapacity: Bool )
  mutating func removeAll(
    where shouldBeRemoved: (Element) throws -> Bool) rethrows
  override subscript(position: Index) -> Element { get }
  override subscript(bounds: Range<Index>) -> SubSequence { get }
}
extension RangeReplaceableCollection {
  @inlinable
  public init(repeating repeatedValue: Element, count: Int) {
    self.init()
    if count != 0 {
      let elements = Repeated(_repeating: repeatedValue, count: count)
      append(contentsOf: elements)
    }
  }
  @inlinable
  public init<S: Sequence>(_ elements: S)
    where S.Element == Element {
    self.init()
    append(contentsOf: elements)
  }
  @inlinable
  public mutating func append(_ newElement: __owned Element) {
    insert(newElement, at: endIndex)
  }
  @inlinable
  public mutating func append<S: Sequence>(contentsOf newElements: __owned S)
    where S.Element == Element {
    let approximateCapacity = self.count + newElements.underestimatedCount
    self.reserveCapacity(approximateCapacity)
    for element in newElements {
      append(element)
    }
  }
  @inlinable
  public mutating func insert(
    _ newElement: __owned Element, at i: Index
  ) {
    replaceSubrange(i..<i, with: CollectionOfOne(newElement))
  }
  @inlinable
  public mutating func insert<C: Collection>(
    contentsOf newElements: __owned C, at i: Index
  ) where C.Element == Element {
    replaceSubrange(i..<i, with: newElements)
  }
  @inlinable
  @discardableResult
  public mutating func remove(at position: Index) -> Element {
    _precondition(!isEmpty, "Can't remove from an empty collection")
    let result: Element = self[position]
    replaceSubrange(position..<index(after: position), with: EmptyCollection())
    return result
  }
  @inlinable
  public mutating func removeSubrange(_ bounds: Range<Index>) {
    replaceSubrange(bounds, with: EmptyCollection())
  }
  @inlinable
  public mutating func removeFirst(_ k: Int) {
    if k == 0 { return }
    _precondition(k >= 0, "Number of elements to remove should be non-negative")
    guard let end = index(startIndex, offsetBy: k, limitedBy: endIndex) else {
      _preconditionFailure(
        "Can't remove more items from a collection than it has")
    }
    removeSubrange(startIndex..<end)
  }
  @inlinable
  @discardableResult
  public mutating func removeFirst() -> Element {
    _precondition(!isEmpty,
      "Can't remove first element from an empty collection")
    let firstElement = first!
    removeFirst(1)
    return firstElement
  }
  @inlinable
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    if !keepCapacity {
      self = Self()
    }
    else {
      replaceSubrange(startIndex..<endIndex, with: EmptyCollection())
    }
  }
  @inlinable
  public mutating func reserveCapacity(_ n: Int) {}
}
extension RangeReplaceableCollection where SubSequence == Self {
  @inlinable
  @discardableResult
  public mutating func removeFirst() -> Element {
    _precondition(!isEmpty, "Can't remove items from an empty collection")
    let element = first!
    self = self[index(after: startIndex)..<endIndex]
    return element
  }
  @inlinable
  public mutating func removeFirst(_ k: Int) {
    if k == 0 { return }
    _precondition(k >= 0, "Number of elements to remove should be non-negative")
    guard let idx = index(startIndex, offsetBy: k, limitedBy: endIndex) else {
      _preconditionFailure(
        "Can't remove more items from a collection than it contains")
    }
    self = self[idx..<endIndex]
  }
}
extension RangeReplaceableCollection {
  @inlinable
  public mutating func replaceSubrange<C: Collection, R: RangeExpression>(
    _ subrange: R,
    with newElements: __owned C
  ) where C.Element == Element, R.Bound == Index {
    self.replaceSubrange(subrange.relative(to: self), with: newElements)
  }
  @available(*, unavailable)
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: C
  ) where C: Collection, C.Element == Element {
    fatalError()
  }
  @inlinable
  public mutating func removeSubrange<R: RangeExpression>(
    _ bounds: R
  ) where R.Bound == Index  {
    removeSubrange(bounds.relative(to: self))
  }
}
extension RangeReplaceableCollection {
  @inlinable
  public mutating func _customRemoveLast() -> Element? {
    return nil
  }
  @inlinable
  public mutating func _customRemoveLast(_ n: Int) -> Bool {
    return false
  }
}
extension RangeReplaceableCollection
  where Self: BidirectionalCollection, SubSequence == Self {
  @inlinable
  public mutating func _customRemoveLast() -> Element? {
    let element = last!
    self = self[startIndex..<index(before: endIndex)]
    return element
  }
  @inlinable
  public mutating func _customRemoveLast(_ n: Int) -> Bool {
    guard let end = index(endIndex, offsetBy: -n, limitedBy: startIndex)
    else {
      _preconditionFailure(
        "Can't remove more items from a collection than it contains")
    }
    self = self[startIndex..<end]
    return true
  }
}
extension RangeReplaceableCollection where Self: BidirectionalCollection {
  @inlinable
  public mutating func popLast() -> Element? {
    if isEmpty { return nil }
    if let result = _customRemoveLast() { return result }
    return remove(at: index(before: endIndex))
  }
  @inlinable
  @discardableResult
  public mutating func removeLast() -> Element {
    _precondition(!isEmpty, "Can't remove last element from an empty collection")
    if let result = _customRemoveLast() { return result }
    return remove(at: index(before: endIndex))
  }
  @inlinable
  public mutating func removeLast(_ k: Int) {
    if k == 0 { return }
    _precondition(k >= 0, "Number of elements to remove should be non-negative")
    if _customRemoveLast(k) {
      return
    }
    let end = endIndex
    guard let start = index(end, offsetBy: -k, limitedBy: startIndex)
    else {
      _preconditionFailure(
        "Can't remove more items from a collection than it contains")
    }
    removeSubrange(start..<end)
  }
}
extension RangeReplaceableCollection
where Self: BidirectionalCollection, SubSequence == Self {
  @inlinable
  public mutating func popLast() -> Element? {
    if isEmpty { return nil }
    if let result = _customRemoveLast() { return result }
    return remove(at: index(before: endIndex))
  }
  @inlinable
  @discardableResult
  public mutating func removeLast() -> Element {
    _precondition(!isEmpty, "Can't remove last element from an empty collection")
    if let result = _customRemoveLast() { return result }
    return remove(at: index(before: endIndex))
  }
  @inlinable
  public mutating func removeLast(_ k: Int) {
    if k == 0 { return }
    _precondition(k >= 0, "Number of elements to remove should be non-negative")
    if _customRemoveLast(k) {
      return
    }
    let end = endIndex
    guard let start = index(end, offsetBy: -k, limitedBy: startIndex)
    else {
      _preconditionFailure(
        "Can't remove more items from a collection than it contains")
    }
    removeSubrange(start..<end)
  }
}
extension RangeReplaceableCollection {
  @inlinable
  public static func + <
    Other: Sequence
  >(lhs: Self, rhs: Other) -> Self
  where Element == Other.Element {
    var lhs = lhs
    lhs.append(contentsOf: rhs)
    return lhs
  }
  @inlinable
  public static func + <
    Other: Sequence
  >(lhs: Other, rhs: Self) -> Self
  where Element == Other.Element {
    var result = Self()
    result.reserveCapacity(rhs.count + lhs.underestimatedCount)
    result.append(contentsOf: lhs)
    result.append(contentsOf: rhs)
    return result
  }
  @inlinable
  public static func += <
    Other: Sequence
  >(lhs: inout Self, rhs: Other)
  where Element == Other.Element {
    lhs.append(contentsOf: rhs)
  }
  @inlinable
  public static func + <
    Other: RangeReplaceableCollection
  >(lhs: Self, rhs: Other) -> Self
  where Element == Other.Element {
    var lhs = lhs
    lhs.append(contentsOf: rhs)
    return lhs
  }
}
extension RangeReplaceableCollection {
  @inlinable
  @available(swift, introduced: 4.0)
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> Self {
    var result = Self()
    for element in self where try isIncluded(element) {
      result.append(element)
    }
    return result
  }
}
extension RangeReplaceableCollection where Self: MutableCollection {
  @inlinable
  public mutating func removeAll(
    where shouldBeRemoved: (Element) throws -> Bool
  ) rethrows {
    let suffixStart = try _halfStablePartition(isSuffixElement: shouldBeRemoved)
    removeSubrange(suffixStart...)
  }
}
extension RangeReplaceableCollection {
  @inlinable
  public mutating func removeAll(
    where shouldBeRemoved: (Element) throws -> Bool
  ) rethrows {
    self = try filter { try !shouldBeRemoved($0) }
  }
}
