//
//  ProfileModel.swift
//  cvmaker
//
//  Created by Pavel on 16.11.2025.
//

import UIKit

struct ProfileModel: Codable {
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
