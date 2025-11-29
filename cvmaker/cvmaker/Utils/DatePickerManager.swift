//
//  DatePickerManager.swift
//  cvmaker
//
//  Created by Pavel on 29.10.2025.
//

import UIKit

final class DatePickerManager {
    
    private weak var presenter: UIViewController?
    private let datePicker = UIDatePicker()
    private var completion: ((Date) -> Void)?
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func show(completion: @escaping (Date) -> Void) {
        self.completion = completion
        
        let alert = UIAlertController(title: "Выберите дату", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.maximumDate = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -110)
        ])
        
        alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { _ in
            self.completion?(self.datePicker.date)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        let heightConstraint = NSLayoutConstraint(item: alert.view!,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 400)
        alert.view.addConstraint(heightConstraint)
        
        presenter?.present(alert, animated: true)
    }
}
