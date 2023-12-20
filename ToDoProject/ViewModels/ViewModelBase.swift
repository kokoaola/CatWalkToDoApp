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
    
    
    init() {
        
        self.defaults.object(forKey:"SavedArray") as? [String] ?? ["", "", ""]
        
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


