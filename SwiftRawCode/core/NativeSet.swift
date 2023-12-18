@usableFromInline
@frozen
internal struct _NativeSet<Element: Hashable> {
  @usableFromInline
  internal var _storage: __RawSetStorage
  @inlinable
  @inline(__always)
  internal init() {
    self._storage = __RawSetStorage.empty
  }
  @inlinable
  @inline(__always)
  internal init(_ storage: __owned __RawSetStorage) {
    self._storage = storage
  }
  @inlinable
  internal init(capacity: Int) {
    if capacity == 0 {
      self._storage = __RawSetStorage.empty
    } else {
      self._storage = _SetStorage<Element>.allocate(capacity: capacity)
    }
  }
#if _runtime(_ObjC)
  @inlinable
  internal init(_ cocoa: __owned __CocoaSet) {
    self.init(cocoa, capacity: cocoa.count)
  }
  @inlinable
  internal init(_ cocoa: __owned __CocoaSet, capacity: Int) {
    if capacity == 0 {
      self._storage = __RawSetStorage.empty
    } else {
      _internalInvariant(cocoa.count <= capacity)
      self._storage = _SetStorage<Element>.convert(cocoa, capacity: capacity)
      for element in cocoa {
        let nativeElement = _forceBridgeFromObjectiveC(element, Element.self)
        insertNew(nativeElement, isUnique: true)
      }
    }
  }
#endif
}
extension _NativeSet { 
  @usableFromInline
  internal typealias Bucket = _HashTable.Bucket
  @inlinable
  internal var capacity: Int {
    @inline(__always)
    get {
      return _assumeNonNegative(_storage._capacity)
    }
  }
  @inline(__always)
  internal var bucketCount: Int {
    _assumeNonNegative(_storage._bucketCount)
  }
  @inlinable
  internal var hashTable: _HashTable {
    @inline(__always) get {
      return _storage._hashTable
    }
  }
  @inlinable
  internal var age: Int32 {
    @inline(__always) get {
      return _storage._age
    }
  }
  @inlinable
  internal var _elements: UnsafeMutablePointer<Element> {
    return _storage._rawElements.assumingMemoryBound(to: Element.self)
  }
  @inlinable
  @inline(__always)
  internal func invalidateIndices() {
    _storage._age &+= 1
  }
}
extension _NativeSet { 
  @inlinable
  @inline(__always)
  internal func uncheckedElement(at bucket: Bucket) -> Element {
    defer { _fixLifetime(self) }
    _internalInvariant(hashTable.isOccupied(bucket))
    return _elements[bucket.offset]
  }
  @inlinable
  @inline(__always)
  internal func uncheckedInitialize(
    at bucket: Bucket,
    to element: __owned Element
  ) {
    _internalInvariant(hashTable.isValid(bucket))
    (_elements + bucket.offset).initialize(to: element)
  }
  @inline(__always)
  internal func uncheckedAssign(
    at bucket: Bucket,
    to element: __owned Element
  ) {
    _internalInvariant(hashTable.isOccupied(bucket))
    (_elements + bucket.offset).pointee = element
  }
}
extension _NativeSet { 
  @inlinable
  @inline(__always)
  internal func hashValue(for element: Element) -> Int {
    return element._rawHashValue(seed: _storage._seed)
  }
  @inlinable
  @inline(__always)
  internal func find(_ element: Element) -> (bucket: Bucket, found: Bool) {
    return find(element, hashValue: self.hashValue(for: element))
  }
  @inlinable
  @inline(__always)
  internal func find(
    _ element: Element,
    hashValue: Int
  ) -> (bucket: Bucket, found: Bool) {
    let hashTable = self.hashTable
    var bucket = hashTable.idealBucket(forHashValue: hashValue)
    while hashTable._isOccupied(bucket) {
      if uncheckedElement(at: bucket) == element {
        return (bucket, true)
      }
      bucket = hashTable.bucket(wrappedAfter: bucket)
    }
    return (bucket, false)
  }
}
extension _NativeSet { 
  @inlinable
  internal mutating func resize(capacity: Int) {
    let capacity = Swift.max(capacity, self.capacity)
    let result = _NativeSet(_SetStorage<Element>.resize(
        original: _storage,
        capacity: capacity,
        move: true))
    if count > 0 {
      for bucket in hashTable {
        let element = (self._elements + bucket.offset).move()
        result._unsafeInsertNew(element)
      }
      _storage._hashTable.clear()
      _storage._count = 0
    }
    _storage = result._storage
  }
  @inlinable
  internal mutating func copyAndResize(capacity: Int) {
    let capacity = Swift.max(capacity, self.capacity)
    let result = _NativeSet(_SetStorage<Element>.resize(
        original: _storage,
        capacity: capacity,
        move: false))
    if count > 0 {
      for bucket in hashTable {
        result._unsafeInsertNew(self.uncheckedElement(at: bucket))
      }
    }
    _storage = result._storage
  }
  @inlinable
  internal mutating func copy() {
    let newStorage = _SetStorage<Element>.copy(original: _storage)
    _internalInvariant(newStorage._scale == _storage._scale)
    _internalInvariant(newStorage._age == _storage._age)
    _internalInvariant(newStorage._seed == _storage._seed)
    let result = _NativeSet(newStorage)
    if count > 0 {
      result.hashTable.copyContents(of: hashTable)
      result._storage._count = self.count
      for bucket in hashTable {
        let element = uncheckedElement(at: bucket)
        result.uncheckedInitialize(at: bucket, to: element)
      }
    }
    _storage = result._storage
  }
  @inlinable
  @inline(__always)
  internal mutating func ensureUnique(isUnique: Bool, capacity: Int) -> Bool {
    if _fastPath(capacity <= self.capacity && isUnique) {
      return false
    }
    if isUnique {
      resize(capacity: capacity)
      return true
    }
    if capacity <= self.capacity {
      copy()
      return false
    }
    copyAndResize(capacity: capacity)
    return true
  }
  internal mutating func reserveCapacity(_ capacity: Int, isUnique: Bool) {
    _ = ensureUnique(isUnique: isUnique, capacity: capacity)
  }
}
extension _NativeSet {
  @inlinable
  @inline(__always)
  func validatedBucket(for index: _HashTable.Index) -> Bucket {
    _precondition(hashTable.isOccupied(index.bucket) && index.age == age,
      "Attempting to access Set elements using an invalid index")
    return index.bucket
  }
  @inlinable
  @inline(__always)
  func validatedBucket(for index: Set<Element>.Index) -> Bucket {
#if _runtime(_ObjC)
    guard index._isNative else {
      index._cocoaPath()
      let cocoa = index._asCocoa
      if cocoa.age == self.age {
        let element = _forceBridgeFromObjectiveC(cocoa.element, Element.self)
        let (bucket, found) = find(element)
        if found {
          return bucket
        }
      }
      _preconditionFailure(
        "Attempting to access Set elements using an invalid index")
    }
#endif
    return validatedBucket(for: index._asNative)
  }
}
extension _NativeSet: _SetBuffer {
  @usableFromInline
  internal typealias Index = Set<Element>.Index
  @inlinable
  internal var startIndex: Index {
    let bucket = hashTable.startBucket
    return Index(_native: _HashTable.Index(bucket: bucket, age: age))
  }
  @inlinable
  internal var endIndex: Index {
    let bucket = hashTable.endBucket
    return Index(_native: _HashTable.Index(bucket: bucket, age: age))
  }
  @inlinable
  internal func index(after index: Index) -> Index {
    let bucket = validatedBucket(for: index._asNative)
    let next = hashTable.occupiedBucket(after: bucket)
    return Index(_native: _HashTable.Index(bucket: next, age: age))
  }
  @inlinable
  @inline(__always)
  internal func index(for element: Element) -> Index? {
    if count == 0 {
      return nil
    }
    let (bucket, found) = find(element)
    guard found else { return nil }
    return Index(_native: _HashTable.Index(bucket: bucket, age: age))
  }
  @inlinable
  internal var count: Int {
    @inline(__always) get {
      return _assumeNonNegative(_storage._count)
    }
  }
  @inlinable
  @inline(__always)
  internal func contains(_ member: Element) -> Bool {
    if count == 0 { return false }
    return find(member).found
  }
  @inlinable
  @inline(__always)
  internal func element(at index: Index) -> Element {
    let bucket = validatedBucket(for: index)
    return uncheckedElement(at: bucket)
  }
}
@usableFromInline
@inline(never)
internal func ELEMENT_TYPE_OF_SET_VIOLATES_HASHABLE_REQUIREMENTS(
  _ elementType: Any.Type
) -> Never {
  _assertionFailure(
    "Fatal error",
    """
    Duplicate elements of type '\(elementType)' were found in a Set.
    This usually means either that the type violates Hashable's requirements, or
    that members of such a set were mutated after insertion.
    """,
    flags: _fatalErrorFlags())
}
extension _NativeSet { 
  @inlinable
  internal func _unsafeInsertNew(_ element: __owned Element) {
    _internalInvariant(count + 1 <= capacity)
    let hashValue = self.hashValue(for: element)
    if _isDebugAssertConfiguration() {
      let (bucket, found) = find(element, hashValue: hashValue)
      guard !found else {
        ELEMENT_TYPE_OF_SET_VIOLATES_HASHABLE_REQUIREMENTS(Element.self)
      }
      hashTable.insert(bucket)
      uncheckedInitialize(at: bucket, to: element)
    } else {
      let bucket = hashTable.insertNew(hashValue: hashValue)
      uncheckedInitialize(at: bucket, to: element)
    }
    _storage._count &+= 1
  }
  @inlinable
  internal mutating func insertNew(_ element: __owned Element, isUnique: Bool) {
    _ = ensureUnique(isUnique: isUnique, capacity: count + 1)
    _unsafeInsertNew(element)
  }
  @inlinable
  internal func _unsafeInsertNew(_ element: __owned Element, at bucket: Bucket) {
    hashTable.insert(bucket)
    uncheckedInitialize(at: bucket, to: element)
    _storage._count += 1
  }
  @inlinable
  internal mutating func insertNew(
    _ element: __owned Element,
    at bucket: Bucket,
    isUnique: Bool
  ) {
    _internalInvariant(!hashTable.isOccupied(bucket))
    var bucket = bucket
    let rehashed = ensureUnique(isUnique: isUnique, capacity: count + 1)
    if rehashed {
      let (b, f) = find(element)
      if f {
        ELEMENT_TYPE_OF_SET_VIOLATES_HASHABLE_REQUIREMENTS(Element.self)
      }
      bucket = b
    }
    _unsafeInsertNew(element, at: bucket)
  }
  @inlinable
  internal mutating func update(
    with element: __owned Element,
    isUnique: Bool
  ) -> Element? {
    var (bucket, found) = find(element)
    let rehashed = ensureUnique(
      isUnique: isUnique,
      capacity: count + (found ? 0 : 1))
    if rehashed {
      let (b, f) = find(element)
      if f != found {
        ELEMENT_TYPE_OF_SET_VIOLATES_HASHABLE_REQUIREMENTS(Element.self)
      }
      bucket = b
    }
    if found {
      let old = (_elements + bucket.offset).move()
      uncheckedInitialize(at: bucket, to: element)
      return old
    }
    _unsafeInsertNew(element, at: bucket)
    return nil
  }
  internal mutating func _unsafeUpdate(
    with element: __owned Element
  ) {
    let (bucket, found) = find(element)
    if found {
      uncheckedAssign(at: bucket, to: element)
    } else {
      _precondition(count < capacity)
      _unsafeInsertNew(element, at: bucket)
    }
  }
}
extension _NativeSet {
  @inlinable
  @inline(__always)
  func isEqual(to other: _NativeSet) -> Bool {
    if self._storage === other._storage { return true }
    if self.count != other.count { return false }
    for member in self {
      guard other.find(member).found else { return false }
    }
    return true
  }
#if _runtime(_ObjC)
  @inlinable
  func isEqual(to other: __CocoaSet) -> Bool {
    if self.count != other.count { return false }
    defer { _fixLifetime(self) }
    for bucket in self.hashTable {
      let key = self.uncheckedElement(at: bucket)
      let bridgedKey = _bridgeAnythingToObjectiveC(key)
      guard other.contains(bridgedKey) else { return false }
    }
    return true
  }
#endif
}
extension _NativeSet: _HashTableDelegate {
  @inlinable
  @inline(__always)
  internal func hashValue(at bucket: Bucket) -> Int {
    return hashValue(for: uncheckedElement(at: bucket))
  }
  @inlinable
  @inline(__always)
  internal func moveEntry(from source: Bucket, to target: Bucket) {
    (_elements + target.offset)
      .moveInitialize(from: _elements + source.offset, count: 1)
  }
}
extension _NativeSet { 
  @inlinable
  internal mutating func _delete(at bucket: Bucket) {
    hashTable.delete(at: bucket, with: self)
    _storage._count -= 1
    _internalInvariant(_storage._count >= 0)
    invalidateIndices()
  }
  @inlinable
  @inline(__always)
  internal mutating func uncheckedRemove(
    at bucket: Bucket,
    isUnique: Bool) -> Element {
    _internalInvariant(hashTable.isOccupied(bucket))
    let rehashed = ensureUnique(isUnique: isUnique, capacity: capacity)
    _internalInvariant(!rehashed)
    let old = (_elements + bucket.offset).move()
    _delete(at: bucket)
    return old
  }
  @usableFromInline
  internal mutating func removeAll(isUnique: Bool) {
    guard isUnique else {
      let scale = self._storage._scale
      _storage = _SetStorage<Element>.allocate(
        scale: scale,
        age: nil,
        seed: nil)
      return
    }
    for bucket in hashTable {
      (_elements + bucket.offset).deinitialize(count: 1)
    }
    hashTable.clear()
    _storage._count = 0
    invalidateIndices()
  }
}
extension _NativeSet: Sequence {
  @usableFromInline
  @frozen
  internal struct Iterator {
    @usableFromInline
    internal let base: _NativeSet
    @usableFromInline
    internal var iterator: _HashTable.Iterator
    @inlinable
    @inline(__always)
    init(_ base: __owned _NativeSet) {
      self.base = base
      self.iterator = base.hashTable.makeIterator()
    }
  }
  @inlinable
  @inline(__always)
  internal __consuming func makeIterator() -> Iterator {
    return Iterator(self)
  }
}
extension _NativeSet.Iterator: IteratorProtocol {
  @inlinable
  @inline(__always)
  internal mutating func next() -> Element? {
    guard let index = iterator.next() else { return nil }
    return base.uncheckedElement(at: index)
  }
}
extension _NativeSet {
  internal func isSubset<S: Sequence>(of possibleSuperset: S) -> Bool
  where S.Element == Element {
    _UnsafeBitset.withTemporaryBitset(capacity: self.bucketCount) { seen in
      var seenCount = 0
      for element in possibleSuperset {
        let (bucket, found) = find(element)
        guard found else { continue }
        let inserted = seen.uncheckedInsert(bucket.offset)
        if inserted {
          seenCount += 1
          if seenCount == self.count {
            return true
          }
        }
      }
      return false
    }
  }
  internal func isStrictSubset<S: Sequence>(of possibleSuperset: S) -> Bool
  where S.Element == Element {
    _UnsafeBitset.withTemporaryBitset(capacity: self.bucketCount) { seen in
      var seenCount = 0
      var isStrict = false
      for element in possibleSuperset {
        let (bucket, found) = find(element)
        guard found else {
          if !isStrict {
            isStrict = true
            if seenCount == self.count { return true }
          }
          continue
        }
        let inserted = seen.uncheckedInsert(bucket.offset)
        if inserted {
          seenCount += 1
          if seenCount == self.count, isStrict {
            return true
          }
        }
      }
      return false
    }
  }
  internal func isStrictSuperset<S: Sequence>(of possibleSubset: S) -> Bool
  where S.Element == Element {
    _UnsafeBitset.withTemporaryBitset(capacity: self.bucketCount) { seen in
      var seenCount = 0
      for element in possibleSubset {
        let (bucket, found) = find(element)
        guard found else { return false }
        let inserted = seen.uncheckedInsert(bucket.offset)
        if inserted {
          seenCount += 1
          if seenCount == self.count {
            return false
          }
        }
      }
      return true
    }
  }
  internal __consuming func extractSubset(
    using bitset: _UnsafeBitset,
    count: Int
  ) -> _NativeSet {
    var count = count
    if count == 0 { return _NativeSet() }
    if count == self.count { return self }
    let result = _NativeSet(capacity: count)
    for offset in bitset {
      result._unsafeInsertNew(self.uncheckedElement(at: Bucket(offset: offset)))
      count -= 1
      if count == 0 { break }
    }
    return result
  }
  internal __consuming func subtracting<S: Sequence>(_ other: S) -> _NativeSet
  where S.Element == Element {
    guard count > 0 else { return _NativeSet() }
    var it = other.makeIterator()
    var bucket: Bucket? = nil
    while let next = it.next() {
      let (b, found) = find(next)
      if found {
        bucket = b
        break
      }
    }
    guard let bucket = bucket else { return self }
    return _UnsafeBitset.withTemporaryCopy(of: hashTable.bitset) { difference in
      var remainingCount = self.count
      let removed = difference.uncheckedRemove(bucket.offset)
      _internalInvariant(removed)
      remainingCount -= 1
      while let element = it.next() {
        let (bucket, found) = find(element)
        if found {
          if difference.uncheckedRemove(bucket.offset) {
            remainingCount -= 1
            if remainingCount == 0 { return _NativeSet() }
          }
        }
      }
      _internalInvariant(difference.count > 0)
      return extractSubset(using: difference, count: remainingCount)
    }
  }
  internal __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> _NativeSet<Element> {
    try _UnsafeBitset.withTemporaryBitset(capacity: bucketCount) { bitset in
      var count = 0
      for bucket in hashTable {
        if try isIncluded(uncheckedElement(at: bucket)) {
          bitset.uncheckedInsert(bucket.offset)
          count += 1
        }
      }
      return extractSubset(using: bitset, count: count)
    }
  }
  internal __consuming func intersection(
    _ other: _NativeSet<Element>
  ) -> _NativeSet<Element> {
    _UnsafeBitset.withTemporaryBitset(capacity: bucketCount) { bitset in
      var count = 0
      if self.count > other.count {
        for element in other {
          let (bucket, found) = find(element)
          if found {
            bitset.uncheckedInsert(bucket.offset)
            count += 1
          }
        }
      } else {
        for bucket in hashTable {
          if other.find(uncheckedElement(at: bucket)).found {
            bitset.uncheckedInsert(bucket.offset)
            count += 1
          }
        }
      }
      return extractSubset(using: bitset, count: count)
    }
  }
  internal __consuming func genericIntersection<S: Sequence>(
    _ other: S
  ) -> _NativeSet<Element>
  where S.Element == Element {
    _UnsafeBitset.withTemporaryBitset(capacity: bucketCount) { bitset in
      var count = 0
      for element in other {
        let (bucket, found) = find(element)
        if found, bitset.uncheckedInsert(bucket.offset) {
          count += 1
        }
      }
      return extractSubset(using: bitset, count: count)
    }
  }
}
