//
//  DailyView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 28/01/2025.
//

import SwiftUI

struct DailyView: View {
    @EnvironmentObject var model: Model
    @State private var arrowOffsetWidth: Double = 60
    @State private var arrowOffsetHeight: Double = -90
    @State private var arrowOpacity: Double = 1
    var width: CGFloat = 100
       
    var body: some View {
        
        ZStack { // this ZStack is for the arrow prompt
            Image(systemName: "arrow.up")
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .offset(x: arrowOffsetWidth, y: arrowOffsetHeight)
                .opacity(arrowOpacity)
            VStack(alignment: .center, spacing: 12) {
                HStack(alignment: .bottom, spacing: 14) {
                    // water (left large)
                    ZStack {
                        ActivityRingView(progress: model.totalWaterDrank, ringColour: .cyan, lineWidth: 13)
                            .frame(width: width - 30)
                        ActivityRingView(progress: model.waterDrank, ringColour: .blue, lineWidth: 14)
                            .frame( width: width)
                        
                        Image(systemName: "waterbottle")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                    }
                    // coffee (right small
                    ZStack {
                        ActivityRingView(progress: model.coffeeDrank, ringColour: .yellow, lineWidth: 10)
                            .frame( width: 60)
                        ActivityRingView(progress: model.totalCoffee, ringColour: .yellow.opacity(0.6), lineWidth: 7)
                            .frame(width: 40)
                        
                        Image(systemName: "cup.and.heat.waves")
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                    }
                }
                HStack(alignment: .top, spacing: 14) {
                    // snacks (left small
                    ZStack {
                        ActivityRingView(progress: model.snacks, ringColour: .green, lineWidth: 10)
                            .frame( width: 60)
                        ActivityRingView(progress: model.totalSnacks, ringColour: .yellow.opacity(0.6), lineWidth: 7)
                            .frame(width: 40)
                        
                        Image(systemName: "carrot")
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                    }
                    // meals (right large)
                    ZStack {
                        ActivityRingView(progress: model.meals, ringColour: .orange, lineWidth: 13)
                            .frame( width: width)
                        ActivityRingView(progress: model.totalMeals, ringColour: .blue, lineWidth: 14)
                            .frame( width: width - 30)
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 25))
                            .foregroundStyle(.white)
                    }
                }
                
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            .ignoresSafeArea()
            
            .onAppear() {
                // prompt arrow
                
                if model.NewUser {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        
                        withAnimation(.linear(duration: 0.7).repeatCount(3, autoreverses: false))  {
                            arrowOffsetHeight -= 30
                            arrowOpacity = 0
                        }
                        model.NewUser = false
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    DailyView()
        .environmentObject(Model())
}
