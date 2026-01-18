//
//  ProfileField.swift
//  cvmaker
//
//  Created by Pavel on 02.11.2025.
//

import Foundation

struct ProfileModel: Codable {
    var avatarPath: String?
    var firstName: String?
    var lastName: String?
    var patronymic: String?
    var genderIndex: Int?
    var birthdate: Date?
    var hobbies: String?
    var phone: String?
    var email: String?
    var telegram: String?
    var specialization: String?
    var experience: String?
    var salary: Float?
    var salaryLabel: String?
    var hardSkills: String?
    var isOpenToOffers: Bool?
}
