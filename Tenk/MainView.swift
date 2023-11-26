//
//  MainView.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import SwiftUI
import Charts

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    var antiPrimary: Color { colorScheme == .light ? Color.white : Color.black }
    
    @ObservedObject var core: Core
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
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
            .onTapGesture {
                core.fetchStepCountData()
            }
//            
            Spacer()
            
        }.background(BackgroundView())
    }
}

#Preview {
    MainView(core: Core())
}
