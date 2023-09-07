//
//  User.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation


struct User: Codable {
    let id: Int
    let name: String
    let address: Address
}


struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}
