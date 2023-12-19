//
//  AddNewItemScreenViewModel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import Foundation


///AddNewItemScreenのビューモデル
class AddNewItemScreenViewModel: ViewModelBase {
    ///タスクのお気に入りリストを格納した配列
    var favoriteList = [String]()
    
    ///追加するタスク名を格納した変数
    @Published var newName = ""
    
    ///タスク名が50文字以上か判別するプロパティ
    var isOver50: Bool{
        newName.count >= 50
    }
    ///タスク名が空白か判別するプロパティ
    var isEmpty: Bool{
        newName.isEmpty
    }


    ///イニシャライザ
    override init() {
        //お気に入り登録されたタスクを取得
        self.favoriteList = UserDefaults.standard.object(forKey:Constants.favoriteListKey) as? [String] ?? [String]()
    }
    
    
    ///アイテムをFireStoreデータベースに新規保存するメソッド
    func addNewItem(title: String, label: Int) async{
        
        //追加するインデックス番号を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[label].count
        
        //データベースへの書き込み
        await firebaseService.addItemToCollection(title: title, label: label, index: newIndex)
        
        //追加したコレクションをリロード
        fetchSelectedData(label)
    }
    
    
    ///タスク名をお気に入りリストへ保存するメソッド
    func addFavoriteList(){
        //すでに同名のタスクが存在する場合は何もしない
        if favoriteList.contains(newName){
            return
        }
        //お気に入り配列に追加して更新
        favoriteList.append(newName)
        
        //ユーザーデフォルトに保存
        defaults.set(favoriteList, forKey: Constants.favoriteListKey)
    }
    
    
    ///タスク名をお気に入りリストから削除するメソッド
    func deleteFavoriteList(){
        //itemName以外を配列に格納
        let newArray = favoriteList.filter { $0 != newName }
        //お気に入り配列を更新
        favoriteList = newArray
        //ユーザーデフォルトに保存
        defaults.set(newArray, forKey: Constants.favoriteListKey)
    }
}
