//
//  PulseAnimation.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

// pulsing animation
struct Pulse: View {
    @State private var animate = false
    let colour: Color
    
    init(c: Color) {
        self.colour = c
    }
    

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
