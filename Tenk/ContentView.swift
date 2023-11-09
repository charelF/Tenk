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
    @StateObject var core = Core()
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Request HealthKit Authorization") {
                core.requestHKAuthorization()
            }
            
            Button("Fetch Step Count") {
                core.fetchStepCountData()
            }
            Chart {
                ForEach(core.steps, id: \.date) { sq in
                    LineMark(
                        x: .value("Index", sq.date),
                        y: .value("Value", sq.count)
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
