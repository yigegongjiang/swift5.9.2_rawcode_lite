import SwiftShims
public protocol Error: Sendable {
  var _domain: String { get }
  var _code: Int { get }
  var _userInfo: AnyObject? { get }
#if _runtime(_ObjC)
  func _getEmbeddedNSError() -> AnyObject?
#endif
}
#if _runtime(_ObjC)
extension Error {
  public func _getEmbeddedNSError() -> AnyObject? { return nil }
}
#endif
#if _runtime(_ObjC)
internal func _getErrorDomainNSString<T: Error>(_ x: UnsafePointer<T>)
-> AnyObject {
  return x.pointee._domain._bridgeToObjectiveCImpl()
}
internal func _getErrorCode<T: Error>(_ x: UnsafePointer<T>) -> Int {
  return x.pointee._code
}
internal func _getErrorUserInfoNSDictionary<T: Error>(_ x: UnsafePointer<T>)
-> AnyObject? {
  return x.pointee._userInfo.map { $0 }
}
internal func _getErrorEmbeddedNSErrorIndirect<T: Error>(
    _ x: UnsafePointer<T>) -> AnyObject? {
  return x.pointee._getEmbeddedNSError()
}
public 
func _getErrorEmbeddedNSError<T: Error>(_ x: T)
-> AnyObject? {
  return x._getEmbeddedNSError()
}
internal func _getErrorDefaultUserInfo<T: Error>(_ error: T) -> AnyObject?
public func _bridgeErrorToNSError(_ error: __owned Error) -> AnyObject
#endif
public func _unexpectedError(
  _ error: __owned Error,
  filenameStart: Builtin.RawPointer,
  filenameLength: Builtin.Word,
  filenameIsASCII: Builtin.Int1,
  line: Builtin.Word
) {
  preconditionFailure(
    "'try!' expression unexpectedly raised an error: \(String(reflecting: error))",
    file: StaticString(
      _start: filenameStart,
      utf8CodeUnitCount: filenameLength,
      isASCII: filenameIsASCII),
    line: UInt(line))
}
public func _errorInMain(_ error: Error) {
  fatalError("Error raised at top level: \(String(reflecting: error))")
}
public func _getDefaultErrorCode<T: Error>(_ error: T) -> Int
extension Error {
  public var _code: Int {
    return _getDefaultErrorCode(self)
  }
  public var _domain: String {
    return String(reflecting: type(of: self))
  }
  public var _userInfo: AnyObject? {
#if _runtime(_ObjC)
    return _getErrorDefaultUserInfo(self)
#else
    return nil
#endif
  }
}
extension Error where Self: RawRepresentable, Self.RawValue: FixedWidthInteger {
  public var _code: Int {
    if Self.RawValue.isSigned {
      return numericCast(self.rawValue)
    }
    let uintValue: UInt = numericCast(self.rawValue)
    return Int(bitPattern: uintValue)
  }
}
