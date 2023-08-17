//
//  Model.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import Foundation

///Firestoreに保存するカスタムデータタイプ
struct ItemDataType:Identifiable, Codable  {
    public var id: String
    public var title: String
    public var index: Int16
    public var label: Int16
    public var checked: Bool
    public var timestamp: Date
}
