//
//  KaloriTakipApp.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData

@main
struct KaloriTakipApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WeightEntry.self,
            FoodEntry.self,
            ActivityEntry.self,
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
            ContentView() // ContentView'i burada çağırıyoruz
        }
        .modelContainer(sharedModelContainer) // Veritabanını uygulamaya burada bağlıyoruz
    }
}
