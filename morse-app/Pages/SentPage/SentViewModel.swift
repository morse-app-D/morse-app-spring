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

class SentViewModel: ObservableObject {
    
    @Published var sentMessages: [Message] = []
    
    func getSentMessage() async throws {
        sentMessages = try await FirebaseClient.getsentMessages()
    }
    
}
