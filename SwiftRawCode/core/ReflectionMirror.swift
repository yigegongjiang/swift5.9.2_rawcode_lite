#if SWIFT_ENABLE_REFLECTION
import SwiftShims
internal func _isClassType(_ type: Any.Type) -> Bool {
  return swift_isClassType(unsafeBitCast(type, to: UnsafeRawPointer.self))
}
internal func _metadataKind(_: Any.Type) -> UInt
internal func _getNormalizedType<T>(_: T, type: Any.Type) -> Any.Type
internal func _getChildCount<T>(_: T, type: Any.Type) -> Int
internal func _getRecursiveChildCount(_: Any.Type) -> Int
internal func _getChildMetadata(
  _: Any.Type,
  index: Int,
  fieldMetadata: UnsafeMutablePointer<_FieldReflectionMetadata>
) -> Any.Type
internal func _getChildOffset(
  _: Any.Type,
  index: Int
) -> Int
internal typealias NameFreeFunc = @convention(c) (UnsafePointer<CChar>?) -> Void
internal func _getChild<T>(
  of: T,
  type: Any.Type,
  index: Int,
  outName: UnsafeMutablePointer<UnsafePointer<CChar>?>,
  outFreeFunc: UnsafeMutablePointer<NameFreeFunc?>
) -> Any
internal func _getDisplayStyle<T>(_: T) -> CChar
internal func getChild<T>(of value: T, type: Any.Type, index: Int) -> (label: String?, value: Any) {
  var nameC: UnsafePointer<CChar>? = nil
  var freeFunc: NameFreeFunc? = nil
  let value = _getChild(of: value, type: type, index: index, outName: &nameC, outFreeFunc: &freeFunc)
  let name = nameC.flatMap({ String(validatingUTF8: $0) })
  freeFunc?(nameC)
  return (name, value)
}
#if _runtime(_ObjC)
internal func _getQuickLookObject<T>(_: T) -> AnyObject?
internal func _isImpl(_ object: AnyObject, kindOf: UnsafePointer<CChar>) -> Bool
internal func _is(_ object: AnyObject, kindOf `class`: String) -> Bool {
  return `class`.withCString {
    return _isImpl(object, kindOf: $0)
  }
}
internal func _getClassPlaygroundQuickLook(
  _ object: AnyObject
) -> _PlaygroundQuickLook? {
  if _is(object, kindOf: "NSNumber") {
    let number: _NSNumber = unsafeBitCast(object, to: _NSNumber.self)
    switch UInt8(number.objCType[0]) {
    case UInt8(ascii: "d"):
      return .double(number.doubleValue)
    case UInt8(ascii: "f"):
      return .float(number.floatValue)
    case UInt8(ascii: "Q"):
      return .uInt(number.unsignedLongLongValue)
    default:
      return .int(number.longLongValue)
    }
  }
  if _is(object, kindOf: "NSAttributedString") {
    return .attributedString(object)
  }
  if _is(object, kindOf: "NSImage") ||
     _is(object, kindOf: "UIImage") ||
     _is(object, kindOf: "NSImageView") ||
     _is(object, kindOf: "UIImageView") ||
     _is(object, kindOf: "CIImage") ||
     _is(object, kindOf: "NSBitmapImageRep") {
    return .image(object)
  }
  if _is(object, kindOf: "NSColor") ||
     _is(object, kindOf: "UIColor") {
    return .color(object)
  }
  if _is(object, kindOf: "NSBezierPath") ||
     _is(object, kindOf: "UIBezierPath") {
    return .bezierPath(object)
  }
  if _is(object, kindOf: "NSString") {
    return .text(_forceBridgeFromObjectiveC(object, String.self))
  }
  return .none
}
#endif
extension Mirror {
  internal init(internalReflecting subject: Any,
              subjectType: Any.Type? = nil,
              customAncestor: Mirror? = nil)
  {
    let subjectType = subjectType ?? _getNormalizedType(subject, type: type(of: subject))
    let childCount = _getChildCount(subject, type: subjectType)
    let children = (0 ..< childCount).lazy.map({
      getChild(of: subject, type: subjectType, index: $0)
    })
    self.children = Children(children)
    self._makeSuperclassMirror = {
      guard let subjectClass = subjectType as? AnyClass,
            let superclass = _getSuperclass(subjectClass) else {
        return nil
      }
      if let customAncestor = customAncestor {
        if superclass == customAncestor.subjectType {
          return customAncestor
        }
        if customAncestor._defaultDescendantRepresentation == .suppressed {
          return customAncestor
        }
      }
      return Mirror(internalReflecting: subject,
                    subjectType: superclass,
                    customAncestor: customAncestor)
    }
    let rawDisplayStyle = _getDisplayStyle(subject)
    switch UnicodeScalar(Int(rawDisplayStyle)) {
    case "c": self.displayStyle = .class
    case "e": self.displayStyle = .enum
    case "s": self.displayStyle = .struct
    case "t": self.displayStyle = .tuple
    case "\0": self.displayStyle = nil
    default: preconditionFailure("Unknown raw display style '\(rawDisplayStyle)'")
    }
    self.subjectType = subjectType
    self._defaultDescendantRepresentation = .generated
  }
  internal static func quickLookObject(_ subject: Any) -> _PlaygroundQuickLook? {
#if _runtime(_ObjC)
    let object = _getQuickLookObject(subject)
    return object.flatMap(_getClassPlaygroundQuickLook)
#else
    return nil
#endif
  }
}
@available(SwiftStdlib 5.2, *)
public struct _EachFieldOptions: OptionSet {
  public var rawValue: UInt32
  public init(rawValue: UInt32) {
    self.rawValue = rawValue
  }
  public static var classType = _EachFieldOptions(rawValue: 1 << 0)
  public static var ignoreUnknown = _EachFieldOptions(rawValue: 1 << 1)
}
@available(SwiftStdlib 5.2, *)
public enum _MetadataKind: UInt {
  case `class` = 0
  case `struct` = 0x200     
  case `enum` = 0x201       
  case optional = 0x202     
  case foreignClass = 0x203 
  case opaque = 0x300       
  case tuple = 0x301        
  case function = 0x302     
  case existential = 0x303  
  case metatype = 0x304     
  case objcClassWrapper = 0x305     
  case existentialMetatype = 0x306  
  case heapLocalVariable = 0x400    
  case heapGenericLocalVariable = 0x500 
  case errorObject = 0x501  
  case unknown = 0xffff
  init(_ type: Any.Type) {
    let v = _metadataKind(type)
    if let result = _MetadataKind(rawValue: v) {
      self = result
    } else {
      self = .unknown
    }
  }
}
@available(SwiftStdlib 5.2, *)
@discardableResult
public func _forEachField(
  of type: Any.Type,
  options: _EachFieldOptions = [],
  body: (UnsafePointer<CChar>, Int, Any.Type, _MetadataKind) -> Bool
) -> Bool {
  if _isClassType(type) != options.contains(.classType) {
    return false
  }
  let childCount = _getRecursiveChildCount(type)
  for i in 0..<childCount {
    let offset = _getChildOffset(type, index: i)
    var field = _FieldReflectionMetadata()
    let childType = _getChildMetadata(type, index: i, fieldMetadata: &field)
    defer { field.freeFunc?(field.name) }
    let kind = _MetadataKind(childType)
    if !body(field.name!, offset, childType, kind) {
      return false
    }
  }
  return true
}
@available(SwiftStdlib 5.4, *)
@discardableResult
public func _forEachFieldWithKeyPath<Root>(
  of type: Root.Type,
  options: _EachFieldOptions = [],
  body: (UnsafePointer<CChar>, PartialKeyPath<Root>) -> Bool
) -> Bool {
  if _isClassType(type) || options.contains(.classType) {
    return false
  }
  let ignoreUnknown = options.contains(.ignoreUnknown)
  let childCount = _getRecursiveChildCount(type)
  for i in 0..<childCount {
    let offset = _getChildOffset(type, index: i)
    var field = _FieldReflectionMetadata()
    let childType = _getChildMetadata(type, index: i, fieldMetadata: &field)
    defer { field.freeFunc?(field.name) }
    let kind = _MetadataKind(childType)
    let supportedType: Bool
    switch kind {
      case .struct, .class, .optional, .existential,
          .existentialMetatype, .tuple, .enum:
        supportedType = true
      default:
        supportedType = false
    }
    if !supportedType || !field.isStrong {
      if !ignoreUnknown { return false }
      continue;
    }
    func keyPathType<Leaf>(for: Leaf.Type) -> PartialKeyPath<Root>.Type {
      if field.isVar { return WritableKeyPath<Root, Leaf>.self }
      return KeyPath<Root, Leaf>.self
    }
    let resultSize = MemoryLayout<Int32>.size + MemoryLayout<Int>.size
    let partialKeyPath = _openExistential(childType, do: keyPathType)
       ._create(capacityInBytes: resultSize) {
      var destBuilder = KeyPathBuffer.Builder($0)
      destBuilder.pushHeader(KeyPathBuffer.Header(
        size: resultSize - MemoryLayout<Int>.size,
        trivial: true,
        hasReferencePrefix: false
      ))
      let component = RawKeyPathComponent(
           header: RawKeyPathComponent.Header(stored: .struct,
                                              mutable: field.isVar,
                                              inlineOffset: UInt32(offset)),
           body: UnsafeRawBufferPointer(start: nil, count: 0))
      component.clone(
        into: &destBuilder.buffer,
        endOfReferencePrefix: false)
    }
    if !body(field.name!, partialKeyPath) {
      return false
    }
  }
  return true
}
#endif
