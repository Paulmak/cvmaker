//
//  Label.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class Label: UILabel {
    
    enum LabelTypes {
        case medium
        case regular
        case large
        case customLabel(
            labelTextName: String,
            labelSize: CGFloat
        )
    }
    
    private let labelType: LabelTypes
    
    init(labelType: LabelTypes) {
        self.labelType = labelType
        super.init(frame: .zero)
        customizeLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeLabel() {
        
        textColor = ColorAssets.mainTextColor
        
        switch labelType {
        case .large:
            font = UIFont(name: "TTNorms-Bold", size: 20)
        case .medium:
            font = UIFont(name: "TTNorms-Medium", size: 16)
        case .regular:
            font = UIFont(name: "TTNorms-Regular", size: 16)
        case .customLabel(let labelTextName, let labelSize):
            font = UIFont(name: labelTextName, size: labelSize)
        }
    }
}
