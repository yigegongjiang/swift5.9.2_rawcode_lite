#if !SWIFT_STDLIB_STATIC_PRINT
public 
func _replPrintLiteralString(_ text: String) {
  print(text, terminator: "")
}
@inline(never)
public 
func _replDebugPrintln<T>(_ value: T) {
  debugPrint(value)
}
#endif
