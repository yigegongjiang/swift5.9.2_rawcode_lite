import SwiftShims
public protocol TextOutputStream {
  mutating func _lock()
  mutating func _unlock()
  mutating func write(_ string: String)
  mutating func _writeASCII(_ buffer: UnsafeBufferPointer<UInt8>)
}
extension TextOutputStream {
  public mutating func _lock() {}
  public mutating func _unlock() {}
  public mutating func _writeASCII(_ buffer: UnsafeBufferPointer<UInt8>) {
    write(String._fromASCII(buffer))
  }
}
public protocol TextOutputStreamable {
  func write<Target: TextOutputStream>(to target: inout Target)
}
public protocol CustomStringConvertible {
  var description: String { get }
}
public protocol LosslessStringConvertible: CustomStringConvertible {
  init?(_ description: String)
}
public protocol CustomDebugStringConvertible {
  var debugDescription: String { get }
}
internal func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?
internal func _opaqueSummary(_ metadata: Any.Type) -> UnsafePointer<CChar>?
internal func _fallbackEnumRawValue<T>(_ value: T) -> Int64? {
  switch MemoryLayout.size(ofValue: value) {
  case 8:
    return unsafeBitCast(value, to:Int64.self)
  case 4:
    return Int64(unsafeBitCast(value, to:Int32.self))
  case 2:
    return Int64(unsafeBitCast(value, to:Int16.self))
  case 1:
    return Int64(unsafeBitCast(value, to:Int8.self))
  default:
    return nil
  }
}
#if SWIFT_ENABLE_REFLECTION
internal func _adHocPrint_unlocked<T, TargetStream: TextOutputStream>(
    _ value: T, _ mirror: Mirror, _ target: inout TargetStream,
    isDebugPrint: Bool
) {
  func printTypeName(_ type: Any.Type) {
    target.write(_typeName(type, qualified: isDebugPrint))
  }
  if let displayStyle = mirror.displayStyle {
    switch displayStyle {
      case .optional:
        if let child = mirror.children.first {
          _debugPrint_unlocked(child.1, &target)
        } else {
          _debugPrint_unlocked("nil", &target)
        }
      case .tuple:
        target.write("(")
        var first = true
        for (label, value) in mirror.children {
          if first {
            first = false
          } else {
            target.write(", ")
          }
          if let label = label {
            if !label.isEmpty && label[label.startIndex] != "." {
              target.write(label)
              target.write(": ")
            }
          }
          _debugPrint_unlocked(value, &target)
        }
        target.write(")")
      case .struct:
        printTypeName(mirror.subjectType)
        target.write("(")
        var first = true
        for (label, value) in mirror.children {
          if let label = label {
            if first {
              first = false
            } else {
              target.write(", ")
            }
            target.write(label)
            target.write(": ")
            _debugPrint_unlocked(value, &target)
          }
        }
        target.write(")")
      case .enum:
        if let cString = _getEnumCaseName(value),
            let caseName = String(validatingUTF8: cString) {
          if isDebugPrint {
            printTypeName(mirror.subjectType)
            target.write(".")
          }
          target.write(caseName)
        } else {
          printTypeName(mirror.subjectType)
          if let rawValue = _fallbackEnumRawValue(value) {
            target.write("(rawValue: ")
            _debugPrint_unlocked(rawValue, &target);
            target.write(")")
          }
        }
        if let (_, value) = mirror.children.first {
          if Mirror(reflecting: value).displayStyle == .tuple {
            _debugPrint_unlocked(value, &target)
          } else {
            target.write("(")
            _debugPrint_unlocked(value, &target)
            target.write(")")
          }
        }
      default:
        target.write(_typeName(mirror.subjectType))
    }
  } else if let metatypeValue = value as? Any.Type {
    printTypeName(metatypeValue)
  } else {
    if let cString = _opaqueSummary(mirror.subjectType),
        let opaqueSummary = String(validatingUTF8: cString) {
      target.write(opaqueSummary)
    } else {
      target.write(_typeName(mirror.subjectType, qualified: true))
    }
  }
}
#endif
@usableFromInline
internal func _print_unlocked<T, TargetStream: TextOutputStream>(
  _ value: T, _ target: inout TargetStream
) {
  if _openExistential(type(of: value as Any), do: _isOptional) {
    let debugPrintable = value as! CustomDebugStringConvertible
    debugPrintable.debugDescription.write(to: &target)
    return
  }
  if let string = value as? String {
    target.write(string)
    return
  }
  if case let streamableObject as TextOutputStreamable = value {
    streamableObject.write(to: &target)
    return
  }
  if case let printableObject as CustomStringConvertible = value {
    printableObject.description.write(to: &target)
    return
  }
  if case let debugPrintableObject as CustomDebugStringConvertible = value {
    debugPrintableObject.debugDescription.write(to: &target)
    return
  }
#if SWIFT_ENABLE_REFLECTION
  let mirror = Mirror(reflecting: value)
  _adHocPrint_unlocked(value, mirror, &target, isDebugPrint: false)
#else
  target.write("(value cannot be printed without reflection)")
#endif
}
@inline(never)
public func _debugPrint_unlocked<T, TargetStream: TextOutputStream>(
    _ value: T, _ target: inout TargetStream
) {
  if let debugPrintableObject = value as? CustomDebugStringConvertible {
    debugPrintableObject.debugDescription.write(to: &target)
    return
  }
  if let printableObject = value as? CustomStringConvertible {
    printableObject.description.write(to: &target)
    return
  }
  if let streamableObject = value as? TextOutputStreamable {
    streamableObject.write(to: &target)
    return
  }
#if SWIFT_ENABLE_REFLECTION
  let mirror = Mirror(reflecting: value)
  _adHocPrint_unlocked(value, mirror, &target, isDebugPrint: true)
#else
  target.write("(value cannot be printed without reflection)")
#endif
}
#if SWIFT_ENABLE_REFLECTION
internal func _dumpPrint_unlocked<T, TargetStream: TextOutputStream>(
    _ value: T, _ mirror: Mirror, _ target: inout TargetStream
) {
  if let displayStyle = mirror.displayStyle {
    switch displayStyle {
    case .tuple:
      let count = mirror.children.count
      target.write(count == 1 ? "(1 element)" : "(\(count) elements)")
      return
    case .collection:
      let count = mirror.children.count
      target.write(count == 1 ? "1 element" : "\(count) elements")
      return
    case .dictionary:
      let count = mirror.children.count
      target.write(count == 1 ? "1 key/value pair" : "\(count) key/value pairs")
      return
    case .`set`:
      let count = mirror.children.count
      target.write(count == 1 ? "1 member" : "\(count) members")
      return
    default:
      break
    }
  }
  if let debugPrintableObject = value as? CustomDebugStringConvertible {
    debugPrintableObject.debugDescription.write(to: &target)
    return
  }
  if let printableObject = value as? CustomStringConvertible {
    printableObject.description.write(to: &target)
    return
  }
  if let streamableObject = value as? TextOutputStreamable {
    streamableObject.write(to: &target)
    return
  }
  if let displayStyle = mirror.displayStyle {
    switch displayStyle {
    case .`class`, .`struct`:
      target.write(_typeName(mirror.subjectType, qualified: true))
      return
    case .`enum`:
      target.write(_typeName(mirror.subjectType, qualified: true))
      if let cString = _getEnumCaseName(value),
          let caseName = String(validatingUTF8: cString) {
        target.write(".")
        target.write(caseName)
      }
      return
    default:
      break
    }
  }
  _adHocPrint_unlocked(value, mirror, &target, isDebugPrint: true)
}
#endif
internal struct _Stdout: TextOutputStream {
  internal init() {}
  internal mutating func _lock() {
    _swift_stdlib_flockfile_stdout()
  }
  internal mutating func _unlock() {
    _swift_stdlib_funlockfile_stdout()
  }
  internal mutating func write(_ string: String) {
    if string.isEmpty { return }
    var string = string
    _ = string.withUTF8 { utf8 in
      _swift_stdlib_fwrite_stdout(utf8.baseAddress!, 1, utf8.count)
    }
  }
}
extension String: TextOutputStream {
  public mutating func write(_ other: String) {
    self += other
  }
  public mutating func _writeASCII(_ buffer: UnsafeBufferPointer<UInt8>) {
    self._guts.append(_StringGuts(buffer, isASCII: true))
  }
}
extension String: TextOutputStreamable {
  @inlinable
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write(self)
  }
}
extension Character: TextOutputStreamable {
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write(String(self))
  }
}
extension Unicode.Scalar: TextOutputStreamable {
  public func write<Target: TextOutputStream>(to target: inout Target) {
    target.write(String(Character(self)))
  }
}
public var _playgroundPrintHook: ((String) -> Void)? = nil
internal struct _TeeStream<L: TextOutputStream, R: TextOutputStream>
  : TextOutputStream
{
  internal var left: L
  internal var right: R
  internal init(left: L, right: R) {
    self.left = left
    self.right = right
  }
  internal mutating func write(_ string: String) {
    left.write(string); right.write(string)
  }
  internal mutating func _lock() { left._lock(); right._lock() }
  internal mutating func _unlock() { right._unlock(); left._unlock() }
}
