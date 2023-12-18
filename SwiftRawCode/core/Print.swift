#if !SWIFT_STDLIB_STATIC_PRINT
public func print(
  _ items: Any...,
  separator: String = " ",
  terminator: String = "\n"
) {
  if let hook = _playgroundPrintHook {
    var output = _TeeStream(left: "", right: _Stdout())
    _print(items, separator: separator, terminator: terminator, to: &output)
    hook(output.left)
  }
  else {
    var output = _Stdout()
    _print(items, separator: separator, terminator: terminator, to: &output)
  }
}
public func debugPrint(
  _ items: Any...,
  separator: String = " ",
  terminator: String = "\n"
) {
  if let hook = _playgroundPrintHook {
    var output = _TeeStream(left: "", right: _Stdout())
    _debugPrint(items, separator: separator, terminator: terminator, to: &output)
    hook(output.left)
  }
  else {
    var output = _Stdout()
    _debugPrint(items, separator: separator, terminator: terminator, to: &output)
  }
}
public func print<Target: TextOutputStream>(
  _ items: Any...,
  separator: String = " ",
  terminator: String = "\n",
  to output: inout Target
) {
  _print(items, separator: separator, terminator: terminator, to: &output)
}
public func debugPrint<Target: TextOutputStream>(
  _ items: Any...,
  separator: String = " ",
  terminator: String = "\n",
  to output: inout Target
) {
  _debugPrint(items, separator: separator, terminator: terminator, to: &output)
}
internal func _print<Target: TextOutputStream>(
  _ items: [Any],
  separator: String = " ",
  terminator: String = "\n",
  to output: inout Target
) {
  var prefix = ""
  output._lock()
  defer { output._unlock() }
  for item in items {
    output.write(prefix)
    _print_unlocked(item, &output)
    prefix = separator
  }
  output.write(terminator)
}
internal func _debugPrint<Target: TextOutputStream>(
  _ items: [Any],
  separator: String = " ",
  terminator: String = "\n",
  to output: inout Target
) {
  var prefix = ""
  output._lock()
  defer { output._unlock() }
  for item in items {
    output.write(prefix)
    _debugPrint_unlocked(item, &output)
    prefix = separator
  }
  output.write(terminator)
}
#endif
