//
//  AddNewTitle.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI
///プラスマークの新規追加ビュー
///今後はリストに直接追加できるよう編集して、このビューは消える予定

struct AddNewItem: View {
    
    //ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
    
    @EnvironmentObject var itemVM: ItemViewModel
    
    //名前入力用の変数
    @State var newName = ""
    
    //ラベル入力用の変数
    @State var num = 0
    
    //お気に入り追加用の変数
    @State var isFavorite = false
    
    //ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        VStack(spacing: 1.0){
            HStack{
                Text("お気に入りから追加")
                    .padding([.top, .leading])
                Spacer()
            }
            .font(.footnote)
            
            FlowLayout(alignment: .center, spacing: 7) {
                ForEach(itemVM.favoriteList, id: \.self) { tag in
                    Text(tag)
                        .font(.footnote)
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
                                .stroke(Color.primary, lineWidth: tag == newName ? 1 : 0)
                        )
                }
            }
            
            .padding()
            
            
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
                    }.pickerStyle(.segmented)
                }
                
                ///お気に入りに追加のスイッチ
                Toggle(isOn: $isFavorite){
                    Text("お気に入りに追加")
                }
                ///入力用テキストフィールド
                TextField("追加する項目", text: $newName)
                    .overlay(RoundedRectangle(cornerRadius: 1).stroke(Color(UIColor.label), lineWidth: 0.1))
                
            }.padding()
            
            ///追加ボタン
            Button(action: {
                //入力された値が空白以外なら配列に追加
                if !newName.isEmpty{
                    itemVM.addItem(title: newName, label: Int16(num))
                    //                        save2(title: newName, label: Int16(num))
                    isFavorite = false
                    dismiss() //追加後のページ破棄関数
                }
            },label: {
                TuikaButton() //ボタンデザインは別ファイル
            }).padding()
            Spacer()
        }
        
    }
    
}

struct AddNewItem_Previews: PreviewProvider {
    static var previews: some View {
        AddNewItem()
            .environmentObject(ItemViewModel())
    }
}
