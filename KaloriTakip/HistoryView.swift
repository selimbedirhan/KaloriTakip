//
//  HistoryView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import SwiftUI
import SwiftData

struct DailySummary: Identifiable, Hashable {
    let id: Date
    let date: Date
    let caloriesIn: Int
    let caloriesOut: Int
    var netCalories: Int { caloriesIn - caloriesOut }
}

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \FoodEntry.date, order: .reverse) private var allFoodEntries: [FoodEntry]
    @Query(sort: \ActivityEntry.date, order: .reverse) private var allActivityEntries: [ActivityEntry]
    
    @AppStorage("userAge") private var userAge: Int = 25
    @AppStorage("userHeight") private var userHeight: Int = 170
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    @AppStorage("userGender") private var userGender: String = "Erkek"
    @AppStorage("userActivityMultiplier") private var userActivityMultiplier: Double = 1.375

    private var basalMetabolismRate: Double {
        if userGender == "Erkek" { return (10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))+5 }
        else { return (10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))-161 }
    }
    
    private var baseCaloriesBurned: Int { return Int(basalMetabolismRate * userActivityMultiplier) }

    private var dailySummaries: [DailySummary] {
        var summaries = [Date: (caloriesIn: Int, caloriesFromActivity: Int)]()
        for entry in allFoodEntries {
            let day = Calendar.current.startOfDay(for: entry.date)
            summaries[day, default: (0, 0)].caloriesIn += entry.calories
        }
        for entry in allActivityEntries {
            let day = Calendar.current.startOfDay(for: entry.date)
            summaries[day, default: (0, 0)].caloriesFromActivity += entry.caloriesBurned
        }
        return summaries.map { (date, totals) in
            let totalBurned = baseCaloriesBurned + totals.caloriesFromActivity
            return DailySummary(id: date, date: date, caloriesIn: totals.caloriesIn, caloriesOut: totalBurned)
        }.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                VStack {
                    if dailySummaries.isEmpty {
                        ContentUnavailableView("Geçmiş günlere ait kayıt bulunamadı.", systemImage: "calendar.badge.exclamationmark")
                    } else {
                        List {
                            ForEach(dailySummaries) { summary in
                                NavigationLink(value: summary) {
                                    HStack {
                                        // ----- HATA BURADAYDI VE DÜZELTİLDİ -----
                                        Text(summary.date, style: .date)
                                        Spacer()
                                        Text("\(summary.netCalories, format: .number) kcal")
                                            .foregroundColor(summary.netCalories >= 0 ? .orange : .green)
                                            .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                    Spacer()
                    Text("Created by Selim Bedirhan Öztürk").font(.caption).foregroundColor(.secondary).padding()
                }
                .navigationTitle("Geçmiş Günler")
                .navigationDestination(for: DailySummary.self) { summary in DayDetailView(selectedDate: summary.date) }
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Kapat") { dismiss() } } }
            }
        }
    }
}
