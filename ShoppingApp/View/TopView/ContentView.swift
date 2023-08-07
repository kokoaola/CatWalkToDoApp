//
//  ContentView.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
import CoreData


///アプリ起動時に表示されるビュー
struct ContentView: View {
    
    var body: some View {
        VStack{
            //表示内容をタブビューで切り替える
            TabView{
                
                //買い物リストビュー
                List_mainView()
                    .tabItem{
                        Label("買い物リスト", systemImage: "cart")
                    }
                
                //単価計算ビュー
                Keisan().tabItem{
                    Label("単価計算", systemImage: "arrow.2.squarepath")
                }
                
                //設定ビュー
                Setting_Top()
                    .tabItem{
                        Label("設定", systemImage: "gearshape")
                    }
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
