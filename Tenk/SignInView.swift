//
//  SignInView.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import SwiftUI
import AuthenticationServices


struct SignInView: View {
    @ObservedObject var core: Core
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("First, please allow Tenk to access your Health Data. Henk will not share this data with anyone but the people you want to")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            Button("Authorise Health Data") {
                core.requestHKAuthorization()
            }
            .foregroundColor(.white)
            .font(.system(size: 19, weight: .medium))
            .bold()
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 50)
            .background(Color.pink)
            .cornerRadius(8)
            .padding(.horizontal, 40)
            
            Text("Authorization status: \(core.HKAuthorized ? "✅" : "⏳")")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.horizontal, 40)
            
            .padding(.bottom, 30)
            
            Text("Next, please sign up with Apple to create an Account with Tenk")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.horizontal, 40)
            
            
            
            
            
            
            
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                    case .success(let authResults):
                        switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let userIdentifier = appleIDCredential.user
                                let fullName = appleIDCredential.fullName
                                let email = appleIDCredential.email
                                
                                // only write on first login
                                if let email {
                                    let localUser: LocalUser
                                    if let pnc: PersonNameComponents = fullName {
                                        localUser = LocalUser(identifier: userIdentifier, email: email, name: pnc)
                                    } else {
                                        // its possible user doesnt want to share their name
                                        localUser = LocalUser(identifier: userIdentifier, email: email, name: PersonNameComponents())
                                    }
                                    do {
                                        let encodedUser = try PropertyListEncoder().encode(localUser)
                                        UserDefaults.standard.set(encodedUser, forKey: "localUser")
                                    } catch let error {
                                        print("Error in signIn", error.localizedDescription)
                                    }
                                }
                                
                                // sign in (doesnt need to be first login)
                                UserDefaults.standard.set(true, forKey: "signedIn")
                                core.retrieveUser()
                            default:
                                break
                        }
                    case .failure(let error):
                        print("Authorisation failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .padding(.horizontal, 40)
            .frame(maxHeight: 50)
        }
    }
    
}

#Preview {
    SignInView(core: Core())
}
