//
//  Store.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/13.
//

import Foundation


///.environmentObjectを使用してアプリケーション全体で認識するグローバルクラス

class Store: ObservableObject {
    let defaults = UserDefaults.standard
    
    ///グローバルオブジェクト
    ///インデックスラベルの名前
    @Published var indexLabel0 = "1"{
        didSet {
            defaults.set(indexLabel0, forKey: Constants.index0Key)
        }
    }
    
    @Published var indexLabel1 = "2"{
        didSet {
            defaults.set(indexLabel1, forKey: Constants.index1Key)
        }
    }
    
    @Published var indexLabel2 = "3"{
        didSet {
            defaults.set(indexLabel2, forKey: Constants.index2Key)
        }
    }
    
    
    init(){
        //お気に入り登録されたタスクを取得
        self.indexLabel0 = defaults.string(forKey: Constants.index0Key) ?? "1"
        self.indexLabel1 = defaults.string(forKey: Constants.index1Key) ?? "2"
        self.indexLabel2 = defaults.string(forKey: Constants.index2Key) ?? "3"
    }
    
    ///都市名を配列にして返す関数
    func getIndexArray() -> [String]{
        return [indexLabel0, indexLabel1, indexLabel2]
    }
}
