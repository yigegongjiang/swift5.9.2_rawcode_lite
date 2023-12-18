import Swift
@available(SwiftStdlib 5.1, *)
public func swift_deletedAsyncMethodError() async {
    fatalError("Fatal error: Call of deleted method")
}
