//
//  Setting_Top.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

import SwiftUI

struct Setting_Top: View {
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
                
//                VStack{
                    List{
                        Section{
                            NavigationLink(destination: {
                                AddNewLabel_View()
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
//                }
                //背景グラデーション設定
                .scrollContentBackground(.hidden)
                .background(AppSetting.mainColor1.opacity(0.1))
                //                .modifier(background(.secondary).foregroundStyle(LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing)))
                
                
            }
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct Setting_Top_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            Setting_Top()
                .environment(\.locale, Locale(identifier: "en"))
            Setting_Top()
                .environment (\.locale, Locale (identifier: "ja"))
        }
        
    }
}
