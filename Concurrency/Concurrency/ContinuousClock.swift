import Swift
@available(SwiftStdlib 5.7, *)
public struct ContinuousClock {
  public struct Instant: Codable, Sendable {
    internal var _value: Swift.Duration
    internal init(_value: Swift.Duration) {
      self._value = _value
    }
  }
  public init() { }
}
@available(SwiftStdlib 5.7, *)
extension Clock where Self == ContinuousClock {
  @available(SwiftStdlib 5.7, *)
  public static var continuous: ContinuousClock { return ContinuousClock() }
}
@available(SwiftStdlib 5.7, *)
extension ContinuousClock: Clock {
  public var now: ContinuousClock.Instant {
    ContinuousClock.now
  }
  public var minimumResolution: Swift.Duration {
    var seconds = Int64(0)
    var nanoseconds = Int64(0)
    _getClockRes(
      seconds: &seconds,
      nanoseconds: &nanoseconds,
      clock: _ClockID.continuous.rawValue)
    return .seconds(seconds) + .nanoseconds(nanoseconds)
  }
  public static var now: ContinuousClock.Instant {
    var seconds = Int64(0)
    var nanoseconds = Int64(0)
    _getTime(
      seconds: &seconds,
      nanoseconds: &nanoseconds,
      clock: _ClockID.continuous.rawValue)
    return ContinuousClock.Instant(_value:
      .seconds(seconds) + .nanoseconds(nanoseconds))
  }
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  public func sleep(
    until deadline: Instant, tolerance: Swift.Duration? = nil
  ) async throws {
    let (seconds, attoseconds) = deadline._value.components
    let nanoseconds = attoseconds / 1_000_000_000
    try await Task._sleep(until:seconds, nanoseconds,
      tolerance: tolerance,
      clock: .continuous)
  }
#else
  @available(SwiftStdlib 5.7, *)
  @available(*, unavailable, message: "Unavailable in task-to-thread concurrency model")
  public func sleep(
    until deadline: Instant, tolerance: Swift.Duration? = nil
  ) async throws {
      fatalError("Unavailable in task-to-thread concurrency model")
  }
#endif
}
@available(SwiftStdlib 5.7, *)
extension ContinuousClock.Instant: InstantProtocol {
  public static var now: ContinuousClock.Instant { ContinuousClock.now }
  public func advanced(by duration: Swift.Duration) -> ContinuousClock.Instant {
    return ContinuousClock.Instant(_value: _value + duration)
  }
  public func duration(to other: ContinuousClock.Instant) -> Swift.Duration {
    other._value - _value
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(_value)
  }
  public static func == (
    _ lhs: ContinuousClock.Instant, _ rhs: ContinuousClock.Instant
  ) -> Bool {
    return lhs._value == rhs._value
  }
  public static func < (
    _ lhs: ContinuousClock.Instant, _ rhs: ContinuousClock.Instant
  ) -> Bool {
    return lhs._value < rhs._value
  }
  @inlinable
  public static func + (
    _ lhs: ContinuousClock.Instant, _ rhs: Swift.Duration
  ) -> ContinuousClock.Instant {
    lhs.advanced(by: rhs)
  }
  @inlinable
  public static func += (
    _ lhs: inout ContinuousClock.Instant, _ rhs: Swift.Duration
  ) {
    lhs = lhs.advanced(by: rhs)
  }
  @inlinable
  public static func - (
    _ lhs: ContinuousClock.Instant, _ rhs: Swift.Duration
  ) -> ContinuousClock.Instant {
    lhs.advanced(by: .zero - rhs)
  }
  @inlinable
  public static func -= (
    _ lhs: inout ContinuousClock.Instant, _ rhs: Swift.Duration
  ) {
    lhs = lhs.advanced(by: .zero - rhs)
  }
  @inlinable
  public static func - (
    _ lhs: ContinuousClock.Instant, _ rhs: ContinuousClock.Instant
  ) -> Swift.Duration {
    rhs.duration(to: lhs)
  }
}
