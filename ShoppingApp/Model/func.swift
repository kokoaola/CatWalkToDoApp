//
//  func.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/10/02.
//

import Foundation
import CoreData
import SwiftUI

enum Team{
    case day, week, month, year
}

///過去のデータ閲覧用関数、押されたボタンに応じて日付を変更して返す
func makePlusOrMinusDate(oldDay: Date, term: Team, plusOrMinus: Bool) -> Date{
    let cal = Calendar(identifier: .gregorian)
    var num = 1
    
    switch term{
    case .day:
        if !plusOrMinus { num = -1 }
        return cal.date(byAdding: .day, value: num, to: oldDay)!
        
    case .week:
        if plusOrMinus{ num = 7 }else{ num = -7 }
        return cal.date(byAdding: .day, value: num, to: oldDay)!
        
    case .month:
        if !plusOrMinus { num = -1 }
        return cal.date(byAdding: .month, value: num, to: oldDay)!
        
    case .year:
        if !plusOrMinus { num = -1 }
        return cal.date(byAdding: .year, value: num, to: oldDay)!
    }
}

///指定した期間の日付を計算して文字列で返すクラス
func makeStringTeam(oldDay: Date, term: Team) -> String{
    //データフォーマットの初期設定
    let df = DateFormatter()
    let cal = Calendar(identifier: .gregorian)
    df.locale = Locale(identifier: "ja-Jp")
    df.dateFormat = "M月d日(E)"
    let comp = cal.dateComponents([.year, .month], from: oldDay)
    
    switch term{
    case .day:
        return String(df.string(from: oldDay))
        
        //週の最初と最後を返す
    case .week:
        let weekday = Calendar.current.component(.weekday, from: oldDay)
        var numMonday = 0
        var numSunday = 0
        
        if weekday == 1{
            numMonday = 6
            numSunday = 0
        }else{
            numMonday = weekday - 2
            numSunday = 8 - weekday
        }
        
        let monday = cal.date(byAdding: .day, value: -numMonday, to: oldDay)!
        let sunday = cal.date(byAdding: .day, value: +numSunday, to: oldDay)!
        return "\(String(df.string(from: monday)))~\(String(df.string(from: sunday)))"
        
        //月の最初と最後を返す
    case .month:
        let firstDay = cal.date(from: DateComponents(year: comp.year, month: comp.month, day: 1))!
        let lastDay = cal.date(from: DateComponents(year: comp.year, month: (comp.month ?? 1) + 1, day: 0))!
        return "\(String(df.string(from: firstDay)))~\(String(df.string(from: lastDay)))"
        
        //年の最初と最後を返す
    case .year:
        let date1 = cal.date(from: DateComponents(year: comp.year, month: 1, day: 1))!
        let date2 = cal.date(from: DateComponents(year: comp.year, month: 12, day: 31))!
        return "\(String(df.string(from: date1)))~\(String(df.string(from: date2)))"

    }
}



///指定した期間の日付の最初と最後を計算して配列にして返すクラス

func makeTeamArray(day: Date, term: Team) -> [Date]{
    let cal = Calendar(identifier: .gregorian)
    
    switch term{
    case .day:
        return [Date()]
        
        //週の最初と最後を返す
    case .week:
        let weekday = Calendar.current.component(.weekday, from: day)
        var numMonday = 0
        var numSunday = 0
        
        if weekday == 1{
            numMonday = 6
            numSunday = 0
        }else{
            numMonday = weekday - 2
            numSunday = 8 - weekday
        }
        
        let monday = cal.date(byAdding: .day, value: -numMonday, to: day)!
        let sunday = cal.date(byAdding: .day, value: +numSunday, to: day)!
        return [monday, sunday]
        
        //月の最初と最後を返す
    case .month:
        let comp = cal.dateComponents([.year, .month], from: day)
        let firstDay = cal.date(from: DateComponents(year: comp.year, month: comp.month, day: 1))!
        let lastDay = cal.date(from: DateComponents(year: comp.year, month: (comp.month ?? 1) + 1, day: 0))!
        return [firstDay, lastDay]
        
        //年の最初と最後を返す
    case .year:
        let comp = cal.dateComponents([.year, .month], from: day)
        let firstDay = cal.date(from: DateComponents(year: comp.year, month: 1, day: 1))!
        let lastDay = cal.date(from: DateComponents(year: comp.year, month: 12, day: 31))!
        return [firstDay, lastDay]
        
    }
    
}


///辞書データのキーだけを配列にする関数
func returnArray(dic: Dictionary<String, Int>) -> [String]{
    
    let newDic = dic.sorted(by: { $0.value > $1.value})
    var array1 :[String] = []
    for i in newDic{
        array1.append(i.key)
    }
    return array1
}


//func omakeDic(dateArray: [Date]) -> Dictionary<String, Int>{
//    //データフォーマットの初期設定
//    let df = DateFormatter()
//    df.locale = Locale(identifier: "ja_Jp")
//    let cal = Calendar(identifier: .gregorian)
//    
//    //取り出したいデータ期間の初日と最終日の日付を作る
//    let formatedDay1 = cal.date(bySettingHour: 0, minute: 0, second: 0, of: dateArray[0])!
//    let formatedDay2 = cal.date(bySettingHour: 23, minute: 59, second: 59, of: dateArray[1])!
//    
//    //期間内のすべてのデータを取り出す
//    let persistenceController = PersistenceController.shared
//    let context = persistenceController.container.viewContext
//    let request = NSFetchRequest<Entity>(entityName: "Entity")
//    let predicate = NSPredicate(format: "(%@ <= timestamp) AND (timestamp <= %@)", dateToNSDate(date: formatedDay1), dateToNSDate(date: formatedDay2))
//    request.predicate = predicate
//    let allData = try? context.fetch(request)
//    
//    //アイテム名のみを格納した配列を生成
//    var allTitleArray : [String] = []
//    for item in allData!{
//        if !allTitleArray.contains(String(item.title!)){
//            allTitleArray.append(String(item.title!))
//        }
//    }
//
//    //アイテム名から辞書を生成（キー：アイテム名、バリュー：購入回数）
//    var dic: Dictionary<String, Int> = [:]
//    var counter = 0
//    for array in allTitleArray {
//        for task in allData!{
//            if task.title == array{
//                counter += 1
//            }
//        }
//        dic[array] = counter
//        counter = 0
//    }
//    return dic
//}

//func makeItemArray(array:FetchedResults<Entity>) -> [String]{
//    //アイテム名のみを格納した配列を生成
//    var allTitleArray : [String] = []
//    for item in array{
//        if !allTitleArray.contains(String(item.title!)){
//            allTitleArray.append(String(item.title!))
//        }
//    }
//    return allTitleArray
//}



///文字列を日付Dateに変換する関数
func stringToDate(dateValue: String) -> Date{
    let df = DateFormatter()
    df.calendar = Calendar(identifier: .gregorian)
    df.dateFormat = "yyyy/MM/dd/HH/mm"
    return df.date(from: dateValue) ?? Date()
}

///日付Dateを文字列に変換する関数
func dateToString(dateValue: Date) -> String{
    let df = DateFormatter()
    df.dateFormat = "yyyy/MM/dd/HH/mm"
    df.locale = Locale(identifier: "ja-Jp")
    return String(df.string(from: dateValue))
}


///日付DateをNSDateに変換する関数
func dateToNSDate(date: Date) -> NSDate{
    let df = DateFormatter()
    let date2 = dateToString(dateValue: date)
    df.dateFormat = "yyyy/MM/dd/HH/mm"
    let con = df.date(from: date2)
    return con! as NSDate
}

