//
//  PreviewViewController.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

protocol PreviewViewControllerProtocol: AnyObject {
    func present(state: PreviewViewState)
}

final class PreviewViewController: UIViewController, PreviewViewDelegate {
    
    private let previewView = PreviewView()
    private let interactor: PreviewInteractorProtocol
    
    init(interactor: PreviewInteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func previewViewDidTapShare(_ view: PreviewView, screenshot: UIImage) {
            presentShareSheet(with: screenshot)
        }
        
    private func presentShareSheet(with image: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact
        ]
        present(activityViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.delegate = self
        interactor.start()
    }
    
    override func loadView() {
        view = previewView
    }
}

extension PreviewViewController: PreviewViewControllerProtocol {
    
    func present(state: PreviewViewState) {
        previewView.configure(with: state)
    }
}
