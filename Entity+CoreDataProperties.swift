//
//  Entity+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by koala panda on 2022/09/29.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var label: Int16
    @NSManaged public var favorite: Bool
    @NSManaged public var checked: Bool
    @NSManaged public var finished: Bool

}

extension Entity : Identifiable {

}
