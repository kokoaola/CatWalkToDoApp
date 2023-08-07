//
//  EditItemView.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/07.
//

import SwiftUI

struct EditItemView: View {
    //ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
    
    @EnvironmentObject var itemVM: ItemViewModel
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    //名前入力用の変数
    @State var newName = ""
    
    //ラベル入力用の変数
    @State var num = 0
    
    //お気に入り追加用の変数
    @State var isFavorite = false
    
    //ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    @State var item: ItemDataType
    
    
    
    
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 10.0){
                
                
                Group{
                    ///ラベル選択用のピッカー
                    HStack{
                        Text("追加先")
                        Picker(selection: $num, label: Text("aaa")){
                            Text(label0)
                                .tag(0)
                            Text(label1)
                                .tag(1)
                            Text(label2)
                                .tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    
                    ///お気に入りに追加のスイッチ
                    Toggle(isOn: $isFavorite){
                        Text("お気に入りに追加")
                    }
                    ///入力用テキストフィールド
                    TextField("追加する項目", text: $newName)
                        .focused($isInputActive)
                        .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color(UIColor.label), lineWidth: 0.1))
                    
                }.padding()
                
                ///追加ボタン
                Button(action: {
                    //入力された値が空白以外なら配列に追加
                    if !newName.isEmpty{
                        itemVM.changeTitle(item: item, newTitle: newName)
                        
                        if isFavorite{
                            itemVM.changeFavoriteList(itemName: newName, delete: false)
                            
                            //お気に入りリストに存在するが、お気に入りスイッチがOFFになってる時
                        }else if !isFavorite && itemVM.favoriteList.contains(newName){
                            //お気に入りから削除する
                            itemVM.changeFavoriteList(itemName: newName, delete: true)
                        }
                        dismiss() //追加後のページ破棄関数
                    }
                },label: {
                    TuikaButton() //ボタンデザインは別ファイル
                })
                .padding()
                .onAppear{
                    print(item)
                    num = Int(item.label)
                    newName = item.title
                    if itemVM.favoriteList.contains(item.title){
                        isFavorite = true
                    }else{
                        isFavorite = false
                    }
                }
                
                Spacer()
                
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("閉じる") {
                                isInputActive = false
                            }
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Spacer()
                            Button("キャンセル") {
                                dismiss()
                            }
                        }
                        
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Spacer()
                            Button("削除する") {
                                dismiss()
                            }
                        }
                        
                    }
                
                    
            }
        }
    }
    
}

struct EditItemView_Previews: PreviewProvider {
    static let item = ItemDataType(id: "A", title: "aaa", label: 2, checked: false, finished: false, timestamp: Date())
    static var previews: some View {
        EditItemView(item: item)
            .environmentObject(ItemViewModel())
    }
}
