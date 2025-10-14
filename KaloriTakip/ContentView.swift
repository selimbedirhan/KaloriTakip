//
//  ContentView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Onboarding'in tamamlanıp tamamlanmadığını kontrol eden bayrağı okuyoruz.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        if hasCompletedOnboarding {
            // Eğer onboarding tamamlandıysa, normal sekmeli arayüzü göster.
            MainTabView()
        } else {
            // Tamamlanmadıysa, tam ekran olarak OnboardingView'i göster.
            OnboardingView()
        }
    }
}

// Sekmeli yapıyı kendi ayrı View'ine taşıdık, kod daha temiz oldu.
struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Anasayfa", systemImage: "house.fill")
                }

            ChartsView()
                .tabItem {
                    Label("Grafikler", systemImage: "chart.bar.xaxis")
                }
            
            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
