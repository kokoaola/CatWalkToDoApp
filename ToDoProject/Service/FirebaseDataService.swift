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
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    private let collectionNames = ["label0Item", "label1Item", "label2Item"]
}


extension FirebaseDataService{
    ///引数で渡されたラベルに応じたデータをフェッチするメソッド
    //非同期処理では、処理の結果がすぐには利用できないためコールバックパターンを使用し、コールバック関数を通じてitemsを返す
    func fetchDataForCollection(_ label: Int, completion: @escaping ([ItemDataType]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let collectionName = collectionNames[label]
        
        //ユーザーのIDを使用してコレクションにアクセス
        db.collection("users").document(uid).collection(collectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //コレクション名を取得
        let collectionName = collectionNames[label]
        
        let data = [
            "title": title,
            "index": index + 1,
            "label": label,
            "checked": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        
        // 新しいアイテムを追加
        db.collection("users").document(uid).collection(collectionName).addDocument(data: data){ (error) in
            if let err = error {
            }
        }
    }
    
    
    
    ///データベース内のアイテムを更新する
    func updateItemInCollection(oldItem: ItemDataType, newCheckedStatus:Bool, newTitle: String){
        
        //コレクション名を取得
        let collectionName = collectionNames[Int(oldItem.label)]
        
        
        db.collection("users").document(uid!).collection(collectionName).document(oldItem.id).updateData([
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
    
    
    
    
    //データベースからアイテムを削除する
    func deleteOneItemFromCollection(item:ItemDataType){
        
    }
    
    //データベースからアイテムを削除する
    func deleteAllItemFromCollection(){
        
    }
    
}

