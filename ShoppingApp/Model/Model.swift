//
//  Model.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import Foundation
import CoreData


///// プレビュー用保存関数
func save() {
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    
//    /// Entityテーブル全消去
//    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequest.entity = Entity.entity()
//    let students = try? context.fetch(fetchRequest) as? [Entity]
//    for student in students! {
//        context.delete(student)
//    }
    
    /// Entityテーブル登録
    let newStudent = Entity(context: context)
    newStudent.label = 0
    newStudent.title = "テスト０"
    newStudent.timestamp = Date()
    newStudent.favorite = true
    newStudent.checked = true
    newStudent.finished = false
    
    let newStudent2 = Entity(context: context)
    newStudent2.label = 1
    newStudent2.title = "テスト1"
    newStudent2.timestamp = Date()
    newStudent2.favorite = true
    newStudent2.checked = true
    newStudent2.finished = false
    
    let newStudent3 = Entity(context: context)
    newStudent3.label = 2
    newStudent3.title = "テスト2"
    newStudent3.timestamp = Date()
    newStudent3.favorite = true
    newStudent3.checked = true
    newStudent3.finished = false
    
    let newStudent4 = Entity(context: context)
    newStudent4.label = 0
    newStudent4.title = "テスト０"
    newStudent4.timestamp = Date()
    newStudent4.favorite = false
    newStudent4.checked = false
    newStudent4.finished = false
    
    let newStudent5 = Entity(context: context)
    newStudent5.label = 1
    newStudent5.title = "テスト1"
    newStudent5.timestamp = Date()
    newStudent5.favorite = false
    newStudent5.checked = false
    newStudent5.finished = false
    
    let newStudent6 = Entity(context: context)
    newStudent6.label = 2
    newStudent6.title = "テスト2"
    newStudent6.timestamp = Date()
    newStudent6.favorite = false
    newStudent6.checked = false
    newStudent6.finished = false
    
    /// コミット
    try? context.save()
}

/////全件表示関数
//func getAllData() -> [Entity]{
//    //すべてのデータを取り出す
//    let persistenceController = PersistenceController.shared
//    let context = persistenceController.container.viewContext
//    let request = NSFetchRequest<Entity>(entityName: "Entity")
//    //request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
//
//    do{let tasks = try context.fetch(request)
//        return tasks
//    }catch{
//        fatalError()
//    }
//}
