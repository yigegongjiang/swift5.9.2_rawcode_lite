import Swift
@available(SwiftStdlib 5.1, *)
public protocol AnyActor: AnyObject, Sendable {}
@available(SwiftStdlib 5.1, *)
public protocol Actor: AnyActor {
  nonisolated var unownedExecutor: UnownedSerialExecutor { get }
}
@available(SwiftStdlib 5.1, *)
public func _defaultActorInitialize(_ actor: AnyObject)
@available(SwiftStdlib 5.9, *)
public func _nonDefaultDistributedActorInitialize(_ actor: AnyObject)
@available(SwiftStdlib 5.1, *)
public func _defaultActorDestroy(_ actor: AnyObject)
@available(SwiftStdlib 5.1, *)
@usableFromInline
internal func _enqueueOnMain(_ job: UnownedJob)
