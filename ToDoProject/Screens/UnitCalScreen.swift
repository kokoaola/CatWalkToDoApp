//
//  Keisan.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/28.
//

import SwiftUI



///単価計算のビュー
struct UnitCalScreen: View {
    ///ViewModelのための変数
    @ObservedObject var unitCalScreenVM = UnitCalScreenViewModel()
    
    ///Doneボタン表示のためのキーボードフォーカス用変数（金額）
    @FocusState var isInputActivePrice: Bool
    ///Doneボタン表示のためのキーボードフォーカス用変数（量）
    @FocusState var isInputActiveVolume: Bool
    
    var body: some View {
        ZStack{
            //上のヘッダーセクション
            VStack{
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: AppSetting.screenHeight * 0.15)
                    .overlay(
                        Text("Unit Price Calculation").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, AppSetting.screenHeight * 0.05)
                            .accessibilityAddTraits(.isHeader)
                    )
                Spacer()
            }//VStackここまで
            
            VStack(alignment: .center, spacing : 50){
                //テキストフィールド2つのセクション
                VStack(spacing: 30){
                    //価格入力用のテキストフィールド
                    HStack{
                        Text("Product Price")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("Enter Price", value: $unitCalScreenVM.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"), prompt: Text("Enter Price").foregroundColor(Color.black.opacity(0.4)))
                            .focused($isInputActivePrice)
                            .unitCalTextField()
                    }//HStackここまで
                    
                    //全体量入力用のテキストフィールド
                    HStack{
                        Text("Total Quantity")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("Enter in ml, count, etc.", value: $unitCalScreenVM.amount, format: .number, prompt: Text("Enter in ml, count, etc.").foregroundColor(Color.black.opacity(0.4)))
                            .focused($isInputActiveVolume)
                            .unitCalTextField()
                    }
                }//VStackここまで
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(.white)
                .foregroundColor(AppSetting.fontColor)
                .frame(width: AppSetting.screenWidth * 0.8)
                .padding(.vertical)
                
                
                //計算結果を表示するセクション
                VStack{
                    //単価を計算して表示（小数点3桁より下は切り捨て）
                    VStack{
                        Text("Per Unit").font(.title2).padding(.vertical, 5).padding(.trailing, 100)
                        CurrencyText(value: unitCalScreenVM.unit)
                    }
                    .padding(.bottom)
                    
                    //アクセシビリティ用
                    .contentShape(Rectangle())
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(AppSetting.currencyString(from: unitCalScreenVM.unit)), Per Unit")
                    
                    
                    Text("The smaller the value, the better the deal.\nValues are truncated.")
                        .opacity(0.9)
                        .font(.callout)
                }//VStackここまで
                .padding()
                .foregroundColor(AppSetting.fontColor)
                .frame(width: AppSetting.screenWidth * 0.8)
                .background(AppSetting.mainColor1.opacity(0.1))
                .cornerRadius(15)
                
                
            }//VStackここまで
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
        }//ZStackここまで
        .background(.white)
        .ignoresSafeArea()
        .embedInNavigationView()
    }
}


///
struct CurrencyText: View {
    let value: Double
    
    var body: some View {
        Text(AppSetting.currencyString(from: value))
            .font(.largeTitle) // 文字サイズを大きく
    }
}

