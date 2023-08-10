//
//  DataModel.swift
//  ShoppingApp
//
//  Created by koala panda on 2023/08/04.
//




import Foundation
import FirebaseFirestore

class ItemViewModel: ObservableObject {
    @Published private(set) var itemList = [ItemDataType]()
    
    ///ラベルごとに分類したアイテム
    @Published var filterdList0 = [ItemDataType]()
    @Published var filterdList1 = [ItemDataType]()
    @Published var filterdList2 = [ItemDataType]()
    
    @Published var label0Item = [ItemDataType]()
    @Published var label1Item = [ItemDataType]()
    @Published var label2Item = [ItemDataType]()
    
    @Published var favoriteList:[String]
    
    @Published var isBusy = false
    
    ///ユーザーデフォルト用の変数
    private let defaults = UserDefaults.standard
    ///ユーザーデフォルト用キー：目標用
    private let favoriteListKey = "favoriteList"
    
    let db = Firestore.firestore()
    
    
    
    
    init() {
        self.favoriteList = defaults.stringArray(forKey:favoriteListKey) ?? ["test"]
        
        isBusy = true
        
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
                        
                        self.label1Item.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
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
                        
                        self.label2Item.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
        }
        
        isBusy = false
        
    }
    
    
    ///アイテムをデータベースに追加する
    func addItem(title: String, label: Int16){
        
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
    func toggleCheck(item: ItemDataType){
        print(item.title, item.checked)
        let documentId = item.id
        let newCheckedStatus = !item.checked
        
        var updatedItem = item
        updatedItem.checked = newCheckedStatus
        
        
        let group = DispatchGroup() // DispatchGroupを作成
        
        group.enter() // タスクが始まったことを通知
        db.collection("items").document(documentId).updateData([
            "checked": newCheckedStatus
        ]) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }else{
                print(item.title, item.checked)
            }
        }
        group.leave()
        
        // 全てのタスクが終わった後に呼ばれる
        group.notify(queue: .main) {
            //            self.updateAllTasks()
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
    }
    
    
    
    ///完了したタスクの削除
    func completeTask() {
        let completeArray = itemList.filter { $0.checked == true }
        
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
            //            self.updateAllTasks()
        }
    }
    
    
    
    ///すべてのデータを再取得するメソッド
    func updateAllTasks(){
        isBusy = true
        var tempArray = [ItemDataType]()
        
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
                        
                        tempArray.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label0Item = tempArray
            tempArray = []
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
                        
                        tempArray.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label1Item = tempArray
            tempArray = []
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
                        
                        tempArray.append(ItemDataType(id: id, title: title, index: index, checked: checked, timestamp: timestamp))
                    }
                }
            }
            self.objectWillChange.send()
            self.label2Item = tempArray
            tempArray = []
        }
        
        isBusy = false
            
            
//            group.notify(queue: .main) {
//                DispatchQueue.main.async {
//                    self.objectWillChange.send()
//                    self.itemList = tempItemList
//
//                    self.objectWillChange.send()
//                    self.filterdList0 = self.itemList.filter { $0.indexedLabel["label"] == 0 }
//                    self.filterdList0.sort {
//                        $0.indexedLabel["index"] ?? 0 < $1.indexedLabel["index"] ?? 0 //比較の条件式
//                    }
//                    self.objectWillChange.send()
//                    self.filterdList1 = self.itemList.filter { $0.indexedLabel["label"] == 1 }
//                    self.filterdList1.sort {
//                        $0.indexedLabel["index"] ?? 0 < $1.indexedLabel["index"] ?? 0 //比較の条件式
//                    }
//                    self.objectWillChange.send()
//                    self.filterdList2 = self.itemList.filter { $0.indexedLabel["label"] == 2 }
//                    self.filterdList2.sort {
//                        $0.indexedLabel["index"] ?? 0 < $1.indexedLabel["index"] ?? 0 //比較の条件式
//                    }
//
//                    self.isBusy = false
//
//                }
//            }
            
        
    }
    
    
    ///タイトルを変更して保存する
    func changeTitle(item: ItemDataType, newTitle: String, newLabel: Int){
        print(item.title, item.checked)
        let documentId = item.id
        
        var newArray: [ItemDataType]
        
        switch newLabel{
        case 0:
            newArray = self.filterdList0
        case 1:
            newArray = self.filterdList1
        case 2:
            newArray = self.filterdList2
        default:
            newArray = self.filterdList0
        }
        
        
        
        let group = DispatchGroup() // DispatchGroupを作成
        group.enter() // タスクが始まったことを通知
        
        //アイテムのタイトル書き換え
        db.collection("items").document(documentId).updateData([
            "title": newTitle
        ]) { [weak self] error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        group.leave()
        
        // 全てのタスクが終わった後に呼ばれる
        group.notify(queue: .main) {
            self.renumber(label: newLabel, newArray: newArray)
            self.updateAllTasks()
        }
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

