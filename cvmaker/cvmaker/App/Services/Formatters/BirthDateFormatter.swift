//
//  BirthDateFormatter.swift
//  cvmaker
//
//  Created by Pavel on 08.11.2025.
//

import UIKit

final class BirthDateFormatter {
    
    static func format(_ date: Date) -> String? {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.year, .month], from: date, to: now)
        guard let years = components.year, let months = components.month else { return nil }
        
        if years == 0 && months == 0 {
            return nil
        }
        
        var parts: [String] = []
        
        if years > 0 {
            parts.append(yearString(years))
        }
        
        if months > 0 {
            parts.append(monthString(months))
        }
        
        return parts.joined(separator: " ")
    }
    
    private static func yearString(_ years: Int) -> String {
        let lastDigit = years % 10
        let lastTwoDigits = years % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(years) лет"
        }
        
        switch lastDigit {
        case 1: return "\(years) год"
        case 2,3,4: return "\(years) года"
        default: return "\(years) лет"
        }
    }
    
    private static func monthString(_ months: Int) -> String {
        switch months {
        case 1: return "\(months) месяц"
        case 2,3,4: return "\(months) месяца"
        default: return "\(months) месяцев"
        }
    }
}
