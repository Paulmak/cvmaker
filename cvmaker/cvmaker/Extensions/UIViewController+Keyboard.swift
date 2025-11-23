//
//  UIViewController+Keyboard.swift
//  cvmaker
//
//  Created by Pavel on 31.10.2025.
//

import UIKit

extension UIViewController {
    
    func enableKeyboardDismissOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
