//
//  IndexLabel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/10/29.
//

import SwiftUI

struct IndexView: View{
    ///表示するラベルの番号を格納するプロパティ
    var num: Int
    
    ///ユーザーが選択中のラベルを格納するプロパティ
    @Binding var selection: Int
    
    ///ラベル編集アラート管理用のフラグ
    @Binding var isEdit:Bool
    
    ///ラベル文
    var index: String
    
    ///インデックスのサイズ
    let indexWidth = AppSetting.screenWidth / 3.5
    let indexHeight = 60.0
    
    var body: some View{
        IndexShape()
            .foregroundColor(.white)
            .frame(width: indexWidth, height: indexHeight)
            .shadow(color:.black.opacity(selection == num ? 0.5 : 0.0001), radius: 3, x: 3, y: 3)
        //ラベルの文字
            .overlay(
                Text(index)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color(selection == num ? .black : .gray)))
        //ユーザーが選択中の時はラベルの色を濃くする
            .opacity(selection == num ? 1.0 : 0.6)
        //タブは猫ちゃんの前後になるように表示
            .zIndex(selection == num ? 1.0 : -1.0)
            .contentShape(Rectangle())
            .onTapGesture {
                selection = num
            }
        //ラベル名長押しで編集用ウィンドウ表示
            .onLongPressGesture {
                selection = num
                isEdit = true
            }
            .accessibilityAddTraits(selection == num ? [.isSelected] : [])
            .accessibilityLabel("\(index), tab")
    }
}



///リストの見出しのビュー
struct IndexShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 左下の角を開始点として
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // 左上へ移動
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 10))
        path.addQuadCurve(to: CGPoint(x: rect.minX + 10, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        
        // 右上へ移動
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 10), control: CGPoint(x: rect.maxX, y: rect.minY))
        
        // 右下へ移動
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        return path
    }
}


struct IndexLabel_Previews: PreviewProvider {
    static var previews: some View {
        IndexShape()
    }
}
