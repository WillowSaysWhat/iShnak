import SwiftData
import SwiftUI
import UserNotifications

// a single Model class was used so a single Environment Object could be used thorught the app.

class Model: ObservableObject {
    // Store user data instance
    @Published var userData: UserData = UserData()

    //checks to see if it is a new day.
    // sets today totals to yesterday totals and zeros everything else.
    // sets today's date
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
    // saves the userData to watch memory
    func save() {
        // sets destination url
        let url = URL.documentsDirectory.appending(path: "UserData")
        
        do {
            // encodes userData
            let data = try JSONEncoder().encode(self.userData)
            // writes to url
            try data.write(to: url)
            print("Data saved successfully")
        } catch {
            print("Save error: \(error)")
        }
    }

    func load() {
        // uses identical url as save
        let url = URL.documentsDirectory.appending(path: "UserData")
        do {
            // looks for recent data.
            if FileManager.default.fileExists(atPath: url.path) {
                // if availble, gets data.
                let data = try Data(contentsOf: url)
                // decodes data as a UserData Object
                let decodedData = try JSONDecoder().decode(UserData.self, from: data)
                //saves data in this class
                userData = decodedData
                // checks whether it is a new day.
                self.setYesterday(yesterday: userData)
                print("Data loaded successfully")
                
            } else {
                print("file not found at \(url.path)")
            }
        } catch {
            print("Model load error: \(error)")
        }
    }
    // sets notifications on watch
    func scheduleHourlyNotification(every hours: Int) {
        // creates notification object.
        let content = UNMutableNotificationContent()
        // sets title, body and sound of the notification.
        content.title = "Hydration Reminder 💧"
        content.body = "Time to drink water!"
        content.sound = UNNotificationSound.default
        // creates a trigger that takes the users choice of interval and turns it into seconds. reapeats the interval.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(hours * 3600), repeats: true)
        // sets notification request instructions with an identifing name "hourlyReminder"
        let request = UNNotificationRequest(identifier: "hourlyReminder", content: content, trigger: trigger)
        // sets the notification in the notification center.
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Hourly notification scheduled every \(hours) hours!")
            }
        }
        
    }
    // deletes notifications with identifying name "hourlyReminders" from watch.
    func clearNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["hourlyReminder"])
        print("✅ Cleared previous notifications")
    }


}

// data model
struct UserData: Decodable, Encodable  {
    // total water consumed in the day. future implementation.
    var totalWaterInLitres: Double = 0.0
    // total coffee for the day. for future implementation.
    var totalCoffeeInLitres: Double = 0.0
    // user's choice of waterbottle size.
    var Litres: Double = 0.0
    // These Doubles are used on their activity rings and reset at 0.9. this could be reset multiple times a day.
    var waterDrank: Double = 0.0
    var coffeeDrank: Double = 0.0
    var meals: Double = 0.0
    var snacks: Double = 0.0
    // totals for the day
    var totalWater: Double = 0.0
    var totalMeals: Double = 0.0
    var totalSnacks: Double = 0.0
    var totalCoffee: Double = 0.0
    // totals for yesterday.
    var totalWaterYesterday: Double = 0.0
    var totalMealsYesterday: Double = 0.0
    var totalSnacksYesterday: Double = 0.0
    var totalCoffeeYesterday: Double = 0.0
    // onboarding animations: future implementation.
    var NewUser: Bool = true
    // today's date so that data can be relocated from today to yesterday.
    var date: Date = .now
    
}
