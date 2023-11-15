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
    
    ///引数で渡されたラベルに応じたデータをフェッチするメソッド
    //非同期処理では、処理の結果がすぐには利用できないためコールバックパターンを使用する
    //コールバック関数を通じてitemsを返す
    func fetchDataForCollection(_ collectionName: String, completion: @escaping ([ItemDataType]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //ユーザーのIDを使用してコレクションにアクセス
        db.collection("users").document(uid).collection(collectionName).order(by: "index").addSnapshotListener { (snapshot, error) in
            var items = [ItemDataType]()
            
            if let error = error {
                //                    print("Error removing document: \(error)")
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
//            switch collectionName {
//            case "label0Item":
//                self.label0Item = tempArray
//            case "label1Item":
//                self.label1Item = tempArray
//            case "label2Item":
//                self.label2Item = tempArray
//            default:
//                break
//            }
            items = tempArray
            completion(items)
        }
    }
    
    // 他のFirebase関連メソッド（addItem, toggleCheck, etc.）もここに移動
}

