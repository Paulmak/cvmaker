//
//  PreviewPresenter.swift
//  cvmaker
//
//  Created by Pavel on 14.01.2026.
//

import UIKit

protocol PreviewPresenterProtocol {
    func present(profile: ProfileModel, avatar: UIImage?)
}

final class PreviewPresenter: PreviewPresenterProtocol {
    
    weak var view: PreviewViewControllerProtocol?
    
    func present(profile: ProfileModel, avatar: UIImage?) {
        
        let fullName: String? = {
            var parts: [String] = []
            if let lastName = profile.lastName, !lastName.isEmpty {
                parts.append(lastName)
            }
            if let firstName = profile.firstName, !firstName.isEmpty {
                parts.append(firstName)
            }
            if let patronymic = profile.patronymic, !patronymic.isEmpty {
                parts.append(patronymic)
            }
            return parts.isEmpty ? nil : parts.joined(separator: " ")
        }()
        
        let genderText: String? = {
            guard let index = profile.genderIndex else { return nil }
            return index == 0 ? "Мужской" : "Женский"
        }()
        
        let genderIndex = profile.genderIndex ?? 0
        
        let ageText: String? = {
            guard let birthdate = profile.birthdate else { return nil }
            return BirthDateFormatter.format(birthdate)
        }()
        
        let genderAndAge: String? = {
            guard let genderText else { return nil }
            if let ageText {
                return "\(genderText), \(ageText)"
            }
            return genderText
        }()
        
        let jobStatusText = profile.isOpenToOffers == true
        ? "Открыт к предложениям"
        : "Закрыт к предложениям"
        
        let jobStatusImage = UIImage(
            named: profile.isOpenToOffers == true ? "Accepted" : "Declined"
        )
        
        let birthDate: String? = {
            guard let date = profile.birthdate else { return nil }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            return formatter.string(from: date)
        }()
        
        let salary: String? = {
            guard let salary = profile.salary else { return nil }
            return SalaryFormatter.formatted(Int(salary))
        }()
        
        let state = PreviewViewState(
            avatar: avatar,
            fullName: fullName,
            genderAndAge: genderAndAge,
            gender: genderText,
            genderIndex: genderIndex,
            jobStatusText: jobStatusText,
            jobStatusImage: jobStatusImage,
            phone: profile.phone,
            email: profile.email,
            telegram: profile.telegram,
            birthDate: birthDate,
            hobbies: profile.hobbies,
            specialization: profile.specialization,
            experience: profile.experience,
            salary: salary,
            hardSkills: profile.hardSkills
        )
        
        view?.present(state: state)
        
    }
}
