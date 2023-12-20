//
//  TutorialSpeechBubble.swift
//  ToDoProject
//
//  Created by koala panda on 2023/12/19.
//

import SwiftUI

struct TutorialSpeechBubble: View {
    var body: some View {
        VStack{
            SpeechBubbleView1()
                .offset(x:0, y:-10)
                .overlay{
                    VStack{
                        Text("By long-pressing index,\nyou can edit label name.")
                            .fontWeight(.bold)
                            .lineSpacing(10)
                    }
                    .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                    .foregroundColor(.black).opacity(0.6)
                }
            
            Spacer()
            
            SpeechBubbleView2()
                .offset(x:0, y:-10)
                .overlay{
                    VStack{
                        Text("Add tasks from here.")
                            .fontWeight(.bold)
                            .lineSpacing(10)
                    }
                    .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
                    .foregroundColor(.black).opacity(0.6)
                }
            
            Spacer()
                .frame(height: 50)
        }
        .padding(.vertical, 50)
    }
}


///吹き出しのビュー
struct SpeechBubbleView1: View{
    var body: some View {
        SpeechBubblePath()
            .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
            .padding(.top)
            .shadow(color:.black.opacity(1), radius: 5, x: 3, y: 3)
            .foregroundColor(AppSetting.mainColor2).opacity(0.3)
    }
}


///吹き出しのビュー
struct SpeechBubbleView2: View{
    var body: some View {
        SpeechBubblePath()
            .rotation(Angle(degrees:180))
            .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.2)
            .padding(.top)
            .shadow(color:.black.opacity(1), radius: 5, x: 3, y: 3)
            .foregroundColor(AppSetting.mainColor1).opacity(0.3)
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
