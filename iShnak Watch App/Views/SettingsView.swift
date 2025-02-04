// SettingsView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 29/01/2025.
//
import SwiftUI
struct SettingsView: View {
    
    @EnvironmentObject var model: Model
    let litreOptions: [Int] = [100, 200, 300, 600, 750, 1000]
    let notificationOptions: [Int] = [1, 2, 3, 4]
    @State private var litreSelectedValue = 100
    @State private var notificationSelectedValue = 1
    @State private var savedOpacity = 0.0
    @State private var removedOpacity = 0.0
    
    
    var body: some View {
       
        ZStack {
            TabView {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color.green.gradient)
                        .opacity(0.02)
                    
                    
                    Picker("BOTTLE VOLUME", selection: $litreSelectedValue) {
                        ForEach(litreOptions, id: \.self) { value in
                            Text("\(value)")
                                .tag(value)
                                .font(.title)
                        }
                        .foregroundStyle(.green)
                    }
                    .foregroundStyle(.green.opacity(0.4))
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 80)
                    
                    Text("ml")
                        .foregroundStyle(.green.opacity(0.4))
                        .offset(x:litreSelectedValue == 1000 ? 53 : 42, y: 15)
                    // save button
                    Button {
                        model.userData.Litres = Double(litreSelectedValue)
                        
                        model.save()
                        animateSaved()}
                    label: {
                        Image(systemName: "waterbottle.fill")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: 80, y: 55)
                    
                }
                // Notification repeat picker
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundStyle(Color.green.gradient)
                        .opacity(0.02)
                    
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
                    
                    Text(notificationSelectedValue > 1 ? "hrs" : "hr")
                        .foregroundStyle(.green.opacity(0.4))
                        .offset(x: 25, y: 15)
                    // save button
                    Button {model.scheduleHourlyNotification(every: notificationSelectedValue)
                        animateSaved()}
                    label: {
                        Image(systemName: "clock")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: 80, y: 55)
                    
                    // delete notifications
                    Button {model.clearNotifications()
                        animateRemoved()}
                    label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: -80, y: 55)
                }
                
            }.tabViewStyle(.verticalPage)
            // saved! overlay
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

