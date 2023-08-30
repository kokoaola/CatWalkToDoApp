//
//  Tesst2.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

///買い物リストのリスト部分
struct ListView: View {
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
    
    
    ///猫動かす用
    @Binding var goRight: Bool
    @Binding var flip: Bool
    @Binding var shouldPlay: Bool
    
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
                    if !shouldPlay && !item.checked{
                        self.flip.toggle()
                        shouldPlay = true
                        withAnimation() {
                            self.goRight.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                            shouldPlay = false
                        }
                    }
                    
                    itemVM.toggleCheck(item: item, labelNum: labelNum)
                    

                }
            }
            .onMove(perform: moveItem)
            
            Spacer()
                .frame(height: 40)
                .listRowBackground(EmptyView())
        }
        .foregroundColor(AppSetting.fontColor)
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
        filterdList.move(fromOffsets: offsets, toOffset: index)
        itemVM.updateIndexesForCollection(labelNum: labelNum)
    }
}



struct ShoppingList1_Previews: PreviewProvider {
    @State static var aaa  = 0
    @State static var a = [ItemDataType]()
    @State static var startAnimation = false
    @State static var flip = false
    static var previews: some View {
        ListView(filterdList: $a, labelNum: $aaa, goRight: $startAnimation, flip: $flip,shouldPlay: $flip)
            .environmentObject(ItemViewModel())
    }
}
