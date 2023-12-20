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
    //データベース操作用のプロパティ
    private let db = Firestore.firestore()
    private let collectionName = "users"
    private let uid = Auth.auth().currentUser?.uid
    private let subCollectionNames = ["label0Item", "label1Item", "label2Item"]
}


extension FirebaseDataService{
    ///引数で渡されたラベルに応じたデータを取得するメソッド
    //非同期処理では、処理の結果がすぐには利用できないためコールバックパターンを使用し、コールバック関数を通じてitemsを返す
    func fetchDataForCollection(_ label: Int, completion: @escaping ([ItemDataType]) -> Void) {
        let subCollectionName = subCollectionNames[label]
        
        //ユーザーのIDを使用してコレクションにアクセス
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
            var items = [ItemDataType]()
            if error != nil { return }
            
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
    func addItemToCollection(title: String, label: Int, index: Int, completion: @escaping (Error?) -> Void) {
        let subCollectionName = subCollectionNames[label]
        
        let data = [
            "title": title,
            "index": index + 1,
            "label": label,
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        // 新しいアイテムを追加
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).addDocument(data: data) { error in
            // コンプリーションハンドラを通じて、呼び出し元にエラー情報を返す
            completion(error)
        }
    }
    
    
    
    ///データベース内のアイテムのタイトル、達成フラグを更新する
    func updateItemInCollection(oldItem: ItemDataType, newCheckedStatus:Bool, newTitle: String, completion: @escaping (Error?) -> Void) {
        
        //コレクション名を取得
        let subCollectionName = subCollectionNames[Int(oldItem.label)]
        
        
        db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(oldItem.id).updateData([
            "checked": newCheckedStatus,
            "title": newTitle
        ]){ error in
            if let error = error {
                print("Error updating document: \(error)")
                // エラー処理
                completion(error)
            } 
        }
    }
    
    
    
    ///index番号を振り直す
    func updateIndexesForCollection(labelNum: Int, completion: @escaping (Error?) -> Void) {
        let subCollectionName = self.subCollectionNames[labelNum]
        
        fetchDataForCollection(labelNum) { itemArray in
            //順番にIndexを振り直して保存する
            DispatchQueue.main.async {
                for (index, item) in itemArray.enumerated() {
                    self.db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(item.id).updateData([
                        "index": index
                    ]){ error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            // エラー処理
                            completion(error)
                        }
                    }
                }
            }
        }
    }

    
    
    
    ///データベースからアイテムを削除する
    func deleteItemFromCollection(labelNum: Int, items:[ItemDataType], completion: @escaping (Error?) -> Void) {
        
        //操作したいコレクション名を取得
        let subCollectionName = subCollectionNames[labelNum]
        
        let group = DispatchGroup()
        //優先する処理
        for item in items {
            // グループにエンター
            group.enter()
            //該当するidのアイテムを削除
            self.db.collection(self.collectionName).document(self.uid!).collection(subCollectionName).document(item.id).delete() { error in
                if error != nil {
                    // エラー処理
                    completion(error)
                }
                // グループからリーブ
                group.leave()
            }
        }
    }
}

