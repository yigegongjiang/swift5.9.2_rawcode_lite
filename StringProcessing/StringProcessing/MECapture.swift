/*
 TODO: Specialized data structure for all captures:
 - We want to be able to refer to COW prefixes for which
   simple appends do not invalidate
 - We want a compact save-point representation
 TODO: Conjectures:
 - We should be able to remove the entire capture history,
   lazily recomputing it on-request from the initial stored
   save point
 - We should be able to keep these flat and simple, lazily
   constructing structured types on-request
 */
extension Processor {
  struct _StoredCapture {
    var range: Range<Position>? = nil
    var value: Any? = nil
    fileprivate var currentCaptureBegin: Position? = nil
    fileprivate func _invariantCheck() {
      if range == nil {
        assert(value == nil)
      }
    }
    var deconstructed: (range: Range<Position>, value: Any?)? {
      guard let r = range else { return nil }
      return (r, value)
    }
    mutating func startCapture(
      _ idx: Position
    ) {
      _invariantCheck()
      defer { _invariantCheck() }
      currentCaptureBegin = idx
    }
    mutating func endCapture(_ idx: Position) {
      _invariantCheck()
      defer { _invariantCheck() }
      guard let low = currentCaptureBegin else {
        fatalError("Invariant violated: ending unstarted capture")
      }
      range = low..<idx
      value = nil 
      currentCaptureBegin = nil
    }
    mutating func registerValue(
      _ value: Any,
      overwriteInitial: SavePoint? = nil
    ) {
      _invariantCheck()
      defer { _invariantCheck() }
      self.value = value
    }
  }
}
struct MECaptureList {
  var values: Array<Processor._StoredCapture>
  var referencedCaptureOffsets: [ReferenceID: Int]
  func latestUntyped(from input: String) -> Array<Substring?> {
    values.map {
      guard let range = $0.range else {
        return nil
      }
      return input[range]
    }
  }
}
