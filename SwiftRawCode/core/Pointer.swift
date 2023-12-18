#if SWIFT_ENABLE_REFLECTION
public typealias _CustomReflectableOrNone = CustomReflectable
#else
public typealias _CustomReflectableOrNone = Any
#endif
public protocol _Pointer
: Hashable, Strideable, CustomDebugStringConvertible, _CustomReflectableOrNone {
  typealias Distance = Int
  associatedtype Pointee
  var _rawValue: Builtin.RawPointer { get }
  init(_ _rawValue: Builtin.RawPointer)
}
extension _Pointer {
  public init(_ from: OpaquePointer) {
    self.init(from._rawValue)
  }
  public init?(_ from: OpaquePointer?) {
    guard let unwrapped = from else { return nil }
    self.init(unwrapped)
  }
  public init?(bitPattern: Int) {
    if bitPattern == 0 { return nil }
    self.init(Builtin.inttoptr_Word(bitPattern._builtinWordValue))
  }
  public init?(bitPattern: UInt) {
    if bitPattern == 0 { return nil }
    self.init(Builtin.inttoptr_Word(bitPattern._builtinWordValue))
  }
    self.init(other._rawValue)
  }
    guard let unwrapped = other else { return nil }
    self.init(unwrapped._rawValue)
  }
}
extension _Pointer  {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    return Bool(Builtin.cmp_eq_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func == <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_eq_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func != <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_ne_RawPointer(lhs._rawValue, rhs._rawValue))
  }
}
extension _Pointer  {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    return Bool(Builtin.cmp_ult_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func < <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_ult_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func <= <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_ule_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func > <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_ugt_RawPointer(lhs._rawValue, rhs._rawValue))
  }
  @inlinable
  public static func >= <Other: _Pointer>(lhs: Self, rhs: Other) -> Bool {
    return Bool(Builtin.cmp_uge_RawPointer(lhs._rawValue, rhs._rawValue))
  }
}
extension _Pointer  {
  public func successor() -> Self {
    return advanced(by: 1)
  }
  public func predecessor() -> Self {
    return advanced(by: -1)
  }
  public func distance(to end: Self) -> Int {
    return
      Int(Builtin.sub_Word(Builtin.ptrtoint_Word(end._rawValue),
                           Builtin.ptrtoint_Word(_rawValue)))
      / MemoryLayout<Pointee>.stride
  }
  public func advanced(by n: Int) -> Self {
    return Self(Builtin.gep_Word(
      self._rawValue, n._builtinWordValue, Pointee.self))
  }
}
extension _Pointer  {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    hasher.combine(UInt(bitPattern: self))
  }
  @inlinable
  public func _rawHashValue(seed: Int) -> Int {
    return Hasher._hash(seed: seed, UInt(bitPattern: self))
  }
}
extension _Pointer  {
  public var debugDescription: String {
    return _rawPointerToString(_rawValue)
  }
}
#if SWIFT_ENABLE_REFLECTION
extension _Pointer  {
  public var customMirror: Mirror {
    let ptrValue = UInt64(
      bitPattern: Int64(Int(Builtin.ptrtoint_Word(_rawValue))))
    return Mirror(self, children: ["pointerValue": ptrValue])
  }
}
#endif
extension Int {
  public init<P: _Pointer>(bitPattern pointer: P?) {
    if let pointer = pointer {
      self = Int(Builtin.ptrtoint_Word(pointer._rawValue))
    } else {
      self = 0
    }
  }
}
extension UInt {
  public init<P: _Pointer>(bitPattern pointer: P?) {
    if let pointer = pointer {
      self = UInt(Builtin.ptrtoint_Word(pointer._rawValue))
    } else {
      self = 0
    }
  }
}
extension Strideable where Self: _Pointer {
    return lhs.advanced(by: rhs)
  }
    return rhs.advanced(by: lhs)
  }
    return lhs.advanced(by: -rhs)
  }
  public static func - (lhs: Self, rhs: Self) -> Self.Stride {
    return rhs.distance(to: lhs)
  }
  public static func += (lhs: inout Self, rhs: Self.Stride) {
    lhs = lhs.advanced(by: rhs)
  }
  public static func -= (lhs: inout Self, rhs: Self.Stride) {
    lhs = lhs.advanced(by: -rhs)
  }
}
public 
func _convertPointerToPointerArgument<
  FromPointer: _Pointer,
  ToPointer: _Pointer
>(_ from: FromPointer) -> ToPointer {
  return ToPointer(from._rawValue)
}
public 
func _convertInOutToPointerArgument<
  ToPointer: _Pointer
>(_ from: Builtin.RawPointer) -> ToPointer {
  return ToPointer(from)
}
public 
func _convertConstArrayToPointerArgument<
  FromElement,
  ToPointer: _Pointer
>(_ arr: [FromElement]) -> (AnyObject?, ToPointer) {
  let (owner, opaquePointer) = arr._cPointerArgs()
  let validPointer: ToPointer
  if let addr = opaquePointer {
    validPointer = ToPointer(addr._rawValue)
  } else {
    let lastAlignedValue = ~(MemoryLayout<FromElement>.alignment - 1)
    let lastAlignedPointer = UnsafeRawPointer(bitPattern: lastAlignedValue)!
    validPointer = ToPointer(lastAlignedPointer._rawValue)
  }
  return (owner, validPointer)
}
public 
func _convertMutableArrayToPointerArgument<
  FromElement,
  ToPointer: _Pointer
>(_ a: inout [FromElement]) -> (AnyObject?, ToPointer) {
  a.reserveCapacity(0)
  _debugPrecondition(a._baseAddressIfContiguous != nil || a.isEmpty)
  return _convertConstArrayToPointerArgument(a)
}
public 
func _convertConstStringToUTF8PointerArgument<
  ToPointer: _Pointer
>(_ str: String) -> (AnyObject?, ToPointer) {
  let utf8 = Array(str.utf8CString)
  return _convertConstArrayToPointerArgument(utf8)
}
