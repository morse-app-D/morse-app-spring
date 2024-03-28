//
//  SendViewModel.swift
//  spring-canp2024
//
//  Created by 本田輝 on 2024/03/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SendViewModel: NSObject, ObservableObject {
    
    func sendMessage(text: String, toId: String) {
        Task {
            let message = Message(sender: Auth.auth().currentUser!.uid, body: text, time: Timestamp(date: .now), isOpened: false, toId: toId)
            try await FirebaseClient.sendMessage(message: message, uid: toId)
        }
    }
}
