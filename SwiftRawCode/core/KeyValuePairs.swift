@frozen 
public struct KeyValuePairs<Key, Value>: ExpressibleByDictionaryLiteral {
  @usableFromInline 
  internal let _elements: [(Key, Value)]
  @inlinable 
  public init(dictionaryLiteral elements: (Key, Value)...) {
    self._elements = elements
  }
}
extension KeyValuePairs: RandomAccessCollection {
  public typealias Element = (key: Key, value: Value)
  public typealias Index = Int
  public typealias Indices = Range<Int>
  public typealias SubSequence = Slice<KeyValuePairs>
  @inlinable 
  public var startIndex: Index { return 0 }
  @inlinable 
  public var endIndex: Index { return _elements.endIndex }
  @inlinable 
  public subscript(position: Index) -> Element {
    return _elements[position]
  }
}
extension KeyValuePairs: CustomStringConvertible {
  public var description: String {
    return _makeKeyValuePairDescription()
  }
}
extension KeyValuePairs: CustomDebugStringConvertible {
  public var debugDescription: String {
    return _makeKeyValuePairDescription()
  }
}
extension KeyValuePairs: Sendable
    where Key: Sendable, Value: Sendable { }
