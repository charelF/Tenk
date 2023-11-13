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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
                                // immediately read the value to set it to the Core
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
        .signInWithAppleButtonStyle(.black)
        .frame(width: 200, height: 40)
    }
    
}

#Preview {
    SignInView(core: Core())
}
