//
//  MainScreen.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
import CoreData


///アプリ起動時に表示される親ビュー
struct MainScreen: View {
    
    var body: some View {
        VStack{
            //表示内容をタブビューで切り替える
            TabView{
                
                //買い物リストビュー
                ListScreen()
                    .tabItem{
                        Label("To-Do List", systemImage: "checklist")
                    }
                
                //単価計算ビュー
                UnitCalScreen().tabItem{
                    Label("Unit Price Calculation", systemImage: "arrow.2.squarepath")
                }
                
                //設定ビュー
                SettingScreen()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .tint(AppSetting.mainColor1)
        }
    }
}




struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            MainScreen()
                .environment(\.locale, Locale(identifier:"en"))
            MainScreen()
                .environment(\.locale, Locale(identifier:"ja"))
        }

    }
}
