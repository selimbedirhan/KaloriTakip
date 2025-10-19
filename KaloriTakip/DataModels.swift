//
//  DataModels.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//
import Foundation
import SwiftData

// Kilo ölçümlerini tutacak model
@Model
final class WeightEntry {
    var date: Date
    var weight: Double

    init(date: Date, weight: Double) {
        self.date = date
        self.weight = weight
    }
}

// Her bir yemek girdisini tutacak model
@Model
final class FoodEntry {
    var name: String
    var calories: Int
    var date: Date

    init(name: String, calories: Int, date: Date) {
        self.name = name
        self.calories = calories
        self.date = date
    }
}

@Model
final class ActivityEntry {
    // YENİ: HealthKit'ten gelen verinin kimliğini saklamak için.
    // Bu, verinin tekrar eklenmesini önleyecek.
    var healthKitUUID: UUID?
    
    var name: String
    var caloriesBurned: Int
    var date: Date
    
    init(healthKitUUID: UUID? = nil, name: String, caloriesBurned: Int, date: Date) {
        self.healthKitUUID = healthKitUUID
        self.name = name
        self.caloriesBurned = caloriesBurned
        self.date = date
    }
}
