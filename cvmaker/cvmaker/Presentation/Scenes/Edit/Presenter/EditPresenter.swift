//
//  EditViewPresenter.swift
//  cvmaker
//
//  Created by Pavel on 01.12.2025.
//

import UIKit

protocol EditPresenterProtocol {
    
    func present(profile: ProfileModel, avatar: UIImage?, deleteButtonIsVisible: Bool)
    func presentEmptyState()
    func presentImageActions()
    func presentPreviewScreen()
}

final class EditPresenter: EditPresenterProtocol {
    
    weak var view: EditViewControllerProtocol?
    
    func present(profile: ProfileModel, avatar: UIImage?, deleteButtonIsVisible: Bool) {
        view?.present(profile: profile, avatar: avatar)
        view?.setDeleteButtonVisible(deleteButtonIsVisible)
    }
    
    func presentEmptyState() {
        view?.resetToEmptyState()
    }
    
    func presentImageActions() {
        view?.presentImageActions()
    }
    
    func presentPreviewScreen() {
        view?.presentPreview()
    }
}
