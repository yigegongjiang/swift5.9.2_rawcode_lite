extension Set {
  @inline(__always)
  internal init?<C: Collection>(
    _mapping source: C,
    allowingDuplicates: Bool,
    transform: (C.Element) -> Element?
  ) {
    var target = _NativeSet<Element>(capacity: source.count)
    if allowingDuplicates {
      for m in source {
        guard let member = transform(m) else { return nil }
        target._unsafeUpdate(with: member)
      }
    } else {
      for m in source {
        guard let member = transform(m) else { return nil }
        target._unsafeInsertNew(member)
      }
    }
    self.init(_native: target)
  }
}
@inlinable
public func _setUpCast<DerivedValue, BaseValue>(
  _ source: Set<DerivedValue>
) -> Set<BaseValue> {
  return Set(
    _mapping: source,
    allowingDuplicates: (BaseValue.self == String.self)
  ) { member in
    (member as! BaseValue)
  }!
}
internal func _setDownCastIndirect<SourceValue, TargetValue>(
  _ source: UnsafePointer<Set<SourceValue>>,
  _ target: UnsafeMutablePointer<Set<TargetValue>>) {
  target.initialize(to: _setDownCast(source.pointee))
}
@inlinable
public func _setDownCast<BaseValue, DerivedValue>(_ source: Set<BaseValue>)
  -> Set<DerivedValue> {
#if _runtime(_ObjC)
  if _isClassOrObjCExistential(BaseValue.self)
  && _isClassOrObjCExistential(DerivedValue.self) {
    guard source._variant.isNative else {
      return Set(_immutableCocoaSet: source._variant.asCocoa.object)
    }
    return Set(_immutableCocoaSet: source._variant.asNative.bridged())
  }
#endif
  return Set(
    _mapping: source,
    allowingDuplicates: (DerivedValue.self == String.self)
  ) { member in
    (member as! DerivedValue)
  }!
}
internal func _setDownCastConditionalIndirect<SourceValue, TargetValue>(
  _ source: UnsafePointer<Set<SourceValue>>,
  _ target: UnsafeMutablePointer<Set<TargetValue>>
) -> Bool {
  if let result: Set<TargetValue> = _setDownCastConditional(source.pointee) {
    target.initialize(to: result)
    return true
  }
  return false
}
@inlinable
public func _setDownCastConditional<BaseValue, DerivedValue>(
  _ source: Set<BaseValue>
) -> Set<DerivedValue>? {
  return Set(
    _mapping: source,
    allowingDuplicates: (DerivedValue.self == String.self)
  ) { member in
    member as? DerivedValue
  }
}
