//
//  Keisan.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

///単価計算のビュー
struct Keisan: View {
    @State var price = ""
    @State var amount = ""
    
    var body: some View {
        VStack{
            
            //価格入力用のテキストフィールド
            HStack{
                Text("商品の価格    ")
                TextField("商品の価格を入力", text: $price)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                Text("円")
            }.padding()
            
            //全体量入力用のテキストフィールド
            HStack{
                Text("商品の全体量")
                TextField("ml、個数などを入力", text: $amount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            //単価を計算して表示（小数点3桁より下は切り捨て）
            Text("\n単価は  \(String(format: "%.3f", keisan(price:price, amount:amount)))円")
                .font(.largeTitle)
            Text("\n\n入力した単位１あたりの値段です。\n単価は小さければ小さいほどお得です。")
                .foregroundColor(Color(UIColor.systemGray))
        }
    }
    
    //単価を計算してリターンする関数
    private func keisan(price: String, amount: String) -> Float{
        let num = (Float(price) ?? 0.0) / (Float(amount) ?? 0.0)
        
        if num.isInfinite{
            return 0.0
        }else if num.isNaN{
            return 0.0
        }else{
            return num
        }
    }
}

struct Keisan_Previews: PreviewProvider {
    static var previews: some View {
        Keisan()
    }
}
