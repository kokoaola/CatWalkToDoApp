//
//  AddNewTitle.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI

///タスクの新規追加シート
struct AddNewItemScreen: View {
    ///itemViewModelのための変数
    @ObservedObject var AddNewItemScreenVM = AddNewItemScreenViewModel()
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///ラベル選択ピッカー用の変数
    @Binding var newLabelNum: Int
    
    ///お気に入り追加フラグ
    @State private var isFavorite = false
    
    ///ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    ///タスクの文字数が50文字以上の時に表示するアラート用フラグ
    @State private var showTooLongAlert = false
    
    
    var body: some View {
        //ツールバー使用するためNavigationStack
        NavigationStack{
            VStack(spacing: 50.0){
                
                VStack(spacing:0){
                    
                    //お気に入り登録されたタスクがある場合は文章を表示.font(.footnote)
                    if !AddNewItemScreenVM.favoriteList.isEmpty{
                        HStack{
                            Text("Add from Favorites")
                            Spacer()
                        }.padding(.bottom)
                    }
                    
                    //お気に入り登録されたタスク名をタグ形式で全て表示する
                    FlowLayout(spacing: 7) {
                        ForEach(AddNewItemScreenVM.favoriteList, id: \.self) { tag in
                            Text(tag)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 12)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .cornerRadius(15)
                                .onTapGesture {
                                    AddNewItemScreenVM.newName = tag
                                    isFavorite = true
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.primary, lineWidth: tag == AddNewItemScreenVM.newName ? 1 : 0))
                        }
                    }
                }
                .font(.footnote)
                
                
                //ラベル選択用のピッカー
                VStack{
                    HStack{
                        Text("Destination to Add")
                        Spacer()
                    }
                    Picker(selection: $newLabelNum, label: Text("")){
                        Text(AddNewItemScreenVM.indexLabel0)
                            .tag(0)
                        Text(AddNewItemScreenVM.indexLabel1)
                            .tag(1)
                        Text(AddNewItemScreenVM.indexLabel2)
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                
                //お気に入りに追加のトグルスイッチ
                Toggle(isOn: $isFavorite){
                    Text("Add to Favorites")
                }
                
                
                //タイトル入力用テキストフィールド
                TextField("Task to Add", text: $AddNewItemScreenVM.newName)
                    .frame(height: 40)
                    .focused($isInputActive)
                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 1))
                
                //保存ボタン
                Button(action: {
                    
                    //文字数が50文字のときはアラートを表示してリターン
                    if AddNewItemScreenVM.isOver50{
                        showTooLongAlert = true
                        return
                    }
                    //文字がからの時は何もせずリターン
                    if AddNewItemScreenVM.isEmpty{
                        return
                    }
                    
                    //項目をデータベースに追加
                    Task{
                        await AddNewItemScreenVM.addNewItem(title: AddNewItemScreenVM.newName, label: newLabelNum)
                    }
                    
                    
                    //お気に入りOnならお気に入りリストに追加
                    if isFavorite{
                        AddNewItemScreenVM.addFavoriteList()
                        
                    }else if !isFavorite && AddNewItemScreenVM.favoriteList.contains(AddNewItemScreenVM.newName){
                        //お気に入りリストに存在するが、お気に入りスイッチがOFFになってる時はお気に入りから削除
                        AddNewItemScreenVM.deleteFavoriteList()
                    }
                    //追加後はページ破棄
                    dismiss()
                    
                },label: {
                    SaveButton() //ボタンデザインは別ファイル
                }).padding()
                
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
                            .accessibilityLabel("Close")
                            .accessibilityAddTraits(.isButton)
                        }
                    }
            }
            
            .padding()
            
            //ナビゲーションバーの設定
            .navigationTitle("Create New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            
            //タスクの文字が長すぎる時のアラート
            .alert(isPresented: $showTooLongAlert){
                Alert(title: Text("Please shorten the item name."),
                      message: Text("Only up to 50 characters can be registered."),
                      //OKならチェックした項目をリストから削除
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

//struct AddNewItemScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AddNewItemScreen()
//            .environmentObject(ItemViewModel())
//    }
//}
