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
                print("snap",snap.count)
                for document in snap.documents {
                    let id = document.documentID
                    let title = document.get("title") as! String
                    let index = document.get("index") as! Int16
                    let checked = document.get("checked") as! Bool
                    let timeData = document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                    let timestamp = timeData.dateValue()
                    print(title)
                    
                    tempArray.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    print("1tempArray", tempArray.count)
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
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        
        // 新しいアイテムを追加
        db.collection("users").document(uid).collection(collectionName).addDocument(data: data) { (error) in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added!")
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
    
    
    
    ///完了したタスクの削除
    func completeTask(labelNum: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var collection: String = ""
        var completedArray: [ItemDataType] = []
        
        switch labelNum{
        case 0:
            collection = "label0Item"
            completedArray = label0Item.filter { $0.checked == true }
        case 1:
            collection = "label1Item"
            completedArray = label1Item.filter { $0.checked == true }
        case 2:
            collection = "label2Item"
            completedArray = label2Item.filter { $0.checked == true }
        default:
            break
        }
        
        for item in completedArray {
            let documentId = item.id
            
            db.collection("users").document(uid).collection(collection).document(documentId).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
        fetchDataForCollection(collection)
        
        //MARK: -
        //        renumber()
    }
    
    
    
    ///タイトルを変更して保存する
    func changeTitle(item: ItemDataType, newTitle: String ,newLabel: Int){
        
        //ラベル番号が変更されたらアイテムを削除してから新規追加
        if true{
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
        
        //アイテムのタイトル書き換え
        db.collection(collection).document(item.id).updateData([
            "title": newTitle
        ])
    }
    
    
    ///選んだタスクを削除する
    func deleteSelectedTask(item:ItemDataType){
        
        let collectionArray = ["label0Item","label1Item","label2Item"]
        
        for collection in collectionArray{
            self.db.collection(collection).document(item.id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
            fetchDataForCollection(collection)
        }
        //        renumber()
    }
    
    
    ///index番号を振り直す
    func updateIndexesForCollection(_ collectionName: String, items: [ItemDataType]) {
        for (index, item) in items.enumerated() {
            let documentId = item.id
            self.db.collection(collectionName).document(documentId).updateData([
                "index": index
            ])
        }
        fetchDataForCollection(collectionName)
    }
}

