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

    
    
    func whiteText() -> some View {
        self.foregroundColor(.white)
    }
}


