@available(SwiftStdlib 5.7, *)
extension Regex {
  internal func _verifyType() -> (Bool, Any.Type) {
    guard Output.self != AnyRegexOutput.self else {
      return (true, Output.self)
    }
    var tupleElements: [Any.Type] = []
    var labels = ""
    for capture in program.tree.captureList.captures {
      var captureType = capture.type
      var i = capture.optionalDepth
      while i != 0 {
        captureType = TypeConstruction.optionalType(of: captureType)
        i -= 1
      }
      tupleElements.append(captureType)
      if let name = capture.name {
        labels += name
      }
      labels.unicodeScalars.append(" ")
    }
    if tupleElements.count == 1 {
      let wholeMatchType = program.tree.root.wholeMatchType
      return (Output.self == wholeMatchType, wholeMatchType)
    }
    let createdType = TypeConstruction.tupleType(
      of: tupleElements,
      labels: labels.all { $0 == " " } ? nil : labels
    )
    return (Output.self == createdType, createdType)
  }
}
