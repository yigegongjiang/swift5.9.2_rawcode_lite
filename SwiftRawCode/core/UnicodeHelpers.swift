@inlinable
@inline(__always)
internal func _decodeUTF8(_ x: UInt8) -> Unicode.Scalar {
  _internalInvariant(UTF8.isASCII(x))
  return Unicode.Scalar(_unchecked: UInt32(x))
}
@inlinable
@inline(__always)
internal func _decodeUTF8(_ x: UInt8, _ y: UInt8) -> Unicode.Scalar {
  _internalInvariant(_utf8ScalarLength(x) == 2)
  _internalInvariant(UTF8.isContinuation(y))
  let x = UInt32(x)
  let value = ((x & 0b0001_1111) &<< 6) | _continuationPayload(y)
  return Unicode.Scalar(_unchecked: value)
}
@inlinable
@inline(__always)
internal func _decodeUTF8(
  _ x: UInt8, _ y: UInt8, _ z: UInt8
) -> Unicode.Scalar {
  _internalInvariant(_utf8ScalarLength(x) == 3)
  _internalInvariant(UTF8.isContinuation(y) && UTF8.isContinuation(z))
  let x = UInt32(x)
  let value = ((x & 0b0000_1111) &<< 12)
            | (_continuationPayload(y) &<< 6)
            | _continuationPayload(z)
  return Unicode.Scalar(_unchecked: value)
}
@inlinable
@inline(__always)
internal func _decodeUTF8(
  _ x: UInt8, _ y: UInt8, _ z: UInt8, _ w: UInt8
) -> Unicode.Scalar {
  _internalInvariant(_utf8ScalarLength(x) == 4)
  _internalInvariant(
    UTF8.isContinuation(y) && UTF8.isContinuation(z)
    && UTF8.isContinuation(w))
  let x = UInt32(x)
  let value = ((x & 0b0000_1111) &<< 18)
            | (_continuationPayload(y) &<< 12)
            | (_continuationPayload(z) &<< 6)
            | _continuationPayload(w)
  return Unicode.Scalar(_unchecked: value)
}
@inlinable
internal func _decodeScalar(
  _ utf8: UnsafeBufferPointer<UInt8>, startingAt i: Int
) -> (Unicode.Scalar, scalarLength: Int) {
  let cu0 = utf8[_unchecked: i]
  let len = _utf8ScalarLength(cu0)
  switch  len {
  case 1: return (_decodeUTF8(cu0), len)
  case 2: return (_decodeUTF8(cu0, utf8[_unchecked: i &+ 1]), len)
  case 3: return (_decodeUTF8(
    cu0, utf8[_unchecked: i &+ 1], utf8[_unchecked: i &+ 2]), len)
  case 4:
    return (_decodeUTF8(
      cu0,
      utf8[_unchecked: i &+ 1],
      utf8[_unchecked: i &+ 2],
      utf8[_unchecked: i &+ 3]),
    len)
  default: Builtin.unreachable()
  }
}
@inlinable
internal func _decodeScalar(
  _ utf8: UnsafeBufferPointer<UInt8>, endingAt i: Int
) -> (Unicode.Scalar, scalarLength: Int) {
  let len = _utf8ScalarLength(utf8, endingAt: i)
  let (scalar, scalarLen) = _decodeScalar(utf8, startingAt: i &- len)
  _internalInvariant(len == scalarLen)
  return (scalar, len)
}
@inlinable @inline(__always)
internal func _utf8ScalarLength(_ x: UInt8) -> Int {
  _internalInvariant(!UTF8.isContinuation(x))
  if UTF8.isASCII(x) { return 1 }
  return (~x).leadingZeroBitCount
}
@inlinable @inline(__always)
internal func _utf8ScalarLength(
  _ utf8: UnsafeBufferPointer<UInt8>, endingAt i: Int
  ) -> Int {
  var len = 1
  while UTF8.isContinuation(utf8[_unchecked: i &- len]) {
    len &+= 1
  }
  _internalInvariant(len == _utf8ScalarLength(utf8[i &- len]))
  return len
}
@inlinable
@inline(__always)
internal func _continuationPayload(_ x: UInt8) -> UInt32 {
  return UInt32(x & 0x3F)
}
@inlinable
internal func _scalarAlign(
  _ utf8: UnsafeBufferPointer<UInt8>, _ idx: Int
) -> Int {
  guard _fastPath(idx != utf8.count) else { return idx }
  var i = idx
  while _slowPath(UTF8.isContinuation(utf8[_unchecked: i])) {
    i &-= 1
    _internalInvariant(i >= 0,
      "Malformed contents: starts with continuation byte")
  }
  return i
}
extension _StringGuts {
  @inlinable
  @inline(__always) 
  internal func scalarAlign(_ idx: Index) -> Index {
    let result: String.Index
    if _fastPath(idx._isScalarAligned) {
      result = idx
    } else {
      result = scalarAlignSlow(idx)._scalarAligned._copyingEncoding(from: idx)
    }
    _internalInvariant(isOnUnicodeScalarBoundary(result),
      "Alignment bit is set for non-aligned index")
    _internalInvariant_5_1(result._isScalarAligned)
    return result
  }
  @inline(never) 
  internal func scalarAlignSlow(_ idx: Index) -> Index {
    _internalInvariant_5_1(!idx._isScalarAligned)
    if _slowPath(idx.transcodedOffset != 0 || idx._encodedOffset == 0) {
      return String.Index(_encodedOffset: idx._encodedOffset)
    }
    if _slowPath(self.isForeign) {
      guard idx._encodedOffset != self.count else { return idx }
      let foreignIdx = foreignScalarAlign(idx)
      _internalInvariant_5_1(foreignIdx._isScalarAligned)
      return foreignIdx
    }
    return String.Index(_encodedOffset:
      self.withFastUTF8 { _scalarAlign($0, idx._encodedOffset) }
    )
  }
  @inlinable
  internal func fastUTF8ScalarLength(startingAt i: Int) -> Int {
    _internalInvariant(isFastUTF8)
    let len = _utf8ScalarLength(self.withFastUTF8 { $0[_unchecked: i] })
    _internalInvariant((1...4) ~= len)
    return len
  }
  @inlinable
  internal func fastUTF8ScalarLength(endingAt i: Int) -> Int {
    _internalInvariant(isFastUTF8)
    return self.withFastUTF8 { utf8 in
      _internalInvariant(i == utf8.count || !UTF8.isContinuation(utf8[i]))
      var len = 1
      while UTF8.isContinuation(utf8[i &- len]) {
        _internalInvariant(i &- len > 0)
        len += 1
      }
      _internalInvariant(len <= 4)
      return len
    }
  }
  @inlinable
  internal func fastUTF8Scalar(startingAt i: Int) -> Unicode.Scalar {
    _internalInvariant(isFastUTF8)
    return self.withFastUTF8 { _decodeScalar($0, startingAt: i).0 }
  }
  @inline(__always)
  internal func isOnUnicodeScalarBoundary(_ offset: Int) -> Bool {
    isOnUnicodeScalarBoundary(String.Index(_encodedOffset: offset))
  }
  @usableFromInline
  internal func isOnUnicodeScalarBoundary(_ i: String.Index) -> Bool {
    _internalInvariant(i._encodedOffset <= count)
    guard i.transcodedOffset == 0 else { return false }
    if i == self.startIndex || i == self.endIndex { return true }
    if _fastPath(isFastUTF8) {
      return self.withFastUTF8 {
        return !UTF8.isContinuation($0[_unchecked: i._encodedOffset])
      }
    }
    return i == foreignScalarAlign(i)
  }
}
extension _StringGuts {
  private func _getForeignCodeUnit(at i: Int) -> UInt16 {
#if _runtime(_ObjC)
    return _object.withCocoaObject { _cocoaStringSubscript($0, i) }
#else
    fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
  @usableFromInline
  internal func foreignErrorCorrectedScalar(
    startingAt idx: String.Index
  ) -> (Unicode.Scalar, scalarLength: Int) {
    _internalInvariant(idx.transcodedOffset == 0)
    _internalInvariant(idx._encodedOffset < self.count)
    let start = idx._encodedOffset
    let leading = _getForeignCodeUnit(at: start)
    if _fastPath(!UTF16.isSurrogate(leading)) {
      return (Unicode.Scalar(_unchecked: UInt32(leading)), 1)
    }
    let nextOffset = start &+ 1
    if _slowPath(UTF16.isTrailSurrogate(leading) || nextOffset == self.count) {
      return (Unicode.Scalar._replacementCharacter, 1)
    }
    let trailing = _getForeignCodeUnit(at: nextOffset)
    if _slowPath(!UTF16.isTrailSurrogate(trailing)) {
      return (Unicode.Scalar._replacementCharacter, 1)
    }
    return (UTF16._decodeSurrogates(leading, trailing), 2)
  }
  internal func foreignErrorCorrectedScalar(
    endingAt idx: String.Index
  ) -> (Unicode.Scalar, scalarLength: Int) {
    _internalInvariant(idx.transcodedOffset == 0)
    _internalInvariant(idx._encodedOffset <= self.count)
    _internalInvariant(idx._encodedOffset > 0)
    let end = idx._encodedOffset
    let trailing = _getForeignCodeUnit(at: end &- 1)
    if _fastPath(!UTF16.isSurrogate(trailing)) {
      return (Unicode.Scalar(_unchecked: UInt32(trailing)), 1)
    }
    let priorOffset = end &- 2
    if _slowPath(UTF16.isLeadSurrogate(trailing) || priorOffset < 0) {
      return (Unicode.Scalar._replacementCharacter, 1)
    }
    let leading = _getForeignCodeUnit(at: priorOffset)
    if _slowPath(!UTF16.isLeadSurrogate(leading)) {
      return (Unicode.Scalar._replacementCharacter, 1)
    }
    return (UTF16._decodeSurrogates(leading, trailing), 2)
  }
  internal func foreignErrorCorrectedUTF16CodeUnit(
    at idx: String.Index
  ) -> UInt16 {
    _internalInvariant(idx.transcodedOffset == 0)
    _internalInvariant(idx._encodedOffset < self.count)
    let start = idx._encodedOffset
    let cu = _getForeignCodeUnit(at: start)
    if _fastPath(!UTF16.isSurrogate(cu)) {
      return cu
    }
    if UTF16.isLeadSurrogate(cu) {
      let nextOffset = start &+ 1
      guard nextOffset < self.count,
            UTF16.isTrailSurrogate(_getForeignCodeUnit(at: nextOffset))
      else { return UTF16._replacementCodeUnit }
    } else {
      let priorOffset = start &- 1
      guard priorOffset >= 0,
            UTF16.isLeadSurrogate(_getForeignCodeUnit(at: priorOffset))
      else { return UTF16._replacementCodeUnit }
    }
    return cu
  }
  @usableFromInline @inline(never) 
  internal func foreignScalarAlign(_ idx: Index) -> Index {
    guard idx._encodedOffset != self.count else { return idx._scalarAligned }
    _internalInvariant(idx._encodedOffset < self.count)
    let ecCU = foreignErrorCorrectedUTF16CodeUnit(at: idx)
    if _fastPath(!UTF16.isTrailSurrogate(ecCU)) {
      return idx._scalarAligned
    }
    _internalInvariant(idx._encodedOffset > 0,
      "Error-correction shouldn't give trailing surrogate at position zero")
    return String.Index(_encodedOffset: idx._encodedOffset &- 1)._scalarAligned
  }
  @usableFromInline @inline(never)
  internal func foreignErrorCorrectedGrapheme(
    startingAt start: Int, endingAt end: Int
  ) -> Character {
#if _runtime(_ObjC)
    _internalInvariant(self.isForeign)
    let count = end &- start
    if start &- end == 1 {
      return Character(String(self.foreignErrorCorrectedScalar(
        startingAt: String.Index(_encodedOffset: start)
      ).0))
    }
    return withUnsafeTemporaryAllocation(
      of: UInt16.self, capacity: count
    ) { buffer in
      self._object.withCocoaObject {
        _cocoaStringCopyCharacters(
          from: $0,
          range: start..<end,
          into: buffer.baseAddress._unsafelyUnwrappedUnchecked
        )
      }
      return Character(String._uncheckedFromUTF16(UnsafeBufferPointer(buffer)))
    }
#else
    fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
}
extension _StringGuts {
  @inlinable @inline(__always)
  internal func errorCorrectedScalar(
    startingAt i: Int
  ) -> (Unicode.Scalar, scalarLength: Int) {
    if _fastPath(isFastUTF8) {
      return withFastUTF8 { _decodeScalar($0, startingAt: i) }
    }
    return foreignErrorCorrectedScalar(
      startingAt: String.Index(_encodedOffset: i))
  }
  @inlinable @inline(__always)
  internal func errorCorrectedCharacter(
    startingAt start: Int, endingAt end: Int
  ) -> Character {
    if _fastPath(isFastUTF8) {
      return withFastUTF8(range: start..<end) { utf8 in
        return Character(unchecked: String._uncheckedFromUTF8(utf8))
      }
    }
    return foreignErrorCorrectedGrapheme(startingAt: start, endingAt: end)
  }
}
