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
    
    ///自分自身の表示状態を格納するフラグ
    @Binding var labelArray:[String]
    
    ///自分自身の表示状態を格納するフラグ
    var labelNum = 0
    
    ///入力したテキストを格納する変数
    @State var editText: String = ""
    
    ///入力できる最大文字数
    let maxLength = 20
    
    ///ユーザーデフォルト用変数
    private let defaults = UserDefaults.standard
    
    @State var key = ""
    
    ///ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "1"
    @AppStorage("label1") var label1 = "2"
    @AppStorage("label2") var label2 = "3"
    
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
                .foregroundColor(Color(UIColor.black))
                .tint(.black)
                .scrollContentBackground(Visibility.hidden)
                .background(.gray.opacity(0.5))
                .border(.gray, width: 1)
                .frame(height: 80)
                .opacity(editText.isEmpty ? 0.5 : 1)
                .accessibilityLabel("Text field to change custom label name.")
                .focused($isInputActive)
            
            //文字数オーバー時の警告
            Text("Only up to \(maxLength) characters can be set").font(.caption) .font(.caption)
                .foregroundColor(editText.count > maxLength ? .red : .clear)
            
            
            HStack{
                //キャンセルボタン
                Button {
                    showAlert = false
                } label: {
                    Text("Cancel")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                }
                .tint(.red)
                
                Spacer()
                
                //保存ボタン
                Button {
                    if !editText.isEmpty && maxLength >= editText.count{
                        switch labelNum {
                        case 0:
                            label0 = editText
                        case 1:
                            label1 = editText
                        case 2:
                            label2 = editText
                        default:
                            break
                        }
                        
                        labelArray = [label0,label1,label2]
                        showAlert = false
                    }
                    
                } label: {
                    Text("Save")
                        .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
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
        //ページ表示時に初期値として現在の目標をテキストエディターに入力
        .onAppear{
            switch labelNum {
            case 0:
                editText = label0
            case 1:
                editText = label1
            case 2:
                editText = label2
            default:
                editText = "Error"
            }
            isInputActive = true
        }
    }
}

//struct EditLabelWindow_Previews: PreviewProvider {
//    @State static var isEdit = false
//    static var previews: some View {
//        Group{
//            EditLabelWindow(showAlert: $isEdit)
//                .environment(\.locale, Locale(identifier:"en"))
//            EditLabelWindow(showAlert: $isEdit)
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//    }
//}
