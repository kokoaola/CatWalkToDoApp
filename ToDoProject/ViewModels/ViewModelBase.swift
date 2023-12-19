//
//  ViewModelBase.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI
import FirebaseFirestore
import Firebase


///タスクの全リストを取り扱うビューモデル
class ViewModelBase: ObservableObject {
    let firebaseService = FirebaseDataService()
    let defaults = UserDefaults.standard
    
    @Published var label0Item = [ItemDataType]()
    @Published var label1Item = [ItemDataType]()
    @Published var label2Item = [ItemDataType]()
    
    
    var indexLabel0:String{
        didSet {
            defaults.set(indexLabel0, forKey: "label0")
        }
    }
    
    var indexLabel1:String{
        didSet {
            defaults.set(indexLabel1, forKey: "label1")
        }
    }
    
    var indexLabel2:String{
        didSet {
            defaults.set(indexLabel2, forKey: "label2")
        }
    }
    
    
    init() {
        //お気に入り登録されたタスクを取得
        self.indexLabel0 = defaults.string(forKey:"label0") ?? "1"
        self.indexLabel1 = defaults.string(forKey:"label1") ?? "2"
        self.indexLabel2 = defaults.string(forKey:"label2") ?? "3"
        
        //すべてのデータをフェッチ
        fetchAllData()
    }
    
    
    ///すべてのデータをフェッチするメソッド
    func fetchAllData() {
        firebaseService.fetchDataForCollection(0) { [weak self] items in
            self?.label0Item = items
        }
        firebaseService.fetchDataForCollection(1) { [weak self] items in
            self?.label1Item = items
        }
        firebaseService.fetchDataForCollection(2) { [weak self] items in
            self?.label2Item = items
        }
    }
    
    ///選択したデータをフェッチするメソッド
    func fetchSelectedData(_ label:Int) {
        firebaseService.fetchDataForCollection(label) { [weak self] items in
            switch label{
            case 0:
                self?.label0Item = items
            case 1:
                self?.label1Item = items
            case 2:
                self?.label2Item = items
            default:
                return
            }
        }
    }
}


