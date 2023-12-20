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

struct TutorialSpeechBubble_Previews: PreviewProvider {
    static var previews: some View {
        TutorialSpeechBubble()
    }
}
