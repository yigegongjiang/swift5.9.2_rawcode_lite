import SwiftShims
internal func _abstract(
  methodName: StaticString = #function,
  file: StaticString = #file, line: UInt = #line
) -> Never {
#if INTERNAL_CHECKS_ENABLED
  _fatalErrorMessage("abstract method", methodName, file: file, line: line,
      flags: _fatalErrorFlags())
#else
  _conditionallyUnreachable()
#endif
}
public class AnyKeyPath: Hashable, _AppendKeyPath {
  @inlinable
  public static var rootType: Any.Type {
    return _rootAndValueType.root
  }
  @inlinable
  public static var valueType: Any.Type {
    return _rootAndValueType.value
  }
  internal final var _kvcKeyPathStringPtr: UnsafePointer<CChar>?
  final public var hashValue: Int {
    return _hashValue(for: self)
  }
  final public func hash(into hasher: inout Hasher) {
    ObjectIdentifier(type(of: self)).hash(into: &hasher)
    return withBuffer {
      var buffer = $0
      if buffer.data.isEmpty { return }
      while true {
        let (component, type) = buffer.next()
        hasher.combine(component.value)
        if let type = type {
          hasher.combine(unsafeBitCast(type, to: Int.self))
        } else {
          break
        }
      }
    }
  }
  public static func ==(a: AnyKeyPath, b: AnyKeyPath) -> Bool {
    if a === b {
      return true
    }
    if type(of: a) != type(of: b) {
      return false
    }
    return a.withBuffer {
      var aBuffer = $0
      return b.withBuffer {
        var bBuffer = $0
        if aBuffer.hasReferencePrefix != bBuffer.hasReferencePrefix {
          return false
        }
        if aBuffer.data.isEmpty {
          return bBuffer.data.isEmpty
        }
        while true {
          let (aComponent, aType) = aBuffer.next()
          let (bComponent, bType) = bBuffer.next()
          if aComponent.header.endOfReferencePrefix
              != bComponent.header.endOfReferencePrefix
            || aComponent.value != bComponent.value
            || aType != bType {
            return false
          }
          if aType == nil {
            return true
          }
        }
      }
    }
  }
  /*
  The following pertains to 32-bit architectures only.
  We assume everything is a valid pointer to a potential
  _kvcKeyPathStringPtr except for the first 4KB page which is reserved
  for the nil pointer. Note that we have to distinguish between a valid
  keypath offset of 0, and the nil pointer itself.
  We use maximumOffsetOn32BitArchitecture + 1 for this case.
  The variable maximumOffsetOn32BitArchitecture is duplicated in the two
  functions below since having it as a global would make accesses slower,
  given getOffsetFromStorage() gets called on each KeyPath read. Further,
  having it as an instance variable in AnyKeyPath would increase the size
  of AnyKeyPath by 8 bytes.
  TODO: Find a better method of refactoring this variable if possible.
  */
  func assignOffsetToStorage(offset: Int) {
    let maximumOffsetOn32BitArchitecture = 4094
    guard offset >= 0 else {
      return
    }
    let architectureSize = MemoryLayout<Int>.size
    if architectureSize == 8 {
      _kvcKeyPathStringPtr = UnsafePointer<CChar>(bitPattern: -offset - 1)
    }
    else {
      if offset <= maximumOffsetOn32BitArchitecture {
        _kvcKeyPathStringPtr = UnsafePointer<CChar>(bitPattern: (offset + 1))
      }
      else {
        _kvcKeyPathStringPtr = nil
      }
    }
  }
  func getOffsetFromStorage() -> Int? {
    let maximumOffsetOn32BitArchitecture = 4094
    guard _kvcKeyPathStringPtr != nil else {
      return nil
    }
    let architectureSize = MemoryLayout<Int>.size
    if architectureSize == 8 {
      let offset = -Int(bitPattern: _kvcKeyPathStringPtr) - 1
      guard offset >= 0 else {
        return nil
      }
      return offset
    }
    else {
      let offset = Int(bitPattern: _kvcKeyPathStringPtr) - 1
      if (offset >= 0 && offset <= maximumOffsetOn32BitArchitecture) {
        return offset
      }
      return nil
    }
  }
  public var _kvcKeyPathString: String? {
    get {
      guard self.getOffsetFromStorage() == nil else {
        return nil
      }
      guard let ptr = _kvcKeyPathStringPtr else { return nil }
      return String(validatingUTF8: ptr)
    }
  }
  @available(*, unavailable)
  internal init() {
    _internalInvariantFailure("use _create(...)")
  }
  @usableFromInline
  internal class var _rootAndValueType: (root: Any.Type, value: Any.Type) {
    _abstract()
  }
  internal static func _create(
    capacityInBytes bytes: Int,
    initializedBy body: (UnsafeMutableRawBufferPointer) -> Void
  ) -> Self {
    _internalInvariant(bytes > 0 && bytes % 4 == 0,
                 "capacity must be multiple of 4 bytes")
    let result = Builtin.allocWithTailElems_1(self, (bytes/4)._builtinWordValue,
                                              Int32.self)
    result._kvcKeyPathStringPtr = nil
    let base = UnsafeMutableRawPointer(Builtin.projectTailElems(result,
                                                                Int32.self))
    body(UnsafeMutableRawBufferPointer(start: base, count: bytes))
    return result
  }
  final internal func withBuffer<T>(_ f: (KeyPathBuffer) throws -> T) rethrows -> T {
    defer { _fixLifetime(self) }
    let base = UnsafeRawPointer(Builtin.projectTailElems(self, Int32.self))
    return try f(KeyPathBuffer(base: base))
  }
  @usableFromInline 
  internal var _storedInlineOffset: Int? {
    return withBuffer {
      var buffer = $0
      if buffer.data.isEmpty { return 0 }
      var offset = 0
      while true {
        let (rawComponent, optNextType) = buffer.next()
        switch rawComponent.header.kind {
        case .struct:
          offset += rawComponent._structOrClassOffset
        case .class, .computed, .optionalChain, .optionalForce, .optionalWrap, .external:
          return .none
        }
        if optNextType == nil { return .some(offset) }
      }
    }
  }
}
public class PartialKeyPath<Root>: AnyKeyPath { }
internal enum KeyPathKind { case readOnly, value, reference }
public class KeyPath<Root, Value>: PartialKeyPath<Root> {
  @usableFromInline
  internal final override class var _rootAndValueType: (
    root: Any.Type,
    value: Any.Type
  ) {
    return (Root.self, Value.self)
  }
  internal typealias Kind = KeyPathKind
  internal class var kind: Kind { return .readOnly }
  internal static func appendedType<AppendedValue>(
    with t: KeyPath<Value, AppendedValue>.Type
  ) -> KeyPath<Root, AppendedValue>.Type {
    let resultKind: Kind
    switch (self.kind, t.kind) {
    case (_, .reference):
      resultKind = .reference
    case (let x, .value):
      resultKind = x
    default:
      resultKind = .readOnly
    }
    switch resultKind {
    case .readOnly:
      return KeyPath<Root, AppendedValue>.self
    case .value:
      return WritableKeyPath.self
    case .reference:
      return ReferenceWritableKeyPath.self
    }
  }
  @usableFromInline
  internal final func _projectReadOnly(from root: Root) -> Value {
    if let offset = getOffsetFromStorage() {
      return withUnsafeBytes(of: root) {
        let pointer = $0.baseAddress.unsafelyUnwrapped.advanced(by: offset)
        return pointer.assumingMemoryBound(to: Value.self).pointee
      }
    }
    var curBase: Any = root
    return withBuffer {
      var buffer = $0
      if buffer.data.isEmpty {
        return unsafeBitCast(root, to: Value.self)
      }
      while true {
        let (rawComponent, optNextType) = buffer.next()
        let valueType = optNextType ?? Value.self
        let isLast = optNextType == nil
        func project<CurValue>(_ base: CurValue) -> Value? {
          func project2<NewValue>(_: NewValue.Type) -> Value? {
            switch rawComponent._projectReadOnly(base,
              to: NewValue.self, endingWith: Value.self) {
            case .continue(let newBase):
              if isLast {
                _internalInvariant(NewValue.self == Value.self,
                             "key path does not terminate in correct type")
                return unsafeBitCast(newBase, to: Value.self)
              } else {
                curBase = newBase
                return nil
              }
            case .break(let result):
              return result
            }
          }
          return _openExistential(valueType, do: project2)
        }
        if let result = _openExistential(curBase, do: project) {
          return result
        }
      }
    }
  }
  deinit {
    withBuffer { $0.destroy() }
  }
}
public class WritableKeyPath<Root, Value>: KeyPath<Root, Value> {
  internal override class var kind: Kind { return .value }
  @usableFromInline
  internal func _projectMutableAddress(from base: UnsafePointer<Root>)
      -> (pointer: UnsafeMutablePointer<Value>, owner: AnyObject?) {
    if let offset = getOffsetFromStorage()
    {
      let p = UnsafeRawPointer(base).advanced(by: offset)
      return (pointer: UnsafeMutablePointer(
        mutating: p.assumingMemoryBound(to: Value.self)), owner: nil)
    }
    var p = UnsafeRawPointer(base)
    var type: Any.Type = Root.self
    var keepAlive: AnyObject?
    return withBuffer {
      var buffer = $0
      _internalInvariant(!buffer.hasReferencePrefix,
                   "WritableKeyPath should not have a reference prefix")
      if buffer.data.isEmpty {
        return (
          UnsafeMutablePointer<Value>(
            mutating: p.assumingMemoryBound(to: Value.self)),
          nil)
      }
      while true {
        let (rawComponent, optNextType) = buffer.next()
        let nextType = optNextType ?? Value.self
        func project<CurValue>(_: CurValue.Type) {
          func project2<NewValue>(_: NewValue.Type) {
            p = rawComponent._projectMutableAddress(p,
                                           from: CurValue.self,
                                           to: NewValue.self,
                                           isRoot: p == UnsafeRawPointer(base),
                                           keepAlive: &keepAlive)
          }
          _openExistential(nextType, do: project2)
        }
        _openExistential(type, do: project)
        if optNextType == nil { break }
        type = nextType
      }
      let typedPointer = p.assumingMemoryBound(to: Value.self)
      return (pointer: UnsafeMutablePointer(mutating: typedPointer),
              owner: keepAlive)
    }
  }
}
public class ReferenceWritableKeyPath<
  Root, Value
>: WritableKeyPath<Root, Value> {
  internal final override class var kind: Kind { return .reference }
  @usableFromInline
  internal final func _projectMutableAddress(from origBase: Root)
      -> (pointer: UnsafeMutablePointer<Value>, owner: AnyObject?) {
    var keepAlive: AnyObject?
    let address: UnsafeMutablePointer<Value> = withBuffer {
      var buffer = $0
      var base: Any = origBase
      while buffer.hasReferencePrefix {
        let (rawComponent, optNextType) = buffer.next()
        _internalInvariant(optNextType != nil,
                     "reference prefix should not go to end of buffer")
        let nextType = optNextType.unsafelyUnwrapped
        func project<NewValue>(_: NewValue.Type) -> Any {
          func project2<CurValue>(_ base: CurValue) -> Any {
            return rawComponent._projectReadOnly(
              base, to: NewValue.self, endingWith: Value.self)
              .assumingContinue
          }
          return _openExistential(base, do: project2)
        }
        base = _openExistential(nextType, do: project)
      }
      func formalMutation<MutationRoot>(_ base: MutationRoot)
          -> UnsafeMutablePointer<Value> {
        var base2 = base
        return withUnsafeBytes(of: &base2) { baseBytes in
          var p = baseBytes.baseAddress.unsafelyUnwrapped
          var curType: Any.Type = MutationRoot.self
          while true {
            let (rawComponent, optNextType) = buffer.next()
            let nextType = optNextType ?? Value.self
            func project<CurValue>(_: CurValue.Type) {
              func project2<NewValue>(_: NewValue.Type) {
                p = rawComponent._projectMutableAddress(p,
                                             from: CurValue.self,
                                             to: NewValue.self,
                                             isRoot: p == baseBytes.baseAddress,
                                             keepAlive: &keepAlive)
              }
              _openExistential(nextType, do: project2)
            }
            _openExistential(curType, do: project)
            if optNextType == nil { break }
            curType = nextType
          }
          let typedPointer = p.assumingMemoryBound(to: Value.self)
          return UnsafeMutablePointer(mutating: typedPointer)
        }
      }
      return _openExistential(base, do: formalMutation)
    }
    return (address, keepAlive)
  }
}
internal enum KeyPathComponentKind {
  case external
  case `struct`
  case `class`
  case computed
  case optionalChain
  case optionalForce
  case optionalWrap
}
internal struct ComputedPropertyID: Hashable {
  internal var value: Int
  internal var kind: KeyPathComputedIDKind
  internal static func ==(
    x: ComputedPropertyID, y: ComputedPropertyID
  ) -> Bool {
    return x.value == y.value
      && x.kind == y.kind
  }
  internal func hash(into hasher: inout Hasher) {
    hasher.combine(value)
    hasher.combine(kind)
  }
}
internal struct ComputedAccessorsPtr {
#if INTERNAL_CHECKS_ENABLED
  internal let header: RawKeyPathComponent.Header
#endif
  internal let _value: UnsafeRawPointer
  init(header: RawKeyPathComponent.Header, value: UnsafeRawPointer) {
#if INTERNAL_CHECKS_ENABLED
    self.header = header
#endif
    self._value = value
  }
  static var getterPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_Getter)
  }
  static var nonmutatingSetterPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_NonmutatingSetter)
  }
  static var mutatingSetterPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_MutatingSetter)
  }
  internal typealias Getter<CurValue, NewValue> = @convention(thin)
    (CurValue, UnsafeRawPointer, Int) -> NewValue
  internal typealias NonmutatingSetter<CurValue, NewValue> = @convention(thin)
    (NewValue, CurValue, UnsafeRawPointer, Int) -> ()
  internal typealias MutatingSetter<CurValue, NewValue> = @convention(thin)
    (NewValue, inout CurValue, UnsafeRawPointer, Int) -> ()
  internal var getterPtr: UnsafeRawPointer {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(header.kind == .computed,
                 "not a computed property")
#endif
    return _value
  }
  internal var setterPtr: UnsafeRawPointer {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(header.isComputedSettable,
                 "not a settable property")
#endif
    return _value + MemoryLayout<Int>.size
  }
  internal func getter<CurValue, NewValue>()
      -> Getter<CurValue, NewValue> {
    return getterPtr._loadAddressDiscriminatedFunctionPointer(
      as: Getter.self,
      discriminator: ComputedAccessorsPtr.getterPtrAuthKey)
  }
  internal func nonmutatingSetter<CurValue, NewValue>()
      -> NonmutatingSetter<CurValue, NewValue> {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(header.isComputedSettable && !header.isComputedMutating,
                 "not a nonmutating settable property")
#endif
    return setterPtr._loadAddressDiscriminatedFunctionPointer(
      as: NonmutatingSetter.self,
      discriminator: ComputedAccessorsPtr.nonmutatingSetterPtrAuthKey)
  }
  internal func mutatingSetter<CurValue, NewValue>()
      -> MutatingSetter<CurValue, NewValue> {
#if INTERNAL_CHECKS_ENABLED
    _internalInvariant(header.isComputedSettable && header.isComputedMutating,
                 "not a mutating settable property")
#endif
    return setterPtr._loadAddressDiscriminatedFunctionPointer(
      as: MutatingSetter.self,
      discriminator: ComputedAccessorsPtr.mutatingSetterPtrAuthKey)
  }
}
internal struct ComputedArgumentWitnessesPtr {
  internal let _value: UnsafeRawPointer
  init(_ value: UnsafeRawPointer) {
    self._value = value
  }
  static var destroyPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentDestroy)
  }
  static var copyPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentCopy)
  }
  static var equalsPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentEquals)
  }
  static var hashPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentHash)
  }
  static var layoutPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentLayout)
  }
  static var initPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_ArgumentInit)
  }
  internal typealias Destroy = @convention(thin)
    (_ instanceArguments: UnsafeMutableRawPointer, _ size: Int) -> ()
  internal typealias Copy = @convention(thin)
    (_ srcInstanceArguments: UnsafeRawPointer,
     _ destInstanceArguments: UnsafeMutableRawPointer,
     _ size: Int) -> ()
  internal typealias Equals = @convention(thin)
    (_ xInstanceArguments: UnsafeRawPointer,
     _ yInstanceArguments: UnsafeRawPointer,
     _ size: Int) -> Bool
  internal typealias Hash = @convention(thin)
    (_ instanceArguments: UnsafeRawPointer,
     _ size: Int) -> Int
  internal var destroy: Destroy? {
    return _value._loadAddressDiscriminatedFunctionPointer(
      as: Optional<Destroy>.self,
      discriminator: ComputedArgumentWitnessesPtr.destroyPtrAuthKey)
  }
  internal var copy: Copy {
    return _value._loadAddressDiscriminatedFunctionPointer(
      fromByteOffset: MemoryLayout<UnsafeRawPointer>.size,
      as: Copy.self,
      discriminator: ComputedArgumentWitnessesPtr.copyPtrAuthKey)
  }
  internal var equals: Equals {
    return _value._loadAddressDiscriminatedFunctionPointer(
      fromByteOffset: 2*MemoryLayout<UnsafeRawPointer>.size,
      as: Equals.self,
      discriminator: ComputedArgumentWitnessesPtr.equalsPtrAuthKey)
  }
  internal var hash: Hash {
    return _value._loadAddressDiscriminatedFunctionPointer(
      fromByteOffset: 3*MemoryLayout<UnsafeRawPointer>.size,
      as: Hash.self,
      discriminator: ComputedArgumentWitnessesPtr.hashPtrAuthKey)
  }
}
internal enum KeyPathComponent: Hashable {
  internal struct ArgumentRef {
    internal var data: UnsafeRawBufferPointer
    internal var witnesses: ComputedArgumentWitnessesPtr
    internal var witnessSizeAdjustment: Int
    internal init(
      data: UnsafeRawBufferPointer,
      witnesses: ComputedArgumentWitnessesPtr,
      witnessSizeAdjustment: Int
    ) {
      self.data = data
      self.witnesses = witnesses
      self.witnessSizeAdjustment = witnessSizeAdjustment
    }
  }
  case `struct`(offset: Int)
  case `class`(offset: Int)
  case get(id: ComputedPropertyID,
           accessors: ComputedAccessorsPtr,
           argument: ArgumentRef?)
  case mutatingGetSet(id: ComputedPropertyID,
                      accessors: ComputedAccessorsPtr,
                      argument: ArgumentRef?)
  case nonmutatingGetSet(id: ComputedPropertyID,
                         accessors: ComputedAccessorsPtr,
                         argument: ArgumentRef?)
  case optionalChain
  case optionalForce
  case optionalWrap
  internal static func ==(a: KeyPathComponent, b: KeyPathComponent) -> Bool {
    switch (a, b) {
    case (.struct(offset: let a), .struct(offset: let b)),
         (.class (offset: let a), .class (offset: let b)):
      return a == b
    case (.optionalChain, .optionalChain),
         (.optionalForce, .optionalForce),
         (.optionalWrap, .optionalWrap):
      return true
    case (.get(id: let id1, accessors: _, argument: let argument1),
          .get(id: let id2, accessors: _, argument: let argument2)),
         (.mutatingGetSet(id: let id1, accessors: _, argument: let argument1),
          .mutatingGetSet(id: let id2, accessors: _, argument: let argument2)),
         (.nonmutatingGetSet(id: let id1, accessors: _, argument: let argument1),
          .nonmutatingGetSet(id: let id2, accessors: _, argument: let argument2)):
      if id1 != id2 {
        return false
      }
      if let arg1 = argument1, let arg2 = argument2 {
        return arg1.witnesses.equals(
          arg1.data.baseAddress.unsafelyUnwrapped,
          arg2.data.baseAddress.unsafelyUnwrapped,
          arg1.data.count - arg1.witnessSizeAdjustment)
      }
      return true
    case (.struct, _),
         (.class,  _),
         (.optionalChain, _),
         (.optionalForce, _),
         (.optionalWrap, _),
         (.get, _),
         (.mutatingGetSet, _),
         (.nonmutatingGetSet, _):
      return false
    }
  }
  internal func hash(into hasher: inout Hasher) {
    func appendHashFromArgument(
      _ argument: KeyPathComponent.ArgumentRef?
    ) {
      if let argument = argument {
        let hash = argument.witnesses.hash(
          argument.data.baseAddress.unsafelyUnwrapped,
          argument.data.count - argument.witnessSizeAdjustment)
        if hash != 0 {
          hasher.combine(hash)
        }
      }
    }
    switch self {
    case .struct(offset: let a):
      hasher.combine(0)
      hasher.combine(a)
    case .class(offset: let b):
      hasher.combine(1)
      hasher.combine(b)
    case .optionalChain:
      hasher.combine(2)
    case .optionalForce:
      hasher.combine(3)
    case .optionalWrap:
      hasher.combine(4)
    case .get(id: let id, accessors: _, argument: let argument):
      hasher.combine(5)
      hasher.combine(id)
      appendHashFromArgument(argument)
    case .mutatingGetSet(id: let id, accessors: _, argument: let argument):
      hasher.combine(6)
      hasher.combine(id)
      appendHashFromArgument(argument)
    case .nonmutatingGetSet(id: let id, accessors: _, argument: let argument):
      hasher.combine(7)
      hasher.combine(id)
      appendHashFromArgument(argument)
    }
  }
}
internal final class ClassHolder<ProjectionType> {
  internal typealias AccessRecord = Builtin.UnsafeValueBuffer
  internal var previous: AnyObject?
  internal var instance: AnyObject
  internal init(previous: AnyObject?, instance: AnyObject) {
    self.previous = previous
    self.instance = instance
  }
  internal final class func _create(
      previous: AnyObject?,
      instance: AnyObject,
      accessingAddress address: UnsafeRawPointer,
      type: ProjectionType.Type
  ) -> ClassHolder {
    let holder: ClassHolder = Builtin.allocWithTailElems_1(self,
                                                          1._builtinWordValue,
                                                          AccessRecord.self)
    withUnsafeMutablePointer(to: &holder.previous) {
      $0.initialize(to: previous)
    }
    withUnsafeMutablePointer(to: &holder.instance) {
      $0.initialize(to: instance)
    }
    let accessRecordPtr = Builtin.projectTailElems(holder, AccessRecord.self)
    Builtin.beginUnpairedModifyAccess(address._rawValue, accessRecordPtr, type)
    return holder
  }
  deinit {
    let accessRecordPtr = Builtin.projectTailElems(self, AccessRecord.self)
    Builtin.endUnpairedAccess(accessRecordPtr)
  }
}
internal final class MutatingWritebackBuffer<CurValue, NewValue> {
  internal let previous: AnyObject?
  internal let base: UnsafeMutablePointer<CurValue>
  internal let set: ComputedAccessorsPtr.MutatingSetter<CurValue, NewValue>
  internal let argument: UnsafeRawPointer
  internal let argumentSize: Int
  internal var value: NewValue
  deinit {
    set(value, &base.pointee, argument, argumentSize)
  }
  internal init(previous: AnyObject?,
       base: UnsafeMutablePointer<CurValue>,
       set: @escaping ComputedAccessorsPtr.MutatingSetter<CurValue, NewValue>,
       argument: UnsafeRawPointer,
       argumentSize: Int,
       value: NewValue) {
    self.previous = previous
    self.base = base
    self.set = set
    self.argument = argument
    self.argumentSize = argumentSize
    self.value = value
  }
}
internal final class NonmutatingWritebackBuffer<CurValue, NewValue> {
  internal let previous: AnyObject?
  internal let base: CurValue
  internal let set: ComputedAccessorsPtr.NonmutatingSetter<CurValue, NewValue>
  internal let argument: UnsafeRawPointer
  internal let argumentSize: Int
  internal var value: NewValue
  deinit {
    set(value, base, argument, argumentSize)
  }
  internal
  init(previous: AnyObject?,
       base: CurValue,
       set: @escaping ComputedAccessorsPtr.NonmutatingSetter<CurValue, NewValue>,
       argument: UnsafeRawPointer,
       argumentSize: Int,
       value: NewValue) {
    self.previous = previous
    self.base = base
    self.set = set
    self.argument = argument
    self.argumentSize = argumentSize
    self.value = value
  }
}
internal typealias KeyPathComputedArgumentLayoutFn = @convention(thin)
  (_ patternArguments: UnsafeRawPointer?) -> (size: Int, alignmentMask: Int)
internal typealias KeyPathComputedArgumentInitializerFn = @convention(thin)
  (_ patternArguments: UnsafeRawPointer?,
   _ instanceArguments: UnsafeMutableRawPointer) -> ()
internal enum KeyPathComputedIDKind {
  case pointer
  case storedPropertyIndex
  case vtableOffset
}
internal enum KeyPathComputedIDResolution {
  case resolved
  case resolvedAbsolute
  case indirectPointer
  case functionCall
}
internal struct RawKeyPathComponent {
  internal var header: Header
  internal var body: UnsafeRawBufferPointer
  internal init(header: Header, body: UnsafeRawBufferPointer) {
    self.header = header
    self.body = body
  }
  static var metadataAccessorPtrAuthKey: UInt64 {
    return UInt64(_SwiftKeyPath_ptrauth_MetadataAccessor)
  }
  internal struct Header {
    internal var _value: UInt32
    init(discriminator: UInt32, payload: UInt32) {
      _value = 0
      self.discriminator = discriminator
      self.payload = payload
    }
    internal var discriminator: UInt32 {
      get {
        return (_value & Header.discriminatorMask) >> Header.discriminatorShift
      }
      set {
        let shifted = newValue << Header.discriminatorShift
        _internalInvariant(shifted & Header.discriminatorMask == shifted,
                     "discriminator doesn't fit")
        _value = _value & ~Header.discriminatorMask | shifted
      }
    }
    internal var payload: UInt32 {
      get {
        return _value & Header.payloadMask
      }
      set {
        _internalInvariant(newValue & Header.payloadMask == newValue,
                     "payload too big")
        _value = _value & ~Header.payloadMask | newValue
      }
    }
    internal var storedOffsetPayload: UInt32 {
      get {
        _internalInvariant(kind == .struct || kind == .class,
                     "not a stored component")
        return _value & Header.storedOffsetPayloadMask
      }
      set {
        _internalInvariant(kind == .struct || kind == .class,
                     "not a stored component")
        _internalInvariant(newValue & Header.storedOffsetPayloadMask == newValue,
                     "payload too big")
        _value = _value & ~Header.storedOffsetPayloadMask | newValue
      }
    }
    internal var endOfReferencePrefix: Bool {
      get {
        return _value & Header.endOfReferencePrefixFlag != 0
      }
      set {
        if newValue {
          _value |= Header.endOfReferencePrefixFlag
        } else {
          _value &= ~Header.endOfReferencePrefixFlag
        }
      }
    }
    internal var kind: KeyPathComponentKind {
      switch (discriminator, payload) {
      case (Header.externalTag, _):
        return .external
      case (Header.structTag, _):
        return .struct
      case (Header.classTag, _):
        return .class
      case (Header.computedTag, _):
        return .computed
      case (Header.optionalTag, Header.optionalChainPayload):
        return .optionalChain
      case (Header.optionalTag, Header.optionalWrapPayload):
        return .optionalWrap
      case (Header.optionalTag, Header.optionalForcePayload):
        return .optionalForce
      default:
        _internalInvariantFailure("invalid header")
      }
    }
    internal static var payloadMask: UInt32 {
      return _SwiftKeyPathComponentHeader_PayloadMask
    }
    internal static var discriminatorMask: UInt32 {
      return _SwiftKeyPathComponentHeader_DiscriminatorMask
    }
    internal static var discriminatorShift: UInt32 {
      return _SwiftKeyPathComponentHeader_DiscriminatorShift
    }
    internal static var externalTag: UInt32 {
      return _SwiftKeyPathComponentHeader_ExternalTag
    }
    internal static var structTag: UInt32 {
      return _SwiftKeyPathComponentHeader_StructTag
    }
    internal static var computedTag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedTag
    }
    internal static var classTag: UInt32 {
      return _SwiftKeyPathComponentHeader_ClassTag
    }
    internal static var optionalTag: UInt32 {
      return _SwiftKeyPathComponentHeader_OptionalTag
    }
    internal static var optionalChainPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_OptionalChainPayload
    }
    internal static var optionalWrapPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_OptionalWrapPayload
    }
    internal static var optionalForcePayload: UInt32 {
      return _SwiftKeyPathComponentHeader_OptionalForcePayload
    }
    internal static var endOfReferencePrefixFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_EndOfReferencePrefixFlag
    }
    internal static var storedMutableFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_StoredMutableFlag
    }
    internal static var storedOffsetPayloadMask: UInt32 {
      return _SwiftKeyPathComponentHeader_StoredOffsetPayloadMask
    }
    internal static var outOfLineOffsetPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_OutOfLineOffsetPayload
    }
    internal static var unresolvedFieldOffsetPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_UnresolvedFieldOffsetPayload
    }
    internal static var unresolvedIndirectOffsetPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_UnresolvedIndirectOffsetPayload
    }
    internal static var maximumOffsetPayload: UInt32 {
      return _SwiftKeyPathComponentHeader_MaximumOffsetPayload
    }
    internal var isStoredMutable: Bool {
      _internalInvariant(kind == .struct || kind == .class)
      return _value & Header.storedMutableFlag != 0
    }
    internal static var computedMutatingFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedMutatingFlag
    }
    internal var isComputedMutating: Bool {
      _internalInvariant(kind == .computed)
      return _value & Header.computedMutatingFlag != 0
    }
    internal static var computedSettableFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedSettableFlag
    }
    internal var isComputedSettable: Bool {
      _internalInvariant(kind == .computed)
      return _value & Header.computedSettableFlag != 0
    }
    internal static var computedIDByStoredPropertyFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDByStoredPropertyFlag
    }
    internal static var computedIDByVTableOffsetFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDByVTableOffsetFlag
    }
    internal var computedIDKind: KeyPathComputedIDKind {
      let storedProperty = _value & Header.computedIDByStoredPropertyFlag != 0
      let vtableOffset = _value & Header.computedIDByVTableOffsetFlag != 0
      switch (storedProperty, vtableOffset) {
      case (true, true):
        _internalInvariantFailure("not allowed")
      case (true, false):
        return .storedPropertyIndex
      case (false, true):
        return .vtableOffset
      case (false, false):
        return .pointer
      }
    }
    internal static var computedHasArgumentsFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedHasArgumentsFlag
    }
    internal var hasComputedArguments: Bool {
      _internalInvariant(kind == .computed)
      return _value & Header.computedHasArgumentsFlag != 0
    }
    internal static var computedInstantiatedFromExternalWithArgumentsFlag: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedInstantiatedFromExternalWithArgumentsFlag
    }
    internal var isComputedInstantiatedFromExternalWithArguments: Bool {
      get {
        _internalInvariant(kind == .computed)
        return
          _value & Header.computedInstantiatedFromExternalWithArgumentsFlag != 0
      }
      set {
        _internalInvariant(kind == .computed)
        _value =
            _value & ~Header.computedInstantiatedFromExternalWithArgumentsFlag
          | (newValue ? Header.computedInstantiatedFromExternalWithArgumentsFlag
                      : 0)
      }
    }
    internal static var externalWithArgumentsExtraSize: Int {
      return MemoryLayout<Int>.size
    }
    internal static var computedIDResolutionMask: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDResolutionMask
    }
    internal static var computedIDResolved: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDResolved
    }
    internal static var computedIDResolvedAbsolute: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDResolvedAbsolute
    }
    internal static var computedIDUnresolvedIndirectPointer: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDUnresolvedIndirectPointer
    }
    internal static var computedIDUnresolvedFunctionCall: UInt32 {
      return _SwiftKeyPathComponentHeader_ComputedIDUnresolvedFunctionCall
    }
    internal var computedIDResolution: KeyPathComputedIDResolution {
      switch payload & Header.computedIDResolutionMask {
      case Header.computedIDResolved:
        return .resolved
      case Header.computedIDResolvedAbsolute:
        return .resolvedAbsolute
      case Header.computedIDUnresolvedIndirectPointer:
        return .indirectPointer
      case Header.computedIDUnresolvedFunctionCall:
        return .functionCall
      default:
        _internalInvariantFailure("invalid key path resolution")
      }
    }
    internal static var pointerAlignmentSkew: Int {
      return MemoryLayout<Int>.size - MemoryLayout<Int32>.size
    }
    internal var isTrivialPropertyDescriptor: Bool {
      return _value ==
        _SwiftKeyPathComponentHeader_TrivialPropertyDescriptorMarker
    }
    internal var patternComponentBodySize: Int {
      return _componentBodySize(forPropertyDescriptor: false)
    }
    internal var propertyDescriptorBodySize: Int {
      if isTrivialPropertyDescriptor { return 0 }
      return _componentBodySize(forPropertyDescriptor: true)
    }
    internal func _componentBodySize(forPropertyDescriptor: Bool) -> Int {
      switch kind {
      case .struct, .class:
        if storedOffsetPayload == Header.unresolvedFieldOffsetPayload
           || storedOffsetPayload == Header.outOfLineOffsetPayload
           || storedOffsetPayload == Header.unresolvedIndirectOffsetPayload {
          return MemoryLayout<UInt32>.size
        }
        return 0
      case .external:
        return 4 * (1 + Int(payload))
      case .computed:
        var size = 8
        if isComputedSettable {
          size += 4
        }
        if !forPropertyDescriptor && hasComputedArguments {
          size += 12
        }
        return size
      case .optionalForce, .optionalChain, .optionalWrap:
        return 0
      }
    }
    init(optionalForce: ()) {
      self.init(discriminator: Header.optionalTag,
                payload: Header.optionalForcePayload)
    }
    init(optionalWrap: ()) {
      self.init(discriminator: Header.optionalTag,
                payload: Header.optionalWrapPayload)
    }
    init(optionalChain: ()) {
      self.init(discriminator: Header.optionalTag,
                payload: Header.optionalChainPayload)
    }
    init(stored kind: KeyPathStructOrClass,
         mutable: Bool,
         inlineOffset: UInt32) {
      let discriminator: UInt32
      switch kind {
      case .struct: discriminator = Header.structTag
      case .class: discriminator = Header.classTag
      }
      _internalInvariant(inlineOffset <= Header.maximumOffsetPayload)
      let payload = inlineOffset
        | (mutable ? Header.storedMutableFlag : 0)
      self.init(discriminator: discriminator,
                payload: payload)
    }
    init(storedWithOutOfLineOffset kind: KeyPathStructOrClass,
         mutable: Bool) {
      let discriminator: UInt32
      switch kind {
      case .struct: discriminator = Header.structTag
      case .class: discriminator = Header.classTag
      }
      let payload = Header.outOfLineOffsetPayload
        | (mutable ? Header.storedMutableFlag : 0)
      self.init(discriminator: discriminator,
                payload: payload)
    }
    init(computedWithIDKind kind: KeyPathComputedIDKind,
         mutating: Bool,
         settable: Bool,
         hasArguments: Bool,
         instantiatedFromExternalWithArguments: Bool) {
      let discriminator = Header.computedTag
      var payload =
          (mutating ? Header.computedMutatingFlag : 0)
        | (settable ? Header.computedSettableFlag : 0)
        | (hasArguments ? Header.computedHasArgumentsFlag : 0)
        | (instantiatedFromExternalWithArguments
             ? Header.computedInstantiatedFromExternalWithArgumentsFlag : 0)
      switch kind {
      case .pointer:
        break
      case .storedPropertyIndex:
        payload |= Header.computedIDByStoredPropertyFlag
      case .vtableOffset:
        payload |= Header.computedIDByVTableOffsetFlag
      }
      self.init(discriminator: discriminator,
                payload: payload)
    }
  }
  internal var bodySize: Int {
    let ptrSize = MemoryLayout<Int>.size
    switch header.kind {
    case .struct, .class:
      if header.storedOffsetPayload == Header.outOfLineOffsetPayload {
        return 4 
      }
      return 0
    case .external:
      _internalInvariantFailure("should be instantiated away")
    case .optionalChain, .optionalForce, .optionalWrap:
      return 0
    case .computed:
      var total = Header.pointerAlignmentSkew + ptrSize * 2
      if header.isComputedSettable {
        total += ptrSize
      }
      if header.hasComputedArguments {
        total += ptrSize * 2
        total += _computedArgumentSize
        if header.isComputedInstantiatedFromExternalWithArguments {
          total += Header.externalWithArgumentsExtraSize
        }
      }
      return total
    }
  }
  internal var _structOrClassOffset: Int {
    _internalInvariant(header.kind == .struct || header.kind == .class,
                 "no offset for this kind")
    if header.storedOffsetPayload == Header.outOfLineOffsetPayload {
      _internalInvariant(body.count >= MemoryLayout<UInt32>.size,
                   "component not big enough")
      return Int(body.load(as: UInt32.self))
    }
    return Int(header.storedOffsetPayload)
  }
  internal var _computedIDValue: Int {
    _internalInvariant(header.kind == .computed,
                 "not a computed property")
    return body.load(fromByteOffset: Header.pointerAlignmentSkew,
                     as: Int.self)
  }
  internal var _computedID: ComputedPropertyID {
    _internalInvariant(header.kind == .computed,
                 "not a computed property")
    return ComputedPropertyID(
      value: _computedIDValue,
      kind: header.computedIDKind)
  }
  internal var _computedAccessors: ComputedAccessorsPtr {
    _internalInvariant(header.kind == .computed,
                 "not a computed property")
    return ComputedAccessorsPtr(
      header: header,
      value: body.baseAddress.unsafelyUnwrapped +
              Header.pointerAlignmentSkew + MemoryLayout<Int>.size)
  }
  internal var _computedArgumentHeaderPointer: UnsafeRawPointer {
    _internalInvariant(header.hasComputedArguments, "no arguments")
    return body.baseAddress.unsafelyUnwrapped
      + Header.pointerAlignmentSkew
      + MemoryLayout<Int>.size *
         (header.isComputedSettable ? 3 : 2)
  }
  internal var _computedArgumentSize: Int {
    return _computedArgumentHeaderPointer.load(as: Int.self)
  }
  internal
  var _computedArgumentWitnesses: ComputedArgumentWitnessesPtr {
    return _computedArgumentHeaderPointer.load(
      fromByteOffset: MemoryLayout<Int>.size,
      as: ComputedArgumentWitnessesPtr.self)
  }
  internal var _computedArguments: UnsafeRawPointer {
    var base = _computedArgumentHeaderPointer + MemoryLayout<Int>.size * 2
    if header.isComputedInstantiatedFromExternalWithArguments {
      base += Header.externalWithArgumentsExtraSize
    }
    return base
  }
  internal var _computedMutableArguments: UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer(mutating: _computedArguments)
  }
  internal var _computedArgumentWitnessSizeAdjustment: Int {
    if header.isComputedInstantiatedFromExternalWithArguments {
      return _computedArguments.load(
        fromByteOffset: -Header.externalWithArgumentsExtraSize,
        as: Int.self)
    }
    return 0
  }
  internal var value: KeyPathComponent {
    switch header.kind {
    case .struct:
      return .struct(offset: _structOrClassOffset)
    case .class:
      return .class(offset: _structOrClassOffset)
    case .optionalChain:
      return .optionalChain
    case .optionalForce:
      return .optionalForce
    case .optionalWrap:
      return .optionalWrap
    case .computed:
      let isSettable = header.isComputedSettable
      let isMutating = header.isComputedMutating
      let id = _computedID
      let accessors = _computedAccessors
      let argument: KeyPathComponent.ArgumentRef?
      if header.hasComputedArguments {
        argument = KeyPathComponent.ArgumentRef(
          data: UnsafeRawBufferPointer(start: _computedArguments,
                                       count: _computedArgumentSize),
          witnesses: _computedArgumentWitnesses,
          witnessSizeAdjustment: _computedArgumentWitnessSizeAdjustment)
      } else {
        argument = nil
      }
      switch (isSettable, isMutating) {
      case (false, false):
        return .get(id: id, accessors: accessors, argument: argument)
      case (true, false):
        return .nonmutatingGetSet(id: id,
                                  accessors: accessors,
                                  argument: argument)
      case (true, true):
        return .mutatingGetSet(id: id,
                               accessors: accessors,
                               argument: argument)
      case (false, true):
        _internalInvariantFailure("impossible")
      }
    case .external:
      _internalInvariantFailure("should have been instantiated away")
    }
  }
  internal func destroy() {
    switch header.kind {
    case .struct,
         .class,
         .optionalChain,
         .optionalForce,
         .optionalWrap:
      break
    case .computed:
      if header.hasComputedArguments,
         let destructor = _computedArgumentWitnesses.destroy {
        destructor(_computedMutableArguments,
                 _computedArgumentSize - _computedArgumentWitnessSizeAdjustment)
      }
    case .external:
      _internalInvariantFailure("should have been instantiated away")
    }
  }
  internal func clone(into buffer: inout UnsafeMutableRawBufferPointer,
             endOfReferencePrefix: Bool) {
    var newHeader = header
    newHeader.endOfReferencePrefix = endOfReferencePrefix
    var componentSize = MemoryLayout<Header>.size
    buffer.storeBytes(of: newHeader, as: Header.self)
    switch header.kind {
    case .struct,
         .class:
      if header.storedOffsetPayload == Header.outOfLineOffsetPayload {
        let overflowOffset = body.load(as: UInt32.self)
        buffer.storeBytes(of: overflowOffset, toByteOffset: 4,
                          as: UInt32.self)
        componentSize += 4
      }
    case .optionalChain,
         .optionalForce,
         .optionalWrap:
      break
    case .computed:
      componentSize += Header.pointerAlignmentSkew
      buffer.storeBytes(of: _computedIDValue,
                        toByteOffset: componentSize,
                        as: Int.self)
      componentSize += MemoryLayout<Int>.size
      let accessors = _computedAccessors
      (buffer.baseAddress.unsafelyUnwrapped + MemoryLayout<Int>.size * 2)
        ._copyAddressDiscriminatedFunctionPointer(
          from: accessors.getterPtr,
          discriminator: ComputedAccessorsPtr.getterPtrAuthKey)
      componentSize += MemoryLayout<Int>.size
      if header.isComputedSettable {
        (buffer.baseAddress.unsafelyUnwrapped + MemoryLayout<Int>.size * 3)
          ._copyAddressDiscriminatedFunctionPointer(
            from: accessors.setterPtr,
            discriminator: header.isComputedMutating
              ? ComputedAccessorsPtr.mutatingSetterPtrAuthKey
              : ComputedAccessorsPtr.nonmutatingSetterPtrAuthKey)
        componentSize += MemoryLayout<Int>.size
      }
      if header.hasComputedArguments {
        let arguments = _computedArguments
        let argumentSize = _computedArgumentSize
        buffer.storeBytes(of: argumentSize,
                          toByteOffset: componentSize,
                          as: Int.self)
        componentSize += MemoryLayout<Int>.size
        buffer.storeBytes(of: _computedArgumentWitnesses,
                          toByteOffset: componentSize,
                          as: ComputedArgumentWitnessesPtr.self)
        componentSize += MemoryLayout<Int>.size
        if header.isComputedInstantiatedFromExternalWithArguments {
          buffer.storeBytes(of: _computedArgumentWitnessSizeAdjustment,
                            toByteOffset: componentSize,
                            as: Int.self)
          componentSize += MemoryLayout<Int>.size
        }
        let adjustedSize = argumentSize - _computedArgumentWitnessSizeAdjustment
        let argumentDest =
          buffer.baseAddress.unsafelyUnwrapped + componentSize
        _computedArgumentWitnesses.copy(
          arguments,
          argumentDest,
          adjustedSize)
        if header.isComputedInstantiatedFromExternalWithArguments {
          _memcpy(dest: argumentDest + adjustedSize,
                  src: arguments + adjustedSize,
                  size: UInt(_computedArgumentWitnessSizeAdjustment))
        }
        componentSize += argumentSize
      }
    case .external:
      _internalInvariantFailure("should have been instantiated away")
    }
    buffer = UnsafeMutableRawBufferPointer(
      start: buffer.baseAddress.unsafelyUnwrapped + componentSize,
      count: buffer.count - componentSize)
  }
  internal enum ProjectionResult<NewValue, LeafValue> {
    case `continue`(NewValue)
    case `break`(LeafValue)
    internal var assumingContinue: NewValue {
      switch self {
      case .continue(let x):
        return x
      case .break:
        _internalInvariantFailure("should not have stopped key path projection")
      }
    }
  }
  internal func _projectReadOnly<CurValue, NewValue, LeafValue>(
    _ base: CurValue,
    to: NewValue.Type,
    endingWith: LeafValue.Type
  ) -> ProjectionResult<NewValue, LeafValue> {
    switch value {
    case .struct(let offset):
      var base2 = base
      return .continue(withUnsafeBytes(of: &base2) {
        let p = $0.baseAddress.unsafelyUnwrapped.advanced(by: offset)
        return p.assumingMemoryBound(to: NewValue.self).pointee
      })
    case .class(let offset):
      _internalInvariant(CurValue.self is AnyObject.Type,
                   "base is not a class")
      let baseObj = unsafeBitCast(base, to: AnyObject.self)
      let basePtr = UnsafeRawPointer(Builtin.bridgeToRawPointer(baseObj))
      defer { _fixLifetime(baseObj) }
      let offsetAddress = basePtr.advanced(by: offset)
      Builtin.performInstantaneousReadAccess(offsetAddress._rawValue,
        NewValue.self)
      return .continue(offsetAddress
        .assumingMemoryBound(to: NewValue.self)
        .pointee)
    case .get(id: _, accessors: let accessors, argument: let argument),
         .mutatingGetSet(id: _, accessors: let accessors, argument: let argument),
         .nonmutatingGetSet(id: _, accessors: let accessors, argument: let argument):
      return .continue(accessors.getter()(base,
                               argument?.data.baseAddress ?? accessors._value,
                               argument?.data.count ?? 0))
    case .optionalChain:
      _internalInvariant(CurValue.self == Optional<NewValue>.self,
                   "should be unwrapping optional value")
      _internalInvariant(_isOptional(LeafValue.self),
                   "leaf result should be optional")
      if let baseValue = unsafeBitCast(base, to: Optional<NewValue>.self) {
        return .continue(baseValue)
      } else {
        return .break((Optional<()>.none as Any) as! LeafValue)
      }
    case .optionalForce:
      _internalInvariant(CurValue.self == Optional<NewValue>.self,
                   "should be unwrapping optional value")
      return .continue(unsafeBitCast(base, to: Optional<NewValue>.self)!)
    case .optionalWrap:
      _internalInvariant(NewValue.self == Optional<CurValue>.self,
                   "should be wrapping optional value")
      return .continue(
        unsafeBitCast(base as Optional<CurValue>, to: NewValue.self))
    }
  }
  internal func _projectMutableAddress<CurValue, NewValue>(
    _ base: UnsafeRawPointer,
    from _: CurValue.Type,
    to _: NewValue.Type,
    isRoot: Bool,
    keepAlive: inout AnyObject?
  ) -> UnsafeRawPointer {
    switch value {
    case .struct(let offset):
      return base.advanced(by: offset)
    case .class(let offset):
      _internalInvariant(isRoot,
                 "class component should not appear in the middle of mutation")
      let object = base.assumingMemoryBound(to: AnyObject.self).pointee
      let offsetAddress = UnsafeRawPointer(Builtin.bridgeToRawPointer(object))
            .advanced(by: offset)
      keepAlive = ClassHolder._create(previous: keepAlive, instance: object,
                                      accessingAddress: offsetAddress,
                                      type: NewValue.self)
      return offsetAddress
    case .mutatingGetSet(id: _, accessors: let accessors,
                         argument: let argument):
      let baseTyped = UnsafeMutablePointer(
        mutating: base.assumingMemoryBound(to: CurValue.self))
      let argValue = argument?.data.baseAddress ?? accessors._value
      let argSize = argument?.data.count ?? 0
      let writeback = MutatingWritebackBuffer<CurValue, NewValue>(
               previous: keepAlive,
               base: baseTyped,
               set: accessors.mutatingSetter(),
               argument: argValue,
               argumentSize: argSize,
               value: accessors.getter()(baseTyped.pointee, argValue, argSize))
      keepAlive = writeback
      return UnsafeRawPointer(Builtin.addressof(&writeback.value))
    case .nonmutatingGetSet(id: _, accessors: let accessors,
                            argument: let argument):
      _internalInvariant(isRoot,
           "nonmutating component should not appear in the middle of mutation")
      let baseValue = base.assumingMemoryBound(to: CurValue.self).pointee
      let argValue = argument?.data.baseAddress ?? accessors._value
      let argSize = argument?.data.count ?? 0
      let writeback = NonmutatingWritebackBuffer<CurValue, NewValue>(
                       previous: keepAlive,
                       base: baseValue,
                       set: accessors.nonmutatingSetter(),
                       argument: argValue,
                       argumentSize: argSize,
                       value: accessors.getter()(baseValue, argValue, argSize))
      keepAlive = writeback
      return UnsafeRawPointer(Builtin.addressof(&writeback.value))
    case .optionalForce:
      _internalInvariant(CurValue.self == Optional<NewValue>.self,
                   "should be unwrapping an optional value")
      let baseOptionalPointer
        = base.assumingMemoryBound(to: Optional<NewValue>.self)
      _ = baseOptionalPointer.pointee!
      return base
    case .optionalChain, .optionalWrap, .get:
      _internalInvariantFailure("not a mutable key path component")
    }
  }
}
internal func _pop<T>(from: inout UnsafeRawBufferPointer,
                      as type: T.Type) -> T {
  let buffer = _pop(from: &from, as: type, count: 1)
  return buffer.baseAddress.unsafelyUnwrapped.pointee
}
internal func _pop<T>(from: inout UnsafeRawBufferPointer,
                      as: T.Type,
                      count: Int) -> UnsafeBufferPointer<T> {
  _internalInvariant(_isPOD(T.self), "should be POD")
  from = MemoryLayout<T>._roundingUpBaseToAlignment(from)
  let byteCount = MemoryLayout<T>.stride * count
  let result = UnsafeBufferPointer(
    start: from.baseAddress.unsafelyUnwrapped.assumingMemoryBound(to: T.self),
    count: count)
  from = UnsafeRawBufferPointer(
    start: from.baseAddress.unsafelyUnwrapped + byteCount,
    count: from.count - byteCount)
  return result
}
internal struct KeyPathBuffer {
  internal var data: UnsafeRawBufferPointer
  internal var trivial: Bool
  internal var hasReferencePrefix: Bool
  internal init(base: UnsafeRawPointer) {
    let header = base.load(as: Header.self)
    data = UnsafeRawBufferPointer(
      start: base + MemoryLayout<Int>.size,
      count: header.size)
    trivial = header.trivial
    hasReferencePrefix = header.hasReferencePrefix
  }
  internal init(partialData: UnsafeRawBufferPointer,
                trivial: Bool = false,
                hasReferencePrefix: Bool = false) {
    self.data = partialData
    self.trivial = trivial
    self.hasReferencePrefix = hasReferencePrefix
  }
  internal var mutableData: UnsafeMutableRawBufferPointer {
    return UnsafeMutableRawBufferPointer(mutating: data)
  }
  internal struct Builder {
    internal var buffer: UnsafeMutableRawBufferPointer
    internal init(_ buffer: UnsafeMutableRawBufferPointer) {
      self.buffer = buffer
    }
    internal mutating func pushRaw(size: Int, alignment: Int)
        -> UnsafeMutableRawBufferPointer {
      var baseAddress = buffer.baseAddress.unsafelyUnwrapped
      var misalign = Int(bitPattern: baseAddress) & (alignment - 1)
      if misalign != 0 {
        misalign = alignment - misalign
        baseAddress = baseAddress.advanced(by: misalign)
      }
      let result = UnsafeMutableRawBufferPointer(
        start: baseAddress,
        count: size)
      buffer = UnsafeMutableRawBufferPointer(
        start: baseAddress + size,
        count: buffer.count - size - misalign)
      return result
    }
    internal mutating func push<T>(_ value: T) {
      let buf = pushRaw(size: MemoryLayout<T>.size,
                        alignment: MemoryLayout<T>.alignment)
      buf.storeBytes(of: value, as: T.self)
    }
    internal mutating func pushHeader(_ header: Header) {
      push(header)
      _ = pushRaw(size: RawKeyPathComponent.Header.pointerAlignmentSkew,
             alignment: 4)
    }
  }
  internal struct Header {
    internal var _value: UInt32
    internal init(size: Int, trivial: Bool, hasReferencePrefix: Bool) {
      _internalInvariant(size <= Int(Header.sizeMask), "key path too big")
      _value = UInt32(size)
        | (trivial ? Header.trivialFlag : 0)
        | (hasReferencePrefix ? Header.hasReferencePrefixFlag : 0)
    }
    internal static var sizeMask: UInt32 {
      return _SwiftKeyPathBufferHeader_SizeMask
    }
    internal static var reservedMask: UInt32 {
      return _SwiftKeyPathBufferHeader_ReservedMask
    }
    internal static var trivialFlag: UInt32 {
      return _SwiftKeyPathBufferHeader_TrivialFlag
    }
    internal static var hasReferencePrefixFlag: UInt32 {
      return _SwiftKeyPathBufferHeader_HasReferencePrefixFlag
    }
    internal var size: Int { return Int(_value & Header.sizeMask) }
    internal var trivial: Bool { return _value & Header.trivialFlag != 0 }
    internal var hasReferencePrefix: Bool {
      get {
        return _value & Header.hasReferencePrefixFlag != 0
      }
      set {
        if newValue {
          _value |= Header.hasReferencePrefixFlag
        } else {
          _value &= ~Header.hasReferencePrefixFlag
        }
      }
    }
    internal var instantiableInLine: Bool {
      return trivial
    }
    internal func validateReservedBits() {
      _precondition(_value & Header.reservedMask == 0,
                    "Reserved bits set to an unexpected bit pattern")
    }
  }
  internal func destroy() {
    if trivial { return }
    var bufferToDestroy = self
    while true {
      let (component, type) = bufferToDestroy.next()
      component.destroy()
      guard let _ = type else { break }
    }
  }
  internal mutating func next() -> (RawKeyPathComponent, Any.Type?) {
    let header = _pop(from: &data, as: RawKeyPathComponent.Header.self)
    if header.endOfReferencePrefix {
      _internalInvariant(self.hasReferencePrefix,
                   "beginMutation marker in non-reference-writable key path?")
      self.hasReferencePrefix = false
    }
    var component = RawKeyPathComponent(header: header, body: data)
    let size = component.bodySize
    component.body = UnsafeRawBufferPointer(start: component.body.baseAddress,
                                            count: size)
    _ = _pop(from: &data, as: Int8.self, count: size)
    let nextType: Any.Type?
    if data.isEmpty {
      nextType = nil
    } else {
      nextType = _pop(from: &data, as: Any.Type.self)
    }
    return (component, nextType)
  }
}
public 
func _getAtPartialKeyPath<Root>(
  root: Root,
  keyPath: PartialKeyPath<Root>
) -> Any {
  func open<Value>(_: Value.Type) -> Any {
    return _getAtKeyPath(root: root,
      keyPath: unsafeDowncast(keyPath, to: KeyPath<Root, Value>.self))
  }
  return _openExistential(type(of: keyPath).valueType, do: open)
}
public 
func _getAtAnyKeyPath<RootValue>(
  root: RootValue,
  keyPath: AnyKeyPath
) -> Any? {
  let (keyPathRoot, keyPathValue) = type(of: keyPath)._rootAndValueType
  func openRoot<KeyPathRoot>(_: KeyPathRoot.Type) -> Any? {
    guard let rootForKeyPath = root as? KeyPathRoot else {
      return nil
    }
    func openValue<Value>(_: Value.Type) -> Any {
      return _getAtKeyPath(root: rootForKeyPath,
        keyPath: unsafeDowncast(keyPath, to: KeyPath<KeyPathRoot, Value>.self))
    }
    return _openExistential(keyPathValue, do: openValue)
  }
  return _openExistential(keyPathRoot, do: openRoot)
}
public 
func _getAtKeyPath<Root, Value>(
  root: Root,
  keyPath: KeyPath<Root, Value>
) -> Value {
  return keyPath._projectReadOnly(from: root)
}
public 
func _modifyAtWritableKeyPath_impl<Root, Value>(
  root: inout Root,
  keyPath: WritableKeyPath<Root, Value>
) -> (UnsafeMutablePointer<Value>, AnyObject?) {
  if type(of: keyPath).kind == .reference {
    return _modifyAtReferenceWritableKeyPath_impl(root: root,
      keyPath: _unsafeUncheckedDowncast(keyPath,
        to: ReferenceWritableKeyPath<Root, Value>.self))
  }
  return _withUnprotectedUnsafePointer(to: &root) {
    keyPath._projectMutableAddress(from: $0)
  }
}
public 
func _modifyAtReferenceWritableKeyPath_impl<Root, Value>(
  root: Root,
  keyPath: ReferenceWritableKeyPath<Root, Value>
) -> (UnsafeMutablePointer<Value>, AnyObject?) {
  return keyPath._projectMutableAddress(from: root)
}
public 
func _setAtWritableKeyPath<Root, Value>(
  root: inout Root,
  keyPath: WritableKeyPath<Root, Value>,
  value: __owned Value
) {
  if type(of: keyPath).kind == .reference {
    return _setAtReferenceWritableKeyPath(root: root,
      keyPath: _unsafeUncheckedDowncast(keyPath,
        to: ReferenceWritableKeyPath<Root, Value>.self),
      value: value)
  }
  let (addr, owner) = _withUnprotectedUnsafePointer(to: &root) {
    keyPath._projectMutableAddress(from: $0)
  }
  addr.pointee = value
  _fixLifetime(owner)
}
public 
func _setAtReferenceWritableKeyPath<Root, Value>(
  root: Root,
  keyPath: ReferenceWritableKeyPath<Root, Value>,
  value: __owned Value
) {
  let (addr, owner) = keyPath._projectMutableAddress(from: root)
  addr.pointee = value
  _fixLifetime(owner)
}
public protocol _AppendKeyPath {}
extension _AppendKeyPath where Self == AnyKeyPath {
  @inlinable
  public func appending(path: AnyKeyPath) -> AnyKeyPath? {
    return _tryToAppendKeyPaths(root: self, leaf: path)
  }
}
extension _AppendKeyPath  {
  @inlinable
  public func appending<Root>(path: AnyKeyPath) -> PartialKeyPath<Root>?
  where Self == PartialKeyPath<Root> {
    return _tryToAppendKeyPaths(root: self, leaf: path)
  }
  @inlinable
  public func appending<Root, AppendedRoot, AppendedValue>(
    path: KeyPath<AppendedRoot, AppendedValue>
  ) -> KeyPath<Root, AppendedValue>?
  where Self == PartialKeyPath<Root> {
    return _tryToAppendKeyPaths(root: self, leaf: path)
  }
  @inlinable
  public func appending<Root, AppendedRoot, AppendedValue>(
    path: ReferenceWritableKeyPath<AppendedRoot, AppendedValue>
  ) -> ReferenceWritableKeyPath<Root, AppendedValue>?
  where Self == PartialKeyPath<Root> {
    return _tryToAppendKeyPaths(root: self, leaf: path)
  }
}
extension _AppendKeyPath  {
  @inlinable
  public func appending<Root, Value, AppendedValue>(
    path: KeyPath<Value, AppendedValue>
  ) -> KeyPath<Root, AppendedValue>
  where Self: KeyPath<Root, Value> {
    return _appendingKeyPaths(root: self, leaf: path)
  }
  /* TODO
  public func appending<Root, Value, Leaf>(
    path: Leaf,
    _: Value.Type = Value.self
  ) -> PartialKeyPath<Root>?
  where Self: KeyPath<Root, Value>, Leaf == AnyKeyPath {
    return _tryToAppendKeyPaths(root: self, leaf: path)
  }
   */
  @inlinable
  public func appending<Root, Value, AppendedValue>(
    path: ReferenceWritableKeyPath<Value, AppendedValue>
  ) -> ReferenceWritableKeyPath<Root, AppendedValue>
  where Self == KeyPath<Root, Value> {
    return _appendingKeyPaths(root: self, leaf: path)
  }
}
extension _AppendKeyPath  {
  @inlinable
  public func appending<Root, Value, AppendedValue>(
    path: WritableKeyPath<Value, AppendedValue>
  ) -> WritableKeyPath<Root, AppendedValue>
  where Self == WritableKeyPath<Root, Value> {
    return _appendingKeyPaths(root: self, leaf: path)
  }
  @inlinable
  public func appending<Root, Value, AppendedValue>(
    path: ReferenceWritableKeyPath<Value, AppendedValue>
  ) -> ReferenceWritableKeyPath<Root, AppendedValue>
  where Self == WritableKeyPath<Root, Value> {
    return _appendingKeyPaths(root: self, leaf: path)
  }
}
extension _AppendKeyPath  {
  @inlinable
  public func appending<Root, Value, AppendedValue>(
    path: WritableKeyPath<Value, AppendedValue>
  ) -> ReferenceWritableKeyPath<Root, AppendedValue>
  where Self == ReferenceWritableKeyPath<Root, Value> {
    return _appendingKeyPaths(root: self, leaf: path)
  }
}
internal func _processOffsetForAppendedKeyPath(
  appendedKeyPath: inout AnyKeyPath,
  root: AnyKeyPath,
  leaf: AnyKeyPath
) {
  if let rootOffset = root.getOffsetFromStorage(),
    let leafOffset = leaf.getOffsetFromStorage()
  {
    appendedKeyPath.assignOffsetToStorage(offset: rootOffset + leafOffset)
  }
}
@usableFromInline
internal func _tryToAppendKeyPaths<Result: AnyKeyPath>(
  root: AnyKeyPath,
  leaf: AnyKeyPath
) -> Result? {
  let (rootRoot, rootValue) = type(of: root)._rootAndValueType
  let (leafRoot, leafValue) = type(of: leaf)._rootAndValueType
  if rootValue != leafRoot {
    return nil
  }
  func open<Root>(_: Root.Type) -> Result {
    func open2<Value>(_: Value.Type) -> Result {
      func open3<AppendedValue>(_: AppendedValue.Type) -> Result {
        let typedRoot = unsafeDowncast(root, to: KeyPath<Root, Value>.self)
        let typedLeaf = unsafeDowncast(leaf,
                                       to: KeyPath<Value, AppendedValue>.self)
        var result:AnyKeyPath = _appendingKeyPaths(root: typedRoot,
                                                   leaf: typedLeaf)
        _processOffsetForAppendedKeyPath(appendedKeyPath: &result,
          root: root, leaf: leaf)
        return unsafeDowncast(result, to: Result.self)
      }
      return _openExistential(leafValue, do: open3)
    }
    return _openExistential(rootValue, do: open2)
  }
  return _openExistential(rootRoot, do: open)
}
@usableFromInline
internal func _appendingKeyPaths<
  Root, Value, AppendedValue,
  Result: KeyPath<Root, AppendedValue>
>(
  root: KeyPath<Root, Value>,
  leaf: KeyPath<Value, AppendedValue>
) -> Result {
  let resultTy = type(of: root).appendedType(with: type(of: leaf))
    var returnValue: AnyKeyPath = root.withBuffer {
    var rootBuffer = $0
    return leaf.withBuffer {
      var leafBuffer = $0
      if leafBuffer.data.isEmpty {
        return unsafeDowncast(root, to: Result.self)
      }
      if rootBuffer.data.isEmpty {
        return unsafeDowncast(leaf, to: Result.self)
      }
      let appendedKVCLength: Int, rootKVCLength: Int, leafKVCLength: Int
      if root.getOffsetFromStorage() == nil, leaf.getOffsetFromStorage() == nil,
        let rootPtr = root._kvcKeyPathStringPtr,
        let leafPtr = leaf._kvcKeyPathStringPtr {
        rootKVCLength = Int(_swift_stdlib_strlen(rootPtr))
        leafKVCLength = Int(_swift_stdlib_strlen(leafPtr))
        appendedKVCLength = rootKVCLength + 1 + leafKVCLength + 1
      } else {
        rootKVCLength = 0
        leafKVCLength = 0
        appendedKVCLength = 0
      }
      let rootSize = MemoryLayout<Int>._roundingUpToAlignment(rootBuffer.data.count)
      let resultSize = rootSize + leafBuffer.data.count
        + 2 * MemoryLayout<Int>.size
      let totalResultSize = MemoryLayout<Int32>
        ._roundingUpToAlignment(resultSize + appendedKVCLength)
      var kvcStringBuffer: UnsafeMutableRawPointer? = nil
      let result = resultTy._create(capacityInBytes: totalResultSize) {
        var destBuffer = $0
        if appendedKVCLength > 0 {
          kvcStringBuffer = destBuffer.baseAddress.unsafelyUnwrapped
            .advanced(by: resultSize)
          destBuffer = .init(start: destBuffer.baseAddress,
                             count: resultSize)
        }
        var destBuilder = KeyPathBuffer.Builder(destBuffer)
        let leafIsReferenceWritable = type(of: leaf).kind == .reference
        destBuilder.pushHeader(KeyPathBuffer.Header(
          size: resultSize - MemoryLayout<Int>.size,
          trivial: rootBuffer.trivial && leafBuffer.trivial,
          hasReferencePrefix: rootBuffer.hasReferencePrefix
                              || leafIsReferenceWritable
        ))
        let leafHasReferencePrefix = leafBuffer.hasReferencePrefix
        while true {
          let (component, type) = rootBuffer.next()
          let isLast = type == nil
          let endOfReferencePrefix: Bool
          if leafHasReferencePrefix {
            endOfReferencePrefix = false
          } else if isLast && leafIsReferenceWritable {
            endOfReferencePrefix = true
          } else {
            endOfReferencePrefix = component.header.endOfReferencePrefix
          }
          component.clone(
            into: &destBuilder.buffer,
            endOfReferencePrefix: endOfReferencePrefix)
          if let type = type {
            destBuilder.push(type)
          } else {
            destBuilder.push(Value.self as Any.Type)
            break
          }
        }
        while true {
          let (component, type) = leafBuffer.next()
          component.clone(
            into: &destBuilder.buffer,
            endOfReferencePrefix: component.header.endOfReferencePrefix)
          if let type = type {
            destBuilder.push(type)
          } else {
            break
          }
        }
        _internalInvariant(destBuilder.buffer.isEmpty,
                     "did not fill entire result buffer")
      }
      if root.getOffsetFromStorage() == nil,
        leaf.getOffsetFromStorage() == nil {
        if let kvcStringBuffer = kvcStringBuffer {
          let rootPtr = root._kvcKeyPathStringPtr.unsafelyUnwrapped
          let leafPtr = leaf._kvcKeyPathStringPtr.unsafelyUnwrapped
          _memcpy(
            dest: kvcStringBuffer,
            src: rootPtr,
            size: UInt(rootKVCLength))
          kvcStringBuffer.advanced(by: rootKVCLength)
            .storeBytes(of: 0x2E , as: CChar.self)
          _memcpy(
            dest: kvcStringBuffer.advanced(by: rootKVCLength + 1),
            src: leafPtr,
            size: UInt(leafKVCLength))
          result._kvcKeyPathStringPtr =
            UnsafePointer(kvcStringBuffer.assumingMemoryBound(to: CChar.self))
          kvcStringBuffer.advanced(by: rootKVCLength + leafKVCLength + 1)
            .storeBytes(of: 0 , as: CChar.self)
        }
      }
      return unsafeDowncast(result, to: Result.self)
    }
  }
  _processOffsetForAppendedKeyPath(
    appendedKeyPath: &returnValue,
    root: root,
    leaf: leaf
  )
  return returnValue as! Result
}
internal var keyPathObjectHeaderSize: Int {
  return MemoryLayout<HeapObject>.size + MemoryLayout<Int>.size
}
internal var keyPathPatternHeaderSize: Int {
  return 16
}
public func _swift_getKeyPath(pattern: UnsafeMutableRawPointer,
                              arguments: UnsafeRawPointer)
    -> UnsafeRawPointer {
  let oncePtrPtr = pattern
  let patternPtr = pattern.advanced(by: 4)
  let bufferHeader = patternPtr.load(fromByteOffset: keyPathPatternHeaderSize,
                                     as: KeyPathBuffer.Header.self)
  bufferHeader.validateReservedBits()
  let oncePtrOffset = oncePtrPtr.load(as: Int32.self)
  let oncePtr: UnsafeRawPointer?
  if oncePtrOffset != 0 {
    let theOncePtr = _resolveRelativeAddress(oncePtrPtr, oncePtrOffset)
    oncePtr = theOncePtr
    let existingInstance = theOncePtr.load(as: UnsafeRawPointer?.self)
    if let existingInstance = existingInstance {
      let object = Unmanaged<AnyKeyPath>.fromOpaque(existingInstance)
      _ = object.retain()
      return existingInstance
    }
  } else {
    oncePtr = nil
  }
  let (keyPathClass, rootType, size, _)
    = _getKeyPathClassAndInstanceSizeFromPattern(patternPtr, arguments)
  var pureStructOffset: UInt32? = nil
  let instance = keyPathClass._create(capacityInBytes: size) { instanceData in
    pureStructOffset = _instantiateKeyPathBuffer(
      patternPtr,
      instanceData,
      rootType,
      arguments
    )
  }
  let kvcStringBase = patternPtr.advanced(by: 12)
  let kvcStringOffset = kvcStringBase.load(as: Int32.self)
  if kvcStringOffset == 0 {
    instance._kvcKeyPathStringPtr = nil
  } else {
    let kvcStringPtr = _resolveRelativeAddress(kvcStringBase, kvcStringOffset)
    instance._kvcKeyPathStringPtr =
      kvcStringPtr.assumingMemoryBound(to: CChar.self)
  }
  if instance._kvcKeyPathStringPtr == nil, let offset = pureStructOffset {
    instance.assignOffsetToStorage(offset: Int(offset))
  }
  if let oncePtr = oncePtr {
    let instancePtr = Unmanaged.passRetained(instance)
    while true {
      let (oldValue, won) = Builtin.cmpxchg_seqcst_seqcst_Word(
        oncePtr._rawValue,
        0._builtinWordValue,
        UInt(bitPattern: instancePtr.toOpaque())._builtinWordValue)
      if Bool(won) {
        break
      }
      if let existingInstance = UnsafeRawPointer(bitPattern: Int(oldValue)) {
        let object = Unmanaged<AnyKeyPath>.fromOpaque(existingInstance)
        _ = object.retain()
        instancePtr.release()
        return existingInstance
      } else {
        continue
      }
    }
  }
  return UnsafeRawPointer(Unmanaged.passRetained(instance).toOpaque())
}
internal typealias MetadataReference = UnsafeRawPointer
internal func _getSymbolicMangledNameLength(_ base: UnsafeRawPointer) -> Int {
  var end = base
  while let current = Optional(end.load(as: UInt8.self)), current != 0 {
    end = end + 1
    if current >= 0x1 && current <= 0x17 {
      end += 4
    } else if current >= 0x18 && current <= 0x1F {
      end += MemoryLayout<Int>.size
    }
  }
  return end - base
}
internal func _getTypeByMangledNameInEnvironmentOrContext(
  _ name: UnsafePointer<UInt8>,
  _ nameLength: UInt,
  genericEnvironmentOrContext: UnsafeRawPointer?,
  genericArguments: UnsafeRawPointer?)
  -> Any.Type? {
  let taggedPointer = UInt(bitPattern: genericEnvironmentOrContext)
  if taggedPointer & 1 == 0 {
    return _getTypeByMangledNameInEnvironment(name, nameLength,
                      genericEnvironment: genericEnvironmentOrContext,
                      genericArguments: genericArguments)
  } else {
    let context = UnsafeRawPointer(bitPattern: taggedPointer & ~1)
    return _getTypeByMangledNameInContext(name, nameLength,
                      genericContext: context,
                      genericArguments: genericArguments)
  }
}
internal func _resolveKeyPathGenericArgReference(
    _ reference: UnsafeRawPointer,
    genericEnvironment: UnsafeRawPointer?,
    arguments: UnsafeRawPointer?)
    -> UnsafeRawPointer {
  if (UInt(bitPattern: reference) & 0x01 == 0) {
    return reference
  }
  let referenceStart = reference - 1
  let first = referenceStart.load(as: UInt8.self)
  if first == 255 && reference.load(as: UInt8.self) == 9 {
    typealias MetadataAccessor =
      @convention(c) (UnsafeRawPointer?) -> UnsafeRawPointer
    let pointerReference = reference + 1
    var offset: Int32 = 0
    _memcpy(dest: &offset, src: pointerReference, size: 4)
    let accessorPtrRaw = _resolveCompactFunctionPointer(pointerReference, offset)
    let accessorPtrSigned =
      _PtrAuth.sign(pointer: accessorPtrRaw,
              key: .processIndependentCode,
              discriminator: _PtrAuth.discriminator(for: MetadataAccessor.self))
    let accessor = unsafeBitCast(accessorPtrSigned, to: MetadataAccessor.self)
    return accessor(arguments)
  }
  let nameLength = _getSymbolicMangledNameLength(referenceStart)
  let namePtr = referenceStart.bindMemory(to: UInt8.self,
                                          capacity: nameLength + 1)
  guard let result =
    _getTypeByMangledNameInEnvironmentOrContext(namePtr, UInt(nameLength),
                         genericEnvironmentOrContext: genericEnvironment,
                         genericArguments: arguments)
  else {
    let nameStr = String._fromUTF8Repairing(
      UnsafeBufferPointer(start: namePtr, count: nameLength)
    ).0
    fatalError("could not demangle keypath type from '\(nameStr)'")
  }
  return unsafeBitCast(result, to: UnsafeRawPointer.self)
}
internal func _resolveKeyPathMetadataReference(
    _ reference: UnsafeRawPointer,
    genericEnvironment: UnsafeRawPointer?,
    arguments: UnsafeRawPointer?)
    -> Any.Type {
  return unsafeBitCast(
           _resolveKeyPathGenericArgReference(
             reference,
             genericEnvironment: genericEnvironment,
             arguments: arguments),
           to: Any.Type.self)
}
internal enum KeyPathStructOrClass {
  case `struct`, `class`
}
internal enum KeyPathPatternStoredOffset {
  case inline(UInt32)
  case outOfLine(UInt32)
  case unresolvedFieldOffset(UInt32)
  case unresolvedIndirectOffset(UnsafePointer<UInt>)
}
internal struct KeyPathPatternComputedArguments {
  var getLayout: KeyPathComputedArgumentLayoutFn
  var witnesses: ComputedArgumentWitnessesPtr
  var initializer: KeyPathComputedArgumentInitializerFn
}
internal protocol KeyPathPatternVisitor {
  mutating func visitHeader(genericEnvironment: UnsafeRawPointer?,
                            rootMetadataRef: MetadataReference,
                            leafMetadataRef: MetadataReference,
                            kvcCompatibilityString: UnsafeRawPointer?)
  mutating func visitStoredComponent(kind: KeyPathStructOrClass,
                                     mutable: Bool,
                                     offset: KeyPathPatternStoredOffset)
  mutating func visitComputedComponent(mutating: Bool,
                                       idKind: KeyPathComputedIDKind,
                                       idResolution: KeyPathComputedIDResolution,
                                       idValueBase: UnsafeRawPointer,
                                       idValue: Int32,
                                       getter: UnsafeRawPointer,
                                       setter: UnsafeRawPointer?,
                                       arguments: KeyPathPatternComputedArguments?,
                                       externalArgs: UnsafeBufferPointer<Int32>?)
  mutating func visitOptionalChainComponent()
  mutating func visitOptionalForceComponent()
  mutating func visitOptionalWrapComponent()
  mutating func visitIntermediateComponentType(metadataRef: MetadataReference)
  mutating func finish()
}
internal func _resolveRelativeAddress(_ base: UnsafeRawPointer,
                                      _ offset: Int32) -> UnsafeRawPointer {
  return UnsafeRawPointer(bitPattern: Int(bitPattern: base) &+ Int(offset))
    .unsafelyUnwrapped
}
internal func _resolveRelativeIndirectableAddress(_ base: UnsafeRawPointer,
                                                  _ offset: Int32)
    -> UnsafeRawPointer {
  if offset & 1 != 0 {
    let ptrToPtr = _resolveRelativeAddress(base, offset - 1)
    return ptrToPtr.load(as: UnsafeRawPointer.self)
  }
  return _resolveRelativeAddress(base, offset)
}
internal func _resolveCompactFunctionPointer(_ base: UnsafeRawPointer, _ offset: Int32)
    -> UnsafeRawPointer {
#if SWIFT_COMPACT_ABSOLUTE_FUNCTION_POINTER
  return UnsafeRawPointer(bitPattern: Int(offset)).unsafelyUnwrapped
#else
  return _resolveRelativeAddress(base, offset)
#endif
}
internal func _loadRelativeAddress<T>(at: UnsafeRawPointer,
                                      fromByteOffset: Int = 0,
                                      as: T.Type) -> T {
  let offset = at.load(fromByteOffset: fromByteOffset, as: Int32.self)
  return unsafeBitCast(_resolveRelativeAddress(at + fromByteOffset, offset),
                       to: T.self)
}
internal func _walkKeyPathPattern<W: KeyPathPatternVisitor>(
                                  _ pattern: UnsafeRawPointer,
                                  walker: inout W) {
  let genericEnvironment = _loadRelativeAddress(at: pattern,
                                                as: UnsafeRawPointer.self)
  let rootMetadataRef = _loadRelativeAddress(at: pattern, fromByteOffset: 4,
                                             as: MetadataReference.self)
  let leafMetadataRef = _loadRelativeAddress(at: pattern, fromByteOffset: 8,
                                             as: MetadataReference.self)
  let kvcString = _loadRelativeAddress(at: pattern, fromByteOffset: 12,
                                       as: UnsafeRawPointer.self)
  walker.visitHeader(genericEnvironment: genericEnvironment,
                     rootMetadataRef: rootMetadataRef,
                     leafMetadataRef: leafMetadataRef,
                     kvcCompatibilityString: kvcString)
  func visitStored(header: RawKeyPathComponent.Header,
                   componentBuffer: inout UnsafeRawBufferPointer) {
    let offset: KeyPathPatternStoredOffset
    switch header.storedOffsetPayload {
    case RawKeyPathComponent.Header.outOfLineOffsetPayload:
      offset = .outOfLine(_pop(from: &componentBuffer,
                               as: UInt32.self))
    case RawKeyPathComponent.Header.unresolvedFieldOffsetPayload:
      offset = .unresolvedFieldOffset(_pop(from: &componentBuffer,
                                           as: UInt32.self))
    case RawKeyPathComponent.Header.unresolvedIndirectOffsetPayload:
      let base = componentBuffer.baseAddress.unsafelyUnwrapped
      let relativeOffset = _pop(from: &componentBuffer,
                                as: Int32.self)
      let ptr = _resolveRelativeIndirectableAddress(base, relativeOffset)
      offset = .unresolvedIndirectOffset(
                                       ptr.assumingMemoryBound(to: UInt.self))
    default:
      offset = .inline(header.storedOffsetPayload)
    }
    let kind: KeyPathStructOrClass = header.kind == .struct 
      ? .struct : .class
    walker.visitStoredComponent(kind: kind,
                                mutable: header.isStoredMutable,
                                offset: offset)
  }
  func popComputedAccessors(header: RawKeyPathComponent.Header,
                            componentBuffer: inout UnsafeRawBufferPointer)
      -> (idValueBase: UnsafeRawPointer,
          idValue: Int32,
          getter: UnsafeRawPointer,
          setter: UnsafeRawPointer?) {
    let idValueBase = componentBuffer.baseAddress.unsafelyUnwrapped
    let idValue = _pop(from: &componentBuffer, as: Int32.self)
    let getterBase = componentBuffer.baseAddress.unsafelyUnwrapped
    let getterRef = _pop(from: &componentBuffer, as: Int32.self)
    let getter = _resolveCompactFunctionPointer(getterBase, getterRef)
    let setter: UnsafeRawPointer?
    if header.isComputedSettable {
      let setterBase = componentBuffer.baseAddress.unsafelyUnwrapped
      let setterRef = _pop(from: &componentBuffer, as: Int32.self)
      setter = _resolveCompactFunctionPointer(setterBase, setterRef)
    } else {
      setter = nil
    }
    return (idValueBase: idValueBase, idValue: idValue,
            getter: getter, setter: setter)
  }
  func popComputedArguments(header: RawKeyPathComponent.Header,
                            componentBuffer: inout UnsafeRawBufferPointer)
      -> KeyPathPatternComputedArguments? {
    if header.hasComputedArguments {
      let getLayoutBase = componentBuffer.baseAddress.unsafelyUnwrapped
      let getLayoutRef = _pop(from: &componentBuffer, as: Int32.self)
      let getLayoutRaw = _resolveCompactFunctionPointer(getLayoutBase, getLayoutRef)
      let getLayoutSigned = _PtrAuth.sign(pointer: getLayoutRaw,
        key: .processIndependentCode,
        discriminator: _PtrAuth.discriminator(for: KeyPathComputedArgumentLayoutFn.self))
      let getLayout = unsafeBitCast(getLayoutSigned,
                                    to: KeyPathComputedArgumentLayoutFn.self)
      let witnessesBase = componentBuffer.baseAddress.unsafelyUnwrapped
      let witnessesRef = _pop(from: &componentBuffer, as: Int32.self)
      let witnesses: UnsafeRawPointer
      if witnessesRef == 0 {
        witnesses = __swift_keyPathGenericWitnessTable_addr()
      } else {
        witnesses = _resolveRelativeAddress(witnessesBase, witnessesRef)
      }
      let initializerBase = componentBuffer.baseAddress.unsafelyUnwrapped
      let initializerRef = _pop(from: &componentBuffer, as: Int32.self)
      let initializerRaw = _resolveCompactFunctionPointer(initializerBase,
                                                          initializerRef)
      let initializerSigned = _PtrAuth.sign(pointer: initializerRaw,
        key: .processIndependentCode,
        discriminator: _PtrAuth.discriminator(for: KeyPathComputedArgumentInitializerFn.self))
      let initializer = unsafeBitCast(initializerSigned,
                                  to: KeyPathComputedArgumentInitializerFn.self)
      return KeyPathPatternComputedArguments(getLayout: getLayout,
        witnesses: ComputedArgumentWitnessesPtr(witnesses),
        initializer: initializer)
    } else {
      return nil
    }
  }
  let bufferPtr = pattern.advanced(by: keyPathPatternHeaderSize)
  let bufferHeader = bufferPtr.load(as: KeyPathBuffer.Header.self)
  var buffer = UnsafeRawBufferPointer(start: bufferPtr + 4,
                                      count: bufferHeader.size)
  while !buffer.isEmpty {
    let header = _pop(from: &buffer,
                      as: RawKeyPathComponent.Header.self)
    var bufferSizeBefore = 0
    var expectedPop = 0
    _internalInvariant({
      bufferSizeBefore = buffer.count
      expectedPop = header.patternComponentBodySize
      return true
    }())
    switch header.kind {
    case .class, .struct:
      visitStored(header: header, componentBuffer: &buffer)
    case .computed:
      let (idValueBase, idValue, getter, setter)
        = popComputedAccessors(header: header,
                               componentBuffer: &buffer)
      let arguments = popComputedArguments(header: header,
                                           componentBuffer: &buffer)
      walker.visitComputedComponent(mutating: header.isComputedMutating,
                                    idKind: header.computedIDKind,
                                    idResolution: header.computedIDResolution,
                                    idValueBase: idValueBase,
                                    idValue: idValue,
                                    getter: getter,
                                    setter: setter,
                                    arguments: arguments,
                                    externalArgs: nil)
    case .optionalChain:
      walker.visitOptionalChainComponent()
    case .optionalWrap:
      walker.visitOptionalWrapComponent()
    case .optionalForce:
      walker.visitOptionalForceComponent()
    case .external:
      let genericParamCount = Int(header.payload)
      let descriptorBase = buffer.baseAddress.unsafelyUnwrapped
      let descriptorOffset = _pop(from: &buffer,
                                  as: Int32.self)
      let descriptor =
        _resolveRelativeIndirectableAddress(descriptorBase, descriptorOffset)
      let descriptorHeader =
        descriptor.load(as: RawKeyPathComponent.Header.self)
      if descriptorHeader.isTrivialPropertyDescriptor {
        _ = _pop(from: &buffer, as: Int32.self, count: genericParamCount)
        continue
      }
      let externalArgs = _pop(from: &buffer, as: Int32.self,
                              count: genericParamCount)
      let localCandidateHeader = _pop(from: &buffer,
                                      as: RawKeyPathComponent.Header.self)
      let localCandidateSize = localCandidateHeader.patternComponentBodySize
      _internalInvariant({
        expectedPop += localCandidateSize + 4
        return true
      }())
      let descriptorSize = descriptorHeader.propertyDescriptorBodySize
      var descriptorBuffer = UnsafeRawBufferPointer(start: descriptor + 4,
                                                    count: descriptorSize)
      switch descriptorHeader.kind {
      case .struct, .class:
        _ = _pop(from: &buffer, as: UInt8.self, count: localCandidateSize)
        visitStored(header: descriptorHeader,
                    componentBuffer: &descriptorBuffer)
      case .computed:
        let (idValueBase, idValue, getter, setter)
          = popComputedAccessors(header: descriptorHeader,
                                 componentBuffer: &descriptorBuffer)
        let arguments: KeyPathPatternComputedArguments?
        if localCandidateHeader.kind == .computed
            && localCandidateHeader.hasComputedArguments {
          _ = popComputedAccessors(header: localCandidateHeader,
                                   componentBuffer: &buffer)
          arguments = popComputedArguments(header: localCandidateHeader,
                                           componentBuffer: &buffer)
        } else {
          _ = _pop(from: &buffer, as: UInt8.self, count: localCandidateSize)
          arguments = nil
        }
        walker.visitComputedComponent(
          mutating: descriptorHeader.isComputedMutating,
          idKind: descriptorHeader.computedIDKind,
          idResolution: descriptorHeader.computedIDResolution,
          idValueBase: idValueBase,
          idValue: idValue,
          getter: getter,
          setter: setter,
          arguments: arguments,
          externalArgs: genericParamCount > 0 ? externalArgs : nil)
      case .optionalChain, .optionalWrap, .optionalForce, .external:
        _internalInvariantFailure("not possible for property descriptor")
      }
    }
    _internalInvariant(
      {
        let popped = MemoryLayout<Int32>._roundingUpToAlignment(
           bufferSizeBefore - buffer.count)
        return expectedPop == popped
      }(),
      """
      component size consumed during pattern walk does not match \
      component size returned by patternComponentBodySize
      """)
    if buffer.isEmpty { break }
    let componentTypeBase = buffer.baseAddress.unsafelyUnwrapped
    let componentTypeOffset = _pop(from: &buffer, as: Int32.self)
    let componentTypeRef = _resolveRelativeAddress(componentTypeBase,
                                                   componentTypeOffset)
    walker.visitIntermediateComponentType(metadataRef: componentTypeRef)
    _internalInvariant(!buffer.isEmpty)
  }
  _internalInvariant(buffer.isEmpty, "did not walk entire pattern buffer")
  walker.finish()
}
internal struct GetKeyPathClassAndInstanceSizeFromPattern
    : KeyPathPatternVisitor {
  var size: Int = MemoryLayout<Int>.size 
  var capability: KeyPathKind = .value
  var didChain: Bool = false
  var root: Any.Type!
  var leaf: Any.Type!
  var genericEnvironment: UnsafeRawPointer?
  let patternArgs: UnsafeRawPointer?
  var structOffset: UInt32 = 0
  var isPureStruct: [Bool] = []
  init(patternArgs: UnsafeRawPointer?) {
    self.patternArgs = patternArgs
  }
  mutating func roundUpToPointerAlignment() {
    size = MemoryLayout<Int>._roundingUpToAlignment(size)
  }
  mutating func visitHeader(genericEnvironment: UnsafeRawPointer?,
                            rootMetadataRef: MetadataReference,
                            leafMetadataRef: MetadataReference,
                            kvcCompatibilityString: UnsafeRawPointer?) {
    self.genericEnvironment = genericEnvironment
    root = _resolveKeyPathMetadataReference(
              rootMetadataRef,
              genericEnvironment: genericEnvironment,
              arguments: patternArgs)
    leaf = _resolveKeyPathMetadataReference(
              leafMetadataRef,
              genericEnvironment: genericEnvironment,
              arguments: patternArgs)
  }
  mutating func visitStoredComponent(kind: KeyPathStructOrClass,
                                     mutable: Bool,
                                     offset: KeyPathPatternStoredOffset) {
    if mutable {
      switch kind {
      case .class:
        capability = .reference
      case .struct:
        break
      }
    } else {
      capability = .readOnly
    }
    switch offset {
    case .inline:
      size += 4
    case .outOfLine, .unresolvedFieldOffset, .unresolvedIndirectOffset:
      size += 8
    }
  }
  mutating func visitComputedComponent(mutating: Bool,
                                   idKind: KeyPathComputedIDKind,
                                   idResolution: KeyPathComputedIDResolution,
                                   idValueBase: UnsafeRawPointer,
                                   idValue: Int32,
                                   getter: UnsafeRawPointer,
                                   setter: UnsafeRawPointer?,
                                   arguments: KeyPathPatternComputedArguments?,
                                   externalArgs: UnsafeBufferPointer<Int32>?) {
    let settable = setter != nil
    switch (settable, mutating) {
    case (false, false):
      capability = .readOnly
    case (true, false):
      capability = .reference
    case (true, true):
      break
    case (false, true):
      _internalInvariantFailure("unpossible")
    }
    size += 4
    roundUpToPointerAlignment()
    size += MemoryLayout<Int>.size * 2
    if settable {
      size += MemoryLayout<Int>.size
    }
    let argumentHeaderSize = MemoryLayout<Int>.size * 2
    switch (arguments, externalArgs) {
    case (nil, nil):
      break
    case (let arguments?, nil):
      size += argumentHeaderSize
      let (addedSize, addedAlignmentMask) = arguments.getLayout(patternArgs)
      _internalInvariant(addedAlignmentMask < MemoryLayout<Int>.alignment,
                   "overaligned computed property element not supported")
      size += addedSize
    case (let arguments?, let externalArgs?):
      size += argumentHeaderSize
      let (addedSize, addedAlignmentMask) = arguments.getLayout(patternArgs)
      _internalInvariant(addedAlignmentMask < MemoryLayout<Int>.alignment,
                   "overaligned computed property element not supported")
      size += addedSize
      roundUpToPointerAlignment()
      size += RawKeyPathComponent.Header.externalWithArgumentsExtraSize
      size += MemoryLayout<Int>.size * externalArgs.count
    case (nil, let externalArgs?):
      size += argumentHeaderSize
      size += MemoryLayout<Int>.size * externalArgs.count
    }
  }
  mutating func visitOptionalChainComponent() {
    didChain = true
    capability = .readOnly
    size += 4
  }
  mutating func visitOptionalWrapComponent() {
    didChain = true
    capability = .readOnly
    size += 4
  }
  mutating func visitOptionalForceComponent() {
    size += 4
  }
  mutating
  func visitIntermediateComponentType(metadataRef _: MetadataReference) {
    roundUpToPointerAlignment()
    size += MemoryLayout<Int>.size
  }
  mutating func finish() {
  }
}
internal func _getKeyPathClassAndInstanceSizeFromPattern(
  _ pattern: UnsafeRawPointer,
  _ arguments: UnsafeRawPointer
) -> (
  keyPathClass: AnyKeyPath.Type,
  rootType: Any.Type,
  size: Int,
  alignmentMask: Int
) {
  var walker = GetKeyPathClassAndInstanceSizeFromPattern(patternArgs: arguments)
  _walkKeyPathPattern(pattern, walker: &walker)
  if walker.didChain {
    walker.capability = .readOnly
  }
  func openRoot<Root>(_: Root.Type) -> AnyKeyPath.Type {
    func openLeaf<Leaf>(_: Leaf.Type) -> AnyKeyPath.Type {
      switch walker.capability {
      case .readOnly:
        return KeyPath<Root, Leaf>.self
      case .value:
        return WritableKeyPath<Root, Leaf>.self
      case .reference:
        return ReferenceWritableKeyPath<Root, Leaf>.self
      }
    }
    return _openExistential(walker.leaf!, do: openLeaf)
  }
  let classTy = _openExistential(walker.root!, do: openRoot)
  return (keyPathClass: classTy,
          rootType: walker.root!,
          size: walker.size,
          alignmentMask: MemoryLayout<Int>._alignmentMask)
}
internal struct InstantiateKeyPathBuffer: KeyPathPatternVisitor {
  var destData: UnsafeMutableRawBufferPointer
  var genericEnvironment: UnsafeRawPointer?
  let patternArgs: UnsafeRawPointer?
  var base: Any.Type
  var structOffset: UInt32 = 0
  var isPureStruct: [Bool] = []
  init(destData: UnsafeMutableRawBufferPointer,
       patternArgs: UnsafeRawPointer?,
       root: Any.Type) {
    self.destData = destData
    self.patternArgs = patternArgs
    self.base = root
  }
  var isTrivial: Bool = true
  var endOfReferencePrefixComponent: UnsafeMutableRawPointer? = nil
  var previousComponentAddr: UnsafeMutableRawPointer? = nil
  mutating func adjustDestForAlignment<T>(of: T.Type) -> (
    baseAddress: UnsafeMutableRawPointer,
    misalign: Int
  ) {
    let alignment = MemoryLayout<T>.alignment
    var baseAddress = destData.baseAddress.unsafelyUnwrapped
    var misalign = Int(bitPattern: baseAddress) & (alignment - 1)
    if misalign != 0 {
      misalign = alignment - misalign
      baseAddress = baseAddress.advanced(by: misalign)
    }
    return (baseAddress, misalign)
  }
  mutating func pushDest<T>(_ value: T) {
    _internalInvariant(_isPOD(T.self))
    let size = MemoryLayout<T>.size
    let (baseAddress, misalign) = adjustDestForAlignment(of: T.self)
    _withUnprotectedUnsafeBytes(of: value) {
      _memcpy(dest: baseAddress, src: $0.baseAddress.unsafelyUnwrapped,
              size: UInt(size))
    }
    destData = UnsafeMutableRawBufferPointer(
      start: baseAddress + size,
      count: destData.count - size - misalign)
  }
  mutating func pushAddressDiscriminatedFunctionPointer(
    _ unsignedPointer: UnsafeRawPointer,
    discriminator: UInt64
  ) {
    let size = MemoryLayout<UnsafeRawPointer>.size
    let (baseAddress, misalign) =
      adjustDestForAlignment(of: UnsafeRawPointer.self)
    baseAddress._storeFunctionPointerWithAddressDiscrimination(
      unsignedPointer, discriminator: discriminator)
    destData = UnsafeMutableRawBufferPointer(
      start: baseAddress + size,
      count: destData.count - size - misalign)
  }
  mutating func updatePreviousComponentAddr() -> UnsafeMutableRawPointer? {
    let oldValue = previousComponentAddr
    previousComponentAddr = destData.baseAddress.unsafelyUnwrapped
    return oldValue
  }
  mutating func visitHeader(genericEnvironment: UnsafeRawPointer?,
                            rootMetadataRef: MetadataReference,
                            leafMetadataRef: MetadataReference,
                            kvcCompatibilityString: UnsafeRawPointer?) {
    self.genericEnvironment = genericEnvironment
  }
  mutating func visitStoredComponent(kind: KeyPathStructOrClass,
                                     mutable: Bool,
                                     offset: KeyPathPatternStoredOffset) {
    let previous = updatePreviousComponentAddr()
    switch kind {
        case .struct:
      isPureStruct.append(true)
        default:
      isPureStruct.append(false)
    }
    switch kind {
    case .class:
      if mutable {
        endOfReferencePrefixComponent = previous
      }
      fallthrough
    case .struct:
      switch offset {
      case .inline(let value):
        let header = RawKeyPathComponent.Header(stored: kind,
                                                mutable: mutable,
                                                inlineOffset: value)
        pushDest(header)
        switch kind {
          case .struct:
            structOffset += value
          default:
             break
        }
      case .outOfLine(let offset):
        let header = RawKeyPathComponent.Header(storedWithOutOfLineOffset: kind,
                                                mutable: mutable)
        pushDest(header)
        pushDest(offset)
      case .unresolvedFieldOffset(let offsetOfOffset):
        let metadataPtr = unsafeBitCast(base, to: UnsafeRawPointer.self)
        let offset: UInt32
        switch kind {
        case .class:
          offset = UInt32(metadataPtr.load(fromByteOffset: Int(offsetOfOffset),
                                           as: UInt.self))
        case .struct:
          offset = UInt32(metadataPtr.load(fromByteOffset: Int(offsetOfOffset),
                                           as: UInt32.self))
          structOffset += offset
        }
        let header = RawKeyPathComponent.Header(storedWithOutOfLineOffset: kind,
                                                mutable: mutable)
        pushDest(header)
        pushDest(offset)
      case .unresolvedIndirectOffset(let pointerToOffset):
        _internalInvariant(pointerToOffset.pointee <= UInt32.max)
        let offset = UInt32(truncatingIfNeeded: pointerToOffset.pointee)
        let header = RawKeyPathComponent.Header(storedWithOutOfLineOffset: kind,
                                                mutable: mutable)
        pushDest(header)
        pushDest(offset)
      }
    }
  }
  mutating func visitComputedComponent(mutating: Bool,
                                   idKind: KeyPathComputedIDKind,
                                   idResolution: KeyPathComputedIDResolution,
                                   idValueBase: UnsafeRawPointer,
                                   idValue: Int32,
                                   getter: UnsafeRawPointer,
                                   setter: UnsafeRawPointer?,
                                   arguments: KeyPathPatternComputedArguments?,
                                   externalArgs: UnsafeBufferPointer<Int32>?) {
    isPureStruct.append(false)
    let previous = updatePreviousComponentAddr()
    let settable = setter != nil
    if settable && !mutating {
      endOfReferencePrefixComponent = previous
    }
    let resolvedID: UnsafeRawPointer?
    switch idKind {
    case .storedPropertyIndex, .vtableOffset:
      _internalInvariant(idResolution == .resolved)
      let value = UInt(UInt32(bitPattern: idValue))
      resolvedID = UnsafeRawPointer(bitPattern: value)
    case .pointer:
      switch idResolution {
      case .resolved:
        resolvedID = _resolveRelativeAddress(idValueBase, idValue)
        break
      case .resolvedAbsolute:
        let value = UInt(UInt32(bitPattern: idValue))
        resolvedID = UnsafeRawPointer(bitPattern: value)
        break
      case .indirectPointer:
        let absoluteID = _resolveRelativeAddress(idValueBase, idValue)
        resolvedID = absoluteID
          .load(as: UnsafeRawPointer?.self)
      case .functionCall:
        typealias Resolver = @convention(c) (UnsafeRawPointer?) -> UnsafeRawPointer?
        let absoluteID = _resolveCompactFunctionPointer(idValueBase, idValue)
        let resolverSigned = _PtrAuth.sign(
          pointer: absoluteID,
          key: .processIndependentCode,
          discriminator: _PtrAuth.discriminator(for: Resolver.self))
        let resolverFn = unsafeBitCast(resolverSigned,
                                       to: Resolver.self)
        resolvedID = resolverFn(patternArgs)
      }
    }
    let header = RawKeyPathComponent.Header(computedWithIDKind: idKind,
          mutating: mutating,
          settable: settable,
          hasArguments: arguments != nil || externalArgs != nil,
          instantiatedFromExternalWithArguments:
            arguments != nil && externalArgs != nil)
    pushDest(header)
    pushDest(resolvedID)
    pushAddressDiscriminatedFunctionPointer(getter,
                           discriminator: ComputedAccessorsPtr.getterPtrAuthKey)
    if let setter = setter {
      pushAddressDiscriminatedFunctionPointer(setter,
        discriminator: mutating ? ComputedAccessorsPtr.mutatingSetterPtrAuthKey
                             : ComputedAccessorsPtr.nonmutatingSetterPtrAuthKey)
    }
    if let arguments = arguments {
      let (baseSize, alignmentMask) = arguments.getLayout(patternArgs)
      _internalInvariant(alignmentMask < MemoryLayout<Int>.alignment,
                   "overaligned computed arguments not implemented yet")
      var totalSize = (baseSize + alignmentMask) & ~alignmentMask
      if let externalArgs = externalArgs {
        totalSize = MemoryLayout<Int>._roundingUpToAlignment(totalSize)
        totalSize += MemoryLayout<Int>.size * externalArgs.count
      }
      pushDest(totalSize)
      pushDest(arguments.witnesses)
      if let _ = arguments.witnesses.destroy {
        isTrivial = false
      }
      if let externalArgs = externalArgs {
        pushDest(externalArgs.count * MemoryLayout<Int>.size)
      }
      _internalInvariant(Int(bitPattern: destData.baseAddress) & alignmentMask == 0,
                   "argument destination not aligned")
      arguments.initializer(patternArgs,
                            destData.baseAddress.unsafelyUnwrapped)
      destData = UnsafeMutableRawBufferPointer(
        start: destData.baseAddress.unsafelyUnwrapped + baseSize,
        count: destData.count - baseSize)
    }
    if let externalArgs = externalArgs {
      if arguments == nil {
        let stride = MemoryLayout<Int>.size * externalArgs.count
        pushDest(stride)
        pushDest(__swift_keyPathGenericWitnessTable_addr())
      }
      for i in externalArgs.indices {
        let base = externalArgs.baseAddress.unsafelyUnwrapped + i
        let offset = base.pointee
        let metadataRef = _resolveRelativeAddress(UnsafeRawPointer(base), offset)
        let result = _resolveKeyPathGenericArgReference(
                       metadataRef,
                       genericEnvironment: genericEnvironment,
                       arguments: patternArgs)
        pushDest(result)
      }
    }
  }
  mutating func visitOptionalChainComponent() {
    isPureStruct.append(false)
    let _ = updatePreviousComponentAddr()
    let header = RawKeyPathComponent.Header(optionalChain: ())
    pushDest(header)
  }
  mutating func visitOptionalWrapComponent() {
    isPureStruct.append(false)
    let _ = updatePreviousComponentAddr()
    let header = RawKeyPathComponent.Header(optionalWrap: ())
    pushDest(header)
  }
  mutating func visitOptionalForceComponent() {
    isPureStruct.append(false)
    let _ = updatePreviousComponentAddr()
    let header = RawKeyPathComponent.Header(optionalForce: ())
    pushDest(header)
  }
  mutating func visitIntermediateComponentType(metadataRef: MetadataReference) {
    let metadata = _resolveKeyPathMetadataReference(
                     metadataRef,
                     genericEnvironment: genericEnvironment,
                     arguments: patternArgs)
    pushDest(metadata)
    base = metadata
  }
  mutating func finish() {
    _internalInvariant(destData.isEmpty,
                 "should have filled entire destination buffer")
  }
}
#if INTERNAL_CHECKS_ENABLED
internal struct ValidatingInstantiateKeyPathBuffer: KeyPathPatternVisitor {
  var sizeVisitor: GetKeyPathClassAndInstanceSizeFromPattern
  var instantiateVisitor: InstantiateKeyPathBuffer
  let origDest: UnsafeMutableRawPointer
  var structOffset: UInt32 = 0
  var isPureStruct: [Bool] = []
  init(sizeVisitor: GetKeyPathClassAndInstanceSizeFromPattern,
       instantiateVisitor: InstantiateKeyPathBuffer) {
    self.sizeVisitor = sizeVisitor
    self.instantiateVisitor = instantiateVisitor
    origDest = self.instantiateVisitor.destData.baseAddress.unsafelyUnwrapped
  }
  mutating func visitHeader(genericEnvironment: UnsafeRawPointer?,
                            rootMetadataRef: MetadataReference,
                            leafMetadataRef: MetadataReference,
                            kvcCompatibilityString: UnsafeRawPointer?) {
    sizeVisitor.visitHeader(genericEnvironment: genericEnvironment,
                            rootMetadataRef: rootMetadataRef,
                            leafMetadataRef: leafMetadataRef,
                            kvcCompatibilityString: kvcCompatibilityString)
    instantiateVisitor.visitHeader(genericEnvironment: genericEnvironment,
                                 rootMetadataRef: rootMetadataRef,
                                 leafMetadataRef: leafMetadataRef,
                                 kvcCompatibilityString: kvcCompatibilityString)
  }
  mutating func visitStoredComponent(kind: KeyPathStructOrClass,
                                     mutable: Bool,
                                     offset: KeyPathPatternStoredOffset) {
    sizeVisitor.visitStoredComponent(kind: kind, mutable: mutable,
                                     offset: offset)
    instantiateVisitor.visitStoredComponent(kind: kind, mutable: mutable,
                                            offset: offset)
    checkSizeConsistency()
    structOffset = instantiateVisitor.structOffset
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
  }
  mutating func visitComputedComponent(mutating: Bool,
                                   idKind: KeyPathComputedIDKind,
                                   idResolution: KeyPathComputedIDResolution,
                                   idValueBase: UnsafeRawPointer,
                                   idValue: Int32,
                                   getter: UnsafeRawPointer,
                                   setter: UnsafeRawPointer?,
                                   arguments: KeyPathPatternComputedArguments?,
                                   externalArgs: UnsafeBufferPointer<Int32>?) {
    sizeVisitor.visitComputedComponent(mutating: mutating,
                                       idKind: idKind,
                                       idResolution: idResolution,
                                       idValueBase: idValueBase,
                                       idValue: idValue,
                                       getter: getter,
                                       setter: setter,
                                       arguments: arguments,
                                       externalArgs: externalArgs)
    instantiateVisitor.visitComputedComponent(mutating: mutating,
                                       idKind: idKind,
                                       idResolution: idResolution,
                                       idValueBase: idValueBase,
                                       idValue: idValue,
                                       getter: getter,
                                       setter: setter,
                                       arguments: arguments,
                                       externalArgs: externalArgs)
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  mutating func visitOptionalChainComponent() {
    sizeVisitor.visitOptionalChainComponent()
    instantiateVisitor.visitOptionalChainComponent()
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  mutating func visitOptionalWrapComponent() {
    sizeVisitor.visitOptionalWrapComponent()
    instantiateVisitor.visitOptionalWrapComponent()
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  mutating func visitOptionalForceComponent() {
    sizeVisitor.visitOptionalForceComponent()
    instantiateVisitor.visitOptionalForceComponent()
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  mutating func visitIntermediateComponentType(metadataRef: MetadataReference) {
    sizeVisitor.visitIntermediateComponentType(metadataRef: metadataRef)
    instantiateVisitor.visitIntermediateComponentType(metadataRef: metadataRef)
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  mutating func finish() {
    sizeVisitor.finish()
    instantiateVisitor.finish()
    isPureStruct.append(contentsOf: instantiateVisitor.isPureStruct)
    checkSizeConsistency()
  }
  func checkSizeConsistency() {
    let nextDest = instantiateVisitor.destData.baseAddress.unsafelyUnwrapped
    let curSize = nextDest - origDest + MemoryLayout<Int>.size
    _internalInvariant(curSize == sizeVisitor.size,
                 "size and instantiation visitors out of sync")
  }
}
#endif 
internal func _instantiateKeyPathBuffer(
  _ pattern: UnsafeRawPointer,
  _ origDestData: UnsafeMutableRawBufferPointer,
  _ rootType: Any.Type,
  _ arguments: UnsafeRawPointer
) -> UInt32? {
  let destHeaderPtr = origDestData.baseAddress.unsafelyUnwrapped
  var destData = UnsafeMutableRawBufferPointer(
    start: destHeaderPtr.advanced(by: MemoryLayout<Int>.size),
    count: origDestData.count - MemoryLayout<Int>.size)
#if INTERNAL_CHECKS_ENABLED
  let sizeWalker = GetKeyPathClassAndInstanceSizeFromPattern(
    patternArgs: arguments)
  let instantiateWalker = InstantiateKeyPathBuffer(
    destData: destData,
    patternArgs: arguments,
    root: rootType)
  var walker = ValidatingInstantiateKeyPathBuffer(sizeVisitor: sizeWalker,
                                          instantiateVisitor: instantiateWalker)
#else
  var walker = InstantiateKeyPathBuffer(
    destData: destData,
    patternArgs: arguments,
    root: rootType)
#endif
  _walkKeyPathPattern(pattern, walker: &walker)
#if INTERNAL_CHECKS_ENABLED
  let isTrivial = walker.instantiateVisitor.isTrivial
  let endOfReferencePrefixComponent =
    walker.instantiateVisitor.endOfReferencePrefixComponent
#else
  let isTrivial = walker.isTrivial
  let endOfReferencePrefixComponent = walker.endOfReferencePrefixComponent
#endif
  let destHeader = KeyPathBuffer.Header(
    size: origDestData.count - MemoryLayout<Int>.size,
    trivial: isTrivial,
    hasReferencePrefix: endOfReferencePrefixComponent != nil)
  destHeaderPtr.storeBytes(of: destHeader, as: KeyPathBuffer.Header.self)
  if let endOfReferencePrefixComponent = endOfReferencePrefixComponent {
    var componentHeader = endOfReferencePrefixComponent
      .load(as: RawKeyPathComponent.Header.self)
    componentHeader.endOfReferencePrefix = true
    endOfReferencePrefixComponent.storeBytes(of: componentHeader,
      as: RawKeyPathComponent.Header.self)
  }
  var isPureStruct = true
  var offset: UInt32? = nil
  for value in walker.isPureStruct {
    isPureStruct = isPureStruct && value
  }
  if isPureStruct {
      offset = walker.structOffset
  }
  return offset
}
#if SWIFT_ENABLE_REFLECTION
@available(SwiftStdlib 5.9, *)
public func _createOffsetBasedKeyPath(
  root: Any.Type,
  value: Any.Type,
  offset: Int
) -> AnyKeyPath {
  func openRoot<Root>(_: Root.Type) -> AnyKeyPath.Type {
    func openValue<Value>(_: Value.Type) -> AnyKeyPath.Type {
      KeyPath<Root, Value>.self
    }
    return _openExistential(value, do: openValue(_:))
  }
  let kpTy = _openExistential(root, do: openRoot(_:))
  let kpBufferSize = MemoryLayout<Int>.size + MemoryLayout<Int32>.size
  let kp = kpTy._create(capacityInBytes: kpBufferSize) {
    var builder = KeyPathBuffer.Builder($0)
    let header = KeyPathBuffer.Header(
      size: kpBufferSize - MemoryLayout<Int>.size,
      trivial: true,
      hasReferencePrefix: false
    )
    builder.pushHeader(header)
    let componentHeader = RawKeyPathComponent.Header(
      stored: _MetadataKind(root) == .struct ? .struct : .class,
      mutable: false,
      inlineOffset: UInt32(offset)
    )
    let component = RawKeyPathComponent(
      header: componentHeader,
      body: UnsafeRawBufferPointer(start: nil, count: 0)
    )
    component.clone(into: &builder.buffer, endOfReferencePrefix: false)
  }
  if _MetadataKind(root) == .struct {
    kp.assignOffsetToStorage(offset: offset)
  }
  return kp
}
fileprivate func keyPath_copySymbolName(
  _: UnsafeRawPointer
) -> UnsafePointer<CChar>?
fileprivate func keyPath_freeSymbolName(
  _: UnsafePointer<CChar>?
) -> Void
fileprivate func demangle(
  name: UnsafePointer<CChar>
) -> UnsafeMutablePointer<CChar>?
fileprivate func dynamicLibraryAddress<Base, Leaf>(
  of pointer: ComputedAccessorsPtr,
  _: Base.Type,
  _ leaf: Leaf.Type
) -> String {
  let getter: ComputedAccessorsPtr.Getter<Base, Leaf> = pointer.getter()
  let pointer = unsafeBitCast(getter, to: UnsafeRawPointer.self)
  if let cString = keyPath_copySymbolName(UnsafeRawPointer(pointer)) {
    defer {
      keyPath_freeSymbolName(cString)
    }
    if let demangled = demangle(name: cString)
      .map({ pointer in
        defer {
          pointer.deallocate()
        }
        return String(cString: pointer)
    }) {
      return demangled
    }
  }
  return "<computed \(pointer) (\(leaf))>"
}
#endif
@available(SwiftStdlib 5.8, *)
extension AnyKeyPath: CustomDebugStringConvertible {
#if SWIFT_ENABLE_REFLECTION
  @available(SwiftStdlib 5.8, *)
  public var debugDescription: String {
    var description = "\\\(String(describing: Self.rootType))"
    return withBuffer {
      var buffer = $0
      if buffer.data.isEmpty {
        description.append(".self")
        return description
      }
      var valueType: Any.Type = Self.rootType
      while true {
        let (rawComponent, optNextType) = buffer.next()
        let hasEnded = optNextType == nil
        let nextType = optNextType ?? Self.valueType
        switch rawComponent.value {
        case .optionalForce, .optionalWrap, .optionalChain:
          break
        default:
          description.append(".")
        }
        switch rawComponent.value {
        case .class(let offset),
            .struct(let offset):
          let count = _getRecursiveChildCount(valueType)
          let index = (0..<count)
            .first(where: { i in
              _getChildOffset(
                valueType,
                index: i
              ) == offset
            })
          if let index = index {
            var field = _FieldReflectionMetadata()
            _ = _getChildMetadata(
              valueType,
              index: index,
              fieldMetadata: &field
            )
            defer {
              field.freeFunc?(field.name)
            }
            description.append(String(cString: field.name))
          } else {
            description.append("<offset \(offset) (\(nextType))>")
          }
        case .get(_, let accessors, _),
            .nonmutatingGetSet(_, let accessors, _),
            .mutatingGetSet(_, let accessors, _):
          func project<Base>(base: Base.Type) -> String {
            func project2<Leaf>(leaf: Leaf.Type) -> String {
              dynamicLibraryAddress(
                of: accessors,
                base,
                leaf
              )
            }
            return _openExistential(nextType, do: project2)
          }
          description.append(
            _openExistential(valueType, do: project)
          )
        case .optionalChain, .optionalWrap:
          description.append("?")
        case .optionalForce:
          description.append("!")
        }
        if hasEnded {
          break
        }
        valueType = nextType
      }
      return description
    }
  }
#else
  @available(SwiftStdlib 5.8, *)
  public var debugDescription: String {
    "(value cannot be printed without reflection)"
  }
#endif
}
