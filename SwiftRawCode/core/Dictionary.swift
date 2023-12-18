@frozen
public struct Dictionary<Key: Hashable, Value> {
  public typealias Element = (key: Key, value: Value)
  @usableFromInline
  internal var _variant: _Variant
  @inlinable
  internal init(_native: __owned _NativeDictionary<Key, Value>) {
    _variant = _Variant(native: _native)
  }
#if _runtime(_ObjC)
  @inlinable
  internal init(_cocoa: __owned __CocoaDictionary) {
    _variant = _Variant(cocoa: _cocoa)
  }
  @inlinable
  public 
  init(_immutableCocoaDictionary: __owned AnyObject) {
    _internalInvariant(
      _isBridgedVerbatimToObjectiveC(Key.self) &&
      _isBridgedVerbatimToObjectiveC(Value.self),
      """
      Dictionary can be backed by NSDictionary buffer only when both Key \
      and Value are bridged verbatim to Objective-C
      """)
    self.init(_cocoa: __CocoaDictionary(_immutableCocoaDictionary))
  }
#endif
  @inlinable
  public init() {
    self.init(_native: _NativeDictionary())
  }
  public 
  init(minimumCapacity: Int) {
    _variant = _Variant(native: _NativeDictionary(capacity: minimumCapacity))
  }
  @inlinable
  public init<S: Sequence>(
    uniqueKeysWithValues keysAndValues: __owned S
  ) where S.Element == (Key, Value) {
    if let d = keysAndValues as? Dictionary<Key, Value> {
      self = d
      return
    }
    var native = _NativeDictionary<Key, Value>(
      capacity: keysAndValues.underestimatedCount)
    try! native.merge(
      keysAndValues,
      isUnique: true,
      uniquingKeysWith: { _, _ in throw _MergeError.keyCollision })
    self.init(_native: native)
  }
  @inlinable
  public init<S: Sequence>(
    _ keysAndValues: __owned S,
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows where S.Element == (Key, Value) {
    var native = _NativeDictionary<Key, Value>(
      capacity: keysAndValues.underestimatedCount)
    try native.merge(keysAndValues, isUnique: true, uniquingKeysWith: combine)
    self.init(_native: native)
  }
  @inlinable
  public init<S: Sequence>(
    grouping values: __owned S,
    by keyForValue: (S.Element) throws -> Key
  ) rethrows where Value == [S.Element] {
    try self.init(_native: _NativeDictionary(grouping: values, by: keyForValue))
  }
}
extension Dictionary: Sequence {
  @inlinable
  @inline(__always)
  public __consuming func makeIterator() -> Iterator {
    return _variant.makeIterator()
  }
}
extension Dictionary {
  @inlinable
  @available(swift, introduced: 4.0)
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Key: Value] {
  #if _runtime(_ObjC)
    guard _variant.isNative else {
      var result = _NativeDictionary<Key, Value>()
      for element in self {
        if try isIncluded(element) {
          result.insertNew(key: element.key, value: element.value)
        }
      }
      return Dictionary(_native: result)
    }
  #endif
    return Dictionary(_native: try _variant.asNative.filter(isIncluded))
  }
}
extension Dictionary: Collection {
  public typealias SubSequence = Slice<Dictionary>
  @inlinable
  public var startIndex: Index {
    return _variant.startIndex
  }
  @inlinable
  public var endIndex: Index {
    return _variant.endIndex
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
  @inline(__always)
  public func index(forKey key: Key) -> Index? {
    return _variant.index(forKey: key)
  }
  @inlinable
  public subscript(position: Index) -> Element {
    return _variant.lookup(position)
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
extension Dictionary {
  @inlinable
  public subscript(key: Key) -> Value? {
    get {
      return _variant.lookup(key)
    }
    set(newValue) {
      if let x = newValue {
        _variant.setValue(x, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
    _modify {
      defer { _fixLifetime(self) }
      yield &_variant[key]
    }
  }
}
extension Dictionary: ExpressibleByDictionaryLiteral {
  @inlinable
  public init(dictionaryLiteral elements: (Key, Value)...) {
    let native = _NativeDictionary<Key, Value>(capacity: elements.count)
    for (key, value) in elements {
      let (bucket, found) = native.find(key)
      _precondition(!found, "Dictionary literal contains duplicate keys")
      native._insert(at: bucket, key: key, value: value)
    }
    self.init(_native: native)
  }
}
extension Dictionary {
  @inlinable
  public subscript(
    key: Key, default defaultValue: @autoclosure () -> Value
  ) -> Value {
    @inline(__always)
    get {
      return _variant.lookup(key) ?? defaultValue()
    }
    @inline(__always)
    _modify {
      let (bucket, found) = _variant.mutatingFind(key)
      let native = _variant.asNative
      if !found {
        let value = defaultValue()
        native._insert(at: bucket, key: key, value: value)
      }
      let address = native._values + bucket.offset
      defer { _fixLifetime(self) }
      yield &address.pointee
    }
  }
  @inlinable
  public func mapValues<T>(
    _ transform: (Value) throws -> T
  ) rethrows -> Dictionary<Key, T> {
    return try Dictionary<Key, T>(_native: _variant.mapValues(transform))
  }
  @inlinable
  public func compactMapValues<T>(
    _ transform: (Value) throws -> T?
  ) rethrows -> Dictionary<Key, T> {
    let result: _NativeDictionary<Key, T> =
      try self.reduce(into: _NativeDictionary<Key, T>()) { (result, element) in
      if let value = try transform(element.value) {
        result.insertNew(key: element.key, value: value)
      }
    }
    return Dictionary<Key, T>(_native: result)
  }
  @inlinable
  @discardableResult
  public mutating func updateValue(
    _ value: __owned Value,
    forKey key: Key
  ) -> Value? {
    return _variant.updateValue(value, forKey: key)
  }
  @inlinable
  public mutating func merge<S: Sequence>(
    _ other: __owned S,
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows where S.Element == (Key, Value) {
    try _variant.merge(other, uniquingKeysWith: combine)
  }
  @inlinable
  public mutating func merge(
    _ other: __owned [Key: Value],
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows {
    try _variant.merge(
      other.lazy.map { ($0, $1) }, uniquingKeysWith: combine)
  }
  @inlinable
  public __consuming func merging<S: Sequence>(
    _ other: __owned S,
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows -> [Key: Value] where S.Element == (Key, Value) {
    var result = self
    try result._variant.merge(other, uniquingKeysWith: combine)
    return result
  }
  @inlinable
  public __consuming func merging(
    _ other: __owned [Key: Value],
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows -> [Key: Value] {
    var result = self
    try result.merge(other, uniquingKeysWith: combine)
    return result
  }
  @inlinable
  @discardableResult
  public mutating func remove(at index: Index) -> Element {
    return _variant.remove(at: index)
  }
  @inlinable
  @discardableResult
  public mutating func removeValue(forKey key: Key) -> Value? {
    return _variant.removeValue(forKey: key)
  }
  @inlinable
  public mutating func removeAll(keepingCapacity keepCapacity: Bool = false) {
    _variant.removeAll(keepingCapacity: keepCapacity)
  }
}
extension Dictionary {
  @inlinable
  @available(swift, introduced: 4.0)
  public var keys: Keys {
    get {
      return Keys(_dictionary: self)
    }
  }
  @inlinable
  @available(swift, introduced: 4.0)
  public var values: Values {
    get {
      return Values(_dictionary: self)
    }
    _modify {
      var values = Values(_variant: _Variant(dummy: ()))
      swap(&values._variant, &_variant)
      defer { self._variant = values._variant }
      yield &values
    }
  }
  @frozen
  public struct Keys
    : Collection, Equatable,
      CustomStringConvertible, CustomDebugStringConvertible {
    public typealias Element = Key
    public typealias SubSequence = Slice<Dictionary.Keys>
    @usableFromInline
    internal var _variant: Dictionary<Key, Value>._Variant
    @inlinable
    internal init(_dictionary: __owned Dictionary) {
      self._variant = _dictionary._variant
    }
    @inlinable
    public var startIndex: Index {
      return _variant.startIndex
    }
    @inlinable
    public var endIndex: Index {
      return _variant.endIndex
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
    public subscript(position: Index) -> Element {
      return _variant.key(at: position)
    }
    @inlinable
    public var count: Int {
      return _variant.count
    }
    @inlinable
    public var isEmpty: Bool {
      return count == 0
    }
    @inlinable
    @inline(__always)
    public func _customContainsEquatableElement(_ element: Element) -> Bool? {
      return _variant.contains(element)
    }
    @inlinable
    @inline(__always)
    public func _customIndexOfEquatableElement(_ element: Element) -> Index?? {
      return Optional(_variant.index(forKey: element))
    }
    @inlinable
    @inline(__always)
    public func _customLastIndexOfEquatableElement(_ element: Element) -> Index?? {
      return _customIndexOfEquatableElement(element)
    }
    @inlinable
    public static func ==(lhs: Keys, rhs: Keys) -> Bool {
#if _runtime(_ObjC)
      if
        lhs._variant.isNative,
        rhs._variant.isNative,
        lhs._variant.asNative._storage === rhs._variant.asNative._storage
      {
        return true
      }
      if
        !lhs._variant.isNative,
        !rhs._variant.isNative,
        lhs._variant.asCocoa.object === rhs._variant.asCocoa.object
      {
        return true
      }
#else
      if lhs._variant.asNative._storage === rhs._variant.asNative._storage {
        return true
      }
#endif
      if lhs.count != rhs.count {
        return false
      }
      for key in lhs {
        if !rhs.contains(key) {
          return false
        }
      }
      return true
    }
    public var description: String {
      return _makeCollectionDescription()
    }
    public var debugDescription: String {
      return _makeCollectionDescription(withTypeName: "Dictionary.Keys")
    }
  }
  @frozen
  public struct Values
    : MutableCollection, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias Element = Value
    @usableFromInline
    internal var _variant: Dictionary<Key, Value>._Variant
    @inlinable
    internal init(_variant: __owned Dictionary<Key, Value>._Variant) {
      self._variant = _variant
    }
    @inlinable
    internal init(_dictionary: __owned Dictionary) {
      self._variant = _dictionary._variant
    }
    @inlinable
    public var startIndex: Index {
      return _variant.startIndex
    }
    @inlinable
    public var endIndex: Index {
      return _variant.endIndex
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
    public subscript(position: Index) -> Element {
      get {
        return _variant.value(at: position)
      }
      _modify {
        let native = _variant.ensureUniqueNative()
        let bucket = native.validatedBucket(for: position)
        let address = native._values + bucket.offset
        defer { _fixLifetime(self) }
        yield &address.pointee
      }
    }
    @inlinable
    public var count: Int {
      return _variant.count
    }
    @inlinable
    public var isEmpty: Bool {
      return count == 0
    }
    public var description: String {
      return _makeCollectionDescription()
    }
    public var debugDescription: String {
      return _makeCollectionDescription(withTypeName: "Dictionary.Values")
    }
    @inlinable
    public mutating func swapAt(_ i: Index, _ j: Index) {
      guard i != j else { return }
#if _runtime(_ObjC)
      if !_variant.isNative {
        _variant = .init(native: _NativeDictionary(_variant.asCocoa))
      }
#endif
      let isUnique = _variant.isUniquelyReferenced()
      let native = _variant.asNative
      let a = native.validatedBucket(for: i)
      let b = native.validatedBucket(for: j)
      _variant.asNative.swapValuesAt(a, b, isUnique: isUnique)
    }
  }
}
extension Dictionary.Keys {
  @frozen
  public struct Iterator: IteratorProtocol {
    @usableFromInline
    internal var _base: Dictionary<Key, Value>.Iterator
    @inlinable
    @inline(__always)
    internal init(_ base: Dictionary<Key, Value>.Iterator) {
      self._base = base
    }
    @inlinable
    @inline(__always)
    public mutating func next() -> Key? {
#if _runtime(_ObjC)
      if case .cocoa(let cocoa) = _base._variant {
        _base._cocoaPath()
        guard let cocoaKey = cocoa.nextKey() else { return nil }
        return _forceBridgeFromObjectiveC(cocoaKey, Key.self)
      }
#endif
      return _base._asNative.nextKey()
    }
  }
  @inlinable
  @inline(__always)
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_variant.makeIterator())
  }
}
extension Dictionary.Values {
  @frozen
  public struct Iterator: IteratorProtocol {
    @usableFromInline
    internal var _base: Dictionary<Key, Value>.Iterator
    @inlinable
    @inline(__always)
    internal init(_ base: Dictionary<Key, Value>.Iterator) {
      self._base = base
    }
    @inlinable
    @inline(__always)
    public mutating func next() -> Value? {
#if _runtime(_ObjC)
      if case .cocoa(let cocoa) = _base._variant {
        _base._cocoaPath()
        guard let (_, cocoaValue) = cocoa.next() else { return nil }
        return _forceBridgeFromObjectiveC(cocoaValue, Value.self)
      }
#endif
      return _base._asNative.nextValue()
    }
  }
  @inlinable
  @inline(__always)
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_variant.makeIterator())
  }
}
extension Dictionary: Equatable where Value: Equatable {
  @inlinable
  public static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool {
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
extension Dictionary: Hashable where Value: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    var commutativeHash = 0
    for (k, v) in self {
      var elementHasher = hasher
      elementHasher.combine(k)
      elementHasher.combine(v)
      commutativeHash ^= elementHasher._finalize()
    }
    hasher.combine(commutativeHash)
  }
}
extension Dictionary: _HasCustomAnyHashableRepresentation
where Value: Hashable {
  public __consuming func _toCustomAnyHashable() -> AnyHashable? {
    return AnyHashable(_box: _DictionaryAnyHashableBox(self))
  }
}
internal struct _DictionaryAnyHashableBox<Key: Hashable, Value: Hashable>
  : _AnyHashableBox {
  internal let _value: Dictionary<Key, Value>
  internal let _canonical: Dictionary<AnyHashable, AnyHashable>
  internal init(_ value: __owned Dictionary<Key, Value>) {
    self._value = value
    self._canonical = value as Dictionary<AnyHashable, AnyHashable>
  }
  internal var _base: Any {
    return _value
  }
  internal var _canonicalBox: _AnyHashableBox {
    return _DictionaryAnyHashableBox<AnyHashable, AnyHashable>(_canonical)
  }
  internal func _isEqual(to other: _AnyHashableBox) -> Bool? {
    guard
      let other = other as? _DictionaryAnyHashableBox<AnyHashable, AnyHashable>
    else {
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
extension Collection {
  internal func _makeKeyValuePairDescription<K, V>(
    withTypeName type: String? = nil
  ) -> String where Element == (key: K, value: V) {
#if !SWIFT_STDLIB_STATIC_PRINT
    if self.isEmpty {
      return "[:]"
    }
    var result = "["
    var first = true
    for (k, v) in self {
      if first {
        first = false
      } else {
        result += ", "
      }
      debugPrint(k, terminator: "", to: &result)
      result += ": "
      debugPrint(v, terminator: "", to: &result)
    }
    result += "]"
    return result
#else
    return "(collection printing not available)"
#endif
  }
}
extension Dictionary: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return _makeKeyValuePairDescription()
  }
  public var debugDescription: String {
    return _makeKeyValuePairDescription()
  }
}
@usableFromInline
@frozen
internal enum _MergeError: Error {
  case keyCollision
}
extension Dictionary {
  @frozen
  public struct Index {
    @frozen
    @usableFromInline
    internal enum _Variant {
      case native(_HashTable.Index)
#if _runtime(_ObjC)
      case cocoa(__CocoaDictionary.Index)
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
    internal init(_cocoa index: __owned __CocoaDictionary.Index) {
      self.init(_variant: .cocoa(index))
    }
#endif
  }
}
extension Dictionary.Index {
#if _runtime(_ObjC)
  internal var _guaranteedNative: Bool {
    return _canBeClass(Key.self) == 0 || _canBeClass(Value.self) == 0
  }
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
        "Attempting to access Dictionary elements using an invalid index")
#endif
    }
  }
#if _runtime(_ObjC)
  @usableFromInline
  internal var _asCocoa: __CocoaDictionary.Index {
    get {
      switch _variant {
      case .native:
        _preconditionFailure(
          "Attempting to access Dictionary elements using an invalid index")
      case .cocoa(let cocoaIndex):
        return cocoaIndex
      }
    }
    _modify {
      guard case .cocoa(var cocoa) = _variant else {
        _preconditionFailure(
          "Attempting to access Dictionary elements using an invalid index")
      }
      let dummy = _HashTable.Index(bucket: _HashTable.Bucket(offset: 0), age: 0)
      _variant = .native(dummy)
      defer { _variant = .cocoa(cocoa) }
      yield &cocoa
    }
  }
#endif
}
extension Dictionary.Index: Equatable {
  @inlinable
  public static func == (
    lhs: Dictionary<Key, Value>.Index,
    rhs: Dictionary<Key, Value>.Index
  ) -> Bool {
    switch (lhs._variant, rhs._variant) {
    case (.native(let lhsNative), .native(let rhsNative)):
      return lhsNative == rhsNative
  #if _runtime(_ObjC)
    case (.cocoa(let lhsCocoa), .cocoa(let rhsCocoa)):
      lhs._cocoaPath()
      return lhsCocoa == rhsCocoa
    default:
      _preconditionFailure("Comparing indexes from different dictionaries")
  #endif
    }
  }
}
extension Dictionary.Index: Comparable {
  @inlinable
  public static func < (
    lhs: Dictionary<Key, Value>.Index,
    rhs: Dictionary<Key, Value>.Index
  ) -> Bool {
    switch (lhs._variant, rhs._variant) {
    case (.native(let lhsNative), .native(let rhsNative)):
      return lhsNative < rhsNative
  #if _runtime(_ObjC)
    case (.cocoa(let lhsCocoa), .cocoa(let rhsCocoa)):
      lhs._cocoaPath()
      return lhsCocoa < rhsCocoa
    default:
      _preconditionFailure("Comparing indexes from different dictionaries")
  #endif
    }
  }
}
extension Dictionary.Index: Hashable {
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
extension Dictionary {
  @frozen
  public struct Iterator {
    @usableFromInline
    @frozen
    internal enum _Variant {
      case native(_NativeDictionary<Key, Value>.Iterator)
#if _runtime(_ObjC)
      case cocoa(__CocoaDictionary.Iterator)
#endif
    }
    @usableFromInline
    internal var _variant: _Variant
    @inlinable
    internal init(_variant: __owned _Variant) {
      self._variant = _variant
    }
    @inlinable
    internal init(_native: __owned _NativeDictionary<Key, Value>.Iterator) {
      self.init(_variant: .native(_native))
    }
#if _runtime(_ObjC)
    @inlinable
    internal init(_cocoa: __owned __CocoaDictionary.Iterator) {
      self.init(_variant: .cocoa(_cocoa))
    }
#endif
  }
}
extension Dictionary.Iterator {
#if _runtime(_ObjC)
  internal var _guaranteedNative: Bool {
    return _canBeClass(Key.self) == 0 || _canBeClass(Value.self) == 0
  }
  internal func _cocoaPath() {
    if _guaranteedNative {
      _conditionallyUnreachable()
    }
  }
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
  internal var _asNative: _NativeDictionary<Key, Value>.Iterator {
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
  internal var _asCocoa: __CocoaDictionary.Iterator {
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
extension Dictionary.Iterator: IteratorProtocol {
  @inlinable
  @inline(__always)
  public mutating func next() -> (key: Key, value: Value)? {
#if _runtime(_ObjC)
    guard _isNative else {
      if let (cocoaKey, cocoaValue) = _asCocoa.next() {
        let nativeKey = _forceBridgeFromObjectiveC(cocoaKey, Key.self)
        let nativeValue = _forceBridgeFromObjectiveC(cocoaValue, Value.self)
        return (nativeKey, nativeValue)
      }
      return nil
    }
#endif
    return _asNative.next()
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Dictionary.Iterator: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(
      self,
      children: EmptyCollection<(label: String?, value: Any)>())
  }
}
extension Dictionary: CustomReflectable {
  public var customMirror: Mirror {
    let style = Mirror.DisplayStyle.dictionary
    return Mirror(self, unlabeledChildren: self, displayStyle: style)
  }
}
#endif
extension Dictionary {
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
public typealias DictionaryIndex<Key: Hashable, Value> =
  Dictionary<Key, Value>.Index
public typealias DictionaryIterator<Key: Hashable, Value> =
  Dictionary<Key, Value>.Iterator
extension Dictionary: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Keys: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Values: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Keys.Iterator: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Values.Iterator: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Index: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
extension Dictionary.Iterator: @unchecked Sendable
  where Key: Sendable, Value: Sendable { }
