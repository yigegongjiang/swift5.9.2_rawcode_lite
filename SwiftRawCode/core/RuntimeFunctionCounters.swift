#if SWIFT_ENABLE_RUNTIME_FUNCTION_COUNTERS
internal func _collectAllReferencesInsideObjectImpl(
  _ value: Any,
  references: inout [UnsafeRawPointer],
  visitedItems: inout [ObjectIdentifier: Int]
) {
  let mirror = Mirror(internalReflecting: value)
  let id: ObjectIdentifier?
  let ref: UnsafeRawPointer?
  if type(of: value) is AnyObject.Type {
    let toAnyObject = _unsafeDowncastToAnyObject(fromAny: value)
    ref = UnsafeRawPointer(Unmanaged.passUnretained(toAnyObject).toOpaque())
    id = ObjectIdentifier(toAnyObject)
  } else if type(of: value) is Builtin.BridgeObject.Type {
    ref = UnsafeRawPointer(
      Builtin.bridgeToRawPointer(value as! Builtin.BridgeObject))
    id = nil
  } else if type(of: value) is Builtin.NativeObject.Type  {
    ref = UnsafeRawPointer(
      Builtin.bridgeToRawPointer(value as! Builtin.NativeObject))
    id = nil
  } else if let metatypeInstance = value as? Any.Type {
    id = ObjectIdentifier(metatypeInstance)
    ref = nil
  } else {
    id = nil
    ref = nil
  }
  if let theId = id {
    if visitedItems[theId] != nil {
      return
    }
    let identifier = visitedItems.count
    visitedItems[theId] = identifier
  }
  if let ref = ref {
    references.append(ref)
  }
  let count = mirror.children.count
  var currentIndex = mirror.children.startIndex
  for _ in 0..<count {
    let (_, child) = mirror.children[currentIndex]
    mirror.children.formIndex(after: &currentIndex)
    _collectAllReferencesInsideObjectImpl(
      child,
      references: &references,
      visitedItems: &visitedItems)
  }
}
public 
struct _RuntimeFunctionCounters {
#if os(Windows) && arch(x86_64)
  public typealias RuntimeFunctionCountersUpdateHandler =
    @convention(c) (_ object: UnsafeRawPointer, _ functionId: Int) -> Void
#else
  public typealias RuntimeFunctionCountersUpdateHandler =
    @convention(c) (_ object: UnsafeRawPointer, _ functionId: Int64) -> Void
#endif
  public static let runtimeFunctionNames =
    getRuntimeFunctionNames()
  public static let runtimeFunctionCountersOffsets =
    _RuntimeFunctionCounters.getRuntimeFunctionCountersOffsets()
  public static let numRuntimeFunctionCounters =
    Int(_RuntimeFunctionCounters.getNumRuntimeFunctionCounters())
  public static let runtimeFunctionNameToIndex: [String: Int] =
    getRuntimeFunctionNameToIndex()
  public static func _getRuntimeFunctionNames() ->
    UnsafePointer<UnsafePointer<CChar>>
  public static func getRuntimeFunctionNames() -> [String] {
    let names = _RuntimeFunctionCounters._getRuntimeFunctionNames()
    let numRuntimeFunctionCounters =
      Int(_RuntimeFunctionCounters.getNumRuntimeFunctionCounters())
    var functionNames: [String] = []
    functionNames.reserveCapacity(numRuntimeFunctionCounters)
    for index in 0..<numRuntimeFunctionCounters {
      let name = String(cString: names[index])
      functionNames.append(name)
    }
    return functionNames
  }
  public static func getRuntimeFunctionCountersOffsets() ->
    UnsafePointer<UInt16>
  public static func getNumRuntimeFunctionCounters() -> UInt64
  public static func dumpObjectsRuntimeFunctionPointers()
  @discardableResult
  public static func setGlobalRuntimeFunctionCountersUpdateHandler(
    handler: RuntimeFunctionCountersUpdateHandler?
  ) -> RuntimeFunctionCountersUpdateHandler?
  public static func collectAllReferencesInsideObject(_ value: Any) ->
    [UnsafeRawPointer] {
    var visited: [ObjectIdentifier: Int] = [:]
    var references: [UnsafeRawPointer] = []
    _collectAllReferencesInsideObjectImpl(
      value, references: &references, visitedItems: &visited)
    return references
  }
  internal static func getRuntimeFunctionNameToIndex() -> [String: Int] {
    let runtimeFunctionNames = _RuntimeFunctionCounters.getRuntimeFunctionNames()
    let numRuntimeFunctionCounters =
      Int(_RuntimeFunctionCounters.getNumRuntimeFunctionCounters())
    var runtimeFunctionNameToIndex: [String: Int] = [:]
    runtimeFunctionNameToIndex.reserveCapacity(numRuntimeFunctionCounters)
    for index in 0..<numRuntimeFunctionCounters {
      let name = runtimeFunctionNames[index]
      runtimeFunctionNameToIndex[name] = index
    }
    return runtimeFunctionNameToIndex
  }
}
public 
protocol _RuntimeFunctionCountersStats: CustomDebugStringConvertible {
  init()
  func dump<T: TextOutputStream>(skipUnchanged: Bool, to: inout T)
  func dumpDiff<T: TextOutputStream>(
    _ after: Self, skipUnchanged: Bool, to: inout T
  )
  func diff(_ other: Self) -> Self
  subscript(_ counterName: String) -> UInt32 { get set }
  subscript(_ index: Int) -> UInt32 { get set }
}
extension _RuntimeFunctionCountersStats {
  public func dump(skipUnchanged: Bool) {
    var output = _Stdout()
    dump(skipUnchanged: skipUnchanged, to: &output)
  }
  public func dumpDiff(_ after: Self, skipUnchanged: Bool) {
    var output = _Stdout()
    dumpDiff(after, skipUnchanged: skipUnchanged, to: &output)
  }
}
extension _RuntimeFunctionCountersStats {
  public var debugDescription: String {
    var result = ""
    dump(skipUnchanged: true, to: &result)
    return result
  }
}
internal struct _RuntimeFunctionCountersState: _RuntimeFunctionCountersStats {
  typealias Counters =
  (
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32, UInt32,
    UInt32, UInt32, UInt32, UInt32
  )
  private var counters: Counters = (
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0), UInt32(0),
    UInt32(0), UInt32(0), UInt32(0), UInt32(0)
  )
  subscript(_ counterName: String) -> UInt32 {
    get {
      if let index = _RuntimeFunctionCounters.runtimeFunctionNameToIndex[counterName] {
        return self[index]
      }
      fatalError("Unknown counter name: \(counterName)")
    }
    set {
      if let index = _RuntimeFunctionCounters.runtimeFunctionNameToIndex[counterName] {
        self[index] = newValue
        return
      }
      fatalError("Unknown counter name: \(counterName)")
    }
  }
  subscript(_ index: Int) -> UInt32 {
    @inline(never)
    get {
      if (index >= _RuntimeFunctionCounters.numRuntimeFunctionCounters) {
        fatalError("Counter index should be in the range " +
          "0..<\(_RuntimeFunctionCounters.numRuntimeFunctionCounters)")
      }
      var tmpCounters = counters
      let counter: UInt32 = withUnsafePointer(to: &tmpCounters) { ptr in
        return ptr.withMemoryRebound(to: UInt32.self, capacity: 64) { buf in
          return buf[index]
        }
      }
      return counter
    }
    @inline(never)
    set {
      if (index >= _RuntimeFunctionCounters.numRuntimeFunctionCounters) {
        fatalError("Counter index should be in the range " +
          "0..<\(_RuntimeFunctionCounters.numRuntimeFunctionCounters)")
      }
      withUnsafeMutablePointer(to: &counters) {
        $0.withMemoryRebound(to: UInt32.self, capacity: 64) {
          $0[index] = newValue
        }
      }
    }
  }
}
extension _RuntimeFunctionCounters {
  internal static func getObjectRuntimeFunctionCounters(
    _ object: UnsafeRawPointer, _ result: inout _RuntimeFunctionCountersState)
  internal static func getGlobalRuntimeFunctionCounters(
    _ result: inout _RuntimeFunctionCountersState)
  internal static func setGlobalRuntimeFunctionCounters(
    _ state: inout _RuntimeFunctionCountersState)
  internal static func setObjectRuntimeFunctionCounters(
    _ object: UnsafeRawPointer,
    _ state: inout _RuntimeFunctionCountersState)
  @discardableResult
  static
  public 
  func setGlobalRuntimeFunctionCountersMode(enable: Bool) -> Bool
  @discardableResult
  static
  public 
  func setPerObjectRuntimeFunctionCountersMode(enable: Bool) -> Bool
  static
  public 
  func enableRuntimeFunctionCountersUpdates(
    mode: (globalMode: Bool, perObjectMode: Bool) = (true, true)) {
      _RuntimeFunctionCounters.setGlobalRuntimeFunctionCountersMode(
        enable: mode.globalMode)
      _RuntimeFunctionCounters.setPerObjectRuntimeFunctionCountersMode(
        enable: mode.perObjectMode)
  }
  static
  public 
  func disableRuntimeFunctionCountersUpdates() ->
    (globalMode: Bool, perObjectMode: Bool) {
      let oldGlobalMode =
        _RuntimeFunctionCounters.setGlobalRuntimeFunctionCountersMode(
          enable: false)
      let oldPerObjectMode =
        _RuntimeFunctionCounters.setPerObjectRuntimeFunctionCountersMode(
          enable: false)
      return (oldGlobalMode, oldPerObjectMode)
  }
}
extension _RuntimeFunctionCountersStats {
  typealias Counters = _RuntimeFunctionCounters
  @inline(never)
  public 
  func dump<T: TextOutputStream>(skipUnchanged: Bool, to: inout T) {
    for i in 0..<Counters.numRuntimeFunctionCounters {
      if skipUnchanged && self[i] == 0 {
        continue
      }
      print("counter \(i) : " +
        "\(Counters.runtimeFunctionNames[i])" +
        " at offset: " +
        "\(Counters.runtimeFunctionCountersOffsets[i]):" +
        "  \(self[i])", to: &to)
    }
  }
  @inline(never)
  public 
  func dumpDiff<T: TextOutputStream>(
    _ after: Self, skipUnchanged: Bool, to: inout T
  ) {
    for i in 0..<Counters.numRuntimeFunctionCounters {
      if self[i] == 0 && after[i] == 0 {
        continue
      }
      if skipUnchanged && self[i] == after[i] {
        continue
      }
      print("counter \(i) : " +
        "\(Counters.runtimeFunctionNames[i])" +
        " at offset: " +
        "\(Counters.runtimeFunctionCountersOffsets[i]): " +
        "before \(self[i]) " +
        "after \(after[i])" + " diff=\(after[i]-self[i])", to: &to)
    }
  }
  public 
  func diff(_ other: Self) -> Self {
    var result = Self()
    for i in 0..<Counters.numRuntimeFunctionCounters {
      result[i] = other[i] - self[i]
    }
    return result
  }
}
public 
struct _GlobalRuntimeFunctionCountersState: _RuntimeFunctionCountersStats {
  var state = _RuntimeFunctionCountersState()
  public init() {
    getGlobalRuntimeFunctionCounters()
  }
  mutating public func getGlobalRuntimeFunctionCounters() {
    _RuntimeFunctionCounters.getGlobalRuntimeFunctionCounters(&state)
  }
  mutating public func setGlobalRuntimeFunctionCounters() {
    _RuntimeFunctionCounters.setGlobalRuntimeFunctionCounters(&state)
  }
  public subscript(_ index: String) -> UInt32 {
    get {
      return state[index]
    }
    set {
      state[index] = newValue
    }
  }
  public subscript(_ index: Int) -> UInt32 {
    get {
      return state[index]
    }
    set {
      state[index] = newValue
    }
  }
}
public 
struct _ObjectRuntimeFunctionCountersState: _RuntimeFunctionCountersStats {
  var state = _RuntimeFunctionCountersState()
  public init(_ p: UnsafeRawPointer) {
    getObjectRuntimeFunctionCounters(p)
  }
  public init() {
  }
  mutating public func getObjectRuntimeFunctionCounters(_ o: UnsafeRawPointer) {
    _RuntimeFunctionCounters.getObjectRuntimeFunctionCounters(o, &state)
  }
  mutating public func setObjectRuntimeFunctionCounters(_ o: UnsafeRawPointer) {
    _RuntimeFunctionCounters.setObjectRuntimeFunctionCounters(o, &state)
  }
  public subscript(_ index: String) -> UInt32 {
    get {
      return state[index]
    }
    set {
      state[index] = newValue
    }
  }
  public subscript(_ index: Int) -> UInt32 {
    get {
      return state[index]
    }
    set {
      state[index] = newValue
    }
  }
}
public 
func _collectReferencesInsideObject(_ value: Any) -> [UnsafeRawPointer] {
  let savedMode = _RuntimeFunctionCounters.disableRuntimeFunctionCountersUpdates()
  let refs = _RuntimeFunctionCounters.collectAllReferencesInsideObject(value)
  _RuntimeFunctionCounters.enableRuntimeFunctionCountersUpdates(mode: savedMode)
  return refs
}
public 
func _measureRuntimeFunctionCountersDiffs(
  objects: [UnsafeRawPointer], _ body: () -> Void) ->
  (_GlobalRuntimeFunctionCountersState, [_ObjectRuntimeFunctionCountersState]) {
    let savedMode =
      _RuntimeFunctionCounters.disableRuntimeFunctionCountersUpdates()
    let globalCountersBefore = _GlobalRuntimeFunctionCountersState()
    var objectsCountersBefore: [_ObjectRuntimeFunctionCountersState] = []
    for object in objects {
      objectsCountersBefore.append(_ObjectRuntimeFunctionCountersState(object))
    }
    _RuntimeFunctionCounters.enableRuntimeFunctionCountersUpdates(
      mode: (globalMode: true, perObjectMode: true))
    body()
    _RuntimeFunctionCounters.enableRuntimeFunctionCountersUpdates(
    mode: (globalMode: false, perObjectMode: false))
    let globalCountersAfter = _GlobalRuntimeFunctionCountersState()
    var objectsCountersDiff: [_ObjectRuntimeFunctionCountersState] = []
    for (idx, object) in objects.enumerated() {
      let objectCountersAfter = _ObjectRuntimeFunctionCountersState(object)
      objectsCountersDiff.append(
        objectsCountersBefore[idx].diff(objectCountersAfter))
    }
    _RuntimeFunctionCounters.enableRuntimeFunctionCountersUpdates(
      mode: savedMode)
    return (globalCountersBefore.diff(globalCountersAfter), objectsCountersDiff)
}
#endif
