//
//  FrirendViewModel.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import SwiftUI

class FriendListViewModel: ObservableObject {
    
    @Published var friendList: [friendDatas] = []
    
    func getFriendList() async throws {
        friendList = try await FirebaseClient.getAllUsers()
    }
    
}
