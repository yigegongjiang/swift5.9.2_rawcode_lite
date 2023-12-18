#if SWIFT_ENABLE_REFLECTION
@discardableResult
public func dump<T, TargetStream: TextOutputStream>(
  _ value: T,
  to target: inout TargetStream,
  name: String? = nil,
  indent: Int = 0,
  maxDepth: Int = .max,
  maxItems: Int = .max
) -> T {
  var maxItemCounter = maxItems
  var visitedItems = [ObjectIdentifier: Int]()
  target._lock()
  defer { target._unlock() }
  _dump_unlocked(
    value,
    to: &target,
    name: name,
    indent: indent,
    maxDepth: maxDepth,
    maxItemCounter: &maxItemCounter,
    visitedItems: &visitedItems)
  return value
}
@discardableResult
public func dump<T>(
  _ value: T,
  name: String? = nil,
  indent: Int = 0,
  maxDepth: Int = .max,
  maxItems: Int = .max
) -> T {
  var stdoutStream = _Stdout()
  return dump(
    value,
    to: &stdoutStream,
    name: name,
    indent: indent,
    maxDepth: maxDepth,
    maxItems: maxItems)
}
internal func _dump_unlocked<TargetStream: TextOutputStream>(
  _ value: Any,
  to target: inout TargetStream,
  name: String?,
  indent: Int,
  maxDepth: Int,
  maxItemCounter: inout Int,
  visitedItems: inout [ObjectIdentifier: Int]
) {
  guard maxItemCounter > 0 else { return }
  maxItemCounter -= 1
  for _ in 0..<indent { target.write(" ") }
  let mirror = Mirror(reflecting: value)
  let count = mirror.children.count
  let bullet = count == 0    ? "-"
             : maxDepth <= 0 ? "▹" : "▿"
  target.write(bullet)
  target.write(" ")
  if let name = name {
    target.write(name)
    target.write(": ")
  }
  _dumpPrint_unlocked(value, mirror, &target)
  let id: ObjectIdentifier?
  if type(of: value) is AnyObject.Type {
    id = ObjectIdentifier(_unsafeDowncastToAnyObject(fromAny: value))
  } else if let metatypeInstance = value as? Any.Type {
    id = ObjectIdentifier(metatypeInstance)
  } else {
    id = nil
  }
  if let theId = id {
    if let previous = visitedItems[theId] {
      target.write(" #")
      _print_unlocked(previous, &target)
      target.write("\n")
      return
    }
    let identifier = visitedItems.count
    visitedItems[theId] = identifier
    target.write(" #")
    _print_unlocked(identifier, &target)
  }
  target.write("\n")
  guard maxDepth > 0 else { return }
  if let superclassMirror = mirror.superclassMirror {
    _dumpSuperclass_unlocked(
      mirror: superclassMirror,
      to: &target,
      indent: indent + 2,
      maxDepth: maxDepth - 1,
      maxItemCounter: &maxItemCounter,
      visitedItems: &visitedItems)
  }
  var currentIndex = mirror.children.startIndex
  for i in 0..<count {
    if maxItemCounter <= 0 {
      for _ in 0..<(indent+4) {
        _print_unlocked(" ", &target)
      }
      let remainder = count - i
      target.write("(")
      _print_unlocked(remainder, &target)
      if i > 0 { target.write(" more") }
      if remainder == 1 {
        target.write(" child)\n")
      } else {
        target.write(" children)\n")
      }
      return
    }
    let (name, child) = mirror.children[currentIndex]
    mirror.children.formIndex(after: &currentIndex)
    _dump_unlocked(
      child,
      to: &target,
      name: name,
      indent: indent + 2,
      maxDepth: maxDepth - 1,
      maxItemCounter: &maxItemCounter,
      visitedItems: &visitedItems)
  }
}
internal func _dumpSuperclass_unlocked<TargetStream: TextOutputStream>(
  mirror: Mirror,
  to target: inout TargetStream,
  indent: Int,
  maxDepth: Int,
  maxItemCounter: inout Int,
  visitedItems: inout [ObjectIdentifier: Int]
) {
  guard maxItemCounter > 0 else { return }
  maxItemCounter -= 1
  for _ in 0..<indent { target.write(" ") }
  let count = mirror.children.count
  let bullet = count == 0    ? "-"
             : maxDepth <= 0 ? "▹" : "▿"
  target.write(bullet)
  target.write(" super: ")
  _debugPrint_unlocked(mirror.subjectType, &target)
  target.write("\n")
  guard maxDepth > 0 else { return }
  if let superclassMirror = mirror.superclassMirror {
    _dumpSuperclass_unlocked(
      mirror: superclassMirror,
      to: &target,
      indent: indent + 2,
      maxDepth: maxDepth - 1,
      maxItemCounter: &maxItemCounter,
      visitedItems: &visitedItems)
  }
  var currentIndex = mirror.children.startIndex
  for i in 0..<count {
    if maxItemCounter <= 0 {
      for _ in 0..<(indent+4) {
        target.write(" ")
      }
      let remainder = count - i
      target.write("(")
      _print_unlocked(remainder, &target)
      if i > 0 { target.write(" more") }
      if remainder == 1 {
        target.write(" child)\n")
      } else {
        target.write(" children)\n")
      }
      return
    }
    let (name, child) = mirror.children[currentIndex]
    mirror.children.formIndex(after: &currentIndex)
    _dump_unlocked(
      child,
      to: &target,
      name: name,
      indent: indent + 2,
      maxDepth: maxDepth - 1,
      maxItemCounter: &maxItemCounter,
      visitedItems: &visitedItems)
  }
}
#endif 
