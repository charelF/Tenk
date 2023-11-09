//
//  ContentView.swift
//  Tenk
//
//  Created by Charel Felten on 08/11/2023.
//

import SwiftUI
import HealthKit
import Charts

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    var antiPrimary: Color { colorScheme == .light ? Color.white : Color.black }
    @StateObject var core = Core()
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("👟 Tenk Step Count 👟").font(.title).bold()
            Chart {
                ForEach(core.cumulSteps(), id: \.date) { sq in
                    LineMark(
                        x: .value("Index", sq.date),
                        y: .value("Value", sq.count)
                    )
                    .cornerRadius(0, style: .continuous)
                    .foregroundStyle(.blue)
                }
            }
            .padding(15)
            .background(antiPrimary)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(10)
            .frame(minHeight: 0, maxHeight: 400)
            
            Button("Request HealthKit Authorization") {
                core.requestHKAuthorization()
            }
            .padding(10)
            .background(antiPrimary)
            .cornerRadius(10)
            .shadow(radius: 4)
            
            
            Button("Fetch Step Count") {
                core.fetchStepCountData()
            }
            .padding(10)
            .background(antiPrimary)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            Spacer()
            
        }.background(Color.primary.opacity(0.2))
    }
}

#Preview {
    ContentView()
}

