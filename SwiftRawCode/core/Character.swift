@frozen
public struct Character: Sendable {
  @usableFromInline
  internal var _str: String
  @inlinable @inline(__always)
  internal init(unchecked str: String) {
    self._str = str
    _invariantCheck()
  }
}
extension Character {
  #if !INTERNAL_CHECKS_ENABLED
  @inlinable @inline(__always) internal func _invariantCheck() {}
  #else
  internal func _invariantCheck() {
    _internalInvariant(_str.count == 1)
    _internalInvariant(_str._guts.isFastUTF8)
    _internalInvariant(_str._guts._object.isPreferredRepresentation)
  }
  #endif 
}
extension Character {
  public typealias UTF8View = String.UTF8View
  @inlinable
  public var utf8: UTF8View { return _str.utf8 }
  public typealias UTF16View = String.UTF16View
  @inlinable
  public var utf16: UTF16View { return _str.utf16 }
  public typealias UnicodeScalarView = String.UnicodeScalarView
  @inlinable
  public var unicodeScalars: UnicodeScalarView { return _str.unicodeScalars }
}
extension Character :
  _ExpressibleByBuiltinExtendedGraphemeClusterLiteral,
  ExpressibleByExtendedGraphemeClusterLiteral
{
  @inlinable @inline(__always)
  public init(_ content: Unicode.Scalar) {
    self.init(unchecked: String(content))
  }
  @inlinable @inline(__always)
  public init(_builtinUnicodeScalarLiteral value: Builtin.Int32) {
    self.init(Unicode.Scalar(_builtinUnicodeScalarLiteral: value))
  }
  @inlinable @inline(__always)
  public init(
    _builtinExtendedGraphemeClusterLiteral start: Builtin.RawPointer,
    utf8CodeUnitCount: Builtin.Word,
    isASCII: Builtin.Int1
  ) {
    self.init(unchecked: String(
      _builtinExtendedGraphemeClusterLiteral: start,
      utf8CodeUnitCount: utf8CodeUnitCount,
      isASCII: isASCII))
  }
  @inlinable @inline(__always)
  public init(extendedGraphemeClusterLiteral value: Character) {
    self.init(unchecked: value._str)
  }
  @inlinable @inline(__always)
  public init(_ s: String) {
    _precondition(!s.isEmpty,
      "Can't form a Character from an empty String")
    _debugPrecondition(s.index(after: s.startIndex) == s.endIndex,
      "Can't form a Character from a String containing more than one extended grapheme cluster")
    if _fastPath(s._guts._object.isPreferredRepresentation) {
      self.init(unchecked: s)
      return
    }
    self.init(unchecked: String._copying(s))
  }
}
extension Character: CustomStringConvertible {
 @inlinable
 public var description: String {
   return _str
 }
}
extension Character: LosslessStringConvertible { }
extension Character: CustomDebugStringConvertible {
 public var debugDescription: String {
   return _str.debugDescription
 }
}
extension String {
  @inlinable @inline(__always)
  public init(_ c: Character) {
    self.init(c._str._guts)
  }
}
extension Character: Equatable {
  @inlinable @inline(__always)
  public static func == (lhs: Character, rhs: Character) -> Bool {
    return lhs._str == rhs._str
  }
}
extension Character: Comparable {
  @inlinable @inline(__always)
  public static func < (lhs: Character, rhs: Character) -> Bool {
    return lhs._str < rhs._str
  }
}
extension Character: Hashable {
  public func hash(into hasher: inout Hasher) {
    _str.hash(into: &hasher)
  }
}
extension Character {
  @usableFromInline 
  internal var _isSmall: Bool {
    return _str._guts.isSmall
  }
}
