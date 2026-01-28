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
        let result = profileUseCase.loadProfile()
        editPresenter.present(
            profile: result.profile,
            avatar: result.avatar,
            deleteButtonIsVisible: result.hasAnyData
        )
    }
    
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, value: T?) {
        profileUseCase.update(keyPath, with: value)
        let result = profileUseCase.loadProfile()
        editPresenter.present(
            profile: result.profile,
            avatar: result.avatar,
            deleteButtonIsVisible: result.hasAnyData
        )
    }
    
    func didTapAvatarImage() {
        editPresenter.presentImageActions()
    }
    
    func didSelectAvatarImage(_ image: UIImage?) {
        profileUseCase.saveAvatar(image: image)

        let result = profileUseCase.loadProfile()
        editPresenter.present(
            profile: result.profile,
            avatar: result.avatar,
            deleteButtonIsVisible: result.hasAnyData
        )
    }
    
    func didTapClearButton() {
        profileUseCase.clearProfile()
        editPresenter.presentEmptyState()
    }
    
    func didTapPresentButton() {
        editPresenter.presentPreviewScreen()
    }
}
