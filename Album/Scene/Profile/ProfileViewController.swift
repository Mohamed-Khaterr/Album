//
//  ProfileViewController.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import UIKit
import Combine
import CombineDataSources

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    private let viewModel = ProfileViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bind()
    }
    
    private func bind() {
        viewModel.error
            .sink { [weak self] error in
                let alert = UIAlertController(title: "Woops! Error", message: error.localizedDescription, preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Close", style: .default)
                alert.addAction(closeAction)
                self?.present(alert, animated: true)
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
        
        
        
        // MARK: - Labels
        viewModel.$user
            .sink { [weak self] name, address in
                self?.userNameLabel.text = name
                self?.addressLabel.text = address
            }
            .store(in: &cancellable)
        
        
        
        // MARK: TableView
        viewModel.$albums
            .bind(subscriber: tableView.rowsSubscriber(cellIdentifier: "albumNameCell", cellType: UITableViewCell.self, cellConfig: { cell, _, album in
                cell.textLabel?.text = album.title
            }))
            .store(in: &cancellable)
        
        
        tableView.didSelectRowPublisher
            .sink { [weak self] indexPath in
                guard let self = self else { return }
                if let albumDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: AlbumDetailsViewController.storyboardIdentifier) as? AlbumDetailsViewController {
                    albumDetailsVC.setAlbum(viewModel.albums[indexPath.row])
//                    albumDetailsVC.album.send(viewModel.albums[indexPath.row])
                    self.navigationController?.pushViewController(albumDetailsVC, animated: true)
                }
                
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            .store(in: &cancellable)
    }
}
