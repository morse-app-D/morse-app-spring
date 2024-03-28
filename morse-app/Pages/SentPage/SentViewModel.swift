//
//  DentViewMode.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SentViewModel {
    
    func getSentMessage() async throws-> [Message] {
        let sentMessages = try await FirebaseClient.getsentMessages()
        return sentMessages
    }
    
}
