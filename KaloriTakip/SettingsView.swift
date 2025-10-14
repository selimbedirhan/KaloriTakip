//
//  SettingsView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isWeightFieldFocused: Bool
    @State private var weightString: String = ""
    @State private var showingInfoSheet = false
    
    @AppStorage("userAge") private var userAge: Int = 25
    @AppStorage("userHeight") private var userHeight: Int = 170
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    @AppStorage("userGender") private var userGender: String = "Erkek"
    @AppStorage("userActivityMultiplier") private var userActivityMultiplier: Double = 1.375

    private var bmiResult: (value: Double, category: BMICategory, recommendation: String)? {
        guard let bmiValue = BMICalculator.calculateBMI(weightInKg: userWeight, heightInCm: userHeight) else { return nil }
        let category = BMICalculator.getCategory(from: bmiValue); let recommendation = BMICalculator.getRecommendation(for: category)
        return (bmiValue, category, recommendation)
    }
    
    private var basalMetabolismRate: Int? {
        if userGender == "Erkek" { return Int((10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))+5) }
        else { return Int((10*userWeight)+(6.25*Double(userHeight))-(5*Double(userAge))-161) }
    }

    let genders = ["Erkek", "Kadın"]
    let activityLevels = [ "Hareketsiz (Ofis İşi)": 1.2, "Az Aktif (Hafif Egzersiz)": 1.375, "Orta Aktif (Orta Egzersiz)": 1.55, "Çok Aktif (Ağır Egzersiz)": 1.725, "Ekstra Aktif (Çok Ağır Egzersiz)": 1.9 ]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            NavigationStack {
                Form {
                    Section(header: Text("Vücut Kitle İndeksin (VKİ)")) {
                        if let result = bmiResult {
                            HStack { Text("Değer"); Spacer(); Text(String(format: "%.1f", result.value)).fontWeight(.bold) }
                            HStack { Text("Durum"); Spacer(); Text(result.category.rawValue).fontWeight(.bold).foregroundColor(getCategoryColor(result.category)) }
                        } else { Text("Hesaplanamadı. Boy ve kilo bilgilerini kontrol et.") }
                    }
                    Section(header: Text("Bazal Metabolizma Hızın (BMH)")) {
                        if let bmr = basalMetabolismRate {
                            HStack { Text("Günlük Minimum Kalori"); Spacer(); Text("\(bmr) kcal").fontWeight(.bold) }
                            Text("Bu, vücudunuzun tam dinlenme halindeyken (uyurken) yaktığı minimum kaloridir.").font(.caption).foregroundColor(.secondary)
                        }
                    }
                    Section(header: Text("Kişisel Bilgiler")) {
                        TextField("Yaş", value: $userAge, format: .number).keyboardType(.numberPad)
                        TextField("Boy (cm)", value: $userHeight, format: .number).keyboardType(.numberPad)
                        TextField("Kilo (kg)", text: $weightString).keyboardType(.decimalPad).focused($isWeightFieldFocused)
                        Picker("Cinsiyet", selection: $userGender) { ForEach(genders, id: \.self) { Text($0) } }
                    }
                    Section(header: Text("Aktivite Seviyesi")) {
                        Picker("Günlük Aktivite Düzeyin", selection: $userActivityMultiplier) {
                            ForEach(activityLevels.keys.sorted(), id: \.self) { key in Text(key).tag(activityLevels[key]!) }
                        }
                    }
                    Section {
                        Button { showingInfoSheet = true } label: { Label("Kalori ve Kilo Kontrolü Hakkında Bilgi", systemImage: "info.circle") }
                        .buttonStyle(.plain) 
                    }
                    Section(header: Text("Hesaplamalar Hakkında")) {
                         Text("Yakılan kalori, popüler Mifflin-St Jeor formülü kullanılarak tahmin edilmektedir. Bu bir tıbbi tavsiye değildir.").font(.caption).foregroundColor(.gray)
                    }
                }
                .scrollContentBackground(.hidden).navigationTitle("Ayarlar")
                .onAppear { weightString = String(userWeight) }.onChange(of: isWeightFieldFocused) { if !isWeightFieldFocused { saveWeightChanges() } }
                .onTapGesture { hideKeyboard() }
                .sheet(isPresented: $showingInfoSheet) { InfoView() }
            }
        }
    }
    
    private func getCategoryColor(_ category: BMICategory) -> Color {
        switch category { case .zayif: .blue; case .normal: .green; case .fazlaKilo: .orange; case .obez: .red; default: .gray }
    }
    
    // ----- HATA BURADAYDI VE DÜZELTİLDİ -----
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func saveWeightChanges() {
        if let newWeight = Double(weightString.replacingOccurrences(of: ",", with: ".")) {
            if abs(newWeight - userWeight) > 0.01 {
                userWeight = newWeight; let newEntry = WeightEntry(date: .now, weight: newWeight); modelContext.insert(newEntry)
            }
        } else { weightString = String(userWeight) }
    }
}
