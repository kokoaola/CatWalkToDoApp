//
//  DataModel.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/04.
//




import Foundation
import FirebaseFirestore
import SwiftUI

class ItemViewModel: ObservableObject {
    @Published private(set) var itemList = [ItemDataType]()
    
    ///ラベルごとに分類したアイテム
    @Published var label0Item = [ItemDataType]()
    @Published var label1Item = [ItemDataType]()
    @Published var label2Item = [ItemDataType]()
    
    @Published var favoriteList = [String]()
    
    @Published var isBusy = false
    
    //    @Published var userSelectedLabel = 0
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    let db = Firestore.firestore()
    
    
    init(itemList: [ItemDataType] = [ItemDataType](), label0Item: [ItemDataType] = [ItemDataType](), label1Item: [ItemDataType] = [ItemDataType](), label2Item: [ItemDataType] = [ItemDataType](), favoriteList: [String] = [String](), isBusy: Bool = false) {
        self.itemList = itemList
        self.label0Item = label0Item
        self.label1Item = label1Item
        self.label2Item = label2Item
        self.favoriteList = favoriteList
        self.isBusy = isBusy
        
        fetchDataForCollection("label0Item")
        fetchDataForCollection("label1Item")
        fetchDataForCollection("label2Item")
    }
    
    
    func fetchData1() {
        db.collection("label0Item").order(by: "index").addSnapshotListener { (snapshot, error) in
            if let snap = snapshot {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let index = item.document.get("index") as! Int16
                        let checked = item.document.get("checked") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        
                        self.label0Item.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
        }
    }
    
    
    
    private func fetchDataForCollection(_ collectionName: String) {
        var tempArray = [ItemDataType]()
        db.collection(collectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
            // データが変更されるたびにこのブロックが実行される
            //           db.collection(collectionName).getDocuments { (snapshot, error) in
            // このブロックはデータを一度だけ取得するために実行される
            
            if let snap = snapshot {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let index = item.document.get("index") as! Int16
                        let checked = item.document.get("checked") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        
                        tempArray.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
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
        
        
        let collection: String
        var newIndex: Int
        switch label{
        case 0:
            newIndex = self.label0Item.count + 1
            collection = "label0Item"
        case 1:
            newIndex = self.label1Item.count + 1
            collection = "label1Item"
        case 2:
            newIndex = self.label2Item.count + 1
            collection = "label2Item"
        default:
            newIndex = self.label0Item.count + 1
            collection = "label0Item"
        }
        
        let data = [
            "title": title,
            "index": newIndex,
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        
        db.collection(collection).addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
        
        
    }
    
    
    ///達成フラグをtrueにして保存する
    func toggleCheck(item: ItemDataType, labelNum: Int){
        
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
        
        
        db.collection(collection).document(documentId).updateData([
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
        
        var collection: String = ""
        var array: [ItemDataType] = []
        
        switch labelNum{
        case 0:
            collection = "label0Item"
            array = label0Item
        case 1:
            collection = "label1Item"
            array = label1Item
        case 2:
            collection = "label2Item"
            array = label2Item
        default:
            break
        }
        
        let completeArray = array.filter { $0.checked == true }
        print(completeArray.count)
        
        
        for item in completeArray {
            self.db.collection(collection).document(item.id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
            
        }
        
        fetchDataForCollection(collection)
    }
    
    
    
    ///すべてのデータを再取得するメソッド
    func updateAllTasks(){
        
        //        let group = DispatchGroup() // DispatchGroupを作成
        //        group.enter() // タスクが始まったことを通知
        isBusy = true
        var tempArray = [ItemDataType]()
        var tempArray1 = [ItemDataType]()
        var tempArray2 = [ItemDataType]()
        
        
        db.collection("label0Item").order(by: "index").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snap = snap {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let index = item.document.get("index") as! Int16
                        let checked = item.document.get("checked") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        
                        self.label0Item.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label0Item = tempArray
        }
        
        
        db.collection("label1Item").order(by: "index").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snap = snap {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let index = item.document.get("index") as! Int16
                        let checked = item.document.get("checked") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        
                        tempArray1.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label1Item = tempArray1
        }
        
        
        
        
        db.collection("label2Item").order(by: "index").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snap = snap {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let index = item.document.get("index") as! Int16
                        let checked = item.document.get("checked") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        
                        tempArray2.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label2Item = tempArray2
        }
        
        //        group.leave() // タスクが終わったことを通知
        //
        //        // 全てのタスクが終わった後に呼ばれる
        //        group.notify(queue: .main) {
        //
        ////            DispatchQueue.main.async {
        //                self.label0Item = tempArray
        //                self.label1Item = tempArray1
        //                self.label2Item = tempArray2
        //                self.isBusy = false
        //
        print("VM label0Item", self.label0Item)
        print("VM label1Item", self.label1Item)
        print("VM label2Item", self.label2Item)
        ////            }
        //        }
        
        
    }
    
    
    ///タイトルを変更して保存する
    func changeTitle(item: ItemDataType, newTitle: String, oldLabel: Int ,newLabel: Int){
        print(item.title, item.checked)
        var collection: String
        
        switch oldLabel{
        case 0:
            collection = "label0Item"
        case 1:
            collection = "label1Item"
        case 2:
            collection = "label2Item"
        default:
            collection = "label0Item"
        }
        
        //ラベルが変更されたらアイテムを削除してから新規追加
        if oldLabel != newLabel{
            db.collection(collection).document(item.id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
            
            addItem(title: newTitle, label: newLabel)
            return
        }
        
        
        
        
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
        //            self.renumber(label: newLabel, newArray: newArray)
        self.updateAllTasks()
    }
    
    
    
    func deleteSelectedTask(item:ItemDataType){
        let completeArray = [item]
        
        let group = DispatchGroup() // DispatchGroupを作成
        group.enter() // タスクが始まったことを通知
        
        for item in completeArray {
            db.collection("items").document(item.id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                }
            }
        }
        group.leave() // タスクが終わったことを通知
        
        // 全てのタスクが終わった後に呼ばれる
        group.notify(queue: .main) {
            self.updateAllTasks()
        }
    }
    
    
    func renumber(label: Int, newArray: [ItemDataType]){
        
        for (index, item) in newArray.enumerated(){
            print(item.title)
            let documentId = item.id
            
            self.db.collection("items").document(documentId).updateData([
                "indexedLabel": ["label": label, "index": index],
            ])
            
        }
        updateAllTasks()
    }
    
    
}

