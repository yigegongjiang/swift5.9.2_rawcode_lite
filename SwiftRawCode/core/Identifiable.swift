@available(SwiftStdlib 5.1, *)
public protocol Identifiable<ID> {
  associatedtype ID: Hashable
  var id: ID { get }
}
@available(SwiftStdlib 5.1, *)
extension Identifiable where Self: AnyObject {
  public var id: ObjectIdentifier {
    return ObjectIdentifier(self)
  }
}
