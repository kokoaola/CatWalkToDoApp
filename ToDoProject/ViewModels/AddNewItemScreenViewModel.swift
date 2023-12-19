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
    func addNewItem(label: Int) async{
        
        //追加するインデックス番号を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[label].count
        
        //データベースへの書き込み
        await firebaseService.addItemToCollection(title: newName, label: label, index: newIndex)
        
        //追加したコレクションをリロード
        fetchSelectedData(label)
    }
    
    
    ///タイトルとラベル番号を変更して保存する
    func updateLabelAndTitle(item: ItemDataType,newLabel: Int) async{
        if item.label == newLabel{
            //ラベル番号が同じでタイトルのみが変更された時の処理
            //アイテムの修正用のメソッドを呼び出す
            firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: item.checked, newTitle: newName)
            //コレクションをリロード
            self.fetchSelectedData(Int(item.label))
        }else{
            //ラベル番号も含めて変更された時の処理
            await self.changeLabelNumber(item: item, newLabel: newLabel)
        }
        
    }
    
    
    ///ラベル番号が変更された時の処理
    func changeLabelNumber(item: ItemDataType,newLabel: Int) async{
        
        let oldLabel = Int(item.label)
        
        //新規追加するためのインデックスを取得
        var allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[newLabel].count
        
        //データベースへの新規書き込み
        await firebaseService.addItemToCollection(title: newName, label: newLabel, index: newIndex)
        
        //削除用関数を呼び出してデータベースから古いアイテムを削除
        firebaseService.deleteItemFromCollection(labelNum: oldLabel, items: [item])
        
        self.fetchSelectedData(oldLabel)
        
        //新規追加するためのインデックスを取得
        var newDataArray = [label0Item, label1Item, label2Item]
        
        //ラベル番号変更前の配列を取得
        let newArray = newDataArray[oldLabel]
        
        //削除したコレクションのインデックス番号振り直し
        firebaseService.NEWupdateIndexesForCollection(labelNum: Int(item.label))
        
        self.fetchSelectedData(oldLabel)
        self.fetchSelectedData(newLabel)
        return
    }
    
    
    ///選んだタスクを１つ削除する
    func deleteOneTask(item:ItemDataType){
        //操作するラベルの番号を取得
        let labelNumber = Int(item.label)
        
        //削除用関数を呼び出して削除を実行
        firebaseService.deleteItemFromCollection(labelNum: labelNumber, items: [item])
        
        //インデックス番号の振り直し
        let allDataArray = [label0Item, label1Item, label2Item]
        let targetArray = allDataArray[labelNumber]
//        firebaseService.updateIndexesForCollection(labelNum: labelNumber, dataArray: targetArray)
        
        //コレクションをリロード
        fetchSelectedData(labelNumber)
    }
    
    
//    ///タイトルとラベル番号を変更して保存する
//    func updateLabelAndTitle(item: ItemDataType,newLabel: Int) async{
//        if item.label == newLabel{
//            //ラベル番号が同じでタイトルのみが変更された時の処理
//            //アイテムの修正用のメソッドを呼び出す
//            firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: item.checked, newTitle: self.newName)
//        }else{
//            //ラベル番号が変更された時の処理
//            await self.changeLabel(item: item, newTitle: self.newName, newLabel: newLabel)
//            return
//        }
//        //コレクションをリロード
//        self.fetchSelectedData(newLabel)
//    }
//
//
//    ///ラベル番号が変更された時の処理
//    func changeLabel(item: ItemDataType, newTitle: String ,newLabel: Int) async{
//
//        //新規追加する順番を設定するためのインデックスを取得
//        var allDataArray = [label0Item, label1Item, label2Item]
//        let newIndex = allDataArray[newLabel].count
//
//        let oldLabelNum = Int(item.label)
//
//        //データベースへの新規書き込み
//        await firebaseService.addItemToCollection(title: self.newName, label: newLabel, index: newIndex)
//
//        //データベースから古いアイテムを削除
//        //削除用関数を呼び出して削除を実行
//        firebaseService.deleteItemFromCollection(labelNum: oldLabelNum, items: [item])
//
//        //コレクションをリロード
//        self.fetchSelectedData(oldLabelNum)
//
//
//        //新規追加する順番を設定するためのインデックスを取得
//        var newAllDataArray = [label0Item, label1Item, label2Item]
//
//        //ラベル番号変更前の配列を取得
//        let arrayBeforeChanging = newAllDataArray[oldLabelNum]
//
//        //削除したコレクションのインデックス番号振り直し
//        firebaseService.updateIndexesForCollection(labelNum: oldLabelNum, dataArray: arrayBeforeChanging)
//
//        fetchAllData()
//    }
//
//
//    ///選んだタスクを１つ削除する
//    func deleteOneTask(item:ItemDataType){
//        //操作するラベルの番号を取得
//        let labelNumber = Int(item.label)
//
//        //削除用関数を呼び出して削除を実行
//        firebaseService.deleteItemFromCollection(labelNum: labelNumber, items: [item])
//
//        //インデックス番号の振り直し
//        let allDataArray = [label0Item, label1Item, label2Item]
//        let targetArray = allDataArray[labelNumber]
//        firebaseService.updateIndexesForCollection(labelNum: labelNumber, dataArray: targetArray)
//
//        //コレクションをリロード
//        fetchSelectedData(labelNumber)
//    }
    
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
