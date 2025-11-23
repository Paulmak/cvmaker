//
//  HorizontalStackView.swift
//  cvmaker
//
//  Created by Pavel on 15.10.2025.
//

import UIKit

final class HorizontalStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        customizeStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeStackView() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 15
    }
    
}
