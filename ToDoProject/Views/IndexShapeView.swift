//
//  IndexLabel.swift
//  ToDoProject
//
//  Created by koala panda on 2023/10/29.
//

import SwiftUI


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
        
        // 下の辺は描画しないため、左下へ直接戻る
        //        path.addLine(to: CGPoint(x: rect.minX - 1.5, y: rect.maxY))
        
        
        return path
    }
}


struct IndexLabel_Previews: PreviewProvider {
    static var previews: some View {
        IndexShape()
    }
}
