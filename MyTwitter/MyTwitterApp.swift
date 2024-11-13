import FirebaseCore
import SwiftUI

@main
struct MyTwitterApp: App {
    // per Firebase docs
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
