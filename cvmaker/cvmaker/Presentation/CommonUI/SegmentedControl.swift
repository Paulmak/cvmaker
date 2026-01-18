//
//  SegmentedControl.swift
//  cvmaker
//
//  Created by Pavel on 01.10.2025.
//

import UIKit

final class SegmentedControl: UISegmentedControl {
    
    init() {
        super.init(items: ["Мужчина", "Женщина"])
        customizeSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeSegmentedControl() {
        selectedSegmentIndex = 0
        selectedSegmentTintColor = ColorAssets.selectedSegmentIndicatorColor
        backgroundColor = ColorAssets.backgroundSegmentControlColor
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        setTitleTextAttributes([
            .foregroundColor: ColorAssets.mainTextColor,
            .font: UIFont(name: "SFProText-Semibold", size: 13) ?? .systemFont(ofSize: 13, weight: UIFont.Weight(600)),
        ], for: .selected)
        
        setTitleTextAttributes([
            .foregroundColor: ColorAssets.mainTextColor,
            .font: UIFont(name: "SFProText-Medium", size: 13) ?? .systemFont(ofSize: 13, weight: UIFont.Weight(500)),
        ], for: .normal)
        
    }
}
