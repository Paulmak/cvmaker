//
//  SphereView.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class SphereView: UIView {
    
    private enum Constants {
        static let customHeight: CGFloat = 112
        static let cornerRadius: CGFloat = 12
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        customizeSphereView()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.customHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSphereView() {
        backgroundColor = ColorAssets.backgroundSphereColor
        layer.cornerRadius = Constants.cornerRadius
    }
}
