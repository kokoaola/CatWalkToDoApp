//
//  Store.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/13.
//

import Foundation


///.environmentObjectを使用してアプリケーション全体で認識するグローバルクラス
/*
これ必要
@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Store())
        }
    }
}*/

class Store: ObservableObject {
    ///グローバルオブジェクト
    @Published var selectedUnit: TemperatureUnit = .kelvin
    @Published var weatherList: [WeatherViewModel] = [WeatherViewModel]()
    
    init(){
        selectedUnit = UserDefaults.standard.unit
    }
    
    ///都市名を配列に追加する関数
    func addWeather(_ weather: WeatherViewModel) {
        weatherList.append(weather)
    }
}
