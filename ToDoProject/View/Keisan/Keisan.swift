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
    @State var price:Double?
    
    ///量を格納する変数
    @State var amount:Double?
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（金額）
    @FocusState var isInputActivePrice: Bool
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（量）
    @FocusState var isInputActiveVolume: Bool
    
    var body: some View {
        NavigationStack{
            ZStack{
                //上のナビゲーションバーっぽいセクション
                VStack{
                    LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing)
                        .frame(height: AppSetting.screenHeight * 0.15)
                        .overlay(
                            Text("Unit Price Calculation").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, AppSetting.screenHeight * 0.05)
                                .accessibilityAddTraits(.isHeader)
                        )
                Spacer()
                }
                
                
                VStack(alignment: .center, spacing : 30){
                    
                    //テキストフィールドのセクション
                    VStack(spacing: 20){
                        //価格入力用のテキストフィールド
                        HStack{
                            Text("Product Price")
                                .padding(.trailing)
                            TextField("Enter Price", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"), prompt: Text("Enter Price").foregroundColor(Color.black.opacity(0.4)))
                                .focused($isInputActivePrice)
                                .textFieldStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .background(.white)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(.gray, lineWidth: 1)
                                )
                        }
                        
                        //全体量入力用のテキストフィールド
                        HStack{
                            Text("Total Quantity")
                            TextField("Enter in ml, count, etc.", value: $amount, format: .number, prompt: Text("Enter in ml, count, etc.").foregroundColor(Color.black.opacity(0.4)))
                                .focused($isInputActiveVolume)
                                .textFieldStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .background(.white)
                                .padding(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(.gray, lineWidth: 1)
                                )
                        }
                    }
                    .foregroundColor(AppSetting.fontColor)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .frame(width: AppSetting.screenWidth * 0.9)
                    .background(.white)
                    .cornerRadius(15)
                    
                    VStack{
                        //単価を計算して表示（小数点3桁より下は切り捨て）
                        VStack{
                            Text("Per Unit").font(.title2).padding(.vertical, 5).padding(.trailing, 100)
                            CurrencyText(value: keisan(price:price ?? 0, amount:amount ?? 0))
                        }
                        .padding(.bottom)
                        //MARK: -
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("1単位あたり" + AppSetting.currencyString(from: keisan(price:price ?? 0, amount:amount ?? 0)))
                        
                        
                        Text("The smaller the value, the better the deal.\nValues are truncated.")
                            .opacity(0.9)
                            .font(.callout)
                    }
                    .foregroundColor(AppSetting.fontColor)
                    .padding()
                    .frame(width: AppSetting.screenWidth * 0.9)
                    .background(Color("usuigray"))
                    .cornerRadius(15)
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 4)
                    )
                    
                }
                //タップでキーボードを閉じる
                .contentShape(Rectangle())
                .onTapGesture {
                    AppSetting.closeKeyBoard()
                }
                
                //キーボード閉じるボタンを配置
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(isInputActivePrice && !isInputActiveVolume ? "Next" : "Close") {
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
            .background(.white)
            .ignoresSafeArea()
        }
    }
    
    ///単価を計算して整数を返す関数
    private func keisan(price: Double, amount: Double) -> Double{
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

struct Keisan_Previews: PreviewProvider {
    static var previews: some View {
        Keisan()
    }
}



struct CurrencyText: View {
    let value: Double
    
    var body: some View {
        Text(AppSetting.currencyString(from: value))
            .font(.largeTitle) // 文字サイズを大きく
    }
}
