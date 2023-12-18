import SwiftShims
#if SWIFT_STDLIB_HAS_COMMANDLINE
internal func _swift_stdlib_getUnsafeArgvArgc(_: UnsafeMutablePointer<Int32>)
  -> UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>
@frozen 
public enum CommandLine {
  @usableFromInline
  internal static var _argc: Int32 = Int32()
  @usableFromInline
  internal static var _unsafeArgv:
    UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>
      =  _swift_stdlib_getUnsafeArgvArgc(&_argc)
  public static var argc: Int32 {
    _ = CommandLine.unsafeArgv 
    return _argc
  }
  public static var unsafeArgv:
    UnsafeMutablePointer<UnsafeMutablePointer<Int8>?> {
    return _unsafeArgv
  }
  public static var arguments: [String]
    = (0..<Int(argc)).map { String(cString: _unsafeArgv[$0]!) }
}
#endif 
