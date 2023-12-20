//
//  Contact.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//

import SwiftUI
import WebKit


///コンタクト用のフォームをHTMLで直接表示する
struct ContactWebView: UIViewRepresentable {
    let html = """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scaleble=no" />
<style> body { font-size: 150%; } </style>
</head>
<body>

<iframe src="https://docs.google.com/forms/d/e/1FAIpQLSeagqUuA4mHe_I6x6QglZXSUIwgGwxvT23jGWFMatoJRd4SIQ/viewform?embedded=true" width="100%" height="1000" frameborder="0" marginheight="0" marginwidth="0">読み込んでいます…</iframe>

</html>
"""
    
    func makeUIView(context: Context) -> WKWebView{
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}


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

