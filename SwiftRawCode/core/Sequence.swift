public protocol IteratorProtocol<Element> {
  associatedtype Element
  mutating func next() -> Element?
}
public protocol Sequence<Element> {
  associatedtype Element
  associatedtype Iterator: IteratorProtocol where Iterator.Element == Element
  @available(*, unavailable, renamed: "Iterator")
  typealias Generator = Iterator
  __consuming func makeIterator() -> Iterator
  var underestimatedCount: Int { get }
  func _customContainsEquatableElement(
    _ element: Element
  ) -> Bool?
  __consuming func _copyToContiguousArray() -> ContiguousArray<Element>
  __consuming func _copyContents(
    initializing ptr: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator,UnsafeMutableBufferPointer<Element>.Index)
  func withContiguousStorageIfAvailable<R>(
    _ body: (_ buffer: UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R?
}
extension Sequence where Self: IteratorProtocol {
  public typealias _Default_Iterator = Self
}
extension Sequence where Self.Iterator == Self {
  @inlinable
  public __consuming func makeIterator() -> Self {
    return self
  }
}
@frozen
public struct DropFirstSequence<Base: Sequence> {
  @usableFromInline
  internal let _base: Base
  @usableFromInline
  internal let _limit: Int
  @inlinable 
  public init(_ base: Base, dropping limit: Int) {
    _precondition(limit >= 0, 
      "Can't drop a negative number of elements from a sequence")
    _base = base
    _limit = limit
  }
}
extension DropFirstSequence: Sequence {
  public typealias Element = Base.Element
  public typealias Iterator = Base.Iterator
  public typealias SubSequence = AnySequence<Element>
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    var it = _base.makeIterator()
    var dropped = 0
    while dropped < _limit, it.next() != nil { dropped &+= 1 }
    return it
  }
  @inlinable
  public __consuming func dropFirst(_ k: Int) -> DropFirstSequence<Base> {
    return DropFirstSequence(_base, dropping: _limit + k)
  }
}
@frozen
public struct PrefixSequence<Base: Sequence> {
  @usableFromInline
  internal var _base: Base
  @usableFromInline
  internal let _maxLength: Int
  @inlinable
  public init(_ base: Base, maxLength: Int) {
    _precondition(maxLength >= 0, "Can't take a prefix of negative length")
    _base = base
    _maxLength = maxLength
  }
}
extension PrefixSequence {
  @frozen
  public struct Iterator {
    @usableFromInline
    internal var _base: Base.Iterator
    @usableFromInline
    internal var _remaining: Int
    @inlinable
    internal init(_ base: Base.Iterator, maxLength: Int) {
      _base = base
      _remaining = maxLength
    }
  }  
}
extension PrefixSequence.Iterator: IteratorProtocol {
  public typealias Element = Base.Element
  @inlinable
  public mutating func next() -> Element? {
    if _remaining != 0 {
      _remaining &-= 1
      return _base.next()
    } else {
      return nil
    }
  }  
}
extension PrefixSequence: Sequence {
  @inlinable
  public __consuming func makeIterator() -> Iterator {
    return Iterator(_base.makeIterator(), maxLength: _maxLength)
  }
  @inlinable
  public __consuming func prefix(_ maxLength: Int) -> PrefixSequence<Base> {
    let length = Swift.min(maxLength, self._maxLength)
    return PrefixSequence(_base, maxLength: length)
  }
}
@frozen
public struct DropWhileSequence<Base: Sequence> {
  public typealias Element = Base.Element
  @usableFromInline
  internal var _iterator: Base.Iterator
  @usableFromInline
  internal var _nextElement: Element?
  @inlinable
  internal init(iterator: Base.Iterator, predicate: (Element) throws -> Bool) rethrows {
    _iterator = iterator
    _nextElement = _iterator.next()
    while let x = _nextElement, try predicate(x) {
      _nextElement = _iterator.next()
    }
  }
  @inlinable
  internal init(_ base: Base, predicate: (Element) throws -> Bool) rethrows {
    self = try DropWhileSequence(iterator: base.makeIterator(), predicate: predicate)
  }
}
extension DropWhileSequence {
  @frozen
  public struct Iterator {
    @usableFromInline
    internal var _iterator: Base.Iterator
    @usableFromInline
    internal var _nextElement: Element?
    @inlinable
    internal init(_ iterator: Base.Iterator, nextElement: Element?) {
      _iterator = iterator
      _nextElement = nextElement
    }
  }
}
extension DropWhileSequence.Iterator: IteratorProtocol {
  public typealias Element = Base.Element
  @inlinable
  public mutating func next() -> Element? {
    guard let next = _nextElement else { return nil }
    _nextElement = _iterator.next()
    return next
  }
}
extension DropWhileSequence: Sequence {
  @inlinable
  public func makeIterator() -> Iterator {
    return Iterator(_iterator, nextElement: _nextElement)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> DropWhileSequence<Base> {
    guard let x = _nextElement, try predicate(x) else { return self }
    return try DropWhileSequence(iterator: _iterator, predicate: predicate)
  }
}
extension Sequence {
  @inlinable
  public func map<T>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T] {
    let initialCapacity = underestimatedCount
    var result = ContiguousArray<T>()
    result.reserveCapacity(initialCapacity)
    var iterator = self.makeIterator()
    for _ in 0..<initialCapacity {
      result.append(try transform(iterator.next()!))
    }
    while let element = iterator.next() {
      result.append(try transform(element))
    }
    return Array(result)
  }
  @inlinable
  public __consuming func filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    return try _filter(isIncluded)
  }
  public func _filter(
    _ isIncluded: (Element) throws -> Bool
  ) rethrows -> [Element] {
    var result = ContiguousArray<Element>()
    var iterator = self.makeIterator()
    while let element = iterator.next() {
      if try isIncluded(element) {
        result.append(element)
      }
    }
    return Array(result)
  }
  @inlinable
  public var underestimatedCount: Int {
    return 0
  }
  @inlinable
  @inline(__always)
  public func _customContainsEquatableElement(
    _ element: Iterator.Element
  ) -> Bool? {
    return nil
  }
  @inlinable
  public func forEach(
    _ body: (Element) throws -> Void
  ) rethrows {
    for element in self {
      try body(element)
    }
  }
}
extension Sequence {
  @inlinable
  public func first(
    where predicate: (Element) throws -> Bool
  ) rethrows -> Element? {
    for element in self {
      if try predicate(element) {
        return element
      }
    }
    return nil
  }
}
extension Sequence where Element: Equatable {
  @inlinable
  public __consuming func split(
    separator: Element,
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true
  ) -> [ArraySlice<Element>] {
    return split(
      maxSplits: maxSplits,
      omittingEmptySubsequences: omittingEmptySubsequences,
      whereSeparator: { $0 == separator })
  }
}
extension Sequence {
  @inlinable
  public __consuming func split(
    maxSplits: Int = Int.max,
    omittingEmptySubsequences: Bool = true,
    whereSeparator isSeparator: (Element) throws -> Bool
  ) rethrows -> [ArraySlice<Element>] {
    _precondition(maxSplits >= 0, "Must take zero or more splits")
    let whole = Array(self)
    return try whole.split(
                  maxSplits: maxSplits, 
                  omittingEmptySubsequences: omittingEmptySubsequences, 
                  whereSeparator: isSeparator)
  }
  @inlinable
  public __consuming func suffix(_ maxLength: Int) -> [Element] {
    _precondition(maxLength >= 0, "Can't take a suffix of negative length from a sequence")
    guard maxLength != 0 else { return [] }
    var ringBuffer = ContiguousArray<Element>()
    ringBuffer.reserveCapacity(Swift.min(maxLength, underestimatedCount))
    var i = 0
    for element in self {
      if ringBuffer.count < maxLength {
        ringBuffer.append(element)
      } else {
        ringBuffer[i] = element
        i = (i + 1) % maxLength
      }
    }
    if i != ringBuffer.startIndex {
      var rotated = ContiguousArray<Element>()
      rotated.reserveCapacity(ringBuffer.count)
      rotated += ringBuffer[i..<ringBuffer.endIndex]
      rotated += ringBuffer[0..<i]
      return Array(rotated)
    } else {
      return Array(ringBuffer)
    }
  }
  @inlinable
  public __consuming func dropFirst(_ k: Int = 1) -> DropFirstSequence<Self> {
    return DropFirstSequence(self, dropping: k)
  }
  @inlinable
  public __consuming func dropLast(_ k: Int = 1) -> [Element] {
    _precondition(k >= 0, "Can't drop a negative number of elements from a sequence")
    guard k != 0 else { return Array(self) }
    var result = ContiguousArray<Element>()
    var ringBuffer = ContiguousArray<Element>()
    var i = ringBuffer.startIndex
    for element in self {
      if ringBuffer.count < k {
        ringBuffer.append(element)
      } else {
        result.append(ringBuffer[i])
        ringBuffer[i] = element
        i = (i + 1) % k
      }
    }
    return Array(result)
  }
  @inlinable
  public __consuming func drop(
    while predicate: (Element) throws -> Bool
  ) rethrows -> DropWhileSequence<Self> {
    return try DropWhileSequence(self, predicate: predicate)
  }
  @inlinable
  public __consuming func prefix(_ maxLength: Int) -> PrefixSequence<Self> {
    return PrefixSequence(self, maxLength: maxLength)
  }
  @inlinable
  public __consuming func prefix(
    while predicate: (Element) throws -> Bool
  ) rethrows -> [Element] {
    var result = ContiguousArray<Element>()
    for element in self {
      guard try predicate(element) else {
        break
      }
      result.append(element)
    }
    return Array(result)
  }
}
extension Sequence {
  @inlinable
  public __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    return _copySequenceContents(initializing: buffer)
  }
  internal __consuming func _copySequenceContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    var it = self.makeIterator()
    guard var ptr = buffer.baseAddress else { return (it, buffer.startIndex) }
    for idx in buffer.indices {
      guard let x = it.next() else {
        return (it, idx)
      }
      ptr.initialize(to: x)
      ptr += 1
    }
    return (it, buffer.endIndex)
  }
  @inlinable
  public func withContiguousStorageIfAvailable<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R? {
    return nil
  }  
}
@frozen
public struct IteratorSequence<Base: IteratorProtocol> {
  @usableFromInline
  internal var _base: Base
  @inlinable
  public init(_ base: Base) {
    _base = base
  }
}
extension IteratorSequence: IteratorProtocol, Sequence {
  @inlinable
  public mutating func next() -> Base.Element? {
    return _base.next()
  }
}
extension IteratorSequence: Sendable where Base: Sendable { }
/* FIXME: ideally for compatibility we would declare
extension Sequence {
  @available(swift, deprecated: 5, message: "")
  public typealias SubSequence = AnySequence<Element>
}
*/
