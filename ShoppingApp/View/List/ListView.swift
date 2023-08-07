//
//  Tesst2.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

///買い物リストのリスト部分
struct ShoppingList1: View {
    ///引数で受け取る配列（リスト表示用）
    @Binding var filterdList: [ItemDataType]
    
    ///項目編集シート用表示フラグ
    @State private var showEditSheet = false
    
    ///項目編集シートに渡すItemDataTypeを格納する変数
    @State private var selectedItem: ItemDataType? = nil
    
    ///itemViewModelのための変数
    @EnvironmentObject var itemVM: ItemViewModel

    
    var body: some View {
        
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
                    
                    //infoマーク表示
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                        .opacity(0.8)
                    //infoマークタップで編集シート表示
                        .onTapGesture {
                            selectedItem = item
                            showEditSheet = true
                        }
                }
                .listRowBackground(Color.clear)
                .opacity(item.checked ? 0.1 : 1)
                
                //セルタップでボックスにチェック
                .contentShape(Rectangle())
                .onTapGesture {
                    itemVM.toggleCheck(item: item)
                }
            }
            Spacer().frame(height: 40)
                .listRowBackground(EmptyView())
        }

        
        //タスク編集用のシート
        .sheet(isPresented: $showEditSheet, content: {
            if let item = selectedItem {
                EditItemView(item: item).environmentObject(itemVM)
            }
        })
        
        //処理中はタップ不可
        .disabled(itemVM.isBusy)
        
        //背景色変える
        .scrollContentBackground(.hidden)
    }
}



struct ShoppingList1_Previews: PreviewProvider {
    @State static var aaa  = false
    @State static var a = [ItemDataType]()
    static var previews: some View {
        ShoppingList1(filterdList: $a)
            .environmentObject(ItemViewModel())
    }
}
