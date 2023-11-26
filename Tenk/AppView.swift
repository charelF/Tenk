//
//  AppView.swift
//  Tenk
//
//  Created by Charel Felten on 26/11/2023.
//

import SwiftUI
import Supabase

struct AppView: View {
    @State var isNotSignedIn = true
    @ObservedObject var core: Core
    
    var body: some View {
        TabView {
            MainView(core: core)
                .tabItem {Label("Tenk", systemImage: "chart.bar.fill")}
            ProfileView()
                .tabItem {Label("Profile", systemImage: "person.crop.circle")}
        }
        .sheet(isPresented: $isNotSignedIn) {
            SupabaseSignInView()
                .interactiveDismissDisabled()
        }
        .task {
            for await state in await supabase.auth.authStateChanges {
                print("state event", state.event)
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isNotSignedIn = state.session == nil
                }
            }
        }
    }
}

#Preview {
    AppView(core: Core())
}
