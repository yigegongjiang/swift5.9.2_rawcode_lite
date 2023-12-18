import SwiftShims
@inlinable @inline(__always) 
internal func _stringCompare(
  _ lhs: _StringGuts, _ rhs: _StringGuts, expecting: _StringComparisonResult
) -> Bool {
  if lhs.rawBits == rhs.rawBits { return expecting == .equal }
  return _stringCompareWithSmolCheck(lhs, rhs, expecting: expecting)
}
@usableFromInline
internal func _stringCompareWithSmolCheck(
  _ lhs: _StringGuts, _ rhs: _StringGuts, expecting: _StringComparisonResult
) -> Bool {
  if lhs.isSmallASCII && rhs.isSmallASCII {
    let lhsRaw = lhs.asSmall._storage
    let rhsRaw = rhs.asSmall._storage
    if lhsRaw.0 != rhsRaw.0 {
      return _lexicographicalCompare(
        lhsRaw.0.bigEndian, rhsRaw.0.bigEndian, expecting: expecting)
    }
    return _lexicographicalCompare(
      lhsRaw.1.bigEndian, rhsRaw.1.bigEndian, expecting: expecting)
  }
  return _stringCompareInternal(lhs, rhs, expecting: expecting)
}
@inline(never) 
@usableFromInline
internal func _stringCompareInternal(
  _ lhs: _StringGuts, _ rhs: _StringGuts, expecting: _StringComparisonResult
) -> Bool {
  guard _fastPath(lhs.isFastUTF8 && rhs.isFastUTF8) else {
    return _stringCompareSlow(lhs, rhs, expecting: expecting)
  }
  let isNFC = lhs.isNFC && rhs.isNFC
  return lhs.withFastUTF8 { lhsUTF8 in
    return rhs.withFastUTF8 { rhsUTF8 in
      return _stringCompareFastUTF8(
        lhsUTF8, rhsUTF8, expecting: expecting, bothNFC: isNFC)
    }
  }
}
@inlinable @inline(__always) 
internal func _stringCompare(
  _ lhs: _StringGuts, _ lhsRange: Range<Int>,
  _ rhs: _StringGuts, _ rhsRange: Range<Int>,
  expecting: _StringComparisonResult
) -> Bool {
  if lhs.rawBits == rhs.rawBits && lhsRange == rhsRange {
    return expecting == .equal
  }
  return _stringCompareInternal(
    lhs, lhsRange, rhs, rhsRange, expecting: expecting)
}
@usableFromInline
internal func _stringCompareInternal(
  _ lhs: _StringGuts, _ lhsRange: Range<Int>,
  _ rhs: _StringGuts, _ rhsRange: Range<Int>,
  expecting: _StringComparisonResult
) -> Bool {
  guard _fastPath(lhs.isFastUTF8 && rhs.isFastUTF8) else {
    return _stringCompareSlow(
      lhs, lhsRange, rhs, rhsRange, expecting: expecting)
  }
  let isNFC = lhs.isNFC && rhs.isNFC
  return lhs.withFastUTF8(range: lhsRange) { lhsUTF8 in
    return rhs.withFastUTF8(range: rhsRange) { rhsUTF8 in
      return _stringCompareFastUTF8(
        lhsUTF8, rhsUTF8, expecting: expecting, bothNFC: isNFC)
    }
  }
}
private func _stringCompareFastUTF8(
  _ utf8Left: UnsafeBufferPointer<UInt8>,
  _ utf8Right: UnsafeBufferPointer<UInt8>,
  expecting: _StringComparisonResult,
  bothNFC: Bool
) -> Bool {
  if _fastPath(bothNFC) {
    /*
     If we know both Strings are NFC *and* we're just checking
     equality, then we can early-out without looking at the contents
     if the UTF8 counts are different (without the NFC req, equal 
     characters can have different counts). It might be nicer to do 
     this in _binaryCompare, but we have the information about what 
     operation we're trying to do at this level.
     */
    if expecting == .equal && utf8Left.count != utf8Right.count {
        return false
    }
    let cmp = _binaryCompare(utf8Left, utf8Right)
    return _lexicographicalCompare(cmp, 0, expecting: expecting)
  }
  return _stringCompareFastUTF8Abnormal(
    utf8Left, utf8Right, expecting: expecting)
}
private func _stringCompareFastUTF8Abnormal(
  _ utf8Left: UnsafeBufferPointer<UInt8>,
  _ utf8Right: UnsafeBufferPointer<UInt8>,
  expecting: _StringComparisonResult
) -> Bool {
  guard let diffIdx = _findDiffIdx(utf8Left, utf8Right) else {
    return _lexicographicalCompare(
      utf8Left.count, utf8Right.count, expecting: expecting)
  }
  let scalarDiffIdx = _scalarAlign(utf8Left, diffIdx)
  _internalInvariant(scalarDiffIdx == _scalarAlign(utf8Right, diffIdx))
  let (leftScalar, leftLen) = _decodeScalar(utf8Left, startingAt: scalarDiffIdx)
  let (rightScalar, rightLen) = _decodeScalar(
    utf8Right, startingAt: scalarDiffIdx)
  if _fastPath(
    leftScalar._isNFCStarter && rightScalar._isNFCStarter &&
    utf8Left.hasNormalizationBoundary(before: scalarDiffIdx &+ leftLen) &&
    utf8Right.hasNormalizationBoundary(before: scalarDiffIdx &+ rightLen)
  ) {
    guard expecting == .less else {
      _internalInvariant(expecting == .equal)
      return false
    }
    return _lexicographicalCompare(
      leftScalar.value, rightScalar.value, expecting: .less)
  }
  let boundaryIdx = Swift.min(
    _findBoundary(utf8Left, before: diffIdx),
    _findBoundary(utf8Right, before: diffIdx))
  _internalInvariant(boundaryIdx <= diffIdx)
  return _stringCompareSlow(
    UnsafeBufferPointer(rebasing: utf8Left[boundaryIdx...]),
    UnsafeBufferPointer(rebasing: utf8Right[boundaryIdx...]),
    expecting: expecting)
}
private func _stringCompareSlow(
  _ lhs: _StringGuts, _ rhs: _StringGuts, expecting: _StringComparisonResult
) -> Bool {
  return _stringCompareSlow(
    lhs, 0..<lhs.count, rhs, 0..<rhs.count, expecting: expecting)
}
private func _stringCompareSlow(
  _ lhs: _StringGuts, _ lhsRange: Range<Int>,
  _ rhs: _StringGuts, _ rhsRange: Range<Int>,
  expecting: _StringComparisonResult
) -> Bool {
  return _StringGutsSlice(lhs, lhsRange).compare(
    with: _StringGutsSlice(rhs, rhsRange),
    expecting: expecting)
}
private func _stringCompareSlow(
  _ leftUTF8: UnsafeBufferPointer<UInt8>,
  _ rightUTF8: UnsafeBufferPointer<UInt8>,
  expecting: _StringComparisonResult
) -> Bool {
  let left = _StringGutsSlice(_StringGuts(leftUTF8, isASCII: false))
  let right = _StringGutsSlice(_StringGuts(rightUTF8, isASCII: false))
  return left.compare(with: right, expecting: expecting)
}
private func _findDiffIdx(
  _ left: UnsafeBufferPointer<UInt8>, _ right: UnsafeBufferPointer<UInt8>
) -> Int? {
  let count = Swift.min(left.count, right.count)
  var idx = 0
  while idx < count {
    guard left[_unchecked: idx] == right[_unchecked: idx] else {
      return idx
    }
    idx &+= 1
  }
  return nil
}
@inline(__always)
private func _lexicographicalCompare<I: FixedWidthInteger>(
  _ lhs: I, _ rhs: I, expecting: _StringComparisonResult
) -> Bool {
  return expecting == .equal ? lhs == rhs : lhs < rhs
}
private func _findBoundary(
  _ utf8: UnsafeBufferPointer<UInt8>, before: Int
) -> Int {
  var idx = before
  _internalInvariant(idx >= 0)
  guard idx < utf8.count else {
    _internalInvariant(before == utf8.count)
    return utf8.count
  }
  while UTF8.isContinuation(utf8[_unchecked: idx]) {
    idx &-= 1
  }
  while true {
    if idx == 0 { return 0 }
    let scalar = _decodeScalar(utf8, startingAt: idx).0
    if scalar._isNFCStarter {
      return idx
    }
    idx &-= _utf8ScalarLength(utf8, endingAt: idx)
  }
}
@frozen
@usableFromInline
internal enum _StringComparisonResult {
  case equal
  case less
  @inlinable @inline(__always)
  internal init(signedNotation int: Int) {
    _internalInvariant(int <= 0)
    self = int == 0 ? .equal : .less
  }
  @inlinable @inline(__always)
  static func ==(
    _ lhs: _StringComparisonResult, _ rhs: _StringComparisonResult
  ) -> Bool {
    switch (lhs, rhs) {
      case (.equal, .equal): return true
      case (.less, .less): return true
      default: return false
    }
  }
}
internal func _binaryCompare<UInt8>(
  _ lhs: UnsafeBufferPointer<UInt8>, _ rhs: UnsafeBufferPointer<UInt8>
) -> Int {
  var cmp = Int(truncatingIfNeeded:
    _swift_stdlib_memcmp(
      lhs.baseAddress._unsafelyUnwrappedUnchecked,
      rhs.baseAddress._unsafelyUnwrappedUnchecked,
      Swift.min(lhs.count, rhs.count)))
  if cmp == 0 {
    cmp = lhs.count &- rhs.count
  }
  return cmp
}
extension _StringGutsSlice {
  internal func compare(
    with other: _StringGutsSlice, expecting: _StringComparisonResult
  ) -> Bool {
    if _fastPath(self.isFastUTF8 && other.isFastUTF8) {
      Builtin.onFastPath() 
      let isEqual = self.withFastUTF8 { utf8Self in
        return other.withFastUTF8 { utf8Other in
          return 0 == _binaryCompare(utf8Self, utf8Other)
        }
      }
      if isEqual { return expecting == .equal }
    }
    return _slowCompare(with: other, expecting: expecting)
  }
  @inline(never) 
  internal func _slowCompare(
    with other: _StringGutsSlice,
    expecting: _StringComparisonResult
  ) -> Bool {
    var iter1 = Substring(self)._internalNFC.makeIterator()
    var iter2 = Substring(other)._internalNFC.makeIterator()
    var scalar1: Unicode.Scalar? = nil
    var scalar2: Unicode.Scalar? = nil
    while true {
      scalar1 = iter1.next()
      scalar2 = iter2.next()
      if scalar1 == nil || scalar2 == nil {
        break
      }
      if scalar1 == scalar2 {
        continue
      }
      if scalar1! < scalar2! {
        return expecting == .less
      } else {
        return false
      }
    }
    if scalar1 == nil, scalar2 == nil {
      return expecting == .equal
    }
    if end < other.end {
      return expecting == .less
    }
    return false
  }
}
