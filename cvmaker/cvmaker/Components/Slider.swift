//
//  Slider.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class Slider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        customizeSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSlider() {
        minimumValue = 60000
        maximumValue = 900000
        minimumTrackTintColor = ColorAssets.minimumTrackTintColor
    }
}
