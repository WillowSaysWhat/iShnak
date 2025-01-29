//
//  CoffeeView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//


import SwiftUI

struct Coffee: View {
    @EnvironmentObject var model: Model
    
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    @State private var colour: Color = .brown
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.coffeeDrank, ringColour: .brown, lineWidth: 22)
                .frame(width: 180)

            // Central Circle
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // Central Icon
            Image(systemName: (model.userData.coffeeDrank >= 0.9) ? "repeat.circle" : "cup.and.heat.waves.fill")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .opacity(ontap ? 0.5 : 1)
                .offset(x:4)

            // Tap Gesture Circle
            Circle()
                .frame(width: 100)
                .foregroundStyle(colour.gradient)
                .opacity(0.1)
                .onTapGesture {
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
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.3)) {
                            ontap = false
                        }
                    }
                }

            // Pulse Animation
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

