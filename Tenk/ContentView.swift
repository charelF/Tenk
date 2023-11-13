//
//  ContentView.swift
//  Tenk
//
//  Created by Charel Felten on 08/11/2023.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var core: Core
    
    var body: some View {
        TabView {
            MainView(core: core)
                .tabItem {Label("Tenk", systemImage: "chart.bar.fill")}
            AboutView(core: core)
                .tabItem {Label("About", systemImage: "info.circle.fill")}
        }
        .sheet(isPresented: $core.notSignedIn) {
            SignInView(core: core)
            .interactiveDismissDisabled()
        }
    }
    
    
    
}

#Preview {
    ContentView(core: Core())
}

