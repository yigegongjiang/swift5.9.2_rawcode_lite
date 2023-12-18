internal struct _BridgingBufferHeader {
  internal var count: Int
  internal init(_ count: Int) { self.count = count }
}
internal final class __BridgingBufferStorage
  : ManagedBuffer<_BridgingBufferHeader, AnyObject> {
}
internal typealias _BridgingBuffer
  = ManagedBufferPointer<_BridgingBufferHeader, AnyObject>
@available(OpenBSD, unavailable, message: "malloc_size is unavailable.")
extension ManagedBufferPointer
where Header == _BridgingBufferHeader, Element == AnyObject {
  internal init(_ count: Int) {
    self.init(
      _uncheckedBufferClass: __BridgingBufferStorage.self,
      minimumCapacity: count)
    self.withUnsafeMutablePointerToHeader {
      $0.initialize(to: Header(count))
    }
  }
  internal var count: Int {
    @inline(__always)
    get {
      return header.count
    }
    @inline(__always)
    set {
      return header.count = newValue
    }
  }
  internal subscript(i: Int) -> Element {
    @inline(__always)
    get {
      return withUnsafeMutablePointerToElements { $0[i] }
    }
  }
  internal var baseAddress: UnsafeMutablePointer<Element> {
    @inline(__always)
    get {
      return withUnsafeMutablePointerToElements { $0 }
    }
  }
  internal var storage: AnyObject? {
    @inline(__always)
    get {
      return buffer
    }
  }
}
