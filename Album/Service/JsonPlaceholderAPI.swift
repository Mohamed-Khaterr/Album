//
//  JsonPlaceholderAPI.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation
import Combine
import Moya


enum JsonPlaceholderAPI {
    case userInfo(id: Int)
    case albumes(userId: Int)
    case photos(albumId: Int)
    case photoSearch(photoTitle: String)
}


extension JsonPlaceholderAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .userInfo(let id):
            return "/users/\(id)"
        case .albumes(_):
            return "/albums"
        case .photos(_), .photoSearch(_):
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .userInfo(_):
            return .requestPlain
        case .albumes(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .photos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        case .photoSearch(let photoTitle):
            return .requestParameters(parameters: ["title": photoTitle], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json; charset=UTF-8"]
    }
}
