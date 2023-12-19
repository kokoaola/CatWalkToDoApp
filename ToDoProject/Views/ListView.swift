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
    @Binding var isFlip: Bool
    @Binding var isMoving: Bool
    
    var body: some View {
        
        ///保存されたアイテムが空ならチュートリアル吹き出しを表示
        if filterdList.isEmpty{
            VStack{
                SpeechBubbleView1()
                    .offset(x:0, y:-10)
                    .overlay{
                        VStack{
                            Text("By long-pressing index,\nyou can edit label name.")
                                .fontWeight(.bold)
                                .lineSpacing(10)
                        }
                        .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                        .foregroundColor(.black).opacity(0.6)
                    }
                
                
                Spacer()
                
                
                
                SpeechBubbleView2()
                    .offset(x:0, y:-10)
                    .overlay{
                        VStack{
                            Text("Add tasks from here.")
                                .fontWeight(.bold)
                                .lineSpacing(10)
                        }
                        .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                        .foregroundColor(.black).opacity(0.6)
                    }
                
                
                
                Spacer()
                    .frame(height: 50)
                
                
            }
            .padding(.vertical, 50)
            ///保存されたアイテムが１つ以上あれば、リストにして表示
        }else{
            //買い物リスト本体
            List{
                
                ForEach(filterdList){ item in
                    HStack{
                        //１列の中でVoiceOverのタップ領域を分けるためのHStack
                        HStack{
                            Text("")
                            //チェックボックス表示
                            Image(systemName: item.checked ? "checkmark.square.fill": "square")
                                .font(.title2)
                            //タイトル表示
                            Text(item.title)
                                .strikethrough(item.checked ? true: false)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                        //VoiceOver用
                        //タスク名とチェック済みかどうかの読み上げ
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(item.checked ? LocalizedStringKey("Checked,\(item.title)") : LocalizedStringKey("Unchecked,\(item.title)"))
                        .accessibilityAddTraits(.isButton)
                        .accessibilityRemoveTraits(.isSelected)
                        
                        
                        //編集マーク表示
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.gray)
                            .opacity(0.8)
                        //編集マークタップで編集シート表示
                            .onTapGesture {
                                selectedItem = item
                                showEditSheet = true
                            }
                        //VoiceOver用
                            .padding(.vertical,10)
                            .padding(.horizontal, 15)
                            .contentShape(Rectangle())
                            .accessibilityRemoveTraits(.isImage)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("Edit")
                            .accessibilityHint("Edit this task, \(item.title)")
                        
                        
                    }
                    .listRowBackground(Color.clear)
                    .opacity(item.checked ? 0.3 : 1)
                    //セルタップでボックスにチェック
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !isMoving && !item.checked{
                            self.isFlip.toggle()
                            isMoving = true
                            withAnimation() {
                                self.goRight.toggle()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                                isMoving = false
                            }
                        }
                        itemVM.toggleItemCheckStatus(item: item)
                    }
                }
                .onMove(perform: moveItem)
                
                //新規追加ボタンと一番下のタスクが被らないようにするための空白
                Spacer()
                    .frame(height: 40)
                    .listRowBackground(EmptyView())
                    .accessibilityHidden(true)
            }
            .foregroundColor(AppSetting.fontColor)
            .listStyle(.sidebar)
            .padding(.horizontal,-15)
            
            //タスク編集用のシート
            .sheet(isPresented: $showEditSheet, content: {
                if let item = selectedItem {
                    EditItemScreen(oldLabel: labelNum, newNum: $labelNum, item: item).environmentObject(itemVM)
                }
            })
            
            //背景色変える
            .scrollContentBackground(.hidden)
        }
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
        ListView(filterdList: $a, labelNum: $aaa, goRight: $startAnimation, isFlip: $flip,isMoving: $flip)
            .environmentObject(ItemViewModel())
    }
}
