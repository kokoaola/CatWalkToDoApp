//
//  ListScreenViewModel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI
import FirebaseFirestore
import Firebase



class ListScreenViewModel: ViewModelBase {
    
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
    
    ///ゴミ箱ボタンが押された時の処理
    ///完了したタスクをまとめて削除
    func deleteCompletedTask(labelNum: Int) {
        //完了したタスクの配列を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let targetArray = allDataArray[labelNum]
        let completedArray = targetArray.filter { $0.checked == true }
        
        //削除用関数を呼び出す
        firebaseService.deleteItemFromCollection(labelNum: labelNum, items: completedArray)
        //インデックス番号の振り直し
        firebaseService.updateIndexesForCollection(labelNum: labelNum, dataArray: targetArray)
        //コレクションをリロード
        fetchSelectedData(labelNum)
    }
}
