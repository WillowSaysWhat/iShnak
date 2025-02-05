//
//  iShnakApp.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 27/01/2025.
//

import SwiftUI

@main
struct iShnak_Watch_AppApp: App {
    // this object is used throughout the app.
    @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model) // injected into the child view.
                
                
        }
        
    }
}
