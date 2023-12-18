import SwiftShims
private var _CR: UInt8 { return 0x0d }
private var _LF: UInt8 { return 0x0a }
internal func _hasGraphemeBreakBetween(
  _ lhs: Unicode.Scalar, _ rhs: Unicode.Scalar
) -> Bool {
  if lhs == Unicode.Scalar(_CR) && rhs == Unicode.Scalar(_LF) {
    return false
  }
  func hasBreakWhenPaired(_ x: Unicode.Scalar) -> Bool {
    switch x.value {
    case 0x3400...0xa4cf: return true
    case 0x0000...0x02ff: return true
    case 0x3041...0x3096: return true
    case 0x30a1...0x30fc: return true
    case 0x0400...0x0482: return true
    case 0x061d...0x064a: return true
    case 0xac00...0xd7af: return true
    case 0x2010...0x2029: return true
    case 0x3000...0x3029: return true
    case 0xFF01...0xFF9D: return true
    default: return false
    }
  }
  return hasBreakWhenPaired(lhs) && hasBreakWhenPaired(rhs)
}
extension _StringGuts {
  @inline(__always)
  internal func roundDownToNearestCharacter(
    _ i: String.Index
  ) -> String.Index {
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(hasMatchingEncoding(i))
    _internalInvariant(i._encodedOffset <= count)
    let offset = i._encodedOffset
    if _fastPath(i._isCharacterAligned) { return i }
    if offset == 0 || offset == count { return i._characterAligned }
    return _slowRoundDownToNearestCharacter(i)
  }
  @inline(never)
  internal func _slowRoundDownToNearestCharacter(
    _ i: String.Index
  ) -> String.Index {
    let offset = i._encodedOffset
    let start = offset - _opaqueCharacterStride(endingAt: offset)
    let stride = _opaqueCharacterStride(startingAt: start)
    _internalInvariant(offset <= start + stride,
      "Grapheme breaking inconsistency")
    if offset >= start + stride {
      return i._characterAligned
    }
    let r = String.Index(encodedOffset: start, characterStride: stride)
    return markEncoding(r._characterAligned)
  }
  @inline(__always)
  internal func roundDownToNearestCharacter(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(
      bounds.lowerBound._isScalarAligned && bounds.upperBound._isScalarAligned)
    _internalInvariant(
      hasMatchingEncoding(bounds.lowerBound)
      && hasMatchingEncoding(bounds.upperBound))
    _internalInvariant(bounds.upperBound <= endIndex)
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(hasMatchingEncoding(i))
    _internalInvariant(i >= bounds.lowerBound && i <= bounds.upperBound)
    if _fastPath(
      bounds.lowerBound._isCharacterAligned && i._isCharacterAligned
    ) {
      return i
    }
    if i == bounds.lowerBound || i == bounds.upperBound { return i }
    return _slowRoundDownToNearestCharacter(i, in: bounds)
  }
  @inline(never)
  internal func _slowRoundDownToNearestCharacter(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    let offset = i._encodedOffset
    let offsetBounds = bounds._encodedOffsetRange
    let prior =
      offset - _opaqueCharacterStride(endingAt: offset, in: offsetBounds)
    let stride = _opaqueCharacterStride(startingAt: prior)
    _internalInvariant(offset <= prior + stride,
      "Grapheme breaking inconsistency")
    if offset >= prior + stride {
      return i
    }
    var r = String.Index(encodedOffset: prior, characterStride: stride)
    if bounds.lowerBound._isCharacterAligned {
      r = r._characterAligned
    } else {
      r = r._scalarAligned
    }
    return markEncoding(r)
  }
}
extension _StringGuts {
  @usableFromInline @inline(never)
  internal func isOnGraphemeClusterBoundary(_ i: String.Index) -> Bool {
    if i._isCharacterAligned { return true }
    guard i.transcodedOffset == 0 else { return false }
    let offset = i._encodedOffset
    if offset == 0 || offset == self.count { return true }
    guard isOnUnicodeScalarBoundary(i) else { return false }
    let nearest = roundDownToNearestCharacter(i._scalarAligned)
    return i == nearest
  }
}
extension _StringGuts {
  @usableFromInline @inline(never)
  internal func _opaqueCharacterStride(startingAt i: Int) -> Int {
    if _slowPath(isForeign) {
      return _foreignOpaqueCharacterStride(startingAt: i)
    }
    let nextIdx = withFastUTF8 { utf8 in
      nextBoundary(startingAt: i) { j in
        _internalInvariant(j >= 0)
        guard j < utf8.count else { return nil }
        let (scalar, len) = _decodeScalar(utf8, startingAt: j)
        return (scalar, j &+ len)
      }
    }
    return nextIdx &- i
  }
  @usableFromInline @inline(never)
  internal func _opaqueCharacterStride(endingAt i: Int) -> Int {
    if _slowPath(isForeign) {
      return _foreignOpaqueCharacterStride(endingAt: i)
    }
    let previousIdx = withFastUTF8 { utf8 in
      previousBoundary(endingAt: i) { j in
        _internalInvariant(j <= utf8.count)
        guard j > 0 else { return nil }
        let (scalar, len) = _decodeScalar(utf8, endingAt: j)
        return (scalar, j &- len)
      }
    }
    return i &- previousIdx
  }
  internal func _opaqueCharacterStride(
    endingAt i: Int,
    in bounds: Range<Int>
  ) -> Int {
    _internalInvariant(i > bounds.lowerBound && i <= bounds.upperBound)
    if _slowPath(isForeign) {
      return _foreignOpaqueCharacterStride(endingAt: i, in: bounds)
    }
    let previousIdx = withFastUTF8 { utf8 in
      previousBoundary(endingAt: i) { j in
        _internalInvariant(j <= bounds.upperBound)
        guard j > bounds.lowerBound else { return nil }
        let (scalar, len) = _decodeScalar(utf8, endingAt: j)
        return (scalar, j &- len)
      }
    }
    _internalInvariant(bounds.contains(previousIdx))
    return i &- previousIdx
  }
  @inline(never)
  private func _foreignOpaqueCharacterStride(startingAt i: Int) -> Int {
#if _runtime(_ObjC)
    _internalInvariant(isForeign)
    let nextIdx = nextBoundary(startingAt: i) { j in
      _internalInvariant(j >= 0)
      guard j < count else { return nil }
      let scalars = String.UnicodeScalarView(self)
      let idx = String.Index(_encodedOffset: j)
      let scalar = scalars[idx]
      let nextIdx = scalars.index(after: idx)
      return (scalar, nextIdx._encodedOffset)
    }
    return nextIdx &- i
#else
  fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
  @inline(never)
  private func _foreignOpaqueCharacterStride(
    startingAt i: Int,
    in bounds: Range<Int>
  ) -> Int {
#if _runtime(_ObjC)
    _internalInvariant(isForeign)
    _internalInvariant(bounds.contains(i))
    let nextIdx = nextBoundary(startingAt: i) { j in
      _internalInvariant(j >= bounds.lowerBound)
      guard j < bounds.upperBound else { return nil }
      let scalars = String.UnicodeScalarView(self)
      let idx = String.Index(_encodedOffset: j)
      let scalar = scalars[idx]
      let nextIdx = scalars.index(after: idx)
      return (scalar, nextIdx._encodedOffset)
    }
    return nextIdx &- i
#else
  fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
  @inline(never)
  private func _foreignOpaqueCharacterStride(endingAt i: Int) -> Int {
#if _runtime(_ObjC)
    _internalInvariant(isForeign)
    let previousIdx = previousBoundary(endingAt: i) { j in
      _internalInvariant(j <= self.count)
      guard j > 0 else { return nil }
      let scalars = String.UnicodeScalarView(self)
      let idx = String.Index(_encodedOffset: j)
      let previousIdx = scalars.index(before: idx)
      let scalar = scalars[previousIdx]
      return (scalar, previousIdx._encodedOffset)
    }
    return i &- previousIdx
#else
  fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
  @inline(never)
  private func _foreignOpaqueCharacterStride(
    endingAt i: Int,
    in bounds: Range<Int>
  ) -> Int {
#if _runtime(_ObjC)
    _internalInvariant(isForeign)
    _internalInvariant(i > bounds.lowerBound && i <= bounds.upperBound)
    let previousIdx = previousBoundary(endingAt: i) { j in
      _internalInvariant(j <= bounds.upperBound)
      guard j > bounds.lowerBound else { return nil }
      let scalars = String.UnicodeScalarView(self)
      let idx = String.Index(_encodedOffset: j)
      let previousIdx = scalars.index(before: idx)
      let scalar = scalars[previousIdx]
      return (scalar, previousIdx._encodedOffset)
    }
    return i &- previousIdx
#else
  fatalError("No foreign strings on Linux in this version of Swift")
#endif
  }
}
extension Unicode.Scalar {
  fileprivate var _isLinkingConsonant: Bool {
    _swift_stdlib_isLinkingConsonant(value)
  }
  fileprivate var _isVirama: Bool {
    switch value {
    case 0x94D:
      return true
    case 0x9CD:
      return true
    case 0xACD:
      return true
    case 0xB4D:
      return true
    case 0xC4D:
      return true
    case 0xD4D:
      return true
    default:
      return false
    }
  }
}
internal struct _GraphemeBreakingState: Sendable, Equatable {
  var hasSeenVirama = false
  var isInEmojiSequence = false
  var isInIndicSequence = false
  var shouldBreakRI = false
}
extension _GraphemeBreakingState: CustomStringConvertible {
  var description: String {
    var r = "["
    if hasSeenVirama { r += "V" }
    if isInEmojiSequence { r += "E" }
    if isInIndicSequence { r += "I" }
    if shouldBreakRI { r += "R" }
    r += "]"
    return r
  }
}
extension Unicode {
  @available(SwiftStdlib 5.8, *)
  public 
  struct _CharacterRecognizer: Sendable {
    internal var _previous: Unicode.Scalar
    internal var _state: _GraphemeBreakingState
    public static func quickBreak(
      between scalar1: Unicode.Scalar,
      and scalar2: Unicode.Scalar
    ) -> Bool? {
      if scalar1.value == 0xD, scalar2.value == 0xA {
        return false
      }
      if _hasGraphemeBreakBetween(scalar1, scalar2) {
        return true
      }
      return nil
    }
    public init() {
      _state = _GraphemeBreakingState()
      _previous = Unicode.Scalar(0 as UInt8)
    }
    public mutating func hasBreak(
      before next: Unicode.Scalar
    ) -> Bool {
      let r = _state.shouldBreak(between: _previous, and: next)
      if r {
        _state = _GraphemeBreakingState()
      }
      _previous = next
      return r
    }
    public mutating func _firstBreak(
      inUncheckedUnsafeUTF8Buffer buffer: UnsafeBufferPointer<UInt8>,
      startingAt start: Int = 0
    ) -> Range<Int>? {
      var i = start
      while i < buffer.endIndex {
        let (next, n) = _decodeScalar(buffer, startingAt: i)
        if hasBreak(before: next) {
          return Range(_uncheckedBounds: (i, i &+ n))
        }
        i &+= n
      }
      return nil
    }
  }
}
@available(SwiftStdlib 5.9, *)
extension Unicode._CharacterRecognizer: Equatable {
  public static func ==(left: Self, right: Self) -> Bool {
    left._previous == right._previous && left._state == right._state
  }
}
@available(SwiftStdlib 5.9, *)
extension Unicode._CharacterRecognizer: CustomStringConvertible {
  public var description: String {
    return "\(_state)U+\(String(_previous.value, radix: 16, uppercase: true))"
  }
}
extension _StringGuts {
  internal func nextBoundary(
    startingAt index: Int,
    nextScalar: (Int) -> (scalar: Unicode.Scalar, end: Int)?
  ) -> Int {
    _internalInvariant(index < endIndex._encodedOffset)
    var state = _GraphemeBreakingState()
    var (scalar, index) = nextScalar(index)!
    while true {
      guard let (scalar2, nextIndex) = nextScalar(index) else { break }
      if state.shouldBreak(between: scalar, and: scalar2) {
        break
      }
      index = nextIndex
      scalar = scalar2
    }
    return index
  }
  internal func previousBoundary(
    endingAt index: Int,
    previousScalar: (Int) -> (scalar: Unicode.Scalar, start: Int)?
  ) -> Int {
    var (scalar2, index) = previousScalar(index)!
    while true {
      guard let (scalar1, previousIndex) = previousScalar(index) else { break }
      if shouldBreakWithLookback(
        between: scalar1, and: scalar2, at: index, with: previousScalar
      ) {
        break
      }
      index = previousIndex
      scalar2 = scalar1
    }
    return index
  }
}
extension _GraphemeBreakingState {
  internal mutating func shouldBreak(
    between scalar1: Unicode.Scalar,
    and scalar2: Unicode.Scalar
  ) -> Bool {
    if scalar1.value == 0xD, scalar2.value == 0xA {
      return false
    }
    if _hasGraphemeBreakBetween(scalar1, scalar2) {
      return true
    }
    let x = Unicode._GraphemeBreakProperty(from: scalar1)
    let y = Unicode._GraphemeBreakProperty(from: scalar2)
    var enterEmojiSequence = false
    var enterIndicSequence = false
    defer {
      self.isInEmojiSequence = enterEmojiSequence
      self.isInIndicSequence = enterIndicSequence
    }
    switch (x, y) {
    case (.any, .any):
      return true
    case (.control, _):
      return true
    case (_, .control):
      return true
    case (.l, .l),
         (.l, .v),
         (.l, .lv),
         (.l, .lvt):
      return false
    case (.lv, .v),
         (.v, .v),
         (.lv, .t),
         (.v, .t):
      return false
    case (.lvt, .t),
         (.t, .t):
      return false
    case (_, .extend),
         (_, .zwj):
      if (
        x == .extendedPictographic || (self.isInEmojiSequence && x == .extend)
      ) {
        enterEmojiSequence = true
      }
      if self.isInIndicSequence || scalar1._isLinkingConsonant {
        if y == .extend {
          let extendNormData = Unicode._NormData(scalar2, fastUpperbound: 0x300)
          guard extendNormData.ccc != 0 else {
            return false
          }
        }
        enterIndicSequence = true
        if scalar2._isVirama {
          self.hasSeenVirama = true
        }
      }
      return false
    case (_, .spacingMark):
      return false
    case (.prepend, _):
      return false
    case (.zwj, .extendedPictographic):
      return !self.isInEmojiSequence
    case (.regionalIndicator, .regionalIndicator):
      defer {
        self.shouldBreakRI.toggle()
      }
      return self.shouldBreakRI
    default:
      if
        self.isInIndicSequence,
        self.hasSeenVirama,
        scalar2._isLinkingConsonant
      {
        self.hasSeenVirama = false
        return false
      }
      return true
    }
  }
}
extension _StringGuts {
  internal func shouldBreakWithLookback(
    between scalar1: Unicode.Scalar,
    and scalar2: Unicode.Scalar,
    at index: Int,
    with previousScalar: (Int) -> (scalar: Unicode.Scalar, start: Int)?
  ) -> Bool {
    if scalar1.value == 0xD, scalar2.value == 0xA {
      return false
    }
    if _hasGraphemeBreakBetween(scalar1, scalar2) {
      return true
    }
    let x = Unicode._GraphemeBreakProperty(from: scalar1)
    let y = Unicode._GraphemeBreakProperty(from: scalar2)
    switch (x, y) {
    case (.any, .any):
      return true
    case (.control, _):
      return true
    case (_, .control):
      return true
    case (.l, .l),
         (.l, .v),
         (.l, .lv),
         (.l, .lvt):
      return false
    case (.lv, .v),
         (.v, .v),
         (.lv, .t),
         (.v, .t):
      return false
    case (.lvt, .t),
         (.t, .t):
      return false
    case (_, .extend),
         (_, .zwj):
      return false
    case (_, .spacingMark):
      return false
    case (.prepend, _):
      return false
    case (.zwj, .extendedPictographic):
      return !checkIfInEmojiSequence(at: index, with: previousScalar)
    case (.regionalIndicator, .regionalIndicator):
      return countRIs(at: index, with: previousScalar)
    default:
      switch (x, scalar2._isLinkingConsonant) {
      case (.extend, true):
        let extendNormData = Unicode._NormData(scalar1, fastUpperbound: 0x300)
        guard extendNormData.ccc != 0 else {
          return true
        }
        return !checkIfInIndicSequence(at: index, with: previousScalar)
      case (.zwj, true):
        return !checkIfInIndicSequence(at: index, with: previousScalar)
      default:
        return true
      }
    }
  }
  internal func checkIfInEmojiSequence(
    at index: Int,
    with previousScalar: (Int) -> (scalar: Unicode.Scalar, start: Int)?
  ) -> Bool {
    guard var i = previousScalar(index)?.start else { return false }
    while let prev = previousScalar(i) {
      i = prev.start
      let gbp = Unicode._GraphemeBreakProperty(from: prev.scalar)
      switch gbp {
      case .extend:
        continue
      case .extendedPictographic:
        return true
      default:
        return false
      }
    }
    return false
  }
  internal func checkIfInIndicSequence(
    at index: Int,
    with previousScalar: (Int) -> (scalar: Unicode.Scalar, start: Int)?
  ) -> Bool {
    guard let p = previousScalar(index) else { return false }
    var hasSeenVirama = p.scalar._isVirama
    var i = p.start
    while let (scalar, prev) = previousScalar(i) {
      i = prev
      let gbp = Unicode._GraphemeBreakProperty(from: scalar)
      switch (gbp, scalar._isLinkingConsonant) {
      case (.extend, false):
        let extendNormData = Unicode._NormData(scalar, fastUpperbound: 0x300)
        guard extendNormData.ccc != 0 else {
          return false
        }
        if scalar._isVirama {
          hasSeenVirama = true
        }
      case (.zwj, false):
        continue
      case (_, true):
        return hasSeenVirama
      default:
        return false
      }
    }
    return false
  }
  internal func countRIs(
    at index: Int,
    with previousScalar: (Int) -> (scalar: Unicode.Scalar, start: Int)?
  ) -> Bool {
    guard let p = previousScalar(index) else { return false }
    var i = p.start
    var riCount = 0
    while let p = previousScalar(i) {
      i = p.start
      let gbp = Unicode._GraphemeBreakProperty(from: p.scalar)
      guard gbp == .regionalIndicator else {
        break
      }
      riCount += 1
    }
    return riCount & 1 != 0
  }
}
