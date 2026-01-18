//
//  FormValidator.swift
//  cvmaker
//
//  Created by Pavel on 26.10.2025.
//

import UIKit

final class FormValidator {
    
    private var textFields: [UITextField]
    private var onValidityChange: ((Bool) -> Void)?
    
    private var isFormValid: Bool = false {
        didSet {
            if oldValue != isFormValid {
                onValidityChange?(isFormValid)
            }
        }
    }
    
    init(textFields: [UITextField], onValidityChange: ((Bool) -> Void)? = nil) {
        self.textFields = textFields
        self.onValidityChange = onValidityChange
        setupObservers()
    }
    
    private func setupObservers() {
        textFields.forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        validateForm()
    }
    
    private func validateForm() {
        let allFieldsFilled = textFields.allSatisfy { !($0.text?.isEmpty ?? true) }
        isFormValid = allFieldsFilled
    }
    
    func forceValidation() {
        validateForm()
    }
}
