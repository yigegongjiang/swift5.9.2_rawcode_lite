internal struct _FixedArray16<T> {
  internal var storage: (
    T, T, T, T, T, T, T, T,
    T, T, T, T, T, T, T, T
  )
  var _count: Int8
}
extension _FixedArray16 {
  internal static var capacity: Int {
    @inline(__always) get { return 16 }
  }
  internal var capacity: Int {
    @inline(__always) get { return 16 }
  }
  internal var count: Int {
    @inline(__always) get { return Int(truncatingIfNeeded: _count) }
    @inline(__always) set { _count = Int8(newValue) }
  }
}
extension _FixedArray16: RandomAccessCollection, MutableCollection {
  internal typealias Index = Int
  internal var startIndex: Index {
    return 0
  }
  internal var endIndex: Index {
    return count
  }
  internal subscript(i: Index) -> T {
    @inline(__always)
    get {
      let count = self.count 
      _internalInvariant(i >= 0 && i < count)
      let res: T = withUnsafeBytes(of: storage) {
        (rawPtr: UnsafeRawBufferPointer) -> T in
        let stride = MemoryLayout<T>.stride
        _internalInvariant(rawPtr.count == 16*stride, "layout mismatch?")
        let bufPtr = UnsafeBufferPointer(
          start: rawPtr.baseAddress!.assumingMemoryBound(to: T.self),
          count: count)
        return bufPtr[_unchecked: i]
      }
      return res
    }
    @inline(__always)
    set {
      _internalInvariant(i >= 0 && i < count)
      self.withUnsafeMutableBufferPointer { buffer in
        buffer[_unchecked: i] = newValue
      }
    }
  }
  @inline(__always)
  internal func index(after i: Index) -> Index {
    return i+1
  }
  @inline(__always)
  internal func index(before i: Index) -> Index {
    return i-1
  }
}
extension _FixedArray16 {
  internal mutating func append(_ newElement: T) {
    _internalInvariant(count < capacity)
    _count += 1
    self[count-1] = newElement
  }
}
extension _FixedArray16 where T: ExpressibleByIntegerLiteral {
  @inline(__always)
  internal init(count: Int) {
    _internalInvariant(count >= 0 && count <= _FixedArray16.capacity)
    self.storage = (
      0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0
    )
    self._count = Int8(truncatingIfNeeded: count)
  }
  @inline(__always)
  internal init() {
    self.init(count: 0)
  }
  @inline(__always)
  internal init(allZeros: ()) {
    self.init(count: 16)
  }
}
extension _FixedArray16 {
  internal mutating func withUnsafeMutableBufferPointer<R>(
    _ body: (UnsafeMutableBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    let count = self.count 
    return try withUnsafeMutableBytes(of: &storage) { rawBuffer in
      _internalInvariant(rawBuffer.count == 16*MemoryLayout<T>.stride,
        "layout mismatch?")
      let buffer = UnsafeMutableBufferPointer<Element>(
        start: rawBuffer.baseAddress._unsafelyUnwrappedUnchecked
          .assumingMemoryBound(to: Element.self),
        count: count)
      return try body(buffer)
    }
  }
  internal mutating func withUnsafeBufferPointer<R>(
    _ body: (UnsafeBufferPointer<Element>) throws -> R
  ) rethrows -> R {
    let count = self.count 
    return try withUnsafeBytes(of: &storage) { rawBuffer in
      _internalInvariant(rawBuffer.count == 16*MemoryLayout<T>.stride,
        "layout mismatch?")
      let buffer = UnsafeBufferPointer<Element>(
        start: rawBuffer.baseAddress._unsafelyUnwrappedUnchecked
        .assumingMemoryBound(to: Element.self),
        count: count)
      return try body(buffer)
    }
  }
}
