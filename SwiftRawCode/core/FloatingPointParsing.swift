// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 1)
//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftShims

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 32)

/// Returns `true` if isspace(u) would return nonzero when the current
/// locale is the C locale; otherwise, returns false.
@inlinable // FIXME(sil-serialize-all)
internal func _isspace_clocale(_ u: UTF16.CodeUnit) -> Bool {
  return "\t\n\u{b}\u{c}\r ".utf16.contains(u)
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 42)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 46)
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 48)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 50)
@available(SwiftStdlib 5.3, *)
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 52)
extension Float16: LosslessStringConvertible {
  /// Creates a new instance from the given string.
  ///
  /// The string passed as `text` can represent a real number in decimal or
  /// hexadecimal format or can be in a special format representing infinity
  /// or NaN ("not a number"). If `text` is not in a recognized format,
  /// the optional initializer will fail and return `nil`.
  ///
  /// The `text` string consists of an optional
  /// plus or minus sign character (`+` or `-`)
  /// followed by one of the following:
  ///
  /// - A *decimal string* contains a significand consisting of one
  ///   or more decimal digits that may include a decimal point:
  ///
  ///       let c = Float16("-1.0")
  ///       // c == -1.0
  ///
  ///       let d = Float16("28.375")
  ///       // d == 28.375
  ///
  ///   A decimal string may also include an exponent following the
  ///   significand, indicating the power of 10 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `e` or `E`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let e = Float16("2837.5e-2")
  ///       // e == 28.375
  ///
  /// - A *hexadecimal string* contains a significand consisting of
  ///   `0X` or `0x` followed by one or more hexadecimal digits that may
  ///   include a decimal point.
  ///
  ///       let f = Float16("0x1c.6")
  ///       // f == 28.375
  ///
  ///   A hexadecimal string may also include an exponent
  ///   indicating the power of 2 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `p` or `P`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let g = Float16("0x1.c6p4")
  ///       // g == 28.375
  ///
  /// - The input strings `"inf"` or `"infinity"` (case insensitive)
  ///   are converted to an infinite result:
  ///
  ///       let i = Float16("inf")
  ///       // i == Float16.infinity
  ///
  ///       let j = Float16("-Infinity")
  ///       // j == -Float16.infinity
  ///
  /// - An input string of `"nan"` (case insensitive) is converted
  ///   into a *NaN* value:
  ///
  ///       let n = Float16("-nan")
  ///       // n?.isNaN == true
  ///       // n?.sign == .minus
  ///
  ///   A NaN string may also include a payload in parentheses following the
  ///   `"nan"` keyword. The payload consists of a sequence of decimal digits,
  ///   or the characters `0X` or `0x` followed by a sequence of hexadecimal
  ///   digits. If the payload contains any other characters, it is ignored.
  ///   If the value of the payload is larger than can be stored as the
  ///   payload of a `Float16.nan`, the least significant bits are used.
  ///
  ///       let p = Float16("nan(0x10)")
  ///       // p?.isNaN == true
  ///       // String(p!) == "nan(0x10)"
  ///
  /// A string in any other format than those described above
  /// or containing additional characters
  /// results in a `nil` value. For example, the following conversions
  /// result in `nil`:
  ///
  ///       Float16(" 5.0")      // Includes whitespace
  ///       Float16("±2.0")      // Invalid character
  ///       Float16("0x1.25e4")  // Incorrect exponent format
  ///
  /// A decimal or hexadecimal string is converted to a `Float16`
  /// instance using the IEEE 754 roundTiesToEven (default) rounding
  /// attribute.
  /// Values with absolute value smaller than `Float16.leastNonzeroMagnitude`
  /// are rounded to plus or minus zero.
  /// Values with absolute value larger than `Float16.greatestFiniteMagnitude`
  /// are rounded to plus or minus infinity.
  ///
  ///       let y = Float16("1.23e-9999")
  ///       // y == 0.0
  ///       // y?.sign == .plus
  ///
  ///       let z = Float16("-7.89e-7206")
  ///       // z == -0.0
  ///       // z?.sign == .minus
  ///
  ///       let r = Float16("1.23e17802")
  ///       // r == Float16.infinity
  ///
  ///       let s = Float16("-7.89e7206")
  ///       // s == Float16.-infinity
  ///
  /// - Note:  Prior to Swift 5.4, a decimal or
  /// hexadecimal input string whose value was too large to represent
  /// as a finite `Float16` instance returned `nil` instead of
  /// `Float16.infinity`.
  ///
  /// - Parameter text: An input string to convert to a `Float16?` instance.
  ///
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 166)
    self.init(Substring(text))
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 192)
  }

  // Caveat:  This implementation used to be inlineable.
  // In particular, we still have to export
  // _swift_stdlib_strtoXYZ_clocale()
  // as ABI to support old compiled code that still requires it.
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false // Reject leading whitespace
        case 0:
          return false // Reject empty string
        default:
          break
        }
        let endPtr = _swift_stdlib_strtof16_clocale(chars, p)
        // Succeed only if endPtr points to end of C string
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 223)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 225)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 42)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 48)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 52)
extension Float: LosslessStringConvertible {
  /// Creates a new instance from the given string.
  ///
  /// The string passed as `text` can represent a real number in decimal or
  /// hexadecimal format or can be in a special format representing infinity
  /// or NaN ("not a number"). If `text` is not in a recognized format,
  /// the optional initializer will fail and return `nil`.
  ///
  /// The `text` string consists of an optional
  /// plus or minus sign character (`+` or `-`)
  /// followed by one of the following:
  ///
  /// - A *decimal string* contains a significand consisting of one
  ///   or more decimal digits that may include a decimal point:
  ///
  ///       let c = Float("-1.0")
  ///       // c == -1.0
  ///
  ///       let d = Float("28.375")
  ///       // d == 28.375
  ///
  ///   A decimal string may also include an exponent following the
  ///   significand, indicating the power of 10 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `e` or `E`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let e = Float("2837.5e-2")
  ///       // e == 28.375
  ///
  /// - A *hexadecimal string* contains a significand consisting of
  ///   `0X` or `0x` followed by one or more hexadecimal digits that may
  ///   include a decimal point.
  ///
  ///       let f = Float("0x1c.6")
  ///       // f == 28.375
  ///
  ///   A hexadecimal string may also include an exponent
  ///   indicating the power of 2 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `p` or `P`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let g = Float("0x1.c6p4")
  ///       // g == 28.375
  ///
  /// - The input strings `"inf"` or `"infinity"` (case insensitive)
  ///   are converted to an infinite result:
  ///
  ///       let i = Float("inf")
  ///       // i == Float.infinity
  ///
  ///       let j = Float("-Infinity")
  ///       // j == -Float.infinity
  ///
  /// - An input string of `"nan"` (case insensitive) is converted
  ///   into a *NaN* value:
  ///
  ///       let n = Float("-nan")
  ///       // n?.isNaN == true
  ///       // n?.sign == .minus
  ///
  ///   A NaN string may also include a payload in parentheses following the
  ///   `"nan"` keyword. The payload consists of a sequence of decimal digits,
  ///   or the characters `0X` or `0x` followed by a sequence of hexadecimal
  ///   digits. If the payload contains any other characters, it is ignored.
  ///   If the value of the payload is larger than can be stored as the
  ///   payload of a `Float.nan`, the least significant bits are used.
  ///
  ///       let p = Float("nan(0x10)")
  ///       // p?.isNaN == true
  ///       // String(p!) == "nan(0x10)"
  ///
  /// A string in any other format than those described above
  /// or containing additional characters
  /// results in a `nil` value. For example, the following conversions
  /// result in `nil`:
  ///
  ///       Float(" 5.0")      // Includes whitespace
  ///       Float("±2.0")      // Invalid character
  ///       Float("0x1.25e4")  // Incorrect exponent format
  ///
  /// A decimal or hexadecimal string is converted to a `Float`
  /// instance using the IEEE 754 roundTiesToEven (default) rounding
  /// attribute.
  /// Values with absolute value smaller than `Float.leastNonzeroMagnitude`
  /// are rounded to plus or minus zero.
  /// Values with absolute value larger than `Float.greatestFiniteMagnitude`
  /// are rounded to plus or minus infinity.
  ///
  ///       let y = Float("1.23e-9999")
  ///       // y == 0.0
  ///       // y?.sign == .plus
  ///
  ///       let z = Float("-7.89e-7206")
  ///       // z == -0.0
  ///       // z?.sign == .minus
  ///
  ///       let r = Float("1.23e17802")
  ///       // r == Float.infinity
  ///
  ///       let s = Float("-7.89e7206")
  ///       // s == Float.-infinity
  ///
  /// - Note:  Prior to Swift 5.4, a decimal or
  /// hexadecimal input string whose value was too large to represent
  /// as a finite `Float` instance returned `nil` instead of
  /// `Float.infinity`.
  ///
  /// - Parameter text: An input string to convert to a `Float?` instance.
  ///
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 168)
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { //SwiftStdlib 5.3
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false // Reject leading whitespace
          case 0:
            return false // Reject empty string
          default:
            break
          }
          let endPtr = _swift_stdlib_strtof_clocale(chars, p)
          // Succeed only if endPtr points to end of C string
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 192)
  }

  // Caveat:  This implementation used to be inlineable.
  // In particular, we still have to export
  // _swift_stdlib_strtoXYZ_clocale()
  // as ABI to support old compiled code that still requires it.
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false // Reject leading whitespace
        case 0:
          return false // Reject empty string
        default:
          break
        }
        let endPtr = _swift_stdlib_strtof_clocale(chars, p)
        // Succeed only if endPtr points to end of C string
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 225)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 42)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 48)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 52)
extension Double: LosslessStringConvertible {
  /// Creates a new instance from the given string.
  ///
  /// The string passed as `text` can represent a real number in decimal or
  /// hexadecimal format or can be in a special format representing infinity
  /// or NaN ("not a number"). If `text` is not in a recognized format,
  /// the optional initializer will fail and return `nil`.
  ///
  /// The `text` string consists of an optional
  /// plus or minus sign character (`+` or `-`)
  /// followed by one of the following:
  ///
  /// - A *decimal string* contains a significand consisting of one
  ///   or more decimal digits that may include a decimal point:
  ///
  ///       let c = Double("-1.0")
  ///       // c == -1.0
  ///
  ///       let d = Double("28.375")
  ///       // d == 28.375
  ///
  ///   A decimal string may also include an exponent following the
  ///   significand, indicating the power of 10 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `e` or `E`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let e = Double("2837.5e-2")
  ///       // e == 28.375
  ///
  /// - A *hexadecimal string* contains a significand consisting of
  ///   `0X` or `0x` followed by one or more hexadecimal digits that may
  ///   include a decimal point.
  ///
  ///       let f = Double("0x1c.6")
  ///       // f == 28.375
  ///
  ///   A hexadecimal string may also include an exponent
  ///   indicating the power of 2 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `p` or `P`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let g = Double("0x1.c6p4")
  ///       // g == 28.375
  ///
  /// - The input strings `"inf"` or `"infinity"` (case insensitive)
  ///   are converted to an infinite result:
  ///
  ///       let i = Double("inf")
  ///       // i == Double.infinity
  ///
  ///       let j = Double("-Infinity")
  ///       // j == -Double.infinity
  ///
  /// - An input string of `"nan"` (case insensitive) is converted
  ///   into a *NaN* value:
  ///
  ///       let n = Double("-nan")
  ///       // n?.isNaN == true
  ///       // n?.sign == .minus
  ///
  ///   A NaN string may also include a payload in parentheses following the
  ///   `"nan"` keyword. The payload consists of a sequence of decimal digits,
  ///   or the characters `0X` or `0x` followed by a sequence of hexadecimal
  ///   digits. If the payload contains any other characters, it is ignored.
  ///   If the value of the payload is larger than can be stored as the
  ///   payload of a `Double.nan`, the least significant bits are used.
  ///
  ///       let p = Double("nan(0x10)")
  ///       // p?.isNaN == true
  ///       // String(p!) == "nan(0x10)"
  ///
  /// A string in any other format than those described above
  /// or containing additional characters
  /// results in a `nil` value. For example, the following conversions
  /// result in `nil`:
  ///
  ///       Double(" 5.0")      // Includes whitespace
  ///       Double("±2.0")      // Invalid character
  ///       Double("0x1.25e4")  // Incorrect exponent format
  ///
  /// A decimal or hexadecimal string is converted to a `Double`
  /// instance using the IEEE 754 roundTiesToEven (default) rounding
  /// attribute.
  /// Values with absolute value smaller than `Double.leastNonzeroMagnitude`
  /// are rounded to plus or minus zero.
  /// Values with absolute value larger than `Double.greatestFiniteMagnitude`
  /// are rounded to plus or minus infinity.
  ///
  ///       let y = Double("1.23e-9999")
  ///       // y == 0.0
  ///       // y?.sign == .plus
  ///
  ///       let z = Double("-7.89e-7206")
  ///       // z == -0.0
  ///       // z?.sign == .minus
  ///
  ///       let r = Double("1.23e17802")
  ///       // r == Double.infinity
  ///
  ///       let s = Double("-7.89e7206")
  ///       // s == Double.-infinity
  ///
  /// - Note:  Prior to Swift 5.4, a decimal or
  /// hexadecimal input string whose value was too large to represent
  /// as a finite `Double` instance returned `nil` instead of
  /// `Double.infinity`.
  ///
  /// - Parameter text: An input string to convert to a `Double?` instance.
  ///
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 168)
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { //SwiftStdlib 5.3
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false // Reject leading whitespace
          case 0:
            return false // Reject empty string
          default:
            break
          }
          let endPtr = _swift_stdlib_strtod_clocale(chars, p)
          // Succeed only if endPtr points to end of C string
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 192)
  }

  // Caveat:  This implementation used to be inlineable.
  // In particular, we still have to export
  // _swift_stdlib_strtoXYZ_clocale()
  // as ABI to support old compiled code that still requires it.
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false // Reject leading whitespace
        case 0:
          return false // Reject empty string
        default:
          break
        }
        let endPtr = _swift_stdlib_strtod_clocale(chars, p)
        // Succeed only if endPtr points to end of C string
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 225)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 42)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 44)
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 48)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 52)
extension Float80: LosslessStringConvertible {
  /// Creates a new instance from the given string.
  ///
  /// The string passed as `text` can represent a real number in decimal or
  /// hexadecimal format or can be in a special format representing infinity
  /// or NaN ("not a number"). If `text` is not in a recognized format,
  /// the optional initializer will fail and return `nil`.
  ///
  /// The `text` string consists of an optional
  /// plus or minus sign character (`+` or `-`)
  /// followed by one of the following:
  ///
  /// - A *decimal string* contains a significand consisting of one
  ///   or more decimal digits that may include a decimal point:
  ///
  ///       let c = Float80("-1.0")
  ///       // c == -1.0
  ///
  ///       let d = Float80("28.375")
  ///       // d == 28.375
  ///
  ///   A decimal string may also include an exponent following the
  ///   significand, indicating the power of 10 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `e` or `E`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let e = Float80("2837.5e-2")
  ///       // e == 28.375
  ///
  /// - A *hexadecimal string* contains a significand consisting of
  ///   `0X` or `0x` followed by one or more hexadecimal digits that may
  ///   include a decimal point.
  ///
  ///       let f = Float80("0x1c.6")
  ///       // f == 28.375
  ///
  ///   A hexadecimal string may also include an exponent
  ///   indicating the power of 2 by which the significand should
  ///   be multiplied. If included, the exponent is separated by a single
  ///   character, `p` or `P`, and consists of an optional plus or minus sign
  ///   character and a sequence of decimal digits.
  ///
  ///       let g = Float80("0x1.c6p4")
  ///       // g == 28.375
  ///
  /// - The input strings `"inf"` or `"infinity"` (case insensitive)
  ///   are converted to an infinite result:
  ///
  ///       let i = Float80("inf")
  ///       // i == Float80.infinity
  ///
  ///       let j = Float80("-Infinity")
  ///       // j == -Float80.infinity
  ///
  /// - An input string of `"nan"` (case insensitive) is converted
  ///   into a *NaN* value:
  ///
  ///       let n = Float80("-nan")
  ///       // n?.isNaN == true
  ///       // n?.sign == .minus
  ///
  ///   A NaN string may also include a payload in parentheses following the
  ///   `"nan"` keyword. The payload consists of a sequence of decimal digits,
  ///   or the characters `0X` or `0x` followed by a sequence of hexadecimal
  ///   digits. If the payload contains any other characters, it is ignored.
  ///   If the value of the payload is larger than can be stored as the
  ///   payload of a `Float80.nan`, the least significant bits are used.
  ///
  ///       let p = Float80("nan(0x10)")
  ///       // p?.isNaN == true
  ///       // String(p!) == "nan(0x10)"
  ///
  /// A string in any other format than those described above
  /// or containing additional characters
  /// results in a `nil` value. For example, the following conversions
  /// result in `nil`:
  ///
  ///       Float80(" 5.0")      // Includes whitespace
  ///       Float80("±2.0")      // Invalid character
  ///       Float80("0x1.25e4")  // Incorrect exponent format
  ///
  /// A decimal or hexadecimal string is converted to a `Float80`
  /// instance using the IEEE 754 roundTiesToEven (default) rounding
  /// attribute.
  /// Values with absolute value smaller than `Float80.leastNonzeroMagnitude`
  /// are rounded to plus or minus zero.
  /// Values with absolute value larger than `Float80.greatestFiniteMagnitude`
  /// are rounded to plus or minus infinity.
  ///
  ///       let y = Float80("1.23e-9999")
  ///       // y == 0.0
  ///       // y?.sign == .plus
  ///
  ///       let z = Float80("-7.89e-7206")
  ///       // z == -0.0
  ///       // z?.sign == .minus
  ///
  ///       let r = Float80("1.23e17802")
  ///       // r == Float80.infinity
  ///
  ///       let s = Float80("-7.89e7206")
  ///       // s == Float80.-infinity
  ///
  /// - Note:  Prior to Swift 5.4, a decimal or
  /// hexadecimal input string whose value was too large to represent
  /// as a finite `Float80` instance returned `nil` instead of
  /// `Float80.infinity`.
  ///
  /// - Parameter text: An input string to convert to a `Float80?` instance.
  ///
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 168)
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { //SwiftStdlib 5.3
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false // Reject leading whitespace
          case 0:
            return false // Reject empty string
          default:
            break
          }
          let endPtr = _swift_stdlib_strtold_clocale(chars, p)
          // Succeed only if endPtr points to end of C string
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 192)
  }

  // Caveat:  This implementation used to be inlineable.
  // In particular, we still have to export
  // _swift_stdlib_strtoXYZ_clocale()
  // as ABI to support old compiled code that still requires it.
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false // Reject leading whitespace
        case 0:
          return false // Reject empty string
        default:
          break
        }
        let endPtr = _swift_stdlib_strtold_clocale(chars, p)
        // Succeed only if endPtr points to end of C string
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 223)
#endif
// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 225)

// ###sourceLocation(file: "/Users/gebiwanger/Downloads/swiftRaw/swift/stdlib/public/core/FloatingPointParsing.swift.gyb", line: 227)

// Local Variables:
// eval: (read-only-mode 1)
// End:
