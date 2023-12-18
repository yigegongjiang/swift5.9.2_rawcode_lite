extension BinaryFloatingPoint where Self.RawSignificand: FixedWidthInteger {
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: Range<Self>,
    using generator: inout T
  ) -> Self {
    _precondition(
      !range.isEmpty,
      "Can't get random value with an empty range"
    )
    let delta = range.upperBound - range.lowerBound
    _precondition(
      delta.isFinite,
      "There is no uniform distribution on an infinite range"
    )
    let rand: Self.RawSignificand
    if Self.RawSignificand.bitWidth == Self.significandBitCount + 1 {
      rand = generator.next()
    } else {
      let significandCount = Self.significandBitCount + 1
      let maxSignificand: Self.RawSignificand = 1 << significandCount
      rand = generator.next() & (maxSignificand - 1)
    }
    let unitRandom = Self.init(rand) * (Self.ulpOfOne / 2)
    let randFloat = delta * unitRandom + range.lowerBound
    if randFloat == range.upperBound {
      return Self.random(in: range, using: &generator)
    }
    return randFloat
  }
  @inlinable
  public static func random(in range: Range<Self>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
  @inlinable
  public static func random<T: RandomNumberGenerator>(
    in range: ClosedRange<Self>,
    using generator: inout T
  ) -> Self {
    _precondition(
      !range.isEmpty,
      "Can't get random value with an empty range"
    )
    let delta = range.upperBound - range.lowerBound
    _precondition(
      delta.isFinite,
      "There is no uniform distribution on an infinite range"
    )
    let rand: Self.RawSignificand
    if Self.RawSignificand.bitWidth == Self.significandBitCount + 1 {
      rand = generator.next()
      let tmp: UInt8 = generator.next() & 1
      if rand == Self.RawSignificand.max && tmp == 1 {
        return range.upperBound
      }
    } else {
      let significandCount = Self.significandBitCount + 1
      let maxSignificand: Self.RawSignificand = 1 << significandCount
      rand = generator.next(upperBound: maxSignificand + 1)
      if rand == maxSignificand {
        return range.upperBound
      }
    }
    let unitRandom = Self.init(rand) * (Self.ulpOfOne / 2)
    let randFloat = delta * unitRandom + range.lowerBound
    return randFloat
  }
  @inlinable
  public static func random(in range: ClosedRange<Self>) -> Self {
    var g = SystemRandomNumberGenerator()
    return Self.random(in: range, using: &g)
  }
}
