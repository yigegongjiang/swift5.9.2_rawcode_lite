import SwiftShims
internal func _byteCountForTemporaryAllocation<T>(
  of type: T.Type,
  capacity: Int
) -> Int {
  if _isComputed(capacity) {
    _precondition(capacity >= 0, "Allocation capacity must be greater than or equal to zero")
  }
  let stride = MemoryLayout<T>.stride
  let (byteCount, overflow) = capacity.multipliedReportingOverflow(by: stride)
  if _isComputed(capacity) {
    _precondition(!overflow, "Allocation byte count too large")
  }
  return byteCount
}
internal func _isStackAllocationSafe(byteCount: Int, alignment: Int) -> Bool {
#if compiler(>=5.5) && $BuiltinStackAlloc
  if _isComputed(alignment) {
    _precondition(alignment > 0, "Alignment value must be greater than zero")
    _precondition(_isPowerOf2(alignment), "Alignment value must be a power of two")
  }
  if alignment > _minAllocationAlignment() {
    return false
  }
  if byteCount <= 1024 {
    return true
  }
  guard #available(macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4, *) 
  else {
    return false
  }
  return swift_stdlib_isStackAllocationSafe(byteCount, alignment)
#else
  fatalError("unsupported compiler")
#endif
}
internal func _withUnsafeTemporaryAllocation<T, R>(
  of type: T.Type,
  capacity: Int,
  alignment: Int,
  _ body: (Builtin.RawPointer) throws -> R
) rethrows -> R {
  let byteCount = _byteCountForTemporaryAllocation(of: type, capacity: capacity)
  guard _isStackAllocationSafe(byteCount: byteCount, alignment: alignment) else {
    return try _fallBackToHeapAllocation(byteCount: byteCount, alignment: alignment, body)
  }
  let result: R
#if compiler(>=5.5) && $BuiltinStackAlloc
  let stackAddress = Builtin.stackAlloc(
    capacity._builtinWordValue,
    MemoryLayout<T>.stride._builtinWordValue,
    alignment._builtinWordValue
  )
  do {
    result = try body(stackAddress)
    Builtin.stackDealloc(stackAddress)
    return result
  } catch {
    Builtin.stackDealloc(stackAddress)
    throw error
  }
#else
  fatalError("unsupported compiler")
#endif
}
internal func _withUnprotectedUnsafeTemporaryAllocation<T, R>(
  of type: T.Type,
  capacity: Int,
  alignment: Int,
  _ body: (Builtin.RawPointer) throws -> R
) rethrows -> R {
  let byteCount = _byteCountForTemporaryAllocation(of: type, capacity: capacity)
  guard _isStackAllocationSafe(byteCount: byteCount, alignment: alignment) else {
    return try _fallBackToHeapAllocation(byteCount: byteCount, alignment: alignment, body)
  }
  let result: R
#if $BuiltinUnprotectedStackAlloc
  let stackAddress = Builtin.unprotectedStackAlloc(
    capacity._builtinWordValue,
    MemoryLayout<T>.stride._builtinWordValue,
    alignment._builtinWordValue
  )
#else
  let stackAddress = Builtin.stackAlloc(
    capacity._builtinWordValue,
    MemoryLayout<T>.stride._builtinWordValue,
    alignment._builtinWordValue
  )
#endif
  do {
    result = try body(stackAddress)
    Builtin.stackDealloc(stackAddress)
    return result
  } catch {
    Builtin.stackDealloc(stackAddress)
    throw error
  }
}
internal func _fallBackToHeapAllocation<R>(
  byteCount: Int,
  alignment: Int,
  _ body: (Builtin.RawPointer) throws -> R
) rethrows -> R {
  let buffer = UnsafeMutableRawPointer.allocate(
    byteCount: byteCount,
    alignment: alignment
  )
  defer {
    buffer.deallocate()
  }
  return try body(buffer._rawValue)
}
public func withUnsafeTemporaryAllocation<R>(
  byteCount: Int,
  alignment: Int,
  _ body: (UnsafeMutableRawBufferPointer) throws -> R
) rethrows -> R {
  return try _withUnsafeTemporaryAllocation(
    of: Int8.self,
    capacity: byteCount,
    alignment: alignment
  ) { pointer in
    let buffer = UnsafeMutableRawBufferPointer(
      start: .init(pointer),
      count: byteCount
    )
    return try body(buffer)
  }
}
public func _withUnprotectedUnsafeTemporaryAllocation<R>(
  byteCount: Int,
  alignment: Int,
  _ body: (UnsafeMutableRawBufferPointer) throws -> R
) rethrows -> R {
  return try _withUnprotectedUnsafeTemporaryAllocation(
    of: Int8.self,
    capacity: byteCount,
    alignment: alignment
  ) { pointer in
    let buffer = UnsafeMutableRawBufferPointer(
      start: .init(pointer),
      count: byteCount
    )
    return try body(buffer)
  }
}
public func withUnsafeTemporaryAllocation<T, R>(
  of type: T.Type,
  capacity: Int,
  _ body: (UnsafeMutableBufferPointer<T>) throws -> R
) rethrows -> R {
  return try _withUnsafeTemporaryAllocation(
    of: type,
    capacity: capacity,
    alignment: MemoryLayout<T>.alignment
  ) { pointer in
    Builtin.bindMemory(pointer, capacity._builtinWordValue, type)
    let buffer = UnsafeMutableBufferPointer<T>(
      start: .init(pointer),
      count: capacity
    )
    return try body(buffer)
  }
}
public func _withUnprotectedUnsafeTemporaryAllocation<T, R>(
  of type: T.Type,
  capacity: Int,
  _ body: (UnsafeMutableBufferPointer<T>) throws -> R
) rethrows -> R {
  return try _withUnprotectedUnsafeTemporaryAllocation(
    of: type,
    capacity: capacity,
    alignment: MemoryLayout<T>.alignment
  ) { pointer in
    Builtin.bindMemory(pointer, capacity._builtinWordValue, type)
    let buffer = UnsafeMutableBufferPointer<T>(
      start: .init(pointer),
      count: capacity
    )
    return try body(buffer)
  }
}
