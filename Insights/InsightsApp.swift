//
//  InsightsApp.swift
//  Insights
//
//  Created by no-today on 2024/5/20.
//

import SwiftUI
import SwiftData

@main
struct InsightsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Journal.self,
            Habit.self
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
            HabitListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
