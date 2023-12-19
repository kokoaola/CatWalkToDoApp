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
