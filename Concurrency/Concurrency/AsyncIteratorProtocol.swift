import Swift
@available(SwiftStdlib 5.1, *)
@rethrows
public protocol AsyncIteratorProtocol {
  associatedtype Element
  mutating func next() async throws -> Element?
}
