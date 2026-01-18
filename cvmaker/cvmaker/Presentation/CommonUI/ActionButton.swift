//
//  RightBarButtonItemButton.swift
//  cvmaker
//
//  Created by Pavel on 04.10.2025.
//

import UIKit

final class ActionButton: TappableButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        addTapAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 16)
        setTitleColor(ColorAssets.actionButtonColor, for: .normal)
    }
}
