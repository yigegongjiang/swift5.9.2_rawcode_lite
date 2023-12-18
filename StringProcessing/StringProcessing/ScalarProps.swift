func _swift_string_processing_getScript(_: UInt32) -> UInt8
func _swift_string_processing_getScriptExtensions(
  _: UInt32,
  _: UnsafeMutablePointer<UInt8>
) -> UnsafePointer<UInt8>?
extension Unicode.Script {
  init(_ scalar: Unicode.Scalar) {
    let rawValue = _swift_string_processing_getScript(scalar.value)
    _internalInvariant(rawValue != .max, "Unknown script rawValue: \(rawValue)")
    self = unsafeBitCast(rawValue, to: Self.self)
  }
  static func extensions(for scalar: Unicode.Scalar) -> [Unicode.Script] {
    var count: UInt8 = 0
    let pointer = _swift_string_processing_getScriptExtensions(scalar.value, &count)
    guard let pointer = pointer else {
      return [Unicode.Script(scalar)]
    }
    var result: [Unicode.Script] = []
    for i in 0 ..< count {
      let script = pointer[Int(i)]
      result.append(unsafeBitCast(script, to: Unicode.Script.self))
    }
    return result
  }
}
extension UnicodeScalar {
  var isHorizontalWhitespace: Bool {
    value == 0x09 || properties.generalCategory == .spaceSeparator
  }
  var isNewline: Bool {
    switch value {
      case 0x000A...0x000D : return true
      case 0x0085 : return true
      case 0x2028 : return true
      case 0x2029 : return true
      default: return false
    }
  }
}
