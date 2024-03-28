//
//  GetViewModel.swift
//  spring-canp2024
//
//  Created by 本田輝 on 2024/03/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class GetViewModel: NSObject, ObservableObject {
    
    func getMessages() async throws -> receivedDatas {
        
        let data = try await FirebaseClient.getMessages(uid: Auth.auth().currentUser!.uid)
        
        var profileDatas: [friendDatas] = []
        
        await data.asyncCompactMap { data in
            if let profileData = try? await FirebaseClient.getProfileData(uid: data.sender!) {
                profileDatas.append(profileData)
            }
        }
        
        let receivedDatas = receivedDatas(messageDatas: data, profileDatas: profileDatas)
        return receivedDatas
    }
    
    
    
}
