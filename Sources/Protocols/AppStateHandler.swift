import SwiftUI

@MainActor public protocol AppStateHandlerProtocol {
    var isAppSetup: Bool { get set }

    func setupApp() async
}
