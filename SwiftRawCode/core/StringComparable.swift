import SwiftShims
extension StringProtocol {
  @inlinable
  public static func == <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return _stringCompare(
      lhs._wholeGuts, lhs._offsetRange,
      rhs._wholeGuts, rhs._offsetRange,
      expecting: .equal)
  }
  @inlinable @inline(__always) 
  public static func != <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return !(lhs == rhs)
  }
  @inlinable
  public static func < <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return _stringCompare(
      lhs._wholeGuts, lhs._offsetRange,
      rhs._wholeGuts, rhs._offsetRange,
      expecting: .less)
  }
  @inlinable @inline(__always) 
  public static func > <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return rhs < lhs
  }
  @inlinable @inline(__always) 
  public static func <= <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return !(rhs < lhs)
  }
  @inlinable @inline(__always) 
  public static func >= <RHS: StringProtocol>(lhs: Self, rhs: RHS) -> Bool {
    return !(lhs < rhs)
  }
}
extension String: Equatable {
  @inlinable @inline(__always) 
  public static func == (lhs: String, rhs: String) -> Bool {
    return _stringCompare(lhs._guts, rhs._guts, expecting: .equal)
  }
}
extension String: Comparable {
  @inlinable @inline(__always) 
  public static func < (lhs: String, rhs: String) -> Bool {
    return _stringCompare(lhs._guts, rhs._guts, expecting: .less)
  }
}
extension Substring: Equatable {}
extension String {
  @inline(__always)
  public static func ~= (lhs: String, rhs: Substring) -> Bool {
    return lhs == rhs
  }
}
extension Substring {
  @inline(__always)
  public static func ~= (lhs: Substring, rhs: String) -> Bool {
    return lhs == rhs
  }
}
