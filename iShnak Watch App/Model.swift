//
//  Model.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import Foundation

class Model: ObservableObject {
    // logic and swiftData
    
    @Published var totalWaterInLitres: Double = 0.0
    @Published var totalCoffeeInLitres: Double = 0.0

    // UI
    @Published var Litres: Double = 0
    @Published var waterDrank: Double = 0.0
    @Published var coffeeDrank: Double = 0.0
    @Published var meals: Double = 0.0
    @Published var snacks: Double = 0.0
    
    @Published var totalWaterDrank: Double = 0.0
    @Published var totalMeals: Double = 0.0
    @Published var totalSnacks: Double = 0.0
    @Published var totalCoffee: Double = 0.0
    // onboarding
    @Published var NewUser: Bool = true
    
    func setTotalWaterDrank() {
        self.totalWaterDrank += self.waterDrank
    }
    
    func setTotalWaterInLitres()  {
        self.totalWaterInLitres = self.totalWaterDrank * self.Litres
    }
    
    
    
}
