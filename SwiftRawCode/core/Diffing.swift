@available(SwiftStdlib 5.1, *)
extension CollectionDifference {
  fileprivate func _fastEnumeratedApply(
    _ consume: (Change) throws -> Void
  ) rethrows {
    let totalRemoves = removals.count
    let totalInserts = insertions.count
    var enumeratedRemoves = 0
    var enumeratedInserts = 0
    while enumeratedRemoves < totalRemoves || enumeratedInserts < totalInserts {
      let change: Change
      if enumeratedRemoves < removals.count && enumeratedInserts < insertions.count {
        let removeOffset = removals[enumeratedRemoves]._offset
        let insertOffset = insertions[enumeratedInserts]._offset
        if removeOffset - enumeratedRemoves <= insertOffset - enumeratedInserts {
          change = removals[enumeratedRemoves]
        } else {
          change = insertions[enumeratedInserts]
        }
      } else if enumeratedRemoves < totalRemoves {
        change = removals[enumeratedRemoves]
      } else if enumeratedInserts < totalInserts {
        change = insertions[enumeratedInserts]
      } else {
        preconditionFailure()
      }
      try consume(change)
      switch change {
      case .remove(_, _, _):
        enumeratedRemoves += 1
      case .insert(_, _, _):
        enumeratedInserts += 1
      }
    }
  }
}
private enum _ApplicationError : Error { case failed }
extension RangeReplaceableCollection {
  @available(SwiftStdlib 5.1, *)
  public func applying(_ difference: CollectionDifference<Element>) -> Self? {
    func append(
      into target: inout Self,
      contentsOf source: Self,
      from index: inout Self.Index, count: Int
    ) throws {
      let start = index
      if !source.formIndex(&index, offsetBy: count, limitedBy: source.endIndex) {
        throw _ApplicationError.failed
      }
      target.append(contentsOf: source[start..<index])
    }
    var result = Self()
    do {
      var enumeratedRemoves = 0
      var enumeratedInserts = 0
      var enumeratedOriginals = 0
      var currentIndex = self.startIndex
      try difference._fastEnumeratedApply { change in
        switch change {
        case .remove(offset: let offset, element: _, associatedWith: _):
          let origCount = offset - enumeratedOriginals
          try append(into: &result, contentsOf: self, from: &currentIndex, count: origCount)
          if currentIndex == self.endIndex {
            throw _ApplicationError.failed
          }
          enumeratedOriginals += origCount + 1 
          currentIndex = self.index(after: currentIndex)
          enumeratedRemoves += 1
        case .insert(offset: let offset, element: let element, associatedWith: _):
          let origCount = (offset + enumeratedRemoves - enumeratedInserts) - enumeratedOriginals
          try append(into: &result, contentsOf: self, from: &currentIndex, count: origCount)
          result.append(element)
          enumeratedOriginals += origCount
          enumeratedInserts += 1
        }
        _internalInvariant(enumeratedOriginals <= self.count)
      }
      if currentIndex < self.endIndex {
        result.append(contentsOf: self[currentIndex...])
      }
      _internalInvariant(result.count == self.count + enumeratedInserts - enumeratedRemoves)
    } catch {
      return nil
    }
    return result
  }
}
extension BidirectionalCollection {
  @available(SwiftStdlib 5.1, *)
  public func difference<C: BidirectionalCollection>(
    from other: C,
    by areEquivalent: (C.Element, Element) -> Bool
  ) -> CollectionDifference<Element>
  where C.Element == Self.Element {
    return _myers(from: other, to: self, using: areEquivalent)
  }
}
extension BidirectionalCollection where Element: Equatable {
  @available(SwiftStdlib 5.1, *)
  public func difference<C: BidirectionalCollection>(
    from other: C
  ) -> CollectionDifference<Element> where C.Element == Self.Element {
    return difference(from: other, by: ==)
  }
}
private struct _V {
  private var a: [Int]
#if INTERNAL_CHECKS_ENABLED
  private let isOdd: Bool
#endif
  init(maxIndex largest: Int) {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(largest >= 0)
    isOdd = largest % 2 == 1
#endif
    a = [Int](repeating: 0, count: largest + 1)
  }
  @inline(__always) private static func transform(_ index: Int) -> Int {
    return (index <= 0 ? -index : index &- 1)
  }
  subscript(index: Int) -> Int {
    get {
#if INTERNAL_CHECKS_ENABLED
      _internalInvariant(isOdd == (index % 2 != 0))
#endif
      return a[_V.transform(index)]
    }
    set(newValue) {
#if INTERNAL_CHECKS_ENABLED
      _internalInvariant(isOdd == (index % 2 != 0))
#endif
      a[_V.transform(index)] = newValue
    }
  }
}
@available(SwiftStdlib 5.1, *)
private func _myers<C,D>(
  from old: C, to new: D,
  using cmp: (C.Element, D.Element) -> Bool
) -> CollectionDifference<C.Element>
  where
    C: BidirectionalCollection,
    D: BidirectionalCollection,
    C.Element == D.Element
{
  func _descent(from a: UnsafeBufferPointer<C.Element>, to b: UnsafeBufferPointer<D.Element>) -> [_V] {
    let n = a.count
    let m = b.count
    let max = n + m
    var result = [_V]()
    var v = _V(maxIndex: 1)
    v[1] = 0
    var x = 0
    var y = 0
    iterator: for d in 0...max {
      let prev_v = v
      result.append(v)
      v = _V(maxIndex: d)
      for k in stride(from: -d, through: d, by: 2) {
        if k == -d {
          x = prev_v[k &+ 1]
        } else {
          let km = prev_v[k &- 1]
          if k != d {
            let kp = prev_v[k &+ 1]
            if km < kp {
              x = kp
            } else {
              x = km &+ 1
            }
          } else {
            x = km &+ 1
          }
        }
        y = x &- k
        while x < n && y < m {
          if !cmp(a[x], b[y]) {
            break;
          }
          x &+= 1
          y &+= 1
        }
        v[k] = x
        if x >= n && y >= m {
          break iterator
        }
      }
      if x >= n && y >= m {
        break
      }
    }
    _internalInvariant(x >= n && y >= m)
    return result
  }
  func _formChanges(
    from a: UnsafeBufferPointer<C.Element>,
    to b: UnsafeBufferPointer<C.Element>,
    using trace: [_V]
  ) -> [CollectionDifference<C.Element>.Change] {
    var changes = [CollectionDifference<C.Element>.Change]()
    changes.reserveCapacity(trace.count)
    var x = a.count
    var y = b.count
    for d in stride(from: trace.count &- 1, to: 0, by: -1) {
      let v = trace[d]
      let k = x &- y
      let prev_k = (k == -d || (k != d && v[k &- 1] < v[k &+ 1])) ? k &+ 1 : k &- 1
      let prev_x = v[prev_k]
      let prev_y = prev_x &- prev_k
      while x > prev_x && y > prev_y {
        x &-= 1
        y &-= 1
      }
      _internalInvariant((x == prev_x && y > prev_y) || (y == prev_y && x > prev_x))
      if y != prev_y {
        changes.append(.insert(offset: prev_y, element: b[prev_y], associatedWith: nil))
      } else {
        changes.append(.remove(offset: prev_x, element: a[prev_x], associatedWith: nil))
      }
      x = prev_x
      y = prev_y
    }
    return changes
  }
  /* Splatting the collections into contiguous storage has two advantages:
   *
   *   1) Subscript access is much faster
   *   2) Subscript index becomes Int, matching the iterator types in the algorithm
   *
   * Combined, these effects dramatically improves performance when
   * collections differ significantly, without unduly degrading runtime when
   * the parameters are very similar.
   *
   * In terms of memory use, the linear cost of creating a ContiguousArray (when
   * necessary) is significantly less than the worst-case n² memory use of the
   * descent algorithm.
   */
  func _withContiguousStorage<C: Collection, R>(
    for values: C,
    _ body: (UnsafeBufferPointer<C.Element>) throws -> R
  ) rethrows -> R {
    if let result = try values.withContiguousStorageIfAvailable(body) { return result }
    let array = ContiguousArray(values)
    return try array.withUnsafeBufferPointer(body)
  }
  return _withContiguousStorage(for: old) { a in
    return _withContiguousStorage(for: new) { b in
      return CollectionDifference(_formChanges(from: a, to: b, using:_descent(from: a, to: b)))!
    }
  }
}
