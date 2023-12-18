@inlinable
public func withExtendedLifetime<T, Result>(
  _ x: T, _ body: () throws -> Result
) rethrows -> Result {
  defer { _fixLifetime(x) }
  return try body()
}
@inlinable
public func withExtendedLifetime<T, Result>(
  _ x: T, _ body: (T) throws -> Result
) rethrows -> Result {
  defer { _fixLifetime(x) }
  return try body(x)
}
public func _fixLifetime<T>(_ x: T) {
  Builtin.fixLifetime(x)
}
@inlinable
public func withUnsafeMutablePointer<T, Result>(
  to value: inout T,
  _ body: (UnsafeMutablePointer<T>) throws -> Result
) rethrows -> Result
{
  return try body(UnsafeMutablePointer<T>(Builtin.addressof(&value)))
}
public func _withUnprotectedUnsafeMutablePointer<T, Result>(
  to value: inout T,
  _ body: (UnsafeMutablePointer<T>) throws -> Result
) rethrows -> Result
{
#if $BuiltinUnprotectedAddressOf
  return try body(UnsafeMutablePointer<T>(Builtin.unprotectedAddressOf(&value)))
#else
  return try body(UnsafeMutablePointer<T>(Builtin.addressof(&value)))
#endif
}
@inlinable
public func withUnsafePointer<T, Result>(
  to value: T,
  _ body: (UnsafePointer<T>) throws -> Result
) rethrows -> Result
{
  return try body(UnsafePointer<T>(Builtin.addressOfBorrow(value)))
}
@inlinable
public func withUnsafePointer<T, Result>(
  to value: inout T,
  _ body: (UnsafePointer<T>) throws -> Result
) rethrows -> Result
{
  return try body(UnsafePointer<T>(Builtin.addressof(&value)))
}
public func _withUnprotectedUnsafePointer<T, Result>(
  to value: inout T,
  _ body: (UnsafePointer<T>) throws -> Result
) rethrows -> Result
{
#if $BuiltinUnprotectedAddressOf
  return try body(UnsafePointer<T>(Builtin.unprotectedAddressOf(&value)))
#else
  return try body(UnsafePointer<T>(Builtin.addressof(&value)))
#endif
}
extension String {
  @inlinable 
  public func withCString<Result>(
    _ body: (UnsafePointer<Int8>) throws -> Result
  ) rethrows -> Result {
    return try _guts.withCString(body)
  }
}
@inlinable
public func _copy<T>(_ value: T) -> T {
  #if $BuiltinCopy
    Builtin.copy(value)
  #else
    value
  #endif
}
