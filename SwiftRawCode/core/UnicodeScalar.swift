extension Unicode {
  @frozen
  public struct Scalar: Sendable {
    @usableFromInline
    internal var _value: UInt32
    @inlinable
    internal init(_value: UInt32) {
      self._value = _value
    }
  }
}
extension Unicode.Scalar :
    _ExpressibleByBuiltinUnicodeScalarLiteral,
    ExpressibleByUnicodeScalarLiteral {
  @inlinable
  public var value: UInt32 { return _value }
  public init(_builtinUnicodeScalarLiteral value: Builtin.Int32) {
    self._value = UInt32(value)
  }
  public init(unicodeScalarLiteral value: Unicode.Scalar) {
    self = value
  }
  @inlinable
  public init?(_ v: UInt32) {
    if (v < 0xD800 || v > 0xDFFF) && v <= 0x10FFFF {
      self._value = v
      return
    }
    return nil
  }
  @inlinable
  public init?(_ v: UInt16) {
    self.init(UInt32(v))
  }
  @inlinable
  public init(_ v: UInt8) {
    self._value = UInt32(v)
  }
  @inlinable
  public init(_ v: Unicode.Scalar) {
    self = v
  }
  public func escaped(asASCII forceASCII: Bool) -> String {
    _escaped(asASCII: forceASCII) ?? String(self)
  }
  internal func _escaped(asASCII forceASCII: Bool) -> String? {
    func lowNibbleAsHex(_ v: UInt32) -> String {
      let nibble = v & 15
      if nibble < 10 {
        return String(Unicode.Scalar(nibble+48)!)    
      } else {
        return String(Unicode.Scalar(nibble-10+65)!) 
      }
    }
    if self == "\\" {
      return "\\\\"
    } else if self == "\'" {
      return "\\\'"
    } else if self == "\"" {
      return "\\\""
    } else if _isPrintableASCII {
      return nil
    } else if self == "\0" {
      return "\\0"
    } else if self == "\n" {
      return "\\n"
    } else if self == "\r" {
      return "\\r"
    } else if self == "\t" {
      return "\\t"
    } else if UInt32(self) < 128 {
      return "\\u{"
        + lowNibbleAsHex(UInt32(self) >> 4)
        + lowNibbleAsHex(UInt32(self)) + "}"
    } else if !forceASCII {
      return nil
    } else if UInt32(self) <= 0xFFFF {
      var result = "\\u{"
      result += lowNibbleAsHex(UInt32(self) >> 12)
      result += lowNibbleAsHex(UInt32(self) >> 8)
      result += lowNibbleAsHex(UInt32(self) >> 4)
      result += lowNibbleAsHex(UInt32(self))
      result += "}"
      return result
    } else {
      var result = "\\u{"
      result += lowNibbleAsHex(UInt32(self) >> 28)
      result += lowNibbleAsHex(UInt32(self) >> 24)
      result += lowNibbleAsHex(UInt32(self) >> 20)
      result += lowNibbleAsHex(UInt32(self) >> 16)
      result += lowNibbleAsHex(UInt32(self) >> 12)
      result += lowNibbleAsHex(UInt32(self) >> 8)
      result += lowNibbleAsHex(UInt32(self) >> 4)
      result += lowNibbleAsHex(UInt32(self))
      result += "}"
      return result
    }
  }
  @inlinable
  public var isASCII: Bool {
    return value <= 127
  }
  internal var _isPrintableASCII: Bool {
    return (self >= Unicode.Scalar(0o040) && self <= Unicode.Scalar(0o176))
  }
}
extension Unicode.Scalar: CustomStringConvertible, CustomDebugStringConvertible {
  @inlinable
  public var description: String {
    return String(self)
  }
  public var debugDescription: String {
    return "\"\(escaped(asASCII: true))\""
  }
}
extension Unicode.Scalar: LosslessStringConvertible {
  @inlinable
  public init?(_ description: String) {
    let scalars = description.unicodeScalars
    guard let v = scalars.first, scalars.count == 1 else {
      return nil
    }
    self = v
  }
}
extension Unicode.Scalar: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }
}
extension Unicode.Scalar {
  @inlinable
  public init?(_ v: Int) {
    if let exact = UInt32(exactly: v) {
      self.init(exact)
    } else {
      return nil
    }
  }
}
extension UInt8 {
  @inlinable
  public init(ascii v: Unicode.Scalar) {
    _precondition(v.value < 128,
        "Code point value does not fit into ASCII")
    self = UInt8(v.value)
  }
}
extension UInt32 {
  @inlinable
  public init(_ v: Unicode.Scalar) {
    self = v.value
  }
}
extension UInt64 {
  @inlinable
  public init(_ v: Unicode.Scalar) {
    self = UInt64(v.value)
  }
}
extension Unicode.Scalar: Equatable {
  @inlinable
  public static func == (lhs: Unicode.Scalar, rhs: Unicode.Scalar) -> Bool {
    return lhs.value == rhs.value
  }
}
extension Unicode.Scalar: Comparable {
  @inlinable
  public static func < (lhs: Unicode.Scalar, rhs: Unicode.Scalar) -> Bool {
    return lhs.value < rhs.value
  }
}
extension Unicode.Scalar {
  @frozen
  public struct UTF16View: Sendable {
    @usableFromInline
    internal var value: Unicode.Scalar
    @inlinable
    internal init(value: Unicode.Scalar) {
      self.value = value
    }
  }
  @inlinable
  public var utf16: UTF16View {
    return UTF16View(value: self)
  }
}
extension Unicode.Scalar.UTF16View: RandomAccessCollection {
  public typealias Indices = Range<Int>
  @inlinable
  public var startIndex: Int {
    return 0
  }
  @inlinable
  public var endIndex: Int {
    return 0 + UTF16.width(value)
  }
  @inlinable
  public subscript(position: Int) -> UTF16.CodeUnit {
    if position == 1 { return UTF16.trailSurrogate(value) }
    if endIndex == 1 { return UTF16.CodeUnit(value.value) }
    return UTF16.leadSurrogate(value)
  }
}
extension Unicode.Scalar {
  @available(SwiftStdlib 5.1, *)
  @frozen
  public struct UTF8View: Sendable {
    @usableFromInline
    internal var value: Unicode.Scalar
    @inlinable
    internal init(value: Unicode.Scalar) {
      self.value = value
    }
  }
  @available(SwiftStdlib 5.1, *)
  @inlinable
  public var utf8: UTF8View { return UTF8View(value: self) }
}
@available(SwiftStdlib 5.1, *)
extension Unicode.Scalar.UTF8View: RandomAccessCollection {
  public typealias Indices = Range<Int>
  @inlinable
  public var startIndex: Int { return 0 }
  @inlinable
  public var endIndex: Int { return 0 + UTF8.width(value) }
  @inlinable
  public subscript(position: Int) -> UTF8.CodeUnit {
    _precondition(position >= startIndex && position < endIndex,
      "Unicode.Scalar.UTF8View index is out of bounds")
    return value.withUTF8CodeUnits { $0[position] }
  }
}
extension Unicode.Scalar {
  internal static var _replacementCharacter: Unicode.Scalar {
    return Unicode.Scalar(_value: UTF32._replacementCodeUnit)
  }
}
extension Unicode.Scalar {
  @available(*, unavailable, message: "use 'Unicode.Scalar(0)'")
  public init() {
    Builtin.unreachable()
  }
}
extension Unicode.Scalar {
  internal func withUTF16CodeUnits<Result>(
    _ body: (UnsafeBufferPointer<UInt16>) throws -> Result
  ) rethrows -> Result {
    var codeUnits: (UInt16, UInt16) = (self.utf16[0], 0)
    let utf16Count = self.utf16.count
    if utf16Count > 1 {
      _internalInvariant(utf16Count == 2)
      codeUnits.1 = self.utf16[1]
    }
    return try Swift.withUnsafePointer(to: &codeUnits) {
      return try $0.withMemoryRebound(to: UInt16.self, capacity: 2) {
        return try body(UnsafeBufferPointer(start: $0, count: utf16Count))
      }
    }
  }
  @inlinable
  internal func withUTF8CodeUnits<Result>(
    _ body: (UnsafeBufferPointer<UInt8>) throws -> Result
  ) rethrows -> Result {
    let encodedScalar = UTF8.encode(self)!
    var (codeUnits, utf8Count) = encodedScalar._bytes
    codeUnits = codeUnits.littleEndian
    return try Swift._withUnprotectedUnsafePointer(to: &codeUnits) {
      return try $0.withMemoryRebound(to: UInt8.self, capacity: 4) {
        return try body(UnsafeBufferPointer(start: $0, count: utf8Count))
      }
    }
  }
}
