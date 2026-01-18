//
//  ProfileUseCase.swift
//  cvmaker
//
//  Created by Pavel on 01.12.2025.
//

import UIKit

protocol ProfileUseCaseProtocol {
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, with value: T?)
    func loadProfile() -> ProfileModel
    func clearProfile()
    func saveAvatar(image: UIImage?)
    func loadAvatar() -> UIImage?
    var isFormValid: Bool { get }
    var hasAnyData: Bool { get }
}

final class ProfileUseCase: ProfileUseCaseProtocol {
    
    private let profileRepository: ProfileRepositoryProtocol
    
    init(profileRepository: ProfileRepositoryProtocol) {
        self.profileRepository = profileRepository
    }
    
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, with value: T?) {
        var profile = profileRepository.loadProfile()
        profile[keyPath: keyPath] = value
        profileRepository.saveProfile(profile)
    }
    
    func loadProfile() -> ProfileModel {
        let profile = profileRepository.loadProfile()
        return profile
    }
    
    func clearProfile() {
        profileRepository.clearProfile()
    }
    
    func saveAvatar(image: UIImage?) {
        profileRepository.saveAvatar(image: image)
    }
    
    func loadAvatar() -> UIImage? {
        profileRepository.loadAvatar()
    }
    
    var isFormValid: Bool {
        let profile = profileRepository.loadProfile()
        return
        !(profile.firstName?.isEmpty ?? true) &&
        !(profile.lastName?.isEmpty ?? true) &&
        !(profile.phone?.isEmpty ?? true) &&
        !(profile.specialization?.isEmpty ?? true)
    }
    
    var hasAnyData: Bool {
        profileRepository.hasAnyData()
    }
}
