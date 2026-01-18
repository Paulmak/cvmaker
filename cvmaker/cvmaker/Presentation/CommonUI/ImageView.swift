//
//  ImageView.swift
//  cvmaker
//
//  Created by Pavel on 04.10.2025.
//

import UIKit

final class ImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        clipsToBounds = true
    }
    
    private func configureImageView() {
        image = UIImage(named: "male")
        contentMode = .scaleAspectFill 
        isUserInteractionEnabled = true
    }
}
