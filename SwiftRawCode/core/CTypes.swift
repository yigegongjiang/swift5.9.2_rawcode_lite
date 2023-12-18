public typealias CChar = Int8
public typealias CUnsignedChar = UInt8
public typealias CUnsignedShort = UInt16
public typealias CUnsignedInt = UInt32
#if os(Windows) && (arch(x86_64) || arch(arm64))
public typealias CUnsignedLong = UInt32
#else
public typealias CUnsignedLong = UInt
#endif
public typealias CUnsignedLongLong = UInt64
public typealias CSignedChar = Int8
public typealias CShort = Int16
public typealias CInt = Int32
#if os(Windows) && (arch(x86_64) || arch(arm64))
public typealias CLong = Int32
#else
public typealias CLong = Int
#endif
public typealias CLongLong = Int64
#if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(SwiftStdlib 5.3, *)
public typealias CFloat16 = Float16
#endif
public typealias CFloat = Float
public typealias CDouble = Double
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
#if arch(x86_64) || arch(i386)
public typealias CLongDouble = Float80
#else
public typealias CLongDouble = Double
#endif
#elseif os(Windows)
public typealias CLongDouble = Double
#elseif os(Linux)
#if arch(x86_64) || arch(i386)
public typealias CLongDouble = Float80
#elseif arch(s390x)
public typealias CLongDouble = Double
#endif
#elseif os(Android)
#if arch(arm)
public typealias CLongDouble = Double
#endif
#elseif os(OpenBSD)
#if arch(x86_64)
public typealias CLongDouble = Float80
#else
#error("CLongDouble needs to be defined for this OpenBSD architecture")
#endif
#elseif os(FreeBSD)
#if arch(x86_64) || arch(i386)
public typealias CLongDouble = Float80
#else
#error("CLongDouble needs to be defined for this FreeBSD architecture")
#endif
#else
#endif
public typealias CWideChar = Unicode.Scalar
public typealias CChar16 = UInt16
public typealias CChar32 = Unicode.Scalar
public typealias CBool = Bool
@frozen
public struct OpaquePointer {
  @usableFromInline
  internal var _rawValue: Builtin.RawPointer
  internal init(_ v: Builtin.RawPointer) {
    self._rawValue = v
  }
  public init?(bitPattern: Int) {
    if bitPattern == 0 { return nil }
    self._rawValue = Builtin.inttoptr_Word(bitPattern._builtinWordValue)
  }
  public init?(bitPattern: UInt) {
    if bitPattern == 0 { return nil }
    self._rawValue = Builtin.inttoptr_Word(bitPattern._builtinWordValue)
  }
    self._rawValue = from._rawValue
  }
    guard let unwrapped = from else { return nil }
    self.init(unwrapped)
  }
    self._rawValue = from._rawValue
  }
    guard let unwrapped = from else { return nil }
    self.init(unwrapped)
  }
}
extension OpaquePointer: Equatable {
  @inlinable 
  public static func == (lhs: OpaquePointer, rhs: OpaquePointer) -> Bool {
    return Bool(Builtin.cmp_eq_RawPointer(lhs._rawValue, rhs._rawValue))
  }
}
extension OpaquePointer: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(Int(Builtin.ptrtoint_Word(_rawValue)))
  }
}
extension OpaquePointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return _rawPointerToString(_rawValue)
  }
}
extension Int {
  @inlinable 
  public init(bitPattern pointer: OpaquePointer?) {
    self.init(bitPattern: UnsafeRawPointer(pointer))
  }
}
extension UInt {
  @inlinable 
  public init(bitPattern pointer: OpaquePointer?) {
    self.init(bitPattern: UnsafeRawPointer(pointer))
  }
}
#if arch(arm64) && !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(Windows))
@frozen
public struct CVaListPointer {
  @usableFromInline 
  internal var _value: (__stack: UnsafeMutablePointer<Int>?,
                        __gr_top: UnsafeMutablePointer<Int>?,
                        __vr_top: UnsafeMutablePointer<Int>?,
                        __gr_off: Int32,
                        __vr_off: Int32)
  @inlinable 
  public 
  init(__stack: UnsafeMutablePointer<Int>?,
       __gr_top: UnsafeMutablePointer<Int>?,
       __vr_top: UnsafeMutablePointer<Int>?,
       __gr_off: Int32,
       __vr_off: Int32) {
    _value = (__stack, __gr_top, __vr_top, __gr_off, __vr_off)
  }
}
extension CVaListPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "(\(_value.__stack.debugDescription), " +
           "\(_value.__gr_top.debugDescription), " +
           "\(_value.__vr_top.debugDescription), " +
           "\(_value.__gr_off), " +
           "\(_value.__vr_off))"
  }
}
#else
@frozen
public struct CVaListPointer {
  @usableFromInline 
  internal var _value: UnsafeMutableRawPointer
  @inlinable 
  public 
  init(_fromUnsafeMutablePointer from: UnsafeMutableRawPointer) {
    _value = from
  }
}
extension CVaListPointer: CustomDebugStringConvertible {
  public var debugDescription: String {
    return _value.debugDescription
  }
}
#endif
@inlinable
internal func _memcpy(
  dest destination: UnsafeMutableRawPointer,
  src: UnsafeRawPointer,
  size: UInt
) {
  let dest = destination._rawValue
  let src = src._rawValue
  let size = UInt64(size)._value
  Builtin.int_memcpy_RawPointer_RawPointer_Int64(
    dest, src, size,
     false._value)
}
@inlinable
internal func _memmove(
  dest destination: UnsafeMutableRawPointer,
  src: UnsafeRawPointer,
  size: UInt
) {
  let dest = destination._rawValue
  let src = src._rawValue
  let size = UInt64(size)._value
  Builtin.int_memmove_RawPointer_RawPointer_Int64(
    dest, src, size,
     false._value)
}
