//
//  DataModel.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/04.
//


import FirebaseFirestore
import SwiftUI
import Firebase



class ItemViewModel: ObservableObject {
    private let firebaseService = FirebaseDataService()
    
    ///ラベルごとに分類したリスト
    @Published  var label0Item = [ItemDataType]()
    @Published  var label1Item = [ItemDataType]()
    @Published  var label2Item = [ItemDataType]()
    
    @Published var favoriteList = [String]()
    
    @Published var selectedTab = 0
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    
    init() {
        //お気に入り登録されたタスクを取得
        self.favoriteList = defaults.object(forKey:favoriteListKey) as? [String] ?? [String]()
        //すべてのデータをフェッチ
        fetchAllData()
    }
}





extension ItemViewModel{
    
    ///すべてのデータをフェッチするメソッド
    private func fetchAllData() {
        firebaseService.fetchDataForCollection(0) { [weak self] items in
            self?.label0Item = items
        }
        firebaseService.fetchDataForCollection(1) { [weak self] items in
            self?.label1Item = items
        }
        firebaseService.fetchDataForCollection(2) { [weak self] items in
            self?.label2Item = items
        }
    }
    
    
    ///選択したデータをフェッチするメソッド
    private func fetchSelectedData(_ label:Int) {
        firebaseService.fetchDataForCollection(label) { [weak self] items in
            switch label{
            case 0:
                self?.label0Item = items
            case 1:
                self?.label1Item = items
            case 2:
                self?.label2Item = items
            default:
                return
            }
        }
    }
    
    
    ///アイテムをデータベースに新規追加するメソッド
    func addNewItem(title: String, label: Int) async{
        //追加するインデックス番号を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[label].count
        
        //データベースへの書き込み
        await firebaseService.addItemToCollection(title: title, label: label, index: newIndex)
        
        //追加したコレクションをリロード
        fetchSelectedData(label)
    }
    
    
    ///達成フラグを変更して保存する
    func toggleItemCheckStatus(item: ItemDataType){
        //Bool値を反転
        let newStatus = !item.checked
        //updateItemInCollectionメソッドを呼び出す
        firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: newStatus, newTitle: item.title)
        
        //コレクションをリロード
        self.fetchSelectedData(Int(item.label))
    }
    
    
    
    ///タイトルとラベル番号を変更して保存する
    func updateLabelOrTitle(item: ItemDataType, newTitle: String ,newLabel: Int) async{
        if item.label == newLabel{
            //ラベル番号が同じでタイトルのみが変更された時の処理
            await self.changeTitle(item: item, newTitle: newTitle)
        }else{
            //ラベル番号が変更された時の処理
            await self.changeLabel(item: item, newTitle: newTitle, newLabel: newLabel)
            return
        }
        
    }
    
    ///タイトルだけが変更された時の処理
    func changeTitle(item: ItemDataType, newTitle: String) async{
        //アイテムの修正用のメソッドを呼び出す
        firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: item.checked, newTitle: newTitle)
        //コレクションをリロード
        self.fetchSelectedData(Int(item.label))
    }
    
    
    ///ラベル番号が変更された時の処理
    func changeLabel(item: ItemDataType, newTitle: String ,newLabel: Int) async{
        
        //新規追加するためのインデックスを取得
        var allDataArray = [label0Item, label1Item, label2Item]
        let newIndex = allDataArray[newLabel].count
        
        //データベースへの新規書き込み
        await firebaseService.addItemToCollection(title: newTitle, label: newLabel, index: newIndex)
        
        //データベースから古いアイテムを削除
        deleteOneTask(item: item)
        
        //ラベル番号変更前の配列を取得
        let arrayBeforeChanging = allDataArray[Int(item.label)]
        
        //削除したコレクションのインデックス番号振り直し
        firebaseService.updateIndexesForCollection(labelNum: Int(item.label), dataArray: arrayBeforeChanging)
        
        self.fetchSelectedData(Int(item.label))
        self.fetchSelectedData(newLabel)
        return
    }
    
    
    
    ///index番号を振り直す
    func updateIndexesForCollection(labelNum: Int) {
        //配列を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let targetArray = allDataArray[labelNum]
        
        firebaseService.updateIndexesForCollection(labelNum: labelNum, dataArray: targetArray)
    }
    
    
    
    
    
    ///完了したタスクをまとめて削除
    func deleteCompletedTask(labelNum: Int) {
        //完了したタスクの配列を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let targetArray = allDataArray[labelNum]
        var completedArray = targetArray.filter { $0.checked == true }
        
        //削除用関数を呼び出す
        firebaseService.deleteItemFromCollection(labelNum: labelNum, items: completedArray)
        //インデックス番号の振り直し
        firebaseService.updateIndexesForCollection(labelNum: labelNum, dataArray: targetArray)
        //コレクションをリロード
        fetchSelectedData(labelNum)
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
        firebaseService.updateIndexesForCollection(labelNum: labelNumber, dataArray: targetArray)
        
        //コレクションをリロード
        fetchSelectedData(labelNumber)
        
    }
}



extension ItemViewModel{
    ///タスク名をお気に入りへ保存するメソッド
    func addFavoriteList(_ title: String){
        //すでに同名のタスクが存在する場合は何もしない
        if favoriteList.contains(title){
            return
        }
        
        //お気に入り配列に追加して更新
        objectWillChange.send()
        favoriteList.append(title)
        
        //ユーザーデフォルトに保存
        defaults.set(favoriteList, forKey: favoriteListKey)
    }
    
    ///タスク名をお気に入りから削除するメソッド
    func deleteFavoriteList(_ title: String){
        //itemName以外の名前のみを配列に格納
        let newArray = favoriteList.filter { $0 != title }
        objectWillChange.send()
        //お気に入り配列を更新
        favoriteList = newArray
        //ユーザーデフォルトに保存
        defaults.set(favoriteList, forKey: favoriteListKey)
    }
}
