//
//  AddNewItemScreenViewModel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import Foundation


///AddNewItemScreenのビューモデル
class AddNewItemScreenViewModel: ViewModelBase {
    ///ユーザーデフォルト操作用
    let defaults = UserDefaults.standard
    
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
    func addNewItem(label: Int){
        
        //追加するインデックス番号を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[label].count
        
        //データベースへの書き込み
        //Firestoreの操作は非同期で実行されるが、FirebaseのaddDocumentメソッドはコールバックベースのAPIを使用しており、Swiftのawaitキーワードはない
        //コンプリーションハンドラを使用する場合、非同期操作が完了した後にコールバックが実行され、awaitを使用せずとも非同期処理の完了をハンドルすることができる
        firebaseService.addItemToCollection(title: newName, label: label, index: newIndex){ error in
            if let error = error { return } else {
                //追加したコレクションをリロード
                self.fetchSelectedData(label)
            }
        }
    }
    
    
    ///タイトルとラベル番号を変更して保存する
    func updateLabelAndTitle(item: ItemDataType,newLabel: Int) async{
        //ラベル番号を整数に直す
        let oldLabel = Int(item.label)
        
        if newLabel == oldLabel{
            //ラベル番号が同じでタイトルのみが変更された時の処理
            //アイテムのタイトル更新用のメソッドを呼び出す
            firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: item.checked, newTitle: newName){error in
                //コレクションをリロード
                self.fetchSelectedData(oldLabel)
            }
        }else{
            //ラベル番号も含めて変更された時の処理
            self.changeLabelNumber(item: item, newLabel: newLabel)
        }
        
    }
    
    
    ///ラベル番号が変更された時の処理
    func changeLabelNumber(item: ItemDataType,newLabel: Int){
        //ラベル番号を整数に直す
        let oldLabel = Int(item.label)
        
        //新規追加するためのインデックス番号をカウント数から取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[newLabel].count
        
        //データベースへの新規書き込み
        firebaseService.addItemToCollection(title: newName, label: newLabel, index: newIndex){ error in
            if let error = error { return } else {
                //削除用関数を呼び出してデータベースから古いアイテムを削除
                self.firebaseService.deleteItemFromCollection(labelNum: oldLabel, items: [item]){error in
                    
                    if let error = error { return } else {
                        //削除したコレクションのインデックス番号振り直し
                        self.firebaseService.updateIndexesForCollection(labelNum: oldLabel){error in
                            if let error = error { return } else {
                                //コレクションをリロード
                                
                                self.fetchSelectedData(oldLabel)
                                self.fetchSelectedData(newLabel)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    ///タスク名をお気に入りリストへ保存するメソッド
    func addFavoriteList(){
        //すでに同名のタスクが存在する場合は何もしない
        if favoriteList.contains(newName){ return }
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
