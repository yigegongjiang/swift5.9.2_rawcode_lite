@frozen
public struct StaticString: Sendable {
  @usableFromInline
  internal var _startPtrOrData: Builtin.Word
  @usableFromInline
  internal var _utf8CodeUnitCount: Builtin.Word
  @usableFromInline
  internal var _flags: Builtin.Int8
  public init() {
    self = ""
  }
  internal init(
    _start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
  ) {
    self._startPtrOrData = Builtin.ptrtoint_Word(_start)
    self._utf8CodeUnitCount = utf8CodeUnitCount
    self._flags = Bool(isASCII)
      ? (0x2 as UInt8)._value
      : (0x0 as UInt8)._value
  }
  internal init(
    unicodeScalar: Builtin.Int32
  ) {
    self._startPtrOrData = UInt(UInt32(unicodeScalar))._builtinWordValue
    self._utf8CodeUnitCount = 0._builtinWordValue
    self._flags = Unicode.Scalar(_builtinUnicodeScalarLiteral: unicodeScalar).isASCII
      ? (0x3 as UInt8)._value
      : (0x1 as UInt8)._value
  }
  public var utf8Start: UnsafePointer<UInt8> {
    _precondition(
      hasPointerRepresentation,
      "StaticString should have pointer representation")
    return UnsafePointer(bitPattern: UInt(_startPtrOrData))!
  }
  public var unicodeScalar: Unicode.Scalar {
    _precondition(
      !hasPointerRepresentation,
      "StaticString should have Unicode scalar representation")
    return Unicode.Scalar(UInt32(UInt(_startPtrOrData)))!
  }
  public var utf8CodeUnitCount: Int {
    _precondition(
      hasPointerRepresentation,
      "StaticString should have pointer representation")
    return Int(_utf8CodeUnitCount)
  }
  internal var unsafeRawPointer: Builtin.RawPointer {
    return Builtin.inttoptr_Word(_startPtrOrData)
  }
  public var hasPointerRepresentation: Bool {
    return (UInt8(_flags) & 0x1) == 0
  }
  public var isASCII: Bool {
    return (UInt8(_flags) & 0x2) != 0
  }
  public func withUTF8Buffer<R>(
    _ body: (UnsafeBufferPointer<UInt8>) -> R
  ) -> R {
    if hasPointerRepresentation {
      return body(UnsafeBufferPointer(
        start: utf8Start, count: utf8CodeUnitCount))
    } else {
      return unicodeScalar.withUTF8CodeUnits { body($0) }
    }
  }
}
extension StaticString: _ExpressibleByBuiltinUnicodeScalarLiteral {
  public init(_builtinUnicodeScalarLiteral value: Builtin.Int32) {
    self = StaticString(unicodeScalar: value)
  }
}
extension StaticString: ExpressibleByUnicodeScalarLiteral {
  public init(unicodeScalarLiteral value: StaticString) {
    self = value
  }
}
extension StaticString: _ExpressibleByBuiltinExtendedGraphemeClusterLiteral {
  public init(
    _builtinExtendedGraphemeClusterLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
  ) {
    self = StaticString(
      _builtinStringLiteral: start,
      utf8CodeUnitCount: utf8CodeUnitCount,
      isASCII: isASCII
    )
  }
}
extension StaticString: ExpressibleByExtendedGraphemeClusterLiteral {
  public init(extendedGraphemeClusterLiteral value: StaticString) {
    self = value
  }
}
extension StaticString: _ExpressibleByBuiltinStringLiteral {
  public init(
    _builtinStringLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
  ) {
    self = StaticString(
      _start: start,
      utf8CodeUnitCount: utf8CodeUnitCount,
      isASCII: isASCII)
  }
}
extension StaticString: ExpressibleByStringLiteral {
  public init(stringLiteral value: StaticString) {
    self = value
  }
}
extension StaticString: CustomStringConvertible {
  public var description: String {
    return withUTF8Buffer { String._uncheckedFromUTF8($0) }
  }
}
extension StaticString: CustomDebugStringConvertible {
  public var debugDescription: String {
    return self.description.debugDescription
  }
}
#if SWIFT_ENABLE_REFLECTION
extension StaticString: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(reflecting: description)
  }
}
#endif
