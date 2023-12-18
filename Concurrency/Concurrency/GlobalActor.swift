import Swift
@available(SwiftStdlib 5.1, *)
public protocol GlobalActor {
  associatedtype ActorType: Actor
  static var shared: ActorType { get }
  static var sharedUnownedExecutor: UnownedSerialExecutor { get }
}
@available(SwiftStdlib 5.1, *)
extension GlobalActor {
  public static var sharedUnownedExecutor: UnownedSerialExecutor {
    shared.unownedExecutor
  }
}
