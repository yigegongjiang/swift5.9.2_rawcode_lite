@frozen
public 
struct _DictionaryBuilder<Key: Hashable, Value> {
  @usableFromInline
  internal var _target: _NativeDictionary<Key, Value>
  @usableFromInline
  internal let _requestedCount: Int
  @inlinable
  public init(count: Int) {
    _target = _NativeDictionary(capacity: count)
    _requestedCount = count
  }
  @inlinable
  public mutating func add(key newKey: Key, value: Value) {
    _precondition(_target.count < _requestedCount,
      "Can't add more members than promised")
    _target._unsafeInsertNew(key: newKey, value: value)
  }
  @inlinable
  public __consuming func take() -> Dictionary<Key, Value> {
    _precondition(_target.count == _requestedCount,
      "The number of members added does not match the promised count")
    return Dictionary(_native: _target)
  }
}
extension Dictionary {
  public 
  init(
    _unsafeUninitializedCapacity capacity: Int,
    allowingDuplicates: Bool,
    initializingWith initializer: (
      _ keys: UnsafeMutableBufferPointer<Key>,
      _ values: UnsafeMutableBufferPointer<Value>
    ) -> Int
  ) {
    self.init(_native: _NativeDictionary(
        _unsafeUninitializedCapacity: capacity,
        allowingDuplicates: allowingDuplicates,
        initializingWith: initializer))
  }
}
extension _NativeDictionary {
  internal init(
    _unsafeUninitializedCapacity capacity: Int,
    allowingDuplicates: Bool,
    initializingWith initializer: (
      _ keys: UnsafeMutableBufferPointer<Key>,
      _ values: UnsafeMutableBufferPointer<Value>
    ) -> Int
  ) {
    self.init(capacity: capacity)
    let initializedCount = initializer(
      UnsafeMutableBufferPointer(start: _keys, count: capacity),
      UnsafeMutableBufferPointer(start: _values, count: capacity))
    _precondition(initializedCount >= 0 && initializedCount <= capacity)
    _storage._count = initializedCount
    var bucket = _HashTable.Bucket(offset: initializedCount - 1)
    while bucket.offset >= 0 {
      if hashTable._isOccupied(bucket) {
        bucket.offset -= 1
        continue
      }
      let target: Bucket
      if _isDebugAssertConfiguration() || allowingDuplicates {
        let (b, found) = find(_keys[bucket.offset])
        if found {
          _internalInvariant(b != bucket)
          _precondition(allowingDuplicates, "Duplicate keys found")
          uncheckedDestroy(at: bucket)
          _storage._count -= 1
          bucket.offset -= 1
          continue
        }
        hashTable.insert(b)
        target = b
      } else {
        let hashValue = self.hashValue(for: _keys[bucket.offset])
        target = hashTable.insertNew(hashValue: hashValue)
      }
      if target > bucket {
        moveEntry(from: bucket, to: target)
        bucket.offset -= 1
      } else if target == bucket {
        bucket.offset -= 1
      } else {
        swapEntry(target, with: bucket)
      }
    }
  }
}
