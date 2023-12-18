@available(SwiftStdlib 5.7, *)
public protocol InstantProtocol<Duration>: Comparable, Hashable, Sendable {
  associatedtype Duration: DurationProtocol
  func advanced(by duration: Duration) -> Self
  func duration(to other: Self) -> Duration
}
/*
disabled for now - this perturbs operator resolution
extension InstantProtocol {
  @inlinable
  public static func + (_ lhs: Self, _ rhs: Duration) -> Self {
    lhs.advanced(by: rhs)
  }
  @inlinable
  public static func += (_ lhs: inout Self, _ rhs: Duration) {
    lhs = lhs.advanced(by: rhs)
  }
  @inlinable
  public static func - (_ lhs: Self, _ rhs: Duration) -> Self {
    lhs.advanced(by: .zero - rhs)
  }
  @inlinable
  public static func -= (_ lhs: inout Self, _ rhs: Duration) {
    lhs = lhs.advanced(by: .zero - rhs)
  }
  @inlinable
  public static func - (_ lhs: Self, _ rhs: Self) -> Duration {
    rhs.duration(to: lhs)
  }
}
*/
