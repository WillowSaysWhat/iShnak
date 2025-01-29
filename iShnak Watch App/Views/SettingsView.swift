//
//  SettingsView.swift
//  iShnak Watch App
//
//  Created by Huw Williams on 29/01/2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: Model
    let options: [Int] = [100, 200, 300, 600, 750, 1000]
    @State private var selectedValue = 100
    @Binding var naviagateToSettingsView: Bool
    var body: some View {
        TabView {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(Color.green.gradient)
                    .opacity(0.2)
                
                    
                    Picker("BOTTLE VOLUME", selection: $selectedValue) {
                        ForEach(options, id: \.self) { value in
                            Text("\(value)")
                                .tag(value)
                                .font(.title)
                        }
                        .foregroundStyle(.green)
                    }
                    .foregroundStyle(.green.opacity(0.4))
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 80)
                    Text("ml")
                        .foregroundStyle(.green.opacity(0.4))
                        .offset(x:selectedValue == 1000 ? 53 : 42, y: 15)
                    
                    Button {
                        model.userData.Litres = Double(selectedValue)
                        naviagateToSettingsView = false}
                    label: {
                        Image(systemName: "waterbottle.fill")
                            .foregroundStyle(.green.opacity(0.7))
                    }
                    .clipShape(Circle())
                    .frame(width: 30)
                    .foregroundStyle(.white)
                    .offset(x: 80, y: 60)
                
            }
            ZStack{
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(Color.green.gradient)
                    .opacity(0.2)
            }
        }
        .tabViewStyle(.verticalPage(transitionStyle: .blur))
    }
}

#Preview {
    SettingsView(naviagateToSettingsView: .constant(true))
}
