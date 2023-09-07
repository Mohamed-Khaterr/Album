//
//  ProfileViewController.swift
//  Album
//
//  Created by Khater on 07/09/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}


// MARK: - UITableView DataSource
extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "albumNameCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Test"
        return cell
    }
}

// MARK: - UITableView Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let albumDetailsVC = storyboard?.instantiateViewController(withIdentifier: AlbumDetailsViewController.storyboardIdentifier) as? AlbumDetailsViewController else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        navigationController?.pushViewController(albumDetailsVC, animated: true)
    }
}
