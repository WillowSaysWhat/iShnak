//
//  Water.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

struct Water: View {
    // model from the parent view
    @EnvironmentObject var model: Model
    
    // animation variables
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    // colour for the circle, activity ring, and pulse animation.
    @State private var colour: Color = .blue
    
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.waterDrank, ringColour: colour, lineWidth: 22)
                .frame(width: 180)

            // bottom circle that you can see (blue)
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // waterbottle icon
            Image(systemName: (model.userData.waterDrank >= 0.9) ? "repeat.circle" : "waterbottle")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .opacity(ontap ? 0.5 : 1) // changes opacity when tapped.

            // Tap Gesture Circle that you cannot see and is used as the "button"
            // to activate the activity ring. It is used because the icon was creating a
            // dead zone around it. If a user tapped slightly off the icon, nothing happened.
            Circle()
                .frame(width: 100)
                .foregroundStyle(colour.gradient)
                .opacity(0.1)
                .onTapGesture {
                    // when te circle is tapped
                    // animate the button tap by lowering opacity
                    // show the pulse animation
                    // if the ring is full, reset.
                    // add +1 to total water
                    // othewise add to ring and add to total water.
                    // save to phone data.
                    withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.userData.waterDrank  >= 0.9 {
                            model.userData.waterDrank = 0.0
                            model.userData.totalWater += 0.1
                        } else {
                            model.userData.waterDrank += 0.1
                            model.userData.totalWater += 0.1
                            model.save()
                        }
                    }
                    // now return circle and icon to their original opacity
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.3)) {
                            ontap = false
                        }
                    }
                }

            // Pulse Animation then reset bool
            if showPulse {
                Pulse(c: colour)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showPulse = false
                        }
                    }
            }
            
        }
        
    }
        
}
    
    

#Preview {
    Water()
        
        .environmentObject(Model())
        
}

