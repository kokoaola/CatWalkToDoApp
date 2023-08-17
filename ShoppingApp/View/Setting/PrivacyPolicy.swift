//
//  Privacy.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//


import SwiftUI
import WebKit


///ウェブ上のプライバシーポリシーを表示する
struct PrivacyPolicyView: UIViewRepresentable {
    ///URL
    var urlString = "https://kokoaola.github.io/privacyPolicy/privacyToDo.html"
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}


struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PrivacyPolicyView()
                .environment(\.locale, Locale(identifier:"en"))
            PrivacyPolicyView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
