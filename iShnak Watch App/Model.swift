import SwiftData
import SwiftUI
import UserNotifications

class Model: ObservableObject {
    
    @Published var userData: UserData = UserData() // Store user data instance

    // Fetch user data (or create if none exists)
    //  Compute total water in litres
    func getTotalWaterInLitres() -> String {
         // Ensure userData exists
        self.userData.totalWaterInLitres = (self.userData.totalWater * 10) * self.userData.Litres
        
        return String(self.userData.totalWaterInLitres)
    }
    func setYesterday(yesterday: UserData) {
        
        let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date()) // Midnight today
            let lastRecordedDay = calendar.startOfDay(for: userData.date)
        
        if lastRecordedDay < today {
            self.userData.totalMealsYesterday = yesterday.totalMeals
            self.userData.totalWaterYesterday = yesterday.totalWater
            self.userData.totalSnacksYesterday = yesterday.totalSnacks
            self.userData.totalCoffeeYesterday = yesterday.totalCoffee
            // everything to zero
            self.userData.waterDrank = 0
            self.userData.snacks = 0
            self.userData.coffeeDrank = 0
            self.userData.meals = 0
            self.userData.date = .now
            
            self.userData.totalMeals = 0
            self.userData.totalWater = 0
            self.userData.totalCoffee = 0
            self.userData.totalSnacks = 0
        }
    }
    func save() {
        let url = URL.documentsDirectory.appending(path: "UserData")
        
        do {
            let data = try JSONEncoder().encode(self.userData)
            try data.write(to: url)
            print("Data saved successfully")
        } catch {
            print("Save error: \(error)")
        }
    }

    func load() {
        let url = URL.documentsDirectory.appending(path: "UserData")
        
        
        
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(UserData.self, from: data)
                
                // move values in object to yesterday vars.
                self.setYesterday(yesterday: decodedData)
                print("Data loaded successfully")
                
            } else {
                print("file not found at \(url.path)")
            }
        } catch {
            print("Model load error: \(error)")
        }
    }
    func scheduleHourlyNotification(every hours: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder 💧"
        content.body = "Time to drink water!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(hours * 3600), repeats: true)
        let request = UNNotificationRequest(identifier: "hourlyReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Hourly notification scheduled every \(hours) hours!")
            }
        }
        
    }
    func clearNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["hourlyReminder"])
        print("✅ Cleared previous notifications")
    }


}

// SwiftData Model

struct UserData: Decodable, Encodable  {
    var totalWaterInLitres: Double = 0.0
    var totalCoffeeInLitres: Double = 0.0
    
    var Litres: Double = 0.0
    var waterDrank: Double = 0.0
    var coffeeDrank: Double = 0.0
    var meals: Double = 0.0
    var snacks: Double = 0.0
    
    var totalWater: Double = 0.0
    var totalMeals: Double = 0.0
    var totalSnacks: Double = 0.0
    var totalCoffee: Double = 0.0
    
    var totalWaterYesterday: Double = 0.0
    var totalMealsYesterday: Double = 0.0
    var totalSnacksYesterday: Double = 0.0
    var totalCoffeeYesterday: Double = 0.0
    
    var NewUser: Bool = true
    
    var date: Date = .now
    
}
