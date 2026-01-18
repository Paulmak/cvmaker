//
//  Switch.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class Switch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        customizeSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 51, height: 31)
    }
    
    private func customizeSwitch() {
        onTintColor = .red
    }
    
}
