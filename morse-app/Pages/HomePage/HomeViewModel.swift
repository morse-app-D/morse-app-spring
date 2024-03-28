//
//  HomeView.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {
    
    func getMessages() async throws -> receivedDatas {
        
        let data = try await FirebaseClient.getMessages(uid: Auth.auth().currentUser!.uid)
        
        var profileDatas: [ProfileData] = []
        
        await data.asyncCompactMap { data in
            if let profileData = try? await FirebaseClient.getProfileData(uid: data.sender) {
                profileDatas.append(profileData)
            }
        }
        
        let receivedDatas = receivedDatas(messageDatas: data, profileDatas: profileDatas)
        return receivedDatas
    }
    
}
