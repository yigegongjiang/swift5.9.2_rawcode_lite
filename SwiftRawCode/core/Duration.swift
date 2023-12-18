@available(SwiftStdlib 5.7, *)
@frozen
public struct Duration: Sendable {
  @usableFromInline
  internal var _low: UInt64
  @usableFromInline
  internal var _high: Int64
  @inlinable
  internal init(_high: Int64, low: UInt64) {
    self._low = low
    self._high = _high
  }
  internal init(_attoseconds: _Int128) {
    self.init(_high: _attoseconds.high, low: _attoseconds.low)
  }
  public init(secondsComponent: Int64, attosecondsComponent: Int64) {
    self = Duration.seconds(secondsComponent) +
           Duration(_attoseconds: _Int128(attosecondsComponent))
  }
  internal var _attoseconds: _Int128 {
    _Int128(high: _high, low: _low)
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration {
  @available(SwiftStdlib 5.7, *)
  public var components: (seconds: Int64, attoseconds: Int64) {
    let (seconds, attoseconds) = _attoseconds.dividedBy1e18()
    return (Int64(seconds), Int64(attoseconds))
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration {
  @available(SwiftStdlib 5.7, *)
  public static func seconds<T: BinaryInteger>(_ seconds: T) -> Duration {
    return Duration(_attoseconds:
      _Int128(seconds).multiplied(by: 1_000_000_000_000_000_000 as UInt64))
  }
  internal init(_ duration: Double, scale: UInt64) {
    let integralPart = duration.rounded(.towardZero)
    let fractionalPart = duration - integralPart
    self.init(_attoseconds:
      _Int128(integralPart).multiplied(by: scale) +
      _Int128((fractionalPart * Double(scale)).rounded())
    )
  }
  @available(SwiftStdlib 5.7, *)
  public static func seconds(_ seconds: Double) -> Duration {
    Duration(seconds, scale: 1_000_000_000_000_000_000)
  }
  @available(SwiftStdlib 5.7, *)
  public static func milliseconds<T: BinaryInteger>(
    _ milliseconds: T
  ) -> Duration {
    return Duration(_attoseconds:
      _Int128(milliseconds).multiplied(by: 1_000_000_000_000_000 as UInt64))
  }
  @available(SwiftStdlib 5.7, *)
  public static func milliseconds(_ milliseconds: Double) -> Duration {
    Duration(milliseconds, scale: 1_000_000_000_000_000)
  }
  @available(SwiftStdlib 5.7, *)
  public static func microseconds<T: BinaryInteger>(
    _ microseconds: T
  ) -> Duration {
    return Duration(_attoseconds:
      _Int128(microseconds).multiplied(by: 1_000_000_000_000 as UInt64))
  }
  @available(SwiftStdlib 5.7, *)
  public static func microseconds(_ microseconds: Double) -> Duration {
    Duration(microseconds, scale: 1_000_000_000_000)
  }
  @available(SwiftStdlib 5.7, *)
  public static func nanoseconds<T: BinaryInteger>(
    _ nanoseconds: T
  ) -> Duration {
    return Duration(_attoseconds:
      _Int128(nanoseconds).multiplied(by: 1_000_000_000))
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: Codable {
  @available(SwiftStdlib 5.7, *)
  public init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    let high = try container.decode(Int64.self)
    let low = try container.decode(UInt64.self)
    self.init(_high: high, low: low)
  }
  @available(SwiftStdlib 5.7, *)
  public func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(_high)
    try container.encode(_low)
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: Hashable {
  @available(SwiftStdlib 5.7, *)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(_attoseconds)
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: Equatable {
  @available(SwiftStdlib 5.7, *)
  public static func == (_ lhs: Duration, _ rhs: Duration) -> Bool {
    return lhs._attoseconds == rhs._attoseconds
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: Comparable {
  @available(SwiftStdlib 5.7, *)
  public static func < (_ lhs: Duration, _ rhs: Duration) -> Bool {
    return lhs._attoseconds < rhs._attoseconds
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: AdditiveArithmetic {
  @available(SwiftStdlib 5.7, *)
  public static var zero: Duration { Duration(_attoseconds: 0) }
  @available(SwiftStdlib 5.7, *)
  public static func + (_ lhs: Duration, _ rhs: Duration) -> Duration {
    return Duration(_attoseconds: lhs._attoseconds + rhs._attoseconds)
  }
  @available(SwiftStdlib 5.7, *)
  public static func - (_ lhs: Duration, _ rhs: Duration) -> Duration {
    return Duration(_attoseconds: lhs._attoseconds - rhs._attoseconds)
  }
  @available(SwiftStdlib 5.7, *)
  public static func += (_ lhs: inout Duration, _ rhs: Duration) {
    lhs = lhs + rhs
  }
  @available(SwiftStdlib 5.7, *)
  public static func -= (_ lhs: inout Duration, _ rhs: Duration) {
    lhs = lhs - rhs
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration {
  @available(SwiftStdlib 5.7, *)
  public static func / (_ lhs: Duration, _ rhs: Double) -> Duration {
    return Duration(_attoseconds:
      _Int128(Double(lhs._attoseconds) / rhs))
  }
  @available(SwiftStdlib 5.7, *)
  public static func /= (_ lhs: inout Duration, _ rhs: Double) {
    lhs = lhs / rhs
  }
  @available(SwiftStdlib 5.7, *)
  public static func / <T: BinaryInteger>(
    _ lhs: Duration, _ rhs: T
  ) -> Duration {
    Duration(_attoseconds: lhs._attoseconds / _Int128(rhs))
  }
  @available(SwiftStdlib 5.7, *)
  public static func /= <T: BinaryInteger>(_ lhs: inout Duration, _ rhs: T) {
    lhs = lhs / rhs
  }
  @available(SwiftStdlib 5.7, *)
  public static func / (_ lhs: Duration, _ rhs: Duration) -> Double {
    Double(lhs._attoseconds) / Double(rhs._attoseconds)
  }
  @available(SwiftStdlib 5.7, *)
  public static func * (_ lhs: Duration, _ rhs: Double) -> Duration {
    Duration(_attoseconds: _Int128(Double(lhs._attoseconds) * rhs))
  }
  @available(SwiftStdlib 5.7, *)
  public static func * <T: BinaryInteger>(
    _ lhs: Duration, _ rhs: T
  ) -> Duration {
    Duration(_attoseconds: lhs._attoseconds * _Int128(rhs))
  }
  @available(SwiftStdlib 5.7, *)
  public static func *= <T: BinaryInteger>(_ lhs: inout Duration, _ rhs: T) {
    lhs = lhs * rhs
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: CustomStringConvertible {
  @available(SwiftStdlib 5.7, *)
  public var description: String {
    return (Double(_attoseconds) / 1e18).description + " seconds"
  }
}
@available(SwiftStdlib 5.7, *)
extension Duration: DurationProtocol { }
