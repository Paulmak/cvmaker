//
//  ViewController.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

final class EditViewController: UIViewController {
    
    private enum Constants {
        static let defaultSalary: Float = 60000
        static let defaultGenderIndex = 0
        static let defaultJobStatus = false
        static let defaultButtonTitle = "Выбрать"
    }
    
    private let editView = EditView()
    private let rightBarItemButton = ActionButton()
    
    private lazy var datePickerManager = DatePickerManager(presenter: self)
    private lazy var avatarProvider = AvatarProvider(presenter: self)
    
    private var experiencePickerHandler: PickerViewHandler?
    private var experiencePickerTextField: UITextField?
    private var viewModel: EditViewModel = .empty()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTargets()
        setupStateObserver()
        
        enableKeyboardDismissOnTap()
        
        editView.delegate = self
        
        loadProfile()
        updateDeleteButtonVisibility()
    }
    
    override func loadView() {
        view = editView
    }
    
    private func setupStateObserver() {
        ProfileStateManager.shared.onProfileDataChanged = { [weak self] hasData in
            DispatchQueue.main.async {
                guard let navItemButton = self?.rightBarItemButton else { return }
                self?.navigationItem.rightBarButtonItem = hasData ? UIBarButtonItem(customView: navItemButton) : nil
            }
        }
    }
    
    private func configureTargets() {
        rightBarItemButton.addTarget(self, action: #selector(deleteCV), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Резюме"
        rightBarItemButton.setTitle("Удалить", for: .normal)
    }
    
    private func updateDeleteButtonVisibility() {
        let hasData = ProfileStorage.shared.hasAnyData()
        navigationItem.rightBarButtonItem = hasData ? UIBarButtonItem(customView: rightBarItemButton) : nil
    }
    
    @objc
    func deleteCV() {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить резюме?",
                                      message: "Все локальные данные будут безвозвратно стерты",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .default) { [weak self] _ in
            self?.performProfileDeletion()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
    }
    
    private func performProfileDeletion() {
        ProfileStorage.shared.clearAllData()
        resetUIToDefault()
        updateDeleteButtonVisibility()
    }
    
    private func resetUIToDefault() {
        viewModel = .empty()
        editView.configure(with: viewModel)
        editView.validateForm()
    }
    
    private func updateProfile(_ profile: ProfileModel) {
        viewModel = EditViewModel(profile: profile, avatarImage: viewModel.avatarImage)
        ProfileStorage.shared.saveProfile(profile)
        ProfileStateManager.shared.notifyDataChanged()
    }
    
    private func presentDatePicker() {
        datePickerManager.show { [weak self] selectedDate in
            guard let self = self else { return }
            var updatedProfile = self.viewModel.profile
            updatedProfile.birthdate = selectedDate
            self.updateProfile(updatedProfile)
            self.updateDateButton(with: selectedDate)
        }
    }
    
    private func updateDateButton(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        let formattedDate = formatter.string(from: date)
        editView.setValue(.birthdate(formattedDate))
    }
    
    private func showExperiencePicker() {
        let years = Array(1...80)
        let months = Array(1...11)
        
        if experiencePickerTextField == nil {
            experiencePickerTextField = UITextField(frame: .zero)
            view.addSubview(experiencePickerTextField!)
        }
        
        let picker = PickerView()
        experiencePickerHandler = PickerViewHandler(years: years, months: months) { [weak self] selected in
            guard let self = self else { return }
            var updatedProfile = self.viewModel.profile
            updatedProfile.experience = selected
            self.updateProfile(updatedProfile)
            editView.setValue(.experience(selected))
        }
        picker.delegate = experiencePickerHandler
        picker.dataSource = experiencePickerHandler
        
        experiencePickerTextField?.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Constants.defaultButtonTitle, style: .done, target: self, action: #selector(dismissPicker))
        toolbar.setItems([doneButton], animated: false)
        experiencePickerTextField?.inputAccessoryView = toolbar
        
        experiencePickerTextField?.becomeFirstResponder()
    }
    
    private func loadProfile() {
        viewModel = .fromStorage()
        editView.configure(with: viewModel)
    }
    
    private func saveDefaultValues() {
        saveProfileChanges { profile in
            if profile.genderIndex == nil {
                profile.genderIndex = Constants.defaultGenderIndex
            }
            if profile.salary == nil {
                profile.salary = Constants.defaultSalary
                profile.salaryLabel = SalaryFormatter.formatted(Int(Constants.defaultSalary))
            }
            if profile.isOpenToOffers == nil {
                profile.isOpenToOffers = Constants.defaultJobStatus
            }
        }
    }
    
    private func saveProfileChanges(_ update: (inout ProfileModel) -> Void) {
        var updatedProfile = viewModel.profile
        update(&updatedProfile)
        
        viewModel = EditViewModel(profile: updatedProfile, avatarImage: viewModel.avatarImage)
        ProfileStorage.shared.saveProfile(updatedProfile)
        ProfileStateManager.shared.notifyDataChanged()
    }
    
    @objc private func dismissPicker() {
        view.endEditing(true)
        experiencePickerHandler = nil
    }
}

extension EditViewController: EditViewDelegate {
    
    func editView(_ view: EditView, didUpdateField field: FieldType) {
        saveProfileChanges { profile in
            switch field {
            case .firstName(let text):
                profile.firstName = text
            case .lastName(let text):
                profile.lastName = text
            case .patronymic(let text):
                profile.patronymic = text
            case .hobbies(let text):
                profile.hobbies = text
            case .phone(let text):
                profile.phone = text
            case .mailbox(let text):
                profile.email = text
            case .telegram(let text):
                profile.telegram = text
            case .specialization(let text):
                profile.specialization = text
            case .hardSkills(let text):
                profile.hardSkills = text
            case .gender(let index):
                profile.genderIndex = index
            case .jobStatus(let isOn):
                profile.isOpenToOffers = isOn
            case .salary(let amount, let label):
                profile.salary = amount
                profile.salaryLabel = label
            case .birthdate, .experience, .avatar:
                break
            }
        }
    }
    
    func editViewDidTapChooseImage(_ view: EditView) {
        avatarProvider.presentImageMenu(
            currentImage: view.imageView.image,
            isDefaultAvatar: view.isDefaultAvatar
        ) { [weak self] image in
            guard let self = self else { return }
            
            ProfileStorage.shared.saveAvatar(image)
            
            self.editView.setAvatarImage(image)
            
            self.viewModel = EditViewModel(
                profile: self.viewModel.profile,
                avatarImage: image
            )
            
            ProfileStateManager.shared.notifyDataChanged()
        }
    }
    
    func editViewDidTapChooseDate(_ view: EditView) {
        presentDatePicker()
    }
    
    func editViewDidTapChooseExperience(_ view: EditView) {
        showExperiencePicker()
    }
    
    func editViewDidTapPreview(_ view: EditView) {
        saveDefaultValues()
        let previewVC = PreviewViewController()
        navigationController?.present(previewVC, animated: true)
    }
}
