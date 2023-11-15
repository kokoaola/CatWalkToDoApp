//
//  EditItemView.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/07.
//

import SwiftUI


///アイテム編集用のシート
struct EditItemView: View {
    ///ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "1"
    @AppStorage("label1") var label1 = "2"
    @AppStorage("label2") var label2 = "3"
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///名前入力用の変数
    @State private var newName = ""
    
    let oldLabel: Int
    
    ///ラベル入力用の変数
    @Binding var newNum: Int
    
    ///お気に入り追加用の変数
    @State private var isFavorite = false
    
    ///ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    ///選択されたタスク、ItemViewModelに引数として渡すための変数
    @State var item: ItemDataType
    
    ///削除ボタンが押された時の確認アラート表示フラグ
    @State private var showDeleteAlert = false
    
    ///itemViewModelのための変数
    @EnvironmentObject var itemVM: ItemViewModel
    
    @State private var showTooLongAlert = false
    
    
    var body: some View {
        //ツールバー使用するためNavigationStack
        NavigationStack{
            VStack(spacing: 50.0){
                
                //ラベル選択用のピッカー
                VStack{
                    HStack{
                        Text("Destination to Move")
                        Spacer()
                    }
                    Picker(selection: $newNum, label: Text("")){
                        Text(label0)
                            .tag(0)
                        Text(label1)
                            .tag(1)
                        Text(label2)
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.top)
                
                
                //お気に入りに追加のトグルスイッチ
                Toggle(isOn: $isFavorite){
                    Text("Add to Favorites")
                }
                
                
                //タイトル入力用テキストフィールド
                
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
                    
                    Task{
                        //項目をデータベースに追加
                        await itemVM.changeTitle(item: item, newTitle: newName, newLabel: newNum)
                    }

                    
                    //お気に入りOnならお気に入りリストに追加
                    if isFavorite{
                        itemVM.changeFavoriteList(itemName: newName, delete: false)
                        
                        //お気に入りリストに存在するが、お気に入りスイッチがOFFになってる時
                    }else if !isFavorite && itemVM.favoriteList.contains(newName){
                        //お気に入りから削除する
                        itemVM.changeFavoriteList(itemName: newName, delete: true)
                    }
                    
                    dismiss() //追加後のページ破棄関数
                    

                },label: {
                    SaveButton() //ボタンデザインは別ファイル
                })
                
                //買い物完了ボタンが押された後の確認アラート
                .alert(isPresented: $showTooLongAlert){
                    Alert(title: Text("Please shorten the item name."),
                          message: Text("Only up to 50 characters can be registered."),
                          //OKならチェックした項目をリストから削除
                          dismissButton: .default(Text("OK")))
                }
                
                
                
                .onAppear{
                    newName = item.title
                    if itemVM.favoriteList.contains(item.title){
                        isFavorite = true
                    }else{
                        isFavorite = false
                    }
                }

                
                Spacer()
                
                //削除ボタンが押された後の確認アラート
                    .alert(isPresented: $showDeleteAlert){
                        Alert(title: Text("Delete Item"),
                              message: Text("Do you want to delete the displayed item?"),
                              //OKならチェックした項目をリストから削除（未搭載）
                              primaryButton: .destructive(Text("Delete"), action: {
                            itemVM.deleteSelectedTask(item: item)
                            dismiss()
                        }),
                              secondaryButton: .cancel(Text("Cancel"), action:{}))
                    }

                
                
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
                            .accessibilityLabel("Close")
                            .accessibilityAddTraits(.isButton)
                        }
                        
                        //削除ボタン
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Spacer()
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 8)
                            }
                            .accessibilityLabel("Delete")
                            .accessibilityHint("Delete this task, \(item.title)")
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                
                
            }
            .padding()
            
            //ナビゲーションバーの設定
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
}

struct EditItemView_Previews: PreviewProvider {
    @State static var num = 0
    static let item = ItemDataType(id: "A", title: "AA", index: 1, label: 0, checked: false, timestamp: Date())
    static var previews: some View {
        EditItemView(oldLabel: 0, newNum: $num, item: item)
            .environmentObject(ItemViewModel())
    }
}
