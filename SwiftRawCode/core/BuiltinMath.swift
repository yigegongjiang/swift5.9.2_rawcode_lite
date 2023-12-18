public func _cos(_ x: Float) -> Float {
  return Float(Builtin.int_cos_FPIEEE32(x._value))
}
public func _sin(_ x: Float) -> Float {
  return Float(Builtin.int_sin_FPIEEE32(x._value))
}
public func _exp(_ x: Float) -> Float {
  return Float(Builtin.int_exp_FPIEEE32(x._value))
}
public func _exp2(_ x: Float) -> Float {
  return Float(Builtin.int_exp2_FPIEEE32(x._value))
}
public func _log(_ x: Float) -> Float {
  return Float(Builtin.int_log_FPIEEE32(x._value))
}
public func _log10(_ x: Float) -> Float {
  return Float(Builtin.int_log10_FPIEEE32(x._value))
}
public func _log2(_ x: Float) -> Float {
  return Float(Builtin.int_log2_FPIEEE32(x._value))
}
public func _nearbyint(_ x: Float) -> Float {
  return Float(Builtin.int_nearbyint_FPIEEE32(x._value))
}
public func _rint(_ x: Float) -> Float {
  return Float(Builtin.int_rint_FPIEEE32(x._value))
}
public func _cos(_ x: Double) -> Double {
  return Double(Builtin.int_cos_FPIEEE64(x._value))
}
public func _sin(_ x: Double) -> Double {
  return Double(Builtin.int_sin_FPIEEE64(x._value))
}
public func _exp(_ x: Double) -> Double {
  return Double(Builtin.int_exp_FPIEEE64(x._value))
}
public func _exp2(_ x: Double) -> Double {
  return Double(Builtin.int_exp2_FPIEEE64(x._value))
}
public func _log(_ x: Double) -> Double {
  return Double(Builtin.int_log_FPIEEE64(x._value))
}
public func _log10(_ x: Double) -> Double {
  return Double(Builtin.int_log10_FPIEEE64(x._value))
}
public func _log2(_ x: Double) -> Double {
  return Double(Builtin.int_log2_FPIEEE64(x._value))
}
public func _nearbyint(_ x: Double) -> Double {
  return Double(Builtin.int_nearbyint_FPIEEE64(x._value))
}
public func _rint(_ x: Double) -> Double {
  return Double(Builtin.int_rint_FPIEEE64(x._value))
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
public func _cos(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_cos_FPIEEE80(x._value))
}
public func _sin(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_sin_FPIEEE80(x._value))
}
public func _exp(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_exp_FPIEEE80(x._value))
}
public func _exp2(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_exp2_FPIEEE80(x._value))
}
public func _log(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_log_FPIEEE80(x._value))
}
public func _log10(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_log10_FPIEEE80(x._value))
}
public func _log2(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_log2_FPIEEE80(x._value))
}
public func _nearbyint(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_nearbyint_FPIEEE80(x._value))
}
public func _rint(_ x: Float80) -> Float80 {
  return Float80(Builtin.int_rint_FPIEEE80(x._value))
}
#endif
