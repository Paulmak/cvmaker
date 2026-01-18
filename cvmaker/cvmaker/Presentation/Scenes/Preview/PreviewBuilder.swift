//
//  PreviewBuilder.swift
//  cvmaker
//
//  Created by Pavel on 09.01.2026.
//

import UIKit

struct PreviewBuilder {
    
    static func build() -> UIViewController {
        let presenter = PreviewPresenter()
        let repository = ProfileStorageService()
        let interactor = PreviewInteractor(
            presenter: presenter,
            storage: repository
        )
        let vc = PreviewViewController(interactor: interactor)
        presenter.view = vc
        return vc
    }
}
