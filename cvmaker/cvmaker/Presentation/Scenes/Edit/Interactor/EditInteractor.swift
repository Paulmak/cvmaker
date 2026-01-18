//
//  EditInteractor.swift
//  cvmaker
//
//  Created by Pavel on 17.11.2025.
//

import UIKit

protocol EditInteractorProtocol {
    
    func start()
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, value: T?)
    func didTapAvatarImage()
    func didSelectAvatarImage(_ image: UIImage?)
    func didTapClearButton()
    func updateDeleteButtonVisibility()
    func didTapPresentButton()
}

final class EditInteractor: EditInteractorProtocol {
    
    private let profileUseCase: ProfileUseCaseProtocol
    private let editPresenter: EditPresenterProtocol
    
    init(
        profileUseCase: ProfileUseCaseProtocol,
        presenter: EditPresenterProtocol
    ) {
        self.profileUseCase = profileUseCase
        self.editPresenter = presenter
    }
    
    func start() {
        let profile = profileUseCase.loadProfile()
        let hasData = profileUseCase.hasAnyData
        let avatar = profileUseCase.loadAvatar()
        editPresenter.present(profile: profile, avatar: avatar)
        editPresenter.presentDeleteButton(isVisible: hasData)
    }
    
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, value: T?) {
        profileUseCase.update(keyPath, with: value)
        let profile = profileUseCase.loadProfile()
        let hasAnyData = profileUseCase.hasAnyData
        let avatar = profileUseCase.loadAvatar()
        editPresenter.present(profile: profile, avatar: avatar)
        editPresenter.presentDeleteButton(isVisible: hasAnyData)
    }
    
    func didTapAvatarImage() {
        editPresenter.presentImageActions()
    }
    
    func didSelectAvatarImage(_ image: UIImage?) {
        profileUseCase.saveAvatar(image: image)

        let profile = profileUseCase.loadProfile()
        let avatar = profileUseCase.loadAvatar()
        editPresenter.present(profile: profile, avatar: avatar)
        editPresenter.presentDeleteButton(isVisible: profileUseCase.hasAnyData)
    }
    
    func didTapClearButton() {
        profileUseCase.clearProfile()
        editPresenter.presentEmptyState()
        editPresenter.presentDeleteButton(isVisible: false)
    }
    
    func updateDeleteButtonVisibility() {
        let hasData = profileUseCase.hasAnyData
        editPresenter.presentDeleteButton(isVisible: hasData)
    }
    
    func didTapPresentButton() {
        editPresenter.presentPreviewScreen()
    }
}
