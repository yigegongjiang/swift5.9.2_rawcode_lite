import SwiftShims
@frozen
public enum UnicodeDecodingResult: Equatable, Sendable {
  case scalarValue(Unicode.Scalar)
  case emptyInput
  case error
  @inlinable
  public static func == (
    lhs: UnicodeDecodingResult,
    rhs: UnicodeDecodingResult
  ) -> Bool {
    switch (lhs, rhs) {
    case (.scalarValue(let lhsScalar), .scalarValue(let rhsScalar)):
      return lhsScalar == rhsScalar
    case (.emptyInput, .emptyInput):
      return true
    case (.error, .error):
      return true
    default:
      return false
    }
  }
}
public protocol UnicodeCodec: Unicode.Encoding {
  init()
  mutating func decode<I: IteratorProtocol>(
    _ input: inout I
  ) -> UnicodeDecodingResult where I.Element == CodeUnit
  static func encode(
    _ input: Unicode.Scalar,
    into processCodeUnit: (CodeUnit) -> Void
  )
  static func _nullCodeUnitOffset(in input: UnsafePointer<CodeUnit>) -> Int
}
extension Unicode.UTF8: UnicodeCodec {
  @inlinable
  public init() { self = ._swift3Buffer(ForwardParser()) }
  @inlinable
  @inline(__always)
  public mutating func decode<I: IteratorProtocol>(
    _ input: inout I
  ) -> UnicodeDecodingResult where I.Element == CodeUnit {
    guard case ._swift3Buffer(var parser) = self else {
      Builtin.unreachable()
    }
    defer { self = ._swift3Buffer(parser) }
    switch parser.parseScalar(from: &input) {
    case .valid(let s): return .scalarValue(UTF8.decode(s))
    case .error: return .error
    case .emptyInput: return .emptyInput
    }
  }
  @inlinable
  public 
  static func _decodeOne(_ buffer: UInt32) -> (result: UInt32?, length: UInt8) {
    if buffer & 0x80 == 0 { 
      let value = buffer & 0xff
      return (value, 1)
    }
    var p = ForwardParser()
    p._buffer._storage = buffer
    p._buffer._bitCount = 32
    var i = EmptyCollection<UInt8>().makeIterator()
    switch p.parseScalar(from: &i) {
    case .valid(let s):
      return (
        result: UTF8.decode(s).value,
        length: UInt8(truncatingIfNeeded: s.count))
    case .error(let l):
      return (result: nil, length: UInt8(truncatingIfNeeded: l))
    case .emptyInput: Builtin.unreachable()
    }
  }
  @inlinable
  @inline(__always)
  public static func encode(
    _ input: Unicode.Scalar,
    into processCodeUnit: (CodeUnit) -> Void
  ) {
    var s = encode(input)!._biasedBits
    processCodeUnit(UInt8(truncatingIfNeeded: s) &- 0x01)
    s &>>= 8
    if _fastPath(s == 0) { return }
    processCodeUnit(UInt8(truncatingIfNeeded: s) &- 0x01)
    s &>>= 8
    if _fastPath(s == 0) { return }
    processCodeUnit(UInt8(truncatingIfNeeded: s) &- 0x01)
    s &>>= 8
    if _fastPath(s == 0) { return }
    processCodeUnit(UInt8(truncatingIfNeeded: s) &- 0x01)
  }
  @inlinable
  public static func isContinuation(_ byte: CodeUnit) -> Bool {
    return byte & 0b11_00__0000 == 0b10_00__0000
  }
  @inlinable
  public static func _nullCodeUnitOffset(
    in input: UnsafePointer<CodeUnit>
  ) -> Int {
    return Int(_swift_stdlib_strlen_unsigned(input))
  }
  @inlinable
  public static func _nullCodeUnitOffset(
    in input: UnsafePointer<CChar>
  ) -> Int {
    return Int(_swift_stdlib_strlen(input))
  }
}
extension Unicode.UTF16: UnicodeCodec {
  @inlinable
  public init() { self = ._swift3Buffer(ForwardParser()) }
  @inlinable
  public mutating func decode<I: IteratorProtocol>(
    _ input: inout I
  ) -> UnicodeDecodingResult where I.Element == CodeUnit {
    guard case ._swift3Buffer(var parser) = self else {
      Builtin.unreachable()
    }
    defer { self = ._swift3Buffer(parser) }
    switch parser.parseScalar(from: &input) {
    case .valid(let s): return .scalarValue(UTF16.decode(s))
    case .error: return .error
    case .emptyInput: return .emptyInput
    }
  }
  @inlinable
  internal mutating func _decodeOne<I: IteratorProtocol>(
    _ input: inout I
  ) -> (UnicodeDecodingResult, Int) where I.Element == CodeUnit {
    let result = decode(&input)
    switch result {
    case .scalarValue(let us):
      return (result, UTF16.width(us))
    case .emptyInput:
      return (result, 0)
    case .error:
      return (result, 1)
    }
  }
  @inlinable
  public static func encode(
    _ input: Unicode.Scalar,
    into processCodeUnit: (CodeUnit) -> Void
  ) {
    var s = encode(input)!._storage
    processCodeUnit(UInt16(truncatingIfNeeded: s))
    s &>>= 16
    if _fastPath(s == 0) { return }
    processCodeUnit(UInt16(truncatingIfNeeded: s))
  }
}
extension Unicode.UTF32: UnicodeCodec {
  @inlinable
  public init() { self = ._swift3Codec }
  @inlinable
  public mutating func decode<I: IteratorProtocol>(
    _ input: inout I
  ) -> UnicodeDecodingResult where I.Element == CodeUnit {
    var parser = ForwardParser()
    switch parser.parseScalar(from: &input) {
    case .valid(let s): return .scalarValue(UTF32.decode(s))
    case .error:      return .error
    case .emptyInput:   return .emptyInput
    }
  }
  @inlinable
  public static func encode(
    _ input: Unicode.Scalar,
    into processCodeUnit: (CodeUnit) -> Void
  ) {
    processCodeUnit(UInt32(input))
  }
}
@inlinable
@inline(__always)
public func transcode<
  Input: IteratorProtocol,
  InputEncoding: Unicode.Encoding,
  OutputEncoding: Unicode.Encoding
>(
  _ input: Input,
  from inputEncoding: InputEncoding.Type,
  to outputEncoding: OutputEncoding.Type,
  stoppingOnError stopOnError: Bool,
  into processCodeUnit: (OutputEncoding.CodeUnit) -> Void
) -> Bool
  where InputEncoding.CodeUnit == Input.Element {
  var input = input
  var p = InputEncoding.ForwardParser()
  var hadError = false
  loop:
  while true {
    switch p.parseScalar(from: &input) {
    case .valid(let s):
      let t = OutputEncoding.transcode(s, from: inputEncoding)
      guard _fastPath(t != nil), let s = t else { break }
      s.forEach(processCodeUnit)
      continue loop
    case .emptyInput:
      return hadError
    case .error:
      if _slowPath(stopOnError) { return true }
      hadError = true
    }
    OutputEncoding.encodedReplacementCharacter.forEach(processCodeUnit)
  }
}
public 
protocol _StringElement {
  static func _toUTF16CodeUnit(_: Self) -> UTF16.CodeUnit
  static func _fromUTF16CodeUnit(_ utf16: UTF16.CodeUnit) -> Self
}
extension UTF16.CodeUnit: _StringElement {
  @inlinable
  public 
  static func _toUTF16CodeUnit(_ x: UTF16.CodeUnit) -> UTF16.CodeUnit {
    return x
  }
  @inlinable
  public 
  static func _fromUTF16CodeUnit(
    _ utf16: UTF16.CodeUnit
  ) -> UTF16.CodeUnit {
    return utf16
  }
}
extension UTF8.CodeUnit: _StringElement {
  @inlinable
  public 
  static func _toUTF16CodeUnit(_ x: UTF8.CodeUnit) -> UTF16.CodeUnit {
    _internalInvariant(x <= 0x7f, "should only be doing this with ASCII")
    return UTF16.CodeUnit(truncatingIfNeeded: x)
  }
  @inlinable
  public 
  static func _fromUTF16CodeUnit(
    _ utf16: UTF16.CodeUnit
  ) -> UTF8.CodeUnit {
    _internalInvariant(utf16 <= 0x7f, "should only be doing this with ASCII")
    return UTF8.CodeUnit(truncatingIfNeeded: utf16)
  }
}
extension Unicode.Scalar {
  @inlinable
  internal init(_unchecked value: UInt32) {
    _internalInvariant(value < 0xD800 || value > 0xDFFF,
      "high- and low-surrogate code points are not valid Unicode scalar values")
    _internalInvariant(value <= 0x10FFFF, "value is outside of Unicode codespace")
    self._value = value
  }
}
extension UnicodeCodec {
  @inlinable
  public static func _nullCodeUnitOffset(
    in input: UnsafePointer<CodeUnit>
  ) -> Int {
    var length = 0
    while input[length] != 0 {
      length += 1
    }
    return length
  }
}
@available(*, unavailable, message: "use 'transcode(_:from:to:stoppingOnError:into:)'")
public func transcode<Input, InputEncoding, OutputEncoding>(
  _ inputEncoding: InputEncoding.Type, _ outputEncoding: OutputEncoding.Type,
  _ input: Input, _ output: (OutputEncoding.CodeUnit) -> Void,
  stopOnError: Bool
) -> Bool
  where
  Input: IteratorProtocol,
  InputEncoding: UnicodeCodec,
  OutputEncoding: UnicodeCodec,
  InputEncoding.CodeUnit == Input.Element {
  Builtin.unreachable()
}
@frozen
public enum Unicode {}
