//
//  View+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation
import SwiftUI

extension View {
    ///自身をナビゲーションビューに入れるextension
    func embedInNavigationView() -> some View {
        return NavigationView { self }
    }
    
    ///カスタマイズしたテキストエディットのスタイルのextension
    func customTextEditStyle() -> some View {
        self
            .foregroundColor(Color(UIColor.black))
            .tint(.black)
            .scrollContentBackground(Visibility.hidden)
            .background(.gray.opacity(0.5))
            .border(.gray, width: 1)
            .frame(height: 80)
    }
    
    ///アクセシビリティに関する項目を追加するextension
    func editAccessibility(label: String? = nil, hint: String? = nil, removeTraits: AccessibilityTraits? = nil, addTraits: AccessibilityTraits? = nil) -> some View {
        self
            .modifier(AccessibilityModifier(label: label, hint: hint, removeTraits: removeTraits, addTraits: addTraits))
    }
    
    
    ///単価計算用にカスタマイズしたテキストエディットのスタイルのextension
    func unitCalTextField() -> some View {
        self
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
            .frame(width: AppStyles.screenWidth / 2)
            .textFieldStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.white)
    }
}


///アクセシビリティに関する項目を追加するAccessibilityModifier
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
