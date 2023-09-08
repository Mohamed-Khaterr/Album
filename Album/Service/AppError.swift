//
//  AppError.swift
//  Album
//
//  Created by Khater on 08/09/2023.
//

import Foundation


enum AppError: LocalizedError {
    case decodingFailed
    case servierError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .decodingFailed: return "Sorry, Can't read response correctly"
        case .servierError(let message): return message
        }
    }
}
