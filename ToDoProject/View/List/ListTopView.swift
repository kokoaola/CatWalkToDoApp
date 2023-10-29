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
    @AppStorage("label0") var label0 = "1"
    @AppStorage("label1") var label1 = "2"
    @AppStorage("label2") var label2 = "3"
    
    ///ラベル名を格納するための配列(ForEachで使用するため)
    @State var labelArray:[String] = ["" , "", ""]
    
    ///itemViewModelのための変数
    @ObservedObject var itemVM = ItemViewModel()
    
    ///猫動かす用
    @State private var goRight: Bool = false
    @State private var flip: Bool = true
    @State private var startMoving: Bool = false
    
    ///ラベル編集アラート表示用フラグ
    @State var isEdit = false
    
    
    var body: some View {
        let catSize = UIScreen.main.bounds.width / 6
        
        
        ZStack{
            NavigationView{
                //下部の完了ボタンを配置するためのZStack
                ZStack{
                    
                    ///ToDoリストとラベルの表示
                    VStack {
                        
                        //インデックスと動く猫ちゃんを並べたHStack
                        HStack{
                            //猫ちゃん
                            LottieView(filename: "cat", loop: .loop, shouldFlip: $flip, startAnimation: $startMoving)
                                .frame(width: catSize)
                                .position(x: goRight ? UIScreen.main.bounds.width + catSize * 2 / 2 : 0 - catSize, y: 40)
                                .animation(.linear(duration: 7.0), value: goRight)
                                .shadow(color:.black.opacity(0.5), radius: 3, x: 3, y: 3)
                                .zIndex(1.0)
                            //VoiceOver用
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("Walking cat")
                                .accessibilityAddTraits(.isImage)
                            
                            
                            //上に表示される３つのインデックス
                            ForEach(0 ..< 3) {num in
                                IndexLabel()
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width / 3.5, height: 60)
                                    .shadow(color:.black.opacity(selection == num ? 0.5 : 0.0001), radius: 3, x: 3, y: 3)
                                //ラベルの文字
                                    .overlay(Text("\(labelArray[num])")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(selection == num ? .black : .gray)))
                                //表示中だけラベルの色を濃くする
                                    .opacity(selection == num ? 1.0 : 0.6)
                                //タブは猫ちゃんの前後になるように表示
                                    .zIndex(selection == num ? 1.0 : -1.0)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selection = num
                                    }
                                //ラベル名長押しで編集用ウィンドウ表示
                                    .onLongPressGesture {
                                        selection = num
//                                        withAnimation {
                                            isEdit = true
//                                        }
                                    }
                                    .accessibilityAddTraits(selection == num ? [.isSelected] : [])
                                    .accessibilityLabel("\(labelArray[num]), tab")
                            }
                        }
                        .offset(x: -UIScreen.main.bounds.width / 18.5)
                        .padding(.bottom, -20)
                        .frame(height: 60)
                        
                        
                        //買い物リストの中身(選択中のタブによって切り替える)
                        TabView(selection: $selection) {
                            ListView(filterdList: $itemVM.label0Item, labelNum: $selection, goRight: $goRight, isFlip: $flip, isMoving: $startMoving)
                                .tag(0)
                            ListView(filterdList: $itemVM.label1Item, labelNum: $selection, goRight: $goRight, isFlip: $flip, isMoving: $startMoving)
                                .tag(1)
                            ListView(filterdList: $itemVM.label2Item, labelNum: $selection, goRight: $goRight, isFlip: $flip, isMoving: $startMoving)
                                .tag(2)
                        }
                        .background(.white)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .environmentObject(itemVM)
                        
                    }.padding(.top, 5)
                    //編集用アラート表示中はタップ無効
                        .disabled(isEdit)
                        .accessibilityHidden(isEdit)
                    
                    
                    ///＋ボタン用のセクション
                    VStack{
                        Spacer()
                        //追加ボタン
                        Button(action: {
                            showAddNewItemSheet = true
                        }) {
                            CatAddButton(color: AppSetting.mainColor2)
                        }
                        
                        //VoiceOver
                        .contentShape(Rectangle())
                        .accessibilityLabel("Add new task")
                        .accessibilityAddTraits(.isButton)
                        .padding(5)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    //編集用アラート表示中はタップ無効
                    .disabled(isEdit)
                    .accessibilityHidden(isEdit)
                    
                    
                    
                    
                    //タスク新規追加用のシート
                    .sheet(isPresented: $showAddNewItemSheet, content: {
                        AddNewItem(newLabelNum: selection)
                            .environmentObject(itemVM)
                    })
                    
                    //買い物完了ボタンが押された後の確認アラート
                    .alert(isPresented: $showCompleteTaskAlert){
                        Alert(title: Text("Task Completion"),
                              message: Text("Do you want to delete the checked items?"),
                              //OKならチェックした項目をリストから削除
                              primaryButton: .destructive(Text("Delete"), action: {
                            itemVM.completeTask(labelNum: selection)
                            
                        }),
                              secondaryButton: .cancel(Text("Cancel"), action:{}))
                    }
                    
                    //ビュー生成時にラベルを配列に追加する
                    .onAppear(){
                        labelArray = [label0, label1, label2]
                    }
                    .onDisappear(){
                        isEdit = false
                    }
                    
                }
                .background(LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing))
                //キーボードによるビューの押し上げをなくす
                .ignoresSafeArea(.keyboard,edges: .all)
                
                //右上のゴミ箱マーク削除ボタン
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            showCompleteTaskAlert.toggle()
                        }) {
                            Image(systemName: "trash.square.fill")
                                .symbolRenderingMode(SymbolRenderingMode.palette)
                                .font(.largeTitle)
                                .foregroundStyle(.white, .gray)
                                .shadow(color:.black.opacity(0.5), radius: 3, x: 3, y: 3
                                )
                        }
                        //VoiceOver
                        .accessibilityLabel("Delete")
                        .accessibilityHint("Remove all completed tasks from the list")
                        .accessibilityAddTraits(.isButton)
                    }
                }
            }.opacity(isEdit ? 0.3:1.0)
            
            
            
            ///ラベル名がロングタップされたら編集用ウィンドウを表示
            if isEdit{
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing).ignoresSafeArea().opacity(0.5)
                EditLabelWindow(showAlert: $isEdit, labelArray:$labelArray, labelNum: selection)
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
