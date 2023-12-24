//
//  Contact.swift
//  Challenge100days
//
//  Created by koala panda on 2023/05/06.
//

import SwiftUI
import WebKit


///インデックスの名前設定用のビュー
struct EditIndexSettingScreen: View {
    ///インデックスラベルをアプリ内で共有する環境変数
    @EnvironmentObject var store: Store
    
    ///ページ破棄用のdismiss
    @Environment(\.dismiss) private var dismiss
    
    ///３つのテキストフィールドそれぞれの値を格納する変数
    @State var newName0 = ""
    @State var newName1 = ""
    @State var newName2 = ""
    
    
    
    var body: some View {
        VStack(spacing: 30.0){
            
            Spacer()
            
            Group{
                HStack{
                    Text("Label1")
                    TextField("\(store.indexLabel0)", text: $newName0,
                              prompt: Text("\(store.indexLabel0)"))}
                
                HStack{
                    Text("Label2")
                    TextField("\(store.indexLabel1)", text: $newName1,
                              prompt: Text("\(store.indexLabel1)"))}
                
                HStack{
                    Text("Label3")
                    TextField("\(store.indexLabel2)", text: $newName2,
                              prompt: Text("\(store.indexLabel2)"))}
            }.padding(.horizontal)
            
            ///保存ボタンが押されたらラベルの変更をユーザーデフォルトに保存
            Button(action: {
                if store.indexLabel0 != newName0{
                    store.indexLabel0 = newName0
                }
                
                if store.indexLabel1 != newName1{
                    store.indexLabel1 = newName1
                }
                
                if store.indexLabel2 != newName2{
                    store.indexLabel2 = newName2
                }
                dismiss()
            }, label: {
                SaveButton() //保存ボタンは別ファイル
            })
            .padding(.top, 40.0)
            
            Spacer()
            Spacer()
            
        }.textFieldStyle(.roundedBorder)
        
        ///ビュー作成時にテキストフィールドに初期値を入力しておく
            .onAppear(){
                newName0 = store.indexLabel0
                newName1 = store.indexLabel1
                newName2 = store.indexLabel2
            }
    }
}


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

