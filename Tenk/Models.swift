//
//  Models.swift
//  Tenk
//
//  Created by Charel Felten on 26/11/2023.
//

import Foundation

struct Profile: Codable {
    let username: String?
    let fullName: String?
    let website: String?
    
    // Note: codingkeys is basically for each property (e.g. fullName) what the
    // name of the JSON key that it is (de-)serialised to, here fullName -> full_name and vice versa
    enum CodingKeys: String, CodingKey {
        case username
        case fullName = "full_name"
        case website
    }
}

//struct UpdateProfileParams: Encodable {
//  let username: String
//  let fullName: String
//  let website: String
//
//  enum CodingKeys: String, CodingKey {
//    case username
//    case fullName = "full_name"
//    case website
//  }
//}
