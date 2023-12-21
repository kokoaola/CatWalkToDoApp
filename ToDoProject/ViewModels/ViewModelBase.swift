//
//  ViewModelBase.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI

///タスクの全リストを取り扱うベースのビューモデル
class ViewModelBase: ObservableObject {
    //firebaseServiceクラスのインスタンスを作成
    let firebaseService = FirebaseDataService()
    
    @Published var label0Item = [ItemDataType]()
    @Published var label1Item = [ItemDataType]()
    @Published var label2Item = [ItemDataType]()
    
    
    init() { //すべてのデータをフェッチ
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


