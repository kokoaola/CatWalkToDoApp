//
//  Store.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/13.
//

import Foundation


///.environmentObjectを使用してアプリケーション全体で認識するグローバルクラス
/*
これ必要
@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Store())
        }
    }
}*/

class Store: ObservableObject {
    let defaults = UserDefaults.standard
    
    ///グローバルオブジェクト
    @Published var indexLabel0 = "1"{
        didSet {
            defaults.set(indexLabel0, forKey: "label0")
        }
    }
    
    @Published var indexLabel1 = "2"{
        didSet {
            defaults.set(indexLabel1, forKey: "label1")
        }
    }
    
    @Published var indexLabel2 = "3"{
        didSet {
            defaults.set(indexLabel2, forKey: "label2")
        }
    }
    
    
    init(){
        //お気に入り登録されたタスクを取得
        self.indexLabel0 = defaults.string(forKey:"label0") ?? "1"
        self.indexLabel1 = defaults.string(forKey:"label1") ?? "2"
        self.indexLabel2 = defaults.string(forKey:"label2") ?? "3"
    }
    
    ///都市名を配列に追加する関数
    func getIndexArray() -> [String]{
        return [indexLabel0, indexLabel1, indexLabel2]
    }
}
