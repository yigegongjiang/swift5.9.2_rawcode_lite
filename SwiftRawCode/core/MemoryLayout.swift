@frozen 
public enum MemoryLayout<T> {
  public static var size: Int {
    return Int(Builtin.sizeof(T.self))
  }
  public static var stride: Int {
    return Int(Builtin.strideof(T.self))
  }
  public static var alignment: Int {
    return Int(Builtin.alignof(T.self))
  }
}
extension MemoryLayout {
  public static func size(ofValue value: T) -> Int {
    return MemoryLayout.size
  }
  public static func stride(ofValue value: T) -> Int {
    return MemoryLayout.stride
  }
  public static func alignment(ofValue value: T) -> Int {
    return MemoryLayout.alignment
  }
  public static func offset(of key: PartialKeyPath<T>) -> Int? {
    return key._storedInlineOffset
  }
}
extension MemoryLayout {
  internal static var _alignmentMask: Int { return alignment - 1 }
  internal static func _roundingUpToAlignment(_ value: Int) -> Int {
    return (value + _alignmentMask) & ~_alignmentMask
  }
  internal static func _roundingDownToAlignment(_ value: Int) -> Int {
    return value & ~_alignmentMask
  }
  internal static func _roundingUpToAlignment(_ value: UInt) -> UInt {
    return (value + UInt(bitPattern: _alignmentMask)) & ~UInt(bitPattern: _alignmentMask)
  }
  internal static func _roundingDownToAlignment(_ value: UInt) -> UInt {
    return value & ~UInt(bitPattern: _alignmentMask)
  }
  internal static func _roundingUpToAlignment(_ value: UnsafeRawPointer) -> UnsafeRawPointer {
    return UnsafeRawPointer(bitPattern:
     _roundingUpToAlignment(UInt(bitPattern: value))).unsafelyUnwrapped
  }
  internal static func _roundingDownToAlignment(_ value: UnsafeRawPointer) -> UnsafeRawPointer {
    return UnsafeRawPointer(bitPattern:
     _roundingDownToAlignment(UInt(bitPattern: value))).unsafelyUnwrapped
  }
  internal static func _roundingUpToAlignment(_ value: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(bitPattern:
     _roundingUpToAlignment(UInt(bitPattern: value))).unsafelyUnwrapped
  }
  internal static func _roundingDownToAlignment(_ value: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(bitPattern:
     _roundingDownToAlignment(UInt(bitPattern: value))).unsafelyUnwrapped
  }
  internal static func _roundingUpBaseToAlignment(_ value: UnsafeRawBufferPointer) -> UnsafeRawBufferPointer {
    let baseAddressBits = Int(bitPattern: value.baseAddress)
    var misalignment = baseAddressBits & _alignmentMask
    if misalignment != 0 {
      misalignment = _alignmentMask & -misalignment
      return UnsafeRawBufferPointer(
        start: UnsafeRawPointer(bitPattern: baseAddressBits + misalignment),
        count: value.count - misalignment)
    }
    return value
  }
  internal static func _roundingUpBaseToAlignment(_ value: UnsafeMutableRawBufferPointer) -> UnsafeMutableRawBufferPointer {
    let baseAddressBits = Int(bitPattern: value.baseAddress)
    var misalignment = baseAddressBits & _alignmentMask
    if misalignment != 0 {
      misalignment = _alignmentMask & -misalignment
      return UnsafeMutableRawBufferPointer(
        start: UnsafeMutableRawPointer(bitPattern: baseAddressBits + misalignment),
        count: value.count - misalignment)
    }
    return value
  }
}
