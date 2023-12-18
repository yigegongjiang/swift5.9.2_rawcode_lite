import SwiftShims
public func _stdlib_isOSVersionAtLeast(
  _ major: Builtin.Word,
  _ minor: Builtin.Word,
  _ patch: Builtin.Word
) -> Builtin.Int1 {
#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && SWIFT_RUNTIME_OS_VERSIONING
  if Int(major) == 9999 {
    return true._value
  }
  let runningVersion = _swift_stdlib_operatingSystemVersion()
  let result =
    (runningVersion.majorVersion,runningVersion.minorVersion,runningVersion.patchVersion)
    >= (Int(major),Int(minor),Int(patch))
  return result._value
#else
  return false._value
#endif
}
#if os(macOS) && SWIFT_RUNTIME_OS_VERSIONING
public func _stdlib_isOSVersionAtLeastOrVariantVersionAtLeast(
  _ major: Builtin.Word,
  _ minor: Builtin.Word,
  _ patch: Builtin.Word,
  _ variantMajor: Builtin.Word,
  _ variantMinor: Builtin.Word,
  _ variantPatch: Builtin.Word
  ) -> Builtin.Int1 {
  return _stdlib_isOSVersionAtLeast(major, minor, patch)
}
#endif
public typealias _SwiftStdlibVersion = SwiftShims._SwiftStdlibVersion
@inline(__always)
internal func _isExecutableLinkedOnOrAfter(
  _ stdlibVersion: _SwiftStdlibVersion
) -> Bool {
#if SWIFT_RUNTIME_OS_VERSIONING
  return _swift_stdlib_isExecutableLinkedOnOrAfter(stdlibVersion)
#else
  return true
#endif
}
extension _SwiftStdlibVersion {
  public static var v5_6_0: Self { Self(_value: 0x050600) }
  public static var v5_7_0: Self { Self(_value: 0x050700) }
  public static var v5_8_0: Self { Self(_value: 0x050800) }
  public static var v5_9_0: Self { Self(_value: 0x050900) }
  @available(SwiftStdlib 5.7, *)
  public static var current: Self { .v5_9_0 }
}
@available(SwiftStdlib 5.7, *)
extension _SwiftStdlibVersion: CustomStringConvertible {
  @available(SwiftStdlib 5.7, *)
  public var description: String {
    let major = _value >> 16
    let minor = (_value >> 8) & 0xFF
    let patch = _value & 0xFF
    return "\(major).\(minor).\(patch)"
  }
}
