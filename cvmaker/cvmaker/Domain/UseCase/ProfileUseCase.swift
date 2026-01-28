//
//  ProfileUseCase.swift
//  cvmaker
//
//  Created by Pavel on 01.12.2025.
//

import UIKit

protocol ProfileUseCaseProtocol {
    func update<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, with value: T?)
    func loadProfile() -> ProfileLoadResult
    func clearProfile()
    func saveAvatar(image: UIImage?)
    var isFormValid: Bool { get }
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
    
    func loadProfile() -> ProfileLoadResult {
        let profile = profileRepository.loadProfile()
        let avatar = profileRepository.loadAvatar()
        let hasAnyData = profileRepository.hasAnyData()
        
        return ProfileLoadResult(
            profile: profile,
            avatar: avatar,
            hasAnyData: hasAnyData
        )
    }
    
    func clearProfile() {
        profileRepository.clearProfile()
    }
    
    func saveAvatar(image: UIImage?) {
        profileRepository.saveAvatar(image: image)
    }
    
    var isFormValid: Bool {
        let profile = profileRepository.loadProfile()
        return
        !(profile.firstName?.isEmpty ?? true) &&
        !(profile.lastName?.isEmpty ?? true) &&
        !(profile.phone?.isEmpty ?? true) &&
        !(profile.specialization?.isEmpty ?? true)
    }
}
