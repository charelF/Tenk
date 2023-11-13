//
//  TenkApp.swift
//  Tenk
//
//  Created by Charel Felten on 08/11/2023.
//

import SwiftUI
import SwiftData

@main
struct TenkApp: App {
    @StateObject var core = Core()
    
    var body: some Scene {
        WindowGroup {
            ContentView(core: core)
        }
    }
}
