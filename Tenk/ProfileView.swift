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
    
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent {
                        TextField("...", text: $username)
                            .textContentType(.username)
                            .textInputAutocapitalization(.never)
                            .monospaced()
                            .bold()
                            .disableAutocorrection(true)
                    } label: {
                        Text("Username:")
                            .foregroundStyle(Color.secondary)
                            
                    }
                    LabeledContent {
                        TextField("...", text: $fullName)
                            .textContentType(.name)
                            .bold()
                            .disableAutocorrection(true)
                    } label: {
                        Text("Name:")
                            .foregroundStyle(Color.secondary)
                    }
                    LabeledContent {
                        TextField("...", text: $website)
                            .textContentType(.URL)
                            .textInputAutocapitalization(.never)
                            .bold()
                            .disableAutocorrection(true)
                    } label: {
                        Text("Website:")
                            .foregroundStyle(Color.secondary)
                    }
                    HStack {
                        if isLoading {
                            ProgressView()
                                .padding(.trailing, 4)
                        }
                        
                        Button("Save Changes") {
                            updateProfileButtonTapped()
                        }
                        .bold()
                    }
                }
                
                Section {
                    Button("Sign out", role: .destructive) {
                        Task {
                            try? await supabase.auth.signOut()
                        }
                    }
                    .bold()
                } footer: {
                    Text("If you sign out, you will have to sign in again next time you open the app. Your data will remain safely stored.")
                }
                
                Section {
                    Button("Delete Account", role: .destructive) {
                        Task {
                            try? await supabase.auth.signOut()
                            // TODO!!
                            // TODO!!
                            // TODO!!
                            // TODO!!
                        }
                    }
                    .bold()
                } footer: {
                    Text("If you delete your account, you will be have to make a new account when you launch the app again. Your data will be deleted from our servers.")
                }
            }
            .navigationTitle("Profile")
            .refreshable { await getInitialProfile() }
        }
        .task { await getInitialProfile() }
    }
    
    func getInitialProfile() async {
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
