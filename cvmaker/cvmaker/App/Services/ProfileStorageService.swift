//
//  ProfileStorage.swift
//  cvmaker
//
//  Created by Pavel on 02.11.2025.
//

import UIKit

protocol ProfileStorageServiceProtocol {
    
    func save<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, value: T?)
    func load<T>(_ keyPath: KeyPath<ProfileModel, T?>) -> T?
    func saveProfile(_ profile: ProfileModel)
    func loadProfile() -> ProfileModel
    func clearAllData()
    func hasAnyData() -> Bool
    func saveAvatar(_ image: UIImage?) -> String?
    func loadAvatar() -> UIImage?
    func setDataChangeObserver(_ observer: @escaping (Bool) -> Void)
}

final class ProfileStorageService: ProfileStorageServiceProtocol {
    
    static let shared = ProfileStorageService()
    private let defaults = UserDefaults.standard
    private let fileManager = FileManager.default
    private var dataChangeObserver: ((Bool) -> Void)?
    
    func setDataChangeObserver(_ observer: @escaping (Bool) -> Void) {
        self.dataChangeObserver = observer
    }
    
    func save<T>(_ keyPath: WritableKeyPath<ProfileModel, T?>, value: T?) {
        var profile = loadProfile()
        profile[keyPath: keyPath] = value
        saveProfile(profile)
    }
    
    func load<T>(_ keyPath: KeyPath<ProfileModel, T?>) -> T? {
        let profile = loadProfile()
        return profile[keyPath: keyPath]
    }
    
    func saveProfile(_ profile: ProfileModel) {
        if let data = try? JSONEncoder().encode(profile) {
            defaults.set(data, forKey: "com.myapp.profile")
            notifyDataChanged()
        } else {
            print("[ProfileStorage] Failed to encode profile")
        }
    }
    
    func loadProfile() -> ProfileModel {
        guard
            let data = defaults.data(forKey: "com.myapp.profile"),
            let profile = try? JSONDecoder().decode(ProfileModel.self, from: data)
        else {
            return ProfileModel()
        }
        return profile
    }
    
    func clearAllData() {
        let emptyProfile = ProfileModel()
        saveProfile(emptyProfile)
        saveAvatar(nil)
    }
    
    func hasAnyData() -> Bool {
        let profile = loadProfile()
        
        let hasTextData = !(profile.firstName?.isEmpty ?? true) ||
        !(profile.lastName?.isEmpty ?? true) ||
        !(profile.patronymic?.isEmpty ?? true) ||
        !(profile.hobbies?.isEmpty ?? true) ||
        !(profile.phone?.isEmpty ?? true) ||
        !(profile.email?.isEmpty ?? true) ||
        !(profile.telegram?.isEmpty ?? true) ||
        !(profile.specialization?.isEmpty ?? true) ||
        !(profile.hardSkills?.isEmpty ?? true)
        
        let hasOtherData = profile.birthdate != nil ||
        profile.experience != nil ||
        (profile.salary ?? 0) > 60000 ||
        profile.genderIndex != nil ||
        profile.isOpenToOffers != nil

        let hasAvatar = profile.avatarPath != nil
        
        return hasTextData || hasOtherData || hasAvatar
    }
    
    @discardableResult
    func saveAvatar(_ image: UIImage?) -> String? {
        if image == nil {
            removeExistingAvatar()
            defaults.removeObject(forKey: "com.myapp.avatarFilename")
            notifyDataChanged()
            return nil
        }
        
        guard let data = image?.pngData() else { return nil }
        let filename = "avatar_\(UUID().uuidString).png"
        let url = avatarURL(for: filename)
        
        removeExistingAvatar()
        
        do {
            try data.write(to: url, options: .atomic)
            defaults.set(filename, forKey: "com.myapp.avatarFilename")
            notifyDataChanged()
            return filename
        } catch {
            print("[ProfileStorage] Failed to save avatar:", error)
            return nil
        }
    }
    
    func loadAvatar() -> UIImage? {
        guard let filename = defaults.string(forKey: "com.myapp.avatarFilename") else { return nil }
        let url = avatarURL(for: filename)
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            defaults.removeObject(forKey: "com.myapp.avatarFilename")
            return nil
        }
        return image
    }
    
    private func removeExistingAvatar() {
        guard let filename = defaults.string(forKey: "com.myapp.avatarFilename") else { return }
        let url = avatarURL(for: filename)
        if fileManager.fileExists(atPath: url.path) {
            try? fileManager.removeItem(at: url)
        }
    }
    
    private func avatarURL(for filename: String) -> URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(filename)
    }
    
    private func notifyDataChanged() {
        dataChangeObserver?(hasAnyData())
    }
}
