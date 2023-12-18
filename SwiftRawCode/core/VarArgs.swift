public protocol CVarArg {
  var _cVarArgEncoding: [Int] { get }
}
public 
protocol _CVarArgPassedAsDouble: CVarArg {}
public 
protocol _CVarArgAligned: CVarArg {
  var _cVarArgAlignment: Int { get }
}
#if !_runtime(_ObjC)
public protocol _CVarArgObject: CVarArg {
  var _cVarArgObject: CVarArg { get }
}
#endif
#if arch(x86_64)
@usableFromInline
internal let _countGPRegisters = 6
@usableFromInline
internal let _countFPRegisters = 8
@usableFromInline
internal let _fpRegisterWords = 2
@usableFromInline
internal let _registerSaveWords = _countGPRegisters + _countFPRegisters * _fpRegisterWords
#elseif arch(s390x)
@usableFromInline
internal let _countGPRegisters = 16
@usableFromInline
internal let _registerSaveWords = _countGPRegisters
#elseif arch(arm64) && !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(Windows))
@usableFromInline
internal let _countGPRegisters = 8
@usableFromInline
internal let _countFPRegisters = 8
@usableFromInline
internal let _fpRegisterWords = 16 /  MemoryLayout<Int>.size
@usableFromInline
internal let _registerSaveWords = _countGPRegisters + (_countFPRegisters * _fpRegisterWords)
#endif
#if arch(s390x)
@usableFromInline
internal typealias _VAUInt = CUnsignedLongLong
@usableFromInline
internal typealias _VAInt  = Int64
#else
@usableFromInline
internal typealias _VAUInt = CUnsignedInt
@usableFromInline
internal typealias _VAInt  = Int32
#endif
@inlinable 
public func withVaList<R>(_ args: [CVarArg],
  _ body: (CVaListPointer) -> R) -> R {
  let builder = __VaListBuilder()
  for a in args {
    builder.append(a)
  }
  return _withVaList(builder, body)
}
@inlinable 
internal func _withVaList<R>(
  _ builder: __VaListBuilder,
  _ body: (CVaListPointer) -> R
) -> R {
  let result = body(builder.va_list())
  _fixLifetime(builder)
  return result
}
#if _runtime(_ObjC)
@inlinable 
public func getVaList(_ args: [CVarArg]) -> CVaListPointer {
  let builder = __VaListBuilder()
  for a in args {
    builder.append(a)
  }
  Builtin.retain(builder)
  Builtin.autorelease(builder)
  return builder.va_list()
}
#endif
@inlinable 
public func _encodeBitsAsWords<T>(_ x: T) -> [Int] {
  let result = [Int](
    repeating: 0,
    count: (MemoryLayout<T>.size + MemoryLayout<Int>.size - 1) / MemoryLayout<Int>.size)
  _internalInvariant(!result.isEmpty)
  var tmp = x
  _withUnprotectedUnsafeMutablePointer(to: &tmp) {
    _memcpy(dest: UnsafeMutablePointer(result._baseAddressIfContiguous!),
            src: $0,
            size: UInt(MemoryLayout<T>.size))
  }
  return result
}
extension Int: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
extension Bool: CVarArg {
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAInt(self ? 1:0))
  }
}
extension Int64: CVarArg, _CVarArgAligned {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
  @inlinable 
  public var _cVarArgAlignment: Int {
    return MemoryLayout.alignment(ofValue: self)
  }
}
extension Int32: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAInt(self))
  }
}
extension Int16: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAInt(self))
  }
}
extension Int8: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAInt(self))
  }
}
extension UInt: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
extension UInt64: CVarArg, _CVarArgAligned {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
  @inlinable 
  public var _cVarArgAlignment: Int {
    return MemoryLayout.alignment(ofValue: self)
  }
}
extension UInt32: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAUInt(self))
  }
}
extension UInt16: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAUInt(self))
  }
}
extension UInt8: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(_VAUInt(self))
  }
}
extension OpaquePointer: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
extension UnsafePointer: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
extension UnsafeMutablePointer: CVarArg {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
#if _runtime(_ObjC)
extension AutoreleasingUnsafeMutablePointer: CVarArg {
  @inlinable
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
}
#endif
extension Float: _CVarArgPassedAsDouble, _CVarArgAligned {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(Double(self))
  }
  @inlinable 
  public var _cVarArgAlignment: Int {
    return MemoryLayout.alignment(ofValue: Double(self))
  }
}
extension Double: _CVarArgPassedAsDouble, _CVarArgAligned {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
  @inlinable 
  public var _cVarArgAlignment: Int {
    return MemoryLayout.alignment(ofValue: self)
  }
}
#if !(os(Windows) || os(Android)) && (arch(i386) || arch(x86_64))
extension Float80: CVarArg, _CVarArgAligned {
  @inlinable 
  public var _cVarArgEncoding: [Int] {
    return _encodeBitsAsWords(self)
  }
  @inlinable 
  public var _cVarArgAlignment: Int {
    return MemoryLayout.alignment(ofValue: self)
  }
}
#endif
#if (arch(x86_64) && !os(Windows)) || arch(s390x) || (arch(arm64) && !(os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(Windows)))
@usableFromInline 
final internal class __VaListBuilder {
  #if arch(x86_64) || arch(s390x)
  @frozen 
  @usableFromInline
  internal struct Header {
    @usableFromInline 
    internal var gp_offset = CUnsignedInt(0)
    @usableFromInline 
    internal var fp_offset =
      CUnsignedInt(_countGPRegisters * MemoryLayout<Int>.stride)
    @usableFromInline 
    internal var overflow_arg_area: UnsafeMutablePointer<Int>?
    @usableFromInline 
    internal var reg_save_area: UnsafeMutablePointer<Int>?
    @inlinable 
    internal init() {}
  }
  #endif
  @usableFromInline 
  internal var gpRegistersUsed = 0
  @usableFromInline 
  internal var fpRegistersUsed = 0
  #if arch(x86_64) || arch(s390x)
  @usableFromInline 
  final  
  internal var header = Header()
  #endif
  @usableFromInline 
  internal var storage: ContiguousArray<Int>
#if !_runtime(_ObjC)
  @usableFromInline 
  internal var retainer = [CVarArg]()
#endif
  @inlinable 
  internal init() {
    storage = ContiguousArray(repeating: 0, count: _registerSaveWords)
  }
  @inlinable 
  deinit {}
  @inlinable 
  internal func append(_ arg: CVarArg) {
#if !_runtime(_ObjC)
    var arg = arg
    if let obj = arg as? _CVarArgObject {
      arg = obj._cVarArgObject
      retainer.append(arg)
    }
#endif
    var encoded = arg._cVarArgEncoding
#if arch(x86_64) || arch(arm64)
    let isDouble = arg is _CVarArgPassedAsDouble
    if isDouble && fpRegistersUsed < _countFPRegisters {
      #if arch(arm64)
        var startIndex = fpRegistersUsed * _fpRegisterWords
      #else
        var startIndex = _countGPRegisters
             + (fpRegistersUsed * _fpRegisterWords)
      #endif
      for w in encoded {
        storage[startIndex] = w
        startIndex += 1
      }
      fpRegistersUsed += 1
    }
    else if encoded.count == 1
      && !isDouble
      && gpRegistersUsed < _countGPRegisters {
      #if arch(arm64)
        let startIndex = ( _fpRegisterWords * _countFPRegisters) + gpRegistersUsed
      #else
        let startIndex = gpRegistersUsed
      #endif
      storage[startIndex] = encoded[0]
      gpRegistersUsed += 1
    }
    else {
      for w in encoded {
        storage.append(w)
      }
    }
#elseif arch(s390x)
    if gpRegistersUsed < _countGPRegisters {
      for w in encoded {
        storage[gpRegistersUsed] = w
        gpRegistersUsed += 1
      }
    } else {
      for w in encoded {
        storage.append(w)
      }
    }
#endif
  }
  @inlinable 
  internal func va_list() -> CVaListPointer {
    #if arch(x86_64) || arch(s390x)
      header.reg_save_area = storage._baseAddress
      header.overflow_arg_area
        = storage._baseAddress + _registerSaveWords
      return CVaListPointer(
               _fromUnsafeMutablePointer: UnsafeMutableRawPointer(
                 Builtin.addressof(&self.header)))
    #elseif arch(arm64)
      let vr_top = storage._baseAddress + (_fpRegisterWords * _countFPRegisters)
      let gr_top = vr_top + _countGPRegisters
      return CVaListPointer(__stack: gr_top,
                            __gr_top: gr_top,
                            __vr_top: vr_top,
                            __gr_off: -64,
                            __vr_off: -128)
    #endif
  }
}
#else
@usableFromInline 
final internal class __VaListBuilder {
  @inlinable 
  internal init() {}
  @inlinable 
  internal func append(_ arg: CVarArg) {
#if !_runtime(_ObjC)
    var arg = arg
    if let obj = arg as? _CVarArgObject {
      arg = obj._cVarArgObject
      retainer.append(arg)
    }
#endif
#if (arch(arm) && !os(iOS)) || arch(arm64_32) || arch(wasm32)
    if let arg = arg as? _CVarArgAligned {
      let alignmentInWords = arg._cVarArgAlignment / MemoryLayout<Int>.size
      let misalignmentInWords = count % alignmentInWords
      if misalignmentInWords != 0 {
        let paddingInWords = alignmentInWords - misalignmentInWords
        appendWords([Int](repeating: -1, count: paddingInWords))
      }
    }
#endif
    appendWords(arg._cVarArgEncoding)
  }
  @usableFromInline 
  internal func va_list() -> CVaListPointer {
    let emptyAddr = UnsafeMutablePointer<Int>(
      Builtin.addressof(&__VaListBuilder.alignedStorageForEmptyVaLists))
    return CVaListPointer(_fromUnsafeMutablePointer: storage ?? emptyAddr)
  }
  @inlinable 
  internal func appendWords(_ words: [Int]) {
    let newCount = count + words.count
    if newCount > allocated {
      let oldAllocated = allocated
      let oldStorage = storage
      let oldCount = count
      allocated = max(newCount, allocated * 2)
      let newStorage = allocStorage(wordCount: allocated)
      storage = newStorage
      if let allocatedOldStorage = oldStorage {
        newStorage.moveInitialize(from: allocatedOldStorage, count: oldCount)
        deallocStorage(wordCount: oldAllocated, storage: allocatedOldStorage)
      }
    }
    let allocatedStorage = storage!
    for word in words {
      allocatedStorage[count] = word
      count += 1
    }
  }
  @inlinable 
  internal func rawSizeAndAlignment(
    _ wordCount: Int
  ) -> (Builtin.Word, Builtin.Word) {
    return ((wordCount * MemoryLayout<Int>.stride)._builtinWordValue,
      requiredAlignmentInBytes._builtinWordValue)
  }
  @inlinable 
  internal func allocStorage(wordCount: Int) -> UnsafeMutablePointer<Int> {
    let (rawSize, rawAlignment) = rawSizeAndAlignment(wordCount)
    let rawStorage = Builtin.allocRaw(rawSize, rawAlignment)
    return UnsafeMutablePointer<Int>(rawStorage)
  }
  @usableFromInline 
  internal func deallocStorage(
    wordCount: Int,
    storage: UnsafeMutablePointer<Int>
  ) {
    let (rawSize, rawAlignment) = rawSizeAndAlignment(wordCount)
    Builtin.deallocRaw(storage._rawValue, rawSize, rawAlignment)
  }
  @inlinable 
  deinit {
    if let allocatedStorage = storage {
      deallocStorage(wordCount: allocated, storage: allocatedStorage)
    }
  }
  @usableFromInline 
  internal let requiredAlignmentInBytes = MemoryLayout<Double>.alignment
  @usableFromInline 
  internal var count = 0
  @usableFromInline 
  internal var allocated = 0
  @usableFromInline 
  internal var storage: UnsafeMutablePointer<Int>?
#if !_runtime(_ObjC)
  @usableFromInline 
  internal var retainer = [CVarArg]()
#endif
  internal static var alignedStorageForEmptyVaLists: Double = 0
}
#endif
