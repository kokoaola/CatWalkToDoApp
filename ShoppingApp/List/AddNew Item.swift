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
    
    //コアデータ用のコード
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Entity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.timestamp, ascending: true)],
        //ラベルが０、未完了のものだけ抽出
        predicate: NSPredicate(format: "favorite == %@", NSNumber(value: true)), animation: .default
    )private var favoriteItems: FetchedResults<Entity>
    
    //@State var favoriteArray : [String] = retunFavoriteArray(items: favoriteItems)
    
    
    //名前入力用の変数
    @State var newName = ""
    
    //ラベル入力用の変数
    @State var num = 0
    
    //お気に入り追加用の変数
    @State var isFavorite = false
    
    //ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    //let testArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]

    
    var body: some View {
        let testArray: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        var favoriteArray : [String] = retunFavoriteArray(items: favoriteItems)
        let row = [GridItem(.flexible(minimum: 100.0), spacing: 10),
                   GridItem(.flexible(minimum: 100.0), spacing: 10),
                   GridItem(.flexible(minimum: 100.0), spacing: 10),
                   GridItem(.flexible(minimum: 100.0), spacing: 10)]
        
        VStack(spacing: 1.0){
            HStack{
            Text("お気に入りから追加")
                    .padding([.top, .leading])
                Spacer()
        }
                .font(.footnote)
                ScrollView([.horizontal]){
                    LazyVGrid(columns: row, alignment: .center, spacing: 10){
                        ForEach(0 ..< favoriteArray.count, id: \.self){num in
                            Text(favoriteArray[num])
                                .opacity(0.7)
                                .frame(minWidth: 1, maxWidth: .infinity, minHeight: 30, maxHeight: 30)
                                .background(Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(.gray), lineWidth: 1.0))
                                .padding(1)

//                            Text(favoriteArray[num])
//                                .frame(width: 60, height: 30)
//                                .foregroundColor(Color(UIColor.label))
//                                //.background(Color(UIColor.secondarySystemBackground))
//                                .overlay(Capsule()
//                                    .stroke(Color(.gray), lineWidth: 1.0))
//                                .padding()
                                .onTapGesture {
                                newName = favoriteArray[num]
                                isFavorite = true}
                        }
                        
                    }
                    
//                    if 0 < favoriteArray.count{
//                        HStack(spacing: 10.0){
//                            ForEach(0 ..< favoriteArray.count / 2 , id: \.self){ i in
//                                FavoriteButton(title: favoriteArray[i])
//                                    .onTapGesture {
//                                        newName = favoriteArray[i]
//                                        isFavorite = true
//                                    }
//                                    .padding(1.0)
//                            }
//                        }
//                        if 4 < favoriteArray.count{
//                            HStack(spacing: 10.0){
//                                ForEach(0 ..< favoriteArray.count / 2 , id: \.self){ i in
//                                    FavoriteButton(title: favoriteArray[favoriteArray.count / 2 + i])
//                                        .onTapGesture {newName = favoriteArray[favoriteArray.count / 2 + i]
//                                            isFavorite = true
//                                        }
//                                        .padding(1.0)
//                                }
//                            }
//                        }
//                    }
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
                
                //.frame(width: 250.0)
                
                ///追加ボタン
                Button(action: {
                    //入力された値が空白以外なら配列に追加
                    if !newName.isEmpty{
                        save2(title: newName, label: Int16(num))
                        isFavorite = false
                        dismiss() //追加後のページ破棄関数
                    }
                },label: {
                    TuikaButton() //ボタンデザインは別ファイル
                }).padding()
                Spacer()
            }
        .onAppear{
            favoriteArray = retunFavoriteArray(items: favoriteItems)
        }
        }

//保存用の関数
func save2(title: String, label: Int16){
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    let newItem = Entity(context: context)
    newItem.label = label
    newItem.title = title
    newItem.timestamp = Date()
    newItem.favorite = isFavorite
    newItem.checked = false
    newItem.finished = false
    /// コミット
    try? context.save()
}

func retunFavoriteArray(items: FetchedResults<Entity>) -> [String]{
    var favorite:[String] = []
    
    for item in items {
        if !favorite.contains(item.title!){
            favorite.append(item.title!)
        }
    }
    return favorite
}


}

struct AddNewItem_Previews: PreviewProvider {
    // @State static var aaa = [shoppingData(title: "aaa", label: 0)]
    static var previews: some View {
        AddNewItem()
    }
}
