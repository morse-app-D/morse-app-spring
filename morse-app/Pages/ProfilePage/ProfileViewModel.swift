//
//  ProfileViewModel.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import SwiftUI
import FirebaseAuth

class ProfileViewModel: ObservableObject {

    @Published var profile: friendDatas?

    func getProfile() async throws {
        profile = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
        print(profile)
        print("yahho", profile?.imageUrl)
    }
    
}
