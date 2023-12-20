//
//  Constants.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import Foundation


struct Constants {
    ///firebaseのコレクション名
    static let firebaseCollectionName = "users"
    static let firebaseSubCollectionNameArray = ["label0Item", "label1Item", "label2Item"]
    
    ///お気に入りリストのUserDefaultsのキー
    static let favoriteListKey = "favoriteList"
    
    ///インデックス名のUserDefaultsのキー
    static let index0Key = "Label0"
    static let index1Key = "Label1"
    static let index2Key = "Label2"
}
