//
//  Models.swift
//  spring-canp2024
//
//  Created by 本田輝 on 2024/03/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Codable, Identifiable {
    @DocumentID var id: String?
    let sender: String
    let body: String
    let time: Timestamp
    let isOpened: Bool
}

struct ProfileData: Codable {
    var imageUrl: URL?
    var name: String?
}

struct receivedDatas: Codable {
    var messageDatas: [Message]
    var profileDatas: [ProfileData]
}

struct friendDatas: Codable {
    var uid: String
    var name: String
    var image: URL?
}
