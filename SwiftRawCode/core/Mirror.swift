#if SWIFT_ENABLE_REFLECTION
public struct Mirror {
  public let subjectType: Any.Type
  public let children: Children
  public let displayStyle: DisplayStyle?
  internal let _makeSuperclassMirror: () -> Mirror?
  internal let _defaultDescendantRepresentation: _DefaultDescendantRepresentation
  public init(reflecting subject: Any) {
    if case let customized as CustomReflectable = subject {
      self = customized.customMirror
    } else {
      self = Mirror(internalReflecting: subject)
    }
  }
  public init<Subject, C: Collection>(
    _ subject: Subject,
    children: C,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) where C.Element == Child {
    self.subjectType = Subject.self
    self._makeSuperclassMirror = Mirror._superclassIterator(
      subject, ancestorRepresentation)
    self.children = Children(children)
    self.displayStyle = displayStyle
    self._defaultDescendantRepresentation
      = subject is CustomLeafReflectable ? .suppressed : .generated
  }
  public init<Subject, C: Collection>(
    _ subject: Subject,
    unlabeledChildren: C,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) {
    self.subjectType = Subject.self
    self._makeSuperclassMirror = Mirror._superclassIterator(
      subject, ancestorRepresentation)
    let lazyChildren =
      unlabeledChildren.lazy.map { Child(label: nil, value: $0) }
    self.children = Children(lazyChildren)
    self.displayStyle = displayStyle
    self._defaultDescendantRepresentation
      = subject is CustomLeafReflectable ? .suppressed : .generated
  }
  public init<Subject>(
    _ subject: Subject,
    children: KeyValuePairs<String, Any>,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) {
    self.subjectType = Subject.self
    self._makeSuperclassMirror = Mirror._superclassIterator(
      subject, ancestorRepresentation)
    let lazyChildren = children.lazy.map { Child(label: $0.0, value: $0.1) }
    self.children = Children(lazyChildren)
    self.displayStyle = displayStyle
    self._defaultDescendantRepresentation
      = subject is CustomLeafReflectable ? .suppressed : .generated
  }
  public var superclassMirror: Mirror? {
    return _makeSuperclassMirror()
  }
}
extension Mirror {
  internal enum _DefaultDescendantRepresentation {
    case generated
    case suppressed
  }
  public enum AncestorRepresentation {
    case generated
    case customized(() -> Mirror)
    case suppressed
  }
  public typealias Child = (label: String?, value: Any)
  public typealias Children = AnyCollection<Child>
  public enum DisplayStyle: Sendable {
    case `struct`, `class`, `enum`, tuple, optional, collection
    case dictionary, `set`
  }
  internal static func _noSuperclassMirror() -> Mirror? { return nil }
  @inline(never)
  internal static func _superclassIterator<Subject>(
    _ subject: Subject, _ ancestorRepresentation: AncestorRepresentation
  ) -> () -> Mirror? {
    if let subjectClass = Subject.self as? AnyClass,
       let superclass = _getSuperclass(subjectClass) {
      switch ancestorRepresentation {
      case .generated:
        return {
          Mirror(internalReflecting: subject, subjectType: superclass)
        }
      case .customized(let makeAncestor):
        return {
          let ancestor = makeAncestor()
          if superclass == ancestor.subjectType
            || ancestor._defaultDescendantRepresentation == .suppressed {
            return ancestor
          } else {
            return Mirror(internalReflecting: subject,
                          subjectType: superclass,
                          customAncestor: ancestor)
          }
        }
      case .suppressed:
        break
      }
    }
    return Mirror._noSuperclassMirror
  }
}
public protocol CustomReflectable {
  var customMirror: Mirror { get }
}
public protocol CustomLeafReflectable: CustomReflectable {}
public protocol MirrorPath {
}
extension Int: MirrorPath {}
extension String: MirrorPath {}
extension Mirror {
  internal struct _Dummy: CustomReflectable {
      internal init(mirror: Mirror) {
      self.mirror = mirror
    }
    internal var mirror: Mirror
    internal var customMirror: Mirror { return mirror }
  }
  public func descendant(
    _ first: MirrorPath, _ rest: MirrorPath...
  ) -> Any? {
    var result: Any = _Dummy(mirror: self)
    for e in [first] + rest {
      let children = Mirror(reflecting: result).children
      let position: Children.Index
      if case let label as String = e {
        position = children.firstIndex { $0.label == label } ?? children.endIndex
      }
      else if let offset = e as? Int {
        position = children.index(children.startIndex,
          offsetBy: offset,
          limitedBy: children.endIndex) ?? children.endIndex
      }
      else {
        _preconditionFailure(
          "Someone added a conformance to MirrorPath; that privilege is reserved to the standard library")
      }
      if position == children.endIndex { return nil }
      result = children[position].value
    }
    return result
  }
}
#else  
@available(*, unavailable)
public struct Mirror {
  public enum AncestorRepresentation {
    case generated
    case customized(() -> Mirror)
    case suppressed
  }
  public init(reflecting subject: Any) { Builtin.unreachable() }
  public typealias Child = (label: String?, value: Any)
  public typealias Children = AnyCollection<Child>
  public enum DisplayStyle: Sendable {
    case `struct`, `class`, `enum`, tuple, optional, collection
    case dictionary, `set`
  }
  public init<Subject, C: Collection>(
    _ subject: Subject,
    children: C,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) where C.Element == Child {
    Builtin.unreachable()
  }
  public init<Subject, C: Collection>(
    _ subject: Subject,
    unlabeledChildren: C,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) {
    Builtin.unreachable()
  }
  public init<Subject>(
    _ subject: Subject,
    children: KeyValuePairs<String, Any>,
    displayStyle: DisplayStyle? = nil,
    ancestorRepresentation: AncestorRepresentation = .generated
  ) {
    Builtin.unreachable()
  }
  public let subjectType: Any.Type
  public let children: Children
  public let displayStyle: DisplayStyle?
  public var superclassMirror: Mirror? { Builtin.unreachable() }
}
@available(*, unavailable)
public protocol CustomReflectable {
  var customMirror: Mirror { get }
}
@available(*, unavailable)
public protocol CustomLeafReflectable: CustomReflectable {}
@available(*, unavailable)
public protocol MirrorPath {}
@available(*, unavailable)
extension Int: MirrorPath {}
@available(*, unavailable)
extension String: MirrorPath {}
@available(*, unavailable)
extension Mirror {
  public func descendant(_ first: MirrorPath, _ rest: MirrorPath...) -> Any? {
    Builtin.unreachable()
  }
}
#endif  
extension String {
  public init<Subject>(describing instance: Subject) {
    self.init()
    _print_unlocked(instance, &self)
  }
  @inlinable
  public init<Subject: CustomStringConvertible>(describing instance: Subject) {
    self = instance.description
  }
  @inlinable
  public init<Subject: TextOutputStreamable>(describing instance: Subject) {
    self.init()
    instance.write(to: &self)
  }
  @inlinable
  public init<Subject>(describing instance: Subject)
    where Subject: CustomStringConvertible & TextOutputStreamable
  {
    self = instance.description
  }
  public init<Subject>(reflecting subject: Subject) {
    self.init()
    _debugPrint_unlocked(subject, &self)
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Mirror: CustomStringConvertible {
  public var description: String {
    return "Mirror for \(self.subjectType)"
  }
}
extension Mirror: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, children: [:])
  }
}
#endif  
