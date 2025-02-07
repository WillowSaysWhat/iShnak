// SettingsView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 29/01/2025.
//
import SwiftUI
// lets the user choose their waterbottle size and to pick the regularity of their notifications.
struct SettingsView: View {
    // model from parent view.
    @EnvironmentObject var model: Model
    // options available for the bottle volume picker
    let litreOptions: [Int] = [100, 200, 300, 600, 750, 1000]
    // options available for notifications - 1hrly, 2hrly.
    let notificationOptions: [Int] = [1, 2, 3, 4]
    // the current selected on the picker: waterebottle
    @State private var litreSelectedValue = 100
    // the current selected on the picker: waterebottle
    @State private var notificationSelectedValue = 1
    // animates the saved and removed notifications that appear when the buttons are pressed.
    @State private var savedOpacity = 0.0
    @State private var removedOpacity = 0.0
    @State var tab: Int = 0
    
    var body: some View {
        ZStack {
            // TabView lets the user navigate between the two screens
            TabView(selection: $tab) {
                ZStack(alignment: .center) {
                    // this recrange is almost invisible. It lets the user
                    // scroll easier.
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.green.gradient)
                        .opacity(0.02)
                    
                    // waterebottle picker
                    Picker("BOTTLE VOLUME", selection: $litreSelectedValue) {
                        ForEach(litreOptions, id: \.self) { value in
                            Text("\(value)") // values: 100, 200,etc
                                .tag(value)
                                .font(.title)
                        }
                        .foregroundStyle(.green)
                    }
                    .foregroundStyle(.green.opacity(0.4))
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 80)
                    
                    Text("ml") // is the text in the picker
                        .foregroundStyle(.green.opacity(0.4))
                    // moves when it reaches 1000.
                        .offset(x:litreSelectedValue == 1000 ? 53 : 42, y: 15)
                    // save button
                    Button {
                        // saves the waterbottle amount
                        model.userData.Litres = Double(litreSelectedValue)
                        // saves to watch memory
                        model.save()
                        // runs the saved animation function at the bottom of this class
                        animateSaved()}
                    label: {
                        Image(systemName: "waterbottle.fill")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: 80, y: 55)
                    
                }.tag(0)
                // Notification repeat picker: how often the user should be notified.
                ZStack {
                    // another rectangle to stop deadspace when scrolling.
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundStyle(Color.green.gradient)
                        .opacity(0.02)
                    // Picker
                    Picker("Notification Repeat", selection: $notificationSelectedValue) {
                        ForEach(notificationOptions, id: \.self) { value in
                            Text("\(value)")
                                .tag(value)
                                .font(.title)
                                
                        }
                        .foregroundStyle(.green)
                    }
                    .foregroundStyle(.green.opacity(0.4))
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 80)
                    // text inside picker: changes from hr to hrs when necessary.
                    Text(notificationSelectedValue > 1 ? "hrs" : "hr")
                        .foregroundStyle(.green.opacity(0.4))
                        .offset(x: 25, y: 15)
                    // save button
                    Button { //model.scheduleHourlyNotification(every: notificationSelectedValue)
                        //test notifications
                        model.testScheduleHourlyNotification(every: notificationSelectedValue)
                        
                        animateSaved()}
                    label: {
                        Image(systemName: "clock")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: 80, y: 55)
                    
                    // delete notifications from phone
                    Button {model.clearNotifications()
                        // runs removed hint animation.
                        animateRemoved()}
                    label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: -80, y: 55)
                }.tag(1)
                
            }
            
            
            // saved! hint overlay
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                Text("Saved!")
                    .foregroundStyle(.black)
                    .font(.system(size: 12))
            }
            .frame(width: 50, height: 40)
            .opacity(savedOpacity)
            .scaleEffect(0.7)
            .offset(y: -70)
            
            // removed hint overlay
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                Text("Removed!")
                    .foregroundStyle(.black)
                    .font(.system(size: 12))
            }
            .frame(width: 60, height: 40)
            .opacity(removedOpacity)
            .scaleEffect(0.7)
            .offset(y: -70)
        }
        
        
    }
    // animates the saved hint by changing the opacity
    func animateSaved() {
        withAnimation(.easeInOut(duration: 1)) {
            savedOpacity = 0.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1)) {
                savedOpacity = 0
            }
        }
    }
    // animates the removed hint by changing the opacity
    func animateRemoved() {
        withAnimation(.easeInOut(duration: 1)) {
            removedOpacity = 0.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 1)) {
                removedOpacity = 0
            }
        }
    }
}
#Preview {
    SettingsView()
        .environmentObject(Model())
}

