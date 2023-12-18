public 
func _isPowerOf2(_ x: UInt) -> Bool {
  if x == 0 {
    return false
  }
  return x & (x &- 1) == 0
}
public 
func _isPowerOf2(_ x: Int) -> Bool {
  if x <= 0 {
    return false
  }
  return x & (x &- 1) == 0
}
#if _runtime(_ObjC)
public func _autorelease(_ x: AnyObject) {
  Builtin.retain(x)
  Builtin.autorelease(x)
}
#endif
@available(SwiftStdlib 5.7, *)
public 
func _getFunctionFullNameFromMangledNameImpl(
  _ mangledName: UnsafePointer<UInt8>, _ mangledNameLength: UInt
) -> (UnsafePointer<UInt8>, UInt)
@available(SwiftStdlib 5.7, *)
public 
func _getFunctionFullNameFromMangledName(mangledName: String) -> String? {
  let mangledNameUTF8 = Array(mangledName.utf8)
  let (stringPtr, count) =
    mangledNameUTF8.withUnsafeBufferPointer { (mangledNameUTF8) in
    return _getFunctionFullNameFromMangledNameImpl(
      mangledNameUTF8.baseAddress!,
      UInt(mangledNameUTF8.endIndex))
  }
  guard count > 0 else {
    return nil
  }
  return String._fromUTF8Repairing(
    UnsafeBufferPointer(start: stringPtr, count: Int(count))).0
}
public func _getTypeName(_ type: Any.Type, qualified: Bool)
  -> (UnsafePointer<UInt8>, Int)
public 
func _typeName(_ type: Any.Type, qualified: Bool = true) -> String {
  let (stringPtr, count) = _getTypeName(type, qualified: qualified)
  return String._fromUTF8Repairing(
    UnsafeBufferPointer(start: stringPtr, count: count)).0
}
@available(SwiftStdlib 5.3, *)
public func _getMangledTypeName(_ type: Any.Type)
  -> (UnsafePointer<UInt8>, Int)
@available(SwiftStdlib 5.3, *)
public 
func _mangledTypeName(_ type: Any.Type) -> String? {
  let (stringPtr, count) = _getMangledTypeName(type)
  guard count > 0 else {
    return nil
  }
  let (result, repairsMade) = String._fromUTF8Repairing(
      UnsafeBufferPointer(start: stringPtr, count: count))
  _precondition(!repairsMade, "repairs made to _mangledTypeName, this is not expected since names should be valid UTF-8")
  return result
}
public 
func _typeByName(_ name: String) -> Any.Type? {
  let nameUTF8 = Array(name.utf8)
  return nameUTF8.withUnsafeBufferPointer { (nameUTF8) in
    return  _getTypeByMangledNameUntrusted(nameUTF8.baseAddress!,
                                  UInt(nameUTF8.endIndex))
  }
}
internal func _getTypeByMangledNameUntrusted(
  _ name: UnsafePointer<UInt8>,
  _ nameLength: UInt)
  -> Any.Type?
public func _getTypeByMangledNameInEnvironment(
  _ name: UnsafePointer<UInt8>,
  _ nameLength: UInt,
  genericEnvironment: UnsafeRawPointer?,
  genericArguments: UnsafeRawPointer?)
  -> Any.Type?
public func _getTypeByMangledNameInContext(
  _ name: UnsafePointer<UInt8>,
  _ nameLength: UInt,
  genericContext: UnsafeRawPointer?,
  genericArguments: UnsafeRawPointer?)
  -> Any.Type?
public func _unsafePerformance<T>(_ c: () -> T) -> T {
  return c()
}
@available(*, unavailable)
