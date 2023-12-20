//
//  Setting_Top.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI


///設定画面のスクリーン
struct SettingScreen: View {
    var body: some View {
            //上のナビゲーションバーっぽいセクション
            VStack(spacing:0){
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: AppSetting.screenHeight * 0.15)
                    .overlay(
                        Text("Setting").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, AppSetting.screenHeight * 0.05)
                            .accessibilityAddTraits(.isHeader))
                
                List{
                    ///インデックスラベル設定用のビュー
                    Section{
                        NavigationLink(destination: {
                            EditIndexSettingScreen()
                        }, label: {Text("Edit Labels")})
                    }

                    Section{
                        ///お問い合わせ用のビュー
                        NavigationLink(destination: {
                            ContactWebView()
                        }, label: {Text("Contact Us")})
                        
                        ///プライバシーポリシー用のビュー
                        NavigationLink(destination: {
                            PrivacyPolicyView()
                        }, label: {Text("Privacy Policy")})
                    }
                }
                .listStyle(.insetGrouped)
                .padding(.top)
                
                //背景グラデーション設定
                .scrollContentBackground(.hidden)
                .background(.gray.opacity(0.1))
            }
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .embedInNavigationView()
    }
}
