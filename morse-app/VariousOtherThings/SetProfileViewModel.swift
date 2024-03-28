//
//  SetProfileViewModel.swift
//  spring-canp2024
//
//  Created by 本田輝 on 2024/03/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SetProfileViewModel: NSObject, ObservableObject {
    
    @Published var imageUrl: URL!
    @Published var sendToDBModel = SendToDBModel()
    
    func changeImages(image: UIImage) async throws {
        
        let maxSize = max(image.size.width * image.scale, image.size.height * image.scale )
        
        let userData = try await FirebaseClient.getProfileData(uid: Auth.auth().currentUser!.uid)
        
        if maxSize > 500 {
            if image.size.width * image.scale > image.size.height * image.scale {
                
                let imaegChangedSize = image.widthResize(image: image, width: 500)
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.userName!)
                
            } else if image.size.width * image.scale < image.size.height * image.scale {
                
                let imaegChangedSize = image.heightResize(image: image, height: 500)
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.userName!)
                
            } else {
                print(maxSize.description)
                let imaegChangedSize = image.resize(targetSize: CGSize(width: 500, height: 500))
                imageUrl = await sendToDBModel.uploadProfileImage(image: imaegChangedSize, name: userData.userName!)
            }
        } else {
            imageUrl = await sendToDBModel.uploadProfileImage(image: image, name: userData.userName!)
        }
        
    }
    
    
    
}
