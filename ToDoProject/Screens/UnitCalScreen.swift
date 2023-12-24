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
    
    ///入力された値を一時的に格納する変数
    @State private var priceInput = ""
    @State private var amountInput = ""
    
    var body: some View {
        ZStack{
            //上のヘッダーセクション
            VStack{
                LinearGradient(gradient: Gradient(colors: [AppStyles.mainColor1, AppStyles.mainColor2]), startPoint: .leading, endPoint: .trailing)
                    .frame(height: AppStyles.screenHeight * 0.15)
                    .overlay(
                        Text("Unit Price Calculation").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, AppStyles.screenHeight * 0.05)
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
                        
                        TextField("Enter Price", text: $priceInput, prompt: Text("Enter Price").foregroundColor(Color.black.opacity(0.4)))
                            .keyboardType(.numberPad)
                            .focused($isInputActivePrice)
                            .unitCalTextField()
                            .onChange(of: priceInput) { newValue in
                                unitCalScreenVM.price = Double(newValue) ?? 0
                            }
                    }//HStackここまで
                    
                    //全体量入力用のテキストフィールド
                    HStack{
                        Text("Total Quantity")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        TextField("Enter Price", text: $amountInput, prompt: Text("Enter in ml, count, etc.").foregroundColor(Color.black.opacity(0.4)))
                            .keyboardType(.numberPad)
                            .focused($isInputActiveVolume)
                            .unitCalTextField()
                            .onChange(of: amountInput) { newValue in
                                unitCalScreenVM.amount = Double(newValue) ?? 0
                            }
                    }
                }//VStackここまで

                .foregroundColor(AppStyles.fontColor)
                .frame(width: AppStyles.screenWidth * 0.8)
                .padding(.vertical)
                
                
                //計算結果を表示するセクション
                VStack{
                    //単価を計算して表示（小数点3桁より下は切り捨て）
                    VStack{
                        Text("Per Unit").font(.title2).padding(.vertical, 5).padding(.trailing, 100)
                        Text(unitCalScreenVM.currencyStringFromUnit()).font(.largeTitle)
                    }
                    .padding(.bottom)
                    
                    //アクセシビリティ用
                    .contentShape(Rectangle())
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(unitCalScreenVM.currencyStringFromUnit()), Per Unit")
                    
                    
                    Text("The smaller the value, the better the deal.\nValues are truncated.")
                        .opacity(0.9)
                        .font(.callout)
                }//VStackここまで
                .padding()
                .frame(width: AppStyles.screenWidth * 0.8)
                .foregroundColor(AppStyles.fontColor)
                .background(AppStyles.mainColor1.opacity(0.1))
                .cornerRadius(15)
                
                
            }//VStackここまで
            
            
            //タップでキーボードを閉じる
            .contentShape(Rectangle())
            .onTapGesture {
                if unitCalScreenVM.amount == nil{
                    print("nil")
                }
                
                if unitCalScreenVM.price == nil{
                    print("nil")
                }
                
                isInputActivePrice = false
                isInputActiveVolume = false
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
