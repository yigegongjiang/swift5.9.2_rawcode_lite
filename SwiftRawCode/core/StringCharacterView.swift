import SwiftShims
extension String: BidirectionalCollection {
  public typealias SubSequence = Substring
  public typealias Element = Character
  @inlinable @inline(__always)
  public var startIndex: Index { return _guts.startIndex }
  @inlinable @inline(__always)
  public var endIndex: Index { return _guts.endIndex }
  @inline(__always)
  public var count: Int {
    return distance(from: startIndex, to: endIndex)
  }
  internal func _isValidIndex(_ i: Index) -> Bool {
    return (
      _guts.hasMatchingEncoding(i)
      && i._encodedOffset <= _guts.count
      && _guts.isOnGraphemeClusterBoundary(i))
  }
  public func index(after i: Index) -> Index {
    let i = _guts.validateCharacterIndex(i)
    return _uncheckedIndex(after: i)
  }
  internal func _uncheckedIndex(after i: Index) -> Index {
    _internalInvariant(_guts.hasMatchingEncoding(i))
    _internalInvariant(i < endIndex)
    _internalInvariant(i._isCharacterAligned)
    let stride = _characterStride(startingAt: i)
    let nextOffset = i._encodedOffset &+ stride
    let nextIndex = Index(_encodedOffset: nextOffset)._characterAligned
    let nextStride = _characterStride(startingAt: nextIndex)
    let r = Index(encodedOffset: nextOffset, characterStride: nextStride)
    return _guts.markEncoding(r._characterAligned)
  }
  public func index(before i: Index) -> Index {
    let i = _guts.validateInclusiveCharacterIndex_5_7(i)
    _precondition(
      ifLinkedOnOrAfter: .v5_7_0,
      i > startIndex, "String index is out of bounds")
    return _uncheckedIndex(before: i)
  }
  internal func _uncheckedIndex(before i: Index) -> Index {
    _internalInvariant(_guts.hasMatchingEncoding(i))
    _internalInvariant(i > startIndex && i <= endIndex)
    _internalInvariant(i._isCharacterAligned)
    let stride = _characterStride(endingAt: i)
    let priorOffset = i._encodedOffset &- stride
    let r = Index(encodedOffset: priorOffset, characterStride: stride)
    return _guts.markEncoding(r._characterAligned)
  }
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    var i = _guts.validateInclusiveCharacterIndex_5_7(i)
    if distance >= 0 {
      for _ in stride(from: 0, to: distance, by: 1) {
        _precondition(i < endIndex, "String index is out of bounds")
        i = _uncheckedIndex(after: i)
      }
    } else {
      for _ in stride(from: 0, to: distance, by: -1) {
        _precondition(i > startIndex, "String index is out of bounds")
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
    var i = _guts.validateInclusiveCharacterIndex_5_7(i)
    if distance >= 0 {
      for _ in stride(from: 0, to: distance, by: 1) {
        guard limit < start || i < limit else { return nil }
        _precondition(i < endIndex, "String index is out of bounds")
        i = _uncheckedIndex(after: i)
      }
      guard limit < start || i <= limit else { return nil }
    } else {
      for _ in stride(from: 0, to: distance, by: -1) {
        guard limit > start || i > limit else { return nil }
        _precondition(i > startIndex, "String index is out of bounds")
        i = _uncheckedIndex(before: i)
      }
      guard limit > start || i >= limit else { return nil }
    }
    return i
  }
  public func distance(from start: Index, to end: Index) -> Int {
    let start = _guts.validateInclusiveCharacterIndex_5_7(start)
    let end = _guts.validateInclusiveCharacterIndex_5_7(end)
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
  public subscript(i: Index) -> Character {
    let i = _guts.validateScalarIndex(i)
    let distance = _characterStride(startingAt: i)
    return _guts.errorCorrectedCharacter(
      startingAt: i._encodedOffset, endingAt: i._encodedOffset &+ distance)
  }
  @usableFromInline
  @inline(__always)
  internal func _characterStride(startingAt i: Index) -> Int {
    _internalInvariant_5_1(i._isScalarAligned)
    if let d = i.characterStride { return d }
    if i == endIndex { return 0 }
    return _guts._opaqueCharacterStride(startingAt: i._encodedOffset)
  }
  @usableFromInline
  @inline(__always)
  internal func _characterStride(endingAt i: Index) -> Int {
    _internalInvariant_5_1(i._isScalarAligned)
    if i == startIndex { return 0 }
    return _guts._opaqueCharacterStride(endingAt: i._encodedOffset)
  }
}
extension String {
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
    public mutating func next() -> Character? {
      guard _fastPath(_position < _end) else { return nil }
      let len = _guts._opaqueCharacterStride(startingAt: _position)
      let nextPosition = _position &+ len
      let result = _guts.errorCorrectedCharacter(
        startingAt: _position, endingAt: nextPosition)
      _position = nextPosition
      return result
    }
  }
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_guts)
  }
}
