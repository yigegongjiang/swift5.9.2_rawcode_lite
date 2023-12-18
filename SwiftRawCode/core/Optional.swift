@frozen
public enum Optional<Wrapped>: ExpressibleByNilLiteral {
  case none
  case some(Wrapped)
  public init(_ some: Wrapped) { self = .some(some) }
  @inlinable
  public func map<U>(
    _ transform: (Wrapped) throws -> U
  ) rethrows -> U? {
    switch self {
    case .some(let y):
      return .some(try transform(y))
    case .none:
      return .none
    }
  }
  @inlinable
  public func flatMap<U>(
    _ transform: (Wrapped) throws -> U?
  ) rethrows -> U? {
    switch self {
    case .some(let y):
      return try transform(y)
    case .none:
      return .none
    }
  }
  public init(nilLiteral: ()) {
    self = .none
  }
  @inlinable
  public var unsafelyUnwrapped: Wrapped {
    @inline(__always)
    get {
      if let x = self {
        return x
      }
      _debugPreconditionFailure("unsafelyUnwrapped of nil optional")
    }
  }
  @inlinable
  internal var _unsafelyUnwrappedUnchecked: Wrapped {
    @inline(__always)
    get {
      if let x = self {
        return x
      }
      _internalInvariantFailure("_unsafelyUnwrappedUnchecked of nil optional")
    }
  }
  internal mutating func _take() -> Wrapped? {
    switch self {
    case .some(let wrapped):
      self = nil
      return wrapped
    case .none:
      return nil
    }
  }
}
extension Optional: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .some(let value):
#if !SWIFT_STDLIB_STATIC_PRINT
      var result = "Optional("
      debugPrint(value, terminator: "", to: &result)
      result += ")"
      return result
#else
    return "(optional printing not available)"
#endif
    case .none:
      return "nil"
    }
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Optional: CustomReflectable {
  public var customMirror: Mirror {
    switch self {
    case .some(let value):
      return Mirror(
        self,
        children: [ "some": value ],
        displayStyle: .optional)
    case .none:
      return Mirror(self, children: [:], displayStyle: .optional)
    }
  }
}
#endif
public 
func _diagnoseUnexpectedNilOptional(_filenameStart: Builtin.RawPointer,
                                    _filenameLength: Builtin.Word,
                                    _filenameIsASCII: Builtin.Int1,
                                    _line: Builtin.Word,
                                    _isImplicitUnwrap: Builtin.Int1) {
  if Bool(_isImplicitUnwrap) {
    _preconditionFailure(
      "Unexpectedly found nil while implicitly unwrapping an Optional value",
      file: StaticString(_start: _filenameStart,
                         utf8CodeUnitCount: _filenameLength,
                         isASCII: _filenameIsASCII),
      line: UInt(_line))
  } else {
    _preconditionFailure(
      "Unexpectedly found nil while unwrapping an Optional value",
      file: StaticString(_start: _filenameStart,
                         utf8CodeUnitCount: _filenameLength,
                         isASCII: _filenameIsASCII),
      line: UInt(_line))
  }
}
extension Optional: Equatable where Wrapped: Equatable {
  public static func ==(lhs: Wrapped?, rhs: Wrapped?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
      return l == r
    case (nil, nil):
      return true
    default:
      return false
    }
  }
}
extension Optional: Hashable where Wrapped: Hashable {
  @inlinable
  public func hash(into hasher: inout Hasher) {
    switch self {
    case .none:
      hasher.combine(0 as UInt8)
    case .some(let wrapped):
      hasher.combine(1 as UInt8)
      hasher.combine(wrapped)
    }
  }
}
@frozen
public struct _OptionalNilComparisonType: ExpressibleByNilLiteral {
  public init(nilLiteral: ()) {
  }
}
extension Optional {
  public static func ~=(lhs: _OptionalNilComparisonType, rhs: Wrapped?) -> Bool {
    switch rhs {
    case .some:
      return false
    case .none:
      return true
    }
  }
  public static func ==(lhs: Wrapped?, rhs: _OptionalNilComparisonType) -> Bool {
    switch lhs {
    case .some:
      return false
    case .none:
      return true
    }
  }
  public static func !=(lhs: Wrapped?, rhs: _OptionalNilComparisonType) -> Bool {
    switch lhs {
    case .some:
      return true
    case .none:
      return false
    }
  }
  public static func ==(lhs: _OptionalNilComparisonType, rhs: Wrapped?) -> Bool {
    switch rhs {
    case .some:
      return false
    case .none:
      return true
    }
  }
  public static func !=(lhs: _OptionalNilComparisonType, rhs: Wrapped?) -> Bool {
    switch rhs {
    case .some:
      return true
    case .none:
      return false
    }
  }
}
public func ?? <T>(optional: T?, defaultValue: @autoclosure () throws -> T)
    rethrows -> T {
  switch optional {
  case .some(let value):
    return value
  case .none:
    return try defaultValue()
  }
}
public func ?? <T>(optional: T?, defaultValue: @autoclosure () throws -> T?)
    rethrows -> T? {
  switch optional {
  case .some(let value):
    return value
  case .none:
    return try defaultValue()
  }
}
#if _runtime(_ObjC)
extension Optional: _ObjectiveCBridgeable {
  internal static var _nilSentinel: AnyObject {
    get
  }
  public func _bridgeToObjectiveC() -> AnyObject {
    if let value = self {
      return _bridgeAnythingToObjectiveC(value)
    }
    return type(of: self)._nilSentinel
  }
  public static func _forceBridgeFromObjectiveC(
    _ source: AnyObject,
    result: inout Optional<Wrapped>?
  ) {
    if source === _nilSentinel {
      result = .some(.none)
      return
    }
    let unwrappedResult = source as! Wrapped
    result = .some(.some(unwrappedResult))
  }
  public static func _conditionallyBridgeFromObjectiveC(
    _ source: AnyObject,
    result: inout Optional<Wrapped>?
  ) -> Bool {
    if source === _nilSentinel {
      result = .some(.none)
      return true
    }
    if let unwrappedResult = source as? Wrapped {
      result = .some(.some(unwrappedResult))
      return true
    } else {
      result = .none
      return false
    }
  }
  public static func _unconditionallyBridgeFromObjectiveC(_ source: AnyObject?)
      -> Optional<Wrapped> {
    if let nonnullSource = source {
      if nonnullSource === _nilSentinel {
        return .none
      } else {
        return .some(nonnullSource as! Wrapped)
      }
    } else {
      return .none
    }
  }
}
#endif
extension Optional: Sendable where Wrapped: Sendable { }
