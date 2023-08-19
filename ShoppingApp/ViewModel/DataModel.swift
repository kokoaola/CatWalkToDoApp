//
//  DataModel.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/04.
//




import Foundation
import FirebaseFirestore
import SwiftUI
import Firebase

class ItemViewModel: ObservableObject {
    
    ///ラベルごとに分類したアイテム
    @Published  var label0Item = [ItemDataType]()
    @Published  var label1Item = [ItemDataType]()
    @Published  var label2Item = [ItemDataType]()
    
    @Published var favoriteList = [String]()
    
    @Published var isBusy = false
    
    @Published var selectedTab = 0
    
    //    @Published var userSelectedLabel = 0
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    let db = Firestore.firestore()
    
    
    init(label0Item: [ItemDataType] = [ItemDataType](), label1Item: [ItemDataType] = [ItemDataType](), label2Item: [ItemDataType] = [ItemDataType](), favoriteList: [String] = [String](), isBusy: Bool = false) {
        self.label0Item = label0Item
        self.label1Item = label1Item
        self.label2Item = label2Item
        self.favoriteList = defaults.object(forKey:favoriteListKey) as? [String] ?? [String]()
        self.isBusy = isBusy
        
        fetchDataForCollection("label0Item")
        fetchDataForCollection("label1Item")
        fetchDataForCollection("label2Item")
        
    }
    
    
    ///引数で渡されたラベルに応じたデータをフェッチするメソッド
    private func fetchDataForCollection(_ collectionName: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).collection(collectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
            var tempArray = [ItemDataType]()
            if let snap = snapshot {
                for document in snap.documents {
                    let id = document.documentID
                    let title = document.get("title") as! String
                    let index = document.get("index") as! Int16
                    let label = document.get("label") as! Int16
                    let checked = document.get("checked") as! Bool
                    let timeData = document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                    let timestamp = timeData.dateValue()
                    
                    tempArray.append(ItemDataType(id: id, title: title, index: index,label: label, checked: checked, timestamp: timestamp))
                }
            }
            switch collectionName {
            case "label0Item":
                self.label0Item = tempArray
            case "label1Item":
                self.label1Item = tempArray
            case "label2Item":
                self.label2Item = tempArray
            default:
                break
            }
        }
    }
    
    
    
    
    ///アイテムをデータベースに追加する
    func addItem(title: String, label: Int){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let collectionName: String
        var newIndex: Int
        switch label{
        case 0:
            newIndex = self.label0Item.count
            collectionName = "label0Item"
        case 1:
            newIndex = self.label1Item.count
            collectionName = "label1Item"
        case 2:
            newIndex = self.label2Item.count
            collectionName = "label2Item"
        default:
            newIndex = self.label0Item.count
            collectionName = "label0Item"
        }
        
        let data = [
            "title": title,
            "index": newIndex,
            "label": label,
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        
        // 新しいアイテムを追加
        db.collection("users").document(uid).collection(collectionName).addDocument(data: data) { (error) in
            if let err = error {
//                print("Error adding document: \(err)")
            } else {
//                print("Document successfully added!")
            }
        }
    }
    
    
    
    ///達成フラグをtrueにして保存する
    func toggleCheck(item: ItemDataType, labelNum: Int){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentId = item.id
        let newCheckedStatus = !item.checked
        
        var updatedItem = item
        updatedItem.checked = newCheckedStatus
        
        
        let collection: String
        
        switch labelNum{
        case 0:
            collection = "label0Item"
        case 1:
            collection = "label1Item"
        case 2:
            collection = "label2Item"
        default:
            collection = "label0Item"
        }
        
        db.collection("users").document(uid).collection(collection).document(documentId).updateData([
            "checked": newCheckedStatus
        ])
        fetchDataForCollection(collection)
    }
    
    
    
    ///お気に入りアイテムへ保存する
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
    
    
    
    ///タイトルを変更して保存する
    func changeTitle(item: ItemDataType, newTitle: String ,newLabel: Int){
        
        //ラベル番号が変更されたらアイテムを削除してから新規追加
        if item.label != newLabel{
            deleteSelectedTask(item: item)
            addItem(title: newTitle, label: newLabel)
            
            return
        }
        
        var collection: String
        switch newLabel{
        case 0:
            collection = "label0Item"
        case 1:
            collection = "label1Item"
        case 2:
            collection = "label2Item"
        default:
            collection = "label0Item"
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //アイテムのタイトル書き換え
        db.collection("users").document(uid).collection(collection).document(item.id).updateData([
            "title": newTitle
        ]){ error in
            if let error = error {
                self.deleteSelectedTask(item: item)
                self.addItem(title: newTitle, label: newLabel)
//                print("Error removing document: \(error)")
            }
        }
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

