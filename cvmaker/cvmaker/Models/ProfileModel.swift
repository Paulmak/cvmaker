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
    
    init(
        firstName: String? = nil,
        lastName: String? = nil,
        patronymic: String? = nil,
        genderIndex: Int? = nil,
        birthdate: Date? = nil,
        hobbies: String? = nil,
        phone: String? = nil,
        email: String? = nil,
        telegram: String? = nil,
        specialization: String? = nil,
        experience: String? = nil,
        salary: Float? = nil,
        hardSkills: String? = nil,
        isOpenToOffers: Bool? = nil
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.patronymic = patronymic
        self.genderIndex = genderIndex
        self.birthdate = birthdate
        self.hobbies = hobbies
        self.phone = phone
        self.email = email
        self.telegram = telegram
        self.specialization = specialization
        self.experience = experience
        self.salary = salary
        self.hardSkills = hardSkills
        self.isOpenToOffers = isOpenToOffers
    }
}
