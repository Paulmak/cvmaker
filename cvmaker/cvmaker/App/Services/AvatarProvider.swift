//
//  AvatarProvider.swift
//  cvmaker
//
//  Created by Pavel on 26.10.2025.
//

import UIKit
import PhotosUI
import AVFoundation

final class AvatarProvider: NSObject {
    
    private weak var presenter: UIViewController?
    private var completion: ((UIImage?) -> Void)?
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    static func image(for genderIndex: Int) -> UIImage? {
        switch genderIndex {
        case 0: return UIImage(named: "male")
        case 1: return UIImage(named: "female")
        default: return nil
        }
    }
    
    func presentImageMenu(currentImage: UIImage?, isDefaultAvatar: Bool, completion: @escaping (UIImage?) -> Void) {
        
        self.completion = completion
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let isCameraDenied = cameraStatus == .denied || cameraStatus == .restricted
        
        let alert = UIAlertController(title: "Управление изображением профиля", message: "Выберите нужное действие", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default) { _ in
            self.requestPhotoLibraryAccess()
        })
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) && !isCameraDenied {
            alert.addAction(UIAlertAction(title: "Камера", style: .default) { _ in
                self.requestCameraAccess()
            })
        }
        
        if currentImage != nil && !isDefaultAvatar {
            alert.addAction(UIAlertAction(title: "Просмотр фото", style: .default) { _ in
                if let currentImage = currentImage {
                    self.openAvatarImage(currentImage)
                }
            })
            alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { _ in
                completion(nil)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        presenter?.present(alert, animated: true)
    }
}

private extension AvatarProvider {
    
    func requestCameraAccess() {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    granted ? self.openCamera() : self.showPermissionAlert(type: "camera")
                }
            }
        default:
            showPermissionAlert(type: "camera")
        }
    }
    
    func openCamera() {
        
        guard let presenter = presenter else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        presenter.present(picker, animated: true)
    }
    
    func openAvatarImage(_ image: UIImage) {
        
        guard let presenter = presenter else { return }
        
        let imageVC = DetailImageViewController(image: image)
        
        imageVC.modalPresentationStyle = .automatic
        presenter.present(imageVC, animated: true)
    }
    
    func requestPhotoLibraryAccess() {
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized, .limited:
                        self.openGallery()
                    default:
                        self.showPermissionAlert(type: "photoGallery")
                    }
                }
            }
        default:
            showPermissionAlert(type: "photoGallery")
        }
    }
    
    func openGallery() {
        
        guard let presenter = presenter else { return }
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        presenter.present(picker, animated: true)
    }
    
    func showPermissionAlert(type: String) {
        
        let alert = UIAlertController(
            title: "Нет доступа",
            message: "Разрешите доступ к \(type) в настройках устройства.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        presenter?.present(alert, animated: true)
    }
    
    @objc
    private func closeFullscreen() {
        presenter?.dismiss(animated: true)
    }
}

extension AvatarProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        completion?(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        completion?(nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider else {
            completion?(nil)
            return
        }
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.completion?(image as? UIImage)
                }
            }
        } else {
            completion?(nil)
        }
    }
}
