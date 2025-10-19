//
//  HealthKitManager.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 16.10.2025.
//

import Foundation
import HealthKit
import SwiftData

// HealthKit'ten gelen veriyi kendi modelimize çevirmek için bir Struct
// Artık tek bir değer döndüreceğimiz için buna ihtiyacımız kalmadı ama gelecekte kullanılabilir.
struct HealthActivity {
    let id: UUID
    let name: String
    let caloriesBurned: Int
    let date: Date
}

@Observable
class HealthKitManager {
    
    let healthStore = HKHealthStore()
    static let shared = HealthKitManager()
    
    // İzin isteme fonksiyonu aynı kalıyor, doğru çalışıyor.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit yetkilendirme hatası: \(error.localizedDescription)")
            }
            completion(success)
        }
    }
    
    // GÜNCELLENDİ: Bu fonksiyon artık antrenmanları değil, günün toplam aktif enerjisini çekiyor.
    func fetchTodaysActiveEnergy(completion: @escaping (Double?) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil)
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: today)!
        let predicate = HKQuery.predicateForSamples(withStart: today, end: endOfDay, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(nil)
                return
            }
            let totalCalories = sum.doubleValue(for: .kilocalorie())
            completion(totalCalories)
        }
        healthStore.execute(query)
    }
}

// HKWorkoutActivityType extension'ına artık ihtiyacımız yok ama silmeyelim, gelecekte lazım olabilir.
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Koşu (Sağlık)"
        case .walking: return "Yürüyüş (Sağlık)"
        case .cycling: return "Bisiklet (Sağlık)"
        case .swimming: return "Yüzme (Sağlık)"
        case .traditionalStrengthTraining: return "Ağırlık Antrenmanı (Sağlık)"
        case .highIntensityIntervalTraining: return "HIIT (Sağlık)"
        default: return "Diğer Antrenman (Sağlık)"
        }
    }
}
