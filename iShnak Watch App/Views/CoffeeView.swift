//
//  CoffeeView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//


import SwiftUI

struct Coffee: View {
    // model from the parent view
    @EnvironmentObject var model: Model
    
    // animation variables
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    // colour for the circle, activity ring, and pulse animation.
    @State private var colour: Color = .brown
    
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.coffeeDrank, ringColour: .brown, lineWidth: 22)
                .frame(width: 180)

            // bottom circle that you can see (brown)
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // The coffee cup icon
            Image(systemName: (model.userData.coffeeDrank >= 0.9) ? "repeat.circle" : "cup.and.heat.waves.fill")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .opacity(ontap ? 0.5 : 1) // changes opacity when tapped.
                .offset(x:4)

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
                    // add +1 to total coffee
                    // othewise add to ring and add to total coffee.
                    // save to phone data.
                    withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.userData.coffeeDrank >= 0.9 {
                            model.userData.coffeeDrank = 0.0
                            model.userData.totalCoffee += 0.1
                        } else {
                            model.userData.coffeeDrank += 0.1
                            model.userData.totalCoffee += 0.1
                        }
                        model.save()
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
    Coffee()
        .environmentObject(Model()) // Inject model
         
}

