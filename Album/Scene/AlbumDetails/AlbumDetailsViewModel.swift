//
//  AlbumDetailsViewModel.swift
//  Album
//
//  Created by Khater on 08/09/2023.
//

import Foundation
import Combine
import Moya


class AlbumDetailsViewModel {
    
    private let provider = MoyaProvider<JsonPlaceholderAPI>()
    private var request: Moya.Cancellable?
    private var photosCache = [Photo]()
    private var cancellable = Set<AnyCancellable>()
    
    @Published var navigationTitle = ""
    
    @Published var album: Album?
    
    
    @Published var photos = [Photo]() {
        didSet {
            isNoSearchResult = photos.isEmpty
        }
    }
    
    @Published var isLoading = false
    @Published var isNoSearchResult = false
    
    var error: PassthroughSubject<AppError, Never> = .init()
    
    func viewDidLoad() {
        fetchAlbumPhotos()
    }
    
    func setAlbum(_ album: Album) {
        self.album = album
        navigationTitle = album.title
    }
    
    private func fetchAlbumPhotos() {
        guard let album = album else { return }
        isLoading = true
        provider.request(.photos(albumId: album.id)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: response.data)
                    self.photos = photos
                    self.photosCache = photos
                } catch {
                    self.error.send(.decodingFailed)
                }
                
            case .failure(let error):
                self.error.send(.servierError(message: error.localizedDescription))
            }
        }
    }
    
    func bind(search: AnyPublisher<String, Never>){
        search.sink { [weak self] text in
            guard let self = self else { return }
            if text.isEmpty {
                self.photos = self.photosCache
            } else {
                // Can Search by
//                self.fetchSearchResult(text)
                self.searchUsingFilter(text)
            }
        }
        .store(in: &cancellable)
    }
    
    private func fetchSearchResult(_ text: String) {
        isLoading = true
        
        // Cancel Old request if it exists
        request?.cancel()
        
        // New request
        request = provider.request(.photoSearch(photoTitle: text)) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                do {
                    let photos = try JSONDecoder().decode([Photo].self, from: response.data)
                    self.photos = photos
                } catch {
                    self.error.send(.decodingFailed)
                }
            case .failure(let error):
                self.error.send(.servierError(message: error.localizedDescription))
            }
        }
    }
    
    private func searchUsingFilter(_ text: String){
        photos = photosCache.filter{ $0.title.lowercased().contains(text.lowercased()) }
    }
}
