//
//  morse_appApp.swift
//  morse-app
//
//  Created by 大澤清乃 on 2024/03/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()

        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                Auth.auth().signInAnonymously() { (authResult, error) in
                    if error != nil {
                        print("Auth Error :\(error!.localizedDescription)")
                    }
                    Task {
                        do {
                            let profileData = friendDatas(name: "", image: URL(string: ""))
                            try await FirebaseClient.settingProfile(data: profileData, uid: Auth.auth().currentUser!.uid)

                            UserDefaults.standard.set(true, forKey: "logIned")

                        } catch {
                            print("アカウント作成時のエラー",error.localizedDescription)
                        }
                    }

                    // 認証情報の取得
                    guard (authResult?.user) != nil else { return }
                    return
                }
            } else {
                print("ログインできた")
                UserDefaults.standard.set(true, forKey: "logIned")
            }
        }

        return true
    }
}

@main
struct spring_canp2024App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
