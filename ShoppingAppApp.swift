//
//  ShoppingAppApp.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/27.
//

import SwiftUI
import CoreData

@main
struct ShoppingAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                //.environmentObject(ShareData())
        }
    }
//    ///これ書いたらエラー消えた（何かは不明）
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Entity")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
}

///これ書いたらエラー消えた（何かは不明）
//lazy var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "Entity")
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//        if let error = error as NSError? {
//            fatalError("Unresolved error \(error), \(error.userInfo)")
//        }
//    })
//    return container
//}()
