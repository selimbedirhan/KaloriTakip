//
//  AddActivityView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI
import SwiftData

struct AddActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var activityName: String = ""
    @State private var calories: String = ""

    // Formun geçerli olup olmadığını kontrol eden değişken
    private var isFormValid: Bool {
        !activityName.isEmpty && !calories.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Aktivite Bilgileri")) {
                    // Alanların sırasını değiştirdik
                    TextField("Yakılan Kalori Miktarı", text: $calories)
                        .keyboardType(.numberPad)
                    
                    TextField("Aktivite Adı (Koşu, Yürüyüş vb.)", text: $activityName)
                }
            }
            .navigationTitle("Yeni Aktivite Ekle")
            .toolbar {
                // İptal Butonu
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                // Kaydet Butonu
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveActivity()
                    }
                    .disabled(!isFormValid) // Alanlar boşsa buton pasif
                }
            }
        }
    }
    
    private func saveActivity() {
        guard let calorieCount = Int(calories) else { return }
        let newActivity = ActivityEntry(name: activityName, caloriesBurned: calorieCount, date: .now)
        modelContext.insert(newActivity)
        dismiss()
    }
}

#Preview {
    AddActivityView()
}
