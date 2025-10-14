//
//  InfoView.swift
//  KaloriTakip
//
//  Created by Selim Bedirhan Öztürk on 13.10.2025.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                List {
                    Section(header: Text("En Sık Karıştırılan Kavramlar").font(.headline)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Bazal Metabolizma Hızı (BMH) Nedir?")
                                .font(.title3).bold()
                            Text("Bu, vücudunuzun 24 saat boyunca tam dinlenme halindeyken (uyurken, yatarken) sadece hayati organlarını çalıştırmak için yaktığı minimum enerji miktarıdır. Bu, sizin temel kalori ihtiyacınızdır.")
                            
                            Text("Peki Ana Ekrandaki 'Yakılan Kalori' Nedir?")
                                .font(.title3).bold()
                                .padding(.top)
                            Text("Bu değer, sizin **Toplam Günlük Enerji Harcamanızdır (TDEE)**. Yani, BMH'nizin üzerine günlük aktivitelerinizin (yürümek, çalışmak, yemek yemek) eklenmesiyle bulunan **tahmini toplam yakımınızdır**. Ayarlar'da seçtiğiniz 'Aktivite Düzeyi' bu tahmini belirler. Gün içinde ekstra spor eklediğinizde bu rakam daha da artar.")
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Kilo Vermek İçin Temel Stratejiler").font(.headline)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Anahtar Kelime: Kalori Açığı")
                                .font(.title3).bold()
                            Text("Kilo vermek için, gün sonunda yaktığınız toplam kaloriden daha az kalori almanız gerekir. Buna 'kalori açığı' denir. Örneğin, gün sonunda -300 kcal'lik bir denge, kilo vermenize yardımcı olur.")
                            
                            Text("İpuçları:")
                                .fontWeight(.semibold)
                                .padding(.top)
                            
                            Label("Sürdürülebilir bir hedef belirleyin (günde -300 ile -500 arası idealdir).", systemImage: "target")
                            Label("Protein ve lif ağırlıklı beslenerek daha uzun süre tok kalın.", systemImage: "leaf.fill")
                            Label("Sadece kardiyo değil, kas kütlenizi korumak için ağırlık antrenmanları da yapın.", systemImage: "figure.strengthtraining.traditional")
                            Label("Bol su için ve sabırlı olun. Bu bir maraton, sprint değil.", systemImage: "drop.fill")
                        }
                        .padding(.vertical)
                    }
                    
                    Section(header: Text("Kilo Almak İçin Temel Stratejiler").font(.headline)) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Anahtar Kelime: Kalori Fazlası")
                                .font(.title3).bold()
                            Text("Kilo almak için, yaktığınız toplam kaloriden daha fazla kalori almanız gerekir. Buna 'kalori fazlası' denir. Örneğin, +300 kcal'lik bir denge, kilo almanıza yardımcı olur.")
                            
                            Text("İpuçları:")
                                .fontWeight(.semibold)
                                .padding(.top)
                            
                            Label("Sağlıklı ve kalori yoğun gıdalar tercih edin (kuruyemişler, avokado, zeytinyağı).", systemImage: "nuts.fill")
                            Label("Kas olarak kilo almak için ağırlık antrenmanları yapmak çok önemlidir.", systemImage: "figure.strengthtraining.traditional")
                            Label("Öğün atlamayın ve ara öğünlerle günlük kalori hedefinizi destekleyin.", systemImage: "fork.knife")
                        }
                        .padding(.vertical)
                    }
                }
                .scrollContentBackground(.hidden)
                .navigationTitle("Bilgilendirme")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Kapat") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
