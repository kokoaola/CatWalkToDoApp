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
    
    //項目追加シート用のBool
    @State var showAddSheet = false
    
    //項目追加シート用のBool
    @State var showEditSheet = false
    
    @State private var selectedItem: ItemDataType? = nil
    
    
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
                            //お気に入り用スター表示

                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                                    .opacity(0.8)
                                    .onTapGesture {
                                        selectedItem = item
                                        showEditSheet = true
                                    }
                            
                        }
                        
                        .listRowBackground(Color.clear)
                        .foregroundColor(item.checked ? Color(UIColor.secondaryLabel): Color(UIColor.label))
                        .contentShape(Rectangle())
                        
                        //タップでボックスにチェック機能
                        .onTapGesture {
                            itemVM.toggleCheck(item: item)
                            print(item)
                        }
                        
                    }
                }
                .sheet(isPresented: $showAddSheet, content: {
                    if let item = selectedItem {
                        AddNewItem().environmentObject(itemVM)
                    }
                })
                .sheet(isPresented: $showEditSheet, content: {
                    if let item = selectedItem {
                        EditItemView(item: item).environmentObject(itemVM)
                    }
                })
                .disabled(itemVM.isBusy)
                //背景色変える
                .scrollContentBackground(.hidden)
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
