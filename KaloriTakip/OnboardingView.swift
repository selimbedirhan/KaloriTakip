//
//  OnboardingView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    private enum Field: Hashable { case age, height, weight }
    @FocusState private var focusedField: Field?
    
    // Değişiklik burada: Artık genel geçer varsayılan değerler kullanılıyor.
    @AppStorage("userAge") private var userAge: Int = 25
    @AppStorage("userHeight") private var userHeight: Int = 170
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    @AppStorage("userGender") private var userGender: String = "Erkek"
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    @State private var ageString = ""
    @State private var heightString = ""
    @State private var weightString = ""
    @State private var showingBMIAlert = false
    @State private var bmiAlertTitle = ""
    @State private var bmiAlertMessage = ""
    
    private var isFormValid: Bool { !ageString.isEmpty && !heightString.isEmpty && !weightString.isEmpty }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "figure.wave").font(.system(size: 80)).foregroundColor(.accentColor)
                    Text("Hoş Geldin!").font(.largeTitle).bold()
                    Text("Hedeflerine ulaşman için önce seni biraz tanıyalım.").font(.headline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
                    Form {
                        Section(header: Text("Kişisel Bilgilerin")) {
                            TextField("Yaşın", text: $ageString).keyboardType(.numberPad).focused($focusedField, equals: .age)
                            TextField("Boyun (cm)", text: $heightString).keyboardType(.numberPad).focused($focusedField, equals: .height)
                            TextField("Kilon (kg)", text: $weightString).keyboardType(.decimalPad).focused($focusedField, equals: .weight)
                            Picker("Cinsiyet", selection: $userGender) { Text("Erkek").tag("Erkek"); Text("Kadın").tag("Kadın") }
                        }
                    }
                    .frame(height: 280).scrollContentBackground(.hidden)
                    Spacer()
                    Button(action: calculateAndShowBMI) {
                        Text("Başlayalım").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(isFormValid ? Color.accentColor : Color.gray).cornerRadius(12)
                    }
                    .disabled(!isFormValid).padding()
                }
                .padding(.top, 40)
            }
        }
        .onTapGesture { focusedField = nil }
        .alert(bmiAlertTitle, isPresented: $showingBMIAlert) { Button("Anladım, Başlayalım!") { completeOnboarding() } } message: { Text(bmiAlertMessage) }
    }
    
    func calculateAndShowBMI() {
        guard let height = Int(heightString), let weight = Double(weightString.replacingOccurrences(of: ",", with: ".")) else { return }
        if let bmiValue = BMICalculator.calculateBMI(weightInKg: weight, heightInCm: height) {
            let category = BMICalculator.getCategory(from: bmiValue)
            let recommendation = BMICalculator.getRecommendation(for: category)
            bmiAlertTitle = "VKİ Sonucun: \(String(format: "%.1f", bmiValue)) (\(category.rawValue))"
            bmiAlertMessage = recommendation
            showingBMIAlert = true
        }
    }
    
    func completeOnboarding() {
        userAge = Int(ageString) ?? 25
        userHeight = Int(heightString) ?? 170
        let initialWeightValue = Double(weightString.replacingOccurrences(of: ",", with: ".")); userWeight = initialWeightValue ?? 70.0
        if let weight = initialWeightValue { let initialWeightEntry = WeightEntry(date: .now, weight: weight); modelContext.insert(initialWeightEntry) }
        hasCompletedOnboarding = true
    }
}
