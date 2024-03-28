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

class HomeViewModel: ObservableObject {
    
    var defaltImageUrl = "https://joho.o-yake.com/wp-content/uploads/2024/02/1707648319180-1024x902.jpg"
    @Published var uid: String = ""
    @Published var allUserDatas: [friendDatas]?
    @Published var receivedDatas: [receivedDatas]?
    
    func sendMessage(text: String, toId: String) {
        Task {
            let message = Message(sender: Auth.auth().currentUser!.uid, body: text, time: Timestamp(date: .now), isOpened: false, toId: toId)
            try await FirebaseClient.sendMessage(message: message, uid: toId)
        }
    }
    
    func saveSentMessage(text: String, toId: String) {
        Task {
            let message = Message(sender: Auth.auth().currentUser!.uid, body: text, time: Timestamp(date: .now), isOpened: false, toId: toId)
            try await FirebaseClient.savesentMessages(uid: message)
        }
    }
    
    func getMessages() async throws -> [receivedDatas] {
        
        let data = try await FirebaseClient.getMessages(uid: Auth.auth().currentUser!.uid)
        
        var messageDatas: [receivedDatas] = []
        
        print(data)
        
        await data.asyncCompactMap { data in
            if let profileData = try? await FirebaseClient.getProfileData(uid: data.sender!) {
                print(profileData)
                messageDatas.append(morse_app.receivedDatas(sender: data.sender, body: data.body, time: data.time, isOpened: data.isOpened, toId: data.toId, name: profileData.name, imageUrl: profileData.imageUrl))
            }
        }
        
        return messageDatas
    }
    
}
