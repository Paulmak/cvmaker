//
//  BirthDateFormatter.swift
//  cvmaker
//
//  Created by Pavel on 08.11.2025.
//

import UIKit

final class BirthDateFormatter {
    
    static func format(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        
        guard let years = ageComponents.year else { return "" }
        
        let lastDigit = years % 10
        let lastTwoDigits = years % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(years) лет"
        }
        
        switch lastDigit {
        case 1:
            return "\(years) год"
        case 2,3,4:
            return "\(years) года"
        default:
            return "\(years) лет"
        }
    }
}
