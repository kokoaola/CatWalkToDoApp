//
//  Tesst2.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

///買い物リストのリスト部分
struct ListView: View {
    ///ViewModelのための変数
    @ObservedObject var listVM: ListViewModel
    
    ///引数で受け取る配列（リスト表示用）
    @Binding var filterdList: [ItemDataType]
    @Binding var labelNum: Int
    
    ///項目編集シート用表示フラグ
    @State private var showEditSheet = false
    
    ///項目編集シートに渡すItemDataTypeを格納する変数
    @State private var selectedItem: ItemDataType? = nil

    
    var body: some View {
        if filterdList.isEmpty{
            ///保存されたアイテムが空ならチュートリアル吹き出しを表示
            TutorialSpeechBubble()
        }else{
            ///保存されたアイテムが１つ以上あれば、リストにして表示
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

                        //VoiceOver用
                        .contentShape(Rectangle())
                        //タスク名とチェック済みかどうかの読み上げ
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(item.checked ? LocalizedStringKey("Checked,\(item.title)") : LocalizedStringKey("Unchecked,\(item.title)"))
                        .accessibilityAddTraits(.isButton)
                        
                        
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
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .contentShape(Rectangle())
                            .editAccessibility(label: "Edit", removeTraits: .isImage, addTraits: .isButton)
                            .accessibilityHint(LocalizedStringKey("Edit this task, \(item.title)"))
                    }//HStackここまで
                    
                    
                    .listRowBackground(Color.clear)
                    .opacity(item.checked ? 0.3 : 1)
                    //セルタップでボックスにチェック
                    .contentShape(Rectangle())
                    //タップでチェックを反転＋猫歩く
                    .onTapGesture {
                        listVM.toggleItemCheckStatus(item: item)
                        
                        //猫が歩いていなくて、チェックマークがtrueの時
                        if !listVM.isMoving && !item.checked{
                            //猫を裏返す
                            listVM.isFacingRight.toggle()
                            //猫移動中にセット
                            listVM.isMoving = true
                            //猫歩く
                            withAnimation() {
                                listVM.stayPositionRight.toggle()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                                listVM.isMoving = false
                            }
                        }
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
                    AddNewItemScreen(newLabelNum: $labelNum, editItem:item)
                }
            })
            
            //背景色変える
            .scrollContentBackground(.hidden)
        }
    }
    
    func moveItem(offsets: IndexSet, index: Int) {
        filterdList.move(fromOffsets: offsets, toOffset: index)
        listVM.updateAfterMove(labelNum: labelNum)
//        itemVM.updateIndexesForCollection(labelNum: labelNum)
    }
}

