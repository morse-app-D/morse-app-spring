//
//  FirebaseClient.swift
//  spring-canp2024
//
//  Created by 本田輝 on 2024/03/26.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseFirestoreSwift
import SwiftUI

enum FirebaseClientFirestoreError: Error {
    case roomDataNotFound
}

class FirebaseClient {
    
    static let db = Firestore.firestore()
    
    static func sendMessage(message: Message, uid: String) async throws {
        guard let encoded = try? Firestore.Encoder().encode(message) else { return }
        try await db.collection("datas").document(uid).collection("receivedMessages").addDocument(data: encoded)
        
    }
    
    static func getMessages(uid: String) async throws -> [Message] {
        var documentDatas = [Message]()
        let db = Firestore.firestore()
        let snapshot = try await db.collection("datas").document(uid).collection("receivedMessages").getDocuments()
        let documents = snapshot.documents
        for document in documents {
            do {
                let data = try document.data(as: Message.self)
                documentDatas.append(data)
            } catch {
                print("再生済み曲の取得失敗",error.localizedDescription)
            }
        }
        return documentDatas
    }
    
    static func addFriend(uid: friendDatas) async throws {
        guard let encoded = try? Firestore.Encoder().encode(uid) else { return }
        try await db.collection("datas").document(Auth.auth().currentUser!.uid).collection("friends").addDocument(data: encoded)
    }
    
    static func saveSendedMessages(uid: Message) async throws {
        guard let encoded = try? Firestore.Encoder().encode(uid) else { return }
        try await db.collection("datas").document(Auth.auth().currentUser!.uid).collection("sendedMessage").addDocument(data: encoded)
    }
    
    static func watchedMessage(documentId: String) async throws {
        try await db.collection("datas").document(Auth.auth().currentUser!.uid).collection("receivedMessages").document(documentId).setData(["isOpened" : true])
    }
    
    static func settingProfile(data: ProfileData, uid: String) async throws {
        
        guard let encoded = try? Firestore.Encoder().encode(data) else { return }
        try await db.collection("datas").document(uid).collection("userData").document("profileData").setData(encoded)
        
    }
    
    static func getProfileData(uid: String) async throws -> ProfileData {
        let snapshot = try await db.collection("datas").document(uid).collection("userData").document("profileData").getDocument()
        let information = try snapshot.data(as: ProfileData.self)
        return information
    }
    
    static func getAllUsers() async throws -> [friendDatas] {
        let db = Firestore.firestore()
        let snapshot = try? await db.collection("datas").getDocuments()
        if let snapshot = snapshot {
            return snapshot.documents.compactMap { document in
                return try? document.data(as: friendDatas.self)
            }
        } else {
            return []
        }
    }
    
}
