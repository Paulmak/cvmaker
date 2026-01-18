//
//  TextView.swift
//  cvmaker
//
//  Created by Pavel on 27.10.2025.
//

import UIKit

final class TextView: UITextView, UITextViewDelegate {
    
    var onTextChanged: ((String?) -> Void)?
    private let placeholderLabel = UILabel()
    private let mode: Mode
    
    private enum Constants {
        static let customHeight: CGFloat = 52
        static let cornerRadius: CGFloat = 16
    }
    
    enum Mode {
        case editable(placeholder: String)
        case preview
    }
    
    init(with mode: Mode) {
        self.mode = mode
        super.init(frame: .zero, textContainer: nil)
        customizeTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func customizeTextView() {
        layer.cornerRadius = Constants.cornerRadius
        delegate = self
        font = UIFont(name: "TTNorms-Regular", size: 16)
        textColor = ColorAssets.mainTextColor
        
        switch mode {
        case .editable(let placeholder):
            backgroundColor = ColorAssets.backgroundTextFieldColor
            isScrollEnabled = false
            textContainerInset = UIEdgeInsets(top: 15, left: 8, bottom: 8, right: 8)
            customizePlaceholder(placeholder: placeholder)
        case .preview:
            backgroundColor = .clear
            textContainerInset = .zero
            isEditable = false
            isScrollEnabled = false
            isSelectable = false
        }
    }
    
    private func customizePlaceholder(placeholder: String) {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = ColorAssets.textFieldPlaceholderColor
        placeholderLabel.font = UIFont(name: "TTNorms-Regular", size: 16)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        invalidateIntrinsicContentSize()
        onTextChanged?(text)
    }
    
    override var intrinsicContentSize: CGSize {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        
        switch mode {
        case .editable:
            let height = max(size.height, Constants.customHeight)
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        case .preview:
            return CGSize(width: UIView.noIntrinsicMetric, height: size.height)
        }
        
        func updateSize() {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}
