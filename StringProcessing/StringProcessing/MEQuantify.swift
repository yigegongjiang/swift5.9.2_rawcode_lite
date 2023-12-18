extension Processor {
  func _doQuantifyMatch(_ payload: QuantifyPayload) -> Input.Index? {
    let isScalarSemantics = payload.isScalarSemantics

    switch payload.type {
    case .bitset:
      return input.matchBitset(
        registers[payload.bitset],
        at: currentPosition,
        limitedBy: end,
        isScalarSemantics: isScalarSemantics)
    case .asciiChar:
      return input.matchScalar(
        UnicodeScalar.init(_value: UInt32(payload.asciiChar)),
        at: currentPosition,
        limitedBy: end,
        boundaryCheck: !isScalarSemantics,
        isCaseInsensitive: false)
    case .builtin:
      guard currentPosition < end else { return nil }

      // We only emit .quantify if it consumes a single character
      return input.matchBuiltinCC(
        payload.builtin,
        at: currentPosition,
        limitedBy: end,
        isInverted: payload.builtinIsInverted,
        isStrictASCII: payload.builtinIsStrict,
        isScalarSemantics: isScalarSemantics)
    case .any:
      guard currentPosition < end else { return nil }

      if payload.anyMatchesNewline {
        if isScalarSemantics {
          return input.unicodeScalars.index(after: currentPosition)
        }
        return input.index(after: currentPosition)
      }

      return input.matchAnyNonNewline(
        at: currentPosition,
        limitedBy: end,
        isScalarSemantics: isScalarSemantics)
    }
  }

  /// Generic quantify instruction interpreter
  /// - Handles .eager and .posessive
  /// - Handles arbitrary minTrips and extraTrips
  mutating func runQuantify(_ payload: QuantifyPayload) -> Bool {
    var trips = 0
    var extraTrips = payload.extraTrips
    var savePoint = startQuantifierSavePoint(
      isScalarSemantics: payload.isScalarSemantics
    )

    while true {
      if trips >= payload.minTrips {
        if extraTrips == 0 { break }
        extraTrips = extraTrips.map({$0 - 1})
        if payload.quantKind == .eager {
          savePoint.updateRange(newEnd: currentPosition)
        }
      }
      let next = _doQuantifyMatch(payload)
      guard let idx = next else {
        if !savePoint.rangeIsEmpty {
          // The last save point has saved the current, non-matching position,
          // so it's unneeded.
          savePoint.shrinkRange(input)
        }
        break
      }
      currentPosition = idx
      trips += 1
    }

    if trips < payload.minTrips {
      signalFailure()
      return false
    }

    if !savePoint.rangeIsEmpty {
      savePoints.append(savePoint)
    }
    return true
  }

  /// Specialized quantify instruction interpreter for *
  mutating func runEagerZeroOrMoreQuantify(_ payload: QuantifyPayload) -> Bool {
    assert(payload.quantKind == .eager
           && payload.minTrips == 0
           && payload.extraTrips == nil)
    var savePoint = startQuantifierSavePoint(
      isScalarSemantics: payload.isScalarSemantics
    )

    while true {
      savePoint.updateRange(newEnd: currentPosition)
      let next = _doQuantifyMatch(payload)
      guard let idx = next else { break }
      currentPosition = idx
    }

    // The last save point has saved the current position, so it's unneeded
    savePoint.shrinkRange(input)
    if !savePoint.rangeIsEmpty {
      savePoints.append(savePoint)
    }
    return true
  }

  /// Specialized quantify instruction interpreter for +
  mutating func runEagerOneOrMoreQuantify(_ payload: QuantifyPayload) -> Bool {
    assert(payload.quantKind == .eager
           && payload.minTrips == 1
           && payload.extraTrips == nil)
    var savePoint = startQuantifierSavePoint(
      isScalarSemantics: payload.isScalarSemantics
    )
    while true {
      let next = _doQuantifyMatch(payload)
      guard let idx = next else { break }
      currentPosition = idx
      savePoint.updateRange(newEnd: currentPosition)
    }

    if savePoint.rangeIsEmpty {
      signalFailure()
      return false
    }
    // The last save point has saved the current position, so it's unneeded
    savePoint.shrinkRange(input)
    if !savePoint.rangeIsEmpty {
      savePoints.append(savePoint)
    }
    return true
  }

  /// Specialized quantify instruction interpreter for ?
  mutating func runZeroOrOneQuantify(_ payload: QuantifyPayload) -> Bool {
    assert(payload.minTrips == 0
           && payload.extraTrips == 1)
    let next = _doQuantifyMatch(payload)
    guard let idx = next else {
      return true // matched zero times
    }
    if payload.quantKind != .possessive {
      // Save the zero match
      let savePoint = makeSavePoint(currentPC + 1)
      savePoints.append(savePoint)
    }
    currentPosition = idx
    return true
  }
}
