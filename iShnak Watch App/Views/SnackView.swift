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
    @State private var colour: Color = .teal
    
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.snacks, ringColour: colour, lineWidth: 22)
                .frame(width: 180)

            // Central Circle
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour)
                .opacity(ontap ? 0.5 : 1)

            // Central Icon
            Image(systemName: (model.snacks >= 0.9) ? "repeat.circle" : "carrot")
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .offset(x: 3)
                .opacity(ontap ? 0.5 : 1)

            // Tap Gesture Circle
            Circle()
                .frame(width: 100)
                .opacity(0.1)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.snacks >= 0.9 {
                            model.snacks = 0.0
                        } else {
                            model.snacks += 0.1
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
        .environmentObject(Model())
}


