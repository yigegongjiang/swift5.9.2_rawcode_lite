@usableFromInline
internal protocol _ArrayBufferProtocol
  : MutableCollection, RandomAccessCollection 
where Indices == Range<Int> {
  init()
  init(_buffer: _ContiguousArrayBuffer<Element>, shiftedToStartIndex: Int)
  init(copying buffer: Self)
  @discardableResult
  __consuming func _copyContents(
    subRange bounds: Range<Int>,
    initializing target: UnsafeMutablePointer<Element>
  ) -> UnsafeMutablePointer<Element>
  mutating func requestUniqueMutableBackingBuffer(
    minimumCapacity: Int
  ) -> _ContiguousArrayBuffer<Element>?
  mutating func isMutableAndUniquelyReferenced() -> Bool
  func requestNativeBuffer() -> _ContiguousArrayBuffer<Element>?
  mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with newCount: Int,
    elementsOf newValues: __owned C
  ) where C: Collection, C.Element == Element
  subscript(bounds: Range<Int>) -> _SliceBuffer<Element> { get }
  func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R
  mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R
  override var count: Int { get set }
  var capacity: Int { get }
  var owner: AnyObject { get }
  var firstElementAddress: UnsafeMutablePointer<Element> { get }
  var firstElementAddressIfContiguous: UnsafeMutablePointer<Element>? { get }
  var subscriptBaseAddress: UnsafeMutablePointer<Element> { get }
  var identity: UnsafeRawPointer { get }
}
extension _ArrayBufferProtocol {
  @inlinable
  internal var subscriptBaseAddress: UnsafeMutablePointer<Element> {
    return firstElementAddress
  }
  @inline(never)
  @inlinable 
  internal init(copying buffer: Self) {
    let newBuffer = _ContiguousArrayBuffer<Element>(
      _uninitializedCount: buffer.count, minimumCapacity: buffer.count)
    buffer._copyContents(
      subRange: buffer.indices,
      initializing: newBuffer.firstElementAddress)
    self = Self( _buffer: newBuffer, shiftedToStartIndex: buffer.startIndex)
  }
  @inlinable
  internal mutating func replaceSubrange<C>(
    _ subrange: Range<Int>,
    with newCount: Int,
    elementsOf newValues: __owned C
  ) where C: Collection, C.Element == Element {
    _internalInvariant(startIndex == 0, "_SliceBuffer should override this function.")
    let oldCount = self.count
    let eraseCount = subrange.count
    let growth = newCount - eraseCount
    if growth != 0 {
      self.count = oldCount + growth
    }
    let elements = self.subscriptBaseAddress
    let oldTailIndex = subrange.upperBound
    let oldTailStart = elements + oldTailIndex
    let newTailIndex = oldTailIndex + growth
    let newTailStart = oldTailStart + growth
    let tailCount = oldCount - subrange.upperBound
    if growth > 0 {
      newTailStart.moveInitialize(from: oldTailStart, count: tailCount)
      var i = newValues.startIndex
      for j in subrange {
        elements[j] = newValues[i]
        newValues.formIndex(after: &i)
      }
      for j in oldTailIndex..<newTailIndex {
        (elements + j).initialize(to: newValues[i])
        newValues.formIndex(after: &i)
      }
      _expectEnd(of: newValues, is: i)
    }
    else { 
      var i = subrange.lowerBound
      var j = newValues.startIndex
      for _ in 0..<newCount {
        elements[i] = newValues[j]
        i += 1
        newValues.formIndex(after: &j)
      }
      _expectEnd(of: newValues, is: j)
      if growth == 0 {
        return
      }
      let shrinkage = -growth
      if tailCount > shrinkage {   
        newTailStart.moveUpdate(from: oldTailStart, count: shrinkage)
        oldTailStart.moveInitialize(
          from: oldTailStart + shrinkage, count: tailCount - shrinkage)
      }
      else {                      
        newTailStart.moveUpdate(from: oldTailStart, count: tailCount)
        (newTailStart + tailCount).deinitialize(
          count: shrinkage - tailCount)
      }
    }
  }
}
