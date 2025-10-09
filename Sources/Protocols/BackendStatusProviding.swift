@MainActor public protocol BackendStatusProviding {
    var isBackendAvailable: Bool { get }
}
