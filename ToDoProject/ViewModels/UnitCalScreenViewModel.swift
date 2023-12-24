//
//  UnitCalScreenViewModel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/21.
//

import Foundation


class UnitCalScreenViewModel: ObservableObject{
    
    ///金額を格納する変数
    @Published var price: Double = 0
    
    ///量を格納する変数
    @Published var amount: Double = 0
    
    
    ///量を格納する変数
    var unit: Double{
        
        let num = Double(price / amount)
        
        if num.isInfinite{
            return 0
        }else if num.isNaN{
            return 0
        }else{
            return num
        }
    }
    
    ///端末の国設定の通貨の単位を付ける関数
    func currencyStringFromUnit() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currency?.identifier
        
        // 日本円の場合の設定
        if formatter.currencyCode == "JPY" {
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 3 // 小数点第三位まで表示
        }
        
        return formatter.string(from: NSNumber(value: self.unit)) ?? ""
    }
}
