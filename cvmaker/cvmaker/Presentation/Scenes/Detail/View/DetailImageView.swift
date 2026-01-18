//
//  DetailImageView.swift
//  cvmaker
//
//  Created by Pavel on 08.11.2025.
//

import UIKit

final class DetailImageView: UIView {
    
    lazy var detailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorAssets.backgroundVcColor
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        addSubview(detailImage)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            detailImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
