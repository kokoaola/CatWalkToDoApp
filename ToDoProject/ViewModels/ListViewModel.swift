//
//  ListScreenViewModel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI

///リスト全体に関するビューモデル
class ListViewModel: ViewModelBase {
    ///猫動かす用
    @Published var stayPositionRight: Bool = false
    @Published var isFacingRight: Bool = true
    @Published var isMoving: Bool = false
    
    ///ユーザーに表示しているリストの種類
    @Published var labelNum: Int = 0
    
    ///ゴミ箱ボタンが押された時の処理、完了したタスクをまとめて削除
    func deleteCompletedTask(labelNum: Int) {
        //完了したタスクの配列を取得
        let allDataArray = [label0Item, label1Item, label2Item]
        let targetArray = allDataArray[labelNum]
        let completedArray = targetArray.filter { $0.checked == true }
        
        //削除用関数を呼び出す
        firebaseService.deleteItemFromCollection(labelNum: labelNum, items: completedArray){ error in
            
            //インデックス番号の振り直し
            self.firebaseService.updateIndexesForCollection(labelNum: labelNum){error in
                if let error = error { return } else {
                    //コレクションをリロード
                    self.fetchSelectedData(labelNum)
                }
            }
        }
    }
    
    
    ///達成フラグを反転して保存する
    func toggleItemCheckStatus(item: ItemDataType){
        //Bool値を反転
        let newStatus = !item.checked
        //updateItemInCollectionメソッドを呼び出す
        firebaseService.updateItemInCollection(oldItem: item, newCheckedStatus: newStatus, newTitle: item.title) { error in
            //コレクションをリロード
            self.fetchSelectedData(Int(item.label))
        }
    }
    
    
    ///リストをドラッグ&ドロップした後の処理、リストの序列を保存し直す
    func updateAfterMove(labelNum: Int){
        DispatchQueue.main.async {
            self.firebaseService.updateIndexesForCollection(labelNum: labelNum) { error in
                return
            }
        }
    }
    
    
    ///猫を歩かせる処理
    func walkingCat(itemCheckStatus: Bool){
        DispatchQueue.main.async {
        //猫が歩いていなくて、チェックマークがfalseの時
        if !self.isMoving && !itemCheckStatus{
            //猫を裏返す
            self.isFacingRight.toggle()
            //猫移動中にセット
            self.isMoving = true
            //猫歩く
            withAnimation() {
                self.stayPositionRight.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                self.isMoving = false
                }
            }
        }
    }
}
