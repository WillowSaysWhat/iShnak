//
//  ContentView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 27/01/2025.
//

import SwiftUI

struct ContentView: View {
    // UI model
    @EnvironmentObject var model: Model
    
    // gets the app to open on this view.
    @State var tabSelected: Int = 0
        
    var body: some View {
        // This is the vertical navigation functionality of the app.
        // each view in the TavView is accessed by swiping up/down.
        TabView(selection: $tabSelected) {
            
            DailyView()
                .tag(0)
            Water()
                .tag(1)
            Meal()
                .tag(2)
            Coffee()
                .tag(3)
            Snacks()
                .tag(4)
            
        }
        .tabViewStyle(.verticalPage(transitionStyle: .blur))
        .onAppear {
            // loads previous data from watch.
            withAnimation(.linear(duration: 0)) {
                model.load()
            }
        }
    }
    
}




#Preview {
    ContentView()
        .environmentObject(Model()) // Inject model
         
        
}

