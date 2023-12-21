//
//  View+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation
import SwiftUI

extension View {
    //自身をナビゲーションビューに入れる
    func embedInNavigationView() -> some View {
        return NavigationView { self }
    }
    
    //カスタマイズしたテキストエディットのスタイル
    func customTextEditStyle() -> some View {
        self.modifier(TextEditModifier())
    }
    
    //アクセシビリティを追加する
    func editAccessibility(label: String? = nil, hint: String? = nil, removeTraits: AccessibilityTraits? = nil, addTraits: AccessibilityTraits? = nil) -> some View {
        self
            .modifier(AccessibilityModifier(label: label, hint: hint, removeTraits: removeTraits, addTraits: addTraits))
    }
}


private struct AccessibilityModifier: ViewModifier {
    let label: String?
    let hint: String?
    let removeTraits: AccessibilityTraits?
    let addTraits: AccessibilityTraits?
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(LocalizedStringKey(label ?? ""))
            .accessibilityHint(LocalizedStringKey(hint ?? ""))
            .accessibilityAddTraits(addTraits ?? AccessibilityTraits())
            .accessibilityRemoveTraits(removeTraits ?? AccessibilityTraits())
    }
}


private struct TextEditModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(UIColor.black))
            .tint(.black)
            .scrollContentBackground(Visibility.hidden)
            .background(.gray.opacity(0.5))
            .border(.gray, width: 1)
            .frame(height: 80)
    }
}