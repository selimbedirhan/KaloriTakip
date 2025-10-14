//
//  DayDetailView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData

struct DayDetailView: View {
    let selectedDate: Date
    
    @Query private var foodEntries: [FoodEntry]
    @Query private var activityEntries: [ActivityEntry]
    
    // YENİ: Tarihi metne çeviren bir yardımcı değişken.
    private var formattedTitle: String {
        selectedDate.formatted(date: .long, time: .omitted)
    }
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        
        let startOfDay = Calendar.current.startOfDay(for: selectedDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        _foodEntries = Query(filter: #Predicate<FoodEntry> {
            $0.date >= startOfDay && $0.date < endOfDay
        }, sort: \.date, order: .reverse)
        
        _activityEntries = Query(filter: #Predicate<ActivityEntry> {
            $0.date >= startOfDay && $0.date < endOfDay
        }, sort: \.date, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            List {
                Section(header: Text("Yenilen Yemekler")) {
                    if foodEntries.isEmpty {
                        Text("Bu gün yemek kaydı bulunamadı.")
                    } else {
                        ForEach(foodEntries) { entry in
                            HStack {
                                Text(entry.name)
                                Spacer()
                                Text("\(entry.calories) kcal").foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(header: Text("Yapılan Aktiviteler")) {
                    if activityEntries.isEmpty {
                        Text("Bu gün aktivite kaydı bulunamadı.")
                    } else {
                        ForEach(activityEntries) { entry in
                            HStack {
                                Text(entry.name)
                                Spacer()
                                Text("\(entry.caloriesBurned) kcal yaktın").foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            // DÜZELTME: Artık önceden formatlanmış String'i kullanıyoruz.
            .navigationTitle(formattedTitle)
        }
    }
}
