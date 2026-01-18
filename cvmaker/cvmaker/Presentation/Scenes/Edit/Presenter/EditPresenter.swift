//
//  EditViewPresenter.swift
//  cvmaker
//
//  Created by Pavel on 01.12.2025.
//

import UIKit

protocol EditPresenterProtocol {
    
    func present(profile: ProfileModel, avatar: UIImage?)
    func presentEmptyState()
    func presentImageActions()
    func presentPreviewScreen()
    func presentDeleteButton(isVisible: Bool)
}

final class EditPresenter: EditPresenterProtocol {
    
    weak var view: EditViewControllerProtocol?
    
    func present(profile: ProfileModel, avatar: UIImage?) {
        view?.present(profile: profile, avatar: avatar)
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
    
    func presentDeleteButton(isVisible: Bool) {
        view?.setDeleteButtonVisible(isVisible)
    }
}
