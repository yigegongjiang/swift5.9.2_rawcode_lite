protocol InstructionProtocol {
  var operandPC: InstructionAddress? { get }
}
protocol ProcessorProtocol {
  associatedtype Input: Collection
  associatedtype Instruction: InstructionProtocol
  associatedtype SavePoint = ()
  associatedtype Registers = ()
  var cycleCount: Int { get }
  var input: Input { get }
  var currentPosition: Input.Index { get }
  var currentPC: InstructionAddress { get }
  var instructions: InstructionList<Instruction> { get }
  var isAcceptState: Bool { get }
  var isFailState: Bool { get }
  var callStack: Array<InstructionAddress> { get }
  var savePoints: Array<SavePoint> { get }
  var registers: Registers { get }
}
