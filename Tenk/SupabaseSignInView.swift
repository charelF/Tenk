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
    
    
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://rtbdzflkfveoqjujqwhf.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0YmR6ZmxrZnZlb3FqdWpxd2hmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA3Njc2NTgsImV4cCI6MjAxNjM0MzY1OH0.tilSElyuv8bC3Z6Ki_Apysu2CK-b6ayUavP1blg2jTY"
    )

    var body: some View {
        VStack {
            Text("Supabase").font(.title).bold()
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
                        try await client.auth.signInWithIdToken(
                            credentials: .init(
                                provider: .apple,
                                idToken: idToken
                            )
                        )
                        
                    } catch {
                        dump(error)
                    }
                }
            }
            .fixedSize()
        }
    }
}

#Preview {
    SupabaseSignInView()
}

