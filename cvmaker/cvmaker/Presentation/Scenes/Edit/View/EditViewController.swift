//
//  ViewController.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

protocol EditViewControllerProtocol: AnyObject {
    func present(profile: ProfileModel, avatar: UIImage?)
    func presentImageActions()
    func resetToEmptyState()
    func presentPreview()
    func setDeleteButtonVisible(_ isVisible: Bool)
    func setAvatarImage(_ image: UIImage?)
}

final class EditViewController: UIViewController {
    
    private let editView = EditView()
    private let rightBarItemButton = ActionButton()
    private let interactor: EditInteractorProtocol
    
    private lazy var datePickerManager = DatePickerManager(presenter: self)
    private lazy var experiencePickerManager = ExperiencePickerManager(presenter: self)
    private lazy var avatarProvider = AvatarProvider(presenter: self)
    
    init(interactor: EditInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTargets()
        enableKeyboardDismissOnTap()
        interactor.start()
    }
    
    override func loadView() {
        view = editView
        editView.delegate = self
    }
    
    private func configureTargets() {
        rightBarItemButton.addTarget(self, action: #selector(deleteCV), for: .touchUpInside)
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Резюме"
        rightBarItemButton.setTitle("Удалить", for: .normal)
    }
    
    @objc private func salaryChanged(_ sender: UISlider) {
        let value = sender.value
        interactor.update(\.salary, value: value)
    }
    
    @objc private func jobStatusChanged(_ sender: UISwitch) {
        interactor.update(\.isOpenToOffers, value: sender.isOn)
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
        interactor.didTapClearButton()
    }
}

extension EditViewController: EditViewDelegate {
    
    func editView<T>(_ view: EditView, didUpdate keyPath: WritableKeyPath<ProfileModel, T?>, value: T?) {
        interactor.update(keyPath, value: value)
    }
    
    func editViewDidTapChooseImage(_ view: EditView) {
        interactor.didTapAvatarImage()
    }
    
    func editViewDidTapChooseDate(_ view: EditView) {
        datePickerManager.show { [weak self] date in
            self?.interactor.update(\.birthdate, value: date)
        }
    }
    
    func editViewDidTapChooseExperience(_ view: EditView) {
        experiencePickerManager.show { [weak self] selected in
            self?.interactor.update(\.experience, value: selected)
        }
    }
    
    func editViewDidTapPreview(_ view: EditView) {
        interactor.didTapPresentButton()
    }
}

extension EditViewController: EditViewControllerProtocol {
    
    func present(profile: ProfileModel, avatar: UIImage?) {
        editView.setProfile(with: profile, avatar: avatar)
    }
    
    func setAvatarImage(_ image: UIImage?) {
        editView.setAvatarImage(image)
    }
    
    func presentImageActions() {
        avatarProvider.presentImageMenu(
            currentImage: editView.currentAvatarImage,
            isDefaultAvatar: editView.isDefaultAvatar
        ) { [weak self] image in
            guard let self else { return }
            self.interactor.didSelectAvatarImage(image)
        }
    }
    
    func resetToEmptyState() {
        let emptyProfile = ProfileModel()
        editView.setProfile(with: emptyProfile, avatar: nil)
        setDeleteButtonVisible(false)
    }
    
    func presentPreview() {
        let previewVC = PreviewBuilder.build()
        present(previewVC, animated: true)
    }
    
    func setDeleteButtonVisible(_ isVisible: Bool) {
        if isVisible {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                customView: rightBarItemButton
            )
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
}
