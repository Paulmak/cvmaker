//
//  PreviewViewController.swift
//  cvmaker
//
//  Created by Pavel on 30.09.2025.
//

import UIKit

final class PreviewViewController: UIViewController, PreviewViewDelegate {
    
    func previewViewDidTapShare(_ view: PreviewView, screenshot: UIImage) {
            presentShareSheet(with: screenshot)
        }
        
    private func presentShareSheet(with image: UIImage) {
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact
        ]
        present(activityViewController, animated: true)
    }
    
    
    let previewView = PreviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromCache()
        previewView.delegate = self
    }
    
    override func loadView() {
        view = previewView
    }
    
    private func loadDataFromCache() {
        let profile = ProfileStorage.shared.loadProfile()
        let avatar = ProfileStorage.shared.loadAvatar()
        let viewModel = PreviewViewModel(profile: profile, avatarImage: avatar)
        
        let avatarData = viewModel.avatarData
        previewView.setValue(.avatar(image: avatarData.image, genderIndex: avatarData.genderIndex))
        
        if let fullName = viewModel.fullName {
            previewView.setValue(.profileName(fullName))
        }
        
        if let profileGender = viewModel.genderString {
            previewView.setValue(.profileGender(profileGender))
        }
        
        if let age = viewModel.formattedAge {
            previewView.setValue(.profileAge(age))
        }
        
        if let jobStatusImage = viewModel.jobStatusImage {
            previewView.setValue(.jobStatus(text: viewModel.jobStatusText, image: jobStatusImage))
        }
        
        if let phone = viewModel.phoneNumber {
            previewView.setValue(.phone(phone))
        }
        
        if let email = viewModel.email {
            previewView.setValue(.email(email))
        }
        
        if let telegram = viewModel.telegram {
            previewView.setValue(.telegram(telegram))
        }
        
        if let displayName = viewModel.displayName {
            previewView.setValue(.profileName(displayName))
        }
        
        if let gender = viewModel.genderString {
            previewView.setValue(.gender(gender))
        }
        
        if let birthDate = viewModel.displayBirthDate {
            previewView.setValue(.birthDate(birthDate))
        }
        
        if let hobbies = viewModel.hobbies {
            previewView.setValue(.hobbies(hobbies))
        }
        
        if let specialization = viewModel.specialization {
            previewView.setValue(.specialization(specialization))
        }
        
        if let experience = viewModel.experience {
            previewView.setValue(.experience(experience))
        }
        
        if let salary = viewModel.formattedSalary {
            previewView.setValue(.salary(salary))
        }
        
        if let hardSkills = viewModel.hardSkills {
            previewView.setValue(.hardSkills(hardSkills))
        }
        
        previewView.updateFieldVisibility()
    }
}
