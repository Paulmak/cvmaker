//
//  TextField.swift
//  cvmaker
//
//  Created by Pavel on 01.10.2025.
//

import UIKit

final class TextField: UITextField, UITextFieldDelegate {
    
    var onTextChanged: ((String?) -> Void)?
    
    private enum Constants {
        static let customHeight: CGFloat = 52
        static let cornerRadius: CGFloat = 16
        static let inset: CGFloat = 12
    }
    
    enum TextFieldType {
        case regular
        case phone
        case email
    }
    
    private let placeholderName: String
    private let textFieldType: TextFieldType
    
    init(placeholderName: String, textFieldType: TextFieldType) {
        self.placeholderName = placeholderName
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        customizeTextField()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.customHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeTextField() {
        delegate = self
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        layer.cornerRadius = Constants.cornerRadius
        layer.backgroundColor = ColorAssets.backgroundTextFieldColor.cgColor
        
        font = UIFont(name: "TTNorms-Regular", size: 16)
        textColor = ColorAssets.mainTextColor
        
        attributedPlaceholder = NSAttributedString(
            string: placeholderName,
            attributes: [
                .font: UIFont(name: "TTNorms-Regular", size: 16) ?? .systemFont(ofSize: 16, weight: UIFont.Weight(400)),
                .foregroundColor: ColorAssets.textFieldPlaceholderColor
            ]
        )
        
        // Кастомизируем клавиатуру в зависимости от типа филда.
        switch textFieldType {
        case .regular:
            keyboardType = .default
        case .phone:
            keyboardType = .numberPad
        case .email:
            keyboardType = .emailAddress
            autocapitalizationType = .none
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        .init(
            x: Constants.inset, y: 0,
            width: bounds.width - Constants.inset * 2, height: bounds.height
        )
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        .init(
            x: Constants.inset, y: 0,
            width: bounds.width - Constants.inset * 2, height: bounds.height
        )
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @objc private func textDidChange() {
            onTextChanged?(text)
        }
}
