import SwiftShims
#if SWIFT_STDLIB_HAS_STDIN
public func readLine(strippingNewline: Bool = true) -> String? {
  var utf8Start: UnsafeMutablePointer<UInt8>?
  let utf8Count = swift_stdlib_readLine_stdin(&utf8Start)
  defer {
    _swift_stdlib_free(utf8Start)
  }
  guard utf8Count > 0 else {
    return nil
  }
  let utf8Buffer = UnsafeBufferPointer(start: utf8Start, count: utf8Count)
  var result = String._fromUTF8Repairing(utf8Buffer).result
  if strippingNewline, result.last == "\n" || result.last == "\r\n" {
    _ = result.removeLast()
  }
  return result
}
#endif
