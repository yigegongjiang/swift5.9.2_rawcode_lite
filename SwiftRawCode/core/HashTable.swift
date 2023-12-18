@usableFromInline
internal protocol _HashTableDelegate {
  func hashValue(at bucket: _HashTable.Bucket) -> Int
  func moveEntry(from source: _HashTable.Bucket, to target: _HashTable.Bucket)
}
@usableFromInline
@frozen
internal struct _HashTable {
  @usableFromInline
  internal typealias Word = _UnsafeBitset.Word
  @usableFromInline
  internal var words: UnsafeMutablePointer<Word>
  @usableFromInline
  internal let bucketMask: Int
  @inlinable
  @inline(__always)
  internal init(words: UnsafeMutablePointer<Word>, bucketCount: Int) {
    _internalInvariant(bucketCount > 0 && bucketCount & (bucketCount - 1) == 0,
      "bucketCount must be a power of two")
    self.words = words
    self.bucketMask = bucketCount &- 1
  }
  @inlinable
  internal var bucketCount: Int {
    @inline(__always) get {
      return _assumeNonNegative(bucketMask &+ 1)
    }
  }
  @inlinable
  internal var wordCount: Int {
    @inline(__always) get {
      return _UnsafeBitset.wordCount(forCapacity: bucketCount)
    }
  }
  internal var bitset: _UnsafeBitset {
    _UnsafeBitset(words: words, wordCount: wordCount)
  }
}
extension _HashTable {
  private static var maxLoadFactor: Double {
    @inline(__always) get { return 3 / 4 }
  }
  internal static func capacity(forScale scale: Int8) -> Int {
    let bucketCount = (1 as Int) &<< scale
    return Int(Double(bucketCount) * maxLoadFactor)
  }
  internal static func scale(forCapacity capacity: Int) -> Int8 {
    let capacity = Swift.max(capacity, 1)
    let minimumEntries = Swift.max(
      Int((Double(capacity) / maxLoadFactor).rounded(.up)),
      capacity + 1)
    let exponent = (Swift.max(minimumEntries, 2) - 1)._binaryLogarithm() + 1
    _internalInvariant(exponent >= 0 && exponent < Int.bitWidth)
    let scale = Int8(truncatingIfNeeded: exponent)
    _internalInvariant(self.capacity(forScale: scale) >= capacity)
    return scale
  }
  internal static func age(for cocoa: AnyObject) -> Int32 {
    let hash = ObjectIdentifier(cocoa).hashValue
    return Int32(truncatingIfNeeded: hash)
  }
  internal static func hashSeed(
    for object: AnyObject,
    scale: Int8
  ) -> Int {
    if Hasher._isDeterministic {
      return Int(scale)
    }
    return unsafeBitCast(object, to: Int.self)
  }
}
extension _HashTable {
  @frozen
  @usableFromInline
  internal struct Bucket {
    @usableFromInline
    internal var offset: Int
    @inlinable
    @inline(__always)
    internal init(offset: Int) {
      self.offset = offset
    }
    @inlinable
    @inline(__always)
    internal init(word: Int, bit: Int) {
      self.offset = _UnsafeBitset.join(word: word, bit: bit)
    }
    @inlinable
    internal var word: Int {
      @inline(__always) get {
        return _UnsafeBitset.word(for: offset)
      }
    }
    @inlinable
    internal var bit: Int {
      @inline(__always) get {
        return _UnsafeBitset.bit(for: offset)
      }
    }
  }
}
extension _HashTable.Bucket: Equatable {
  @inlinable
  @inline(__always)
  internal
  static func == (lhs: _HashTable.Bucket, rhs: _HashTable.Bucket) -> Bool {
    return lhs.offset == rhs.offset
  }
}
extension _HashTable.Bucket: Comparable {
  @inlinable
  @inline(__always)
  internal
  static func < (lhs: _HashTable.Bucket, rhs: _HashTable.Bucket) -> Bool {
    return lhs.offset < rhs.offset
  }
}
extension _HashTable {
  @usableFromInline
  @frozen
  internal struct Index {
    @usableFromInline
    let bucket: Bucket
    @usableFromInline
    let age: Int32
    @inlinable
    @inline(__always)
    internal init(bucket: Bucket, age: Int32) {
      self.bucket = bucket
      self.age = age
    }
  }
}
extension _HashTable.Index: Equatable {
  @inlinable
  @inline(__always)
  internal static func ==(
    lhs: _HashTable.Index,
    rhs: _HashTable.Index
  ) -> Bool {
    _precondition(lhs.age == rhs.age,
      "Can't compare indices belonging to different collections")
    return lhs.bucket == rhs.bucket
  }
}
extension _HashTable.Index: Comparable {
  @inlinable
  @inline(__always)
  internal static func <(
    lhs: _HashTable.Index,
    rhs: _HashTable.Index
  ) -> Bool {
    _precondition(lhs.age == rhs.age,
      "Can't compare indices belonging to different collections")
    return lhs.bucket < rhs.bucket
  }
}
extension _HashTable: Sequence {
  @usableFromInline
  @frozen
  internal struct Iterator: IteratorProtocol {
    @usableFromInline
    let hashTable: _HashTable
    @usableFromInline
    var wordIndex: Int
    @usableFromInline
    var word: Word
    @inlinable
    @inline(__always)
    init(_ hashTable: _HashTable) {
      self.hashTable = hashTable
      self.wordIndex = 0
      self.word = hashTable.words[0]
      if hashTable.bucketCount < Word.capacity {
        self.word = self.word.intersecting(elementsBelow: hashTable.bucketCount)
      }
    }
    @inlinable
    @inline(__always)
    internal mutating func next() -> Bucket? {
      if let bit = word.next() {
        return Bucket(word: wordIndex, bit: bit)
      }
      while wordIndex + 1 < hashTable.wordCount {
        wordIndex += 1
        word = hashTable.words[wordIndex]
        if let bit = word.next() {
          return Bucket(word: wordIndex, bit: bit)
        }
      }
      return nil
    }
  }
  @inlinable
  @inline(__always)
  internal func makeIterator() -> Iterator {
    return Iterator(self)
  }
}
extension _HashTable {
  @inlinable
  @inline(__always)
  internal func isValid(_ bucket: Bucket) -> Bool {
    return bucket.offset >= 0 && bucket.offset < bucketCount
  }
  @inlinable
  @inline(__always)
  internal func _isOccupied(_ bucket: Bucket) -> Bool {
    _internalInvariant(isValid(bucket))
    return words[bucket.word].uncheckedContains(bucket.bit)
  }
  @inlinable
  @inline(__always)
  internal func isOccupied(_ bucket: Bucket) -> Bool {
    return isValid(bucket) && _isOccupied(bucket)
  }
  @inlinable
  @inline(__always)
  internal func checkOccupied(_ bucket: Bucket) {
    _precondition(isOccupied(bucket),
      "Attempting to access Collection elements using an invalid Index")
  }
  @inlinable
  @inline(__always)
  internal func _firstOccupiedBucket(fromWord word: Int) -> Bucket {
    _internalInvariant(word >= 0 && word <= wordCount)
    var word = word
    while word < wordCount {
      if let bit = words[word].minimum {
        return Bucket(word: word, bit: bit)
      }
      word += 1
    }
    return endBucket
  }
  @inlinable
  internal func occupiedBucket(after bucket: Bucket) -> Bucket {
    _internalInvariant(isValid(bucket))
    let word = bucket.word
    if let bit = words[word].intersecting(elementsAbove: bucket.bit).minimum {
      return Bucket(word: word, bit: bit)
    }
    return _firstOccupiedBucket(fromWord: word + 1)
  }
  @inlinable
  internal var startBucket: Bucket {
    return _firstOccupiedBucket(fromWord: 0)
  }
  @inlinable
  internal var endBucket: Bucket {
    @inline(__always)
    get {
      return Bucket(offset: bucketCount)
    }
  }
}
extension _HashTable {
  @inlinable
  @inline(__always)
  internal func idealBucket(forHashValue hashValue: Int) -> Bucket {
    return Bucket(offset: hashValue & bucketMask)
  }
  @inlinable
  @inline(__always)
  internal func bucket(wrappedAfter bucket: Bucket) -> Bucket {
    return Bucket(offset: (bucket.offset &+ 1) & bucketMask)
  }
}
extension _HashTable {
  @inlinable
  internal func previousHole(before bucket: Bucket) -> Bucket {
    _internalInvariant(isValid(bucket))
    var word = bucket.word
    if let bit =
      words[word]
        .complement
        .intersecting(elementsBelow: bucket.bit)
        .maximum {
      return Bucket(word: word, bit: bit)
    }
    var wrap = false
    while true {
      word -= 1
      if word < 0 {
        _precondition(!wrap, "Hash table has no holes")
        wrap = true
        word = wordCount - 1
      }
      if let bit = words[word].complement.maximum {
        return Bucket(word: word, bit: bit)
      }
    }
  }
  @inlinable
  internal func nextHole(atOrAfter bucket: Bucket) -> Bucket {
    _internalInvariant(isValid(bucket))
    var word = bucket.word
    if let bit =
      words[word]
        .complement
        .subtracting(elementsBelow: bucket.bit)
        .minimum {
      return Bucket(word: word, bit: bit)
    }
    var wrap = false
    while true {
      word &+= 1
      if word == wordCount {
        _precondition(!wrap, "Hash table has no holes")
        wrap = true
        word = 0
      }
      if let bit = words[word].complement.minimum {
        return Bucket(word: word, bit: bit)
      }
    }
  }
}
extension _HashTable {
  @inlinable
  @inline(__always)
  internal func copyContents(of other: _HashTable) {
    _internalInvariant(bucketCount == other.bucketCount)
    self.words.update(from: other.words, count: wordCount)
  }
  @inlinable
  @inline(__always)
  internal func insertNew(hashValue: Int) -> Bucket {
    let hole = nextHole(atOrAfter: idealBucket(forHashValue: hashValue))
    insert(hole)
    return hole
  }
  @inlinable
  @inline(__always)
  internal func insert(_ bucket: Bucket) {
    _internalInvariant(!isOccupied(bucket))
    words[bucket.word].uncheckedInsert(bucket.bit)
  }
  @inlinable
  @inline(__always)
  internal func clear() {
    if bucketCount < Word.capacity {
      words[0] = Word.allBits.subtracting(elementsBelow: bucketCount)
    } else {
      words.update(repeating: .empty, count: wordCount)
    }
  }
  @inline(__always)
  @inlinable
  internal func delete<D: _HashTableDelegate>(
    at bucket: Bucket,
    with delegate: D
  ) {
    _internalInvariant(isOccupied(bucket))
    var hole = bucket
    var candidate = self.bucket(wrappedAfter: hole)
    guard _isOccupied(candidate) else {
      words[hole.word].uncheckedRemove(hole.bit)
      return
    }
    let start = self.bucket(wrappedAfter: previousHole(before: bucket))
    while _isOccupied(candidate) {
      let candidateHash = delegate.hashValue(at: candidate)
      let ideal = idealBucket(forHashValue: candidateHash)
      let c0 = ideal >= start
      let c1 = ideal <= hole
      if start <= hole ? (c0 && c1) : (c0 || c1) {
        delegate.moveEntry(from: candidate, to: hole)
        hole = candidate
      }
      candidate = self.bucket(wrappedAfter: candidate)
    }
    words[hole.word].uncheckedRemove(hole.bit)
  }
}
