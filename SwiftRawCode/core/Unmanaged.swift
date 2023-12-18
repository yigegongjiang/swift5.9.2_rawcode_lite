@frozen
public struct Unmanaged<Instance: AnyObject> {
  @usableFromInline
  internal unowned(unsafe) var _value: Instance
  internal init(_private: Instance) { _value = _private }
  public static func fromOpaque(
  ) -> Unmanaged {
    return Unmanaged(_private: unsafeBitCast(value, to: Instance.self))
  }
  public func toOpaque() -> UnsafeMutableRawPointer {
    return unsafeBitCast(_value, to: UnsafeMutableRawPointer.self)
  }
  public static func passRetained(_ value: Instance) -> Unmanaged {
    Builtin.retain(value)
    return Unmanaged(_private: value)
  }
  public static func passUnretained(_ value: Instance) -> Unmanaged {
    return Unmanaged(_private: value)
  }
  public func takeUnretainedValue() -> Instance {
    return _value
  }
  public func takeRetainedValue() -> Instance {
    let result = _value
    release()
    return result
  }
  @inlinable 
  public func _withUnsafeGuaranteedRef<Result>(
    _ body: (Instance) throws -> Result
  ) rethrows -> Result {
    var tmp = self
    let fakeBase: Int? = nil
    return try body(Builtin.convertUnownedUnsafeToGuaranteed(fakeBase,
                                                             &tmp._value))
  }
  public func retain() -> Unmanaged {
    Builtin.retain(_value)
    return self
  }
  public func release() {
    Builtin.release(_value)
  }
#if _runtime(_ObjC)
  public func autorelease() -> Unmanaged {
    Builtin.autorelease(_value)
    return self
  }
#endif
}
extension Unmanaged: Sendable where Instance: Sendable { }
