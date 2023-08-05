//
//  ShoppingList2.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/30.
//

import SwiftUI

struct ShoppingList2: View {
    //コアデータ用のコード
//        @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        entity: Entity.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.timestamp, ascending: true)],
//            //ラベルが1、未完了のものだけ抽出
//            predicate: NSPredicate(format: "label == %d And finished == %@", 1, NSNumber(value: false)), animation: .default
//        )private var items: FetchedResults<Entity>
    
    var body: some View {
        
        ZStack{
            VStack{
                //買い物リスト本体
                List{
//                    ForEach(items){ item in
//                        HStack{
//                            //チェックボックス表示
//                            Image(systemName: item.checked ? "checkmark.square.fill": "square")
//                            //タイトル表示
//                            Text(item.title ?? "aaa")
//                                .strikethrough(item.checked ? true: false)
//                            Spacer()
//                            //お気に入り用スター表示
//                            Group{
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(item.favorite ? .yellow : Color(UIColor.systemGray4))
//                                    .opacity(0.6)
//                                    .onTapGesture {
//                                        //                                        item.favorite.toggle()
//                                        //                                        try? viewContext.save()
//                                        //                                        }
//                                    }
//                            }
//
//                            .listRowBackground(Color.clear)
//                            .foregroundColor(item.checked ? Color(UIColor.secondaryLabel): Color(UIColor.label))
//                            .contentShape(Rectangle())
//
//                            //タップでボックスにチェック機能
//                            .onTapGesture {
//                                //                            item.checked.toggle()
//                                //                            try? viewContext.save()
//                                                            }
//                            }
//                        }
                        //背景色変える
//                        .scrollContentBackground(.hidden)
                    }
                    .onAppear{}
                }
            }
        }
        }

struct ShoppingList2_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingList2()
    }
}
