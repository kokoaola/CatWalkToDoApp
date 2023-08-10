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
    var labelNum: Int = 0
    
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
                    //チェックボックス表示
                    Image(systemName: item.checked ? "checkmark.square.fill": "square")
                        .font(.title2)
                    //タイトル表示
                    Text(item.title)
                        .strikethrough(item.checked ? true: false)
                    Text("\(item.index)")
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
                    itemVM.toggleCheck(item: item, labelNum: labelNum)
                }
            }
            .onMove(perform: moveItem)
            
            Spacer().frame(height: 40)
                .listRowBackground(EmptyView())
        }

        
        //タスク編集用のシート
        .sheet(isPresented: $showEditSheet, content: {
            if let item = selectedItem {
                EditItemView(oldLabel: labelNum, item: item).environmentObject(itemVM)
            }
        })
        
        .onAppear{
            print("View label0Item", itemVM.label0Item)
            print("View label1Item", itemVM.label1Item)
            print("View label2Item", itemVM.label2Item)
//            switch labelNum{
//            case 0:
//                filterdList = itemVM.label0Item
//                print(itemVM.label0Item)
//            case 1:
//                filterdList = itemVM.label1Item
//                print(itemVM.label1Item)
//            default:
//                filterdList = itemVM.label2Item
//                print(itemVM.label2Item)
//            }
            
        }
        
//        .onAppear{
//            print("Appear")
//            list = filterdList
//        }
//        .onChange(of: labelNum, perform: { newValue in
//            list = filterdList
//        })
        
        //処理中はタップ不可
        .disabled(itemVM.isBusy)
        
        //背景色変える
        .scrollContentBackground(.hidden)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        
        list.move(fromOffsets: source, toOffset: destination)
        itemVM.renumber(label: labelNum, newArray: list)
        

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
