import Swift
@propertyWrapper
@available(SwiftStdlib 5.1, *)
public final class TaskLocal<Value: Sendable>: Sendable, CustomStringConvertible {
  let defaultValue: Value
  public init(wrappedValue defaultValue: Value) {
    self.defaultValue = defaultValue
  }
  var key: Builtin.RawPointer {
    unsafeBitCast(self, to: Builtin.RawPointer.self)
  }
  public func get() -> Value {
    guard let rawValue = _taskLocalValueGet(key: key) else {
      return self.defaultValue
    }
    let storagePtr =
        rawValue.bindMemory(to: Value.self, capacity: 1)
    return UnsafeMutablePointer<Value>(mutating: storagePtr).pointee
  }
  @discardableResult
  @available(SwiftStdlib 5.1, *) 
  public func withValue<R>(_ valueDuringOperation: Value, operation: () async throws -> R,
                           file: String = #fileID, line: UInt = #line) async rethrows -> R {
    return try await withValueImpl(valueDuringOperation, operation: operation, file: file, line: line)
  }
  @inlinable
  @discardableResult
  @available(SwiftStdlib 5.1, *) 
  internal func withValueImpl<R>(_ valueDuringOperation: __owned Value, operation: () async throws -> R,
                                 file: String = #fileID, line: UInt = #line) async rethrows -> R {
    _checkIllegalTaskLocalBindingWithinWithTaskGroup(file: file, line: line)
    _taskLocalValuePush(key: key, value: valueDuringOperation)
    do {
      let result = try await operation()
      _taskLocalValuePop()
      return result
    } catch {
      _taskLocalValuePop()
      throw error
    }
  }
  @inlinable
  @discardableResult
  public func withValue<R>(_ valueDuringOperation: Value, operation: () throws -> R,
                           file: String = #fileID, line: UInt = #line) rethrows -> R {
    _checkIllegalTaskLocalBindingWithinWithTaskGroup(file: file, line: line)
    _taskLocalValuePush(key: key, value: valueDuringOperation)
    defer { _taskLocalValuePop() }
    return try operation()
  }
  public var projectedValue: TaskLocal<Value> {
    get {
      self
    }
    @available(*, unavailable, message: "use '$myTaskLocal.withValue(_:do:)' instead")
    set {
      fatalError("Illegal attempt to set a \(Self.self) value, use `withValue(...) { ... }` instead.")
    }
  }
  @available(*, unavailable, message: "property wrappers cannot be instance members")
  public static subscript(
    _enclosingInstance object: Never,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<Never, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<Never, TaskLocal<Value>>
  ) -> Value {
    get {
      fatalError("Will never be executed, since enclosing instance is Never")
    }
  }
  public var wrappedValue: Value {
    self.get()
  }
  public var description: String {
    "\(Self.self)(defaultValue: \(self.defaultValue))"
  }
}
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _taskLocalValuePush<Value>(
  key: Builtin.RawPointer,
  value: __owned Value
) 
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _taskLocalValuePop()
@available(SwiftStdlib 5.1, *)
func _taskLocalValueGet(
  key: Builtin.RawPointer
) -> UnsafeMutableRawPointer? 
@available(SwiftStdlib 5.1, *)
func _taskLocalsCopy(
  to target: Builtin.NativeObject
)
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _checkIllegalTaskLocalBindingWithinWithTaskGroup(file: String, line: UInt) {
  if _taskHasTaskGroupStatusRecord() {
    file.withCString { _fileStart in
      _reportIllegalTaskLocalBindingWithinWithTaskGroup(
          _fileStart, file.count, true, line)
    }
  }
}
@available(SwiftStdlib 5.1, *)
@usableFromInline
func _reportIllegalTaskLocalBindingWithinWithTaskGroup(
  _ _filenameStart: UnsafePointer<Int8>,
  _ _filenameLength: Int,
  _ _filenameIsASCII: Bool,
  _ _line: UInt)
