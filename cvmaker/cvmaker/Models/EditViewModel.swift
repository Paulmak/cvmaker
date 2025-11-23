//
//  EditViewModel.swift
//  cvmaker
//
//  Created by Pavel on 17.11.2025.
//

import UIKit

struct EditViewModel {
    let profile: ProfileModel
    let avatarImage: UIImage?
    
    init(profile: ProfileModel, avatarImage: UIImage? = nil) {
        self.profile=profile
        self.avatarImage=avatarImage
    }
    
    var avatarData: (image: UIImage?, isDefault: Bool) {
        (avatarImage, avatarImage == nil)
    }
    
    var genderIndex: Int {
        profile.genderIndex ?? 0
    }
    
    var jobStatus: Bool {
        profile.isOpenToOffers ?? false
    }
    
    var salaryValue: Float {
        profile.salary ?? 60000
    }
    
    var formattedSalary: String {
        "\(SalaryFormatter.formatted(Int(salaryValue)))"
    }
    
    var birthdateString: String {
        guard let birthdate = profile.birthdate else { return "Выбрать" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: birthdate)
    }
    
    var experienceString: String {
        profile.experience ?? "Выбрать"
    }
    
    var isFormValid: Bool {
        !(profile.firstName?.isEmpty ?? true) &&
        !(profile.lastName?.isEmpty ?? true) &&
        !(profile.phone?.isEmpty ?? true) &&
        !(profile.specialization?.isEmpty ?? true)
    }
    
    static func empty() -> EditViewModel {
        EditViewModel(profile: ProfileModel())
    }
    
    static func fromStorage() -> EditViewModel {
        let profile = ProfileStorage.shared.loadProfile()
        let avatar = ProfileStorage.shared.loadAvatar()
        return EditViewModel(profile: profile, avatarImage: avatar)
    }
}
