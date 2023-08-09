//
//  Model.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/27.
//

import Foundation

///Firestoreに保存するカスタムデータタイプ
struct ItemDataType: Identifiable {
    public var id: String
    public var title: String
    public var label: Int16
    public var indexedLabel: Dictionary<String, Int> = ["label": 0, "index": 0]
    public var checked: Bool
    public var finished: Bool
    public var timestamp: Date
}
