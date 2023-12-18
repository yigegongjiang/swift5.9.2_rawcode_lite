@usableFromInline
internal protocol _ArrayProtocol
  : RangeReplaceableCollection, ExpressibleByArrayLiteral
where Indices == Range<Int> {
  var capacity: Int { get }
  var _owner: AnyObject? { get }
  var _baseAddressIfContiguous: UnsafeMutablePointer<Element>? { get }
  override mutating func reserveCapacity(_ minimumCapacity: Int)
  override mutating func insert(_ newElement: __owned Element, at i: Int)
  @discardableResult
  override mutating func remove(at index: Int) -> Element
  associatedtype _Buffer: _ArrayBufferProtocol where _Buffer.Element == Element
  init(_ buffer: _Buffer)
  var _buffer: _Buffer { get }
}
extension _ArrayProtocol {
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _filter(isIncluded)
  }
}
