//
//  ContentView.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
import CoreData


///アプリ起動時に表示される親ビュー
struct ContentView: View {
    
    var body: some View {
        VStack{
            //表示内容をタブビューで切り替える
            TabView{
                
                //買い物リストビュー
                List_mainView()
                    .tabItem{
                        Label("To-Do List", systemImage: "checklist")
                    }
                
                //単価計算ビュー
                Keisan().tabItem{
                    Label("Unit Price Calculation", systemImage: "arrow.2.squarepath")
                }
                
                //設定ビュー
                Setting_Top()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .tint(AppSetting.mainColor1)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            ContentView()
                .environment(\.locale, Locale(identifier:"en"))
            ContentView()
                .environment(\.locale, Locale(identifier:"ja"))
        }

    }
}
