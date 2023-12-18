#if _runtime(_ObjC)
import SwiftShims
@usableFromInline
@frozen
internal struct _CocoaArrayWrapper: RandomAccessCollection {
  @usableFromInline
  typealias Indices = Range<Int>
  @usableFromInline
  internal var buffer: AnyObject
  internal init(_ buffer: AnyObject) {
    self.buffer = buffer
  }
  internal var core: _NSArrayCore {
    @inline(__always) get {
      return unsafeBitCast(buffer, to: _NSArrayCore.self)
    }
  }
  @inlinable
  internal var startIndex: Int {
    return 0
  }
  @usableFromInline
  internal var endIndex: Int {
    return core.count
  }
  @usableFromInline
  internal subscript(i: Int) -> AnyObject {
    return core.objectAt(i)
  }
  @usableFromInline
  internal subscript(bounds: Range<Int>) -> _SliceBuffer<AnyObject> {
    let boundsCount = bounds.count
    if boundsCount == 0 {
      return _SliceBuffer(
        _buffer: _ContiguousArrayBuffer<AnyObject>(),
        shiftedToStartIndex: bounds.lowerBound)
    }
    let cocoaStorageBaseAddress = self.contiguousStorage(self.indices)
    if let cocoaStorageBaseAddress = cocoaStorageBaseAddress {
      return _SliceBuffer(
        owner: self.buffer,
        subscriptBaseAddress: cocoaStorageBaseAddress,
        indices: bounds,
        hasNativeBuffer: false)
    }
    let result = _ContiguousArrayBuffer<AnyObject>(
      _uninitializedCount: boundsCount,
      minimumCapacity: 0)
    let base = UnsafeMutableRawPointer(result.firstElementAddress)
      .assumingMemoryBound(to: AnyObject.self)
    for idx in 0..<boundsCount {
      (base + idx).initialize(to: core.objectAt(idx + bounds.lowerBound))
    }
    return _SliceBuffer(_buffer: result, shiftedToStartIndex: bounds.lowerBound)
  }
  internal func contiguousStorage(
    _ subRange: Range<Int>
  ) -> UnsafeMutablePointer<AnyObject>?
  {
    _internalInvariant(!subRange.isEmpty)
    var enumerationState = _makeSwiftNSFastEnumerationState()
    let contiguousCount = withUnsafeMutablePointer(to: &enumerationState) {
      core.countByEnumerating(with: $0, objects: nil, count: 0)
    }
    return contiguousCount >= subRange.upperBound
      ? UnsafeMutableRawPointer(enumerationState.itemsPtr!)
          .assumingMemoryBound(to: AnyObject.self)
        + subRange.lowerBound
      : nil
  }
  @usableFromInline
  __consuming internal func _copyContents(
    subRange bounds: Range<Int>,
    initializing target: UnsafeMutablePointer<AnyObject>
  ) -> UnsafeMutablePointer<AnyObject> {
    return withExtendedLifetime(buffer) {
      let nsSubRange = SwiftShims._SwiftNSRange(
        location: bounds.lowerBound,
        length: bounds.upperBound - bounds.lowerBound)
      core.getObjects(target, range: nsSubRange)
      var result = target
      for _ in bounds {
        result.initialize(to: result.pointee)
        result += 1
      }
      return result
    }
  }
  internal __consuming func _copyContents(
    initializing buffer: UnsafeMutableBufferPointer<Element>
  ) -> (Iterator, UnsafeMutableBufferPointer<Element>.Index) {
    guard buffer.count > 0 else { return (makeIterator(), 0) }
    let start = buffer.baseAddress!
    let c = Swift.min(self.count, buffer.count)
    _ = _copyContents(subRange: 0 ..< c, initializing: start)
    return (IndexingIterator(_elements: self, _position: c), c)
  }
}
#endif
