//
//  BMI_Calculator.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import Foundation

// VKİ kategorilerini tanımlayan bir enum
enum BMICategory: String {
    case zayif = "Zayıf"
    case normal = "Normal Kilolu"
    case fazlaKilo = "Fazla Kilolu"
    case obez = "Obez"
    case bilinmiyor = "Hesaplanamadı"
}

// Tüm VKİ mantığını içeren bir yardımcı yapı
struct BMICalculator {
    
    // VKİ değerini hesaplayan fonksiyon
    static func calculateBMI(weightInKg: Double, heightInCm: Int) -> Double? {
        // Boy 0 veya daha küçükse hesaplama yapılamaz (hatayı önlemek için)
        guard heightInCm > 0 else { return nil }
        
        let heightInMeters = Double(heightInCm) / 100.0
        let bmi = weightInKg / (heightInMeters * heightInMeters)
        return bmi
    }
    
    // VKİ değerine göre kategoriyi belirleyen fonksiyon
    static func getCategory(from bmi: Double) -> BMICategory {
        switch bmi {
        case ..<18.5:
            return .zayif
        case 18.5..<25:
            return .normal
        case 25..<30:
            return .fazlaKilo
        case 30...:
            return .obez
        default:
            return .bilinmiyor
        }
    }
    
    // Kategoriye göre motivasyonel tavsiye veren fonksiyon
    static func getRecommendation(for category: BMICategory) -> String {
        switch category {
        case .zayif:
            return "Sağlıklı bir şekilde kilo almayı hedefleyebilirsin. Enerji ve besin değeri yüksek gıdalarla beslenmek iyi bir başlangıç olabilir."
        case .normal:
            return "Harika! Kilon ideal aralıkta. Mevcut kilonu korumaya ve sağlıklı yaşam alışkanlıklarını sürdürmeye devam et."
        case .fazlaKilo:
            return "Sağlıklı bir kiloya ulaşmak için ilk adımı attın. Dengeli beslenme ve düzenli aktivite ile hedefine ulaşabilirsin."
        case .obez:
            return "Sağlığın için önemli bir karar aldın. Küçük ve sürdürülebilir adımlarla başlayarak büyük farklar yaratabilirsin. Yolculuğunda yalnız değilsin."
        case .bilinmiyor:
            return "Lütfen boy ve kilo bilgilerini doğru girdiğinden emin ol."
        }
    }
}
