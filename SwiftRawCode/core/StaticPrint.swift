#if SWIFT_STDLIB_STATIC_PRINT
import SwiftShims
extension String {
  @inlinable
  internal var percentEscapedString: String {
    get {
      return self
        .split(separator: "%", omittingEmptySubsequences: false)
        .joined(separator: "%%")
    }
  }
}
extension ConstantVPrintFInterpolation {
  @inlinable
  public mutating func appendInterpolation(
    _ pointer: @autoclosure @escaping () -> UnsafeRawBufferPointer
  ) {
    appendInterpolation(pointer().baseAddress!)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ pointer: @autoclosure @escaping () -> UnsafeRawPointer
  ) {
    formatString += "%p"
    arguments.append(pointer)
  }
}
@frozen
public struct ConstantVPrintFIntegerFormatting {
  @usableFromInline
  internal var radix: Int
  @usableFromInline
  internal var explicitPositiveSign: Bool
  @usableFromInline
  internal var includePrefix: Bool
  @usableFromInline
  internal var uppercase: Bool
  @usableFromInline
  internal var minDigits: (() -> Int)?
  @usableFromInline
  internal init(
    radix: Int = 10,
    explicitPositiveSign: Bool = false,
    includePrefix: Bool = false,
    uppercase: Bool = false,
    minDigits: (() -> Int)?
  ) {
    self.radix = radix
    self.explicitPositiveSign = explicitPositiveSign
    self.includePrefix = includePrefix
    self.uppercase = uppercase
    self.minDigits = minDigits
  }
  @inlinable
  public static func decimal(
    explicitPositiveSign: Bool = false,
    minDigits: @escaping @autoclosure () -> Int
  ) -> ConstantVPrintFIntegerFormatting {
    return ConstantVPrintFIntegerFormatting(
      radix: 10,
      explicitPositiveSign: explicitPositiveSign,
      minDigits: minDigits)
  }
  @inlinable
  public static func decimal(
    explicitPositiveSign: Bool = false
  ) -> ConstantVPrintFIntegerFormatting {
    return ConstantVPrintFIntegerFormatting(
      radix: 10,
      explicitPositiveSign: explicitPositiveSign,
      minDigits: nil)
  }
  @inlinable
  public static var decimal: ConstantVPrintFIntegerFormatting { .decimal() }
  @inlinable
  public static func hex(
    explicitPositiveSign: Bool = false,
    includePrefix: Bool = false,
    uppercase: Bool = false,
    minDigits: @escaping @autoclosure () -> Int
  ) -> ConstantVPrintFIntegerFormatting {
    return ConstantVPrintFIntegerFormatting(
      radix: 16,
      explicitPositiveSign: explicitPositiveSign,
      includePrefix: includePrefix,
      uppercase: uppercase,
      minDigits: minDigits)
  }
  @inlinable
  public static func hex(
    explicitPositiveSign: Bool = false,
    includePrefix: Bool = false,
    uppercase: Bool = false
  ) -> ConstantVPrintFIntegerFormatting {
    return ConstantVPrintFIntegerFormatting(
      radix: 16,
      explicitPositiveSign: explicitPositiveSign,
      includePrefix: includePrefix,
      uppercase: uppercase,
      minDigits: nil)
  }
  @inlinable
  public static var hex: ConstantVPrintFIntegerFormatting { .hex() }
  @inlinable
  public static func octal(
    explicitPositiveSign: Bool = false,
    includePrefix: Bool = false,
    uppercase: Bool = false,
    minDigits: @autoclosure @escaping () -> Int
  ) -> ConstantVPrintFIntegerFormatting {
    ConstantVPrintFIntegerFormatting(
      radix: 8,
      explicitPositiveSign: explicitPositiveSign,
      includePrefix: includePrefix,
      uppercase: uppercase,
      minDigits: minDigits)
  }
  @inlinable
  public static func octal(
    explicitPositiveSign: Bool = false,
    includePrefix: Bool = false,
    uppercase: Bool = false
  ) -> ConstantVPrintFIntegerFormatting {
    ConstantVPrintFIntegerFormatting(
      radix: 8,
      explicitPositiveSign: explicitPositiveSign,
      includePrefix: includePrefix,
      uppercase: uppercase,
      minDigits: nil)
  }
  @inlinable
  public static var octal: ConstantVPrintFIntegerFormatting { .octal() }
}
extension ConstantVPrintFIntegerFormatting {
  @inlinable
  internal var _prefix: String {
    guard includePrefix else { return "" }
    switch radix {
    case 2: return "0b"
    case 8: return "0o"
    case 16: return "0x"
    default: return ""
    }
  }
}
extension ConstantVPrintFIntegerFormatting {
  @inlinable
  internal static func formatSpecifierLengthModifier<I: FixedWidthInteger>(
    _ type: I.Type
  ) -> String? {
    switch type {
    case is CChar.Type: return "hh"
    case is CUnsignedChar.Type: return "hh"
    case is CShort.Type: return "h"
    case is CUnsignedShort.Type: return "h"
    case is CInt.Type: return ""
    case is CUnsignedInt.Type: return ""
    case is CLong.Type: return "l"
    case is CUnsignedLong.Type: return "l"
    case is CLongLong.Type: return "ll"
    case is CUnsignedLongLong.Type: return "ll"
    default: return nil
    }
  }
  internal func formatSpecifier<I: FixedWidthInteger>(
    for type: I.Type,
    attributes: String
  ) -> String {
    if (type.isSigned && radix != 10) {
      fatalError("Signed integers must be formatted using .decimal")
    }
    var specification = _prefix
    specification += "%"
    if explicitPositiveSign {
      if type.isSigned {
        specification += "+"
      } else {
        var newSpecification = "+"
        newSpecification += specification
        specification = newSpecification
      }
    }
    if let _ = minDigits {
      specification += ".*"
    }
    guard let lengthModifier =
      ConstantVPrintFIntegerFormatting.formatSpecifierLengthModifier(type) else {
      fatalError("Integer type has unknown byte length")
    }
    specification += lengthModifier
    switch radix {
    case 10:
      specification += type.isSigned ? "d" : "u"
    case 8:
      specification += "o"
    case 16:
      specification += uppercase ? "X" : "x"
    default:
      fatalError("radix must be 10, 8 or 16")
    }
    return specification
  }
}
@frozen
@usableFromInline
internal struct ConstantVPrintFArguments {
  @usableFromInline
  internal var argumentClosures: [(([Int]) -> ()) -> ()]
  @inlinable
  internal init() {
    argumentClosures = []
  }
}
extension ConstantVPrintFInterpolation {
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> Int,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> Int8,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> Int16,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> Int32,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> Int64,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> UInt,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> UInt8,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> UInt16,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> UInt32,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ number: @autoclosure @escaping () -> UInt64,
    format: ConstantVPrintFIntegerFormatting = .decimal
  ) {
    appendInteger(number, format: format)
  }
  public mutating func appendInterpolation<T: FixedWidthInteger>(
    _ number: @autoclosure @escaping () -> T,
    format: ConstantVPrintFIntegerFormatting = .decimal,
    attributes: String
  ) {
    appendInteger(number, format: format, attributes: attributes)
  }
  internal mutating func appendInteger<T>(
    _ number: @escaping () -> T,
    format: ConstantVPrintFIntegerFormatting,
    attributes: String = ""
  ) where T: FixedWidthInteger {
    formatString += format.formatSpecifier(for: T.self,  attributes: attributes)
    arguments.append(number)
  }
}
@frozen
public struct ConstantVPrintFInterpolation : StringInterpolationProtocol {
  @usableFromInline
  internal var formatString: String
  @usableFromInline
  internal var arguments: ConstantVPrintFArguments
  @inlinable
  public init(literalCapacity: Int, interpolationCount: Int) {
    formatString = ""
    arguments = ConstantVPrintFArguments()
  }
  @inlinable
  public mutating func appendLiteral(_ literal: String) {
    formatString += literal.percentEscapedString
  }
}
extension ConstantVPrintFInterpolation {
  public mutating func appendInterpolation(
    _ argumentString: @autoclosure @escaping () -> String
  ) {
    formatString += "%s"
    arguments.append(argumentString)
  }
}
extension ConstantVPrintFInterpolation {
  public mutating func appendInterpolation<T : CustomStringConvertible>(
    _ value: @autoclosure @escaping () -> T
  ) {
    appendInterpolation(value().description)
  }
  @inlinable
  public mutating func appendInterpolation(
    _ value: @autoclosure @escaping () -> Any.Type
  ) {
    appendInterpolation(_typeName(value(), qualified: false))
  }
}
extension UnsafeRawPointer: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
extension ConstantVPrintFArguments {
  @inlinable
  internal mutating func append(_ value: @escaping () -> UnsafeRawPointer) {
    argumentClosures.append({ continuation in
      continuation(value()._cVarArgEncoding)
    })
  }
}
extension ConstantVPrintFArguments {
  @inlinable
  internal mutating func append(_ value: @escaping () -> String) {
    argumentClosures.append({ continuation in
      value().withCString { str in
        continuation(str._cVarArgEncoding)
      }
    })
  }
}
extension ConstantVPrintFArguments {
  @inlinable
  internal mutating func append<T>(
    _ value: @escaping () -> T
  ) where T: FixedWidthInteger {
    argumentClosures.append({ continuation in
      continuation(_encodeBitsAsWords(value()))
    })
  }
}
public struct ConstantVPrintFMessage :
  ExpressibleByStringInterpolation, ExpressibleByStringLiteral
{
  public let interpolation: ConstantVPrintFInterpolation
  @inlinable
  public init(stringInterpolation: ConstantVPrintFInterpolation) {
    var s = stringInterpolation
    s.appendLiteral("\n")
    self.interpolation = s
  }
  @inlinable
  public init(stringLiteral value: String) {
    var s = ConstantVPrintFInterpolation(
      literalCapacity: 1,
      interpolationCount: 0
    )
    s.appendLiteral(value)
    s.appendLiteral("\n")
    self.interpolation = s
  }
}
internal func constant_vprintf_backend_recurse(
  fmt: UnsafePointer<CChar>,
  argumentClosures: ArraySlice<(([Int]) -> ()) -> ()>,
  args: inout [CVarArg]
) {
  if let closure = argumentClosures.first {
    closure { newArg in
      args.append(contentsOf: newArg)
      constant_vprintf_backend_recurse(
        fmt: fmt,
        argumentClosures: argumentClosures.dropFirst(),
        args: &args
      )
    }
  } else {
    _ = withVaList(args) { valist in
      _swift_stdlib_vprintf(fmt, valist)
    }
  }
}
@inline(never) @usableFromInline
internal func constant_vprintf_backend(
  fmt: UnsafePointer<CChar>,
  argumentClosures: [(([Int]) -> ()) -> ()]
) {
  var args:[CVarArg] = []
  if let closure = argumentClosures.first {
    closure { newArg in
      args.append(contentsOf: newArg)
      constant_vprintf_backend_recurse(
        fmt: fmt,
        argumentClosures: argumentClosures.dropFirst(),
        args: &args
      )
    }
  } else {
    constant_vprintf_backend_recurse(
      fmt: fmt,
      argumentClosures: ArraySlice(argumentClosures),
      args: &args
    )
  }
}
@inlinable
public func print(_ message: ConstantVPrintFMessage) {
  let formatString = message.interpolation.formatString
  let argumentClosures = message.interpolation.arguments.argumentClosures
  if Bool(_builtinBooleanLiteral: Builtin.ifdef_SWIFT_STDLIB_PRINT_DISABLED()) { return }
  let formatStringPointer = _getGlobalStringTablePointer(formatString)
  constant_vprintf_backend(
    fmt: formatStringPointer,
    argumentClosures: argumentClosures
  )
}
#endif
