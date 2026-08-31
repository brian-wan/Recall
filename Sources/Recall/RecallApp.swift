import SwiftUI
import SwiftData

@main
struct RecallApp: App {
    var body: some Scene {
        WindowGroup {
            ReviewView()
        }
        .modelContainer(for: Word.self)
    }
}
