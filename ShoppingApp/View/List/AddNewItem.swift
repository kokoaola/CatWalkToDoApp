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
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
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
    
    
    var body: some View {
        //ツールバー使用するためNavigationStack
        NavigationStack{
            VStack(spacing: 40.0){
                
                VStack(spacing:0){
                    //お気に入り表示用タグ
                    HStack{
                        Text("お気に入りから追加")
                        Spacer()
                    }.padding(.vertical)
                    
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
                        Text("追加先")
                        Picker(selection: $newLabelNum, label: Text("aaa")){
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
                        Text("お気に入りに追加")
                    }
                    
                    
                    //タイトル入力用テキストフィールド
                    TextField("追加する項目", text: $newName)
                        .frame(height: 40)
                        .focused($isInputActive)
                        .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 1))
                
                //保存ボタン
                Button(action: {
                    //入力された値が空白以外なら配列に追加
                    if !newName.isEmpty{
                        itemVM.addItem(title: newName, label: Int16(newLabelNum))
                        
                        if isFavorite{
                            itemVM.changeFavoriteList(itemName: newName, delete: false)
                            
                            //お気に入りリストに存在するが、お気に入りスイッチがOFFになってる時
                        }else if !isFavorite && itemVM.favoriteList.contains(newName){
                            //お気に入りから削除する
                            itemVM.changeFavoriteList(itemName: newName, delete: true)
                        }
                        dismiss() //追加後はページ破棄
                    }
                },label: {
                    TuikaButton() //ボタンデザインは別ファイル
                }).padding()
                
                Spacer()
                
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
                    }

                
                
            }
            .padding()
            
            //ナビゲーションバーの設定
            .navigationTitle("新規作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
}

struct AddNewItem_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItem()
            .environmentObject(ItemViewModel())
    }
}
