//
//  List1.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
///買い物リストのメインのビュー


struct List_mainView: View {
    
    ///項目追加シート用のBool
    @State private var showAddNewItemSheet = false
    
    ///ラベル選択用のプロパティ
    @State var selection = 0
    
    ///買い物完了ボタンを押した時のアラート用のプロパティ
    @State var showCompleteTaskAlert = false
    
    ///ユーザーデフォルトから３つのラベルデータを取得
    @AppStorage("label0") var label0 = "ラベル１"
    @AppStorage("label1") var label1 = "ラベル２"
    @AppStorage("label2") var label2 = "ラベル３"
    
    ///ラベル名を格納するための配列(ForEachで使用するため)
    @State var labelArray:[String] = ["" , "", ""]
    
    ///itemViewModelのための変数
    @ObservedObject var itemVM = ItemViewModel()
    
    
    var body: some View {
        NavigationView{
            //下部の完了ボタンを配置するためのZStack
            ZStack{
                VStack {
                    //上に表示される３つのラベル
                    HStack{
                        ForEach(0 ..< 3) {num in

                                //表示中だけラベルの色を変える
                                CustomShape()
//                                    .cornerRadius(15)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 3.5, height: 60)
                                    .onTapGesture {
                                        selection = num
                                    }
                                
//                                Color.white.frame(width: UIScreen.main.bounds.width / 3.5, height: 30)
//
//                                    .padding(.top, -20)
//                                    .offset(y:-15)
                            
                            .opacity(selection == num ? 1.0 : 0.4)
                            .overlay(Text("\(labelArray[num])")
                                .font(.callout)
                                .foregroundColor(Color(selection == num ? UIColor.label : .gray)))
                            
//                            .offset(y: 20)
//                            .background(.red)
//                            .cornerRadius(15)
                            
                        }
                    }
                    .padding(.bottom, -20)
                    .frame(height: 60)
                    
                    //買い物リストの中身は選択中のタブによって切り替える
                    TabView(selection: $selection) {
                        ListView(filterdList: $itemVM.label0Item, labelNum: $selection)
                            .tag(0)
                        ListView(filterdList: $itemVM.label1Item, labelNum: $selection)
                            .tag(1)
                        ListView(filterdList: $itemVM.label2Item, labelNum: $selection)
                            .tag(2)
                    }
                    
                    .background(.white)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .environmentObject(itemVM)
                    
                }.padding(.top, -10)
                
                
                VStack{
                    Spacer()
                    //追加ボタン
                    Button(action: {
                        showAddNewItemSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(AppSetting.mainColor2)
                            .cornerRadius(30)
                            .padding()
                    }
                }
                
                
                //タスク新規追加用のシート
                .sheet(isPresented: $showAddNewItemSheet, content: {
                    AddNewItem(newLabelNum: selection)
                        .environmentObject(itemVM)
                })
                
                //買い物完了ボタンが押された後の確認アラート
                .alert(isPresented: $showCompleteTaskAlert){
                    Alert(title: Text("タスクの完了"),
                          message: Text("チェックした項目を削除しますか？"),
                          //OKならチェックした項目をリストから削除
                          primaryButton: .default(Text("OK"), action: {
                        itemVM.completeTask(labelNum: selection)
                        
                    }),
                          secondaryButton: .cancel(Text("Cansel"), action:{}))
                }
                
                //ビュー生成時にラベルを配列に追加する
                .onAppear(){
                    labelArray = [label0, label1, label2]
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing))
//            .navigationBarItems(trailing: EditButton())
            
            //削除ボタン
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Spacer()
                    
                    Button(action: {
                        showCompleteTaskAlert = true
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                    }
                }
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


struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        // 左下の角を開始点として
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // 左上へ移動
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 10))
        path.addQuadCurve(to: CGPoint(x: rect.minX + 10, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        
        // 右上へ移動
        path.addLine(to: CGPoint(x: rect.maxX - 10, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 10), control: CGPoint(x: rect.maxX, y: rect.minY))
        
        // 右下へ移動
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // 下の辺は描画しないため、左下へ直接戻る
//        path.addLine(to: CGPoint(x: rect.minX - 1.5, y: rect.maxY))

        
        return path
    }
}
