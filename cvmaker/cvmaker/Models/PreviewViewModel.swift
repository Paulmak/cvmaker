//
//  PreviewViewModel.swift
//  cvmaker
//
//  Created by Pavel on 16.11.2025.
//

import UIKit

struct PreviewViewModel {
    
    let profile: ProfileModel
    let avatarImage: UIImage?
    
    var avatarData: (image: UIImage?, genderIndex: Int?) {
        if let avatarImage = avatarImage {
            return (avatarImage, profile.genderIndex)
        } else {
            return (nil, profile.genderIndex)
        }
    }
    
    var fullName: String? {
        guard let firstName = profile.firstName, let lastName = profile.lastName else { return nil }
        return "\(lastName) \(firstName)"
    }
    
    var displayName: String? {
        var components: [String] = []
        if let lastName = profile.lastName { components.append(lastName) }
        if let firstName = profile.firstName { components.append(firstName) }
        if let patronymic = profile.patronymic { components.append(patronymic) }
        return components.isEmpty ? nil : components.joined(separator: " ")
    }
    
    var genderString: String? {
        guard let genderIndex = profile.genderIndex else { return nil }
        return genderIndex == 0 ? "Мужской" : "Женский"
    }
    
    var formattedAge: String? {
        guard let birthdate = profile.birthdate else { return nil }
        return ", \(BirthDateFormatter.format(birthdate))"
    }
    
    var displayBirthDate: String? {
        guard let birthdate = profile.birthdate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: birthdate)
    }
    
    var jobStatusText: String {
        profile.isOpenToOffers == true ? "Открыт к предложениям" : "Закрыт к предложениям"
    }
    
    var jobStatusImage: UIImage? {
        UIImage(named: profile.isOpenToOffers == true ? "Accepted" : "Declined")
    }
    
    var phoneNumber: String? { profile.phone }
    var email: String? { profile.email }
    var telegram: String? { profile.telegram }
    
    var hobbies: String? { profile.hobbies }
    
    var specialization: String? { profile.specialization }
    var experience: String? { profile.experience }
    
    var formattedSalary: String? {
        guard let salary = profile.salary else { return nil }
        return SalaryFormatter.formatted(Int(salary))
    }
    
    var hardSkills: String? { profile.hardSkills }
    
    var hasContactInfo: Bool {
        phoneNumber?.isEmpty == false || email?.isEmpty == false || telegram?.isEmpty == false
    }
    
    var hasCommonInfo: Bool {
        displayName?.isEmpty == false || genderString?.isEmpty == false ||
        displayBirthDate?.isEmpty == false || hobbies?.isEmpty == false
    }
    
    var hasJobSeekersInfo: Bool {
        specialization?.isEmpty == false || experience?.isEmpty == false ||
        formattedSalary?.isEmpty == false || hardSkills?.isEmpty == false
    }
}
