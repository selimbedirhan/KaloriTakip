//
//  Color+Extension.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI

// SwiftUI'ın Color yapısını kendi renklerimizle genişletiyoruz.
extension Color {
    // Bu, harcama uygulamasındaki arka plan rengine çok yakın bir gri tonu.
    // Artık projenin herhangi bir yerinden `Color.appBackground` yazarak bu renge ulaşabiliriz.
    static let appBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
}
