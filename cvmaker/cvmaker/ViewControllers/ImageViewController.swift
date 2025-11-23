//
//  ImageViewController.swift
//  cvmaker
//
//  Created by Pavel on 08.11.2025.
//

import UIKit

final class ImageViewController: UIViewController {
    
    let detailImageView = DetailImageView()
    var image: UIImage?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = detailImageView
    }
    
    private func setupImage() {
        detailImageView.detailImage.image = image
    }
}
