public protocol _UTFParser {
  associatedtype Encoding: _UnicodeEncoding
  func _parseMultipleCodeUnits() -> (isValid: Bool, bitCount: UInt8)
  func _bufferedScalar(bitCount: UInt8) -> Encoding.EncodedScalar
  var _buffer: _UIntBuffer<Encoding.CodeUnit> { get set }
}
extension _UTFParser
where Encoding.EncodedScalar: RangeReplaceableCollection {
  @inlinable
  @inline(__always)
  public mutating func parseScalar<I: IteratorProtocol>(
    from input: inout I
  ) -> Unicode.ParseResult<Encoding.EncodedScalar>
    where I.Element == Encoding.CodeUnit {
    if _fastPath(_buffer.isEmpty) {
      guard let codeUnit = input.next() else { return .emptyInput }
      if Encoding._isScalar(codeUnit) {
        return .valid(Encoding.EncodedScalar(CollectionOfOne(codeUnit)))
      }
      _buffer.append(codeUnit)
    } else if Encoding._isScalar(
      Encoding.CodeUnit(truncatingIfNeeded: _buffer._storage)
    ) {
      let codeUnit = Encoding.CodeUnit(truncatingIfNeeded: _buffer._storage)
      _buffer.remove(at: _buffer.startIndex)
      return .valid(Encoding.EncodedScalar(CollectionOfOne(codeUnit)))
    }
    repeat {
      if let codeUnit = input.next() {
        _buffer.append(codeUnit)
      } else {
        if _buffer.isEmpty { return .emptyInput }
        break 
      }
    } while _buffer.count < _buffer.capacity
    let (isValid, scalarBitCount) = _parseMultipleCodeUnits()
    _internalInvariant(scalarBitCount % numericCast(Encoding.CodeUnit.bitWidth) == 0)
    _internalInvariant(1...4 ~= scalarBitCount / 8)
    _internalInvariant(scalarBitCount <= _buffer._bitCount)
    let encodedScalar = _bufferedScalar(bitCount: scalarBitCount)
    _buffer._storage = UInt32(
      truncatingIfNeeded: UInt64(_buffer._storage) &>> scalarBitCount)
    _buffer._bitCount = _buffer._bitCount &- scalarBitCount
    if _fastPath(isValid) {
      return .valid(encodedScalar)
    }
    return .error(
      length: Int(scalarBitCount / numericCast(Encoding.CodeUnit.bitWidth)))
  }
}
