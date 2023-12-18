import SwiftShims
public 
func _isDebugAssertConfiguration() -> Bool {
  return Int32(Builtin.assert_configuration()) == 0
}
public 
func _isReleaseAssertConfiguration() -> Bool {
  return Int32(Builtin.assert_configuration()) == 1
}
public 
func _isFastAssertConfiguration() -> Bool {
  return Int32(Builtin.assert_configuration()) == 2
}
public 
func _isStdlibInternalChecksEnabled() -> Bool {
#if INTERNAL_CHECKS_ENABLED
  return true
#else
  return false
#endif
}
public 
func _isStdlibDebugChecksEnabled() -> Bool {
#if SWIFT_STDLIB_ENABLE_DEBUG_PRECONDITIONS_IN_RELEASE
  return !_isFastAssertConfiguration()
#else
  return _isDebugAssertConfiguration()
#endif
}
internal func _fatalErrorFlags() -> UInt32 {
#if os(iOS) || os(tvOS) || os(watchOS)
  return 0
#else
  return _isDebugAssertConfiguration() ? 1 : 0
#endif
}
@usableFromInline
@inline(never)
internal func _assertionFailure(
  _ prefix: StaticString, _ message: StaticString,
  file: StaticString, line: UInt,
  flags: UInt32
) -> Never {
  prefix.withUTF8Buffer {
    (prefix) -> Void in
    message.withUTF8Buffer {
      (message) -> Void in
      file.withUTF8Buffer {
        (file) -> Void in
        _swift_stdlib_reportFatalErrorInFile(
          prefix.baseAddress!, CInt(prefix.count),
          message.baseAddress!, CInt(message.count),
          file.baseAddress!, CInt(file.count), UInt32(line),
          flags)
        Builtin.int_trap()
      }
    }
  }
  Builtin.int_trap()
}
@usableFromInline
@inline(never)
internal func _assertionFailure(
  _ prefix: StaticString, _ message: String,
  file: StaticString, line: UInt,
  flags: UInt32
) -> Never {
  prefix.withUTF8Buffer {
    (prefix) -> Void in
    var message = message
    message.withUTF8 {
      (messageUTF8) -> Void in
      file.withUTF8Buffer {
        (file) -> Void in
        _swift_stdlib_reportFatalErrorInFile(
          prefix.baseAddress!, CInt(prefix.count),
          messageUTF8.baseAddress!, CInt(messageUTF8.count),
          file.baseAddress!, CInt(file.count), UInt32(line),
          flags)
      }
    }
  }
  Builtin.int_trap()
}
@usableFromInline
@inline(never)
internal func _assertionFailure(
  _ prefix: StaticString, _ message: String,
  flags: UInt32
) -> Never {
  prefix.withUTF8Buffer {
    (prefix) -> Void in
    var message = message
    message.withUTF8 {
      (messageUTF8) -> Void in
      _swift_stdlib_reportFatalError(
        prefix.baseAddress!, CInt(prefix.count),
        messageUTF8.baseAddress!, CInt(messageUTF8.count),
        flags)
    }
  }
  Builtin.int_trap()
}
@usableFromInline
@inline(never)
internal func _fatalErrorMessage(
  _ prefix: StaticString, _ message: StaticString,
  file: StaticString, line: UInt,
  flags: UInt32
) -> Never {
  _assertionFailure(prefix, message, file: file, line: line, flags: flags)
}
public 
func _unimplementedInitializer(className: StaticString,
                               initName: StaticString = #function,
                               file: StaticString = #file,
                               line: UInt = #line,
                               column: UInt = #column
) -> Never {
  if _isDebugAssertConfiguration() {
    className.withUTF8Buffer {
      (className) in
      initName.withUTF8Buffer {
        (initName) in
        file.withUTF8Buffer {
          (file) in
          _swift_stdlib_reportUnimplementedInitializerInFile(
            className.baseAddress!, CInt(className.count),
            initName.baseAddress!, CInt(initName.count),
            file.baseAddress!, CInt(file.count),
            UInt32(line), UInt32(column),
             0)
        }
      }
    }
  } else {
    className.withUTF8Buffer {
      (className) in
      initName.withUTF8Buffer {
        (initName) in
        _swift_stdlib_reportUnimplementedInitializer(
          className.baseAddress!, CInt(className.count),
          initName.baseAddress!, CInt(initName.count),
           0)
      }
    }
  }
  Builtin.int_trap()
}
public 
func _undefined<T>(
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) -> T {
  _assertionFailure("Fatal error", message(), file: file, line: line, flags: 0)
}
@inline(never)
@usableFromInline 
internal func _diagnoseUnexpectedEnumCaseValue<SwitchedValue, RawValue>(
  type: SwitchedValue.Type,
  rawValue: RawValue
) -> Never {
  _assertionFailure("Fatal error",
                    "unexpected enum case '\(type)(rawValue: \(rawValue))'",
                    flags: _fatalErrorFlags())
}
@inline(never)
@usableFromInline 
internal func _diagnoseUnexpectedEnumCase<SwitchedValue>(
  type: SwitchedValue.Type
) -> Never {
  _assertionFailure(
    "Fatal error",
    "unexpected enum case while switching on value of type '\(type)'",
    flags: _fatalErrorFlags())
}
@backDeployed(before: SwiftStdlib 5.9)
@inline(never)
@usableFromInline 
internal func _diagnoseUnavailableCodeReached() -> Never {
  _assertionFailure(
    "Fatal error", "Unavailable code reached", flags: _fatalErrorFlags())
}
