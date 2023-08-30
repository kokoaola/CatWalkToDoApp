//
//  AppSetting.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/06.
//

import SwiftUI

///アプリ全体に適用するプロパティ、メソッド
class AppSetting{
    
    ///使用端末の横画面サイズ
    static let screenWidth = UIScreen.main.bounds.width
    
    ///使用端末の縦画面サイズ
    static let screenHeight = UIScreen.main.bounds.height
    
    ///文字数上限
    static let maxLength = 50
    
    ///アプリのメインカラー1
    static let mainColor1 = Color("reef1")
    
    ///アプリのメインカラー2
    static let mainColor2 = Color("reef2")
    
    static let fontColor = Color.black
    
    ///キーボード閉じるボタン
    static func closeKeyBoard(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}
