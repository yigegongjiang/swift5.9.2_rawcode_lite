/*
 Pull in shims and other things so our code is closer to the
 stdlib's and vice versa. Long term, we'll want to address
 each of these
*/
func _internalInvariant(
  _ b: @autoclosure () -> Bool, _ s: String = ""
) {
  assert(b(), s)
}
extension Optional {
  internal var _unsafelyUnwrappedUnchecked: Wrapped {
    self.unsafelyUnwrapped
  }
  internal mutating func _take() -> Wrapped? {
    switch self {
    case .some(let thing):
      self = nil
      return thing
    case .none:
      return nil
    }
  }
}
struct UnsafeByteBuffer {
  var pointer: UnsafeRawPointer
  var count: Int
  func boundsCheck(_ idx: Int) -> Bool {
    idx < count
  }
  subscript(_unchecked idx: Int) -> UInt8 {
    assert(boundsCheck(idx))
    return pointer.load(fromByteOffset: idx, as: UInt8.self)
  }
  subscript(idx: Int) -> UInt8 {
    precondition(boundsCheck(idx))
    return self[_unchecked: idx]
  }
}
extension UnsafeBufferPointer where Element == UInt8 {
  var byteBuffer: UnsafeByteBuffer {
    UnsafeByteBuffer(pointer: baseAddress.unsafelyUnwrapped, count: count)
  }
}
extension Unicode.Scalar {
  init(_unchecked v: UInt32) {
    self.init(v)!
  }
  init(_value v: UInt32) {
    self = unsafeBitCast(v, to: Self.self)
  }
}
extension UTF16 {
  internal static func _decodeSurrogates(
    _ lead: CodeUnit,
    _ trail: CodeUnit
  ) -> Unicode.Scalar {
    _internalInvariant(isLeadSurrogate(lead))
    _internalInvariant(isTrailSurrogate(trail))
    return Unicode.Scalar(
      _unchecked: 0x10000 +
      (UInt32(lead & 0x03ff) &<< 10 | UInt32(trail & 0x03ff)))
  }
}
