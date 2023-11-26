//
//  AppView.swift
//  Tenk
//
//  Created by Charel Felten on 26/11/2023.
//

import SwiftUI
import Supabase

struct AppView: View {
  @State var isAuthenticated = false

  var body: some View {
    Group {
      if isAuthenticated {
        ProfileView()
      } else {
        SupabaseSignInView()
      }
    }
    .task {
        for await state in await supabase.auth.authStateChanges {
            print("state event", state.event)
        if [.initialSession, .signedIn, .signedOut].contains(state.event) {
          isAuthenticated = state.session != nil
        }
      }
    }
  }
}

#Preview {
    AppView()
}
