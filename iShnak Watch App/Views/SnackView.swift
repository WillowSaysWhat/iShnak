//
//  SnacksView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

struct Snacks: View {
    @EnvironmentObject var model: Model
    
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    @State private var colour: Color = .reddish
    
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.snacks , ringColour: colour, lineWidth: 22)
                .frame(width: 180)

            // Central Circle
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // Central Icon
            Image(systemName: (model.userData.snacks >= 0.9) ? "repeat.circle" : "carrot")
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .offset(x: 3)
                .opacity(ontap ? 0.5 : 1)

            // Tap Gesture Circle
            Circle()
                .frame(width: 100)
                .foregroundStyle(colour.gradient)
                .opacity(0.1)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.userData.snacks >= 0.9 {
                            model.userData.snacks = 0.0
                            model.userData.totalSnacks += 0.1
                        } else {
                            model.userData.snacks += 0.1
                            model.userData.totalSnacks += 0.1
                            model.save()
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
    Snacks()
        .environmentObject(Model()) // Inject model
         
}


