//
//  PulseAnimation.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

// pulsing animation that activates on each press of a progress button.
struct Pulse: View {
    @State private var animate = false // toggles when the animation should activate.
    let colour: Color // each view uses a different colour.
    
    // gets the correct colour for each view. e.g. blue for water, brown for coffee.
    init(c: Color) {
        self.colour = c
    }
    
// The amination is 2 circles that grow and fade using animation to change the scale and opacity.
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(colour, lineWidth: 3)
                    .scaleEffect(animate ? 1.5 : 0.5)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1)
                            .repeatCount(0)
                            .delay(Double(i) * 0.4),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}


#Preview {
    Pulse(c:.blue)
}
