//
//  AddNewLabel_View.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/10/02.
//

import SwiftUI


struct AddNewLabel_View: View {
    //ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "1"
    @AppStorage("label1") var label1 = "2"
    @AppStorage("label2") var label2 = "3"
    //ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    @State var newName0 = ""
    @State var newName1 = ""
    @State var newName2 = ""
    
    var body: some View {
        
        VStack(spacing: 30.0){
            Spacer()
            Group{
                HStack{
                    Text("Label1")
                    TextField("\(label0)", text: $newName0,
                              prompt: Text("\(newName0)"))}
                
                HStack{
                    Text("Label2")
                    TextField("\(label1)", text: $newName1,
                              prompt: Text("\(newName0)"))}
                
                HStack{
                    Text("Label3")
                    TextField("\(label2)", text: $newName2,
                              prompt: Text("\(newName0)"))}
            }.padding(.horizontal)
            
            //ラベルの変更をユーザーデフォルトに保存
            Button(action: {
                label0 = newName0
                label1 = newName1
                label2 = newName2
                dismiss()
            }, label: {
                SaveButton() //保存ボタンは別ファイル
            })
            .padding(.top, 40.0)
            Spacer()
            Spacer()
        }.textFieldStyle(.roundedBorder)
        .onAppear(){
            newName0 = label0
            newName1 = label1
            newName2 = label2
        }
    }
}
struct AddNewLabel_View_Previews: PreviewProvider {
    static var previews: some View {
        AddNewLabel_View()
    }
}
