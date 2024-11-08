import SwiftUI
import FirebaseCore

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
