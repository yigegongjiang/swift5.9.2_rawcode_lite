@frozen
public struct Set<Element: Hashable> {
  @usableFromInline
  internal var _variant: _Variant
  public 
  init(minimumCapacity: Int) {
    _variant = _Variant(native: _NativeSet(capacity: minimumCapacity))
  }
  @inlinable
  internal init(_native: __owned _NativeSet<Element>) {
    _variant = _Variant(native: _native)
  }
#if _runtime(_ObjC)
  @inlinable
  internal init(_cocoa: __owned __CocoaSet) {
    _variant = _Variant(cocoa: _cocoa)
  }
  @inlinable
  public 
  init(_immutableCocoaSet: __owned AnyObject) {
    _internalInvariant(_isBridgedVerbatimToObjectiveC(Element.self),
      "Set can be backed by NSSet _variant only when the member type can be bridged verbatim to Objective-C")
    self.init(_cocoa: __CocoaSet(_immutableCocoaSet))
  }
#endif
}
extension Set: ExpressibleByArrayLiteral {
  @inlinable
  @inline(__always)
  public init(arrayLiteral elements: Element...) {
    if elements.isEmpty {
      self.init()
      return
    }
    self.init(_nonEmptyArrayLiteral: elements)
  }
  internal init(_nonEmptyArrayLiteral elements: [Element]) {
    let native = _NativeSet<Element>(capacity: elements.count)
    for element in elements {
      let (bucket, found) = native.find(element)
      if found {
        continue
      }
      native._unsafeInsertNew(element, at: bucket)
    }
    self.init(_native: native)
  }
}
extension Set: Sequence {
  @inlinable
  @inline(__always)
  public __consuming func makeIterator() -> Iterator {
    return _variant.makeIterator()
  }
  @inlinable
  public func contains(_ member: Element) -> Bool {
    return _variant.contains(member)
  }
  @inlinable
  @inline(__always)
  public func _customContainsEquatableElement(_ member: Element) -> Bool? {
    return contains(member)
  }
}
extension Set {
  @inlinable
  @available(swift, introduced: 4.0)
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> Set {
    return try Set(_native: _variant.filter(isIncluded))
  }
}
extension Set: Collection {
  @inlinable
  public var startIndex: Index {
    return _variant.startIndex
  }
  @inlinable
  public var endIndex: Index {
    return _variant.endIndex
  }
  @inlinable
  public subscript(position: Index) -> Element {
    get {
      return _variant.element(at: position)
    }
  }
  @inlinable
  public func index(after i: Index) -> Index {
    return _variant.index(after: i)
  }
  @inlinable
  public func formIndex(after i: inout Index) {
    _variant.formIndex(after: &i)
  }
  @inlinable
  public func firstIndex(of member: Element) -> Index? {
    return _variant.index(for: member)
  }
  @inlinable
  @inline(__always)
  public func _customIndexOfEquatableElement(
     _ member: Element
    ) -> Index?? {
    return Optional(firstIndex(of: member))
  }
  @inlinable
  @inline(__always)
  public func _customLastIndexOfEquatableElement(
     _ member: Element
    ) -> Index?? {
    return _customIndexOfEquatableElement(member)
  }
  @inlinable
  public var count: Int {
    return _variant.count
  }
  @inlinable
  public var isEmpty: Bool {
    return count == 0
  }
}
extension Set: Equatable {
  @inlinable
  public static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool {
#if _runtime(_ObjC)
    switch (lhs._variant.isNative, rhs._variant.isNative) {
    case (true, true):
      return lhs._variant.asNative.isEqual(to: rhs._variant.asNative)
    case (false, false):
      return lhs._variant.asCocoa.isEqual(to: rhs._variant.asCocoa)
    case (true, false):
      return lhs._variant.asNative.isEqual(to: rhs._variant.asCocoa)
    case (false, true):
      return rhs._variant.asNative.isEqual(to: lhs._variant.asCocoa)
    }
#else
    return lhs._variant.asNative.isEqual(to: rhs._variant.asNative)
#endif
  }
}
extension Set: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var copy = hasher
    let seed = copy._finalize()
    var hash = 0
    for member in self {
      hash ^= member._rawHashValue(seed: seed)
    }
    hasher.combine(hash)
  }
}
extension Set: _HasCustomAnyHashableRepresentation {
  public __consuming func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _SetAnyHashableBox(self))
  }
}
internal struct _SetAnyHashableBox<Element: Hashable>: _AnyHashableBox {
  internal let _value: Set<Element>
  internal let _canonical: Set<AnyHashable>
  internal init(_ value: __owned Set<Element>) {
    self._value = value
    self._canonical = value as Set<AnyHashable>
  }
  internal var _base: Any {
    return _value
  }
  internal var _canonicalBox: _AnyHashableBox {
    return _SetAnyHashableBox<AnyHashable>(_canonical)
  }
  internal func _isEqual(to other: _AnyHashableBox) -> Bool? {
    guard let other = other as? _SetAnyHashableBox<AnyHashable> else {
      return nil
    }
    return _canonical == other._value
  }
  internal var _hashValue: Int {
    return _canonical.hashValue
  }
  internal func _hash(into hasher: inout Hasher) {
    _canonical.hash(into: &hasher)
  }
  internal func _rawHashValue(_seed: Int) -> Int {
    return _canonical._rawHashValue(seed: _seed)
  }
  internal func _unbox<T: Hashable>() -> T? {
    return _value as? T
  }
  internal func _downCastConditional<T>(
    into result: UnsafeMutablePointer<T>
  ) -> Bool {
    guard let value = _value as? T else { return false }
    result.initialize(to: value)
    return true
  }
}
extension Set: SetAlgebra {
  @inlinable
  @discardableResult
  public mutating func insert(
    _ newMember: __owned Element
  ) -> (inserted: Bool, memberAfterInsert: Element) {
    return _variant.insert(newMember)
  }
  @inlinable
  @discardableResult
  public mutating func update(with newMember: __owned Element) -> Element? {
    return _variant.update(with: newMember)
  }
  @inlinable
  @discardableResult
  public mutating func remove(_ member: Element) -> Element? {
    return _variant.remove(member)
  }
  @inlinable
  @discardableResult
  public mutating func remove(at position: Index) -> Element {
    return _variant.remove(at: position)
  }
  @inlinable
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    _variant.removeAll(keepingCapacity: keepCapacity)
  }
  @inlinable
  @discardableResult
  public mutating func removeFirst() -> Element {
    _precondition(!isEmpty, "Can't removeFirst from an empty Set")
    return remove(at: startIndex)
  }
  @inlinable
  public init() {
    self = Set<Element>(_native: _NativeSet())
  }
  @inlinable
  public init<Source: Sequence>(_ sequence: __owned Source)
  where Source.Element == Element {
    if let s = sequence as? Set<Element> {
      self = s
    } else {
      self.init(minimumCapacity: sequence.underestimatedCount)
      for item in sequence {
        insert(item)
      }
    }
  }
  @inlinable
  public func isSubset<S: Sequence>(of possibleSuperset: S) -> Bool
  where S.Element == Element {
    guard !isEmpty else { return true }
    if self.count == 1 { return possibleSuperset.contains(self.first!) }
    if let s = possibleSuperset as? Set<Element> {
      return isSubset(of: s)
    }
    return _variant.convertedToNative.isSubset(of: possibleSuperset)
  }
  @inlinable
  public func isStrictSubset<S: Sequence>(of possibleStrictSuperset: S) -> Bool
  where S.Element == Element {
    if let s = possibleStrictSuperset as? Set<Element> {
      return isStrictSubset(of: s)
    }
    return _variant.convertedToNative.isStrictSubset(of: possibleStrictSuperset)
  }
  @inlinable
  public func isSuperset<S: Sequence>(of possibleSubset: __owned S) -> Bool
  where S.Element == Element {
    if let s = possibleSubset as? Set<Element> {
      return isSuperset(of: s)
    }
    for member in possibleSubset {
      if !contains(member) {
        return false
      }
    }
    return true
  }
  @inlinable
  public func isStrictSuperset<S: Sequence>(of possibleStrictSubset: S) -> Bool
  where S.Element == Element {
    if isEmpty { return false }
    if let s = possibleStrictSubset as? Set<Element> {
      return isStrictSuperset(of: s)
    }
    return _variant.convertedToNative.isStrictSuperset(of: possibleStrictSubset)
  }
  @inlinable
  public func isDisjoint<S: Sequence>(with other: S) -> Bool
  where S.Element == Element {
    if let s = other as? Set<Element> {
      return isDisjoint(with: s)
    }
    return _isDisjoint(with: other)
  }
  @inlinable
  public __consuming func union<S: Sequence>(_ other: __owned S) -> Set<Element>
  where S.Element == Element {
    var newSet = self
    newSet.formUnion(other)
    return newSet
  }
  @inlinable
  public mutating func formUnion<S: Sequence>(_ other: __owned S)
  where S.Element == Element {
    for item in other {
      insert(item)
    }
  }
  @inlinable
  public __consuming func subtracting<S: Sequence>(_ other: S) -> Set<Element>
  where S.Element == Element {
    return self._subtracting(other)
  }
  @inlinable
  internal __consuming func _subtracting<S: Sequence>(
    _ other: S
  ) -> Set<Element>
  where S.Element == Element {
    return Set(_native: _variant.convertedToNative.subtracting(other))
  }
  @inlinable
  public mutating func subtract<S: Sequence>(_ other: S)
  where S.Element == Element {
    _subtract(other)
  }
  @inlinable
  internal mutating func _subtract<S: Sequence>(_ other: S)
  where S.Element == Element {
    guard !isEmpty else { return }
    for item in other {
      remove(item)
    }
  }
  @inlinable
  public __consuming func intersection<S: Sequence>(_ other: S) -> Set<Element>
  where S.Element == Element {
    if let other = other as? Set<Element> {
      return self.intersection(other)
    }
    return Set(_native: _variant.convertedToNative.genericIntersection(other))
  }
  @inlinable
  public mutating func formIntersection<S: Sequence>(_ other: S)
  where S.Element == Element {
    self = self.intersection(other)
  }
  @inlinable
  public __consuming func symmetricDifference<S: Sequence>(
    _ other: __owned S
  ) -> Set<Element>
  where S.Element == Element {
    var newSet = self
    newSet.formSymmetricDifference(other)
    return newSet
  }
  @inlinable
  public mutating func formSymmetricDifference<S: Sequence>(
    _ other: __owned S)
  where S.Element == Element {
    let otherSet = Set(other)
    formSymmetricDifference(otherSet)
  }
}
extension Set: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return _makeCollectionDescription()
  }
  public var debugDescription: String {
    return _makeCollectionDescription(withTypeName: "Set")
  }
}
extension Set {
  @inlinable
  public mutating func subtract(_ other: Set<Element>) {
    _subtract(other)
  }
  @inlinable
  public func isSubset(of other: Set<Element>) -> Bool {
    guard self.count <= other.count else { return false }
    for member in self {
      guard other.contains(member) else {
        return false
      }
    }
    return true
  }
  @inlinable
  public func isSuperset(of other: Set<Element>) -> Bool {
    return other.isSubset(of: self)
  }
  @inlinable
  public func isDisjoint(with other: Set<Element>) -> Bool {
    guard !isEmpty && !other.isEmpty else { return true }
    let (smaller, larger) =
      count < other.count ? (self, other) : (other, self)
    for member in smaller {
      if larger.contains(member) {
        return false
      }
    }
    return true
  }
  @inlinable
  internal func _isDisjoint<S: Sequence>(with other: S) -> Bool
  where S.Element == Element {
    guard !isEmpty else { return true }
    for member in other {
      if contains(member) {
        return false
      }
    }
    return true
  }
  @inlinable
  public __consuming func subtracting(_ other: Set<Element>) -> Set<Element> {
    if other.count <= self.count / 8 {
      var copy = self
      copy._subtract(other)
      return copy
    }
    return self._subtracting(other)
  }
  @inlinable
  public func isStrictSuperset(of other: Set<Element>) -> Bool {
    return self.count > other.count && other.isSubset(of: self)
  }
  @inlinable
  public func isStrictSubset(of other: Set<Element>) -> Bool {
    return self.count < other.count && self.isSubset(of: other)
  }
  @inlinable
  public __consuming func intersection(_ other: Set<Element>) -> Set<Element> {
    Set(_native: _variant.intersection(other))
  }
  @inlinable
  public mutating func formSymmetricDifference(_ other: __owned Set<Element>) {
    for member in other {
      if contains(member) {
        remove(member)
      } else {
        insert(member)
      }
    }
  }
}
extension Set {
  @frozen
  public struct Index {
    @frozen
    @usableFromInline
    internal enum _Variant {
      case native(_HashTable.Index)
#if _runtime(_ObjC)
      case cocoa(__CocoaSet.Index)
#endif
    }
    @usableFromInline
    internal var _variant: _Variant
    @inlinable
    @inline(__always)
    internal init(_variant: __owned _Variant) {
      self._variant = _variant
    }
    @inlinable
    @inline(__always)
    internal init(_native index: _HashTable.Index) {
      self.init(_variant: .native(index))
    }
#if _runtime(_ObjC)
    @inlinable
    @inline(__always)
    internal init(_cocoa index: __owned __CocoaSet.Index) {
      self.init(_variant: .cocoa(index))
    }
#endif
  }
}
extension Set.Index {
#if _runtime(_ObjC)
  internal var _guaranteedNative: Bool {
    return _canBeClass(Element.self) == 0
  }
  @usableFromInline
  internal func _cocoaPath() {
    if _guaranteedNative {
      _conditionallyUnreachable()
    }
  }
  @inlinable
  @inline(__always)
  internal mutating func _isUniquelyReferenced() -> Bool {
    defer { _fixLifetime(self) }
    var handle = _asCocoa.handleBitPattern
    return handle == 0 || _isUnique_native(&handle)
  }
#endif
#if _runtime(_ObjC)
  internal var _isNative: Bool {
    switch _variant {
    case .native:
      return true
    case .cocoa:
      _cocoaPath()
      return false
    }
  }
#endif
  internal var _asNative: _HashTable.Index {
    switch _variant {
    case .native(let nativeIndex):
      return nativeIndex
#if _runtime(_ObjC)
    case .cocoa:
      _preconditionFailure(
        "Attempting to access Set elements using an invalid index")
#endif
    }
  }
#if _runtime(_ObjC)
  @usableFromInline
  internal var _asCocoa: __CocoaSet.Index {
    get {
      switch _variant {
      case .native:
        _preconditionFailure(
          "Attempting to access Set elements using an invalid index")
      case .cocoa(let cocoaIndex):
        return cocoaIndex
      }
    }
    _modify {
      guard case .cocoa(var cocoa) = _variant else {
        _preconditionFailure(
          "Attempting to access Set elements using an invalid index")
      }
      let dummy = _HashTable.Index(bucket: _HashTable.Bucket(offset: 0), age: 0)
      _variant = .native(dummy)
      defer { _variant = .cocoa(cocoa) }
      yield &cocoa
    }
  }
#endif
}
extension Set.Index: Equatable {
  @inlinable
  public static func == (
    lhs: Set<Element>.Index,
    rhs: Set<Element>.Index
  ) -> Bool {
    switch (lhs._variant, rhs._variant) {
    case (.native(let lhsNative), .native(let rhsNative)):
      return lhsNative == rhsNative
  #if _runtime(_ObjC)
    case (.cocoa(let lhsCocoa), .cocoa(let rhsCocoa)):
      lhs._cocoaPath()
      return lhsCocoa == rhsCocoa
    default:
      _preconditionFailure("Comparing indexes from different sets")
  #endif
    }
  }
}
extension Set.Index: Comparable {
  @inlinable
  public static func < (
    lhs: Set<Element>.Index,
    rhs: Set<Element>.Index
  ) -> Bool {
    switch (lhs._variant, rhs._variant) {
    case (.native(let lhsNative), .native(let rhsNative)):
      return lhsNative < rhsNative
  #if _runtime(_ObjC)
    case (.cocoa(let lhsCocoa), .cocoa(let rhsCocoa)):
      lhs._cocoaPath()
      return lhsCocoa < rhsCocoa
    default:
      _preconditionFailure("Comparing indexes from different sets")
  #endif
    }
  }
}
extension Set.Index: Hashable {
  public 
  func hash(into hasher: inout Hasher) {
#if _runtime(_ObjC)
    guard _isNative else {
      hasher.combine(1 as UInt8)
      hasher.combine(_asCocoa._offset)
      return
    }
    hasher.combine(0 as UInt8)
    hasher.combine(_asNative.bucket.offset)
#else
    hasher.combine(_asNative.bucket.offset)
#endif
  }
}
extension Set {
  @frozen
  public struct Iterator {
    @usableFromInline
    @frozen
    internal enum _Variant {
      case native(_NativeSet<Element>.Iterator)
#if _runtime(_ObjC)
      case cocoa(__CocoaSet.Iterator)
#endif
    }
    @usableFromInline
    internal var _variant: _Variant
    @inlinable
    internal init(_variant: __owned _Variant) {
      self._variant = _variant
    }
    @inlinable
    internal init(_native: __owned _NativeSet<Element>.Iterator) {
      self.init(_variant: .native(_native))
    }
#if _runtime(_ObjC)
    @usableFromInline
    internal init(_cocoa: __owned __CocoaSet.Iterator) {
      self.init(_variant: .cocoa(_cocoa))
    }
#endif
  }
}
extension Set.Iterator {
#if _runtime(_ObjC)
  internal var _guaranteedNative: Bool {
    return _canBeClass(Element.self) == 0
  }
  internal func _cocoaPath() {
    if _guaranteedNative {
      _conditionallyUnreachable()
    }
  }
#endif
#if _runtime(_ObjC)
  internal var _isNative: Bool {
    switch _variant {
    case .native:
      return true
    case .cocoa:
      _cocoaPath()
      return false
    }
  }
#endif
  internal var _asNative: _NativeSet<Element>.Iterator {
    get {
      switch _variant {
      case .native(let nativeIterator):
        return nativeIterator
#if _runtime(_ObjC)
      case .cocoa:
        _internalInvariantFailure("internal error: does not contain a native index")
#endif
      }
    }
    set {
      self._variant = .native(newValue)
    }
  }
#if _runtime(_ObjC)
  internal var _asCocoa: __CocoaSet.Iterator {
    get {
      switch _variant {
      case .native:
        _internalInvariantFailure("internal error: does not contain a Cocoa index")
      case .cocoa(let cocoa):
        return cocoa
      }
    }
  }
#endif
}
extension Set.Iterator: IteratorProtocol {
  @inlinable
  @inline(__always)
  public mutating func next() -> Element? {
#if _runtime(_ObjC)
    guard _isNative else {
      guard let cocoaElement = _asCocoa.next() else { return nil }
      return _forceBridgeFromObjectiveC(cocoaElement, Element.self)
    }
#endif
    return _asNative.next()
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Set.Iterator: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      children: EmptyCollection<(label: String?, value: Any)>())
  }
}
extension Set: CustomReflectable {
  public var customMirror: Mirror {
    let style = Mirror.DisplayStyle.`set`
    return Mirror(self, unlabeledChildren: self, displayStyle: style)
  }
}
#endif
extension Set {
  @inlinable
  public mutating func popFirst() -> Element? {
    guard !isEmpty else { return nil }
    return remove(at: startIndex)
  }
  @inlinable
  public var capacity: Int {
    return _variant.capacity
  }
  public 
  mutating func reserveCapacity(_ minimumCapacity: Int) {
    _variant.reserveCapacity(minimumCapacity)
    _internalInvariant(self.capacity >= minimumCapacity)
  }
}
public typealias SetIndex<Element: Hashable> = Set<Element>.Index
public typealias SetIterator<Element: Hashable> = Set<Element>.Iterator
extension Set: @unchecked Sendable
  where Element: Sendable { }
extension Set.Index: @unchecked Sendable
  where Element: Sendable { }
extension Set.Iterator: @unchecked Sendable
  where Element: Sendable { }
