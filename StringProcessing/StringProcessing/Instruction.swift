struct Instruction: RawRepresentable, Hashable {
  var rawValue: UInt64
  init(rawValue: UInt64){
    self.rawValue = rawValue
  }
}
extension Instruction {
  enum OpCode: UInt64 {
    case invalid = 0
    case moveImmediate
    case moveCurrentPosition
    case branch
    case condBranchZeroElseDecrement
    case condBranchSamePosition
    case advance
    case match
    case matchScalar
    case matchBitset
    case matchBuiltin
    case matchAnyNonNewline
    case consumeBy
    case assertBy
    case matchBy
    case save
    case saveAddress
    case clear
    case clearThrough
    case splitSaving
    case quantify
    case beginCapture
    case endCapture
    case transformCapture
    case captureValue
    case backreference
    case accept
    case fail
  }
}
internal var _opcodeMask: UInt64 { 0xFF00_0000_0000_0000 }
var _payloadMask: UInt64 { ~_opcodeMask }
extension Instruction {
  var opcodeMask: UInt64 { 0xFF00_0000_0000_0000 }
  var opcode: OpCode {
    get {
      OpCode(
        rawValue: (rawValue & _opcodeMask) &>> 56
      ).unsafelyUnwrapped
    }
    set {
      assert(newValue != .invalid, "consider hoisting this")
      assert(newValue.rawValue < 256)
      self.rawValue &= ~_opcodeMask
      self.rawValue |= newValue.rawValue &<< 56
    }
  }
  var payload: Payload {
    get { Payload(rawValue: rawValue & ~opcodeMask) }
    set {
      self.rawValue &= opcodeMask
      self.rawValue |= newValue.rawValue
    }
  }
  var destructure: (opcode: OpCode, payload: Payload) {
    get { (opcode, payload) }
    set { self = Self(opcode, payload) }
  }
  init(_ opcode: OpCode, _ payload: Payload) {
    self.init(rawValue: 0)
    self.opcode = opcode
    self.payload = payload
  }
  init(_ opcode: OpCode) {
    self.init(rawValue: 0)
    self.opcode = opcode
  }
}
/*
 This is in need of more refactoring and design, the following
 are a rough listing of TODOs:
 - Save point and call stack interactions should be more formalized.
 - It's too easy to have unbalanced save/clears amongst function calls
 - Nominal type for conditions with an invert bit
 - Better bit allocation and layout for operand, instruction, etc
 - Use spare bits for better assertions
 - Check low-level compiler code gen for switches
 - Consider relative addresses instead of absolute addresses
 - Explore a predication bit
 - Explore using SIMD
 - Explore a larger opcode, so that we can have variant flags
   - E.g., opcode-local bits instead of flattening opcode space
 We'd like to eventually design:
 - A general-purpose core (future extensibility)
 - A matching-specific instruction area carved out
 - Leave a large area for future usage of run-time bytecode interpretation
 - Debate: allow for future variable-width instructions
 We'd like a testing / performance setup that lets us
 - Define new instructions in terms of old ones (testing, perf)
 - Version our instruction set in case we need future fixes
 */
extension Instruction {
  var instructionAddress: InstructionAddress? {
    switch opcode {
    case .branch, .save, .saveAddress:
      return payload.addr
    default: return nil
    }
  }
  var elementRegister: ElementRegister? {
    switch opcode {
    case .match:
      return payload.elementPayload.1
    default: return nil
    }
  }
  var consumeFunctionRegister: ConsumeFunctionRegister? {
    switch opcode {
    case .consumeBy: return payload.consumer
    default: return nil
    }
  }
}
extension Instruction: InstructionProtocol {
  var operandPC: InstructionAddress? { instructionAddress }
}
enum State {
  case inProgress
  case fail
  case accept
}
