//
//  HomeView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingHistorySheet = false
    @Query private var foodEntries: [FoodEntry]
    @Query private var activityEntries: [ActivityEntry]
    
    @AppStorage("userAge") private var userAge: Int = 25
    @AppStorage("userHeight") private var userHeight: Int = 170
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    @AppStorage("userGender") private var userGender: String = "Erkek"
    @AppStorage("userActivityMultiplier") private var userActivityMultiplier: Double = 1.375
    
    @State private var showingAddFoodSheet = false
    @State private var showingAddActivitySheet = false
    
    init() {
        let today = Calendar.current.startOfDay(for: .now); let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        _foodEntries = Query(filter: #Predicate<FoodEntry> { $0.date >= today && $0.date < tomorrow }, sort: \.date, order: .reverse)
        _activityEntries = Query(filter: #Predicate<ActivityEntry> { $0.date >= today && $0.date < tomorrow }, sort: \.date, order: .reverse)
    }
    
    private var totalCaloriesToday: Int { foodEntries.reduce(0) { $0 + $1.calories } }
    private var totalBurnedFromActivities: Int { activityEntries.reduce(0) { $0 + $1.caloriesBurned } }
    private var basalMetabolismRate: Double {
        if userGender == "Erkek" { return (10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))+5 } else { return (10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))-161 }
    }
    private var totalDailyEnergyExpenditure: Int { Int(basalMetabolismRate * userActivityMultiplier) + totalBurnedFromActivities }
    private var calorieBalance: Int { totalCaloriesToday - totalDailyEnergyExpenditure }
    
    var body: some View {
        ZStack {
            // ----- HATA BURADAYDI VE DÜZELTİLDİ -----
            Color.appBackground.ignoresSafeArea()
            NavigationStack {
                List {
                    Section {
                        VStack(spacing: 15) {
                            Text("Bugünün Özeti").font(.title2).bold().frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                StatView(value: "\(totalCaloriesToday)", label: "Alınan Kalori"); Spacer()
                                StatView(value: "\(totalDailyEnergyExpenditure)", label: "Yakılan Kalori"); Spacer()
                                StatView(value: "\(calorieBalance)", label: "Kalori Dengesi", color: calorieBalance > 0 ? .orange : .green)
                            }
                        }
                        .padding().background(Color(uiColor: .systemBackground)).cornerRadius(12).shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5).padding(.vertical, 5)
                    }
                    .listRowInsets(EdgeInsets()).listRowBackground(Color.clear)
                    Section(header: Text("Bugün Yediğin Yemekler").font(.headline)) {
                        if foodEntries.isEmpty { Text("Henüz yemek eklemedin.").foregroundColor(.gray) }
                        else { ForEach(foodEntries) { entry in HStack { Text(entry.name); Spacer(); Text("\(entry.calories) kcal").foregroundColor(.gray) } }.onDelete(perform: deleteFood) }
                    }
                    Section(header: Text("Bugün Yaptığın Aktiviteler").font(.headline)) {
                        if activityEntries.isEmpty { Text("Henüz aktivite eklemedin.").foregroundColor(.gray) }
                        else { ForEach(activityEntries) { entry in HStack { Text(entry.name); Spacer(); Text("\(entry.caloriesBurned) kcal yaktın").foregroundColor(.green) } }.onDelete(perform: deleteActivity) }
                    }
                }
                .scrollContentBackground(.hidden).navigationTitle("Anasayfa")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { Button { showingHistorySheet = true } label: { Image(systemName: "calendar").font(.title3) } }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: { showingAddFoodSheet = true }) { Label("Yemek Ekle", systemImage: "fork.knife.circle") }
                            Button(action: { showingAddActivitySheet = true }) { Label("Aktivite Ekle", systemImage: "figure.run.circle") }
                        } label: { Image(systemName: "plus.circle.fill").font(.title2) }
                    }
                }
                .sheet(isPresented: $showingHistorySheet) { HistoryView() }
                .sheet(isPresented: $showingAddFoodSheet) { AddFoodView() }
                .sheet(isPresented: $showingAddActivitySheet) { AddActivityView() }
            }
        }
    }
    
    private func deleteFood(at offsets: IndexSet) { for index in offsets { modelContext.delete(foodEntries[index]) } }
    private func deleteActivity(at offsets: IndexSet) { for index in offsets { modelContext.delete(activityEntries[index]) } }
}

struct StatView: View {
    let value: String
    let label: String
    var color: Color = .primary
    var body: some View {
        VStack {
            Text(value).font(.title).bold().foregroundColor(color)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}
