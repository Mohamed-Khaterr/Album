//
//  AlbumDetailsViewController.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    
    static let storyboardIdentifier = "AlbumDetailsViewController"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Album Details"
    }
}
