extension Unicode {
  @frozen
  public enum ParseResult<T> {
  case valid(T)
  case emptyInput
  case error(length: Int)
    @inlinable
    internal var _valid: T? {
      if case .valid(let result) = self { return result }
      return nil
    }
    @inlinable
    internal var _error: Int? {
      if case .error(let result) = self { return result }
      return nil
    }
  }
}
public protocol _UnicodeParser {
  associatedtype Encoding: _UnicodeEncoding
  init()
  mutating func parseScalar<I: IteratorProtocol>(
    from input: inout I
  ) -> Unicode.ParseResult<Encoding.EncodedScalar>
  where I.Element == Encoding.CodeUnit
}
extension Unicode {
  public typealias Parser = _UnicodeParser
}
extension Unicode.ParseResult: Sendable where T: Sendable { }
