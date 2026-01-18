//
//  PreviewViewModel.swift
//  cvmaker
//
//  Created by Pavel on 16.11.2025.
//

import UIKit

protocol PreviewInteractorProtocol {
    func start()
}

final class PreviewInteractor: PreviewInteractorProtocol {
    
    private let presenter: PreviewPresenter
    private let storage: ProfileStorageServiceProtocol
    
    init(
        presenter: PreviewPresenter,
        storage: ProfileStorageServiceProtocol
    ) {
        self.presenter = presenter
        self.storage = storage
    }
    
    func start() {
        let profile = storage.loadProfile()
        let avatar = storage.loadAvatar()
        presenter.present(profile: profile, avatar: avatar)
    }
}
