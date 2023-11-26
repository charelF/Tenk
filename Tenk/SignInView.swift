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
            
            

            
            
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                switch result {
                    case .success(let authResults):
                        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                            
                            let user = appleIDCredential.user
                            let fullName = appleIDCredential.fullName
                            let email = appleIDCredential.email
                                                        
                            let signedInBefore = UserDefaults.standard.bool(forKey: "signedInBefore1")
                            if !signedInBefore {
                                let localUser = LocalUser(identifier: user, email: email, name: fullName)
                                do {
                                    let encodedUser = try PropertyListEncoder().encode(localUser)
                                    UserDefaults.standard.set(encodedUser, forKey: "localUser")
                                    UserDefaults.standard.set(true, forKey: "signedInBefore1")
                                    print("did all this with success")
                                } catch let error {
                                    print("Error in signIn", error.localizedDescription)
                                }
                            }
                            UserDefaults.standard.set(true, forKey: "signedIn")
                            core.retrieveUser()
                            
//                            let 
                            
                            
                        } else {
                            print("Authorisation failed: could not get appleIDCredential")
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
