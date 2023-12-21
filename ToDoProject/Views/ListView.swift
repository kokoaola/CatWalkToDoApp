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
    
    @State var selectedItem: ItemDataType? = nil
    @State var showEditSheet = false
    
    var body: some View {
        if filterdList.isEmpty{
            ///保存されたアイテムが空ならチュートリアル吹き出しを表示
            TutorialSpeechBubble()
        }else{
            ///保存されたアイテムがあれば、リストにして表示
            //買い物リスト本体
            List{
                ForEach(filterdList){ item in
                    listLowView(listVM: listVM, item: item, selectedItem: $selectedItem, showEditSheet: $showEditSheet)
                        .listRowBackground(Color.clear)
                        .opacity(item.checked ? 0.3 : 1)
                        .contentShape(Rectangle())
                    ///タップでチェックを反転＋猫歩く
                        .onTapGesture {
                            ///チェックを反転して保存
                            listVM.toggleItemCheckStatus(item: item)
                            ///猫歩くアニメーションを開始
                            listVM.walkingCat(itemCheckStatus: item.checked)
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
            .scrollContentBackground(.hidden)//背景色変える
            
            //タスク編集用のシート
            .sheet(isPresented: $showEditSheet, onDismiss: {
                // シートが閉じられた時に実行する処理（リストの更新）
                selectedItem = nil
            }) {
                if let item = selectedItem {
                    AddNewItemScreen(newLabelNum: $labelNum, editItem:item)
                }
            }
        }
    }
    
    func moveItem(offsets: IndexSet, index: Int) {
        filterdList.move(fromOffsets: offsets, toOffset: index)
        listVM.updateAfterMove(labelNum: labelNum)
    }
}


///リストの1行分のビュー
struct listLowView: View{
    @ObservedObject var listVM: ListViewModel
    var item: ItemDataType
    @Binding var selectedItem: ItemDataType?
    @Binding var showEditSheet: Bool
    
    var body: some View{
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
    }
}
