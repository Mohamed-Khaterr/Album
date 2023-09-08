//
//  PhotoPreviewViewController.swift
//  Album
//
//  Created by Khater on 08/09/2023.
//

import UIKit
import SDWebImage

class PhotoPreviewViewController: UIViewController {
    static let storyboardIdentifier = "PhotoPreviewViewController"

    @IBOutlet weak var photoImageView: UIImageView!
    
    private var photo: Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        addGesture()
        setupPhotoImageView()
    }
    
    
    // MARK: - Setub View
    private func setupNavigation() {
        let shareBarButton = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareBarButtonPressed))
        navigationItem.rightBarButtonItem = shareBarButton
    }
    
    private func setupPhotoImageView() {
        photoImageView.isUserInteractionEnabled = true
        photoImageView.isMultipleTouchEnabled = true
        
        if let photo = photo {
            photoImageView.sd_setImage(with: URL(string: photo.urlString), placeholderImage: UIImage(named: "placeholder-image"))
        }
    }
    
    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoominout(_:)))
        photoImageView.addGestureRecognizer(pinchGesture)
    }
    
    
    // MARK: - Actions
    @objc private func shareBarButtonPressed() {
        guard
            let photo = photo,
//            let albumURL = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(photo.albumId)")
            let photoURL = URL(string: photo.urlString)
        else { return }
        let shareSheet = UIActivityViewController(activityItems: [photoURL], applicationActivities: nil)
        present(shareSheet, animated: true)
    }
    
    @objc private func zoominout(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        if gesture.state == .changed {
            let scale = gesture.scale
            gestureView.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
    
    // MARK: - SetPhoto
    func setPhoto(_ photo: Photo){
        self.photo = photo
    }
}
