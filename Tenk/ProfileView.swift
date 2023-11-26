//
//  ProfileView.swift
//  Tenk
//
//  Created by Charel Felten on 26/11/2023.
//

import SwiftUI
import Supabase

struct ProfileView: View {
  @State var username = ""
  @State var fullName = ""
  @State var website = ""
  @State var profile: Profile = Profile(username: nil, fullName: nil, website: nil)

  @State var isLoading = false

  var body: some View {
    NavigationStack {
      Form {
        Section {
        
          TextField("Username", text: $username)
            .textContentType(.username)
            .textInputAutocapitalization(.never)
          TextField("Full name", text: $fullName)
            .textContentType(.name)
          TextField("Website", text: $website)
            .textContentType(.URL)
            .textInputAutocapitalization(.never)
            LabeledContent {
              TextField("Name", text: $username)
            } label: {
              Text("Name")
            }
        }

        Section {
          Button("") {
            updateProfileButtonTapped()
          }
          .bold()

          if isLoading {
            ProgressView()
          }
        }
      }
      .navigationTitle("Profile")
      .toolbar(content: {
        ToolbarItem(placement: .topBarLeading){
          Button("Sign out", role: .destructive) {
            Task {
              try? await supabase.auth.signOut()
            }
          }
        }
      })
    }
    .task {
      await getInitialProfile()
    }
  }

  func getInitialProfile() async {
      print("in getInitialProfile")
    do {
      let currentUser = try await supabase.auth.session.user

      let profile: Profile = try await supabase.database
        .from("profiles")
        .select()
        .eq("id", value: currentUser.id)
        .single()
        .execute()
        .value

      self.username = profile.username ?? ""
      self.fullName = profile.fullName ?? ""
      self.website = profile.website ?? ""

    } catch {
        print("in catch")
      debugPrint(error)
    }
  }

  func updateProfileButtonTapped() {
    Task {
      isLoading = true
      defer { isLoading = false }
      do {
        let currentUser = try await supabase.auth.session.user

        try await supabase.database
          .from("profiles")
          .update(
            Profile(
              username: username,
              fullName: fullName,
              website: website
            )
          )
          .eq("id", value: currentUser.id)
          .execute()
      } catch {
        debugPrint(error)
      }
    }
  }
}

#Preview {
    ProfileView()
}
