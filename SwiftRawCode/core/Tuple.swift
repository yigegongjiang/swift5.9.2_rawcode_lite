@inlinable 
public func ==(lhs: (), rhs: ()) -> Bool {
  return true
}
@inlinable 
public func !=(lhs: (), rhs: ()) -> Bool {
    return false
}
@inlinable 
public func <(lhs: (), rhs: ()) -> Bool {
    return false
}
@inlinable 
public func <=(lhs: (), rhs: ()) -> Bool {
    return true
}
@inlinable 
public func >(lhs: (), rhs: ()) -> Bool {
    return false
}
@inlinable 
public func >=(lhs: (), rhs: ()) -> Bool {
    return true
}
@inlinable 
public func == <A: Equatable, B: Equatable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  guard lhs.0 == rhs.0 else { return false }
   return (
    lhs.1
  ) == (
    rhs.1
  )
}
@inlinable 
public func != <A: Equatable, B: Equatable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  guard lhs.0 == rhs.0 else { return true }
   return (
    lhs.1
  ) != (
    rhs.1
  )
}
@inlinable 
public func < <A: Comparable, B: Comparable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 < rhs.0 }
   return (
    lhs.1
  ) < (
    rhs.1
  )
}
@inlinable 
public func <= <A: Comparable, B: Comparable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 <= rhs.0 }
   return (
    lhs.1
  ) <= (
    rhs.1
  )
}
@inlinable 
public func > <A: Comparable, B: Comparable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 > rhs.0 }
   return (
    lhs.1
  ) > (
    rhs.1
  )
}
@inlinable 
public func >= <A: Comparable, B: Comparable>(lhs: (A,B), rhs: (A,B)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 >= rhs.0 }
   return (
    lhs.1
  ) >= (
    rhs.1
  )
}
@inlinable 
public func == <A: Equatable, B: Equatable, C: Equatable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  guard lhs.0 == rhs.0 else { return false }
   return (
    lhs.1, lhs.2
  ) == (
    rhs.1, rhs.2
  )
}
@inlinable 
public func != <A: Equatable, B: Equatable, C: Equatable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  guard lhs.0 == rhs.0 else { return true }
   return (
    lhs.1, lhs.2
  ) != (
    rhs.1, rhs.2
  )
}
@inlinable 
public func < <A: Comparable, B: Comparable, C: Comparable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 < rhs.0 }
   return (
    lhs.1, lhs.2
  ) < (
    rhs.1, rhs.2
  )
}
@inlinable 
public func <= <A: Comparable, B: Comparable, C: Comparable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 <= rhs.0 }
   return (
    lhs.1, lhs.2
  ) <= (
    rhs.1, rhs.2
  )
}
@inlinable 
public func > <A: Comparable, B: Comparable, C: Comparable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 > rhs.0 }
   return (
    lhs.1, lhs.2
  ) > (
    rhs.1, rhs.2
  )
}
@inlinable 
public func >= <A: Comparable, B: Comparable, C: Comparable>(lhs: (A,B,C), rhs: (A,B,C)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 >= rhs.0 }
   return (
    lhs.1, lhs.2
  ) >= (
    rhs.1, rhs.2
  )
}
@inlinable 
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  guard lhs.0 == rhs.0 else { return false }
   return (
    lhs.1, lhs.2, lhs.3
  ) == (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func != <A: Equatable, B: Equatable, C: Equatable, D: Equatable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  guard lhs.0 == rhs.0 else { return true }
   return (
    lhs.1, lhs.2, lhs.3
  ) != (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func < <A: Comparable, B: Comparable, C: Comparable, D: Comparable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 < rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3
  ) < (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func <= <A: Comparable, B: Comparable, C: Comparable, D: Comparable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 <= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3
  ) <= (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func > <A: Comparable, B: Comparable, C: Comparable, D: Comparable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 > rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3
  ) > (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func >= <A: Comparable, B: Comparable, C: Comparable, D: Comparable>(lhs: (A,B,C,D), rhs: (A,B,C,D)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 >= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3
  ) >= (
    rhs.1, rhs.2, rhs.3
  )
}
@inlinable 
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  guard lhs.0 == rhs.0 else { return false }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) == (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func != <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  guard lhs.0 == rhs.0 else { return true }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) != (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func < <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 < rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) < (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func <= <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 <= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) <= (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func > <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 > rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) > (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func >= <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable>(lhs: (A,B,C,D,E), rhs: (A,B,C,D,E)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 >= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4
  ) >= (
    rhs.1, rhs.2, rhs.3, rhs.4
  )
}
@inlinable 
public func == <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  guard lhs.0 == rhs.0 else { return false }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) == (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
@inlinable 
public func != <A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  guard lhs.0 == rhs.0 else { return true }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) != (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
@inlinable 
public func < <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 < rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) < (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
@inlinable 
public func <= <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 <= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) <= (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
@inlinable 
public func > <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 > rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) > (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
@inlinable 
public func >= <A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable>(lhs: (A,B,C,D,E,F), rhs: (A,B,C,D,E,F)) -> Bool {
  if lhs.0 != rhs.0 { return lhs.0 >= rhs.0 }
   return (
    lhs.1, lhs.2, lhs.3, lhs.4, lhs.5
  ) >= (
    rhs.1, rhs.2, rhs.3, rhs.4, rhs.5
  )
}
