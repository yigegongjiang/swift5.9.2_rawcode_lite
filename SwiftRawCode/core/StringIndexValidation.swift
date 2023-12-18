extension _StringGuts {
  internal func isFastScalarIndex(_ i: String.Index) -> Bool {
    hasMatchingEncoding(i) && i._isScalarAligned
  }
  internal func isFastCharacterIndex(_ i: String.Index) -> Bool {
    hasMatchingEncoding(i) && i._isCharacterAligned
  }
}
extension _StringGuts {
  internal func validateSubscalarIndex(_ i: String.Index) -> String.Index {
    let i = ensureMatchingEncoding(i)
    _precondition(i._encodedOffset < count, "String index is out of bounds")
    return i
  }
  internal func validateSubscalarIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    let i = ensureMatchingEncoding(i)
    _precondition(i >= bounds.lowerBound && i < bounds.upperBound,
      "Substring index is out of bounds")
    return i
  }
  internal func validateInclusiveSubscalarIndex(
    _ i: String.Index
  ) -> String.Index {
    let i = ensureMatchingEncoding(i)
    _precondition(i._encodedOffset <= count, "String index is out of bounds")
    return i
  }
  internal func validateInclusiveSubscalarIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    let i = ensureMatchingEncoding(i)
    _precondition(i >= bounds.lowerBound && i <= bounds.upperBound,
      "Substring index is out of bounds")
    return i
  }
  internal func validateSubscalarRange(
    _ range: Range<String.Index>
  ) -> Range<String.Index> {
    let upper = ensureMatchingEncoding(range.upperBound)
    let lower = ensureMatchingEncoding(range.lowerBound)
    _precondition(upper <= endIndex && lower <= upper,
      "String index range is out of bounds")
    return Range(_uncheckedBounds: (lower, upper))
  }
  internal func validateSubscalarRange(
    _ range: Range<String.Index>,
    in bounds: Range<String.Index>
  ) -> Range<String.Index> {
    _internalInvariant(bounds.upperBound <= endIndex)
    let upper = ensureMatchingEncoding(range.upperBound)
    let lower = ensureMatchingEncoding(range.lowerBound)
    _precondition(
      lower >= bounds.lowerBound
      && lower <= upper
      && upper <= bounds.upperBound,
      "Substring index range is out of bounds")
    return Range(_uncheckedBounds: (lower, upper))
  }
}
extension _StringGuts {
  internal func validateScalarIndex(_ i: String.Index) -> String.Index {
    if isFastScalarIndex(i) {
      _precondition(i._encodedOffset < count, "String index is out of bounds")
      return i
    }
    return scalarAlign(validateSubscalarIndex(i))
  }
  internal func validateScalarIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    if isFastScalarIndex(i) {
      _precondition(i >= bounds.lowerBound && i < bounds.upperBound,
        "Substring index is out of bounds")
      return i
    }
    return scalarAlign(validateSubscalarIndex(i, in: bounds))
  }
}
extension _StringGuts {
  internal func validateInclusiveScalarIndex(
    _ i: String.Index
  ) -> String.Index {
    if isFastScalarIndex(i) {
      _precondition(i._encodedOffset <= count, "String index is out of bounds")
      return i
    }
    return scalarAlign(validateInclusiveSubscalarIndex(i))
  }
  internal func validateInclusiveScalarIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    if isFastScalarIndex(i) {
      _precondition(i >= bounds.lowerBound && i <= bounds.upperBound,
        "Substring index is out of bounds")
      return i
    }
    return scalarAlign(validateInclusiveSubscalarIndex(i, in: bounds))
  }
}
extension _StringGuts {
  internal func validateScalarRange(
    _ range: Range<String.Index>
  ) -> Range<String.Index> {
    if
      isFastScalarIndex(range.lowerBound), isFastScalarIndex(range.upperBound)
    {
      _precondition(range.upperBound._encodedOffset <= count,
        "String index range is out of bounds")
      return range
    }
    let r = validateSubscalarRange(range)
    return Range(
      _uncheckedBounds: (scalarAlign(r.lowerBound), scalarAlign(r.upperBound)))
  }
  internal func validateScalarRange(
    _ range: Range<String.Index>,
    in bounds: Range<String.Index>
  ) -> Range<String.Index> {
    _internalInvariant(bounds.upperBound <= endIndex)
    if
      isFastScalarIndex(range.lowerBound), isFastScalarIndex(range.upperBound)
    {
      _precondition(
        range.lowerBound >= bounds.lowerBound
        && range.upperBound <= bounds.upperBound,
        "String index range is out of bounds")
      return range
    }
    let r = validateSubscalarRange(range, in: bounds)
    let upper = scalarAlign(r.upperBound)
    let lower = scalarAlign(r.lowerBound)
    return Range(_uncheckedBounds: (lower, upper))
  }
}
extension _StringGuts {
  internal func validateCharacterIndex(_ i: String.Index) -> String.Index {
    if isFastCharacterIndex(i) {
      _precondition(i._encodedOffset < count, "String index is out of bounds")
      return i
    }
    return roundDownToNearestCharacter(scalarAlign(validateSubscalarIndex(i)))
  }
  internal func validateCharacterIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    if isFastCharacterIndex(i) {
      _precondition(i >= bounds.lowerBound && i < bounds.upperBound,
        "Substring index is out of bounds")
      return i
    }
    return roundDownToNearestCharacter(
      scalarAlign(validateSubscalarIndex(i, in: bounds)),
      in: bounds)
  }
  internal func validateInclusiveCharacterIndex(
    _ i: String.Index
  ) -> String.Index {
    if isFastCharacterIndex(i) {
      _precondition(i._encodedOffset <= count, "String index is out of bounds")
      return i
    }
    return roundDownToNearestCharacter(
      scalarAlign(validateInclusiveSubscalarIndex(i)))
  }
  internal func validateInclusiveCharacterIndex(
    _ i: String.Index,
    in bounds: Range<String.Index>
  ) -> String.Index {
    _internalInvariant(bounds.upperBound <= endIndex)
    if isFastCharacterIndex(i) {
      _precondition(i >= bounds.lowerBound && i <= bounds.upperBound,
        "Substring index is out of bounds")
      return i
    }
    return roundDownToNearestCharacter(
      scalarAlign(validateInclusiveSubscalarIndex(i, in: bounds)),
      in: bounds)
  }
}
extension _StringGuts {
  internal func validateInclusiveSubscalarIndex_5_7(
    _ i: String.Index
  ) -> String.Index {
    let i = ensureMatchingEncoding(i)
    _precondition(
      ifLinkedOnOrAfter: .v5_7_0,
      i._encodedOffset <= count,
      "String index is out of bounds")
    return i
  }
  internal func validateInclusiveScalarIndex_5_7(
    _ i: String.Index
  ) -> String.Index {
    if isFastScalarIndex(i) {
      _precondition(
        ifLinkedOnOrAfter: .v5_7_0,
        i._encodedOffset <= count,
        "String index is out of bounds")
      return i
    }
    return scalarAlign(validateInclusiveSubscalarIndex_5_7(i))
  }
  internal func validateSubscalarRange_5_7(
    _ range: Range<String.Index>
  ) -> Range<String.Index> {
    let upper = ensureMatchingEncoding(range.upperBound)
    let lower = ensureMatchingEncoding(range.lowerBound)
    _precondition(upper <= endIndex && lower <= upper,
      "String index range is out of bounds")
    return Range(_uncheckedBounds: (lower, upper))
  }
  internal func validateScalarRange_5_7(
    _ range: Range<String.Index>
  ) -> Range<String.Index> {
    if
      isFastScalarIndex(range.lowerBound), isFastScalarIndex(range.upperBound)
    {
      _precondition(
        ifLinkedOnOrAfter: .v5_7_0,
        range.upperBound._encodedOffset <= count,
        "String index range is out of bounds")
      return range
    }
    let r = validateSubscalarRange_5_7(range)
    return Range(
      _uncheckedBounds: (scalarAlign(r.lowerBound), scalarAlign(r.upperBound)))
  }
  internal func validateInclusiveCharacterIndex_5_7(
    _ i: String.Index
  ) -> String.Index {
    if isFastCharacterIndex(i) {
      _precondition(
        ifLinkedOnOrAfter: .v5_7_0,
        i._encodedOffset <= count,
        "String index is out of bounds")
      return i
    }
    return roundDownToNearestCharacter(
      scalarAlign(validateInclusiveSubscalarIndex_5_7(i)))
  }
}
extension _StringGuts {
  internal func validateWordIndex(
    _ i: String.Index
  ) -> String.Index {
    return roundDownToNearestWord(scalarAlign(validateSubscalarIndex(i)))
  }
  internal func validateInclusiveWordIndex(
    _ i: String.Index
  ) -> String.Index {
    return roundDownToNearestWord(
      scalarAlign(validateInclusiveSubscalarIndex(i))
    )
  }
}
