//
//  ChartsView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData
import Charts

struct ChartsView: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isWeightFieldFocused: Bool
    @Query(sort: \WeightEntry.date) private var weightEntries: [WeightEntry]
    @AppStorage("userWeight") private var userWeight: Double = 85.0
    @State private var newWeight: String = ""
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            NavigationStack {
                List {
                    Section {
                        VStack {
                            Text("Kilo Değişim Grafiği")
                                .font(.title2).bold()
                                .padding(.top)
                            
                            // GÜNCELLENDİ: Koşulu < 2 yerine .isEmpty olarak değiştirdik.
                            // Artık sadece hiç veri yokken bu mesaj görünecek.
                            if weightEntries.isEmpty {
                                ContentUnavailableView("Grafik için henüz veri girilmedi.", systemImage: "chart.bar.xaxis.ascending")
                            } else {
                                Chart(weightEntries) { entry in
                                    // GÜNCELLENDİ: LineMark (çizgi) sadece 1'den fazla veri varsa çizilecek.
                                    if weightEntries.count > 1 {
                                        LineMark(x: .value("Tarih", entry.date, unit: .day), y: .value("Kilo", entry.weight))
                                            .interpolationMethod(.catmullRom)
                                    }
                                    
                                    // PointMark (nokta) her zaman çizilecek.
                                    PointMark(x: .value("Tarih", entry.date, unit: .day), y: .value("Kilo", entry.weight))
                                        .annotation(position: .top) { Text("\(entry.weight, specifier: "%.1f")").font(.caption2).foregroundColor(.secondary) }
                                }
                                .chartXAxis { AxisMarks(values: .stride(by: .day)) { value in AxisGridLine(); AxisTick(); AxisValueLabel(format: .dateTime.month().day()) } }
                                .padding(.horizontal)
                            }
                        }
                        .frame(height: 250)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    
                    Section(header: Text("Kilo Geçmişi")) {
                        if weightEntries.isEmpty {
                            Text("Henüz kilo verisi eklemedin.")
                        } else {
                            ForEach(weightEntries.sorted(by: { $0.date > $1.date })) { entry in
                                HStack {
                                    Text(entry.date, style: .date)
                                    Spacer()
                                    Text("\(entry.weight, specifier: "%.1f") kg").foregroundColor(.secondary)
                                }
                            }
                            .onDelete(perform: deleteWeight)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Grafikler")
                .onTapGesture { isWeightFieldFocused = false }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        TextField("Yeni Kilo (örn: 85.5)", text: $newWeight)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                            .focused($isWeightFieldFocused)
                        
                        Button("Kilo Ekle") { addWeight() }
                            .buttonStyle(.borderedProminent)
                            .padding(.trailing)
                            .disabled(newWeight.isEmpty)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func addWeight() {
        guard let weightValue = Double(newWeight.replacingOccurrences(of: ",", with: ".")) else { return }
        let newEntry = WeightEntry(date: .now, weight: weightValue); modelContext.insert(newEntry)
        userWeight = weightValue; newWeight = ""
        isWeightFieldFocused = false
    }
    
    private func deleteWeight(at offsets: IndexSet) {
        let sortedEntries = weightEntries.sorted(by: { $0.date > $1.date }); for index in offsets { let entryToDelete = sortedEntries[index]; modelContext.delete(entryToDelete) }
    }
}
