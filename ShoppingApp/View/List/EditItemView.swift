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
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
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
    
    ///ItemViewModelに引数として渡すための変数
    @State var item: ItemDataType
    
    ///削除ボタンが押された時の確認アラート表示フラグ
    @State private var showDeleteAlert = false
    
    ///itemViewModelのための変数
    @EnvironmentObject var itemVM: ItemViewModel
    
    @State private var showTooLongAlert = false
    
    
    var body: some View {
        //ツールバー使用するためNavigationStack
        NavigationStack{
            VStack(spacing: 40.0){
                
                //ラベル選択用のピッカー
                HStack{
                    Text("移動先")
                    Picker(selection: $newNum, label: Text("aaa")){
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
                    Text("お気に入りに追加")
                }
                
                
                //タイトル入力用テキストフィールド
                
                //タイトル入力用テキストフィールド
                TextField("追加する項目", text: $newName)
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
                    itemVM.changeTitle(item: item, newTitle: newName, newLabel: newNum)
                    
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
                    Alert(title: Text("項目名を短くしてください"),
                          message: Text("50文字以内のみ登録可能です。"),
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
                        Alert(title: Text("アイテムの削除"),
                              message: Text("表示中のアイテムを削除しますか？"),
                              //OKならチェックした項目をリストから削除（未搭載）
                              primaryButton: .destructive(Text("削除する"), action: {
                            itemVM.deleteSelectedTask(item: item)
                            dismiss()
                        }),
                              secondaryButton: .cancel(Text("やめる"), action:{}))
                    }

                
                
                //ツールバーの設置
                //キーボード閉じるボタン
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("閉じる") {
                                isInputActive = false
                            }
                        }
                        
                        //シート閉じるボタン
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Spacer()
                            Button("閉じる") {
                                dismiss()
                            }
                        }
                        
                        //削除ボタン
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Spacer()
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                
                
            }
            .padding()
            
            //ナビゲーションバーの設定
            .navigationTitle("編集")
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
