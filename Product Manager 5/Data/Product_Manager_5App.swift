import SwiftUI
import SwiftData

@main
struct Product_Manager_5App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Initiative.self,
            Note.self,
            Task.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
