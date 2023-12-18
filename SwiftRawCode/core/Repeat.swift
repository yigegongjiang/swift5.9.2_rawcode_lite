@frozen
public struct Repeated<Element> {
  public let count: Int
  public let repeatedValue: Element
  @inlinable 
  internal init(_repeating repeatedValue: Element, count: Int) {
    _precondition(count >= 0, "Repetition count should be non-negative")
    self.count = count
    self.repeatedValue = repeatedValue
  }
}
extension Repeated: RandomAccessCollection {
  public typealias Indices = Range<Int>
  public typealias Index = Int
  @inlinable 
  public var startIndex: Index {
    return 0
  }
  @inlinable 
  public var endIndex: Index {
    return count
  }
  @inlinable 
  public subscript(position: Int) -> Element {
    _precondition(position >= 0 && position < count, "Index out of range")
    return repeatedValue
  }
}
@inlinable 
public func repeatElement<T>(_ element: T, count n: Int) -> Repeated<T> {
  return Repeated(_repeating: element, count: n)
}
extension Repeated: Sendable where Element: Sendable { }
