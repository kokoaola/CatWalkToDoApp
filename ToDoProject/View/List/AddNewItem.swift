//
//  AddNewTitle.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI

///タスクの新規追加シート
struct AddNewItem: View {
    
    ///ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "1"
    @AppStorage("label1") var label1 = "2"
    @AppStorage("label2") var label2 = "3"
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///名前入力用の変数
    @State var newName = ""
    
    ///ラベル選択ピッカー用の変数
    @State var newLabelNum = 0
    
    ///お気に入り追加フラグ
    @State var isFavorite = false
    
    ///ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    ///itemViewModelのための変数
    @EnvironmentObject var itemVM: ItemViewModel
    
    @State private var showTooLongAlert = false
    
    
    var body: some View {
        //ツールバー使用するためNavigationStack
        NavigationStack{
            VStack(spacing: 30.0){
                
                VStack(spacing:0){
                    
                    if !itemVM.favoriteList.isEmpty{
                        //お気に入り表示用タグ
                        HStack{
                            Text("Add from Favorites")
                            Spacer()
                        }.padding(.bottom)
                    }
                    
                    //タグ用のビュー
                    FlowLayout(spacing: 7) {
                        ForEach(itemVM.favoriteList, id: \.self) { tag in
                            Text(tag)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 12)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .cornerRadius(15)
                                .onTapGesture {
                                    newName = tag
                                    isFavorite = true
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.primary, lineWidth: tag == newName ? 1 : 0))
                        }
                    }
                }
                .font(.footnote)
                
                
                //ラベル選択用のピッカー
                HStack{
                    Text("Destination to Add")
                    Picker(selection: $newLabelNum, label: Text("")){
                        Text(label0)
                            .tag(0)
                        Text(label1)
                            .tag(1)
                        Text(label2)
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                
                
                //お気に入りに追加のスイッチ
                Toggle(isOn: $isFavorite){
                    Text("Add to Favorites")
                }
                
                
                //タイトル入力用テキストフィールド
                TextField("Task to Add", text: $newName)
                    .frame(height: 40)
                    .focused($isInputActive)
                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 1))
                
                //保存ボタン
                Button(action: {
                    
                    //入力された値が５０文字以上ならアラートを表示してリターン
                    if newName.count >= 50{
                        showTooLongAlert = true
                        return
                    }
                    //入力された値が空白ならリターン
                    if newName.isEmpty{ return }
                    
                    //項目をデータベースに追加
                    itemVM.addItem(title: newName, label: newLabelNum)
                    
                    //お気に入りOnならお気に入りリストに追加
                    if isFavorite{
                        itemVM.changeFavoriteList(itemName: newName, delete: false)
                        
                        //お気に入りリストに存在するが、お気に入りスイッチがOFFになってる時
                    }else if !isFavorite && itemVM.favoriteList.contains(newName){
                        //お気に入りから削除する
                        itemVM.changeFavoriteList(itemName: newName, delete: true)
                    }
                    
                    dismiss() //追加後はページ破棄
                    
                },label: {
                    SaveButton() //ボタンデザインは別ファイル
                }).padding()
                
                    .onAppear{
                        isInputActive = true
                    }
                Spacer()
                
                //ツールバーの設置
                //キーボード閉じるボタン
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Close") {
                                isInputActive = false
                            }
                        }
                        
                        //シート閉じるボタン
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Spacer()
                            Button("Close") {
                                dismiss()
                            }
                        }
                    }
            }

            .padding()
            
            //ナビゲーションバーの設定
            .navigationTitle("Create New")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            
            //買い物完了ボタンが押された後の確認アラート
            .alert(isPresented: $showTooLongAlert){
                Alert(title: Text("Please shorten the item name."),
                      message: Text("Only up to 50 characters can be registered."),
                      //OKならチェックした項目をリストから削除
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddNewItem_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItem()
            .environmentObject(ItemViewModel())
    }
}
