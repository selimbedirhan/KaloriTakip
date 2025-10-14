//
//  AddFoodView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var foodName: String = ""
    @State private var calories: String = ""

    // Formun geçerli olup olmadığını kontrol eden değişken
    private var isFormValid: Bool {
        !foodName.isEmpty && !calories.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Yemek Bilgileri")) {
                    // Alanların sırasını değiştirdik
                    TextField("Kalori Miktarı", text: $calories)
                        .keyboardType(.numberPad)
                    
                    TextField("Yemek Adı", text: $foodName)
                }
            }
            .navigationTitle("Yeni Yemek Ekle")
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
                        saveFood()
                    }
                    .disabled(!isFormValid) // Alanlar boşsa buton pasif
                }
            }
        }
    }
    
    private func saveFood() {
        guard let calorieCount = Int(calories) else { return }
        let newFood = FoodEntry(name: foodName, calories: calorieCount, date: .now)
        modelContext.insert(newFood)
        dismiss()
    }
}

#Preview {
    AddFoodView()
}
