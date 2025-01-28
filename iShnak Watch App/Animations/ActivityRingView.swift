//
//  ActivityRingView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 27/01/2025.
//

import SwiftUI

struct ActivityRingView: View {
    var progress: Double // makes the bar color progress
    var ringColour: Color // colour of the progress
    var lineWidth: CGFloat
    var backgroundColor: Color = Color.gray.opacity(0.2)

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(
                    backgroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Progress Ring
            Circle()
                .trim(from: 0.0, to: progress)
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
    ActivityRingView(progress: 50, ringColour: .blue, lineWidth: 22)
}
