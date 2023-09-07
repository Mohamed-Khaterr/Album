//
//  JsonPlaceholderAPI.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation
import Moya


enum JsonPlaceholderAPI {
    case userInfo(id: Int)
    case albumes(userId: Int)
    case photos(albumId: Int)
    
    /// API Provider
    private var provider: MoyaProvider<Self> {
        return MoyaProvider<Self>()
    }
    
    
    /// async function to Send Request to JSON Placeholder API
    /// - Returns: Response Data
    /// - Throws: Error from Decoding Data or Error from server
    /// - Parameters:
    ///   - ofType: Repsonse Data
    func getData<ResponseType: Codable>(ofType type: ResponseType.Type) async throws -> ResponseType {
        // Converting Closure to Swift Modern Concurrency
        return try await withCheckedThrowingContinuation { continuation in
            // Send Request of selected case
            provider.request(self) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(type, from: response.data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


extension JsonPlaceholderAPI: TargetType {
    var baseURL: URL {
        if let url = URL(string: "https://jsonplaceholder.typicode.com") {
            return url
        } else {
            return URL(string: "")!
        }
    }
    
    var path: String {
        switch self {
        case .userInfo(let id):
            return "/users/\(id)"
        case .albumes(_):
            return "/albums"
        case .photos(_):
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
        }
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json; charset=UTF-8"]
    }
}
