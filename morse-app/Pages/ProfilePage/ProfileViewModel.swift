//
//  ProfileViewModel.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import SwiftUI

class ProfileViewModel {
    
    @Published var getProfile: [ProfileData] = []
    
    func getSentMessage() async throws {
        getProfile = try await FirebaseClient.getProfileData()
    }
    
}
