//
//  DatePicker.swift
//  cvmaker
//
//  Created by Pavel on 29.10.2025.
//

import UIKit

final class DatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDatePicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDatePicker() {
        datePickerMode = .date
        preferredDatePickerStyle = .wheels
        locale = Locale(identifier: "ru_RU")
        maximumDate = Date()
    }
}

