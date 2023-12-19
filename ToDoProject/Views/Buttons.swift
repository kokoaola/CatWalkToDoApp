//
//  CompButton.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI
///ボタンのデザインたち



///猫の＋ボタン
struct CatAddButton:View{
    let color: Color
    var body: some View{
        ZStack{
            Image(systemName: "triangle.fill")
                .offset(x: 0,y: -27)
                .rotationEffect(Angle(degrees: 28),anchor: .bottom)
                .font(.title)
                .foregroundColor(color)
            
            
            Image(systemName: "triangle.fill")
                .offset(x: 0,y: -27)
                .rotationEffect(Angle(degrees: 28),anchor: .bottom)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .font(.title)
                .foregroundColor(color)
            
            
            Image(systemName: "plus")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(30)
        }
        .padding(.bottom, 5)
        .padding([.horizontal, .top], 15)
        .compositingGroup()
        .shadow(color:.black.opacity(0.3), radius: 3, x: 3, y: 3)
        .contentShape(Rectangle())
    }
}

///買い物リストの要素追加の保存ボタン
struct SaveButton: View {
    var body: some View {
        //ボタンのラベル
        Capsule()
            .stroke(Color(UIColor.label), lineWidth: 1)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(width: 200, height: 50)
            .overlay(Text("Save")
                .foregroundColor(Color(UIColor.label)))
            .font(.title)
            .font(.system(size: 50, weight: .semibold))
    }
}


///ゴミ箱マーク削除ボタン
struct TrashButton: View {
    var body: some View {
        Image(systemName: "trash.square.fill")
            .symbolRenderingMode(SymbolRenderingMode.palette)
            .font(.largeTitle)
            .foregroundStyle(.white, .gray)
            .shadow(color:.black.opacity(0.5), radius: 3, x: 3, y: 3
            )
    }
}



struct CompButton_Previews: PreviewProvider {
    @State static var aa = false
    @State static var bb = false
    static var cc = "aaaaa"
    static var previews: some View {
        VStack{
            SaveButton()
        }
    }
}

