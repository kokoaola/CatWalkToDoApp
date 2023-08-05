//
//  Tesst2.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI
///買い物リスト(ラベル0)

struct ShoppingList1: View {
    
    @Binding var isAlart: Bool
    @EnvironmentObject var itemVM: ItemViewModel
    @Binding var filterdList: [ItemDataType]
    
    var body: some View {
        
        ZStack{
            VStack{
                //買い物リスト本体
                List{
                    ForEach(filterdList){ item in
                        HStack{
                            //チェックボックス表示
                            Image(systemName: item.checked ? "checkmark.square.fill": "square")
                                .font(.title2)
                            //タイトル表示
                            Text(item.title)
                                .strikethrough(item.checked ? true: false)
                            Spacer()
                            //お気に入り用スター表示
                            //                            Group{
                            //                                Image(systemName: "star.fill")
                            //                                    .foregroundColor(itemVM.favoriteList.contains(item.title) ? .yellow : Color(UIColor.systemGray4))
                            //                                    .opacity(0.8)
                            //                                    .onTapGesture {
                            //                                        if itemVM.favoriteList.contains(item.title){
                            //                                            itemVM.changeFavoriteList(itemName: item.title, delete: true)
                            //                                        }else{
                            //                                            if itemVM.favoriteList.count > 10{
                            //                                                isAlart.toggle()
                            //                                                return
                            //                                            }
                            //                                            itemVM.changeFavoriteList(itemName: item.title, delete: false)
                            //                                        }
                            //                                    }
                            //                            }
                        }
                        
                        .listRowBackground(Color.clear)
                        .foregroundColor(item.checked ? Color(UIColor.secondaryLabel): Color(UIColor.label))
                        .contentShape(Rectangle())
                        
                        //タップでボックスにチェック機能
                        .onTapGesture {
                            itemVM.toggleCheck(item: item)
                        }
                        
                    }
                }
                .disabled(itemVM.isBusy)
                //背景色変える
                .scrollContentBackground(.hidden)
            }
        }
    }
}



struct ShoppingList1_Previews: PreviewProvider {
    @State static var aaa  = false
    @State static var a = [ItemDataType]()
    static var previews: some View {
        ShoppingList1(isAlart: $aaa, filterdList: $a)
            .environmentObject(ItemViewModel())
    }
}
