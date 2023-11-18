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
    
    ///ラベルごとに分類したアイテム
    @Published  var label0Item = [ItemDataType]()
    @Published  var label1Item = [ItemDataType]()
    @Published  var label2Item = [ItemDataType]()
    
    @Published var favoriteList = [String]()
    
    @Published var isBusy = false
    
    @Published var selectedTab = 0
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    let db = Firestore.firestore()
    
    
    init() {
        self.favoriteList = defaults.object(forKey:favoriteListKey) as? [String] ?? [String]()
        self.isBusy = isBusy
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
            self?.label0Item = items
        }
    }
    
    
    ///アイテムをデータベースに新規追加するメソッド
    func addNewItem(title: String, label: Int) async{
        //アイテム総数を取得
        let itemCounts = [self.label0Item.count, self.label1Item.count, self.label2Item.count]
        //データベースへの書き込み
        await firebaseService.addItemToCollection(title: title, label: label, index: itemCounts[label])
        //追加したコレクションをリロード
        fetchSelectedData(label)
    }
    
    
    ///達成フラグを変更して保存する
    func toggleItemCheckStatus(item: ItemDataType, labelNum: Int){
        //達成フラグを反転
        var newItem = item
        newItem.checked = !item.checked
        
        //updateItemInCollectionメソッドを呼び出す
        firebaseService.updateItemInCollection2(oldItem: item, newItem: newItem)
        
        //コレクションをリロード
        self.fetchAllData()
    }
    
    
    
    ///タイトルを変更して保存する
    func changeTitle(item: ItemDataType, newTitle: String ,newLabel: Int) async{
        //ラベル番号が変更されたらアイテムを削除してから新規追加
        if item.label != newLabel{
            //アイテムを削除
            deleteSelectedTask(item: item)
            //データベースへの書き込み
            await firebaseService.addItemToCollection(title: newTitle, label: newLabel, index: Int(item.index))
            return
        }
        
        var newItem = item
        newItem.title = newTitle
        
        //updateItemInCollectionメソッドを呼び出す
        firebaseService.updateItemInCollection2(oldItem: item, newItem: newItem)
        //コレクションをリロード
        self.fetchAllData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    ///完了したタスクをまとめて削除
    func completeTask(labelNum: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var collection: String = ""
        var completedArray: [ItemDataType] = []
        var notCompletedArray: [ItemDataType] = []
        
        switch labelNum{
        case 0:
            collection = "label0Item"
            completedArray = label0Item.filter { $0.checked == true }
            notCompletedArray = label0Item.filter { $0.checked == false }
        case 1:
            collection = "label1Item"
            completedArray = label1Item.filter { $0.checked == true }
            notCompletedArray = label1Item.filter { $0.checked == false }
        case 2:
            collection = "label2Item"
            completedArray = label2Item.filter { $0.checked == true }
            notCompletedArray = label2Item.filter { $0.checked == false }
        default:
            break
        }
        
        
        let group = DispatchGroup()
        //優先する処理
        for item in completedArray {
            let documentId = item.id
            
            group.enter()  // グループにエンター
            self.db.collection("users").document(uid).collection(collection).document(documentId).delete() { error in
                if let error = error {
//                    print("Error removing document: \(error)")
                }
                group.leave()  // グループからリーブ
            }
        }
        
        // すべての非同期処理が完了した後に実行
        group.notify(queue: .main) {
            //2の処理
            self.updateIndexesForCollection(labelNum: labelNum)
        }
    }
    
    ///選んだタスクを１つ削除する
    func deleteSelectedTask(item:ItemDataType){
        let labelNum = item.label
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var collectionName: String
        switch labelNum{
        case 0:
            collectionName = "label0Item"
        case 1:
            collectionName = "label1Item"
        case 2:
            collectionName = "label2Item"
        default:
            collectionName = "label0Item"
        }
        
        let group = DispatchGroup()
        group.enter()  // グループにエンター
        //優先する処理
        db.collection("users").document(uid).collection(collectionName).document(item.id).delete() { error in
            if let error = error {
//                print("Error removing document: \(error)")
            }
            group.leave()  // グループからリーブ
        }
        
        // すべての非同期処理が完了した後に実行
        group.notify(queue: .main) {
            //2の処理
            self.updateIndexesForCollection(labelNum: Int(labelNum))
        }
    }
    
    
    
    
    ///index番号を振り直す
    func updateIndexesForCollection(labelNum: Int) {
        
        var collectionName: String
        var array: [ItemDataType]
        switch labelNum{
        case 0:
            collectionName = "label0Item"
            array = label0Item
        case 1:
            collectionName = "label1Item"
            array = label1Item
        case 2:
            collectionName = "label2Item"
            array = label2Item
        default:
            collectionName = "label0Item"
            array = label0Item
        }
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        DispatchQueue.main.async {
            for (index, item) in array.enumerated() {
                self.db.collection("users").document(uid).collection(collectionName).document(item.id).updateData([
                    "index": index
                ])
            }
        }
    }
}



extension ItemViewModel{
    ///タスク名をお気に入りへ保存するメソッド
    func changeFavoriteList(itemName: String, delete: Bool){
        
        if delete{
            let newArray = favoriteList.filter { $0 != itemName }
            objectWillChange.send()
            favoriteList = newArray
        }else{
            if favoriteList.contains(itemName){
                return
            }
            
            objectWillChange.send()
            favoriteList.append(itemName)
        }
        
        defaults.set(favoriteList, forKey: favoriteListKey)
    }
}
