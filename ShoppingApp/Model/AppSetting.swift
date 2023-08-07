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
    
    
    ///キーボード閉じるボタン
    static func colseKeyBoard(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}
