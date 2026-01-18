//
//  EditBuilder.swift
//  cvmaker
//
//  Created by Pavel on 07.12.2025.
//

import UIKit

struct EditBuilder {
    
    func build() -> UIViewController {
        let presenter = EditPresenter()
        let repository = ProfileRepository(profileStorageService: ProfileStorageService())
        let interactor = EditInteractor(
            profileUseCase: ProfileUseCase(profileRepository: repository),
            presenter: presenter
        )
        let viewController = EditViewController(interactor: interactor)
        presenter.view = viewController
        return viewController
    }
}
