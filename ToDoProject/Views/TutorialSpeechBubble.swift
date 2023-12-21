//
//  TutorialSpeechBubble.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI


///タスクが一件も存在しない時に表示するチュートリアルのビュー
struct TutorialSpeechBubble: View {
    var body: some View {
        VStack{
            //上部の吹き出しのビュー
            SpeechBubbleView(text: "By long-pressing index,\nyou can edit label name.", isLotation: false)
            
            Spacer()
            
            //下部の吹き出しのビュー
            SpeechBubbleView(text: "Add tasks from here.", isLotation: true)
            
            Spacer()
                .frame(height: 50)
        }
        .padding(.vertical, 50)
    }
}


///吹き出しのビュー
struct SpeechBubbleView: View{
    var text: String
    var isLotation: Bool
    
    var body: some View {
        SpeechBubblePath()
            .rotation(Angle(degrees: isLotation ? 180 : 0))
            .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
            .padding(.top)
            .shadow(color:.black.opacity(1), radius: 5, x: 3, y: 3)
            .foregroundColor(isLotation ? AppSetting.mainColor1 : AppSetting.mainColor2).opacity(0.3)
            .offset(x:0, y:-10)
            .overlay{
                VStack{
                    Text(LocalizedStringKey(text))
                        .fontWeight(.bold)
                        .lineSpacing(10)
                }
                .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                .opacity(0.6)
            }
            .contentShape(Rectangle())
    }
}


///吹き出しのパス
struct SpeechBubblePath: Shape {
    private let radius = 10.0
    private let tailSize = 20.0
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY))
            path.addCurve(
                to: CGPoint(x: rect.minX + rect.width / 2 + tailSize, y: rect.minY),
                control1: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY - tailSize),
                control2: CGPoint(x: rect.minX + rect.width / 2 + tailSize / 2, y: rect.minY)
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
        }
    }
}
