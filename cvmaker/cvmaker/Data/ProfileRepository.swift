//
//  ProfileRepository.swift
//  cvmaker
//
//  Created by Pavel on 01.12.2025.
//

import UIKit

protocol ProfileRepositoryProtocol {
    
    func loadProfile() -> ProfileModel
    func saveProfile(_ profile: ProfileModel)
    func saveAvatar(image: UIImage?)
    func loadAvatar() -> UIImage?
    func clearProfile()
    func hasAnyData() -> Bool
    
}

final class ProfileRepository: ProfileRepositoryProtocol {
    
    private let profileStorageService: ProfileStorageServiceProtocol
    
    init(profileStorageService: ProfileStorageServiceProtocol) {
        self.profileStorageService = profileStorageService
    }
    
    func loadProfile() -> ProfileModel {
        profileStorageService.loadProfile()
    }
    
    func saveProfile(_ profile: ProfileModel) {
        profileStorageService.saveProfile(profile)
    }
    
    func saveAvatar(image: UIImage?) {
        profileStorageService.saveAvatar(image)
    }
    
    func loadAvatar() -> UIImage? {
        profileStorageService.loadAvatar()
    }
    
    func clearProfile() {
        profileStorageService.clearAllData()
    }
    
    func hasAnyData() -> Bool {
        profileStorageService.hasAnyData()
    }
}
