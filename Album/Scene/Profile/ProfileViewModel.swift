//
//  ProfileViewModel.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import Foundation
import Moya
import Combine


class ProfileViewModel {
    
    private let provider = MoyaProvider<JsonPlaceholderAPI>()
    
    private let userId = Int.random(in: 0...10)
    
    @Published var user: (name: String, address: String) = ("", "")
    @Published var albums: [Album] = []
    @Published var isLoading = false
    
    var error: PassthroughSubject<AppError, Never> = .init()
    
    func viewDidLoad() {
        fetchUserInfo()
        fetchUserAlbums()
    }
    
    private func fetchUserInfo() {
        isLoading = true
        provider.request(.userInfo(id: userId)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let user = try JSONDecoder().decode(User.self, from: response.data)
                    let address = "\(user.address.street), \(user.address.city), \(user.address.suite), \(user.address.zipcode)"
                    self.user = (user.name, address)
                } catch {
                    self.error.send(.decodingFailed)
                }
            case .failure(let error):
                self.error.send(.servierError(message: error.localizedDescription))
            }
        }
    }
    
    
    private func fetchUserAlbums() {
        isLoading = true
        provider.request(.albumes(userId: userId)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                do {
                    self.albums = try JSONDecoder().decode([Album].self, from: response.data)
                } catch {
                    self.error.send(.decodingFailed)
                }
            case .failure(let error):
                self.error.send(.servierError(message: error.localizedDescription))
            }
        }
    }
}
