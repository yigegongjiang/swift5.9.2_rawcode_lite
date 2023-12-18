extension Processor {
  struct SavePoint {
    var pc: InstructionAddress
    var pos: Position?
    var rangeStart: Position?
    var rangeEnd: Position?
    var isScalarSemantics: Bool
    var stackEnd: CallStackAddress
    var captureEnds: [_StoredCapture]
    var intRegisters: [Int]
    var posRegisters: [Input.Index]
    var destructure: (
      pc: InstructionAddress,
      pos: Position?,
      stackEnd: CallStackAddress,
      captureEnds: [_StoredCapture],
      intRegisters: [Int],
      PositionRegister: [Input.Index]
    ) {
      return (pc, pos, stackEnd, captureEnds, intRegisters, posRegisters)
    }
    var rangeIsEmpty: Bool { rangeEnd == nil }
    mutating func updateRange(newEnd: Input.Index) {
      if rangeStart == nil {
        rangeStart = newEnd
      }
      rangeEnd = newEnd
    }
    mutating func takePositionFromRange(_ input: Input) {
      assert(!rangeIsEmpty)
      pos = rangeEnd!
      shrinkRange(input)
    }
    mutating func shrinkRange(_ input: Input) {
      assert(!rangeIsEmpty)
      if rangeEnd == rangeStart {
        rangeStart = nil
        rangeEnd = nil
      } else {
        if isScalarSemantics {
          input.unicodeScalars.formIndex(before: &rangeEnd!)
        } else {
          input.formIndex(before: &rangeEnd!)
        }
      }
    }
  }
  func makeSavePoint(
    _ pc: InstructionAddress,
    addressOnly: Bool = false
  ) -> SavePoint {
    SavePoint(
      pc: pc,
      pos: addressOnly ? nil : currentPosition,
      rangeStart: nil,
      rangeEnd: nil,
      isScalarSemantics: false, 
      stackEnd: .init(callStack.count),
      captureEnds: storedCaptures,
      intRegisters: registers.ints,
      posRegisters: registers.positions)
  }
  func startQuantifierSavePoint(
    isScalarSemantics: Bool
  ) -> SavePoint {
    SavePoint(
      pc: controller.pc + 1,
      pos: nil,
      rangeStart: nil,
      rangeEnd: nil,
      isScalarSemantics: isScalarSemantics,
      stackEnd: .init(callStack.count),
      captureEnds: storedCaptures,
      intRegisters: registers.ints,
      posRegisters: registers.positions)
  }
}
