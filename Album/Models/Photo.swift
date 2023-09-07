//
//  Photo.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation


struct Photo: Codable {
    let id: Int
    let albumId: Int
    let title: String
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case id, albumId, title
        case urlString = "url"
    }
}
