//
//  TappableButton.swift
//  cvmaker
//
//  Created by Pavel on 29.11.2025.
//

import UIKit

class TappableButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TappableButton {
    
    func addTapAnimation() {
        addTarget(self, action: #selector(animateTap), for: .touchUpInside)
    }
    
    @objc private func animateTap() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut]
        ) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        } completion: { _ in
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                options: [.curveEaseInOut]
            ) {
                self.transform = .identity
                self.alpha = 1.0
            }
        }
    }
}
