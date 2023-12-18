struct Engine {
  let program: MEProgram
  var instructions: InstructionList<Instruction> { program.instructions }
  var enableTracing: Bool { program.enableTracing }
  var enableMetrics: Bool { program.enableMetrics }
  init(_ program: MEProgram) {
    self.program = program
  }
}
struct AsyncEngine {  }
extension Engine: CustomStringConvertible {
  var description: String {
    return program.description
  }
}
