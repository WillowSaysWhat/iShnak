//
//  DailyView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

struct DailyView: View {
    // model from the parent view
    @EnvironmentObject var model: Model
    // navigates to the setting screen when the button is tapped.
    @State var naviagateToSettingsView = false
    // animation for the legend/key in the top right of the view.
    @State var keyOpacity: Double = 0
    // width of the larger rings.
    let width: CGFloat = 100
    
       
    var body: some View {
        // this stack lets the button naviage to the settings screen.
        NavigationStack {
            ZStack {
                // key: Today/Tomorrow
                HStack {
                    Circle()
                        .frame(width: 5)
                        .foregroundStyle(.cyan)
                    Text("Today")
                        .font(.system(size: 6))
                }
                .offset(x: 17, y: -110)
                .opacity(keyOpacity)
                HStack {
                    Circle()
                        .frame(width: 4)
                        .foregroundStyle(.blue)
                    Text("Yesterday")
                        .font(.system(size: 5))
                }
                .offset(x: 29, y: -102)
                .opacity(keyOpacity)
                
                // Settings Button
                Button {naviagateToSettingsView = true}
                label: {
                    Image(systemName: "info.circle")
                }
                .navigationDestination(isPresented: $naviagateToSettingsView) {
                    // click to navigate to the settings view
                    SettingsView()
                }
                .clipShape(Circle())
                .frame(width: 35)
                .foregroundStyle(.white)
                .offset(x: -45, y: 90)
                
                
                // activity circles start here
                VStack(alignment: .center, spacing: 12) {
                    HStack(alignment: .bottom, spacing: 14) {
                        // water (left large)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalWater, ringColour: .cyan, lineWidth: 14)
                                .frame(width: width)
                            // yesterday
                            ActivityRingView(progress: model.userData.totalWaterYesterday, ringColour: .blue, lineWidth: 9)
                                .frame( width: width - 30)
                            // waterbottle icon
                            Image(systemName: "waterbottle")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                        }
                        // coffee (right small)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalCoffee, ringColour: .brown, lineWidth: 10)
                                .frame( width: 60)
                            // Yesterday
                            ActivityRingView(progress: model.userData.totalCoffeeYesterday, ringColour: .brown.opacity(0.6), lineWidth: 7)
                                .frame(width: 40)
                            // cup icon
                            Image(systemName: "cup.and.heat.waves")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                    }
                    HStack(alignment: .top, spacing: 14) {
                        // snacks (left small)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalSnacks, ringColour: .reddish, lineWidth: 10)
                                .frame( width: 60)
                            // yesterday
                            ActivityRingView(progress: model.userData.totalSnacksYesterday, ringColour: .darkerReddish, lineWidth: 7)
                                .frame(width: 40)
                            // carrot icon
                            Image(systemName: "carrot")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        // meals (right large)
                        ZStack {
                            // Yesterday
                            ActivityRingView(progress: model.userData.totalMealsYesterday, ringColour: .greenish, lineWidth: 9)
                                .frame( width: width - 30)
                            // Today
                            ActivityRingView(progress: model.userData.totalMeals, ringColour: .darkerGeenish, lineWidth: 14)
                                .frame( width: width)
                            // knife and fork icon
                            Image(systemName: "fork.knife.circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                .ignoresSafeArea()
                
            }
            .onAppear() {
                // after 3 seconds, animate the Legend/Key onto the screen.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.linear(duration: 1)) {
                        self.keyOpacity = 1
                    }
                }
            }
        }
    }
}

#Preview {
    DailyView()
        .environmentObject(Model()) // Inject model
         
}
