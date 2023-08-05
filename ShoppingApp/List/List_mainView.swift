//
//  List1.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
///買い物リストのメインのビュー


struct List_mainView: View {
    //    @Environment(\.managedObjectContext) private var viewContext
    //    @FetchRequest(
    //        entity: Entity.entity(),
    //        sortDescriptors: [],
    //        //ラベルが０、未完了+チェックがついたのものだけ完了用に抽出
    //        predicate: NSPredicate(format: "finished == %@ And checked == %@", NSNumber(value: false), NSNumber(value: true))
    //    )private var checkedItems: FetchedResults<Entity>
    
    //項目追加シート用のBool
    @State var isSheet = false
    
    //お気に入り多すぎアラート用
    @State var isAlart = false
    @State var isOK = false
    
    //ラベル選択用のプロパティ
    @State var selection = 0
    
    //買い物完了ボタンを押した時のアラート用のプロパティ
    @State var showAlart = false
    
    //ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
    
    //ラベル名を格納するための配列
    @State var labelArray:[String] = ["" , "", ""]
    
    @ObservedObject var itemVM = ItemViewModel()
    
    
    var body: some View {
        ZStack{
            VStack {
                //左上のプラスの追加ボタン
                HStack{
                    Spacer()
                    Button(action: {
                        isSheet = true
                    }, label: {Image(systemName: "plus")})}
                .padding()
                
                
                //上に表示されるラベル
                
                HStack{
                    ForEach(0 ..< 3) {num in
                        //表示中だけラベルの色を変える
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: UIScreen.main.bounds.width / 3.5, height: 30)
                            .overlay(Text("\(labelArray[num])")
                                .foregroundColor(Color(selection == num ? UIColor.label : .gray)))
                            .opacity(selection == num ? 1.0 : 0.5)
                            .onTapGesture {selection = num}
                    }
                }
                
                //買い物リストの中身のビュー
                TabView(selection: $selection) {
                    ShoppingList1(isAlart: $isAlart, filterdList: $itemVM.filterdList0)
                        .tag(0)
                    ShoppingList1(isAlart: $isAlart, filterdList: $itemVM.filterdList1)
                        .tag(1)
                    ShoppingList1(isAlart: $isAlart, filterdList: $itemVM.filterdList2)
                        .tag(2)
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .environmentObject(itemVM)

            }
            
            VStack{
                Spacer()
                //買い物完了ボタン
                Button(action: {
                    showAlart.toggle()
                }, label: {
                    Buttons()
                    //ボタン本体のデザインは別のファイル
                }).padding(.bottom, 30)
                //買うものの新規追加用のシート
                    .sheet(isPresented: $isSheet, content: {AddNewItem().environmentObject(itemVM)})
            }                //買い物完了ボタンが押された後の確認アラート
            .alert(isPresented: $showAlart){
                Alert(title: Text("買い物完了"),
                      message: Text("チェックした項目を削除して\n買い物を完了にしますか？"),
                      //OKならチェックした項目をリストから削除（未搭載）
                      primaryButton: .default(Text("OK"), action: {
                    itemVM.deleteTask()
                }),
                      secondaryButton: .cancel(Text("Cansel"), action:{}))
            }
            
            .onAppear(){
                labelArray = [label0, label1, label2]
            }
            if isAlart{
                AlartView(isAlart: $isAlart, isOK: $isOK, message: "お気に入り登録できるのは２０個までです。")
            }
            
            
        }
    }
}

struct List_mainView_Previews: PreviewProvider {
    static var previews: some View {
        List_mainView()
            .environmentObject(ItemViewModel())
    }
}
