@available(SwiftStdlib 5.7, *)
public protocol DurationProtocol: Comparable, AdditiveArithmetic, Sendable {
  static func / (_ lhs: Self, _ rhs: Int) -> Self
  static func /= (_ lhs: inout Self, _ rhs: Int)
  static func * (_ lhs: Self, _ rhs: Int) -> Self
  static func *= (_ lhs: inout Self, _ rhs: Int)
  static func / (_ lhs: Self, _ rhs: Self) -> Double
}
@available(SwiftStdlib 5.7, *)
extension DurationProtocol {
  @available(SwiftStdlib 5.7, *)
  public static func /= (_ lhs: inout Self, _ rhs: Int) {
    lhs = lhs / rhs
  }
  @available(SwiftStdlib 5.7, *)
  public static func *= (_ lhs: inout Self, _ rhs: Int) {
    lhs = lhs * rhs
  }
}
