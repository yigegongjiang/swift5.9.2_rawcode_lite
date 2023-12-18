extension String {
  @frozen
  public struct UTF8View: Sendable {
    @usableFromInline
    internal var _guts: _StringGuts
    @inlinable @inline(__always)
    internal init(_ guts: _StringGuts) {
      self._guts = guts
      _invariantCheck()
    }
  }
}
extension String.UTF8View {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
  }
  #endif 
}
extension String.UTF8View: BidirectionalCollection {
  public typealias Index = String.Index
  public typealias Element = UTF8.CodeUnit
  @inlinable @inline(__always)
  public var startIndex: Index { return _guts.startIndex }
  @inlinable @inline(__always)
  public var endIndex: Index { return _guts.endIndex }
  @inlinable @inline(__always)
  public func index(after i: Index) -> Index {
    let i = _guts.ensureMatchingEncoding(i)
    if _fastPath(_guts.isFastUTF8) {
      return i.strippingTranscoding.nextEncoded._knownUTF8
    }
    _precondition(i._encodedOffset < _guts.count,
      "String index is out of bounds")
    return _foreignIndex(after: i)
  }
  @inlinable @inline(__always)
  public func index(before i: Index) -> Index {
    let i = _guts.ensureMatchingEncoding(i)
    _precondition(!i.isZeroPosition, "String index is out of bounds")
    if _fastPath(_guts.isFastUTF8) {
      return i.strippingTranscoding.priorEncoded._knownUTF8
    }
    _precondition(i._encodedOffset <= _guts.count,
      "String index is out of bounds")
    return _foreignIndex(before: i)
  }
  @inlinable @inline(__always)
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    let i = _guts.ensureMatchingEncoding(i)
    if _fastPath(_guts.isFastUTF8) {
      let offset = n + i._encodedOffset
      _precondition(offset >= 0 && offset <= _guts.count,
        "String index is out of bounds")
      return Index(_encodedOffset: offset)._knownUTF8
    }
    return _foreignIndex(i, offsetBy: n)
  }
  @inlinable @inline(__always)
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    let i = _guts.ensureMatchingEncoding(i)
    if _fastPath(_guts.isFastUTF8) {
      let iOffset = i._encodedOffset
      let result = iOffset + n
      let limitOffset = limit._encodedOffset
      if n >= 0 {
        guard limitOffset < iOffset || result <= limitOffset else { return nil }
      } else {
        guard limitOffset > iOffset || result >= limitOffset else { return nil }
      }
      _precondition(result >= 0 && result <= _guts.count,
        "String index is out of bounds")
      return Index(_encodedOffset: result)._knownUTF8
    }
    return _foreignIndex(i, offsetBy: n, limitedBy: limit)
  }
  @inlinable @inline(__always)
  public func distance(from i: Index, to j: Index) -> Int {
    let i = _guts.ensureMatchingEncoding(i)
    let j = _guts.ensureMatchingEncoding(j)
    if _fastPath(_guts.isFastUTF8) {
      return j._encodedOffset &- i._encodedOffset
    }
    _precondition(
      i._encodedOffset <= _guts.count && j._encodedOffset <= _guts.count,
      "String index is out of bounds")
    return _foreignDistance(from: i, to: j)
  }
  @inlinable @inline(__always)
  public subscript(i: Index) -> UTF8.CodeUnit {
    let i = _guts.ensureMatchingEncoding(i)
    _precondition(i._encodedOffset < _guts.count,
      "String index is out of bounds")
    return self[_unchecked: i]
  }
  internal subscript(_unchecked i: Index) -> UTF8.CodeUnit {
    if _fastPath(_guts.isFastUTF8) {
      return _guts.withFastUTF8 { utf8 in utf8[_unchecked: i._encodedOffset] }
    }
    return _foreignSubscript(position: i)
  }
}
extension String.UTF8View: CustomStringConvertible {
  @inlinable @inline(__always)
  public var description: String { return String(_guts) }
}
extension String.UTF8View: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "UTF8View(\(self.description.debugDescription))"
  }
}
extension String {
  @inlinable
  public var utf8: UTF8View {
    @inline(__always) get { return UTF8View(self._guts) }
    set { self = String(newValue._guts) }
  }
  public var utf8CString: ContiguousArray<CChar> {
    get {
      if _fastPath(_guts.isFastUTF8) {
        var result = _guts.withFastCChar { ContiguousArray($0) }
        result.append(0)
        return result
      }
      return _slowUTF8CString()
    }
  }
  @usableFromInline @inline(never) 
  internal func _slowUTF8CString() -> ContiguousArray<CChar> {
    var result = ContiguousArray<CChar>()
    result.reserveCapacity(self._guts.count + 1)
    for c in self.utf8 {
      result.append(CChar(bitPattern: c))
    }
    result.append(0)
    return result
  }
  @available(swift, introduced: 4.0, message:
  "Please use failable String.init?(_:UTF8View) when in Swift 3.2 mode")
  @inlinable @inline(__always)
  public init(_ utf8: UTF8View) {
    self = String(utf8._guts)
  }
}
extension String.UTF8View {
  @inlinable @inline(__always)
  public var count: Int {
    if _fastPath(_guts.isFastUTF8) {
      return _guts.count
    }
    return _foreignCount()
  }
}
extension String.UTF8View.Index {
  public init?(_ idx: String.Index, within target: String.UTF8View) {
    let idx = target._guts.ensureMatchingEncoding(idx)
    guard idx._encodedOffset <= target._guts.count else { return nil }
    if _slowPath(target._guts.isForeign) {
      guard idx._foreignIsWithin(target) else { return nil }
    } else {
      guard idx.transcodedOffset == 0 else { return nil }
    }
    self = idx
  }
}
#if SWIFT_ENABLE_REFLECTION
extension String.UTF8View: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: self)
  }
}
#endif
extension String.UTF8View {
  public typealias SubSequence = Substring.UTF8View
  @inlinable
  @available(swift, introduced: 4)
  public subscript(r: Range<Index>) -> String.UTF8View.SubSequence {
    let r = _guts.validateSubscalarRange(r)
    return Substring.UTF8View(self, _bounds: r)
  }
}
extension String.UTF8View {
  @inlinable @inline(__always)
  public func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Iterator.Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Iterator.Element>.Index) {
    guard buffer.baseAddress != nil else {
        _preconditionFailure(
          "Attempt to copy string contents into nil buffer pointer")
    }
    guard let written = _guts.copyUTF8(into: buffer) else {
      _preconditionFailure(
        "Insufficient space allocated to copy string contents")
    }
    let it = String().utf8.makeIterator()
    return (it, buffer.index(buffer.startIndex, offsetBy: written))
  }
}
extension String.UTF8View {
  internal func _utf8AlignForeignIndex(_ idx: String.Index) -> String.Index {
    _internalInvariant(_guts.isForeign)
    guard idx.transcodedOffset == 0 else { return idx }
    return _guts.scalarAlign(idx)
  }
  @usableFromInline @inline(never)
  internal func _foreignIndex(after idx: Index) -> Index {
    _internalInvariant(_guts.isForeign)
    _internalInvariant(idx._encodedOffset < _guts.count)
    let idx = _utf8AlignForeignIndex(idx)
    let (scalar, scalarLen) = _guts.foreignErrorCorrectedScalar(
      startingAt: idx.strippingTranscoding)
    let utf8Len = UTF8.width(scalar)
    if utf8Len == 1 {
      _internalInvariant(idx.transcodedOffset == 0)
      return idx.nextEncoded._scalarAligned._knownUTF16
    }
    if idx.transcodedOffset < utf8Len - 1 {
      return idx.nextTranscoded._knownUTF16
    }
    _internalInvariant(idx.transcodedOffset == utf8Len - 1)
    return idx.encoded(offsetBy: scalarLen)._scalarAligned._knownUTF16
  }
  @usableFromInline @inline(never)
  internal func _foreignIndex(before idx: Index) -> Index {
    _internalInvariant(_guts.isForeign)
    _internalInvariant(idx._encodedOffset <= _guts.count)
    let idx = _utf8AlignForeignIndex(idx)
    if idx.transcodedOffset != 0 {
      _internalInvariant((1...3) ~= idx.transcodedOffset)
      return idx.priorTranscoded._knownUTF16
    }
    let (scalar, scalarLen) = _guts.foreignErrorCorrectedScalar(
      endingAt: idx.strippingTranscoding)
    let utf8Len = UTF8.width(scalar)
    return idx.encoded(
      offsetBy: -scalarLen
    ).transcoded(withOffset: utf8Len &- 1)._knownUTF16
  }
  @usableFromInline @inline(never)
  internal func _foreignSubscript(position idx: Index) -> UTF8.CodeUnit {
    _internalInvariant(_guts.isForeign)
    let idx = _utf8AlignForeignIndex(idx)
    let scalar = _guts.foreignErrorCorrectedScalar(
      startingAt: idx.strippingTranscoding).0
    let encoded = Unicode.UTF8.encode(scalar)._unsafelyUnwrappedUnchecked
    _internalInvariant(idx.transcodedOffset < 1+encoded.count)
    return encoded[
      encoded.index(encoded.startIndex, offsetBy: idx.transcodedOffset)]
  }
  @usableFromInline @inline(never)
  internal func _foreignIndex(_ i: Index, offsetBy n: Int) -> Index {
    _internalInvariant(_guts.isForeign)
    return _index(i, offsetBy: n)
  }
  @usableFromInline @inline(never)
  internal func _foreignIndex(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    _internalInvariant(_guts.isForeign)
    return _index(i, offsetBy: n, limitedBy: limit)
  }
  @usableFromInline @inline(never)
  internal func _foreignDistance(from i: Index, to j: Index) -> Int {
    _internalInvariant(_guts.isForeign)
    let i = _utf8AlignForeignIndex(i)
    let j = _utf8AlignForeignIndex(j)
    #if _runtime(_ObjC)
    let count = _guts._object.withCocoaObject {
      _cocoaStringUTF8Count($0, range: i._encodedOffset ..< j._encodedOffset)
    }
    if let count {
      let refinedCount = (count - i.transcodedOffset) + j.transcodedOffset
      _internalInvariant(refinedCount == _distance(from: i, to: j))
      return refinedCount
    }
    #endif
    return _distance(from: i, to: j)
  }
  @usableFromInline @inline(never)
  internal func _foreignCount() -> Int {
    _internalInvariant(_guts.isForeign)
    return _foreignDistance(from: startIndex, to: endIndex)
  }
}
extension String.Index {
  @usableFromInline @inline(never) 
  internal func _foreignIsWithin(_ target: String.UTF8View) -> Bool {
    _internalInvariant(target._guts.isForeign)
    return self == target._utf8AlignForeignIndex(self)
  }
}
extension String.UTF8View {
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    guard _guts.isFastUTF8 else { return nil }
    return try _guts.withFastUTF8(body)
  }
}
