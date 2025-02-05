//
//  ActivityRingView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 27/01/2025.
//

import SwiftUI

// This is the refactored widget in every view. It visualised the progress of each
// activity - e.g. water consumption or meals eaten.

struct ActivityRingView: View {
    var progress: Double // makes the bar color progress
    var ringColour: Color // colour of the progress
    var lineWidth: CGFloat // width of the ring
    var backgroundColor: Color = Color.gray.opacity(0.2)

    var body: some View {
        ZStack {
            // Background Circle: The dark gray circle.
            Circle()
                .stroke( // makes the circle a donut
                    backgroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Progress Ring: The coloured progress ring.
            Circle()
                .trim(from: 0.0, to: progress) // decides the size of the segment (blue)
                .stroke(
                    ringColour,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut, value: progress) // Smooth animation
        }
    }
}


#Preview {
    ActivityRingView(progress: 0.3, ringColour: .blue, lineWidth: 22)
}
