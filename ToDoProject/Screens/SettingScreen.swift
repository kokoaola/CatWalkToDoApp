//
//  Setting_Top.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI



struct SettingScreen: View {
    var body: some View {
        NavigationView{
            
            //上のナビゲーションバーっぽいセクション
            VStack(spacing:0){
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: AppSetting.screenHeight * 0.15)
                    .overlay(
                        Text("Setting").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, AppSetting.screenHeight * 0.05)
                            .accessibilityAddTraits(.isHeader)
                    )
                
                List{
                    Section{
                        NavigationLink(destination: {
                            EditIndexSettingScreen()
                        }, label: {Text("Edit Labels")})
                    }
                    
                    // NavigationLink(destination: {
                    //     FavoriteList()
                    // }, label: {Text("Edit Favorite List")})
                    Section{
                        NavigationLink(destination: {
                            ContactWebView()
                        }, label: {Text("Contact Us")})
                        
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
        }
    }
}
