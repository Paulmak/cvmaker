//
//  StackView.swift
//  cvmaker
//
//  Created by Pavel on 17.11.2025.
//

import UIKit

extension UIStackView {
    func setArrangedSubview(_ view: UIView, hidden: Bool) {
        if hidden {
            if self.arrangedSubviews.contains(view) {
                self.removeArrangedSubview(view)
                view.isHidden = true
            }
        } else {
            if !self.arrangedSubviews.contains(view) {
                self.addArrangedSubview(view)
            }
            view.isHidden = false
        }
    }
}
