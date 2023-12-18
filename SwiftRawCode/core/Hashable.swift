public protocol Hashable: Equatable {
  var hashValue: Int { get }
  func hash(into hasher: inout Hasher)
  func _rawHashValue(seed: Int) -> Int
}
extension Hashable {
  @inlinable
  @inline(__always)
  public func _rawHashValue(seed: Int) -> Int {
    var hasher = Hasher(_seed: seed)
    hasher.combine(self)
    return hasher._finalize()
  }
}
@inlinable
@inline(__always)
public func _hashValue<H: Hashable>(for value: H) -> Int {
  return value._rawHashValue(seed: 0)
}
internal func Hashable_isEqual_indirect<T: Hashable>(
  _ lhs: UnsafePointer<T>,
  _ rhs: UnsafePointer<T>
) -> Bool {
  return lhs.pointee == rhs.pointee
}
internal func Hashable_hashValue_indirect<T: Hashable>(
  _ value: UnsafePointer<T>
) -> Int {
  return value.pointee.hashValue
}
