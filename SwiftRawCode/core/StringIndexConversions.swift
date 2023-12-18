extension String.Index {
  public init?(_ sourcePosition: String.Index, within target: String) {
    let i = target._guts.ensureMatchingEncoding(sourcePosition)
    guard target._isValidIndex(i) else { return nil }
    self = i._characterAligned
  }
  @available(SwiftStdlib 5.1, *)
  public init?<S: StringProtocol>(
    _ sourcePosition: String.Index, within target: S
  ) {
    if let str = target as? String {
      self.init(sourcePosition, within: str)
      return
    }
    if let str = target as? Substring {
      let i = str._wholeGuts.ensureMatchingEncoding(sourcePosition)
      guard str._isValidIndex(i) else { return nil }
      self = i
      return
    }
    self.init(sourcePosition, within: String(target))
  }
  public func samePosition(
    in utf8: String.UTF8View
  ) -> String.UTF8View.Index? {
    return String.UTF8View.Index(self, within: utf8)
  }
  public func samePosition(
    in utf16: String.UTF16View
  ) -> String.UTF16View.Index? {
    return String.UTF16View.Index(self, within: utf16)
  }
}
extension String {
  @available(SwiftStdlib 5.8, *)
  public 
  func _index(roundingDown i: Index) -> Index {
    _guts.validateInclusiveCharacterIndex(i)
  }
}
extension Substring {
  @available(SwiftStdlib 5.8, *)
  public 
  func _index(roundingDown i: Index) -> Index {
    _wholeGuts.validateInclusiveCharacterIndex(i, in: _bounds)
  }
}
extension String.UnicodeScalarView {
  public 
  func _index(roundingDown i: Index) -> Index {
    _guts.validateInclusiveScalarIndex(i)
  }
}
extension Substring.UnicodeScalarView {
  public 
  func _index(roundingDown i: Index) -> Index {
    _wholeGuts.validateInclusiveScalarIndex(i, in: _bounds)
  }
}
extension String.UTF8View {
  public 
  func _index(roundingDown i: Index) -> Index {
    let i = _guts.validateInclusiveSubscalarIndex(i)
    guard _guts.isForeign else { return i.strippingTranscoding._knownUTF8 }
    return _utf8AlignForeignIndex(i)
  }
}
extension Substring.UTF8View {
  public 
  func _index(roundingDown i: Index) -> Index {
    let i = _wholeGuts.validateInclusiveSubscalarIndex(i, in: _bounds)
    guard _wholeGuts.isForeign else { return i.strippingTranscoding._knownUTF8 }
    return _slice._base._utf8AlignForeignIndex(i)
  }
}
extension String.UTF16View {
  public 
  func _index(roundingDown i: Index) -> Index {
    let i = _guts.validateInclusiveSubscalarIndex(i)
    if _guts.isForeign { return i.strippingTranscoding._knownUTF16 }
    return _utf16AlignNativeIndex(i)
  }
}
extension Substring.UTF16View {
  public 
  func _index(roundingDown i: Index) -> Index {
    let i = _wholeGuts.validateInclusiveSubscalarIndex(i, in: _bounds)
    if _wholeGuts.isForeign { return i.strippingTranscoding._knownUTF16 }
    return _slice._base._utf16AlignNativeIndex(i)
  }
}
