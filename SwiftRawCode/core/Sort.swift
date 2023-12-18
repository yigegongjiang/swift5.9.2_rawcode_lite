extension Sequence where Element: Comparable {
  @inlinable
  public func sorted() -> [Element] {
    return sorted(by: <)
  }
}
extension Sequence {
  @inlinable
  public func sorted(
    by areInIncreasingOrder:
      (Element, Element) throws -> Bool
  ) rethrows -> [Element] {
    var result = ContiguousArray(self)
    try result.sort(by: areInIncreasingOrder)
    return Array(result)
  }
}
extension MutableCollection
where Self: RandomAccessCollection, Element: Comparable {
  @inlinable
  public mutating func sort() {
    sort(by: <)
  }
}
extension MutableCollection where Self: RandomAccessCollection {
  @inlinable
  public mutating func sort(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows {
    let didSortUnsafeBuffer: Void? =
      try withContiguousMutableStorageIfAvailable { buffer in
        try buffer._stableSortImpl(by: areInIncreasingOrder)
      }
    if didSortUnsafeBuffer == nil {
      let sortedElements = try sorted(by: areInIncreasingOrder)
      for (i, j) in zip(indices, sortedElements.indices) {
        self[i] = sortedElements[j]
      }
    }
  }
}
extension MutableCollection where Self: BidirectionalCollection {
  @inlinable
  internal mutating func _insertionSort(
    within range: Range<Index>,
    sortedEnd: Index,
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows {
    var sortedEnd = sortedEnd
    while sortedEnd != range.upperBound {
      var i = sortedEnd
      repeat {
        let j = index(before: i)
        if try !areInIncreasingOrder(self[i], self[j]) {
          break
        }
        swapAt(i, j)
        i = j
      } while i != range.lowerBound
      formIndex(after: &sortedEnd)
    }
  }
  @inlinable
  public 
  mutating func _insertionSort(
    within range: Range<Index>,
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows {
    if range.isEmpty {
      return
    }
    let sortedEnd = index(after: range.lowerBound)
    try _insertionSort(
      within: range, sortedEnd: sortedEnd, by: areInIncreasingOrder)
  }
  @inlinable
  internal mutating func _reverse(
    within range: Range<Index>
  ) {
    var f = range.lowerBound
    var l = range.upperBound
    while f < l {
      formIndex(before: &l)
      swapAt(f, l)
      formIndex(after: &f)
    }
  }
}
@discardableResult
@inlinable
internal func _merge<Element>(
  low: UnsafeMutablePointer<Element>,
  mid: UnsafeMutablePointer<Element>,
  high: UnsafeMutablePointer<Element>,
  buffer: UnsafeMutablePointer<Element>,
  by areInIncreasingOrder: (Element, Element) throws -> Bool
) rethrows -> Bool {
  let lowCount = mid - low
  let highCount = high - mid
  var destLow = low         
  var bufferLow = buffer    
  var bufferHigh = buffer   
  defer {
    destLow.moveInitialize(from: bufferLow, count: bufferHigh - bufferLow)
  }
  if lowCount < highCount {
    buffer.moveInitialize(from: low, count: lowCount)
    bufferHigh = bufferLow + lowCount
    var srcLow = mid
    while bufferLow < bufferHigh && srcLow < high {
      if try areInIncreasingOrder(srcLow.pointee, bufferLow.pointee) {
        destLow.moveInitialize(from: srcLow, count: 1)
        srcLow += 1
      } else {
        destLow.moveInitialize(from: bufferLow, count: 1)
        bufferLow += 1
      }
      destLow += 1
    }
  } else {
    buffer.moveInitialize(from: mid, count: highCount)
    bufferHigh = bufferLow + highCount
    var destHigh = high
    var srcHigh = mid
    destLow = mid
    while bufferHigh > bufferLow && srcHigh > low {
      destHigh -= 1
      if try areInIncreasingOrder(
        (bufferHigh - 1).pointee, (srcHigh - 1).pointee
      ) {
        srcHigh -= 1
        destHigh.moveInitialize(from: srcHigh, count: 1)
        destLow -= 1
      } else {
        bufferHigh -= 1
        destHigh.moveInitialize(from: bufferHigh, count: 1)
      }
    }
  }
  return true
}
@inlinable
internal func _minimumMergeRunLength(_ c: Int) -> Int {
  let bitsToUse = 6
  if c < 1 << bitsToUse {
    return c
  }
  let offset = (Int.bitWidth - bitsToUse) - c.leadingZeroBitCount
  let mask = (1 << offset) - 1
  return c >> offset + (c & mask == 0 ? 0 : 1)
}
@inlinable
internal func _findNextRun<C: RandomAccessCollection>(
  in elements: C,
  from start: C.Index,
  by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
) rethrows -> (end: C.Index, descending: Bool) {
  _internalInvariant(start < elements.endIndex)
  var previous = start
  var current = elements.index(after: start)
  guard current < elements.endIndex else {
    return (current, false)
  }
  let isDescending =
    try areInIncreasingOrder(elements[current], elements[previous])
  repeat {
    previous = current
    elements.formIndex(after: &current)
  } while try current < elements.endIndex &&
    isDescending == areInIncreasingOrder(elements[current], elements[previous])
  return(current, isDescending)
}
extension UnsafeMutableBufferPointer {
  @discardableResult
  @inlinable
  internal mutating func _mergeRuns(
    _ runs: inout [Range<Index>],
    at i: Int,
    buffer: UnsafeMutablePointer<Element>,
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> Bool {
    _internalInvariant(runs[i - 1].upperBound == runs[i].lowerBound)
    let low = runs[i - 1].lowerBound
    let middle = runs[i].lowerBound
    let high = runs[i].upperBound
    try _merge(
      low: baseAddress! + low,
      mid: baseAddress! + middle,
      high: baseAddress! + high,
      buffer: buffer,
      by: areInIncreasingOrder)
    runs[i - 1] = low..<high
    runs.remove(at: i)
    return true
  }
  @discardableResult
  @inlinable
  internal mutating func _mergeTopRuns(
    _ runs: inout [Range<Index>],
    buffer: UnsafeMutablePointer<Element>,
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> Bool {
    while runs.count > 1 {
      var lastIndex = runs.count - 1
      if lastIndex >= 3 &&
        (runs[lastIndex - 3].count <=
          runs[lastIndex - 2].count + runs[lastIndex - 1].count)
      {
        if runs[lastIndex - 2].count < runs[lastIndex].count {
          lastIndex -= 1
        }
      } else if lastIndex >= 2 &&
        (runs[lastIndex - 2].count <=
          runs[lastIndex - 1].count + runs[lastIndex].count)
      {
        if runs[lastIndex - 2].count < runs[lastIndex].count {
          lastIndex -= 1
        }
      } else if runs[lastIndex - 1].count <= runs[lastIndex].count {
      } else {
        break
      }
      try _mergeRuns(
        &runs, at: lastIndex, buffer: buffer, by: areInIncreasingOrder)
    }
    return true
  }
  @discardableResult
  @inlinable
  internal mutating func _finalizeRuns(
    _ runs: inout [Range<Index>],
    buffer: UnsafeMutablePointer<Element>,
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> Bool {
    while runs.count > 1 {
      try _mergeRuns(
        &runs, at: runs.count - 1, buffer: buffer, by: areInIncreasingOrder)
    }
    return true
  }
  @inlinable
  public mutating func _stableSortImpl(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows {
    let minimumRunLength = _minimumMergeRunLength(count)
    if count <= minimumRunLength {
      try _insertionSort(
        within: startIndex..<endIndex, by: areInIncreasingOrder)
      return
    }
    _ = try Array<Element>(_unsafeUninitializedCapacity: count / 2) {
      buffer, _ in
      var runs: [Range<Index>] = []
      var start = startIndex
      while start < endIndex {
        var (end, descending) =
          try _findNextRun(in: self, from: start, by: areInIncreasingOrder)
        if descending {
          _reverse(within: start..<end)
        }
        if end < endIndex && end - start < minimumRunLength {
          let newEnd = Swift.min(endIndex, start + minimumRunLength)
          try _insertionSort(
            within: start..<newEnd, sortedEnd: end, by: areInIncreasingOrder)
          end = newEnd
        }
        runs.append(start..<end)
        try _mergeTopRuns(
          &runs, buffer: buffer.baseAddress!, by: areInIncreasingOrder)
        start = end
      }
      try _finalizeRuns(
        &runs, buffer: buffer.baseAddress!, by: areInIncreasingOrder)
      _internalInvariant(runs.count == 1, "Didn't complete final merge")
    }
  }
}
