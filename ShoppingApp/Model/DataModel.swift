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


struct itemDataType: Identifiable {
    public var id = UUID()
    public var title: String
    public var label: Int16
    public var favorite: Bool
    public var checked: Bool
    public var finished: Bool
    public var timestamp: Date
}

class ItemViewModel: ObservableObject {
    @Published var items = [itemDataType]()

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
                        let title = item.document.get("title") as! String
                        let label = item.document.get("label") as! Int16
                        let favorite = item.document.get("favorite") as! Bool
                        let checked = item.document.get("checked") as! Bool
                        let finished = item.document.get("finished") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
//                        let id = item.document.documentID

                        self.items.append(itemDataType(title: title, label: label, favorite: favorite, checked: checked, finished: finished, timestamp: timestamp))
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
        var data = [
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
}

