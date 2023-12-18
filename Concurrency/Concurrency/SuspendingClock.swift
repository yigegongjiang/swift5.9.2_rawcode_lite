import Swift
@available(SwiftStdlib 5.7, *)
public struct SuspendingClock {
  public struct Instant: Codable, Sendable {
    internal var _value: Swift.Duration
    internal init(_value: Swift.Duration) {
      self._value = _value
    }
  }
  public init() { }
}
@available(SwiftStdlib 5.7, *)
extension Clock where Self == SuspendingClock {
  @available(SwiftStdlib 5.7, *)
  public static var suspending: SuspendingClock { return SuspendingClock() }
}
@available(SwiftStdlib 5.7, *)
extension SuspendingClock: Clock {
  @available(SwiftStdlib 5.7, *)
  public var now: SuspendingClock.Instant {
    SuspendingClock.now
  }
  @available(SwiftStdlib 5.7, *)
  public static var now: SuspendingClock.Instant {
    var seconds = Int64(0)
    var nanoseconds = Int64(0)
    _getTime(
      seconds: &seconds,
      nanoseconds: &nanoseconds,
      clock: _ClockID.suspending.rawValue)
    return SuspendingClock.Instant(_value:
      .seconds(seconds) + .nanoseconds(nanoseconds))
  }
  @available(SwiftStdlib 5.7, *)
  public var minimumResolution: Swift.Duration {
    var seconds = Int64(0)
    var nanoseconds = Int64(0)
    _getClockRes(
      seconds: &seconds,
      nanoseconds: &nanoseconds,
      clock: _ClockID.suspending.rawValue)
    return .seconds(seconds) + .nanoseconds(nanoseconds)
  }
#if !SWIFT_STDLIB_TASK_TO_THREAD_MODEL_CONCURRENCY
  @available(SwiftStdlib 5.7, *)
  public func sleep(
    until deadline: Instant, tolerance: Swift.Duration? = nil
  ) async throws {
    let (seconds, attoseconds) = deadline._value.components
    let nanoseconds = attoseconds / 1_000_000_000
    try await Task._sleep(until:seconds, nanoseconds,
      tolerance: tolerance,
      clock: .suspending)
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
extension SuspendingClock.Instant: InstantProtocol {
  @available(SwiftStdlib 5.7, *)
  public static var now: SuspendingClock.Instant { SuspendingClock().now }
  @available(SwiftStdlib 5.7, *)
  public func advanced(by duration: Swift.Duration) -> SuspendingClock.Instant {
    SuspendingClock.Instant(_value: _value + duration)
  }
  @available(SwiftStdlib 5.7, *)
  public func duration(to other: SuspendingClock.Instant) -> Swift.Duration {
    other._value - _value
  }
  @available(SwiftStdlib 5.7, *)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(_value)
  }
  @available(SwiftStdlib 5.7, *)
  public static func == (
    _ lhs: SuspendingClock.Instant, _ rhs: SuspendingClock.Instant
  ) -> Bool {
    return lhs._value == rhs._value
  }
  @available(SwiftStdlib 5.7, *)
  public static func < (
    _ lhs: SuspendingClock.Instant, _ rhs: SuspendingClock.Instant
  ) -> Bool {
    return lhs._value < rhs._value
  }
  @available(SwiftStdlib 5.7, *)
  public static func + (
    _ lhs: SuspendingClock.Instant, _ rhs: Swift.Duration
  ) -> SuspendingClock.Instant {
    lhs.advanced(by: rhs)
  }
  @available(SwiftStdlib 5.7, *)
  public static func += (
    _ lhs: inout SuspendingClock.Instant, _ rhs: Swift.Duration
  ) {
    lhs = lhs.advanced(by: rhs)
  }
  @available(SwiftStdlib 5.7, *)
  public static func - (
    _ lhs: SuspendingClock.Instant, _ rhs: Swift.Duration
  ) -> SuspendingClock.Instant {
    lhs.advanced(by: .zero - rhs)
  }
  @available(SwiftStdlib 5.7, *)
  public static func -= (
    _ lhs: inout SuspendingClock.Instant, _ rhs: Swift.Duration
  ) {
    lhs = lhs.advanced(by: .zero - rhs)
  }
  @available(SwiftStdlib 5.7, *)
  public static func - (
    _ lhs: SuspendingClock.Instant, _ rhs: SuspendingClock.Instant
  ) -> Swift.Duration {
    rhs.duration(to: lhs)
  }
}
