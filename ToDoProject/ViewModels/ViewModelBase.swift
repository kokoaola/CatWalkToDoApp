//
//  ViewModelBase.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import Foundation


///タスクの全リストを取り扱うビューモデル
class ViewModelBase: ObservableObject {
    @Published  var label0Item = [ItemDataType]()
    @Published  var label1Item = [ItemDataType]()
    @Published  var label2Item = [ItemDataType]()
}

