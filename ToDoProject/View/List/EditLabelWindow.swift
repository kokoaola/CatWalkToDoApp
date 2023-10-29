//
//  Edit.swift
//  ToDoProject
//
//  Created by koala panda on 2023/10/29.
//

import SwiftUI


struct EditLabelWindow: View {
    ///自分自身の表示状態を格納するフラグ
    @Binding var showAlert: Bool
    
    ///SettingViewでトーストポップアップを表示させるフラグ
    @Binding var showToast: Bool
    
    ///トースト内に表示する文章を格納する変数
    @Binding var toastText: String
    
    ///入力したテキストを格納する変数
    @State var editText: String = ""
    
    ///入力できる最大文字数
    let maxLength = 30
    
    ///使用端末の横画面サイズ
    let screenWidth = UIScreen.main.bounds.width
    
    ///使用端末の縦画面サイズ
    let screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        
            VStack(alignment: .leading){
                
                //見出しの文言
                Text("ラベルの変更")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                
                //テキストエディタ
                TextEditor(text: $editText)
                    .foregroundColor(Color(UIColor.black))
                    .tint(.black)
                    .scrollContentBackground(Visibility.hidden)
                    .background(.gray.opacity(0.5))
                    .border(.gray, width: 1)
                    .frame(height: 80)
                    .opacity(editText.isEmpty ? 0.5 : 1)
                    .accessibilityLabel("ラベル名を変更するためのテキストフィールド")
                
                //文字数オーバー時の警告
                Text("\(maxLength)文字以内のみ設定可能です").font(.caption) .font(.caption)
                    .foregroundColor(editText.count > maxLength ? .red : .clear)
                
                
                HStack{
                    //キャンセルボタン
                    Button {
                        showAlert = false
                    } label: {
                        Text("キャンセル")
                            .frame(width: screenWidth / 3.5, height: screenWidth * 0.1)
                    }
                    .tint(.red)
                    
                    Spacer()
                    
                    //保存ボタン
                    Button {
                        //                    if !editText.isEmpty && AppSetting.maxLengthOfTerm >= editText.count{
                        //                        userSettingViewModel.saveUserSettingGoal(isLong: isLong, goal: editText)
                        //                    }
                        toastText = "目標を変更しました"
                        showAlert = false
                        showToast = true
                    } label: {
                        Text("保存する")
                            .frame(width: screenWidth / 3.5, height: screenWidth * 0.1)
                    }.tint(.green)
                    //                    .disabled(editText.isEmpty || editText.count > maxLengthOfTerm)
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
        //ページ表示時に初期値として現在の目標をテキストエディターに入力
        .onAppear{
            editText = "Test"
        }
    }
}

struct EditLabelWindow_Previews: PreviewProvider {
    @State static var isEdit = false
    @State static var showToast = false
    @State static var toastText = "目標を変更しました"
    static var previews: some View {
        Group{
            EditLabelWindow(showAlert: $isEdit,showToast: $showToast,toastText: $toastText)
                .environment(\.locale, Locale(identifier:"en"))
            EditLabelWindow(showAlert: $isEdit,showToast: $showToast,toastText: $toastText)
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
