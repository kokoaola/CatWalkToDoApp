//
//  CompButton.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI
///ボタンのデザインたち



///猫の追加ボタン
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

///買い物リストの要素追加ボタン
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
            SaveButton()
            PeriodButton(period: "aaa")
            FavoriteButton(title: "aaaaaaaaaaaaaaaaaa")
            AlartView(isAlart: $aa, isOK: $bb, message: cc)
        }
    }
}

