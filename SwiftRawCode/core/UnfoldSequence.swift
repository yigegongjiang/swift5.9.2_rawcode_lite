@inlinable 
public func sequence<T>(first: T, next: @escaping (T) -> T?) -> UnfoldFirstSequence<T> {
  return sequence(state: (first, true), next: { (state: inout (T?, Bool)) -> T? in
    switch state {
    case (let value, true):
      state.1 = false
      return value
    case (let value?, _):
      let nextValue = next(value)
      state.0 = nextValue
      return nextValue
    case (nil, _):
      return nil
    }
  })
}
@inlinable 
public func sequence<T, State>(state: State, next: @escaping (inout State) -> T?)
  -> UnfoldSequence<T, State> {
  return UnfoldSequence(_state: state, _next: next)
}
public typealias UnfoldFirstSequence<T> = UnfoldSequence<T, (T?, Bool)>
@frozen 
public struct UnfoldSequence<Element, State>: Sequence, IteratorProtocol {
  @usableFromInline 
  internal var _state: State
  @usableFromInline 
  internal let _next: (inout State) -> Element?
  @usableFromInline 
  internal var _done = false
  @inlinable 
  public mutating func next() -> Element? {
    guard !_done else { return nil }
    if let elt = _next(&_state) {
        return elt
    } else {
        _done = true
        return nil
    }
  }
  @inlinable 
  internal init(_state: State, _next: @escaping (inout State) -> Element?) {
    self._state = _state
    self._next = _next
  }
}
