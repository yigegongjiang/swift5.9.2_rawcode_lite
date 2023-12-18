import SwiftShims
public protocol RandomNumberGenerator {
  mutating func next() -> UInt64
}
extension RandomNumberGenerator {
  @available(*, unavailable)
  public mutating func next() -> UInt64 { fatalError() }
  @inlinable
  public mutating func next<T: FixedWidthInteger & UnsignedInteger>() -> T {
    return T._random(using: &self)
  }
  @inlinable
  public mutating func next<T: FixedWidthInteger & UnsignedInteger>(
    upperBound: T
  ) -> T {
    _precondition(upperBound != 0, "upperBound cannot be zero.")
    var random: T = next()
    var m = random.multipliedFullWidth(by: upperBound)
    if m.low < upperBound {
      let t = (0 &- upperBound) % upperBound
      while m.low < t {
        random = next()
        m = random.multipliedFullWidth(by: upperBound)
      }
    }
    return m.high
  }
}
@frozen
public struct SystemRandomNumberGenerator: RandomNumberGenerator, Sendable {
  @inlinable
  public init() { }
  @inlinable
  public mutating func next() -> UInt64 {
    var random: UInt64 = 0
    _withUnprotectedUnsafeMutablePointer(to: &random) {
      swift_stdlib_random($0, MemoryLayout<UInt64>.size)
    }
    return random
  }
}
