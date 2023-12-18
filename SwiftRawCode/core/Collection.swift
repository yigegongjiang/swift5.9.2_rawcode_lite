@frozen
public struct IndexingIterator<Elements: Collection> {
  @usableFromInline
  internal let _elements: Elements
  @usableFromInline
  internal var _position: Elements.Index
  @inlinable
  @inline(__always)
  public 
  init(_elements: Elements) {
    self._elements = _elements
    self._position = _elements.startIndex
  }
  @inlinable
  @inline(__always)
  public 
  init(_elements: Elements, _position: Elements.Index) {
    self._elements = _elements
    self._position = _position
  }
}
extension IndexingIterator: IteratorProtocol, Sequence {
  public typealias Element = Elements.Element
  public typealias Iterator = IndexingIterator<Elements>
  public typealias SubSequence = AnySequence<Element>
  @inlinable
  @inline(__always)
  public mutating func next() -> Elements.Element? {
    if _position == _elements.endIndex { return nil }
    let element = _elements[_position]
    _elements.formIndex(after: &_position)
    return element
  }
}
extension IndexingIterator: Sendable
  where Elements: Sendable, Elements.Index: Sendable { }
public protocol Collection<Element>: Sequence {
  @available(*, deprecated, message: "all index distances are now of type Int")
  typealias IndexDistance = Int  
  override associatedtype Element
  @available(swift, deprecated: 3.2, obsoleted: 5.0, renamed: "Element")
  typealias _Element = Element
  associatedtype Index: Comparable
  var startIndex: Index { get }
  var endIndex: Index { get }
  associatedtype Iterator = IndexingIterator<Self>
  override __consuming func makeIterator() -> Iterator
  associatedtype SubSequence: Collection = Slice<Self>
  where SubSequence.Index == Index,
        Element == SubSequence.Element,
        SubSequence.SubSequence == SubSequence
  subscript(position: Index) -> Element { get }
  subscript(bounds: Range<Index>) -> SubSequence { get }
  associatedtype Indices: Collection = DefaultIndices<Self>
    where Indices.Element == Index, 
          Indices.Index == Index,
          Indices.SubSequence == Indices
  var indices: Indices { get }
  var isEmpty: Bool { get }
  var count: Int { get }
  func _customIndexOfEquatableElement(_ element: Element) -> Index??
  func _customLastIndexOfEquatableElement(_ element: Element) -> Index??
  func index(_ i: Index, offsetBy distance: Int) -> Index
  func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index?
  func distance(from start: Index, to end: Index) -> Int
  func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>)
  func _failEarlyRangeCheck(_ index: Index, bounds: ClosedRange<Index>)
  func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>)
  func index(after i: Index) -> Index
  func formIndex(after i: inout Index)
}
extension Collection {
  @inlinable 
  @inline(__always)
  public func formIndex(after i: inout Index) {
    i = index(after: i)
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    _precondition(
      bounds.lowerBound <= index && index < bounds.upperBound,
      "Index out of bounds")
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: ClosedRange<Index>) {
    _precondition(
      bounds.lowerBound <= index && index <= bounds.upperBound,
      "Index out of bounds")
  }
  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
    _precondition(
      bounds.lowerBound <= range.lowerBound &&
      range.upperBound <= bounds.upperBound,
      "Range out of bounds")
  }
  @inlinable
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    return self._advanceForward(i, by: distance)
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index? {
    return self._advanceForward(i, by: distance, limitedBy: limit)
  }
  @inlinable
  public func formIndex(_ i: inout Index, offsetBy distance: Int) {
    i = index(i, offsetBy: distance)
  }
  @inlinable
  public func formIndex(
    _ i: inout Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Bool {
    if let advancedIndex = index(i, offsetBy: distance, limitedBy: limit) {
      i = advancedIndex
      return true
    }
    i = limit
    return false
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    _precondition(start <= end,
      "Only BidirectionalCollections can have end come before start")
    var start = start
    var count = 0
    while start != end {
      count = count + 1
      formIndex(after: &start)
    }
    return count
  }
  @inlinable
  public func randomElement<T: RandomNumberGenerator>(
    using generator: inout T
  ) -> Element? {
    guard !isEmpty else { return nil }
    let random = Int.random(in: 0 ..< count, using: &generator)
    let idx = index(startIndex, offsetBy: random)
    return self[idx]
  }
  @inlinable
  public func randomElement() -> Element? {
    var g = SystemRandomNumberGenerator()
    return randomElement(using: &g)
  }
  @inlinable
  @inline(__always)
  internal func _advanceForward(_ i: Index, by n: Int) -> Index {
    _precondition(n >= 0,
      "Only BidirectionalCollections can be advanced by a negative amount")
    var i = i
    for _ in stride(from: 0, to: n, by: 1) {
      formIndex(after: &i)
    }
    return i
  }
  @inlinable
  @inline(__always)
  internal func _advanceForward(
    _ i: Index, by n: Int, limitedBy limit: Index
  ) -> Index? {
    _precondition(n >= 0,
      "Only BidirectionalCollections can be advanced by a negative amount")
    var i = i
    for _ in stride(from: 0, to: n, by: 1) {
      if i == limit {
        return nil
      }
      formIndex(after: &i)
    }
    return i
  }
}
extension Collection where Iterator == IndexingIterator<Self> {
  @inlinable 
  @inline(__always)
  public __consuming func makeIterator() -> IndexingIterator<Self> {
    return IndexingIterator(_elements: self)
  }
}
extension Collection where SubSequence == Slice<Self> {
  @inlinable
  public subscript(bounds: Range<Index>) -> Slice<Self> {
    _failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
    return Slice(base: self, bounds: bounds)
  }
}
extension Collection {
  @available(*, unavailable)
  public subscript(bounds: Range<Index>) -> SubSequence { fatalError() }
}
extension Collection where SubSequence == Self {
  @inlinable
  public mutating func popFirst() -> Element? {
    guard !isEmpty else { return nil }
    let element = first!
    self = self[index(after: startIndex)..<endIndex]
    return element
  }
}
extension Collection {
  @inlinable
  public var isEmpty: Bool {
    return startIndex == endIndex
  }
  @inlinable
  public var first: Element? {
    let start = startIndex
    if start != endIndex { return self[start] }
    else { return nil }
  }
  @inlinable
  public var underestimatedCount: Int {
    return count
  }
  @inlinable
  public var count: Int {
    return distance(from: startIndex, to: endIndex)
  }
  @inlinable
  @inline(__always)
  public 
  func _customIndexOfEquatableElement(_: Element) -> Index?? {
    return nil
  }
  @inlinable
  @inline(__always)
  public 
  func _customLastIndexOfEquatableElement(_ element: Element) -> Index?? {
    return nil
  }
}
extension Collection {
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    let n = self.count
    if n == 0 {
      return []
    }
    var result = ContiguousArray<T>()
    result.reserveCapacity(n)
    var i = self.startIndex
    for _ in 0..<n {
      result.append(try transform(self[i]))
      formIndex(after: &i)
    }
    _expectEnd(of: self, is: i)
    return Array(result)
  }
  @inlinable
  public __consuming func dropFirst(_ k: Int = 1) -> SubSequence {
    _precondition(k >= 0, "Can't drop a negative number of elements from a collection")
    let start = index(startIndex, offsetBy: k, limitedBy: endIndex) ?? endIndex
    return self[start..<endIndex]
  }
  @inlinable
  public __consuming func dropLast(_ k: Int = 1) -> SubSequence {
    _precondition(
      k >= 0, "Can't drop a negative number of elements from a collection")
    let amount = Swift.max(0, count - k)
    let end = index(startIndex,
      offsetBy: amount, limitedBy: endIndex) ?? endIndex
    return self[startIndex..<end]
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> SubSequence {
    var start = startIndex
    while try start != endIndex && predicate(self[start]) {
      formIndex(after: &start)
    } 
    return self[start..<endIndex]
  }
  @inlinable
  public __consuming func prefix(_ maxLength: Int) -> SubSequence {
    _precondition(
      maxLength >= 0,
      "Can't take a prefix of negative length from a collection")
    let end = index(startIndex,
      offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
    return self[startIndex..<end]
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> SubSequence {
    var end = startIndex
    while try end != endIndex && predicate(self[end]) {
      formIndex(after: &end)
    }
    return self[startIndex..<end]
  }
  @inlinable
  public __consuming func suffix(_ maxLength: Int) -> SubSequence {
    _precondition(
      maxLength >= 0,
      "Can't take a suffix of negative length from a collection")
    let amount = Swift.max(0, count - maxLength)
    let start = index(startIndex,
      offsetBy: amount, limitedBy: endIndex) ?? endIndex
    return self[start..<endIndex]
  }
  @inlinable
  public __consuming func prefix(upTo end: Index) -> SubSequence {
    return self[startIndex..<end]
  }
  @inlinable
  public __consuming func suffix(from start: Index) -> SubSequence {
    return self[start..<endIndex]
  }
  @inlinable
  public __consuming func prefix(through position: Index) -> SubSequence {
    return prefix(upTo: index(after: position))
  }
  @inlinable
  public __consuming func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [SubSequence] {
    _precondition(maxSplits >= 0, "Must take zero or more splits")
    var result: [SubSequence] = []
    var subSequenceStart: Index = startIndex
    func appendSubsequence(end: Index) -> Bool {
      if subSequenceStart == end && omittingEmptySubsequences {
        return false
      }
      result.append(self[subSequenceStart..<end])
      return true
    }
    if maxSplits == 0 || isEmpty {
      _ = appendSubsequence(end: endIndex)
      return result
    }
    var subSequenceEnd = subSequenceStart
    let cachedEndIndex = endIndex
    while subSequenceEnd != cachedEndIndex {
      if try isSeparator(self[subSequenceEnd]) {
        let didAppend = appendSubsequence(end: subSequenceEnd)
        formIndex(after: &subSequenceEnd)
        subSequenceStart = subSequenceEnd
        if didAppend && result.count == maxSplits {
          break
        }
        continue
      }
      formIndex(after: &subSequenceEnd)
    }
    if subSequenceStart != cachedEndIndex || !omittingEmptySubsequences {
      result.append(self[subSequenceStart..<cachedEndIndex])
    }
    return result
  }
}
extension Collection where Element: Equatable {
  @inlinable
  public __consuming func split(
    separator: Element,
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true
  ) -> [SubSequence] {
    return split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: { $0 == separator })
  }
}
extension Collection where SubSequence == Self {
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
