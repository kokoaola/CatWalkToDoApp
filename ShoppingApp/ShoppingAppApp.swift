//
//  ShoppingAppApp.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI
import Firebase
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
//        print("ユーザーがログインしていない", Auth.auth().currentUser == nil)
//        print("匿名ユーザーでログイン中", Auth.auth().currentUser?.isAnonymous == true)
        
        // ユーザーがログインしていない、またはログイン中のユーザーが匿名ユーザーの場合に匿名認証を行う
        if Auth.auth().currentUser == nil || Auth.auth().currentUser?.isAnonymous == true {
            Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
//                    print("Error signing in anonymously: \(error.localizedDescription)")
                    return
                }
                
                if let user = authResult?.user {
//                    print("Signed in as anonymous user with UID: \(user.uid)")
                }
            }
        }
        
        return true
    }
}



@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
    
