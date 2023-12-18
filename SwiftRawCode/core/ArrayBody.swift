import SwiftShims
@frozen
@usableFromInline
internal struct _ArrayBody {
  @usableFromInline
  internal var _storage: _SwiftArrayBodyStorage
  @inlinable
  internal init(
    count: Int, capacity: Int, elementTypeIsBridgedVerbatim: Bool = false
  ) {
    _internalInvariant(count >= 0)
    _internalInvariant(capacity >= 0)
    _storage = _SwiftArrayBodyStorage(
      count: count,
      _capacityAndFlags:
        (UInt(truncatingIfNeeded: capacity) &<< 1) |
        (elementTypeIsBridgedVerbatim ? 1 : 0))
  }
  @inlinable
  internal init() {
    _storage = _SwiftArrayBodyStorage(count: 0, _capacityAndFlags: 0)
  }
  @inlinable
  internal var count: Int {
    get {
      return _assumeNonNegative(_storage.count)
    }
    set(newCount) {
      _storage.count = newCount
    }
  }
  @inlinable
  internal var capacity: Int {
    return Int(_capacityAndFlags &>> 1)
  }
  @inlinable
  internal var elementTypeIsBridgedVerbatim: Bool {
    get {
      return (_capacityAndFlags & 0x1) != 0
    }
    set {
      _capacityAndFlags
        = newValue ? _capacityAndFlags | 1 : _capacityAndFlags & ~1
    }
  }
  @inlinable
  internal var _capacityAndFlags: UInt {
    get {
      return _storage._capacityAndFlags
    }
    set {
      _storage._capacityAndFlags = newValue
    }
  }
}
