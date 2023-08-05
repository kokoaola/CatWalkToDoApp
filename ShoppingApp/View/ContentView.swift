//
//  ContentView.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//
///メモ　11/2
///１  無駄なコード修正した,画面サイズからラベルの大きさを取得
///２　UIを勉強したらいじろう


import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        VStack{
            //下のタブビュー
            TabView{
                List_mainView()
                    .tabItem{
                        Label("買い物リスト", systemImage: "cart")
                    }
                Keisan().tabItem{
                    Label("単価計算", systemImage: "arrow.2.squarepath")
                }
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
