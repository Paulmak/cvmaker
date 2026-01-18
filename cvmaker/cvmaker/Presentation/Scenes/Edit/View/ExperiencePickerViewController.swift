//
//  ExperiencePickerViewController.swift
//  cvmaker
//
//  Created by Pavel on 12.01.2026.
//

import UIKit

final class ExperiencePickerViewController: UIViewController {
    
    private let pickerView = UIPickerView()
    private let years: [Int]
    private let months: [Int]
    private var completion: ((String) -> Void)?
    
    init(years: [Int], months: [Int], completion: @escaping (String) -> Void) {
        self.years = years
        self.months = months
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .formSheet
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([done], animated: false)
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func doneTapped() {
        let selectedYear = years[pickerView.selectedRow(inComponent: 0)]
        let selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
        
        let experience: String? = {
            if selectedYear == 0 && selectedMonth == 0 { return nil }
            var result = ""
            if selectedYear > 0 { result += "\(selectedYear) \(yearWord(for: selectedYear))" }
            if selectedMonth > 0 { result += result.isEmpty ? "" : " "; result += "\(selectedMonth) мес." }
            return result
        }()
        
        completion?(experience ?? "Выбрать")
        dismiss(animated: true)
    }
    
    private func yearWord(for value: Int) -> String {
        switch value % 10 {
        case 1 where value % 100 != 11: return "год"
        case 2, 3, 4 where !(12...14).contains(value % 100): return "года"
        default: return "лет"
        }
    }
}

extension ExperiencePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { return years[row] == 0 ? "—" : "\(years[row]) лет" }
        else { return months[row] == 0 ? "—" : "\(months[row]) мес." }
    }
}
