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
    
    
    func keisan(price: Double, amount: Double) -> Double{
        let num = price / amount
        
        if num.isInfinite{
            return 0
        }else if num.isNaN{
            return 0
        }else{
            return num
        }
    }
}
