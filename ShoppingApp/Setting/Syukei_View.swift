//
//  Syuukei.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/10/02.
//

import SwiftUI

struct Syukei_View: View {
    //コアデータ用のコード
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Entity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.timestamp, ascending: true)],
        //ラベルが０、未完了のものだけ抽出
        predicate: NSPredicate(format: "favorite == %@ And finished == %@", NSNumber(value: true), NSNumber(value: true)), animation: .default
    )private var items: FetchedResults<Entity>
    
    
    @State var kikan = Team.week
    @State var theDate = Date()
    
    
    var body: some View {

        
        NavigationView{
            VStack{
                //期間選択用のボタン
                HStack(spacing: 20){
                    Button(action:{
                        kikan = .week
                    }){PeriodButton(period: "週")}
                    Button(action:{
                        kikan = .month
                    }){PeriodButton(period: "月")}
                    Button(action:{kikan = .year
                    }){PeriodButton(period: "年")}
                }.padding()
                
                
                ZStack{
                    Text(makeStringTeam(oldDay: theDate, term: kikan))
                        .onTapGesture {
                            theDate = Date()
                        }
                    
                    //日付変更ボタン
                    HStack{
                        //表示中の期間に応じて日付を戻る
                        Button(action: {
                            theDate = makePlusOrMinusDate(oldDay: theDate, term: kikan, plusOrMinus: false)
                        }, label: {Image(systemName: "backward.fill")})
                        Spacer()
                        
                        //表示中の期間に応じて日付を進む
                        Button(action: {
                            theDate = makePlusOrMinusDate(oldDay: theDate, term: kikan, plusOrMinus: true)
                        }, label: {Image(systemName: "forward.fill")})
                        
                    }.padding(.horizontal)
                        .font(.title)
                        .onAppear{}
                        .foregroundColor(.gray)
                        .monospacedDigit()
                }
                
                //買い物リスト本体
                List{
                    ForEach(returnArray(dic: omakeDic(dateArray: makeTeamArray(day: theDate, term: kikan))), id: \.self) { item in
                        HStack{
                            Text("\(item)")
                            Spacer()
                            Text("\(omakeDic(dateArray: makeTeamArray(day: theDate, term: kikan))[item]!)回")
                        }
                    }
                }
            }
        }
    }
}


struct Syukei_View_Previews: PreviewProvider {
    static var previews: some View {
        Syukei_View()
    }
}
