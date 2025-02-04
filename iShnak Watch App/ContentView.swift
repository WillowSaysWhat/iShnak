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
    // Fetch local data query (SwiftData)
    
    
    var body: some View {
        TabView(selection: $tabSelected) {
            DailyView()
                .tag(0)
               
            // water drink view
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
            withAnimation(.linear(duration: 0)) {
                model.load()
            }
            
        }
        .onDisappear {
            
            model.save()
            
        }
        
            
        
        
    }
    
}

// Pulse animation


#Preview {
    ContentView()
        .environmentObject(Model()) // Inject model
         
        
}

