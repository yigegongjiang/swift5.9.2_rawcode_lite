public 
func _findStringSwitchCase(
  cases: [StaticString],
  string: String) -> Int {
  for (idx, s) in cases.enumerated() {
    if String(_builtinStringLiteral: s.utf8Start._rawValue,
              utf8CodeUnitCount: s._utf8CodeUnitCount,
              isASCII: s.isASCII._value) == string {
      return idx
    }
  }
  return -1
}
@frozen 
public 
struct _OpaqueStringSwitchCache {
  var a: Builtin.Word
  var b: Builtin.Word
}
internal typealias _StringSwitchCache = Dictionary<String, Int>
internal struct _StringSwitchContext {
  internal let cases: [StaticString]
  internal let cachePtr: UnsafeMutablePointer<_StringSwitchCache>
  internal init(
    cases: [StaticString],
    cachePtr: UnsafeMutablePointer<_StringSwitchCache>
  ){
    self.cases = cases
    self.cachePtr = cachePtr
  }
}
public 
func _findStringSwitchCaseWithCache(
  cases: [StaticString],
  string: String,
  cache: inout _OpaqueStringSwitchCache) -> Int {
#if $BuiltinUnprotectedAddressOf
  let ptr = UnsafeMutableRawPointer(Builtin.unprotectedAddressOf(&cache))
#else
  let ptr = UnsafeMutableRawPointer(Builtin.addressof(&cache))
#endif
  let oncePtr = ptr
  let cacheRawPtr = oncePtr + MemoryLayout<Builtin.Word>.stride
  let cachePtr = cacheRawPtr.bindMemory(to: _StringSwitchCache.self, capacity: 1)
  var context = _StringSwitchContext(cases: cases, cachePtr: cachePtr)
  withUnsafeMutablePointer(to: &context) { (context) -> () in
    Builtin.onceWithContext(oncePtr._rawValue, _createStringTableCache,
                            context._rawValue)
  }
  let cache = cachePtr.pointee;
  if let idx = cache[string] {
    return idx
  }
  return -1
}
internal func _createStringTableCache(_ cacheRawPtr: Builtin.RawPointer) {
  let context = UnsafePointer<_StringSwitchContext>(cacheRawPtr).pointee
  var cache = _StringSwitchCache()
  cache.reserveCapacity(context.cases.count)
  _internalInvariant(
    MemoryLayout<_StringSwitchCache>.size <= MemoryLayout<Builtin.Word>.size)
  for (idx, s) in context.cases.enumerated() {
    let key = String(_builtinStringLiteral: s.utf8Start._rawValue,
                     utf8CodeUnitCount: s._utf8CodeUnitCount,
                     isASCII: s.isASCII._value)
    cache[key] = idx
  }
  context.cachePtr.initialize(to: cache)
}
