struct TypedIndex<C: Collection, 👻>: RawRepresentable where C.Index == Int {
  var rawValue: C
  init(rawValue: C) { self.rawValue = rawValue }
  init(_ rawValue: C) { self.init(rawValue: rawValue) }
}
extension TypedIndex: Collection {
  typealias Index = TypedInt<👻>
  typealias Element = C.Element
  var startIndex: Index { Index(rawValue.startIndex) }
  var endIndex: Index { Index(rawValue.endIndex )}
  var count: Int { rawValue.count }
  func index(after: Index) -> Index {
    Index(rawValue.index(after: after.rawValue))
  }
  subscript(position: Index) -> Element {
    rawValue[position.rawValue]
  }
  func distance(
    from start: Index, to end: Index
  ) -> Int {
    rawValue.distance(from: start.rawValue, to: end.rawValue)
  }
  func index(_ i: Index, offsetBy distance: Int) -> Index {
    Index(rawValue.index(i.rawValue, offsetBy: distance))
  }
  func index(_ i: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
    guard let idx = rawValue.index(i.rawValue, offsetBy: distance, limitedBy: limit.rawValue) else {
      return nil
    }
    return Index(idx)
  }
}
extension TypedIndex: RandomAccessCollection where C: RandomAccessCollection {
}
extension TypedIndex: MutableCollection where C: MutableCollection {
  subscript(position: Index) -> Element {
    _read {
      yield rawValue[position.rawValue]
    }
    _modify {
      yield &rawValue[position.rawValue]
    }
  }
}
extension TypedIndex: BidirectionalCollection where C: BidirectionalCollection {
  func index(before: Index) -> Index {
    Index(rawValue.index(before: before.rawValue))
  }
}
#if false
extension TypedIndex: RangeReplaceableCollection where C: RangeReplaceableCollection {
  init() { content = C() }
  mutating func replaceSubrange<C>(_ subrange: Range<Index>, with newElements: C) where C : Collection, C.Element == Element {
    let rawRange = subrange.lowerBound.content ..< subrange.upperBound.content
    content.replaceSubrange(rawRange, with: newElements)
  }
}
#endif
extension TypedIndex where C: RangeReplaceableCollection {
  mutating func append(_ newElement: Element) {
    rawValue.append(newElement)
  }
}
extension TypedIndex: ExpressibleByArrayLiteral where C: ExpressibleByArrayLiteral & RangeReplaceableCollection {
  init(arrayLiteral elements: Element...) {
    self.init(C(elements))
  }
}
typealias InstructionList<Instruction: InstructionProtocol> = TypedIndex<[Instruction], _InstructionAddress>
