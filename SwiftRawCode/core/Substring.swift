extension String {
  @inlinable
  public init(_ substring: __shared Substring) {
    self = String._fromSubstring(substring)
  }
}
@frozen
public struct Substring: Sendable {
  @usableFromInline
  internal var _slice: Slice<String>
  @inline(__always)
  internal init(_unchecked slice: Slice<String>) {
    self._slice = slice
    _invariantCheck()
  }
  @inline(__always)
  internal init(_unchecked guts: _StringGuts, bounds: Range<Index>) {
    self.init(_unchecked: Slice(base: String(guts), bounds: bounds))
  }
  @usableFromInline 
  @available(*, deprecated) 
  internal init(_ slice: Slice<String>) {
    let r = slice._base._guts.validateScalarRange(slice._bounds)
    self._slice = Slice(base: slice._base, bounds: r)
    _invariantCheck()
  }
  @inline(__always)
  internal init(_ slice: _StringGutsSlice) {
    self.init(String(slice._guts)[slice.range])
  }
  @inlinable @inline(__always)
  public init() {
    self._slice = Slice()
  }
}
extension Substring {
  public var base: String { return _slice._base }
  @inlinable @inline(__always)
  internal var _wholeGuts: _StringGuts { _slice._base._guts }
  @inlinable @inline(__always)
  internal var _offsetRange: Range<Int> { _slice._bounds._encodedOffsetRange }
  internal var _bounds: Range<Index> { _slice._bounds }
}
extension Substring {
  internal var _startIsCharacterAligned: Bool {
    startIndex._isCharacterAligned
  }
}
extension Substring {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    _internalInvariant(endIndex <= _wholeGuts.endIndex)
    _internalInvariant(
      _wholeGuts.hasMatchingEncoding(startIndex) &&
      _wholeGuts.hasMatchingEncoding(endIndex))
    _internalInvariant(
      startIndex._isScalarAligned && endIndex._isScalarAligned)
    self.base._invariantCheck()
  }
  #endif 
}
extension Substring {
  internal func _isValidIndex(_ i: Index) -> Bool {
    guard
      _wholeGuts.hasMatchingEncoding(i),
      i >= startIndex,
      i <= endIndex,
      _wholeGuts.isOnUnicodeScalarBoundary(i)
    else {
      return false
    }
    let c = _wholeGuts.roundDownToNearestCharacter(
      i._scalarAligned, in: _bounds)
    return i == c
  }
}
extension Substring: StringProtocol {
  public typealias Index = String.Index
  public typealias SubSequence = Substring
  @inlinable @inline(__always)
  public var startIndex: Index { _slice._startIndex }
  @inlinable @inline(__always)
  public var endIndex: Index { _slice._endIndex }
  public func index(after i: Index) -> Index {
    let i = _wholeGuts.validateCharacterIndex(i, in: _bounds)
    return _uncheckedIndex(after: i)
  }
  internal func _uncheckedIndex(after i: Index) -> Index {
    _internalInvariant(_wholeGuts.hasMatchingEncoding(i))
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(i >= startIndex && i < endIndex)
    let stride = _characterStride(startingAt: i)
    let nextOffset = Swift.min(
      i._encodedOffset &+ stride,
      endIndex._encodedOffset)
    let nextIndex = Index(_encodedOffset: nextOffset)._scalarAligned
    let nextStride = _characterStride(startingAt: nextIndex)
    var r = Index(
      encodedOffset: nextOffset, characterStride: nextStride)._scalarAligned
    if _startIsCharacterAligned {
      r = r._characterAligned
    }
    return _wholeGuts.markEncoding(r)
  }
  public func index(before i: Index) -> Index {
    let i = _wholeGuts.validateInclusiveCharacterIndex(i, in: _bounds)
    _precondition(i > startIndex, "Substring index is out of bounds")
    return _uncheckedIndex(before: i)
  }
  internal func _uncheckedIndex(before i: Index) -> Index {
    _internalInvariant(_wholeGuts.hasMatchingEncoding(i))
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(i > startIndex && i <= endIndex)
    let priorStride = _characterStride(endingAt: i)
    let priorOffset = i._encodedOffset &- priorStride
    _internalInvariant(priorOffset >= startIndex._encodedOffset)
    var r = Index(
      encodedOffset: priorOffset, characterStride: priorStride
    )._scalarAligned
    if _startIsCharacterAligned {
      r = r._characterAligned
    }
    return _wholeGuts.markEncoding(r)
  }
  public func index(_ i: Index, offsetBy distance: Int) -> Index {
    var i = _wholeGuts.validateInclusiveCharacterIndex(i, in: _bounds)
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
    let limit = _wholeGuts.ensureMatchingEncoding(limit)
    let start = _wholeGuts.ensureMatchingEncoding(i)
    var i = _wholeGuts.validateInclusiveCharacterIndex(i, in: _bounds)
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
    let start = _wholeGuts.validateInclusiveCharacterIndex(start, in: _bounds)
    let end = _wholeGuts.validateInclusiveCharacterIndex(end, in: _bounds)
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
    let i = _wholeGuts.validateScalarIndex(i, in: _bounds)
    let stride = _characterStride(startingAt: i)
    let endOffset = Swift.min(
      i._encodedOffset &+ stride,
      endIndex._encodedOffset)
    return _wholeGuts.errorCorrectedCharacter(
      startingAt: i._encodedOffset, endingAt: endOffset)
  }
  public mutating func replaceSubrange<C>(
    _ subrange: Range<Index>,
    with newElements: C
  ) where C: Collection, C.Iterator.Element == Iterator.Element {
    _replaceSubrange(subrange, with: newElements)
  }
  public mutating func replaceSubrange(
    _ subrange: Range<Index>, with newElements: Substring
  ) {
    _replaceSubrange(subrange, with: newElements)
  }
  internal mutating func _replaceSubrange<C: Collection>(
    _ subrange: Range<Index>, with newElements: C
  ) where C.Element == Element {
    let subrange = _wholeGuts.validateScalarRange(subrange, in: _bounds)
    _slice._base._guts.mutateSubrangeInSubstring(
      subrange: subrange,
      startIndex: &_slice._startIndex,
      endIndex: &_slice._endIndex,
      with: { $0.replaceSubrange(subrange, with: newElements) })
    _invariantCheck()
  }
  @inlinable 
  public init<C: Collection, Encoding: _UnicodeEncoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  ) where C.Iterator.Element == Encoding.CodeUnit {
    self.init(String(decoding: codeUnits, as: sourceEncoding))
  }
  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(String(cString: nullTerminatedUTF8))
  }
  @inlinable 
  public init<Encoding: _UnicodeEncoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) {
    self.init(
      String(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))
  }
  @inlinable 
  public func withCString<Result>(
    _ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    return try String(self).withCString(body)
  }
  @inlinable 
  public func withCString<Result, TargetEncoding: _UnicodeEncoding>(
    encodedAs targetEncoding: TargetEncoding.Type,
    _ body: (UnsafePointer<TargetEncoding.CodeUnit>) throws -> Result
  ) rethrows -> Result {
    return try String(self).withCString(encodedAs: targetEncoding, body)
  }
}
extension Substring {
  internal func _characterStride(startingAt i: Index) -> Int {
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(i._encodedOffset <= _wholeGuts.count)
    if let d = i.characterStride { return d }
    if i._encodedOffset == endIndex._encodedOffset { return 0 }
    return _wholeGuts._opaqueCharacterStride(startingAt: i._encodedOffset)
  }
  internal func _characterStride(endingAt i: Index) -> Int {
    _internalInvariant(i._isScalarAligned)
    _internalInvariant(i._encodedOffset <= _wholeGuts.count)
    if i == startIndex { return 0 }
    return _wholeGuts._opaqueCharacterStride(
      endingAt: i._encodedOffset, in: _offsetRange)
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Substring: CustomReflectable {
 public var customMirror: Mirror { return String(self).customMirror }
}
#endif
extension Substring: CustomStringConvertible {
  @inlinable @inline(__always)
  public var description: String { return String(self) }
}
extension Substring: CustomDebugStringConvertible {
  public var debugDescription: String { return String(self).debugDescription }
}
extension Substring: LosslessStringConvertible {
  public init(_ content: String) {
    let range = Range(_uncheckedBounds: (content.startIndex, content.endIndex))
    self.init(_unchecked: Slice(base: content, bounds: range))
  }
}
extension Substring {
  @frozen
  public struct UTF8View: Sendable {
    @usableFromInline
    internal var _slice: Slice<String.UTF8View>
    @inlinable
    internal init(_ base: String.UTF8View, _bounds: Range<Index>) {
      _slice = Slice(base: base, bounds: _bounds)
    }
    internal var _wholeGuts: _StringGuts { _slice._base._guts }
    internal var _base: String.UTF8View { _slice._base }
    internal var _bounds: Range<Index> { _slice._bounds }
  }
}
extension Substring.UTF8View: BidirectionalCollection {
  public typealias Index = String.UTF8View.Index
  public typealias Indices = String.UTF8View.Indices
  public typealias Element = String.UTF8View.Element
  public typealias SubSequence = Substring.UTF8View
  @inlinable
  public var startIndex: Index { _slice._startIndex }
  @inlinable
  public var endIndex: Index { _slice._endIndex }
  @inlinable
  public subscript(index: Index) -> Element {
    let index = _wholeGuts.ensureMatchingEncoding(index)
    _precondition(index >= startIndex && index < endIndex,
      "String index is out of bounds")
    return _base[_unchecked: index]
  }
  @inlinable
  public var indices: Indices { return _slice.indices }
  @inlinable
  public func index(after i: Index) -> Index {
    return _base.index(after: i)
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    _base.formIndex(after: &i)
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return _base.index(i, offsetBy: n)
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _base.index(i, offsetBy: n, limitedBy: limit)
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _base.distance(from: start, to: end)
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return try _slice.withContiguousStorageIfAvailable(body)
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    _base._failEarlyRangeCheck(index, bounds: bounds)
  }
  @inlinable
  public func _failEarlyRangeCheck(
    _ range: Range<Index>, bounds: Range<Index>
  ) {
    _base._failEarlyRangeCheck(range, bounds: bounds)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    return _base.index(before: i)
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    _base.formIndex(before: &i)
  }
  @inlinable
  public subscript(r: Range<Index>) -> Substring.UTF8View {
    let r = _wholeGuts.validateSubscalarRange(r, in: _bounds)
    return Substring.UTF8View(_slice.base, _bounds: r)
  }
}
extension Substring {
  @inlinable
  public var utf8: UTF8View {
    get {
      UTF8View(base.utf8, _bounds: _bounds)
    }
    set {
      self = Substring(newValue)
    }
  }
  public init(_ content: UTF8View) {
    let lower = content._wholeGuts.scalarAlign(content.startIndex)
    let upper = content._wholeGuts.scalarAlign(content.endIndex)
    let bounds = Range(_uncheckedBounds: (lower, upper))
    self.init(_unchecked: content._wholeGuts, bounds: bounds)
  }
}
extension String {
  public init?(_ codeUnits: Substring.UTF8View) {
    let guts = codeUnits._wholeGuts
    guard guts.isOnUnicodeScalarBoundary(codeUnits.startIndex),
          guts.isOnUnicodeScalarBoundary(codeUnits.endIndex) else {
      return nil
    }
    self = String(Substring(codeUnits))
  }
}
extension Substring {
  @frozen
  public struct UTF16View: Sendable {
    @usableFromInline
    internal var _slice: Slice<String.UTF16View>
    @inlinable
    internal init(_ base: String.UTF16View, _bounds: Range<Index>) {
      _slice = Slice(base: base, bounds: _bounds)
    }
    internal var _wholeGuts: _StringGuts { _slice._base._guts }
    internal var _base: String.UTF16View { _slice._base }
    internal var _bounds: Range<Index> { _slice._bounds }
  }
}
extension Substring.UTF16View: BidirectionalCollection {
  public typealias Index = String.UTF16View.Index
  public typealias Indices = String.UTF16View.Indices
  public typealias Element = String.UTF16View.Element
  public typealias SubSequence = Substring.UTF16View
  @inlinable
  public var startIndex: Index { _slice._startIndex }
  @inlinable
  public var endIndex: Index { _slice._endIndex }
  @inlinable
  public subscript(index: Index) -> Element {
    let index = _wholeGuts.ensureMatchingEncoding(index)
    _precondition(index >= startIndex && index < endIndex,
      "String index is out of bounds")
    return _base[_unchecked: index]
  }
  @inlinable
  public var indices: Indices { return _slice.indices }
  @inlinable
  public func index(after i: Index) -> Index {
    return _base.index(after: i)
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    _base.formIndex(after: &i)
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return _base.index(i, offsetBy: n)
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _base.index(i, offsetBy: n, limitedBy: limit)
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _base.distance(from: start, to: end)
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    _base._failEarlyRangeCheck(index, bounds: bounds)
  }
  @inlinable
  public func _failEarlyRangeCheck(
    _ range: Range<Index>, bounds: Range<Index>
  ) {
    _base._failEarlyRangeCheck(range, bounds: bounds)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    return _base.index(before: i)
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    _base.formIndex(before: &i)
  }
  @inlinable
  public subscript(r: Range<Index>) -> Substring.UTF16View {
    let r = _wholeGuts.validateSubscalarRange(r, in: _bounds)
    return Substring.UTF16View(_slice.base, _bounds: r)
  }
}
extension Substring {
  @inlinable
  public var utf16: UTF16View {
    get {
      UTF16View(base.utf16, _bounds: _bounds)
    }
    set {
      self = Substring(newValue)
    }
  }
  public init(_ content: UTF16View) {
    let lower = content._wholeGuts.scalarAlign(content.startIndex)
    let upper = content._wholeGuts.scalarAlign(content.endIndex)
    let bounds = Range(_uncheckedBounds: (lower, upper))
    self.init(_unchecked: content._wholeGuts, bounds: bounds)
  }
}
extension String {
  public init?(_ codeUnits: Substring.UTF16View) {
    let guts = codeUnits._wholeGuts
    guard guts.isOnUnicodeScalarBoundary(codeUnits.startIndex),
          guts.isOnUnicodeScalarBoundary(codeUnits.endIndex) else {
      return nil
    }
    self = String(Substring(codeUnits))
  }
}
extension Substring {
  @frozen
  public struct UnicodeScalarView: Sendable {
    @usableFromInline
    internal var _slice: Slice<String.UnicodeScalarView>
    internal init(
      _unchecked base: String.UnicodeScalarView, bounds: Range<Index>
    ) {
      _slice = Slice(base: base, bounds: bounds)
      _invariantCheck()
    }
    @usableFromInline 
    @available(*, deprecated, message: "Use `init(_unchecked:bounds)` in new code")
    internal init(_ base: String.UnicodeScalarView, _bounds: Range<Index>) {
      let start = base._guts.scalarAlign(_bounds.lowerBound)
      let end = base._guts.scalarAlign(_bounds.upperBound)
      _slice = Slice(base: base, bounds: Range(_uncheckedBounds: (start, end)))
    }
  }
}
extension Substring.UnicodeScalarView {
  internal var _wholeGuts: _StringGuts { _slice._base._guts }
  @inline(__always)
  internal var _offsetRange: Range<Int> { _slice._bounds._encodedOffsetRange }
  @inline(__always)
  internal var _bounds: Range<Index> { _slice._bounds }
}
extension Substring.UnicodeScalarView {
  #if !INTERNAL_CHECKS_ENABLED
  internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    _internalInvariant(endIndex <= _wholeGuts.endIndex)
    _internalInvariant(
      _wholeGuts.hasMatchingEncoding(startIndex) &&
      _wholeGuts.hasMatchingEncoding(endIndex))
    _internalInvariant(
      startIndex._isScalarAligned && endIndex._isScalarAligned)
    _slice._base._invariantCheck()
  }
  #endif 
}
extension Substring.UnicodeScalarView: BidirectionalCollection {
  public typealias Index = String.UnicodeScalarView.Index
  public typealias Indices = String.UnicodeScalarView.Indices
  public typealias Element = String.UnicodeScalarView.Element
  public typealias SubSequence = Substring.UnicodeScalarView
  @inlinable @inline(__always)
  public var startIndex: Index { _slice._startIndex }
  @inlinable @inline(__always)
  public var endIndex: Index { _slice._endIndex }
  @inlinable
  public subscript(index: Index) -> Element {
    let index = _wholeGuts.validateScalarIndex(index, in: _bounds)
    return _wholeGuts.errorCorrectedScalar(startingAt: index._encodedOffset).0
  }
  @inlinable
  public var indices: Indices {
    return _slice.indices
  }
  @inlinable
  public func index(after i: Index) -> Index {
    _slice._base.index(after: i)
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    _slice._base.formIndex(after: &i)
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    _slice._base.index(i, offsetBy: n)
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    _slice._base.index(i, offsetBy: n, limitedBy: limit)
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    _slice._base.distance(from: start, to: end)
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
    _slice._base._failEarlyRangeCheck(index, bounds: bounds)
  }
  @inlinable
  public func _failEarlyRangeCheck(
    _ range: Range<Index>, bounds: Range<Index>
  ) {
    _slice._base._failEarlyRangeCheck(range, bounds: bounds)
  }
  @inlinable
  public func index(before i: Index) -> Index {
    _slice._base.index(before: i)
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    _slice._base.formIndex(before: &i)
  }
  public subscript(r: Range<Index>) -> Substring.UnicodeScalarView {
    let r = _wholeGuts.validateScalarRange(r, in: _bounds)
    return Substring.UnicodeScalarView(_unchecked: _slice._base, bounds: r)
  }
}
extension Substring {
  @inlinable
  public var unicodeScalars: UnicodeScalarView {
    get {
      UnicodeScalarView(_unchecked: base.unicodeScalars, bounds: _bounds)
    }
    set {
      self = Substring(newValue)
    }
  }
  public init(_ content: UnicodeScalarView) {
    let slice = Slice(base: String(content._wholeGuts), bounds: content._bounds)
    self.init(_unchecked: slice)
  }
}
extension String {
  public init(_ content: Substring.UnicodeScalarView) {
    self = String(Substring(content))
  }
}
extension Substring.UnicodeScalarView: RangeReplaceableCollection {
  @inlinable
  public init() { _slice = Slice.init() }
  public mutating func replaceSubrange<C: Collection>(
    _ subrange: Range<Index>, with replacement: C
  ) where C.Element == Element {
    let subrange = _wholeGuts.validateScalarRange(subrange, in: _bounds)
    _slice._base._guts.mutateSubrangeInSubstring(
      subrange: subrange,
      startIndex: &_slice._startIndex,
      endIndex: &_slice._endIndex,
      with: { $0.replaceSubrange(subrange, with: replacement) })
    _invariantCheck()
  }
}
extension Substring: RangeReplaceableCollection {
  public init<S: Sequence>(_ elements: S)
  where S.Element == Character {
    if let str = elements as? String {
      self.init(str)
      return
    }
    if let subStr = elements as? Substring {
      self = subStr
      return
    }
    self.init(String(elements))
  }
  @inlinable 
  public mutating func append<S: Sequence>(contentsOf elements: S)
  where S.Element == Character {
    var string = String(self)
    self = Substring() 
    string.append(contentsOf: elements)
    self = Substring(string)
  }
}
extension Substring {
  public func lowercased() -> String {
    return String(self).lowercased()
  }
  public func uppercased() -> String {
    return String(self).uppercased()
  }
  public func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> String {
    return try String(self.lazy.filter(isIncluded))
  }
}
extension Substring: TextOutputStream {
  public mutating func write(_ other: String) {
    append(contentsOf: other)
  }
}
extension Substring: TextOutputStreamable {
  @inlinable 
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write(String(self))
  }
}
extension Substring: ExpressibleByUnicodeScalarLiteral {
  @inlinable
  public init(unicodeScalarLiteral value: String) {
     self.init(value)
  }
}
extension Substring: ExpressibleByExtendedGraphemeClusterLiteral {
  @inlinable
  public init(extendedGraphemeClusterLiteral value: String) {
     self.init(value)
  }
}
extension Substring: ExpressibleByStringLiteral {
  @inlinable
  public init(stringLiteral value: String) {
     self.init(value)
  }
}
extension String {
  @available(swift, introduced: 4)
  public subscript(r: Range<Index>) -> Substring {
    var r = _guts.validateScalarRange(r)
    if r.lowerBound._encodedOffset == 0 {
      r = Range(_uncheckedBounds:
        (r.lowerBound._characterAligned, r.upperBound))
    }
    return Substring(_unchecked: Slice(base: self, bounds: r))
  }
}
extension Substring {
  @available(swift, introduced: 4)
  public subscript(r: Range<Index>) -> Substring {
    let r = _wholeGuts.validateScalarRange(r, in: _bounds)
    return Substring(_unchecked: Slice(base: base, bounds: r))
  }
}
