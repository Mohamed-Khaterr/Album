//
//  Album.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation


struct Album: Codable, Hashable {
    let userId: Int
    let id: Int
    let title: String
}
