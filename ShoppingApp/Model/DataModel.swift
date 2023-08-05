//
//  DataModel.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/04.
//


/*
Firebaseデータベースアクセス部分を作成
FirebaseのCloud Firestoreの読み書きするコードを記載します。
@Publishedで新しいメッセージが追加されたときに自動でデータ更新が通知されるようになります。
*/


import Foundation
import FirebaseFirestore


struct ItemDataType: Identifiable {
    public var id: String
    public var title: String
    public var label: Int16
    public var favorite: Bool
    public var checked: Bool
    public var finished: Bool
    public var timestamp: Date
}

class ItemViewModel: ObservableObject {
    @Published var itemList = [ItemDataType]()

    init() {
        let db = Firestore.firestore()

        db.collection("items").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snap = snap {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let label = item.document.get("label") as! Int16
                        let favorite = item.document.get("favorite") as! Bool
                        let checked = item.document.get("checked") as! Bool
                        let finished = item.document.get("finished") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
//                        let id = item.document.documentID

                        self.itemList.append(ItemDataType(id: id,title: title, label: label, favorite: favorite, checked: checked, finished: finished, timestamp: timestamp))
                    }
                }
                // 日付順に並べ替えする
//                self.items.sort { before, after in
//                    return before.createAt < after.createAt ? true : false
//                }
            
            }
        }
    }

    func addItem(title: String, label: Int16){
        let data = [
            "label": label,
            "title": title,
            "favorite": false,
            "checked": false,
            "finished": false,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]

        let db = Firestore.firestore()

        db.collection("items").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            print("success")
        }
    }
    
    func toggleCheck(item:ItemDataType){
        let documentId = item.id
        objectWillChange.send()
        let newCheckedStatus = !item.checked
        print("item.checked", item.checked)
        print("newCheckedStatus", newCheckedStatus)
        let db = Firestore.firestore()
        

        db.collection("items").document(documentId).updateData([
            "checked": newCheckedStatus
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success")
                print("item.checked", item.checked)
            }
            
            DispatchQueue.main.async {
                self.updateAllTasks()
            }
        }
    }
    
    
    ///すべてのデータを再取得するメソッド
    func updateAllTasks(){
        var tempItemList = [ItemDataType]()
        
        let db = Firestore.firestore()
        
        db.collection("items").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snap = snap {
                for item in snap.documentChanges {
                    if item.type == .added {
                        let id = item.document.documentID
                        let title = item.document.get("title") as! String
                        let label = item.document.get("label") as! Int16
                        let favorite = item.document.get("favorite") as! Bool
                        let checked = item.document.get("checked") as! Bool
                        let finished = item.document.get("finished") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        //                        let id = item.document.documentID
                        
                        tempItemList.append(ItemDataType(id: id,title: title, label: label, favorite: favorite, checked: checked, finished: finished, timestamp: timestamp))
                    }
                }
                // 日付順に並べ替えする
                //                self.items.sort { before, after in
                //                    return before.createAt < after.createAt ? true : false
                //                }
                
            }
            
            self.itemList = tempItemList
        }
    }
}

