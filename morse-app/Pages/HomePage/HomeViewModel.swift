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

@MainActor
class HomeViewModel: ObservableObject {
    
    var defaltImageUrl = "https://joho.o-yake.com/wp-content/uploads/2024/02/1707648319180-1024x902.jpg"
    @Published var uid: String = ""
    @Published var allUserDatas: [friendDatas]?
    @Published var receivedDatas: [receivedDatas]?
    @Published var messageDatas: [receivedDatas] = []
    
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
    
    
    func startListening() {
        
        Firestore.firestore().collection("datas").document(Auth.auth().currentUser!.uid).collection("receivedMessages").order(by: "time", descending: true).addSnapshotListener { [self] (snapShot, error) in
            
            Task {
                messageDatas = []
                if let documents = snapShot?.documents {
                    await documents.asyncCompactMap { [self] data in
                        if let data = try? data.data(as: Message.self){
                            if let profileData = try? await FirebaseClient.getProfileData(uid: data.sender!) {
                                print(profileData)
                                messageDatas.append(morse_app.receivedDatas(sender: data.sender, body: data.body, time: data.time, isOpened: data.isOpened, toId: data.toId, name: profileData.name, imageUrl: profileData.imageUrl))
                            }
                        }
                        //                        if data.played == false {
                        //                            if !self.withinOneMeterAccounts.contains(where: { $0.uid == data.uid }) {
                        //                                self.withinOneMeterAccounts.append(data)
                        //                            }
                        //                        }
                        messageDatas.sort(by: { $0.time!.dateValue() < $1.time!.dateValue() })
                    }
                }
            }
        }
    }
    
}
