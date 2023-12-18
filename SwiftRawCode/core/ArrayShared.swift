@frozen
public struct _DependenceToken {
  @inlinable
  public init() {
  }
}
@inlinable 
@inline(__always)
public 
func _allocateUninitializedArray<Element>(_  builtinCount: Builtin.Word)
    -> (Array<Element>, Builtin.RawPointer) {
  let count = Int(builtinCount)
  if count > 0 {
    let bufferObject = Builtin.allocWithTailElems_1(
       getContiguousArrayStorageType(for: Element.self),
       builtinCount, Element.self)
    let (array, ptr) = Array<Element>._adoptStorage(bufferObject, count: count)
    return (array, ptr._rawValue)
  }
  let (array, ptr) = Array<Element>._allocateUninitialized(count)
  return (array, ptr._rawValue)
}
@inlinable
public 
func _deallocateUninitializedArray<Element>(
  _ array: __owned Array<Element>
) {
  var array = array
  array._deallocateUninitialized()
}
#if !INTERNAL_CHECKS_ENABLED
public 
func _finalizeUninitializedArray<Element>(
  _ array: __owned Array<Element>
) -> Array<Element> {
  var mutableArray = array
  mutableArray._endMutation()
  return mutableArray
}
#else
public 
func _finalizeUninitializedArray<Element>(
  _ array: __owned Array<Element>
) -> Array<Element> {
  var mutableArray = array
  mutableArray._endMutation()
  return mutableArray
}
#endif
extension Collection {  
  internal func _makeCollectionDescription(
    withTypeName type: String? = nil
  ) -> String {
#if !SWIFT_STDLIB_STATIC_PRINT
    var result = ""
    if let type = type {
      result += "\(type)(["
    } else {
      result += "["
    }
    var first = true
    for item in self {
      if first {
        first = false
      } else {
        result += ", "
      }
      debugPrint(item, terminator: "", to: &result)
    }
    result += type != nil ? "])" : "]"
    return result
#else
    return "(collection printing not available)"
#endif
  }
}
extension _ArrayBufferProtocol {
  @inlinable 
  @inline(never)
  internal mutating func _arrayOutOfPlaceReplace<C: Collection>(
    _ bounds: Range<Int>,
    with newValues: __owned C,
    count insertCount: Int
  ) where C.Element == Element {
    let growth = insertCount - bounds.count
    let newCount = self.count + growth
    var newBuffer = _forceCreateUniqueMutableBuffer(
      newCount: newCount, requiredCapacity: newCount)
    _arrayOutOfPlaceUpdate(
      &newBuffer, bounds.lowerBound - startIndex, insertCount,
      { rawMemory, count in
        var p = rawMemory
        var q = newValues.startIndex
        for _ in 0..<count {
          p.initialize(to: newValues[q])
          newValues.formIndex(after: &q)
          p += 1
        }
        _expectEnd(of: newValues, is: q)
      }
    )
  }
}
@inlinable
internal func _expectEnd<C: Collection>(of s: C, is i: C.Index) {
  _debugPrecondition(
    i == s.endIndex,
    "invalid Collection: count differed in successive traversals")
}
@inlinable
internal func _growArrayCapacity(_ capacity: Int) -> Int {
  return capacity * 2
}
internal func _growArrayCapacity(
  oldCapacity: Int, minimumCapacity: Int, growForAppend: Bool
) -> Int {
  if growForAppend {
    if oldCapacity < minimumCapacity {
      return Swift.max(minimumCapacity, _growArrayCapacity(oldCapacity))
    }
    return oldCapacity
  }
  return minimumCapacity
}
extension _ArrayBufferProtocol {
  @inline(never)
  @inlinable 
  internal func _forceCreateUniqueMutableBuffer(
    newCount: Int, requiredCapacity: Int
  ) -> _ContiguousArrayBuffer<Element> {
    return _forceCreateUniqueMutableBufferImpl(
      countForBuffer: newCount, minNewCapacity: newCount,
      requiredCapacity: requiredCapacity)
  }
  @inline(never)
  @inlinable 
  internal func _forceCreateUniqueMutableBuffer(
    countForNewBuffer: Int, minNewCapacity: Int
  ) -> _ContiguousArrayBuffer<Element> {
    return _forceCreateUniqueMutableBufferImpl(
      countForBuffer: countForNewBuffer, minNewCapacity: minNewCapacity,
      requiredCapacity: minNewCapacity)
  }
  @inlinable
  internal func _forceCreateUniqueMutableBufferImpl(
    countForBuffer: Int, minNewCapacity: Int,
    requiredCapacity: Int
  ) -> _ContiguousArrayBuffer<Element> {
    _internalInvariant(countForBuffer >= 0)
    _internalInvariant(requiredCapacity >= countForBuffer)
    _internalInvariant(minNewCapacity >= countForBuffer)
    let minimumCapacity = Swift.max(requiredCapacity,
      minNewCapacity > capacity
         ? _growArrayCapacity(capacity) : capacity)
    return _ContiguousArrayBuffer(
      _uninitializedCount: countForBuffer, minimumCapacity: minimumCapacity)
  }
}
extension _ArrayBufferProtocol {
  @inline(never)
  @inlinable 
  internal mutating func _arrayOutOfPlaceUpdate(
    _ dest: inout _ContiguousArrayBuffer<Element>,
    _ headCount: Int, 
    _ newCount: Int,  
    _ initializeNewElements: 
        ((UnsafeMutablePointer<Element>, _ count: Int) -> ()) = { ptr, count in
      _internalInvariant(count == 0)
    }
  ) {
    _internalInvariant(headCount >= 0)
    _internalInvariant(newCount >= 0)
    let sourceCount = self.count
    let tailCount = dest.count - headCount - newCount
    _internalInvariant(headCount + tailCount <= sourceCount)
    let oldCount = sourceCount - headCount - tailCount
    let destStart = dest.firstElementAddress
    let newStart = destStart + headCount
    let newEnd = newStart + newCount
    if let backing = requestUniqueMutableBackingBuffer(
      minimumCapacity: sourceCount) {
      let sourceStart = firstElementAddress
      let oldStart = sourceStart + headCount
      let backingStart = backing.firstElementAddress
      let sourceOffset = sourceStart - backingStart
      backingStart.deinitialize(count: sourceOffset)
      destStart.moveInitialize(from: sourceStart, count: headCount)
      oldStart.deinitialize(count: oldCount)
      initializeNewElements(newStart, newCount)
      newEnd.moveInitialize(from: oldStart + oldCount, count: tailCount)
      let backingEnd = backingStart + backing.count
      let sourceEnd = sourceStart + sourceCount
      sourceEnd.deinitialize(count: backingEnd - sourceEnd)
      backing.count = 0
    }
    else {
      let headStart = startIndex
      let headEnd = headStart + headCount
      let newStart = _copyContents(
        subRange: headStart..<headEnd,
        initializing: destStart)
      initializeNewElements(newStart, newCount)
      let tailStart = headEnd + oldCount
      let tailEnd = endIndex
      _copyContents(subRange: tailStart..<tailEnd, initializing: newEnd)
    }
    self = Self(_buffer: dest, shiftedToStartIndex: startIndex)
  }
}
extension _ArrayBufferProtocol {
  @inline(never)
  @usableFromInline
  internal mutating func _outlinedMakeUniqueBuffer(bufferCount: Int) {
    if _fastPath(
        requestUniqueMutableBackingBuffer(minimumCapacity: bufferCount) != nil) {
      return
    }
    var newBuffer = _forceCreateUniqueMutableBuffer(
      newCount: bufferCount, requiredCapacity: bufferCount)
    _arrayOutOfPlaceUpdate(&newBuffer, bufferCount, 0)
  }
  @inlinable
  internal mutating func _arrayAppendSequence<S: Sequence>(
    _ newItems: __owned S
  ) where S.Element == Element {
    _internalInvariant(count == capacity)
    var newCount = self.count
    var stream = newItems.makeIterator()
    var nextItem = stream.next()
    while nextItem != nil {
      var newBuffer = _forceCreateUniqueMutableBuffer(
        countForNewBuffer: newCount, 
        minNewCapacity: newCount + 1)
      _arrayOutOfPlaceUpdate(&newBuffer, newCount, 0)
      let currentCapacity = self.capacity
      let base = self.firstElementAddress
      while let next = nextItem, newCount < currentCapacity {
        (base + newCount).initialize(to: next)
        newCount += 1
        nextItem = stream.next()
      }
      self.count = newCount
    }
  }
}
