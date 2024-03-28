//
//  ProfileViewModel.swift
//  morse-app
//
//  Created by 伊藤汰海 on 2024/03/28.
//

import SwiftUI
import FirebaseAuth

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var getProfile: friendDatas?
    @Published var imageUrl: URL!
    @Published var sendToDBModel = SendToDBModel()
    
    func changeImages(image: UIImage) async throws {
        
        let maxSize = max(image.size.width * image.scale, image.size.height * image.scale )
        
        let userData = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
        
        if maxSize > 500 {
            if image.size.width * image.scale > image.size.height * image.scale {
                
                let imaegChangedSize = image.widthResize(image: image, width: 500)
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.name)
                
            } else if image.size.width * image.scale < image.size.height * image.scale {
                
                let imaegChangedSize = image.heightResize(image: image, height: 500)
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.name)
                
            } else {
                print(maxSize.description)
                let imaegChangedSize = image.resize(targetSize: CGSize(width: 500, height: 500))
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.name)
            }
        } else {
            imageUrl = await sendToDBModel.uploadProfileImage(image: image, name: userData.name)
        }
        
    }
    
    func getSentMessage() async throws {
        getProfile = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
        print(getProfile)
    }
    
}
