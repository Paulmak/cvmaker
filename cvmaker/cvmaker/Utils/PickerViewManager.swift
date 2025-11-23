//
//  PickerViewManager.swift
//  cvmaker
//
//  Created by Pavel on 29.10.2025.
//

import UIKit

class PickerViewHandler: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let years: [String]
    private let months: [String]
    private var onSelect: ((String) -> Void)?
    
    init(years: [Int], months: [Int], onSelect: ((String) -> Void)? = nil) {
        
        self.years = ["—"] + years.map { "\($0)" }
        self.months = ["—"] + months.map { "\($0)" }
        self.onSelect = onSelect
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return years[row] == "—" ? "—" : "\(years[row]) лет"
        } else {
            return months[row] == "—" ? "—" : "\(months[row]) мес"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedYearStr = years[pickerView.selectedRow(inComponent: 0)]
        let selectedMonthStr = months[pickerView.selectedRow(inComponent: 1)]
        
        guard selectedYearStr != "—" || selectedMonthStr != "—" else { return }
        
        var result = ""
        
        if selectedYearStr != "—" {
            let yearValue = Int(selectedYearStr) ?? 0
            result += "\(yearValue) \(yearWord(for: yearValue))"
        }
        if selectedMonthStr != "—" {
            let monthValue = Int(selectedMonthStr) ?? 0
            if !result.isEmpty { result += " " }
            result += "\(monthValue) мес."
        }
        
        onSelect?(result)
    }
    
    private func yearWord(for value: Int) -> String {
        switch value % 10 {
        case 1 where value % 100 != 11: return "год"
        case 2, 3, 4 where !(12...14).contains(value % 100): return "года"
        default: return "лет"
        }
    }
}
