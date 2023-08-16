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
    @State var price:Int?
    
    ///量を格納する変数
    @State var amount = ""
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（金額）
    @FocusState var isInputActivePrice: Bool
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（量）
    @FocusState var isInputActiveVolume: Bool
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, spacing : 30){
                
                //価格入力用のテキストフィールド
                HStack{
                    Text("商品の価格")
                        .padding(.trailing)
                    TextField("商品の価格を入力", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "JPY" ))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActivePrice)
                    //                    Text("円")
                }
                
                //全体量入力用のテキストフィールド
                HStack{
                    Text("商品の全体量")
                    TextField("ml、個数などを入力", text: $amount)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputActiveVolume)
                }
                
                
                //単価を計算して表示（小数点3桁より下は切り捨て）
                VStack{
                    Text("1つあたり").font(.title2).padding(.vertical, 5).padding(.trailing, 100)
//                    Text(keisan(price:price ?? 0, amount:amount), format: .currency(code: Locale.current.currency?.identifier ?? "USD" )).font(.largeTitle)
                    CurrencyText(value: keisan(price:price ?? 0, amount:amount))
                    //                    Spacer()
                    //                    Text("\(keisanInt(price:price ?? 0, amount:amount))").font(.largeTitle) +
                    //                    Text(" . ") +
                    //                    Text("\(keisanDecimal(price:price ?? 0, amount:amount))").font(.title2) +
                    //                    Text("円").font(.title3)
                    //                    Spacer()
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
    private func keisan(price: Int, amount: String) -> Double{
        let num = (Float(price) ?? 0.0) / (Float(amount) ?? 0.0)
        
        if num.isInfinite{
            return 0
        }else if num.isNaN{
            return 0
        }else{
            print(num)
            return Double(num)
            //            let value = Double(String(format: "%.3f", num))
            //            let fraction = value?.truncatingRemainder(dividingBy: 1)
            //            return Int(String(format: "%.0f", num)) ?? 0 + Int((fraction ?? 0) * 1000)
        }
    }
}

struct Keisan_Previews: PreviewProvider {
    static var previews: some View {
        Keisan()
    }
}



struct CurrencyText: View {
    let value: Double
    
    var body: some View {
        Text(currencyString(from: value))
            .font(.largeTitle) // 文字サイズを大きく
    }
    
    private func currencyString(from value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = Locale.current.currencyCode
        
        // 日本円の場合の設定
        if formatter.currencyCode == "JPY" {
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 3 // 小数点第三位まで表示
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
