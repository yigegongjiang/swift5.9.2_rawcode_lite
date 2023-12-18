extension BidirectionalCollection {
  @inlinable
  public var last: Element? {
    return isEmpty ? nil : self[index(before: endIndex)]
  }
}
extension Collection where Element: Equatable {
  @inlinable
  public func firstIndex(of element: Element) -> Index? {
    if let result = _customIndexOfEquatableElement(element) {
      return result
    }
    var i = self.startIndex
    while i != self.endIndex {
      if self[i] == element {
        return i
      }
      self.formIndex(after: &i)
    }
    return nil
  }
}
extension Collection {
  @inlinable
  public func firstIndex(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Index? {
    var i = self.startIndex
    while i != self.endIndex {
      if try predicate(self[i]) {
        return i
      }
      self.formIndex(after: &i)
    }
    return nil
  }
}
extension BidirectionalCollection {
  @inlinable
  public func last(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Element? {
    return try lastIndex(where: predicate).map { self[$0] }
  }
  @inlinable
  public func lastIndex(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Index? {
    var i = endIndex
    while i != startIndex {
      formIndex(before: &i)
      if try predicate(self[i]) {
        return i
      }
    }
    return nil
  }
}
extension BidirectionalCollection where Element: Equatable {
  @inlinable
  public func lastIndex(of element: Element) -> Index? {
    if let result = _customLastIndexOfEquatableElement(element) {
      return result
    }
    return lastIndex(where: { $0 == element })
  }
}
extension MutableCollection {
  @inlinable
  public mutating func partition(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> Index {
    return try _halfStablePartition(isSuffixElement: belongsInSecondPartition)
  }
  @inlinable
  internal mutating func _halfStablePartition(
    isSuffixElement: (Element) throws -> Bool
  ) rethrows -> Index {
    guard var i = try firstIndex(where: isSuffixElement)
    else { return endIndex }
    var j = index(after: i)
    while j != endIndex {
      if try !isSuffixElement(self[j]) { swapAt(i, j); formIndex(after: &i) }
      formIndex(after: &j)
    }
    return i
  }  
}
extension MutableCollection where Self: BidirectionalCollection {
  @inlinable
  public mutating func partition(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> Index {
    let maybeOffset = try withContiguousMutableStorageIfAvailable {
      (bufferPointer) -> Int in
      let unsafeBufferPivot = try bufferPointer._partitionImpl(
        by: belongsInSecondPartition)
      return unsafeBufferPivot - bufferPointer.startIndex
    }
    if let offset = maybeOffset {
      return index(startIndex, offsetBy: offset)
    } else {
      return try _partitionImpl(by: belongsInSecondPartition)
    }
  }
  @inlinable
  internal mutating func _partitionImpl(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> Index {
    var lo = startIndex
    var hi = endIndex
    while true {
      while true {
        guard lo < hi else { return lo }
        if try belongsInSecondPartition(self[lo]) { break }
        formIndex(after: &lo)
      }
      while true {
        formIndex(before: &hi)
        guard lo < hi else { return lo }
        if try !belongsInSecondPartition(self[hi]) { break }
      }
      swapAt(lo, hi)
      formIndex(after: &lo)
    }
  }
}
extension MutableCollection {
  internal mutating func _indexedStablePartition(
    count n: Int,
    range: Range<Index>,
    by belongsInSecondPartition: (Index) throws-> Bool
  ) rethrows -> Index {
    if n == 0 { return range.lowerBound }
    if n == 1 {
      return try belongsInSecondPartition(range.lowerBound)
        ? range.lowerBound
        : range.upperBound
    }
    let h = n / 2, i = index(range.lowerBound, offsetBy: h)
    let j = try _indexedStablePartition(
      count: h,
      range: range.lowerBound..<i,
      by: belongsInSecondPartition)
    let k = try _indexedStablePartition(
      count: n - h,
      range: i..<range.upperBound,
      by: belongsInSecondPartition)
    return _rotate(in: j..<k, shiftingToStart: i)
  }
}
extension Collection {
  internal func _partitioningIndex(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Index {
    var n = count
    var l = startIndex
    while n > 0 {
      let half = n / 2
      let mid = index(l, offsetBy: half)
      if try predicate(self[mid]) {
        n = half
      } else {
        l = index(after: mid)
        n -= half + 1
      }
    }
    return l
  }
}
extension Sequence {
  @inlinable
  public func shuffled<T: RandomNumberGenerator>(
    using generator: inout T
  ) -> [Element] {
    var result = ContiguousArray(self)
    result.shuffle(using: &generator)
    return Array(result)
  }
  @inlinable
  public func shuffled() -> [Element] {
    var g = SystemRandomNumberGenerator()
    return shuffled(using: &g)
  }
}
extension MutableCollection where Self: RandomAccessCollection {
  @inlinable
  public mutating func shuffle<T: RandomNumberGenerator>(
    using generator: inout T
  ) {
    guard count > 1 else { return }
    var amount = count
    var currentIndex = startIndex
    while amount > 1 {
      let random = Int.random(in: 0 ..< amount, using: &generator)
      amount -= 1
      swapAt(
        currentIndex,
        index(currentIndex, offsetBy: random)
      )
      formIndex(after: &currentIndex)
    }
  }
  @inlinable
  public mutating func shuffle() {
    var g = SystemRandomNumberGenerator()
    shuffle(using: &g)
  }
}
