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
    
    ///アプリのフォントカラー
    static let fontColor = Color.black
}


extension AppSetting{
    
    ///キーボード閉じるボタンの挙動
    static func closeKeyBoard(){
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
    
    ///端末の国設定の通貨の単位を付ける関数
    static func currencyString(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier
        
        // 日本円の場合の設定
        if formatter.currencyCode == "JPY" {
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 3 // 小数点第三位まで表示
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
