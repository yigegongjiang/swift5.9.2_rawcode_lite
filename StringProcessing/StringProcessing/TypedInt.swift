struct TypedInt<👻>: RawRepresentable, Hashable {
  var rawValue: Int
  init(rawValue: Int) {
    self.rawValue = rawValue
  }
  init(_ rawValue: Int) {
    self.init(rawValue: rawValue)
  }
  init(_ uint: UInt64) {
    assert(uint.leadingZeroBitCount > 0)
    self.init(Int(asserting: uint))
  }
}
extension TypedInt: Comparable {
  static func <(lhs: TypedInt, rhs: TypedInt) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}
extension TypedInt: CustomStringConvertible {
  var description: String { return "#\(rawValue)" }
}
extension TypedInt: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    self.init(rawValue: value)
  }
}
protocol TypedIntProtocol {
  associatedtype 👻
}
extension TypedInt: TypedIntProtocol { }
enum _Boo {}
typealias TypedInt_ = TypedInt
extension TypedInt {
  static func +(lhs: TypedInt, rhs: Int) -> TypedInt {
    return TypedInt(lhs.rawValue + rhs)
  }
  var bits: UInt64 {
    UInt64(asserting: self.rawValue)
  }
}
struct TypedSetVector<Element: Hashable, 👻> {
  typealias Idx = TypedInt<👻>
  var lookup: Dictionary<Element, Idx> = [:]
  var stored: Array<Element> = []
  func load(_ idx: Idx) -> Element { stored[idx.rawValue] }
  @discardableResult
  mutating func store(_ e: Element) -> Idx {
    if let reg = lookup[e] { return reg }
    let reg = Idx(stored.count)
    stored.append(e)
    lookup[e] = reg
    return reg
  }
  var count: Int { stored.count }
  init() {}
}
typealias Distance = TypedInt<_Distance>
enum _Distance {}
typealias InstructionAddress = TypedInt<_InstructionAddress>
enum _InstructionAddress {}
typealias CallStackAddress = TypedInt<_CallStackAddress>
enum _CallStackAddress {}
typealias PositionStackAddress = TypedInt<_PositionStackAddress>
enum _PositionStackAddress {}
typealias SavePointStackAddress = TypedInt<_SavePointAddress>
enum _SavePointAddress {}
typealias ElementRegister = TypedInt<_ElementRegister>
enum _ElementRegister {}
typealias SequenceRegister = TypedInt<_SequenceRegister>
enum _SequenceRegister {}
typealias BoolRegister = TypedInt<_BoolRegister>
enum _BoolRegister {}
typealias StringRegister = TypedInt<_StringRegister>
enum _StringRegister {}
typealias AsciiBitsetRegister = TypedInt<_AsciiBitsetRegister>
enum _AsciiBitsetRegister {}
typealias ConsumeFunctionRegister = TypedInt<_ConsumeFunctionRegister>
enum _ConsumeFunctionRegister {}
typealias TransformRegister = TypedInt<_TransformRegister>
enum _TransformRegister {}
typealias MatcherRegister = TypedInt<_MatcherRegister>
enum _MatcherRegister {}
typealias IntRegister = TypedInt<_IntRegister>
enum _IntRegister {}
typealias FloatRegister = TypedInt<_FloatRegister>
enum _FloatRegister {}
typealias PositionRegister = TypedInt<_PositionRegister>
enum _PositionRegister {}
typealias ValueRegister = TypedInt<_ValueRegister>
enum _ValueRegister {}
typealias CaptureRegister = TypedInt<_CaptureRegister>
enum _CaptureRegister {}
typealias InstructionAddressRegister = TypedInt<_InstructionAddressRegister>
enum _InstructionAddressRegister {}
typealias CallStackAddressRegister = TypedInt<_CallStackAddressRegister>
enum _CallStackAddressRegister {}
typealias PositionStackAddressRegister = TypedInt<_PositionStackAddressRegister>
enum _PositionStackAddressRegister {}
typealias SavePointAddressRegister = TypedInt<_SavePointAddressRegister>
enum _SavePointAddressRegister {}
typealias LabelId = TypedInt<_LabelId>
enum _LabelId {}
typealias FunctionId = TypedInt<_FunctionId>
enum _FunctionId {}
typealias CaptureId = TypedInt<_CaptureId>
enum _CaptureId {}
