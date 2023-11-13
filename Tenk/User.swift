//
//  User.swift
//  Tenk
//
//  Created by Charel Felten on 11/11/2023.
//

import Foundation
import SwiftData

@Model
class User {
    var id: String
    var email: String
    var fullname: PersonNameComponents
    
    init(id: String, email: String, fullname: PersonNameComponents) {
        self.id = id
        self.email = email
        self.fullname = fullname
    }
}


