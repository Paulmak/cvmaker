//
//  SalaryFormatter.swift
//  cvmaker
//
//  Created by Pavel on 26.10.2025.
//

import UIKit

final class SalaryFormatter {
    
    static func formatted(_ amount: Int) -> String {
        "\(amount.formatted(.number.grouping(.automatic))) ₽"
    }
}
