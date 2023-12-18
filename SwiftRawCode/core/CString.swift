import SwiftShims
extension String {
  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    let len = UTF8._nullCodeUnitOffset(in: nullTerminatedUTF8)
    let buffer = UnsafeBufferPointer(start: nullTerminatedUTF8, count: len)
    self = buffer.withMemoryRebound(to: UInt8.self) {
      String._fromUTF8Repairing($0).0
    }
  }
  @inlinable
  public init(cString nullTerminatedUTF8: [CChar]) {
    self = nullTerminatedUTF8.withUnsafeBufferPointer {
      $0.withMemoryRebound(to: UInt8.self, String.init(_checkingCString:))
    }
  }
  private init(_checkingCString bytes: UnsafeBufferPointer<UInt8>) {
    guard let length = bytes.firstIndex(of: 0) else {
      _preconditionFailure(
        "input of String.init(cString:) must be null-terminated"
      )
    }
    self = String._fromUTF8Repairing(
      UnsafeBufferPointer(
        start: bytes.baseAddress._unsafelyUnwrappedUnchecked,
        count: length
      )
    ).0
  }
  @inlinable
  @available(*, deprecated, message: "Use String(_ scalar: Unicode.Scalar)")
  public init(cString nullTerminatedUTF8: inout CChar) {
    guard nullTerminatedUTF8 == 0 else {
      _preconditionFailure(
        "input of String.init(cString:) must be null-terminated"
      )
    }
    self = ""
  }
  public init(cString nullTerminatedUTF8: UnsafePointer<UInt8>) {
    let len = UTF8._nullCodeUnitOffset(in: nullTerminatedUTF8)
    self = String._fromUTF8Repairing(
      UnsafeBufferPointer(start: nullTerminatedUTF8, count: len)).0
  }
  @inlinable
  public init(cString nullTerminatedUTF8: [UInt8]) {
    self = nullTerminatedUTF8.withUnsafeBufferPointer {
      String(_checkingCString: $0)
    }
  }
  @inlinable
  @available(*, deprecated, message: "Use a copy of the String argument")
  public init(cString nullTerminatedUTF8: String) {
    self = nullTerminatedUTF8.withCString(String.init(cString:))
  }
  @inlinable
  @available(*, deprecated, message: "Use String(_ scalar: Unicode.Scalar)")
  public init(cString nullTerminatedUTF8: inout UInt8) {
    guard nullTerminatedUTF8 == 0 else {
      _preconditionFailure(
        "input of String.init(cString:) must be null-terminated"
      )
    }
    self = ""
  }
  public init?(validatingUTF8 cString: UnsafePointer<CChar>) {
    let len = UTF8._nullCodeUnitOffset(in: cString)
    guard let str = cString.withMemoryRebound(to: UInt8.self, capacity: len, {
      String._tryFromUTF8(UnsafeBufferPointer(start: $0, count: len))
    })
    else { return nil }
    self = str
  }
  @inlinable
  public init?(validatingUTF8 cString: [CChar]) {
    guard let length = cString.firstIndex(of: 0) else {
      _preconditionFailure(
        "input of String.init(validatingUTF8:) must be null-terminated"
      )
    }
    guard let string = cString.prefix(length).withUnsafeBufferPointer({
      $0.withMemoryRebound(to: UInt8.self, String._tryFromUTF8(_:))
    })
    else { return nil }
    self = string
  }
  @inlinable
  @available(*, deprecated, message: "Use a copy of the String argument")
  public init?(validatingUTF8 cString: String) {
    self = cString.withCString(String.init(cString:))
  }
  @inlinable
  @available(*, deprecated, message: "Use String(_ scalar: Unicode.Scalar)")
  public init?(validatingUTF8 cString: inout CChar) {
    guard cString == 0 else {
      _preconditionFailure(
        "input of String.init(validatingUTF8:) must be null-terminated"
      )
    }
    self = ""
  }
  @inlinable 
  public static func decodeCString<Encoding: _UnicodeEncoding>(
    _ cString: UnsafePointer<Encoding.CodeUnit>?,
    as encoding: Encoding.Type,
    repairingInvalidCodeUnits isRepairing: Bool = true
  ) -> (result: String, repairsMade: Bool)? {
    guard let cPtr = cString else { return nil }
    if _fastPath(encoding == Unicode.UTF8.self) {
      let len = UTF8._nullCodeUnitOffset(
        in: UnsafeRawPointer(cPtr).assumingMemoryBound(to: UInt8.self)
      )
      let bytes = UnsafeBufferPointer(start: cPtr, count: len)
      return bytes.withMemoryRebound(to: UInt8.self) { codeUnits in
        if isRepairing {
          return String._fromUTF8Repairing(codeUnits)
        }
        else if let str = String._tryFromUTF8(codeUnits) {
          return (str, false)
        }
        return nil
      }
    }
    var end = cPtr
    while end.pointee != 0 { end += 1 }
    let len = end - cPtr
    let codeUnits = UnsafeBufferPointer(start: cPtr, count: len)
    return String._fromCodeUnits(
      codeUnits, encoding: encoding, repair: isRepairing)
  }
  @inlinable 
  public static func decodeCString<Encoding: _UnicodeEncoding>(
    _ cString: [Encoding.CodeUnit],
    as encoding: Encoding.Type,
    repairingInvalidCodeUnits isRepairing: Bool = true
  ) -> (result: String, repairsMade: Bool)? {
    guard let length = cString.firstIndex(of: 0) else {
      _preconditionFailure(
        "input of decodeCString(_:as:repairingInvalidCodeUnits:) must be null-terminated"
      )
    }
    if _fastPath(encoding == Unicode.UTF8.self) {
      return cString.prefix(length).withUnsafeBufferPointer {
        buffer -> (result: String, repairsMade: Bool)? in
        return buffer.withMemoryRebound(to: UInt8.self) { codeUnits in
          if isRepairing {
            return String._fromUTF8Repairing(codeUnits)
          }
          else if let str = String._tryFromUTF8(codeUnits) {
            return (str, false)
          }
          return nil
        }
      }
    }
    return cString.prefix(length).withUnsafeBufferPointer {
      buf -> (result: String, repairsMade: Bool)? in
      String._fromCodeUnits(buf, encoding: encoding, repair: isRepairing)
    }
  }
  @inlinable
  @available(*, deprecated, message: "Use a copy of the String argument")
  public static func decodeCString<Encoding: _UnicodeEncoding>(
    _ cString: String,
    as encoding: Encoding.Type,
    repairingInvalidCodeUnits isRepairing: Bool = true
  ) -> (result: String, repairsMade: Bool)? {
    return cString.withCString(encodedAs: encoding) {
      String.decodeCString(
        $0, as: encoding, repairingInvalidCodeUnits: isRepairing
      )
    }
  }
  @inlinable
  @available(*, deprecated, message: "Use String(_ scalar: Unicode.Scalar)")
  public static func decodeCString<Encoding: _UnicodeEncoding>(
    _ cString: inout Encoding.CodeUnit,
    as encoding: Encoding.Type,
    repairingInvalidCodeUnits isRepairing: Bool = true
  ) -> (result: String, repairsMade: Bool)? {
    guard cString == 0 else {
      _preconditionFailure(
        "input of decodeCString(_:as:repairingInvalidCodeUnits:) must be null-terminated"
      )
    }
    return ("", false)
  }
  @inlinable 
  public init<Encoding: Unicode.Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) {
    self = String.decodeCString(nullTerminatedCodeUnits, as: sourceEncoding)!.0
  }
  @inlinable 
  public init<Encoding: Unicode.Encoding>(
    decodingCString nullTerminatedCodeUnits: [Encoding.CodeUnit],
    as sourceEncoding: Encoding.Type
  ) {
    self = String.decodeCString(nullTerminatedCodeUnits, as: sourceEncoding)!.0
  }
  @inlinable
  @available(*, deprecated, message: "Use a copy of the String argument")
  public init<Encoding: _UnicodeEncoding>(
    decodingCString nullTerminatedCodeUnits: String,
    as sourceEncoding: Encoding.Type
  ) {
    self = nullTerminatedCodeUnits.withCString(encodedAs: sourceEncoding) {
      String(decodingCString: $0, as: sourceEncoding.self)
    }
  }
  @inlinable 
  @available(*, deprecated, message: "Use String(_ scalar: Unicode.Scalar)")
  public init<Encoding: Unicode.Encoding>(
    decodingCString nullTerminatedCodeUnits: inout Encoding.CodeUnit,
    as sourceEncoding: Encoding.Type
  ) {
    guard nullTerminatedCodeUnits == 0 else {
      _preconditionFailure(
        "input of String.init(decodingCString:as:) must be null-terminated"
      )
    }
    self = ""
  }
}
extension UnsafePointer where Pointee == UInt8 {
  @inlinable
  internal var _asCChar: UnsafePointer<CChar> {
    @inline(__always) get {
      return UnsafeRawPointer(self).assumingMemoryBound(to: CChar.self)
    }
  }
}
extension UnsafePointer where Pointee == CChar {
  @inlinable
  internal var _asUInt8: UnsafePointer<UInt8> {
    @inline(__always) get {
      return UnsafeRawPointer(self).assumingMemoryBound(to: UInt8.self)
    }
  }
}
