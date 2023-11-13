//
//  AboutView.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import SwiftUI

struct AboutView: View {
    @ObservedObject var core: Core
    
    var body: some View {
        List{
            Text("ID: \(core.localUser?.identifier ?? "")")
            Text("Email: \(core.localUser?.email ?? "")")
            Text("Name: \(fn(core.localUser?.name ?? PersonNameComponents()))")
        
            Button("Sign Out") {
                core.signOut()
            }
        }
    }
    
    private func fn(_ nameComponents: PersonNameComponents) -> String {
        let formatter = PersonNameComponentsFormatter()
        formatter.style = .default
        return formatter.string(from: nameComponents)
    }
}

#Preview {
    AboutView(core: Core())
}
