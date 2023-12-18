public protocol SetAlgebra<Element>: Equatable, ExpressibleByArrayLiteral {
  associatedtype Element
  init()
  func contains(_ member: Element) -> Bool
  __consuming func union(_ other: __owned Self) -> Self
  __consuming func intersection(_ other: Self) -> Self
  __consuming func symmetricDifference(_ other: __owned Self) -> Self
  @discardableResult
  mutating func insert(
    _ newMember: __owned Element
  ) -> (inserted: Bool, memberAfterInsert: Element)
  @discardableResult
  mutating func remove(_ member: Element) -> Element?
  @discardableResult
  mutating func update(with newMember: __owned Element) -> Element?
  mutating func formUnion(_ other: __owned Self)
  mutating func formIntersection(_ other: Self)
  mutating func formSymmetricDifference(_ other: __owned Self)
  __consuming func subtracting(_ other: Self) -> Self
  func isSubset(of other: Self) -> Bool
  func isDisjoint(with other: Self) -> Bool
  func isSuperset(of other: Self) -> Bool
  var isEmpty: Bool { get }
  init<S: Sequence>(_ sequence: __owned S) where S.Element == Element
  mutating func subtract(_ other: Self)
}
extension SetAlgebra {
  @inlinable 
  public init<S: Sequence>(_ sequence: __owned S)
    where S.Element == Element {
    self.init()
    _onFastPath()
    for e in sequence { insert(e) }
  }
  @inlinable 
  public mutating func subtract(_ other: Self) {
    self.formIntersection(self.symmetricDifference(other))
  }
  @inlinable 
  public func isSubset(of other: Self) -> Bool {
    return self.intersection(other) == self
  }
  @inlinable 
  public func isSuperset(of other: Self) -> Bool {
    return other.isSubset(of: self)
  }
  @inlinable 
  public func isDisjoint(with other: Self) -> Bool {
    return self.intersection(other).isEmpty
  }
  @inlinable 
  public func subtracting(_ other: Self) -> Self {
    return self.intersection(self.symmetricDifference(other))
  }
  @inlinable 
  public var isEmpty: Bool {
    return self == Self()
  }
  @inlinable 
  public func isStrictSuperset(of other: Self) -> Bool {
    return self.isSuperset(of: other) && self != other
  }
  @inlinable 
  public func isStrictSubset(of other: Self) -> Bool {
    return other.isStrictSuperset(of: self)
  }
}
extension SetAlgebra where Element == ArrayLiteralElement {
  @inlinable 
  public init(arrayLiteral: Element...) {
    self.init(arrayLiteral)
  }  
}
