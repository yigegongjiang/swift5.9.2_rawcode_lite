extension String {
  @frozen
  public struct UnicodeScalarView: Sendable {
    @usableFromInline
    internal var _guts: _StringGuts
    @inlinable @inline(__always)
    internal init(_ _guts: _StringGuts) {
      self._guts = _guts
      _invariantCheck()
    }
  }
}
extension String.UnicodeScalarView {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
  }
  #endif 
}
extension String.UnicodeScalarView: BidirectionalCollection {
  public typealias Index = String.Index
  @inlinable @inline(__always)
  public var startIndex: Index { return _guts.startIndex }
  @inlinable @inline(__always)
  public var endIndex: Index { return _guts.endIndex }
  @inlinable @inline(__always)
  public func index(after i: Index) -> Index {
    let i = _guts.validateScalarIndex(i)
    return _uncheckedIndex(after: i)
  }
  @inline(__always)
  internal func _uncheckedIndex(after i: Index) -> Index {
    if _fastPath(_guts.isFastUTF8) {
      let len = _guts.fastUTF8ScalarLength(startingAt: i._encodedOffset)
      return i.encoded(offsetBy: len)._scalarAligned._knownUTF8
    }
    return _foreignIndex(after: i)
  }
  @inlinable @inline(__always)
  public func index(before i: Index) -> Index {
    let i = _guts.validateInclusiveScalarIndex(i)
    _precondition(i > startIndex, "String index is out of bounds")
    return _uncheckedIndex(before: i)
  }
  @inline(__always)
  internal func _uncheckedIndex(before i: Index) -> Index {
    if _fastPath(_guts.isFastUTF8) {
      let len = _guts.withFastUTF8 { utf8 in
        _utf8ScalarLength(utf8, endingAt: i._encodedOffset)
      }
      _internalInvariant(len <= 4, "invalid UTF8")
      return i.encoded(offsetBy: 0 &- len)._scalarAligned._knownUTF8
    }
    return _foreignIndex(before: i)
  }
  @inlinable @inline(__always)
  public subscript(position: Index) -> Unicode.Scalar {
    let i = _guts.validateScalarIndex(position)
    return _guts.errorCorrectedScalar(startingAt: i._encodedOffset).0
  }
  public func distance(from start: Index, to end: Index) -> Int {
    let start = _guts.validateInclusiveScalarIndex(start)
    let end = _guts.validateInclusiveScalarIndex(end)
    var i = start
    var count = 0
    if i < end {
      while i < end {
        count += 1
        i = _uncheckedIndex(after: i)
      }
    } else if i > end {
      while i > end {
        count -= 1
        i = _uncheckedIndex(before: i)
      }
    }
    return count
  }
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    var i = _guts.validateInclusiveScalarIndex(i)
    if distance >= 0 {
      for _ in stride(from: 0, to: distance, by: 1) {
        _precondition(i._encodedOffset < _guts.count, "String index is out of bounds")
        i = _uncheckedIndex(after: i)
      }
    } else {
      for _ in stride(from: 0, to: distance, by: -1) {
        _precondition(i._encodedOffset > 0, "String index is out of bounds")
        i = _uncheckedIndex(before: i)
      }
    }
    return i
  }
  public func index(
    _ i: Index, offsetBy distance: Int, limitedBy limit: Index
  ) -> Index? {
    let limit = _guts.ensureMatchingEncoding(limit)
    let start = _guts.ensureMatchingEncoding(i)
    var i = _guts.validateInclusiveScalarIndex(i)
    if distance >= 0 {
      for _ in stride(from: 0, to: distance, by: 1) {
        guard limit < start || i < limit else { return nil }
        _precondition(i._encodedOffset < _guts.count, "String index is out of bounds")
        i = _uncheckedIndex(after: i)
      }
      guard limit < start || i <= limit else { return nil }
    } else {
      for _ in stride(from: 0, to: distance, by: -1) {
        guard limit > start || i > limit else { return nil }
        _precondition(i._encodedOffset > 0, "String index is out of bounds")
        i = _uncheckedIndex(before: i)
      }
      guard limit > start || i >= limit else { return nil }
    }
    return i
  }
}
extension String.UnicodeScalarView {
  @frozen
  public struct Iterator: IteratorProtocol, Sendable {
    @usableFromInline
    internal var _guts: _StringGuts
    @usableFromInline
    internal var _position: Int = 0
    @usableFromInline
    internal var _end: Int
    @inlinable
    internal init(_ guts: _StringGuts) {
      self._end = guts.count
      self._guts = guts
    }
    @inlinable
    @inline(__always)
    public mutating func next() -> Unicode.Scalar? {
      guard _fastPath(_position < _end) else { return nil }
      let (result, len) = _guts.errorCorrectedScalar(startingAt: _position)
      _position &+= len
      return result
    }
  }
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_guts)
  }
}
extension String.UnicodeScalarView: CustomStringConvertible {
 @inlinable @inline(__always)
 public var description: String { return String(_guts) }
}
extension String.UnicodeScalarView: CustomDebugStringConvertible {
 public var debugDescription: String {
   return "StringUnicodeScalarView(\(self.description.debugDescription))"
 }
}
extension String {
  @inlinable @inline(__always)
  public init(_ unicodeScalars: UnicodeScalarView) {
    self.init(unicodeScalars._guts)
  }
  public typealias UnicodeScalarIndex = UnicodeScalarView.Index
  @inlinable
  public var unicodeScalars: UnicodeScalarView {
    @inline(__always) get { return UnicodeScalarView(_guts) }
    @inline(__always) set { _guts = newValue._guts }
    @inlinable @inline(__always)
    _modify {
      var view = self.unicodeScalars
      self = ""
      defer { self._guts = view._guts }
      yield &view
    }
  }
}
extension String.UnicodeScalarView: RangeReplaceableCollection {
  @inlinable @inline(__always)
  public init() {
    self.init(_StringGuts())
  }
  public mutating func reserveCapacity(_ n: Int) {
    self._guts.reserveCapacity(n)
  }
  public mutating func append(_ c: Unicode.Scalar) {
    self._guts.append(String(c)._guts)
  }
  public mutating func append<S: Sequence>(contentsOf newElements: S)
  where S.Element == Unicode.Scalar {
    let scalars = String(decoding: newElements.map { $0.value }, as: UTF32.self)
    self = (String(self._guts) + scalars).unicodeScalars
  }
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: C
  ) where C: Collection, C.Element == Unicode.Scalar {
    let subrange = _guts.validateScalarRange_5_7(subrange)
    _guts.replaceSubrange(subrange, with: newElements)
    _invariantCheck()
  }
}
extension String.UnicodeScalarIndex {
  public init?(
    _ sourcePosition: String.Index,
    within unicodeScalars: String.UnicodeScalarView
  ) {
    let i = unicodeScalars._guts.ensureMatchingEncoding(sourcePosition)
    guard
      i._encodedOffset <= unicodeScalars._guts.count,
      unicodeScalars._guts.isOnUnicodeScalarBoundary(i)
    else {
      return nil
    }
    self = i
  }
  public func samePosition(in characters: String) -> String.Index? {
    return String.Index(self, within: characters)
  }
}
#if SWIFT_ENABLE_REFLECTION
extension String.UnicodeScalarView: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: self)
  }
}
#endif
extension String.UnicodeScalarView {
  public typealias SubSequence = Substring.UnicodeScalarView
  @available(swift, introduced: 4)
  public subscript(r: Range<Index>) -> String.UnicodeScalarView.SubSequence {
    let r = _guts.validateScalarRange(r)
    return SubSequence(_unchecked: self, bounds: r)
  }
}
extension String.UnicodeScalarView {
  @usableFromInline @inline(never)
  internal func _foreignIndex(after i: Index) -> Index {
    _internalInvariant(_guts.isForeign)
    let cu = _guts.foreignErrorCorrectedUTF16CodeUnit(at: i)
    let len = UTF16.isLeadSurrogate(cu) ? 2 : 1
    let r = i.encoded(offsetBy: len)._scalarAligned
    return r._knownUTF16
  }
  @usableFromInline @inline(never)
  internal func _foreignIndex(before i: Index) -> Index {
    _internalInvariant(_guts.isForeign)
    let priorIdx = i.priorEncoded
    let cu = _guts.foreignErrorCorrectedUTF16CodeUnit(at: priorIdx)
    let len = UTF16.isTrailSurrogate(cu) ? 2 : 1
    let r = i.encoded(offsetBy: -len)._scalarAligned
    return r._knownUTF16
  }
}
