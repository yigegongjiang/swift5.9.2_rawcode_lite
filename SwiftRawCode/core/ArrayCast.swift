internal func _arrayDownCastIndirect<SourceValue, TargetValue>(
  _ source: UnsafePointer<Array<SourceValue>>,
  _ target: UnsafeMutablePointer<Array<TargetValue>>) {
  target.initialize(to: _arrayForceCast(source.pointee))
}
@inlinable 
public func _arrayForceCast<SourceElement, TargetElement>(
  _ source: Array<SourceElement>
) -> Array<TargetElement> {
#if _runtime(_ObjC)
  if _isClassOrObjCExistential(SourceElement.self)
  && _isClassOrObjCExistential(TargetElement.self) {
    let src = source._buffer
    if let native = src.requestNativeBuffer() {
      if native.storesOnlyElementsOfType(TargetElement.self) {
        return Array(_buffer: src.cast(toBufferOf: TargetElement.self))
      }
      return Array(_buffer:
        src.downcast(toBufferWithDeferredTypeCheckOf: TargetElement.self))
    }
    return Array(_immutableCocoaArray: source._buffer._asCocoaArray())
  }
#endif
  return source.map { $0 as! TargetElement }
}
internal func _arrayDownCastConditionalIndirect<SourceValue, TargetValue>(
  _ source: UnsafePointer<Array<SourceValue>>,
  _ target: UnsafeMutablePointer<Array<TargetValue>>
) -> Bool {
  if let result: Array<TargetValue> = _arrayConditionalCast(source.pointee) {
    target.initialize(to: result)
    return true
  }
  return false
}
@inlinable 
public func _arrayConditionalCast<SourceElement, TargetElement>(
  _ source: [SourceElement]
) -> [TargetElement]? {
  var successfulCasts = ContiguousArray<TargetElement>()
  successfulCasts.reserveCapacity(source.count)
  for element in source {
    if let casted = element as? TargetElement {
      successfulCasts.append(casted)
    } else {
      return nil
    }
  }
  return Array(successfulCasts)
}
