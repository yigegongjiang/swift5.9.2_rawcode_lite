extension Dictionary {
  @inline(__always)
  internal init?<C: Collection>(
    _mapping source: C,
    allowingDuplicates: Bool,
    transform: (C.Element) -> (key: Key, value: Value)?
  ) {
    var target = _NativeDictionary<Key, Value>(capacity: source.count)
    if allowingDuplicates {
      for member in source {
        guard let (key, value) = transform(member) else { return nil }
        target._unsafeUpdate(key: key, value: value)
      }
    } else {
      for member in source {
        guard let (key, value) = transform(member) else { return nil }
        target._unsafeInsertNew(key: key, value: value)
      }
    }
    self.init(_native: target)
  }
}
@inlinable
public func _dictionaryUpCast<DerivedKey, DerivedValue, BaseKey, BaseValue>(
    _ source: Dictionary<DerivedKey, DerivedValue>
) -> Dictionary<BaseKey, BaseValue> {
  return Dictionary(
    _mapping: source,
    allowingDuplicates: (BaseKey.self == String.self)
  ) { k, v in
    (k as! BaseKey, v as! BaseValue)
  }!
}
internal func _dictionaryDownCastIndirect<SourceKey, SourceValue,
                                          TargetKey, TargetValue>(
  _ source: UnsafePointer<Dictionary<SourceKey, SourceValue>>,
  _ target: UnsafeMutablePointer<Dictionary<TargetKey, TargetValue>>) {
  target.initialize(to: _dictionaryDownCast(source.pointee))
}
@inlinable
public func _dictionaryDownCast<BaseKey, BaseValue, DerivedKey, DerivedValue>(
  _ source: Dictionary<BaseKey, BaseValue>
) -> Dictionary<DerivedKey, DerivedValue> {
#if _runtime(_ObjC)
  if _isClassOrObjCExistential(BaseKey.self)
  && _isClassOrObjCExistential(BaseValue.self)
  && _isClassOrObjCExistential(DerivedKey.self)
  && _isClassOrObjCExistential(DerivedValue.self) {
    guard source._variant.isNative else {
      return Dictionary(
        _immutableCocoaDictionary: source._variant.asCocoa.object)
    }
    return Dictionary(
      _immutableCocoaDictionary: source._variant.asNative.bridged())
  }
#endif
  return Dictionary(
    _mapping: source,
    allowingDuplicates: (DerivedKey.self == String.self)
  ) { k, v in
    (k as! DerivedKey, v as! DerivedValue)
  }!
}
internal func _dictionaryDownCastConditionalIndirect<SourceKey, SourceValue,
                                                     TargetKey, TargetValue>(
  _ source: UnsafePointer<Dictionary<SourceKey, SourceValue>>,
  _ target: UnsafeMutablePointer<Dictionary<TargetKey, TargetValue>>
) -> Bool {
  if let result: Dictionary<TargetKey, TargetValue>
       = _dictionaryDownCastConditional(source.pointee) {
    target.initialize(to: result)
    return true
  }
  return false
}
@inlinable
public func _dictionaryDownCastConditional<
  BaseKey, BaseValue, DerivedKey, DerivedValue
>(
  _ source: Dictionary<BaseKey, BaseValue>
) -> Dictionary<DerivedKey, DerivedValue>? {
  return Dictionary(
    _mapping: source,
    allowingDuplicates: (DerivedKey.self == String.self)
  ) { k, v in
    guard
      let key = k as? DerivedKey,
      let value = v as? DerivedValue
    else {
      return nil
    }
    return (key, value)
  }
}
