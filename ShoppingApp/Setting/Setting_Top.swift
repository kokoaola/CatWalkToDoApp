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
            VStack{
                List{
                    NavigationLink(destination: {
                        AddNewLabel_View()
                    }, label: {Text("ラベルの編集")})
                    NavigationLink(destination: {
                        FavoriteList()
                    }, label: {Text("お気に入りリスト編集")})
//                    NavigationLink(destination: {
//                        Syukei_View()
//                    }, label: {Text("買い物頻度の確認（おまけ機能）")})
                }
            }
            .navigationTitle(Text("各種設定"))
            .navigationBarTitleDisplayMode(.inline)
        }.scrollContentBackground(.hidden)

    }
}

struct Setting_Top_Previews: PreviewProvider {
    static var previews: some View {
        Setting_Top()
    }
}
