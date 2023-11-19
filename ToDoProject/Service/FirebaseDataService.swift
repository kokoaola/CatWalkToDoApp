//
//  FirebaseDataService.swift
//  ToDoProject
//
//  Created by koala panda on 2023/11/15.
//

import FirebaseFirestore
import SwiftUI
import Firebase


class FirebaseDataService {
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid
    private let subCollectionNames = ["label0Item", "label1Item", "label2Item"]
    private let collectionName = "users"
}


extension FirebaseDataService{
    ///引数で渡されたラベルに応じたデータを取得するメソッド
    //非同期処理では、処理の結果がすぐには利用できないためコールバックパターンを使用し、コールバック関数を通じてitemsを返す
    func fetchDataForCollection(_ label: Int, completion: @escaping ([ItemDataType]) -> Void) {
        let subCollectionName = subCollectionNames[label]
        
        //ユーザーのIDを使用してコレクションにアクセス
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
            var items = [ItemDataType]()
            
            if error != nil {
            }
            
            var tempArray = [ItemDataType]()
            
            //１つのタスクを取得
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
            items = tempArray
            completion(items)
        }
    }
    
    
    ///アイテムをデータベースに追加する
    func addItemToCollection(title: String, label: Int, index: Int) async{
        //コレクション名を取得
        let subCollectionName = subCollectionNames[label]
        
        let data = [
            "title": title,
            "index": index + 1,
            "label": label,
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        
        // 新しいアイテムを追加
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).addDocument(data: data){ (error) in
            if let err = error {
            }
        }
    }
    
    
    
    ///データベース内のアイテムを更新する
    func updateItemInCollection(oldItem: ItemDataType, newCheckedStatus:Bool, newTitle: String){
        
        //コレクション名を取得
        let subCollectionName = subCollectionNames[Int(oldItem.label)]
        
        
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(oldItem.id).updateData([
            "checked": newCheckedStatus,
            "title": newTitle
        ]){ error in
            if let error = error {
                print("Error updating document: \(error)")
                // エラー処理をここで行う
            } else {
                // 成功時の処理をここで行う
            }
        }
    }
    
    
    
    ///index番号を振り直す
    func updateIndexesForCollection(labelNum: Int, dataArray:[ItemDataType]) {
        
        //コレクション名を取得
        let subCollectionName = subCollectionNames[labelNum]
        
        //順番にIndexを振り直して保存する
        DispatchQueue.main.async {
            for (index, item) in dataArray.enumerated() {
                self.db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(item.id).updateData([
                    "index": index
                ])
            }
        }
    }
    
    
    
    
    //データベースからアイテムを削除する
    func deleteItemFromCollection(labelNum: Int, items:[ItemDataType]){
        
        //操作したいコレクション名を取得
        let subCollectionName = subCollectionNames[labelNum]
        
        let group = DispatchGroup()
        //優先する処理
        for item in items {
            // グループにエンター
            group.enter()
            //該当するidのアイテムを削除
            self.db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(item.id).delete() { error in
                if let error = error {
                    //                    print("Error removing document: \(error)")
                }
                group.leave()  // グループからリーブ
            }
        }
    }
    
    //データベースからアイテムを削除する
//    func deleteAllItemFromCollection(){
//
//    }
    
}

