//
//  PreviewButton.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class PreviewButton: TappableButton {
    
    private enum Constants {
        static let buttonHeight: CGFloat = 52
    }
    
    enum CustomButtonType {
        case enabled
        case disabled
    }
    
    private let customButtonType: CustomButtonType
    
    init(customButtonType: CustomButtonType) {
        self.customButtonType = customButtonType
        super.init(frame: .zero)
        configureButton()
        addTapAnimation()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.buttonHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        titleLabel?.font = UIFont(name: "TTNorms-Medium", size: 16)
        setTitleColor(ColorAssets.mainTextColor, for: .normal)
        backgroundColor = ColorAssets.previewButtonColor
        layer.cornerRadius = 16
        if customButtonType == .disabled {
            isEnabled = false
            alpha = 0.5
        }
    }
}
