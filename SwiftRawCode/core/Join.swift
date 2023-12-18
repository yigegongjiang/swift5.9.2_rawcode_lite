@frozen 
public struct JoinedSequence<Base: Sequence> where Base.Element: Sequence {
  public typealias Element = Base.Element.Element
  @usableFromInline 
  internal var _base: Base
  @usableFromInline 
  internal var _separator: ContiguousArray<Element>
  @inlinable 
  public init<Separator: Sequence>(base: Base, separator: Separator)
    where Separator.Element == Element {
    self._base = base
    self._separator = ContiguousArray(separator)
  }
}
extension JoinedSequence {
  @frozen 
  public struct Iterator {
    @frozen 
    @usableFromInline 
    internal enum _JoinIteratorState {
      case start
      case generatingElements
      case generatingSeparator
      case end
    }
    @usableFromInline 
    internal var _base: Base.Iterator
    @usableFromInline 
    internal var _inner: Base.Element.Iterator?
    @usableFromInline 
    internal var _separatorData: ContiguousArray<Element>
    @usableFromInline 
    internal var _separator: ContiguousArray<Element>.Iterator?
    @usableFromInline 
    internal var _state: _JoinIteratorState = .start
    @inlinable 
    public init<Separator: Sequence>(base: Base.Iterator, separator: Separator)
      where Separator.Element == Element {
      self._base = base
      self._separatorData = ContiguousArray(separator)
    }
  }
}
extension JoinedSequence.Iterator: IteratorProtocol {
  public typealias Element = Base.Element.Element
  @inlinable 
  public mutating func next() -> Element? {
    while true {
      switch _state {
      case .start:
        if let nextSubSequence = _base.next() {
          _inner = nextSubSequence.makeIterator()
          _state = .generatingElements
        } else {
          _state = .end
          return nil
        }
      case .generatingElements:
        let result = _inner!.next()
        if _fastPath(result != nil) {
          return result
        }
        _inner = _base.next()?.makeIterator()
        if _inner == nil {
          _state = .end
          return nil
        }
        if !_separatorData.isEmpty {
          _separator = _separatorData.makeIterator()
          _state = .generatingSeparator
        }
      case .generatingSeparator:
        let result = _separator!.next()
        if _fastPath(result != nil) {
          return result
        }
        _state = .generatingElements
      case .end:
        return nil
      }
    }
  }
}
extension JoinedSequence: Sequence {
  @inlinable 
  public __consuming func makeIterator() -> Iterator {
    return Iterator(base: _base.makeIterator(), separator: _separator)
  }
  @inlinable 
  public __consuming func _copyToContiguousArray() -> ContiguousArray<Element> {
    var result = ContiguousArray<Element>()
    let separatorSize = _separator.count
    if separatorSize == 0 {
      for x in _base {
        result.append(contentsOf: x)
      }
      return result
    }
    var iter = _base.makeIterator()
    if let first = iter.next() {
      result.append(contentsOf: first)
      while let next = iter.next() {
        result.append(contentsOf: _separator)
        result.append(contentsOf: next)
      }
    }
    return result
  }
}
extension Sequence where Element: Sequence {
  @inlinable 
  public __consuming func joined<Separator: Sequence>(
    separator: Separator
  ) -> JoinedSequence<Self>
    where Separator.Element == Element.Element {
    return JoinedSequence(base: self, separator: separator)
  }
}
