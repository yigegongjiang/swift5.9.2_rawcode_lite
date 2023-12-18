#if SWIFT_ENABLE_REFLECTION
extension Float: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Float: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Float.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .float(self)
  }
}
extension Double: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Double: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Double.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .double(self)
  }
}
extension Bool: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Bool: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Bool.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .bool(self)
  }
}
extension String: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension String: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "String.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(self)
  }
}
extension Character: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Character: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Character.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(String(self))
  }
}
extension Unicode.Scalar: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Unicode.Scalar: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Unicode.Scalar.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension UInt8: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension UInt8: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "UInt8.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension Int8: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Int8: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Int8.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
extension UInt16: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension UInt16: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "UInt16.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension Int16: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Int16: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Int16.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
extension UInt32: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension UInt32: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "UInt32.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension Int32: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Int32: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Int32.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
extension UInt64: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension UInt64: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "UInt64.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension Int64: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Int64: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Int64.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
extension UInt: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension UInt: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "UInt.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .uInt(UInt64(self))
  }
}
extension Int: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
extension Int: _CustomPlaygroundQuickLookable {
  @available(*, deprecated, message: "Int.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .int(Int64(self))
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
extension Float80: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(self, unlabeledChildren: EmptyCollection<Void>())
  }
}
#endif
#endif
