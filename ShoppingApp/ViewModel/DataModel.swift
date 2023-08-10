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
        
//        renumberW()
    }
    
    
//    func fetchData1() {
//        db.collection("label0Item").order(by: "index").addSnapshotListener { (snapshot, error) in
//            if let snap = snapshot {
//                for item in snap.documentChanges {
//                    if item.type == .added {
//                        let id = item.document.documentID
//                        let title = item.document.get("title") as! String
//                        let index = item.document.get("index") as! Int16
//                        let checked = item.document.get("checked") as! Bool
//                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
//                        let timestamp = timeData.dateValue()
//
//                        self.label0Item.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
//                    }
//                }
//
//
//            }
//        }
//    }
    
    
    
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

