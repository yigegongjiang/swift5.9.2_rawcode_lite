@available(SwiftStdlib 5.8, *)
@frozen
public struct StaticBigInt:
  _ExpressibleByBuiltinIntegerLiteral,
  ExpressibleByIntegerLiteral,
  Sendable
{
  @available(SwiftStdlib 5.8, *)
  @usableFromInline
  internal let _value: Builtin.IntLiteral
  @available(SwiftStdlib 5.8, *)
  @inlinable
  public init(_builtinIntegerLiteral value: Builtin.IntLiteral) {
    _value = value
  }
}
@available(SwiftStdlib 5.8, *)
extension StaticBigInt {
  @available(SwiftStdlib 5.8, *)
  @inlinable
  public func signum() -> Int {
    _isNegative ? -1 : (bitWidth == 1) ? 0 : +1
  }
  @available(SwiftStdlib 5.8, *)
  @inlinable
  internal var _isNegative: Bool {
#if compiler(>=5.8) && $BuiltinIntLiteralAccessors
    Bool(Builtin.isNegative_IntLiteral(_value))
#else
    fatalError("Swift compiler is incompatible with this SDK version")
#endif
  }
  @available(SwiftStdlib 5.8, *)
  @inlinable
  public var bitWidth: Int {
#if compiler(>=5.8) && $BuiltinIntLiteralAccessors
    Int(Builtin.bitWidth_IntLiteral(_value))
#else
    fatalError("Swift compiler is incompatible with this SDK version")
#endif
  }
  @available(SwiftStdlib 5.8, *)
  @inlinable
  public subscript(_ wordIndex: Int) -> UInt {
    _precondition(wordIndex >= 0, "Negative word index")
    let bitIndex = wordIndex.multipliedReportingOverflow(by: UInt.bitWidth)
    guard !bitIndex.overflow, bitIndex.partialValue < bitWidth else {
      return _isNegative ? ~0 : 0
    }
#if compiler(>=5.8) && $BuiltinIntLiteralAccessors
    return UInt(
      Builtin.wordAtIndex_IntLiteral(_value, wordIndex._builtinWordValue)
    )
#else
    fatalError("Swift compiler is incompatible with this SDK version")
#endif
  }
}
@available(SwiftStdlib 5.8, *)
extension StaticBigInt: CustomDebugStringConvertible {
  @available(SwiftStdlib 5.8, *)
  public var debugDescription: String {
    let isNegative = _isNegative
    let indicator = isNegative ? "-0x" : "+0x"
    let capacity = indicator.utf8.count + (((bitWidth - 1) + 3) / 4)
    var result = String(unsafeUninitializedCapacity: capacity) { utf8 in
      var utf8 = utf8.prefix(capacity)
      utf8.initialize(repeating: UInt8(ascii: "0"))
      typealias Element = UInt32
      let hexDigitsPerElement = Element.bitWidth / 4
      _internalInvariant(hexDigitsPerElement <= _SmallString.capacity)
      _internalInvariant(UInt.bitWidth.isMultiple(of: Element.bitWidth))
      var overflow = isNegative
      for bitIndex in stride(from: 0, to: bitWidth, by: Element.bitWidth) {
        let wordIndex = bitIndex >> UInt.bitWidth.trailingZeroBitCount
        var element = Element(_truncatingBits: self[wordIndex] &>> bitIndex)
        if isNegative {
          element = ~element
          if overflow {
            (element, overflow) = element.addingReportingOverflow(1)
          }
        }
        let hexDigits = String(element, radix: 16, uppercase: true).utf8
        _ = utf8.suffix(hexDigits.count).update(fromContentsOf: hexDigits)
        utf8 = utf8.dropLast(hexDigitsPerElement)
      }
      return capacity
    }
    if let upToIndex = result.firstIndex(where: { $0 != "0" }) {
      result.replaceSubrange(..<upToIndex, with: indicator)
    } else {
      result = "+0x0"
    }
    return result
  }
}
#if SWIFT_ENABLE_REFLECTION
@available(SwiftStdlib 5.8, *)
extension StaticBigInt: CustomReflectable {
  @available(SwiftStdlib 5.8, *)
  public var customMirror: Mirror {
    Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
#endif
