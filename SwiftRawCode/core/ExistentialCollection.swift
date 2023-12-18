import SwiftShims
@inline(never)
@usableFromInline
internal func _abstract(
  file: StaticString = #file,
  line: UInt = #line
) -> Never {
  fatalError("Method must be overridden", file: file, line: line)
}
@frozen
public struct AnyIterator<Element> {
  @usableFromInline
  internal let _box: _AnyIteratorBoxBase<Element>
  @inlinable
  public init<I: IteratorProtocol>(_ base: I) where I.Element == Element {
    self._box = _IteratorBox(base)
  }
  @inlinable
  public init(_ body: @escaping () -> Element?) {
    self._box = _IteratorBox(_ClosureBasedIterator(body))
  }
  @inlinable
  internal init(_box: _AnyIteratorBoxBase<Element>) {
    self._box = _box
  }
}
extension AnyIterator: IteratorProtocol {
  @inlinable
  public func next() -> Element? {
    return _box.next()
  }
}
extension AnyIterator: Sequence { }
@usableFromInline
@frozen
internal struct _ClosureBasedIterator<Element>: IteratorProtocol {
  @usableFromInline
  internal let _body: () -> Element?
  @inlinable
  internal init(_ body: @escaping () -> Element?) {
    self._body = body
  }
  @inlinable
  internal func next() -> Element? { return _body() }
}
@usableFromInline
internal class _AnyIteratorBoxBase<Element>: IteratorProtocol {
  @inlinable 
  internal init() {}
  @inlinable 
  deinit {}
  @inlinable 
  internal func next() -> Element? { _abstract() }
}
@usableFromInline
internal final class _IteratorBox<Base: IteratorProtocol>
  : _AnyIteratorBoxBase<Base.Element> {
  @inlinable
  internal init(_ base: Base) { self._base = base }
  @inlinable 
  deinit {}
  @inlinable
  internal override func next() -> Base.Element? { return _base.next() }
  @usableFromInline
  internal var _base: Base
}
@usableFromInline
internal class _AnySequenceBox<Element> {
  @inlinable 
  internal init() { }
  @inlinable
  internal func _makeIterator() -> AnyIterator<Element> { _abstract() }
  @inlinable
  internal var _underestimatedCount: Int { _abstract() }
  @inlinable
  internal func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    _abstract()
  }
  @inlinable
  internal func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    _abstract()
  }
  @inlinable
  internal func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    _abstract()
  }
  @inlinable
  internal func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    _abstract()
  }
  @inlinable
  internal func __copyToContiguousArray() -> ContiguousArray<Element> {
    _abstract()
  }
  @inlinable
  internal func __copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>, UnsafeMutableBufferPointer<Element>.Index) {
    _abstract()
  }
  @inlinable 
  deinit {}
  @inlinable
  internal func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    _abstract()
  }
  @inlinable
  internal func _dropFirst(_ n: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }
  @inlinable
  internal func _dropLast(_ n: Int) -> [Element] {
    _abstract()
  }
  @inlinable
  internal func _prefix(_ maxLength: Int) -> _AnySequenceBox<Element> {
    _abstract()
  }
  @inlinable
  internal func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> [Element] {
    _abstract()
  }
  @inlinable
  internal func _suffix(_ maxLength: Int) -> [Element] {
    _abstract()
  }
}
@usableFromInline
internal class _AnyCollectionBox<Element>: _AnySequenceBox<Element> {
  @inlinable 
  deinit {}
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal  func _dropLast(_ n: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal  func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal  func _suffix(_ maxLength: Int) -> _AnyCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal subscript(i: _AnyIndexBox) -> Element { _abstract() }
  @inlinable
  internal func _index(after i: _AnyIndexBox) -> _AnyIndexBox { _abstract() }
  @inlinable
  internal func _formIndex(after i: _AnyIndexBox) { _abstract() }
  @inlinable
  internal func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int
  ) -> _AnyIndexBox {
    _abstract()
  }
  @inlinable
  internal func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    _abstract()
  }
  @inlinable
  internal func _formIndex(_ i: inout _AnyIndexBox, offsetBy n: Int) {
    _abstract()
  }
  @inlinable
  internal func _formIndex(
    _ i: inout _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> Bool {
    _abstract()
  }
  @inlinable
  internal func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    _abstract()
  }
  /*
  var _indices: Indices
  __consuming func prefix(upTo end: Index) -> SubSequence
  __consuming func suffix(from start: Index) -> SubSequence
  func prefix(through position: Index) -> SubSequence
  var isEmpty: Bool { get }
  */
  @inlinable 
  internal var _count: Int { _abstract() }
  /*
  func _customIndexOfEquatableElement(element: Element) -> Index??
  func _customLastIndexOfEquatableElement(element: Element) -> Index??
  */
  @inlinable
  internal init(
    _startIndex: _AnyIndexBox,
    endIndex: _AnyIndexBox
  ) {
    self._startIndex = _startIndex
    self._endIndex = endIndex
  }
  @usableFromInline
  internal let _startIndex: _AnyIndexBox
  @usableFromInline
  internal let _endIndex: _AnyIndexBox
  @inlinable
  internal  subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyCollectionBox<Element> { _abstract() }
}
@usableFromInline
internal class _AnyBidirectionalCollectionBox<Element>
  : _AnyCollectionBox<Element>
{
  @inlinable 
  deinit {}
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _dropFirst(
    _ n: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _dropLast(
    _ n: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _suffix(
    _ maxLength: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyBidirectionalCollectionBox<Element> { _abstract() }
  @inlinable
  internal func _index(before i: _AnyIndexBox) -> _AnyIndexBox { _abstract() }
  @inlinable
  internal func _formIndex(before i: _AnyIndexBox) { _abstract() }
}
@usableFromInline
internal class _AnyRandomAccessCollectionBox<Element>
  : _AnyBidirectionalCollectionBox<Element>
{
  @inlinable 
  deinit {}
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _dropFirst(
    _ n: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _dropLast(
    _ n: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override func _suffix(
    _ maxLength: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    _abstract()
  }
  @inlinable
  internal override subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyRandomAccessCollectionBox<Element> { _abstract() }
}
@usableFromInline
internal final class _SequenceBox<S: Sequence>: _AnySequenceBox<S.Element> {
  @usableFromInline
  internal typealias Element = S.Element
  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<DropFirstSequence<S>>(_base: _base.dropFirst(n))
  }
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnySequenceBox<Element> {
    return try _SequenceBox<DropWhileSequence<S>>(_base: _base.drop(while: predicate))
  }
  @inlinable
  internal override func _dropLast(_ n: Int) -> [Element] {
    return _base.dropLast(n)
  }
  @inlinable
  internal override func _prefix(_ n: Int) -> _AnySequenceBox<Element> {
    return _SequenceBox<PrefixSequence<S>>(_base: _base.prefix(n))
  }
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.prefix(while: predicate)
  }
  @inlinable
  internal override func _suffix(_ maxLength: Int) -> [Element] {
    return _base.suffix(maxLength)
  }
  @inlinable 
  deinit {}
  @inlinable
  internal init(_base: S) {
    self._base = _base
  }
  @usableFromInline
  internal var _base: S
}
@usableFromInline
internal final class _CollectionBox<S: Collection>: _AnyCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element
  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inline(__always)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    return try _CollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _dropFirst(_ n: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inline(__always)
  @inlinable
  internal override func _dropLast(_ n: Int) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyCollectionBox<Element> {
    return try _CollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inline(__always)
  @inlinable
  internal override func _suffix(
    _ maxLength: Int
  ) -> _AnyCollectionBox<Element> {
    return _CollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
  @inlinable 
  deinit {}
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex)
    )
  }
  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }
  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }
  @inlinable
  internal override subscript(start start: _AnyIndexBox, end end: _AnyIndexBox)
    -> _AnyCollectionBox<Element>
  {
    return _CollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }
  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }
  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: n))
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(_unbox(i), offsetBy: n, limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n, limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return _base.distance(from: _unbox(start), to: _unbox(end))
  }
  @inlinable
  internal override var _count: Int {
    return _base.count
  }
  @usableFromInline
  internal var _base: S
}
@usableFromInline
internal final class _BidirectionalCollectionBox<S: BidirectionalCollection>
  : _AnyBidirectionalCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element
  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inline(__always)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    return try _BidirectionalCollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _dropFirst(
    _ n: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inline(__always)
  @inlinable
  internal override func _dropLast(
    _ n: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyBidirectionalCollectionBox<Element> {
    return try _BidirectionalCollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inline(__always)
  @inlinable
  internal override func _suffix(
    _ maxLength: Int
  ) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
  @inlinable 
  deinit {}
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex)
    )
  }
  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }
  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }
  @inlinable
  internal override subscript(
    start start: _AnyIndexBox,
    end end: _AnyIndexBox
  ) -> _AnyBidirectionalCollectionBox<Element> {
    return _BidirectionalCollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }
  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }
  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: n))
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(_unbox(i), offsetBy: n, limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n, limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return _base.distance(from: _unbox(start), to: _unbox(end))
  }
  @inlinable
  internal override var _count: Int {
    return _base.count
  }
  @inlinable
  internal override func _index(before position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(before: _unbox(position)))
  }
  @inlinable
  internal override func _formIndex(before position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(before: &p._base)
    }
    fatalError("Index type mismatch!")
  }
  @usableFromInline
  internal var _base: S
}
@usableFromInline
internal final class _RandomAccessCollectionBox<S: RandomAccessCollection>
  : _AnyRandomAccessCollectionBox<S.Element>
{
  @usableFromInline
  internal typealias Element = S.Element
  @inline(__always)
  @inlinable
  internal override func _makeIterator() -> AnyIterator<Element> {
    return AnyIterator(_base.makeIterator())
  }
  @inlinable
  internal override var _underestimatedCount: Int {
    return _base.underestimatedCount
  }
  @inlinable
  internal override func _map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _base.map(transform)
  }
  @inlinable
  internal override func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _base.filter(isIncluded)
  }
  @inlinable
  internal override func _forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _base.forEach(body)
  }
  @inlinable
  internal override func __customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _base._customContainsEquatableElement(element)
  }
  @inlinable
  internal override func __copyToContiguousArray() -> ContiguousArray<Element> {
    return _base._copyToContiguousArray()
  }
  @inlinable
  internal override func __copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _base._copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
  @inline(__always)
  @inlinable
  internal override func _drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    return try _RandomAccessCollectionBox<S.SubSequence>(_base: _base.drop(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _dropFirst(
    _ n: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.dropFirst(n))
  }
  @inline(__always)
  @inlinable
  internal override func _dropLast(
    _ n: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.dropLast(n))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> _AnyRandomAccessCollectionBox<Element> {
    return try _RandomAccessCollectionBox<S.SubSequence>(_base: _base.prefix(while: predicate))
  }
  @inline(__always)
  @inlinable
  internal override func _prefix(
    _ maxLength: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.prefix(maxLength))
  }
  @inline(__always)
  @inlinable
  internal override func _suffix(
    _ maxLength: Int
  ) -> _AnyRandomAccessCollectionBox<Element> {
    return _RandomAccessCollectionBox<S.SubSequence>(_base: _base.suffix(maxLength))
  }
  @inlinable 
  deinit {}
  @inlinable
  internal init(_base: S) {
    self._base = _base
    super.init(
      _startIndex: _IndexBox(_base: _base.startIndex),
      endIndex: _IndexBox(_base: _base.endIndex)
    )
  }
  @inlinable
  internal func _unbox(
    _ position: _AnyIndexBox, file: StaticString = #file, line: UInt = #line
  ) -> S.Index {
    if let i = position._unbox() as S.Index? {
      return i
    }
    fatalError("Index type mismatch!", file: file, line: line)
  }
  @inlinable
  internal override subscript(position: _AnyIndexBox) -> Element {
    return _base[_unbox(position)]
  }
  @inlinable
  internal override subscript(start start: _AnyIndexBox, end end: _AnyIndexBox)
    -> _AnyRandomAccessCollectionBox<Element>
  {
    return _RandomAccessCollectionBox<S.SubSequence>(_base:
      _base[_unbox(start)..<_unbox(end)]
    )
  }
  @inlinable
  internal override func _index(after position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(after: _unbox(position)))
  }
  @inlinable
  internal override func _formIndex(after position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(after: &p._base)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox, offsetBy n: Int
  ) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(_unbox(i), offsetBy: n))
  }
  @inlinable
  internal override func _index(
    _ i: _AnyIndexBox,
    offsetBy n: Int,
    limitedBy limit: _AnyIndexBox
  ) -> _AnyIndexBox? {
    return _base.index(_unbox(i), offsetBy: n, limitedBy: _unbox(limit))
      .map { _IndexBox(_base: $0) }
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int
  ) {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n)
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _formIndex(
    _ i: inout _AnyIndexBox, offsetBy n: Int, limitedBy limit: _AnyIndexBox
  ) -> Bool {
    if let box = i as? _IndexBox<S.Index> {
      return _base.formIndex(&box._base, offsetBy: n, limitedBy: _unbox(limit))
    }
    fatalError("Index type mismatch!")
  }
  @inlinable
  internal override func _distance(
    from start: _AnyIndexBox,
    to end: _AnyIndexBox
  ) -> Int {
    return _base.distance(from: _unbox(start), to: _unbox(end))
  }
  @inlinable
  internal override var _count: Int {
    return _base.count
  }
  @inlinable
  internal override func _index(before position: _AnyIndexBox) -> _AnyIndexBox {
    return _IndexBox(_base: _base.index(before: _unbox(position)))
  }
  @inlinable
  internal override func _formIndex(before position: _AnyIndexBox) {
    if let p = position as? _IndexBox<S.Index> {
      return _base.formIndex(before: &p._base)
    }
    fatalError("Index type mismatch!")
  }
  @usableFromInline
  internal var _base: S
}
@usableFromInline
@frozen
internal struct _ClosureBasedSequence<Iterator: IteratorProtocol> {
  @usableFromInline
  internal var _makeUnderlyingIterator: () -> Iterator
  @inlinable
  internal init(_ makeUnderlyingIterator: @escaping () -> Iterator) {
    self._makeUnderlyingIterator = makeUnderlyingIterator
  }
}
extension _ClosureBasedSequence: Sequence {
  @inlinable
  internal func makeIterator() -> Iterator {
    return _makeUnderlyingIterator()
  }
}
@frozen
public struct AnySequence<Element> {
  @usableFromInline
  internal let _box: _AnySequenceBox<Element>
  @inlinable
  public init<I: IteratorProtocol>(
    _ makeUnderlyingIterator: @escaping () -> I
  ) where I.Element == Element {
    self.init(_ClosureBasedSequence(makeUnderlyingIterator))
  }
  @inlinable
  internal init(_box: _AnySequenceBox<Element>) {
    self._box = _box
  }
}
extension  AnySequence: Sequence {
  public typealias Iterator = AnyIterator<Element>
  @inlinable
  public init<S: Sequence>(_ base: S)
    where
    S.Element == Element {
    self._box = _SequenceBox(_base: base)
  }
}
extension AnySequence {
  @inline(__always)
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return _box._makeIterator()
  }
  @inlinable
  public __consuming func dropLast(_ n: Int = 1) -> [Element] {
    return _box._dropLast(n)
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._prefix(while: predicate)
  }
  @inlinable
  public __consuming func suffix(_ maxLength: Int) -> [Element] {
    return _box._suffix(maxLength)
  }
  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }
  @inlinable
  public __consuming func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnySequence<Element> {
    return try AnySequence(_box: _box._drop(while: predicate))
  }
  @inlinable
  public __consuming func dropFirst(_ n: Int = 1) -> AnySequence<Element> {
    return AnySequence(_box: _box._dropFirst(n))
  }
  @inlinable
  public __consuming func prefix(_ maxLength: Int = 1) -> AnySequence<Element> {
    return AnySequence(_box: _box._prefix(maxLength))
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }
  @inlinable
  public __consuming func _copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
extension AnyCollection {
  @inline(__always)
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return _box._makeIterator()
  }
  @inlinable
  public __consuming func dropLast(_ n: Int = 1) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._dropLast(n))
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyCollection<Element> {
    return try AnyCollection(_box: _box._prefix(while: predicate))
  }
  @inlinable
  public __consuming func suffix(_ maxLength: Int) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._suffix(maxLength))
  }
  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }
  @inlinable
  public __consuming func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyCollection<Element> {
    return try AnyCollection(_box: _box._drop(while: predicate))
  }
  @inlinable
  public __consuming func dropFirst(_ n: Int = 1) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._dropFirst(n))
  }
  @inlinable
  public __consuming func prefix(
    _ maxLength: Int = 1
  ) -> AnyCollection<Element> {
    return AnyCollection(_box: _box._prefix(maxLength))
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }
  @inlinable
  public __consuming func _copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
extension AnyBidirectionalCollection {
  @inline(__always)
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return _box._makeIterator()
  }
  @inlinable
  public __consuming func dropLast(
    _ n: Int = 1
  ) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._dropLast(n))
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyBidirectionalCollection<Element> {
    return try AnyBidirectionalCollection(_box: _box._prefix(while: predicate))
  }
  @inlinable
  public __consuming func suffix(
    _ maxLength: Int
  ) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._suffix(maxLength))
  }
  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }
  @inlinable
  public __consuming func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyBidirectionalCollection<Element> {
    return try AnyBidirectionalCollection(_box: _box._drop(while: predicate))
  }
  @inlinable
  public __consuming func dropFirst(
    _ n: Int = 1
  ) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._dropFirst(n))
  }
  @inlinable
  public __consuming func prefix(
    _ maxLength: Int = 1
  ) -> AnyBidirectionalCollection<Element> {
    return AnyBidirectionalCollection(_box: _box._prefix(maxLength))
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }
  @inlinable
  public __consuming func _copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
extension AnyRandomAccessCollection {
  @inline(__always)
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return _box._makeIterator()
  }
  @inlinable
  public __consuming func dropLast(
    _ n: Int = 1
  ) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._dropLast(n))
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyRandomAccessCollection<Element> {
    return try AnyRandomAccessCollection(_box: _box._prefix(while: predicate))
  }
  @inlinable
  public __consuming func suffix(
    _ maxLength: Int
  ) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._suffix(maxLength))
  }
  @inlinable
  public var underestimatedCount: Int {
    return _box._underestimatedCount
  }
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    return try _box._map(transform)
  }
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _box._filter(isIncluded)
  }
  @inlinable
  public __consuming func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    return try _box._forEach(body)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> AnyRandomAccessCollection<Element> {
    return try AnyRandomAccessCollection(_box: _box._drop(while: predicate))
  }
  @inlinable
  public __consuming func dropFirst(
    _ n: Int = 1
  ) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._dropFirst(n))
  }
  @inlinable
  public __consuming func prefix(
    _ maxLength: Int = 1
  ) -> AnyRandomAccessCollection<Element> {
    return AnyRandomAccessCollection(_box: _box._prefix(maxLength))
  }
  @inlinable
  public func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool? {
    return _box.__customContainsEquatableElement(element)
  }
  @inlinable
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    return self._box.__copyToContiguousArray()
  }
  @inlinable
  public __consuming func _copyContents(
    initializing buf: UnsafeMutableBufferPointer<Element>
  ) -> (AnyIterator<Element>,UnsafeMutableBufferPointer<Element>.Index) {
    let (it,idx) = _box.__copyContents(initializing: buf)
    return (AnyIterator(it),idx)
  }
}
@usableFromInline
internal protocol _AnyIndexBox: AnyObject {
  var _typeID: ObjectIdentifier { get }
  func _unbox<T: Comparable>() -> T?
  func _isEqual(to rhs: _AnyIndexBox) -> Bool
  func _isLess(than rhs: _AnyIndexBox) -> Bool
}
@usableFromInline
internal final class _IndexBox<BaseIndex: Comparable>: _AnyIndexBox {
  @usableFromInline
  internal var _base: BaseIndex
  @inlinable
  internal init(_base: BaseIndex) {
    self._base = _base
  }
  @inlinable
  internal func _unsafeUnbox(_ other: _AnyIndexBox) -> BaseIndex {
    return unsafeDowncast(other, to: _IndexBox.self)._base
  }
  @inlinable
  internal var _typeID: ObjectIdentifier {
    return ObjectIdentifier(type(of: self))
  }
  @inlinable
  internal func _unbox<T: Comparable>() -> T? {
    return (self as _AnyIndexBox as? _IndexBox<T>)?._base
  }
  @inlinable
  internal func _isEqual(to rhs: _AnyIndexBox) -> Bool {
    return _base == _unsafeUnbox(rhs)
  }
  @inlinable
  internal func _isLess(than rhs: _AnyIndexBox) -> Bool {
    return _base < _unsafeUnbox(rhs)
  }
}
@frozen
public struct AnyIndex {
  @usableFromInline
  internal var _box: _AnyIndexBox
  @inlinable
  public init<BaseIndex: Comparable>(_ base: BaseIndex) {
    self._box = _IndexBox(_base: base)
  }
  @inlinable
  internal init(_box: _AnyIndexBox) {
    self._box = _box
  }
  @inlinable
  internal var _typeID: ObjectIdentifier {
    return _box._typeID
  }
}
extension AnyIndex: Comparable {
  @inlinable
  public static func == (lhs: AnyIndex, rhs: AnyIndex) -> Bool {
    _precondition(lhs._typeID == rhs._typeID, "Base index types differ")
    return lhs._box._isEqual(to: rhs._box)
  }
  @inlinable
  public static func < (lhs: AnyIndex, rhs: AnyIndex) -> Bool {
    _precondition(lhs._typeID == rhs._typeID, "Base index types differ")
    return lhs._box._isLess(than: rhs._box)
  }
}
public 
protocol _AnyCollectionProtocol: Collection {
  var _boxID: ObjectIdentifier { get }
}
@frozen
public struct AnyCollection<Element> {
  @usableFromInline
  internal let _box: _AnyCollectionBox<Element>
  @inlinable
  internal init(_box: _AnyCollectionBox<Element>) {
    self._box = _box
  }
}
extension AnyCollection: Collection {
  public typealias Indices = DefaultIndices<AnyCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyCollection<Element> 
  @inline(__always)
  @inlinable
  public init<C: Collection>(_ base: C) where C.Element == Element {
    self._box = _CollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyCollection<Element>) {
    self._box = other._box
  }
  @inline(__always)
  @inlinable
  public init<C: BidirectionalCollection>(_ base: C) where C.Element == Element {
    self._box = _BidirectionalCollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyBidirectionalCollection<Element>) {
    self._box = other._box
  }
  @inline(__always)
  @inlinable
  public init<C: RandomAccessCollection>(_ base: C) where C.Element == Element {
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }
  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
  }
  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }
  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }
  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }
  @inlinable
  public var count: Int {
    return _box._count
  }
}
extension AnyCollection: _AnyCollectionProtocol {
  @inlinable
  public 
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
@frozen
public struct AnyBidirectionalCollection<Element> {
  @usableFromInline
  internal let _box: _AnyBidirectionalCollectionBox<Element>
  @inlinable
  internal init(_box: _AnyBidirectionalCollectionBox<Element>) {
    self._box = _box
  }
}
extension AnyBidirectionalCollection: BidirectionalCollection {
  public typealias Indices = DefaultIndices<AnyBidirectionalCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyBidirectionalCollection<Element> 
  @inline(__always)
  @inlinable
  public init<C: BidirectionalCollection>(_ base: C) where C.Element == Element {
    self._box = _BidirectionalCollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyBidirectionalCollection<Element>) {
    self._box = other._box
  }
  @inline(__always)
  @inlinable
  public init<C: RandomAccessCollection>(_ base: C) where C.Element == Element {
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
  @inlinable
  public init?(_ other: AnyCollection<Element>) {
    guard let box =
      other._box as? _AnyBidirectionalCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }
  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyBidirectionalCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
  }
  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }
  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }
  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }
  @inlinable
  public var count: Int {
    return _box._count
  }
  @inlinable
  public func index(before i: Index) -> Index {
    return AnyIndex(_box: _box._index(before: i._box))
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(before: i._box)
    }
    else {
      i = index(before: i)
    }
  }
}
extension AnyBidirectionalCollection: _AnyCollectionProtocol {
  @inlinable
  public 
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
@frozen
public struct AnyRandomAccessCollection<Element> {
  @usableFromInline
  internal let _box: _AnyRandomAccessCollectionBox<Element>
  @inlinable
  internal init(_box: _AnyRandomAccessCollectionBox<Element>) {
    self._box = _box
  }
}
extension AnyRandomAccessCollection: RandomAccessCollection {
  public typealias Indices = DefaultIndices<AnyRandomAccessCollection>
  public typealias Iterator = AnyIterator<Element>
  public typealias Index = AnyIndex
  public typealias SubSequence = AnyRandomAccessCollection<Element> 
  @inline(__always)
  @inlinable
  public init<C: RandomAccessCollection>(_ base: C) where C.Element == Element {
    self._box = _RandomAccessCollectionBox<C>(
      _base: base)
  }
  @inlinable
  public init(_ other: AnyRandomAccessCollection<Element>) {
    self._box = other._box
  }
  @inlinable
  public init?(_ other: AnyCollection<Element>) {
    guard let box =
      other._box as? _AnyRandomAccessCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
  @inlinable
  public init?(_ other: AnyBidirectionalCollection<Element>) {
    guard let box =
      other._box as? _AnyRandomAccessCollectionBox<Element> else {
      return nil
    }
    self._box = box
  }
  @inlinable
  public var startIndex: Index {
    return AnyIndex(_box: _box._startIndex)
  }
  @inlinable
  public var endIndex: Index {
    return AnyIndex(_box: _box._endIndex)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    return _box[position._box]
  }
  @inlinable
  public subscript(bounds: Range<Index>) -> SubSequence {
    return AnyRandomAccessCollection(_box:
      _box[start: bounds.lowerBound._box, end: bounds.upperBound._box])
  }
  @inlinable
  public func _failEarlyRangeCheck(_ index: Index, bounds: Range<Index>) {
  }
  @inlinable
  public func _failEarlyRangeCheck(_ range: Range<Index>, bounds: Range<Index>) {
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return AnyIndex(_box: _box._index(after: i._box))
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(after: i._box)
    }
    else {
      i = index(after: i)
    }
  }
  @inlinable
  public func index(_ i: Index, offsetBy n: Int) -> Index {
    return AnyIndex(_box: _box._index(i._box, offsetBy: n))
  }
  @inlinable
  public func index(
    _ i: Index, offsetBy n: Int, limitedBy limit: Index
  ) -> Index? {
    return _box._index(i._box, offsetBy: n, limitedBy: limit._box)
      .map { AnyIndex(_box:$0) }
  }
  @inlinable
  public func formIndex(_ i: inout Index, offsetBy n: Int) {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n)
    } else {
      i = index(i, offsetBy: n)
    }
  }
  @inlinable
  public func formIndex(
    _ i: inout Index,
    offsetBy n: Int,
    limitedBy limit: Index
  ) -> Bool {
    if _isUnique(&i._box) {
      return _box._formIndex(&i._box, offsetBy: n, limitedBy: limit._box)
    }
    if let advanced = index(i, offsetBy: n, limitedBy: limit) {
      i = advanced
      return true
    }
    i = limit
    return false
  }
  @inlinable
  public func distance(from start: Index, to end: Index) -> Int {
    return _box._distance(from: start._box, to: end._box)
  }
  @inlinable
  public var count: Int {
    return _box._count
  }
  @inlinable
  public func index(before i: Index) -> Index {
    return AnyIndex(_box: _box._index(before: i._box))
  }
  @inlinable
  public func formIndex(before i: inout Index) {
    if _isUnique(&i._box) {
      _box._formIndex(before: i._box)
    }
    else {
      i = index(before: i)
    }
  }
}
extension AnyRandomAccessCollection: _AnyCollectionProtocol {
  @inlinable
  public 
  var _boxID: ObjectIdentifier {
    return ObjectIdentifier(_box)
  }
}
