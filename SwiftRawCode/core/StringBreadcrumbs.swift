internal final class _StringBreadcrumbs {
  internal static var breadcrumbStride: Int { 64 }
  internal var utf16Length: Int
  internal var crumbs: [String.Index]
  internal init(_ str: String) {
    let stride = _StringBreadcrumbs.breadcrumbStride
    self.crumbs = []
    if str.isEmpty {
      self.utf16Length = 0
      return
    }
    self.crumbs.reserveCapacity(
      (str._guts.count / 3) / stride)
    let utf16 = str.utf16
    var i = 0
    var curIdx = utf16.startIndex
    while curIdx != utf16.endIndex {
      if i % stride == 0 { 
        self.crumbs.append(curIdx)
      }
      i = i &+ 1
      curIdx = utf16.index(after: curIdx)
    }
    if i % stride == 0 {
      self.crumbs.append(utf16.endIndex)
    }
    self.utf16Length = i
    _internalInvariant(self.crumbs.count == 1 + (self.utf16Length / stride))
    _invariantCheck(for: str)
  }
}
extension _StringBreadcrumbs {
  internal var stride: Int {
    @inline(__always) get { return _StringBreadcrumbs.breadcrumbStride }
  }
  internal func getBreadcrumb(
    forOffset offset: Int
  ) -> (lowerBound: String.Index, remaining: Int) {
    return (crumbs[offset / stride], offset % stride)
  }
  internal func getBreadcrumb(
    forIndex idx: String.Index
  ) -> (lowerBound: String.Index, offset: Int) {
    var lowerBound = idx._encodedOffset / 3 / stride
    var upperBound = Swift.min(1 + (idx._encodedOffset / stride), crumbs.count)
    _internalInvariant(crumbs[lowerBound] <= idx)
    _internalInvariant(upperBound == crumbs.count || crumbs[upperBound] >= idx)
    while (upperBound &- lowerBound) > 1 {
      let mid = lowerBound + ((upperBound &- lowerBound) / 2)
      if crumbs[mid] <= idx { lowerBound = mid } else { upperBound = mid }
    }
    let crumb = crumbs[lowerBound]
    _internalInvariant(crumb <= idx)
    _internalInvariant(lowerBound == crumbs.count-1 || crumbs[lowerBound+1] > idx)
    return (crumb, lowerBound &* stride)
  }
  #if !INTERNAL_CHECKS_ENABLED
  @nonobjc @inline(__always) internal func _invariantCheck(for str: String) {}
  #else
  internal func _invariantCheck(for str: String) {
    _internalInvariant(self.utf16Length == str.utf16._distance(
      from: str.startIndex, to: str.endIndex),
      "Stale breadcrumbs")
  }
  #endif 
}
