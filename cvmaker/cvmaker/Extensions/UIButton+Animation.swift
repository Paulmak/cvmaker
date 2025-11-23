//
//  UIButton+Animation.swift
//  cvmaker
//
//  Created by Pavel on 25.10.2025.
//

import UIKit


extension UIButton {
    
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
