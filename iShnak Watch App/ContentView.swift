//
//  ContentView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 27/01/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: Model
    // check to see if this is needed for nav.
    @State var tabSelected: Int = 0
    //
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
            
        }.tabViewStyle(.verticalPage(transitionStyle: .blur))
    }
}

// Pulse animation


#Preview {
    ContentView()
        .environmentObject(Model())
}
