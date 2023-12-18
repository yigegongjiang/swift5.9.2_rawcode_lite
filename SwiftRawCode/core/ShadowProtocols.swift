#if _runtime(_ObjC)
import SwiftShims
@objc
internal protocol _ShadowProtocol {}
@objc
internal protocol _NSFastEnumeration: _ShadowProtocol {
  @objc(countByEnumeratingWithState:objects:count:)
  func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int
}
@objc
internal protocol _NSEnumerator: _ShadowProtocol {
  init()
  func nextObject() -> AnyObject?
}
internal typealias _SwiftNSZone = OpaquePointer
@objc
internal protocol _NSCopying: _ShadowProtocol {
  @objc(copyWithZone:)
  func copy(with zone: _SwiftNSZone?) -> AnyObject
}
@unsafe_no_objc_tagged_pointer @objc
internal protocol _NSArrayCore: _NSCopying, _NSFastEnumeration {
  @objc(objectAtIndex:)
  func objectAt(_ index: Int) -> AnyObject
  func getObjects(_: UnsafeMutablePointer<AnyObject>, range: _SwiftNSRange)
  @objc(countByEnumeratingWithState:objects:count:)
  override func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int
  var count: Int { get }
}
@objc
internal protocol _NSDictionaryCore: _NSCopying, _NSFastEnumeration {
  init(
    objects: UnsafePointer<AnyObject?>,
    forKeys: UnsafeRawPointer, count: Int)
  var count: Int { get }
  @objc(objectForKey:)
  func object(forKey aKey: AnyObject) -> AnyObject?
  func keyEnumerator() -> _NSEnumerator
  @objc(copyWithZone:)
  override func copy(with zone: _SwiftNSZone?) -> AnyObject
  @objc(getObjects:andKeys:count:)
  func getObjects(
    _ objects: UnsafeMutablePointer<AnyObject>?,
    andKeys keys: UnsafeMutablePointer<AnyObject>?,
    count: Int
  )
  @objc(countByEnumeratingWithState:objects:count:)
  override func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int
}
@unsafe_no_objc_tagged_pointer @objc
internal protocol _NSDictionary: _NSDictionaryCore {
  override func getObjects(
    _ objects: UnsafeMutablePointer<AnyObject>?,
    andKeys keys: UnsafeMutablePointer<AnyObject>?,
    count: Int)
}
@objc
internal protocol _NSSetCore: _NSCopying, _NSFastEnumeration {
  init(objects: UnsafePointer<AnyObject?>, count: Int)
  var count: Int { get }
  func member(_ object: AnyObject) -> AnyObject?
  func objectEnumerator() -> _NSEnumerator
  @objc(copyWithZone:)
  override func copy(with zone: _SwiftNSZone?) -> AnyObject
  @objc(countByEnumeratingWithState:objects:count:)
  override func countByEnumerating(
    with state: UnsafeMutablePointer<_SwiftNSFastEnumerationState>,
    objects: UnsafeMutablePointer<AnyObject>?, count: Int
  ) -> Int
}
@unsafe_no_objc_tagged_pointer @objc
internal protocol _NSSet: _NSSetCore {
  @objc(getObjects:count:) func getObjects(
    _ buffer: UnsafeMutablePointer<AnyObject>,
    count: Int
  )
  @objc(getObjects:) func getObjects(
    _ buffer: UnsafeMutablePointer<AnyObject>
  )
}
@objc
internal protocol _NSNumber {
  var doubleValue: Double { get }
  var floatValue: Float { get }
  var unsignedLongLongValue: UInt64 { get }
  var longLongValue: Int64 { get }
  var objCType: UnsafePointer<Int8> { get }
}
#else
internal protocol _NSSetCore {}
internal protocol _NSDictionaryCore {}
#endif
