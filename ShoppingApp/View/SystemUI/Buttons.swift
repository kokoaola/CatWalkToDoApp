//
//  CompButton.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//
///ボタンのデザインたち
import SwiftUI

//買い物完了ボタン
struct Buttons: View {
    var body: some View {
        Capsule()
            .frame(width: 170.0, height: 50)
//            .cornerRadius(25)
        
            .foregroundColor(Color(UIColor.systemBackground))

            .overlay(Text("タスクを完了する")
                .foregroundColor(Color.primary))
            .overlay(
                Capsule()
                    .stroke(Color.primary, lineWidth: 2))
            //.font(.title3)
            
    }
}

//買い物リストの要素追加ボタン
struct TuikaButton: View {
    var body: some View {
        //ボタンのラベル
        Capsule()
            .stroke(Color(UIColor.label), lineWidth: 1)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(width: 200, height: 50)
            .overlay(Text("保存する")
                .foregroundColor(Color(UIColor.label)))
            .font(.title)
            .font(.system(size: 50, weight: .semibold))
    }
}

//ボタンのラベル
struct LabelButton: View {
    var body: some View {
        Capsule()
            .stroke(Color(UIColor.label), lineWidth: 1)
            .foregroundColor(Color(UIColor.systemBackground))
            .frame(width: 200, height: 50)
            .overlay(Text("ラベル名を変更する")
                .foregroundColor(Color(UIColor.label)))
            .font(.title3)
            .font(.system(size: 50, weight: .semibold))
    }
}

struct PeriodButton: View {
    let period: String
    
    init(period: String) {
        self.period = period
    }
    
    var body: some View {
        Text(period)
            .frame(width: 30, height: 30)
            .foregroundColor(Color(UIColor.label))
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 3)
                .stroke(Color(.label), lineWidth: 1.0))
    }
}


struct FavoriteButton: View {
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        if title.count < 3{
            Text(title)
                .frame(width: 60, height: 30)
                .foregroundColor(Color(UIColor.label))
                //.background(Color(UIColor.secondarySystemBackground))
                .overlay(Capsule()
                    .stroke(Color(.gray), lineWidth: 1.0))
            
        }else if title.count < 7{
            Text(title)
                .frame(width: CGFloat(title.count) * 25, height: 30)
                .foregroundColor(Color(UIColor.label))
                //.background(Color(UIColor.secondarySystemBackground))
                .overlay(Capsule()
                    .stroke(Color(.gray), lineWidth: 1.0))
        }else{
            Text(title)
                .frame(width: 150, height: 30)
                .foregroundColor(Color(UIColor.label))
               // .background(Color(UIColor.secondarySystemBackground))
                .overlay(Capsule()
                    .stroke(Color(.gray), lineWidth: 1.0))
        }
        
    }
}



struct AlartView:View{
    @Binding var isAlart: Bool
    @Binding var isOK: Bool
    let message: String
    
    var body: some View{
        VStack {
//                    Image(systemName: "ladybug")
//                        .resizable().frame(width: 50, height: 50)
//                        .padding(.top, 10)
                        //.foregroundColor(Color(alert.title))
                    Spacer()
                    Text(message).foregroundColor(Color.white)
                    Spacer()
                    Divider()
                    HStack {
                        Button("OK") {
                            isAlart.toggle()
                            isOK = true
                        }.foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width/2, height: 40)
                        Spacer()
                        
                        Button("Cansel") {
                            isAlart.toggle()
                        }.foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width/2, height: 40)
                        //: BUTTON
//                        .frame(width: UIScreen.main.bounds.width, height: 40)
//                        .foregroundColor(.white)
                    }//: HSTACK
                }//: VSTAC
                .frame(width: UIScreen.main.bounds.width-50, height: 150)
                .background(Color.gray.opacity(0.9))
                .cornerRadius(12)
                .clipped()
                
            }
    }


struct CompButton_Previews: PreviewProvider {
    @State static var aa = false
    @State static var bb = false
    static var cc = "aaaaa"
    static var previews: some View {
        VStack{
            Buttons()
            TuikaButton()
            LabelButton()
            PeriodButton(period: "aaa")
            FavoriteButton(title: "aaaaaaaaaaaaaaaaaa")
            AlartView(isAlart: $aa, isOK: $bb, message: cc)
        }
    }
}
