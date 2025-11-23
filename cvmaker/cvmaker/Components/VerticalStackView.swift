//
//  StackView.swift
//  cvmaker
//
//  Created by Pavel on 01.10.2025.
//

import UIKit

final class VerticalStackView: UIStackView {
    
    enum StackViewType {
        case main
        case group
        case keyValue
    }
    
    private let verticalStackViewType: StackViewType
    
    init(for verticalStackViewType: StackViewType) {
        self.verticalStackViewType = verticalStackViewType
        super.init(frame: .zero)
        customizeStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeStackView() {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        switch verticalStackViewType {
        case .main:
            spacing = 30
        case .group:
            spacing = 15
        case .keyValue:
            spacing = 5
        }
    }
}
