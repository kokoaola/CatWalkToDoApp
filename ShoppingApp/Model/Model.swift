//
//  Model.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import Foundation

struct ItemDataType: Identifiable {
    public var id: String
    public var title: String
    public var label: Int16
    public var favorite: Bool
    public var checked: Bool
    public var finished: Bool
    public var timestamp: Date
}
