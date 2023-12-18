@frozen
public enum Never {}
extension Never: Sendable { }
extension Never: Error {}
extension Never: Equatable, Comparable, Hashable {}
@available(SwiftStdlib 5.5, *)
extension Never: Identifiable {
  @available(SwiftStdlib 5.5, *)
  public var id: Never {
    switch self {}
  }
}
@available(SwiftStdlib 5.9, *)
extension Never: Encodable {
  @available(SwiftStdlib 5.9, *)
  public func encode(to encoder: any Encoder) throws {}
}
@available(SwiftStdlib 5.9, *)
extension Never: Decodable {
  @available(SwiftStdlib 5.9, *)
  public init(from decoder: any Decoder) throws {
    let context = DecodingError.Context(
      codingPath: decoder.codingPath,
      debugDescription: "Unable to decode an instance of Never.")
    throw DecodingError.typeMismatch(Never.self, context)
  }
}
public typealias Void = ()
public typealias Float32 = Float
public typealias Float64 = Double
public typealias IntegerLiteralType = Int
public typealias FloatLiteralType = Double
public typealias BooleanLiteralType = Bool
public typealias UnicodeScalarType = String
public typealias ExtendedGraphemeClusterType = String
public typealias StringLiteralType = String
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
public typealias _MaxBuiltinFloatType = Builtin.FPIEEE80
#else
public typealias _MaxBuiltinFloatType = Builtin.FPIEEE64
#endif
#if _runtime(_ObjC)
public typealias AnyObject = Builtin.AnyObject
#else
public typealias AnyObject = Builtin.AnyObject
#endif
public typealias AnyClass = AnyObject.Type
public func ~= <T: Equatable>(a: T, b: T) -> Bool {
  return a == b
}
precedencegroup AssignmentPrecedence {
  assignment: true
  associativity: right
}
precedencegroup FunctionArrowPrecedence {
  associativity: right
  higherThan: AssignmentPrecedence
}
precedencegroup TernaryPrecedence {
  associativity: right
  higherThan: FunctionArrowPrecedence
}
precedencegroup DefaultPrecedence {
  higherThan: TernaryPrecedence
}
precedencegroup LogicalDisjunctionPrecedence {
  associativity: left
  higherThan: TernaryPrecedence
}
precedencegroup LogicalConjunctionPrecedence {
  associativity: left
  higherThan: LogicalDisjunctionPrecedence
}
precedencegroup ComparisonPrecedence {
  higherThan: LogicalConjunctionPrecedence
}
precedencegroup NilCoalescingPrecedence {
  associativity: right
  higherThan: ComparisonPrecedence
}
precedencegroup CastingPrecedence {
  higherThan: NilCoalescingPrecedence
}
precedencegroup RangeFormationPrecedence {
  higherThan: CastingPrecedence
}
precedencegroup AdditionPrecedence {
  associativity: left
  higherThan: RangeFormationPrecedence
}
precedencegroup MultiplicationPrecedence {
  associativity: left
  higherThan: AdditionPrecedence
}
precedencegroup BitwiseShiftPrecedence {
  higherThan: MultiplicationPrecedence
}
postfix operator ++
postfix operator --
postfix operator ...
prefix operator ++
prefix operator --
prefix operator !
prefix operator ~
prefix operator +
prefix operator -
prefix operator ...
prefix operator ..<
infix operator  <<: BitwiseShiftPrecedence
infix operator &<<: BitwiseShiftPrecedence
infix operator  >>: BitwiseShiftPrecedence
infix operator &>>: BitwiseShiftPrecedence
infix operator   *: MultiplicationPrecedence
infix operator  &*: MultiplicationPrecedence
infix operator   /: MultiplicationPrecedence
infix operator   %: MultiplicationPrecedence
infix operator   &: MultiplicationPrecedence
infix operator   +: AdditionPrecedence
infix operator  &+: AdditionPrecedence
infix operator   -: AdditionPrecedence
infix operator  &-: AdditionPrecedence
infix operator   |: AdditionPrecedence
infix operator   ^: AdditionPrecedence
infix operator  ...: RangeFormationPrecedence
infix operator  ..<: RangeFormationPrecedence
infix operator ??: NilCoalescingPrecedence
infix operator  <: ComparisonPrecedence
infix operator  <=: ComparisonPrecedence
infix operator  >: ComparisonPrecedence
infix operator  >=: ComparisonPrecedence
infix operator  ==: ComparisonPrecedence
infix operator  !=: ComparisonPrecedence
infix operator ===: ComparisonPrecedence
infix operator !==: ComparisonPrecedence
infix operator  ~=: ComparisonPrecedence
infix operator &&: LogicalConjunctionPrecedence
infix operator ||: LogicalDisjunctionPrecedence
infix operator   *=: AssignmentPrecedence
infix operator  &*=: AssignmentPrecedence
infix operator   /=: AssignmentPrecedence
infix operator   %=: AssignmentPrecedence
infix operator   +=: AssignmentPrecedence
infix operator  &+=: AssignmentPrecedence
infix operator   -=: AssignmentPrecedence
infix operator  &-=: AssignmentPrecedence
infix operator  <<=: AssignmentPrecedence
infix operator &<<=: AssignmentPrecedence
infix operator  >>=: AssignmentPrecedence
infix operator &>>=: AssignmentPrecedence
infix operator   &=: AssignmentPrecedence
infix operator   ^=: AssignmentPrecedence
infix operator   |=: AssignmentPrecedence
infix operator ~>
