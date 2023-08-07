//
//  Keisan.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI

///単価計算のビュー
struct Keisan: View {
    ///金額を格納する変数
    @State var price = ""
    
    ///量を格納する変数
    @State var amount = ""
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（金額）
    @FocusState var isInputActivePrice: Bool
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（量）
    @FocusState var isInputActiveVolume: Bool
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing : 30){
                
                //価格入力用のテキストフィールド
                HStack{
                    Text("商品の価格")
                        .padding(.trailing)
                    TextField("商品の価格を入力", text: $price)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActivePrice)
                    Text("円")
                }
                
                //全体量入力用のテキストフィールド
                HStack{
                    Text("商品の全体量")
                    TextField("ml、個数などを入力", text: $amount)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActiveVolume)
                }
                
                
                //単価を計算して表示（小数点3桁より下は切り捨て）
                
                Text("1つあたり").font(.title2).padding(.top)
                
                HStack{
                    Spacer()
                    Text("\(keisanInt(price:price, amount:amount))").font(.largeTitle) +
                    Text(" . ") +
                    Text("\(keisanDecimal(price:price, amount:amount))").font(.title2) +
                    Text("円").font(.title3)
                    Spacer()
                }
                .padding(.bottom)
                
                
                Group{
                    Text("小さければ小さいほどお得です。\n単位は切り捨てです。")
                }
                    .foregroundColor(Color(UIColor.systemGray))
            }
            .padding()
            //タップでキーボードを閉じる
            .contentShape(Rectangle())
            .onTapGesture {
                AppSetting.colseKeyBoard()
            }
            
            //キーボード閉じるボタンを配置
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(isInputActivePrice && !isInputActiveVolume ? "次へ" : "閉じる") {
                        if isInputActivePrice && !isInputActiveVolume{
                            isInputActiveVolume = true
                        }else{
                            isInputActivePrice = false
                            isInputActiveVolume = false
                        }
                    }
                }
            }
        }
    }
    
    ///単価を計算して整数を返す関数
    private func keisanInt(price: String, amount: String) -> Int{
        let num = (Float(price) ?? 0.0) / (Float(amount) ?? 0.0)
        
        if num.isInfinite{
            return 0
        }else if num.isNaN{
            return 0
        }else{
            return Int(String(format: "%.0f", num)) ?? 0
        }
    }
    
    
    ///単価を計算して少数を返す関数
    private func keisanDecimal(price: String, amount: String) -> Int{
        let num = (Float(price) ?? 0.0) / (Float(amount) ?? 0.0)
        
        if num.isInfinite{
            return 0
        }else if num.isNaN{
            return 0
        }else{
            let value = Double(String(format: "%.3f", num))
            let fraction = value?.truncatingRemainder(dividingBy: 1)
            return Int((fraction ?? 0) * 1000)
        }
    }
}

struct Keisan_Previews: PreviewProvider {
    static var previews: some View {
        Keisan()
    }
}
