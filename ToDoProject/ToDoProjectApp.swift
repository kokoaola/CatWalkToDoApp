//
//  ToDoProjectApp.swift
//  ToDoProject
//
//  Created by koala panda on 2023/08/19.
//
import FirebaseAuth
import SwiftUI
import Firebase
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //DEBUGの時はGoogleService-Stage-Infoを、本番の場合はGoogleService-Infoを使ってFirebaseの接続先を切り替える
#if DEBUG
        let filePath = Bundle.main.path(forResource: "GoogleService-Test-Info", ofType: "plist")
#else
        let filePath = Bundle.main.path(forResource: "GoogleService-Production-Info", ofType: "plist")
#endif
        
        if let filePath = filePath {
            if let options = FirebaseOptions(contentsOfFile: filePath) {
                FirebaseApp.configure(options: options)
            }
        }
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
struct ToDoProjectApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(Store())
        }
    }
}



