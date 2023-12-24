//
//  Edit.swift
//  ToDoProject
//
//  Created by koala panda on 2023/10/29.
//

import SwiftUI


///インデックスボタン長押しで表示させるテキストフィールドアラート
struct EditIndexAlertView: View {
    ///インデックスラベルをアプリ内で共有する環境変数
    @EnvironmentObject var store: Store
    
    ///自分自身の表示状態を格納するフラグ
    @Binding var showAlert: Bool
    
    ///自分自身の表示状態を格納するフラグ
    var labelNum = 0
    
    ///入力したテキストを格納する変数
    @State var editText: String = ""
    
    ///入力できる最大文字数
    let maxLength = 20
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            //見出しの文言
            Text("Edit custom label")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title3)
            
            //テキストエディタ
            TextEditor(text: $editText)
                .customTextEditStyle()
                .opacity(editText.isEmpty ? 0.5 : 1)
                .focused($isInputActive)
                .editAccessibility(label: "Text field to change custom label name.")
            
            //文字数オーバー時の警告
            Text("Only up to \(maxLength) characters can be set").font(.caption) .font(.caption)
                .foregroundColor(editText.count > maxLength ? .red : .clear)
            
            
            HStack{
                //キャンセルボタン
                Button {
                    showAlert = false
                } label: {
                    Text("Cancel")
                        .frame(width: AppStyles.screenWidth / 3.5, height: AppStyles.screenWidth * 0.1)
                }
                .tint(.red)
                
                Spacer()
                
                //保存ボタン
                Button {
                    if !editText.isEmpty && maxLength >= editText.count{
                        switch labelNum {
                        case 0:
                            store.indexLabel0 = editText
                        case 1:
                            store.indexLabel1 = editText
                        case 2:
                            store.indexLabel2 = editText
                        default:
                            break
                        }
                        showAlert = false
                    }
                    
                } label: {
                    Text("Save")
                        .frame(width: AppStyles.screenWidth / 3.5, height: AppStyles.screenWidth * 0.1)
                }.tint(.green)
                    .disabled(editText.isEmpty || editText.count > maxLength)
                
                
                
                //キーボード閉じるボタン
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Close") {
                                isInputActive = false
                            }
                        }
                    }
            }//HStackここまで
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
            
        }//VStackここまで
        
        .foregroundColor(.black)
        .padding()
        .background(.white)
        .cornerRadius(15)
        .padding()
        //ページ表示時に初期値として現在のインデックスをテキストエディターに入力
        .onAppear{
            isInputActive = true
        }
    }
}
