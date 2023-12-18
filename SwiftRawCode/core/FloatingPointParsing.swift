import SwiftShims
@inlinable 
internal func _isspace_clocale(_ u: UTF16.CodeUnit) -> Bool {
  return "\t\n\u{b}\u{c}\r ".utf16.contains(u)
}
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
extension Float16: LosslessStringConvertible {
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
    self.init(Substring(text))
  }
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false 
        case 0:
          return false 
        default:
          break
        }
        let endPtr = _swift_stdlib_strtof16_clocale(chars, p)
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}
#endif
extension Float: LosslessStringConvertible {
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { 
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false 
          case 0:
            return false 
          default:
            break
          }
          let endPtr = _swift_stdlib_strtof_clocale(chars, p)
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
  }
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false 
        case 0:
          return false 
        default:
          break
        }
        let endPtr = _swift_stdlib_strtof_clocale(chars, p)
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}
extension Double: LosslessStringConvertible {
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { 
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false 
          case 0:
            return false 
          default:
            break
          }
          let endPtr = _swift_stdlib_strtod_clocale(chars, p)
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
  }
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false 
        case 0:
          return false 
        default:
          break
        }
        let endPtr = _swift_stdlib_strtod_clocale(chars, p)
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
extension Float80: LosslessStringConvertible {
  @inlinable
  public init?<S: StringProtocol>(_ text: S) {
    if #available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *) { 
      self.init(Substring(text))
    } else {
      self = 0.0
      let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
        text.withCString { chars -> Bool in
          switch chars[0] {
          case 9, 10, 11, 12, 13, 32:
            return false 
          case 0:
            return false 
          default:
            break
          }
          let endPtr = _swift_stdlib_strtold_clocale(chars, p)
          return endPtr != nil && endPtr![0] == 0
        }
      }
      if !success {
        return nil
      }
    }
  }
  @available(SwiftStdlib 5.3, *)
  public init?(_ text: Substring) {
    self = 0.0
    let success = _withUnprotectedUnsafeMutablePointer(to: &self) { p -> Bool in
      text.withCString { chars -> Bool in
        switch chars[0] {
        case 9, 10, 11, 12, 13, 32:
          return false 
        case 0:
          return false 
        default:
          break
        }
        let endPtr = _swift_stdlib_strtold_clocale(chars, p)
        return endPtr != nil && endPtr![0] == 0
      }
    }
    if !success {
      return nil
    }
  }
}
#endif
