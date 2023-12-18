@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "BidirectionalCollection")
public typealias BidirectionalIndexable = BidirectionalCollection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "Collection")
public typealias IndexableBase = Collection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "Collection")
public typealias Indexable = Collection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "MutableCollection")
public typealias MutableIndexable = MutableCollection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "RandomAccessCollection")
public typealias RandomAccessIndexable = RandomAccessCollection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "RangeReplaceableIndexable")
public typealias RangeReplaceableIndexable = RangeReplaceableCollection
@available(swift, deprecated: 4.2, renamed: "EnumeratedSequence.Iterator")
public typealias EnumeratedIterator<T: Sequence> = EnumeratedSequence<T>.Iterator
@available(swift,deprecated: 4.2, obsoleted: 5.0, renamed: "CollectionOfOne.Iterator")
public typealias IteratorOverOne<T> = CollectionOfOne<T>.Iterator
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "EmptyCollection.Iterator")
public typealias EmptyIterator<T> = EmptyCollection<T>.Iterator
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyFilterSequence.Iterator")
public typealias LazyFilterIterator<T: Sequence> = LazyFilterSequence<T>.Iterator
@available(swift, deprecated: 3.1, obsoleted: 5.0, message: "Use Base.Index")
public typealias LazyFilterIndex<Base: Collection> = Base.Index
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyDropWhileSequence.Iterator")
public typealias LazyDropWhileIterator<T> = LazyDropWhileSequence<T>.Iterator where T: Sequence
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyDropWhileCollection.Index")
public typealias LazyDropWhileIndex<T> = LazyDropWhileCollection<T>.Index where T: Collection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyDropWhileCollection")
public typealias LazyDropWhileBidirectionalCollection<T> = LazyDropWhileCollection<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyFilterCollection")
public typealias LazyFilterBidirectionalCollection<T> = LazyFilterCollection<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyMapSequence.Iterator")
public typealias LazyMapIterator<T, E> = LazyMapSequence<T, E>.Iterator where T: Sequence
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyMapCollection")
public typealias LazyMapBidirectionalCollection<T, E> = LazyMapCollection<T, E> where T: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyMapCollection")
public typealias LazyMapRandomAccessCollection<T, E> = LazyMapCollection<T, E> where T: RandomAccessCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyCollection")
public typealias LazyBidirectionalCollection<T> = LazyCollection<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyCollection")
public typealias LazyRandomAccessCollection<T> = LazyCollection<T> where T: RandomAccessCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "FlattenCollection.Index")
public typealias FlattenCollectionIndex<T> = FlattenCollection<T>.Index where T: Collection, T.Element: Collection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "FlattenCollection.Index")
public typealias FlattenBidirectionalCollectionIndex<T> = FlattenCollection<T>.Index where T: BidirectionalCollection, T.Element: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "FlattenCollection")
public typealias FlattenBidirectionalCollection<T> = FlattenCollection<T> where T: BidirectionalCollection, T.Element: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "JoinedSequence.Iterator")
public typealias JoinedIterator<T: Sequence> = JoinedSequence<T>.Iterator where T.Element: Sequence
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "Zip2Sequence.Iterator")
public typealias Zip2Iterator<T, U> = Zip2Sequence<T, U>.Iterator where T: Sequence, U: Sequence
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyPrefixWhileSequence.Iterator")
public typealias LazyPrefixWhileIterator<T> = LazyPrefixWhileSequence<T>.Iterator where T: Sequence
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyPrefixWhileCollection.Index")
public typealias LazyPrefixWhileIndex<T> = LazyPrefixWhileCollection<T>.Index where T: Collection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "LazyPrefixWhileCollection")
public typealias LazyPrefixWhileBidirectionalCollection<T> = LazyPrefixWhileCollection<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "ReversedCollection")
public typealias ReversedRandomAccessCollection<T: RandomAccessCollection> = ReversedCollection<T>
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "ReversedCollection.Index")
public typealias ReversedIndex<T: BidirectionalCollection> = ReversedCollection<T>.Index
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias BidirectionalSlice<T> = Slice<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias RandomAccessSlice<T> = Slice<T> where T: RandomAccessCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias RangeReplaceableSlice<T> = Slice<T> where T: RangeReplaceableCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias RangeReplaceableBidirectionalSlice<T> = Slice<T> where T: RangeReplaceableCollection & BidirectionalCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias RangeReplaceableRandomAccessSlice<T> = Slice<T> where T: RangeReplaceableCollection & RandomAccessCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableSlice<T> = Slice<T> where T: MutableCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableBidirectionalSlice<T> = Slice<T> where T: MutableCollection & BidirectionalCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableRandomAccessSlice<T> = Slice<T> where T: MutableCollection & RandomAccessCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableRangeReplaceableSlice<T> = Slice<T> where T: MutableCollection & RangeReplaceableCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableRangeReplaceableBidirectionalSlice<T> = Slice<T> where T: MutableCollection & RangeReplaceableCollection & BidirectionalCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "Slice")
public typealias MutableRangeReplaceableRandomAccessSlice<T> = Slice<T> where T: MutableCollection & RangeReplaceableCollection & RandomAccessCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "DefaultIndices")
public typealias DefaultBidirectionalIndices<T> = DefaultIndices<T> where T: BidirectionalCollection
@available(swift, deprecated: 4.0, obsoleted: 5.0, renamed: "DefaultIndices")
public typealias DefaultRandomAccessIndices<T> = DefaultIndices<T> where T: RandomAccessCollection
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByNilLiteral")
public typealias NilLiteralConvertible = ExpressibleByNilLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinIntegerLiteral")
public typealias _BuiltinIntegerLiteralConvertible = _ExpressibleByBuiltinIntegerLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByIntegerLiteral")
public typealias IntegerLiteralConvertible = ExpressibleByIntegerLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinFloatLiteral")
public typealias _BuiltinFloatLiteralConvertible = _ExpressibleByBuiltinFloatLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByFloatLiteral")
public typealias FloatLiteralConvertible = ExpressibleByFloatLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinBooleanLiteral")
public typealias _BuiltinBooleanLiteralConvertible = _ExpressibleByBuiltinBooleanLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByBooleanLiteral")
public typealias BooleanLiteralConvertible = ExpressibleByBooleanLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinUnicodeScalarLiteral")
public typealias _BuiltinUnicodeScalarLiteralConvertible = _ExpressibleByBuiltinUnicodeScalarLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByUnicodeScalarLiteral")
public typealias UnicodeScalarLiteralConvertible = ExpressibleByUnicodeScalarLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinExtendedGraphemeClusterLiteral")
public typealias _BuiltinExtendedGraphemeClusterLiteralConvertible = _ExpressibleByBuiltinExtendedGraphemeClusterLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByExtendedGraphemeClusterLiteral")
public typealias ExtendedGraphemeClusterLiteralConvertible = ExpressibleByExtendedGraphemeClusterLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByBuiltinStringLiteral")
public typealias _BuiltinStringLiteralConvertible = _ExpressibleByBuiltinStringLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByStringLiteral")
public typealias StringLiteralConvertible = ExpressibleByStringLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByArrayLiteral")
public typealias ArrayLiteralConvertible = ExpressibleByArrayLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByDictionaryLiteral")
public typealias DictionaryLiteralConvertible = ExpressibleByDictionaryLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "ExpressibleByStringInterpolation")
public typealias StringInterpolationConvertible = ExpressibleByStringInterpolation
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByColorLiteral")
public typealias _ColorLiteralConvertible = _ExpressibleByColorLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByImageLiteral")
public typealias _ImageLiteralConvertible = _ExpressibleByImageLiteral
@available(swift, deprecated: 3.0, obsoleted: 5.0, renamed: "_ExpressibleByFileReferenceLiteral")
public typealias _FileReferenceLiteralConvertible = _ExpressibleByFileReferenceLiteral
@available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "ClosedRange.Index")
public typealias ClosedRangeIndex<T> = ClosedRange<T>.Index where T: Strideable, T.Stride: SignedInteger
@available(*, unavailable, renamed: "Optional")
public typealias ImplicitlyUnwrappedOptional<Wrapped> = Optional<Wrapped>
extension Range where Bound: Strideable, Bound.Stride: SignedInteger {
  @available(swift, deprecated: 4.2, obsoleted: 5.0, message: "CountableRange is now a Range. No need to convert any more.")
  public init(_ other: Range<Bound>) {
    self = other
  }  
}
extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
  @available(swift, deprecated: 4.2, obsoleted: 5.0, message: "CountableClosedRange is now a ClosedRange. No need to convert any more.")
  public init(_ other: ClosedRange<Bound>) {
    self = other
  }  
}
@available(swift, deprecated: 5.0, renamed: "KeyValuePairs")
public typealias DictionaryLiteral<Key, Value> = KeyValuePairs<Key, Value>
extension LazySequenceProtocol {
  @available(swift, deprecated: 4.1, renamed: "compactMap(_:)", message: "Please use compactMap(_:) for the case where closure returns an optional value")
  public func flatMap<ElementOfResult>(
    _ transform: @escaping (Elements.Element) -> ElementOfResult?
  ) -> LazyMapSequence<
    LazyFilterSequence<
      LazyMapSequence<Elements, ElementOfResult?>>,
    ElementOfResult
  > {
    return self.compactMap(transform)
  }
}
extension String {
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please use String directly")
  public typealias CharacterView = String
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please use String directly")
  public var characters: String {
    get { return self }
    set { self = newValue }
  }
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please mutate the String directly")
  public mutating func withMutableCharacters<R>(
    _ body: (inout String) -> R
  ) -> R {
    return body(&self)
  }
}
extension String.UnicodeScalarView: _CustomPlaygroundQuickLookable {
  @available(swift, deprecated: 4.2, message: "UnicodeScalarView.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(description)
  }
}
public typealias UTF8 = Unicode.UTF8
public typealias UTF16 = Unicode.UTF16
public typealias UTF32 = Unicode.UTF32
public typealias UnicodeScalar = Unicode.Scalar
extension String.UTF16View: _CustomPlaygroundQuickLookable {
  @available(swift, deprecated: 4.2, message: "UTF16View.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(description)
  }
}
extension String.UTF8View: _CustomPlaygroundQuickLookable {
  @available(swift, deprecated: 4.2, message: "UTF8View.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(description)
  }
}
extension Substring {
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please use Substring directly")
  public typealias CharacterView = Substring
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please use Substring directly")
  public var characters: Substring {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  @available(swift, deprecated: 3.2, obsoleted: 5.0, message: "Please mutate the Substring directly")
  public mutating func withMutableCharacters<R>(
    _ body: (inout Substring) -> R
  ) -> R {
    return body(&self)
  }
  private func _boundsCheck(_ range: Range<Index>) {
    _precondition(range.lowerBound >= startIndex,
      "String index range is out of bounds")
    _precondition(range.upperBound <= endIndex,
      "String index range is out of bounds")
  }
}
#if SWIFT_ENABLE_REFLECTION
extension Substring: _CustomPlaygroundQuickLookable {
  @available(swift, deprecated: 4.2, message: "Substring.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return String(self).customPlaygroundQuickLook
  }
}
#endif
extension Collection {
  @available(swift, deprecated: 4.0, obsoleted: 5.0, message: "all index distances are now of type Int")
  public func index<T: BinaryInteger>(_ i: Index, offsetBy n: T) -> Index {
    return index(i, offsetBy: Int(n))
  }
  @available(swift, deprecated: 4.0, obsoleted: 5.0, message: "all index distances are now of type Int")
  public func formIndex<T: BinaryInteger>(_ i: inout Index, offsetBy n: T) {
    return formIndex(&i, offsetBy: Int(n))
  }
  @available(swift, deprecated: 4.0, obsoleted: 5.0, message: "all index distances are now of type Int")
  public func index<T: BinaryInteger>(_ i: Index, offsetBy n: T, limitedBy limit: Index) -> Index? {
    return index(i, offsetBy: Int(n), limitedBy: limit)
  }
  @available(swift, deprecated: 4.0, obsoleted: 5.0, message: "all index distances are now of type Int")
  public func formIndex<T: BinaryInteger>(_ i: inout Index, offsetBy n: T, limitedBy limit: Index) -> Bool {
    return formIndex(&i, offsetBy: Int(n), limitedBy: limit)
  }
  @available(swift, deprecated: 4.0, obsoleted: 5.0, message: "all index distances are now of type Int")
  public func distance<T: BinaryInteger>(from start: Index, to end: Index) -> T {
    return numericCast(distance(from: start, to: end) as Int)
  }
}
extension UnsafeMutablePointer {
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "initialize(repeating:count:)")
  public func initialize(to newValue: Pointee, count: Int = 1) { 
    initialize(repeating: newValue, count: count)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, message: "the default argument to deinitialize(count:) has been removed, please specify the count explicitly") 
  @discardableResult
  public func deinitialize() -> UnsafeMutableRawPointer {
    return deinitialize(count: 1)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, message: "Swift currently only supports freeing entire heap blocks, use deallocate() instead")
  public func deallocate(capacity _: Int) { 
    self.deallocate()
  }
  @available(swift, deprecated: 4.2, obsoleted: 5.0, message: "it will be removed in Swift 5.0.  Please use 'UnsafeMutableBufferPointer.initialize(from:)' instead")
  public func initialize<C: Collection>(from source: C)
    where C.Element == Pointee {
    let buf = UnsafeMutableBufferPointer(start: self, count: numericCast(source.count))
    var (remainders,writtenUpTo) = source._copyContents(initializing: buf)
    _precondition(remainders.next() == nil, "rhs underreported its count")
    _precondition(writtenUpTo == buf.endIndex, "rhs overreported its count")
  }
}
extension UnsafeMutableRawPointer {
  @available(*, unavailable, renamed: "init(mutating:)")
  @available(*, unavailable, renamed: "init(mutating:)")
  @available(*, unavailable, renamed: "init(mutating:)")
  @available(*, unavailable, renamed: "init(mutating:)")
}
extension UnsafeRawPointer: _CustomPlaygroundQuickLookable {
  internal var summary: String {
    let ptrValue = UInt64(
      bitPattern: Int64(Int(Builtin.ptrtoint_Word(_rawValue))))
    return ptrValue == 0
    ? "UnsafeRawPointer(nil)"
    : "UnsafeRawPointer(0x\(_uint64ToString(ptrValue, radix:16, uppercase:true)))"
  }
  @available(swift, deprecated: 4.2, message: "UnsafeRawPointer.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(summary)
  }
}
extension UnsafeMutableRawPointer: _CustomPlaygroundQuickLookable {
  private var summary: String {
    let ptrValue = UInt64(
      bitPattern: Int64(Int(Builtin.ptrtoint_Word(_rawValue))))
    return ptrValue == 0
    ? "UnsafeMutableRawPointer(nil)"
    : "UnsafeMutableRawPointer(0x\(_uint64ToString(ptrValue, radix:16, uppercase:true)))"
  }
  @available(swift, deprecated: 4.2, message: "UnsafeMutableRawPointer.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: _PlaygroundQuickLook {
    return .text(summary)
  }
}
extension UnsafePointer: _CustomPlaygroundQuickLookable {
  private var summary: String {
    let ptrValue = UInt64(bitPattern: Int64(Int(Builtin.ptrtoint_Word(_rawValue))))
    return ptrValue == 0 
    ? "UnsafePointer(nil)" 
    : "UnsafePointer(0x\(_uint64ToString(ptrValue, radix:16, uppercase:true)))"
  }
  @available(swift, deprecated: 4.2, message: "UnsafePointer.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: PlaygroundQuickLook {
    return .text(summary)
  }
}
extension UnsafeMutablePointer: _CustomPlaygroundQuickLookable {
  private var summary: String {
    let ptrValue = UInt64(bitPattern: Int64(Int(Builtin.ptrtoint_Word(_rawValue))))
    return ptrValue == 0 
    ? "UnsafeMutablePointer(nil)" 
    : "UnsafeMutablePointer(0x\(_uint64ToString(ptrValue, radix:16, uppercase:true)))"
  }
  @available(swift, deprecated: 4.2, message: "UnsafeMutablePointer.customPlaygroundQuickLook will be removed in a future Swift version")
  public var customPlaygroundQuickLook: PlaygroundQuickLook {
    return .text(summary)
  }
}
@available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "UnsafeBufferPointer.Iterator")
public typealias UnsafeBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
@available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "UnsafeRawBufferPointer.Iterator")
public typealias UnsafeRawBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
@available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "UnsafeRawBufferPointer.Iterator")
public typealias UnsafeMutableRawBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
extension UnsafeMutableRawPointer {
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "allocate(byteCount:alignment:)")
  public static func allocate(
    bytes size: Int, alignedTo alignment: Int
  ) -> UnsafeMutableRawPointer {
    return UnsafeMutableRawPointer.allocate(byteCount: size, alignment: alignment)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "deallocate()", message: "Swift currently only supports freeing entire heap blocks, use deallocate() instead")
  public func deallocate(bytes _: Int, alignedTo _: Int) { 
    self.deallocate()
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "copyMemory(from:byteCount:)")
  public func copyBytes(from source: UnsafeRawPointer, count: Int) {
    copyMemory(from: source, byteCount: count)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "initializeMemory(as:repeating:count:)")
  @discardableResult
  public func initializeMemory<T>(
    as type: T.Type, at offset: Int = 0, count: Int = 1, to repeatedValue: T
  ) -> UnsafeMutablePointer<T> { 
    return (self + offset * MemoryLayout<T>.stride).initializeMemory(
      as: type, repeating: repeatedValue, count: count)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, message: "it will be removed in Swift 5.0.  Please use 'UnsafeMutableRawBufferPointer.initialize(from:)' instead")
  @discardableResult
  public func initializeMemory<C: Collection>(
    as type: C.Element.Type, from source: C
  ) -> UnsafeMutablePointer<C.Element> {
    var ptr = self
    for element in source {
      ptr.initializeMemory(as: C.Element.self, repeating: element, count: 1)
      ptr += MemoryLayout<C.Element>.stride
    }
    return UnsafeMutablePointer(_rawValue)
  }
}
extension UnsafeMutableRawBufferPointer {
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "allocate(byteCount:alignment:)")
  public static func allocate(count: Int) -> UnsafeMutableRawBufferPointer { 
    return UnsafeMutableRawBufferPointer.allocate(
      byteCount: count, alignment: MemoryLayout<UInt>.alignment)
  }
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "copyMemory(from:)")
  public func copyBytes(from source: UnsafeRawBufferPointer) {
    copyMemory(from: source)
  }
}
extension Sequence {
  @available(swift, deprecated: 4.1, renamed: "compactMap(_:)",
    message: "Please use compactMap(_:) for the case where closure returns an optional value")
  public func flatMap<ElementOfResult>(
    _ transform: (Element) throws -> ElementOfResult?
  ) rethrows -> [ElementOfResult] {
    return try _compactMap(transform)
  }
}
extension Collection {
  @available(swift, deprecated: 4.1, obsoleted: 5.0, renamed: "compactMap(_:)",
    message: "Please use compactMap(_:) for the case where closure returns an optional value")
  public func flatMap(
    _ transform: (Element) throws -> String?
  ) rethrows -> [String] {
    return try _compactMap(transform)
  }
}
extension Collection {
  @available(swift, deprecated: 5.0, renamed: "firstIndex(where:)")
  @inlinable
  public func index(
    where _predicate: (Element) throws -> Bool
  ) rethrows -> Index? {
    return try firstIndex(where: _predicate)
  }
}
extension Collection where Element: Equatable {
  @available(swift, deprecated: 5.0, renamed: "firstIndex(of:)")
  @inlinable
  public func index(of element: Element) -> Index? {
    return firstIndex(of: element)
  }
}
extension Zip2Sequence {
  @available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "Sequence1.Iterator")
  public typealias Stream1 = Sequence1.Iterator
  @available(swift, deprecated: 4.2, obsoleted: 5.0, renamed: "Sequence2.Iterator")
  public typealias Stream2 = Sequence2.Iterator
}
@available(swift, deprecated: 4.2, message: "PlaygroundQuickLook will be removed in a future Swift version. For customizing how types are presented in playgrounds, use CustomPlaygroundDisplayConvertible instead.")
public typealias PlaygroundQuickLook = _PlaygroundQuickLook
@frozen 
public enum _PlaygroundQuickLook {
  case text(String)
  case int(Int64)
  case uInt(UInt64)
  case float(Float32)
  case double(Float64)
  case image(Any)
  case sound(Any)
  case color(Any)
  case bezierPath(Any)
  case attributedString(Any)
  case rectangle(Float64, Float64, Float64, Float64)
  case point(Float64, Float64)
  case size(Float64, Float64)
  case bool(Bool)
  case range(Int64, Int64)
  case view(Any)
  case sprite(Any)
  case url(String)
  case _raw([UInt8], String)
}
#if SWIFT_ENABLE_REFLECTION
extension _PlaygroundQuickLook {
  @available(swift, deprecated: 4.2, obsoleted: 5.0, message: "PlaygroundQuickLook will be removed in a future Swift version.")
  public init(reflecting subject: Any) {
    if let customized = subject as? _CustomPlaygroundQuickLookable {
      self = customized.customPlaygroundQuickLook
    }
    else if let customized = subject as? __DefaultCustomPlaygroundQuickLookable {
      self = customized._defaultCustomPlaygroundQuickLook
    }
    else {
      if let q = Mirror.quickLookObject(subject) {
        self = q
      }
      else {
        self = .text(String(reflecting: subject))
      }
    }
  }
}
#endif
@available(swift, deprecated: 4.2, obsoleted: 5.0, message: "CustomPlaygroundQuickLookable will be removed in a future Swift version. For customizing how types are presented in playgrounds, use CustomPlaygroundDisplayConvertible instead.")
public typealias CustomPlaygroundQuickLookable = _CustomPlaygroundQuickLookable
public protocol _CustomPlaygroundQuickLookable {
  var customPlaygroundQuickLook: _PlaygroundQuickLook { get }
}
@available(swift, deprecated: 4.2, obsoleted: 5.0, message: "_DefaultCustomPlaygroundQuickLookable will be removed in a future Swift version. For customizing how types are presented in playgrounds, use CustomPlaygroundDisplayConvertible instead.")
public typealias _DefaultCustomPlaygroundQuickLookable = __DefaultCustomPlaygroundQuickLookable
public protocol __DefaultCustomPlaygroundQuickLookable {
  var _defaultCustomPlaygroundQuickLook: _PlaygroundQuickLook { get }
}
extension String {
  @available(*, deprecated, message: "All index distances are now of type Int")
  public typealias IndexDistance = Int
}
