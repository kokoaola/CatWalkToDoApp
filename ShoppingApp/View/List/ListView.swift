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
    @Binding var labelNum: Int
    
    ///項目編集シート用表示フラグ
    @State private var showEditSheet = false
    
    ///項目編集シートに渡すItemDataTypeを格納する変数
    @State private var selectedItem: ItemDataType? = nil
    
    ///itemViewModelのための変数
    @EnvironmentObject var itemVM: ItemViewModel
    
    @State var list: [ItemDataType] = []

    
    var body: some View {
        
        //買い物リスト本体
        List{
            
            ForEach(filterdList){ item in
                HStack{
                    Text("")
                    //チェックボックス表示
                    Image(systemName: item.checked ? "checkmark.square.fill": "square")
                        .font(.title2)
                    //タイトル表示
                    Text(item.title)
                        .strikethrough(item.checked ? true: false)
                    Text("index: \(item.index)")
                    Spacer()
                    
                    //infoマーク表示
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.gray)
                        .opacity(0.8)
                    //infoマークタップで編集シート表示
                        .onTapGesture {
                            selectedItem = item
                            showEditSheet = true
                        }

                }
                .listRowBackground(Color.clear)
                .opacity(item.checked ? 0.3 : 1)
                .padding(.vertical, 8)
                
                //セルタップでボックスにチェック
                .contentShape(Rectangle())
                .onTapGesture {
                    itemVM.toggleCheck(item: item, labelNum: labelNum)
                }
            }
            .onMove(perform: moveItem)
//            .listRowSeparator(.)

            
            Spacer().frame(height: 40)
                .listRowBackground(EmptyView())
            
            
        }
        .listStyle(.sidebar)

        
        //タスク編集用のシート
        .sheet(isPresented: $showEditSheet, content: {
            if let item = selectedItem {
                EditItemView(oldLabel: labelNum, newNum: $labelNum, item: item).environmentObject(itemVM)
            }
        })
        
        //処理中はタップ不可
        .disabled(itemVM.isBusy)
        
        //背景色変える
        .scrollContentBackground(.hidden)
    }
    
    func moveItem(offsets: IndexSet, index: Int) {
        let label: String
        
        switch labelNum{
        case 0:
            label = "label0Item"
        case 1:
            label = "label1Item"
        case 2:
            label = "label2Item"
        default:
            label = "label0Item"
        }
        
        filterdList.move(fromOffsets: offsets, toOffset: index)
        itemVM.updateIndexesForCollection(labelNum: labelNum)
    }
}



struct ShoppingList1_Previews: PreviewProvider {
    @State static var aaa  = 0
    @State static var a = [ItemDataType]()
    static var previews: some View {
        ShoppingList1(filterdList: $a, labelNum: $aaa)
            .environmentObject(ItemViewModel())
    }
}
