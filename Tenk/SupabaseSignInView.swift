//
//  SupabaseSignInView.swift
//  Tenk
//
//  Created by Charel Felten on 25/11/2023.
//

import Foundation
import SwiftUI
import AuthenticationServices
import Supabase
import GoTrue

struct SupabaseSignInView: View {
    @State var signInResult: Result<Void, Error>?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section {
                
                Button("Authorise Health Data") {
                    //                core.requestHKAuthorization()
                    print(1)
                }
                .foregroundStyle(Color.white)
                .bold()
                .listRowBackground(Color.pink)
            }
            
            
            
            Section {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    Task {
                        do {
                            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                            else {
                                return
                            }
                            
                            guard let idToken = credential.identityToken
                                .flatMap({ String(data: $0, encoding: .utf8) })
                            else {
                                return
                            }
                            try await supabase.auth.signInWithIdToken(
                                credentials: .init(
                                    provider: .apple,
                                    idToken: idToken
                                )
                            )
                            signInResult = .success(())
                        } catch {
                            signInResult = .failure(error)
                        }
                    }
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(width: 1000, height: 50)
                .listRowBackground(colorScheme == .dark ? Color.white : Color.black)
            }
        }
    }
}

#Preview {
    SupabaseSignInView()
}

