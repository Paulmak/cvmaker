//
//  PickerViewManager.swift
//  cvmaker
//
//  Created by Pavel on 29.10.2025.
//

import UIKit

final class ExperiencePickerManager {
    
    private weak var presenter: UIViewController?
    private let years: [Int]
    private let months: [Int]
    
    init(presenter: UIViewController, maxYears: Int = 80, maxMonths: Int = 11) {
        self.presenter = presenter
        self.years = Array(0...maxYears)
        self.months = Array(0...maxMonths)
    }
    
    func show(completion: @escaping (String) -> Void) {
        let pickerVC = ExperiencePickerViewController(years: years, months: months, completion: completion)
        presenter?.present(pickerVC, animated: true)
    }
}
