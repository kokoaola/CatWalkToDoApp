//
//  FavoriteList.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/10/04.
//

import SwiftUI

struct FavoriteList: View{
    //コアデータ用のコード
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Entity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.timestamp, ascending: true)],
        //お気に入りものだけ抽出
        predicate: NSPredicate(format: "favorite == %@", NSNumber(value: true)), animation: .default
    )private var favoriteItems: FetchedResults<Entity>

    //削除したいアイテムを格納するプロパティ
    @State var delete = ""
    
    var body: some View{
        ZStack{
        List{
            ForEach(makeItemArray(array: favoriteItems), id: \.self){ item in
                let nu = makeItemArray(array:favoriteItems).firstIndex(of: item)! + 1
               
                HStack{
                    Text("No.\(nu)  ")
                    //タイトル表示
                    Text(item)
                    Spacer()
                    //お気に入り用スター表示
                    Group{
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .opacity(0.8)
                            .onTapGesture {
                                delete = item
                                for item in favoriteItems{
                                    if item.title == delete{
                                        item.favorite = false
                                        try? viewContext.save()
                                    }
                                    }
                                }
                            }
                        }
                
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                
                }
            }
        }
    }
}


struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList()
    }
}
