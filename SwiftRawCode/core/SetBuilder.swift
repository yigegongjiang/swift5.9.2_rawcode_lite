@frozen
public 
struct _SetBuilder<Element: Hashable> {
  @usableFromInline
  internal var _target: _NativeSet<Element>
  @usableFromInline
  internal let _requestedCount: Int
  @inlinable
  public init(count: Int) {
    _target = _NativeSet(capacity: count)
    _requestedCount = count
  }
  @inlinable
  @inline(__always)
  public mutating func add(member: Element) {
    _precondition(_target.count < _requestedCount,
      "Can't add more members than promised")
    _target._unsafeInsertNew(member)
  }
  @inlinable
  public __consuming func take() -> Set<Element> {
    _precondition(_target.count == _requestedCount,
      "The number of members added does not match the promised count")
    return Set(_native: _target)
  }
}
