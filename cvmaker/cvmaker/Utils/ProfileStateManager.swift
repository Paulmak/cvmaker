//
//  ProfileStateManager.swift
//  cvmaker
//
//  Created by Pavel on 03.11.2025.
//

import Foundation

final class ProfileStateManager {
    
    static let shared = ProfileStateManager()
    
    var onProfileDataChanged: ((Bool) -> Void)?
    
    func notifyDataChanged() {
        let hasData = ProfileStorage.shared.hasAnyData()
        onProfileDataChanged?(hasData)
    }
}
