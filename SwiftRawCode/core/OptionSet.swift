public protocol OptionSet: SetAlgebra, RawRepresentable {
  associatedtype Element = Self
  init(rawValue: RawValue)
}
extension OptionSet {
  @inlinable 
  public func union(_ other: Self) -> Self {
    var r: Self = Self(rawValue: self.rawValue)
    r.formUnion(other)
    return r
  }
  @inlinable 
  public func intersection(_ other: Self) -> Self {
    var r = Self(rawValue: self.rawValue)
    r.formIntersection(other)
    return r
  }
  @inlinable 
  public func symmetricDifference(_ other: Self) -> Self {
    var r = Self(rawValue: self.rawValue)
    r.formSymmetricDifference(other)
    return r
  }
}
extension OptionSet where Element == Self {
  @inlinable 
  public func contains(_ member: Self) -> Bool {
    return self.isSuperset(of: member)
  }
  @inlinable 
  @discardableResult
  public mutating func insert(
    _ newMember: Element
  ) -> (inserted: Bool, memberAfterInsert: Element) {
    let oldMember = self.intersection(newMember)
    let shouldInsert = oldMember != newMember
    let result = (
      inserted: shouldInsert,
      memberAfterInsert: shouldInsert ? newMember : oldMember)
    if shouldInsert {
      self.formUnion(newMember)
    }
    return result
  }
  @inlinable 
  @discardableResult
  public mutating func remove(_ member: Element) -> Element? {
    let intersectionElements = intersection(member)
    guard !intersectionElements.isEmpty else {
      return nil
    }
    self.subtract(member)
    return intersectionElements
  }
  @inlinable 
  @discardableResult
  public mutating func update(with newMember: Element) -> Element? {
    let r = self.intersection(newMember)
    self.formUnion(newMember)
    return r.isEmpty ? nil : r
  }
}
extension OptionSet where RawValue: FixedWidthInteger {
  @inlinable 
  public init() {
    self.init(rawValue: 0)
  }
  @inlinable 
  public mutating func formUnion(_ other: Self) {
    self = Self(rawValue: self.rawValue | other.rawValue)
  }
  @inlinable 
  public mutating func formIntersection(_ other: Self) {
    self = Self(rawValue: self.rawValue & other.rawValue)
  }
  @inlinable 
  public mutating func formSymmetricDifference(_ other: Self) {
    self = Self(rawValue: self.rawValue ^ other.rawValue)
  }
}
