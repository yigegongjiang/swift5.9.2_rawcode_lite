public protocol MutableCollection<Element>: Collection
where SubSequence: MutableCollection
{
  override associatedtype Element
  override associatedtype Index
  override associatedtype SubSequence
  override subscript(position: Index) -> Element { get set }
  override subscript(bounds: Range<Index>) -> SubSequence { get set }
  mutating func partition(
    by belongsInSecondPartition: (Element) throws -> Bool
  ) rethrows -> Index
  mutating func swapAt(_ i: Index, _ j: Index)
  @available(*, deprecated, renamed: "withContiguousMutableStorageIfAvailable")
  mutating func _withUnsafeMutableBufferPointerIfSupported<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R?
  mutating func withContiguousMutableStorageIfAvailable<R>(
    _ body: (_ buffer: inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R?
}
extension MutableCollection {
  @inlinable
  @available(*, deprecated, renamed: "withContiguousMutableStorageIfAvailable")
  public mutating func _withUnsafeMutableBufferPointerIfSupported<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return nil
  }
  @inlinable
  public mutating func withContiguousMutableStorageIfAvailable<R>(
    _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return nil
  }
  @available(*, unavailable)
  @inlinable
  public subscript(bounds: Range<Index>) -> Slice<Self> {
    get {
      _failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
      return Slice(base: self, bounds: bounds)
    }
    set {
      _writeBackMutableSlice(&self, bounds: bounds, slice: newValue)
    }
  }
  @available(*, unavailable)
  public subscript(bounds: Range<Index>) -> SubSequence {
    get { fatalError() }
    set { fatalError() }
  }
  @inlinable
  public mutating func swapAt(_ i: Index, _ j: Index) {
    guard i != j else { return }
    let tmp = self[i]
    self[i] = self[j]
    self[j] = tmp
  }
}
extension MutableCollection where SubSequence == Slice<Self> {
  @inlinable
  public subscript(bounds: Range<Index>) -> Slice<Self> {
    get {
      _failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
      return Slice(base: self, bounds: bounds)
    }
    set {
      _writeBackMutableSlice(&self, bounds: bounds, slice: newValue)
    }
  }
}
extension MutableCollection {
  @discardableResult
  internal mutating func _rotate(
    in subrange: Range<Index>,
    shiftingToStart middle: Index
  ) -> Index {
    var m = middle, s = subrange.lowerBound
    let e = subrange.upperBound
    if s == m { return e }
    if m == e { return s }
    var ret = e 
    while true {
      let (s1, m1) = _swapNonemptySubrangePrefixes(s..<m, m..<e)
      if m1 == e {
        if ret == e { ret = s1 }
        if s1 == m { break }
      }
      s = s1
      if s == m { m = m1 }
    }
    return ret
  }
  internal mutating func _swapNonemptySubrangePrefixes(
    _ lhs: Range<Index>, _ rhs: Range<Index>
  ) -> (Index, Index) {
    _internalInvariant(!lhs.isEmpty)
    _internalInvariant(!rhs.isEmpty)
    var p = lhs.lowerBound
    var q = rhs.lowerBound
    repeat {
      swapAt(p, q)
      formIndex(after: &p)
      formIndex(after: &q)
    } while p != lhs.upperBound && q != rhs.upperBound
    return (p, q)
  }
}
@inlinable
public func swap<T>(_ a: inout T, _ b: inout T) {
#if $BuiltinUnprotectedAddressOf
  let p1 = Builtin.unprotectedAddressOf(&a)
  let p2 = Builtin.unprotectedAddressOf(&b)
#else
  let p1 = Builtin.addressof(&a)
  let p2 = Builtin.addressof(&b)
#endif
  _debugPrecondition(
    p1 != p2,
    "swapping a location with itself is not supported")
  let tmp: T = Builtin.take(p1)
  Builtin.initialize(Builtin.take(p2) as T, p1)
  Builtin.initialize(tmp, p2)
}
