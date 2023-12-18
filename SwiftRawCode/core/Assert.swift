public func assert(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) {
  if _isDebugAssertConfiguration() {
    if !_fastPath(condition()) {
      _assertionFailure("Assertion failed", message(), file: file, line: line,
        flags: _fatalErrorFlags())
    }
  }
}
public func precondition(
  _ condition: @autoclosure () -> Bool,
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) {
  if _isDebugAssertConfiguration() {
    if !_fastPath(condition()) {
      _assertionFailure("Precondition failed", message(), file: file, line: line,
        flags: _fatalErrorFlags())
    }
  } else if _isReleaseAssertConfiguration() {
    let error = !condition()
    Builtin.condfail_message(error._value,
      StaticString("precondition failure").unsafeRawPointer)
  }
}
@inlinable
@inline(__always)
public func assertionFailure(
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) {
  if _isDebugAssertConfiguration() {
    _assertionFailure("Fatal error", message(), file: file, line: line,
      flags: _fatalErrorFlags())
  }
  else if _isFastAssertConfiguration() {
    _conditionallyUnreachable()
  }
}
public func preconditionFailure(
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) -> Never {
  if _isDebugAssertConfiguration() {
    _assertionFailure("Fatal error", message(), file: file, line: line,
      flags: _fatalErrorFlags())
  } else if _isReleaseAssertConfiguration() {
    Builtin.condfail_message(true._value,
      StaticString("precondition failure").unsafeRawPointer)
  }
  _conditionallyUnreachable()
}
public func fatalError(
  _ message: @autoclosure () -> String = String(),
  file: StaticString = #file, line: UInt = #line
) -> Never {
  _assertionFailure("Fatal error", message(), file: file, line: line,
    flags: _fatalErrorFlags())
}
internal func _precondition(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
  if _isDebugAssertConfiguration() {
    if !_fastPath(condition()) {
      _assertionFailure("Fatal error", message, file: file, line: line,
        flags: _fatalErrorFlags())
    }
  } else if _isReleaseAssertConfiguration() {
    let error = !condition()
    Builtin.condfail_message(error._value, message.unsafeRawPointer)
  }
}
internal func _preconditionFailure(
  _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) -> Never {
  _precondition(false, message, file: file, line: line)
  _conditionallyUnreachable()
}
public func _overflowChecked<T>(
  _ args: (T, Bool),
  file: StaticString = #file, line: UInt = #line
) -> T {
  let (result, error) = args
  if _isDebugAssertConfiguration() {
    if _slowPath(error) {
      _fatalErrorMessage("Fatal error", "Overflow/underflow",
        file: file, line: line, flags: _fatalErrorFlags())
    }
  } else {
    Builtin.condfail_message(error._value,
      StaticString("_overflowChecked failure").unsafeRawPointer)
  }
  return result
}
internal func _debugPrecondition(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
#if SWIFT_STDLIB_ENABLE_DEBUG_PRECONDITIONS_IN_RELEASE
  _precondition(condition(), message, file: file, line: line)
#else
  if _slowPath(_isDebugAssertConfiguration()) {
    if !_fastPath(condition()) {
      _fatalErrorMessage("Fatal error", message, file: file, line: line,
        flags: _fatalErrorFlags())
    }
  }
#endif
}
internal func _debugPreconditionFailure(
  _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) -> Never {
#if SWIFT_STDLIB_ENABLE_DEBUG_PRECONDITIONS_IN_RELEASE
  _preconditionFailure(message, file: file, line: line)
#else
  if _slowPath(_isDebugAssertConfiguration()) {
    _precondition(false, message, file: file, line: line)
  }
  _conditionallyUnreachable()
#endif
}
internal func _internalInvariant(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
#if INTERNAL_CHECKS_ENABLED
  if !_fastPath(condition()) {
    _fatalErrorMessage("Fatal error", message, file: file, line: line,
      flags: _fatalErrorFlags())
  }
#endif
}
internal func _internalInvariant_5_1(
  _ condition: @autoclosure () -> Bool, _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
#if INTERNAL_CHECKS_ENABLED
  guard #available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *) 
  else { return }
  _internalInvariant(condition(), message, file: file, line: line)
#endif
}
internal func _precondition(
  ifLinkedOnOrAfter version: _SwiftStdlibVersion,
  _ condition: @autoclosure () -> Bool,
  _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) {
  if _isDebugAssertConfiguration() {
    if _slowPath(!condition()) {
      guard _isExecutableLinkedOnOrAfter(version) else { return }
      _assertionFailure("Fatal error", message, file: file, line: line,
        flags: _fatalErrorFlags())
    }
  } else if _isReleaseAssertConfiguration() {
    let error = (!condition() && _isExecutableLinkedOnOrAfter(version))
    Builtin.condfail_message(error._value, message.unsafeRawPointer)
  }
}
internal func _internalInvariantFailure(
  _ message: StaticString = StaticString(),
  file: StaticString = #file, line: UInt = #line
) -> Never {
  _internalInvariant(false, message, file: file, line: line)
  _conditionallyUnreachable()
}
