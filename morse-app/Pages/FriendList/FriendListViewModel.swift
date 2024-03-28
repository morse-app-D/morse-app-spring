//
//  FriendListViewModel.swift
//  morse-app
//
//  Created by 加藤 on 2024/03/28.
//

import SwiftUI

//struct FriendListViewModel: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
////
//struct FriendListViewModel_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendListViewModel()
//    }
//}

class FriendListViewModel: ObservableObject {
    @Published var friendList : [friendDatas] = []
    
    func getFriendList() async throws {
        friendList = try await FirebaseClient.getAllUsers()
    }
    
}
