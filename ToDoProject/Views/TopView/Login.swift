//
//  Login.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/15.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignIn
import UIKit

struct Login: View {
    @State private var isSignedIn = false
    
    var body: some View {
        VStack {
            if isSignedIn {
                Text("Successfully signed in!")
            } else {
                Button("Sign in anonymously") {
                    signInAnonymously()
                }
            }
        }
    }
    
    func signInAnonymously() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
//                print("Error signing in: \(error.localizedDescription)")
                return
            }
            isSignedIn = true
        }
    }
}

struct Login_Previews: PreviewProvider {
    @State static var isSignedIn = false
    static var previews: some View {
        Login()
    }
}
