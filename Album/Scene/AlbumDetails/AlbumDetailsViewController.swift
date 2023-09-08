//
//  AlbumDetailsViewController.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import UIKit
import Combine
import CombineDataSources
import CombineCocoa
import SDWebImage

class AlbumDetailsViewController: UIViewController {
    
    static let storyboardIdentifier = "AlbumDetailsViewController"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    private let viewModel = AlbumDetailsViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bind()
    }
    
    func setAlbum(_ album: Album) {
        viewModel.setAlbum(album)
    }
    
    private func bind() {
        viewModel.$navigationTitle
            .sink { [weak self] title in
                self?.navigationItem.title = title
            }
            .store(in: &cancellable)
        
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingActivityIndicator.startAnimating()
                } else {
                    self?.loadingActivityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellable)
        
        
        // MARK: Error Handling
        viewModel.error
            .sink { [weak self] error in
                let alert = UIAlertController(title: "Woops! Error", message: error.localizedDescription, preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .default)
                alert.addAction(closeAction)
                self?.present(alert, animated: true)
            }
            .store(in: &cancellable)
        
        
        // MARK: Search
        viewModel.bind(search: searchBar.textDidChangePublisher)
        
        viewModel.$isNoSearchResult
            .sink { [weak self] isNoResult in
                self?.noResultLabel.isHidden = !isNoResult
            }
            .store(in: &cancellable)
        
        
        // MARK: CollectionView
        viewModel.$photos
            .bind(subscriber: collectionView.itemsSubscriber(cellIdentifier: "AlbumPhotoCollectionViewCell",
                                                             cellType: AlbumPhotoCollectionViewCell.self,
                                                             cellConfig: { cell, _, photo in
                
                cell.albumPhotoImageView.sd_setImage(with: URL(string: photo.urlString),
                                                     placeholderImage: UIImage(named: "placeholder-image"))
            }))
        .store(in: &cancellable)
        
        
        collectionView.didSelectItemPublisher
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                if let photoPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: PhotoPreviewViewController.storyboardIdentifier) as? PhotoPreviewViewController {
                    photoPreviewVC.setPhoto(viewModel.photos[indexPath.row])
                    self.navigationController?.pushViewController(photoPreviewVC, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}
