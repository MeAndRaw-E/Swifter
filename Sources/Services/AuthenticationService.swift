import Foundation

public protocol UserConfigurationProtocol: Sendable {
    var testUserTokens: [String: String] { get }
    var defaultTestUser: String { get }
    var userAuthTokenKey: String { get }
}

public final class AuthenticationService: @unchecked Sendable {
    private let config: UserConfigurationProtocol, lock = NSLock()
    private static let sharedInstance = SharedInstance()
    private final class SharedInstance: @unchecked Sendable {
        private let lock = NSLock()
        fileprivate var _shared: AuthenticationService?
        fileprivate func getShared() -> AuthenticationService {
            lock.lock()
            defer { lock.unlock() }
            guard let instance = _shared else {
                fatalError("AuthenticationService.setup() must be called before access")
            }
            return instance
        }
        fileprivate func setShared(_ service: AuthenticationService) -> Bool {
            lock.lock()
            defer { lock.unlock() }
            guard _shared == nil else { return false }
            _shared = service
            return true
        }
    }
    public static var shared: AuthenticationService { sharedInstance.getShared() }
    public static func setup(with config: UserConfigurationProtocol) {
        guard sharedInstance.setShared(AuthenticationService(config: config)) else {
            assertionFailure("AuthenticationService already initialized")
            return
        }
    }
    #if DEBUG
        public private(set) var currentUser: String
        public var userAuthenticationToken: String {
            get {
                synchronized {
                    config.testUserTokens[currentUser] ?? config.testUserTokens[config.defaultTestUser]!
                }
            }
            set {
                synchronized {
                    currentUser = config.testUserTokens.first { $0.value == newValue }?.key ?? currentUser
                }
            }
        }
        public func signIn(username: String) {
            synchronized { if config.testUserTokens.keys.contains(username) { currentUser = username } }
        }
        public func signOut() { synchronized { currentUser = config.defaultTestUser } }
        public var isAuthenticated: Bool { true }
    #else
        private var inMemoryToken = ""
        public var userAuthenticationToken: String {
            get {
                synchronized {
                    UserDefaults.standard.string(forKey: config.userAuthTokenKey).flatMap { $0.isEmpty ? nil : $0 }
                        ?? inMemoryToken
                }
            }
            set {
                synchronized {
                    inMemoryToken = newValue
                    try? UserDefaults.standard.set(newValue, forKey: config.userAuthTokenKey)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        public func signIn(username: String) {
            guard let token = config.testUserTokens[username] else { return }
            inMemoryToken = token
            try? UserDefaults.standard.set(token, forKey: config.userAuthTokenKey)
            UserDefaults.standard.synchronize()
        }
        public func signOut() {
            synchronized {
                inMemoryToken = ""
                UserDefaults.standard.removeObject(forKey: config.userAuthTokenKey)
                UserDefaults.standard.synchronize()
            }
        }
        public var isAuthenticated: Bool { !userAuthenticationToken.isEmpty }
    #endif
    private func synchronized<T>(_ block: () -> T) -> T {
        lock.lock()
        defer { lock.unlock() }
        return block()
    }
    public init(config: UserConfigurationProtocol) {
        self.config = config
        #if DEBUG
            currentUser = config.defaultTestUser
        #endif
    }
    public static func getUserAuthenticationToken() -> String { shared.userAuthenticationToken }
    public static func isUserAuthenticated() -> Bool { shared.isAuthenticated }
}
