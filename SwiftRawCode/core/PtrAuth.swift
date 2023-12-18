internal enum _PtrAuth {
  internal struct Key {
    var _value: Int32
    init(_value: Int32) {
      self._value = _value
    }
#if _ptrauth(_arm64e)
    static var ASIA: Key { return Key(_value: 0) }
    static var ASIB: Key { return Key(_value: 1) }
    static var ASDA: Key { return Key(_value: 2) }
    static var ASDB: Key { return Key(_value: 3) }
    static var processIndependentCode: Key { return .ASIA }
    static var processDependentCode: Key { return .ASIB }
    static var processIndependentData: Key { return .ASDA }
    static var processDependentData: Key { return .ASDB }
#elseif _ptrauth(_none)
    static var processIndependentCode: Key { return Key(_value: 0) }
    static var processDependentCode: Key { return Key(_value: 0) }
    static var processIndependentData: Key { return Key(_value: 0) }
    static var processDependentData: Key { return Key(_value: 0) }
#else
  #error("unsupported ptrauth scheme")
#endif
  }
#if _ptrauth(_arm64e)
  static func blend(pointer: UnsafeRawPointer,
                    discriminator: UInt64) -> UInt64 {
    return UInt64(Builtin.int_ptrauth_blend(
                    UInt64(UInt(bitPattern: pointer))._value,
                    discriminator._value))
  }
  static func sign(pointer: UnsafeRawPointer,
                   key: Key,
                   discriminator: UInt64) -> UnsafeRawPointer {
    let bitPattern = UInt64(Builtin.int_ptrauth_sign(
      UInt64(UInt(bitPattern: pointer))._value,
      key._value._value,
      discriminator._value))
    return UnsafeRawPointer(bitPattern:
      UInt(truncatingIfNeeded: bitPattern)).unsafelyUnwrapped
  }
  static func authenticateAndResign(pointer: UnsafeRawPointer,
                                oldKey: Key,
                                oldDiscriminator: UInt64,
                                newKey: Key,
                                newDiscriminator: UInt64) -> UnsafeRawPointer {
    let bitPattern = UInt64(Builtin.int_ptrauth_resign(
      UInt64(UInt(bitPattern: pointer))._value,
      oldKey._value._value,
      oldDiscriminator._value,
      newKey._value._value,
      newDiscriminator._value))
    return UnsafeRawPointer(bitPattern:
      UInt(truncatingIfNeeded: bitPattern)).unsafelyUnwrapped
  }
  static func discriminator<T>(for type: T.Type) -> UInt64 {
    return UInt64(Builtin.typePtrAuthDiscriminator(type))
  }
#elseif _ptrauth(_none)
  static func blend(pointer _: UnsafeRawPointer,
                    discriminator _: UInt64) -> UInt64{
    return 0
  }
  static func sign(pointer: UnsafeRawPointer,
                   key: Key,
                   discriminator: UInt64) -> UnsafeRawPointer {
    return pointer
  }
  static func authenticateAndResign(pointer: UnsafeRawPointer,
                                oldKey: Key,
                                oldDiscriminator: UInt64,
                                newKey: Key,
                                newDiscriminator: UInt64) -> UnsafeRawPointer {
    return pointer
  }
  static func discriminator<T>(for type: T.Type) -> UInt64 {
    return 0
  }
#else
  #error("Unsupported ptrauth scheme")
#endif
}
extension UnsafeRawPointer {
  internal func _loadAddressDiscriminatedFunctionPointer<T>(
    fromByteOffset offset: Int = 0,
    as type: T.Type,
    discriminator: UInt64
  ) -> T {
    let src = self + offset
    let srcDiscriminator = _PtrAuth.blend(pointer: src,
                                          discriminator: discriminator)
    let ptr = src.load(as: UnsafeRawPointer.self)
    let resigned = _PtrAuth.authenticateAndResign(
      pointer: ptr,
      oldKey: .processIndependentCode,
      oldDiscriminator: srcDiscriminator,
      newKey: .processIndependentCode,
      newDiscriminator: _PtrAuth.discriminator(for: type))
    return unsafeBitCast(resigned, to: type)
  }
  internal func _loadAddressDiscriminatedFunctionPointer<T>(
    fromByteOffset offset: Int = 0,
    as type: Optional<T>.Type,
    discriminator: UInt64
  ) -> Optional<T> {
    let src = self + offset
    let srcDiscriminator = _PtrAuth.blend(pointer: src,
                                          discriminator: discriminator)
    guard let ptr = src.load(as: Optional<UnsafeRawPointer>.self) else {
      return nil
    }
    let resigned = _PtrAuth.authenticateAndResign(
      pointer: ptr,
      oldKey: .processIndependentCode,
      oldDiscriminator: srcDiscriminator,
      newKey: .processIndependentCode,
      newDiscriminator: _PtrAuth.discriminator(for: T.self))
    return .some(unsafeBitCast(resigned, to: T.self))
  }
}
extension UnsafeMutableRawPointer {
  internal func _copyAddressDiscriminatedFunctionPointer(
    from src: UnsafeRawPointer,
    discriminator: UInt64
  ) {
    if src == UnsafeRawPointer(self) { return }
    let srcDiscriminator = _PtrAuth.blend(pointer: src,
                                          discriminator: discriminator)
    let destDiscriminator = _PtrAuth.blend(pointer: self,
                                           discriminator: discriminator)
    let ptr = src.load(as: UnsafeRawPointer.self)
    let resigned = _PtrAuth.authenticateAndResign(
      pointer: ptr,
      oldKey: .processIndependentCode,
      oldDiscriminator: srcDiscriminator,
      newKey: .processIndependentCode,
      newDiscriminator: destDiscriminator)
    storeBytes(of: resigned, as: UnsafeRawPointer.self)
  }
  internal func _storeFunctionPointerWithAddressDiscrimination(
    _ unsignedPointer: UnsafeRawPointer,
    discriminator: UInt64
  ) {
    let destDiscriminator = _PtrAuth.blend(pointer: self,
                                           discriminator: discriminator)
    let signed = _PtrAuth.sign(pointer: unsignedPointer,
                               key: .processIndependentCode,
                               discriminator: destDiscriminator)
    storeBytes(of: signed, as: UnsafeRawPointer.self)
  }
}
