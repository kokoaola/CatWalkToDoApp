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

class ItemViewModel: ObservableObject {
    @Published var itemList = [ItemDataType]()
    @Published var filterdList0 = [ItemDataType]()
    @Published var filterdList1 = [ItemDataType]()
    @Published var filterdList2 = [ItemDataType]()
    
    @Published var favoriteList:[String]
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    init() {
        self.favoriteList = defaults.stringArray(forKey:favoriteListKey) ?? ["test"]
        
        
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
//                        let favorite = item.document.get("favorite") as! Bool
                        let checked = item.document.get("checked") as! Bool
                        let finished = item.document.get("finished") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
//                        let id = item.document.documentID

                        self.itemList.append(ItemDataType(id: id,title: title, label: label, checked: checked, finished: finished, timestamp: timestamp))
                    }
                }
                // 日付順に並べ替えする
//                self.items.sort { before, after in
//                    return before.createAt < after.createAt ? true : false
//                }
                
                self.filterdList0 = self.itemList.filter { $0.label == 0 }
                self.filterdList1 = self.itemList.filter { $0.label == 1 }
                self.filterdList2 = self.itemList.filter { $0.label == 2 }
            
            }
        }
    }

    
    ///アイテムをデータベースに追加する
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


    ///達成フラグをtrueにして保存する
    func toggleCheck(item: ItemDataType){
        let documentId = item.id
        let newCheckedStatus = !item.checked
        let db = Firestore.firestore()
        
        var updatedItem = item
        updatedItem.checked = newCheckedStatus
        
        if let index = itemList.firstIndex(where: { $0.id == documentId }) {
            DispatchQueue.main.async {
                // 4. Update the UI by assigning the updated item to the appropriate index in the `itemList` array.
                self.itemList[index] = updatedItem
            }
        }
        
        db.collection("items").document(documentId).updateData([
            "checked": newCheckedStatus
        ]) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                
//                // 3. Fetch the updated data from Firestore and update the `itemList` array.
//                db.collection("items").document(documentId).getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//
//                        guard let docData = document.data() else {
//                            print("Document data was empty.")
//                            return
//                        }
//
////                        self?.updateAllTasks()
//
//                    } else {
//                        print("Document does not exist.")
//                    }
//                }
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
//                        let favorite = item.document.get("favorite") as! Bool
                        let checked = item.document.get("checked") as! Bool
                        let finished = item.document.get("finished") as! Bool
                        let timeData = item.document.get("timestamp", serverTimestampBehavior: .estimate) as! Timestamp
                        let timestamp = timeData.dateValue()
                        //                        let id = item.document.documentID
                        
                        tempItemList.append(ItemDataType(id: id,title: title, label: label, checked: checked, finished: finished, timestamp: timestamp))
                    }
                }
                
            }
            
            self.itemList = tempItemList
        }
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
        print(favoriteList)
    }
}

