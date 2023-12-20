//
//  List1.swift
//  Kaimono
//
//  Created by koala panda on 2022/09/26.
//

import SwiftUI
///買い物リストのメインのビュー


struct ListScreen: View {
    ///ViewModelのための変数
    @ObservedObject var listVM = ListViewModel()
    @EnvironmentObject var store: Store
    
    ///タスク追加シート管理用のフラグ
    @State private var showAddNewItemSheet = false
    
    ///ラベル選択用のプロパティ
    @State var selection = 0
    
    ///買い物完了ボタンを押した時のアラート用のプロパティ
    @State var showCompleteTaskAlert = false
    
    ///ラベル編集アラート管理用のフラグ
    @State var isEdit = false
    
    ///猫動かす用
    //    @State var goRight: Bool = false
    //    @State var isFlip: Bool = false
    //    @State var isMoving: Bool = false
    
    
    var body: some View {
        
        ///インデックスのサイズ
        let indexWidth = AppSetting.screenWidth / 3.5
        let indexHeight = 60.0
        
        ZStack{//インデックス長押し時のアラート表示のためのZStack
            
            ZStack{//下部の追加ボタンを配置するためのZStack
                
                ///ToDoリストとラベルの表示
                VStack {
                    
                    //インデックスと動く猫ちゃんを並べたHStack
                    HStack{
                        //猫のアニメーション
                        CatView(listVM: listVM)
                        
                        //上に表示される３つのインデックス
                        ForEach(0 ..< 3) {num in
                            IndexShape()
                                .foregroundColor(.white)
                                .frame(width: indexWidth, height: indexHeight)
                                .shadow(color:.black.opacity(selection == num ? 0.5 : 0.0001), radius: 3, x: 3, y: 3)
                            //ラベルの文字
                                .overlay(Text("\(store.getIndexArray()[num])")
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
                                    isEdit = true
                                }
                                .accessibilityAddTraits(selection == num ? [.isSelected] : [])
                                .accessibilityLabel("\(store.getIndexArray()[num]), tab")
                        }
                    }//HStackここまで
                    .offset(x: -UIScreen.main.bounds.width / 18.5)
                    .padding(.bottom, -20)
                    .frame(height: 60)
                    
                    
                    //買い物リストの中身(選択中のタブによって切り替える)
                    TabView(selection: $selection) {
                        ListView(listVM: listVM, filterdList: $listVM.label0Item, labelNum: $selection)
                            .tag(0)
                        ListView(listVM: listVM, filterdList: $listVM.label1Item, labelNum: $selection)
                            .tag(1)
                        ListView(listVM: listVM, filterdList: $listVM.label2Item, labelNum: $selection)
                            .tag(2)
                    }
                    .background(.white)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }//VStackここまで
                .padding(.top, 5)
                
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
                }//VStackここまで
                .ignoresSafeArea(.keyboard, edges: .bottom)
                //編集用アラート表示中はタップ無効
                .disabled(isEdit)
                .accessibilityHidden(isEdit)
                
                
                
                
                //タスク新規追加用のシート
                .sheet(isPresented: $showAddNewItemSheet, content: {
                    AddNewItemScreen(newLabelNum: $selection)
                })
                
                //ゴミ箱ボタンが押された後の確認アラート
                .alert(isPresented: $showCompleteTaskAlert){
                    Alert(title: Text("Task Completion"),
                          message: Text("Do you want to delete the checked items?"),
                          //OKならチェックした項目をリストから削除
                          primaryButton: .destructive(Text("Delete"), action: {
                        listVM.deleteCompletedTask(labelNum: selection)
                        
                    }),
                          secondaryButton: .cancel(Text("Cancel"), action:{}))
                }
                
                .onDisappear(){
                    isEdit = false
                }
                
            }//ZStackここまで
            .background(LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing))
            //キーボードによるビューの押し上げをなくす
            .ignoresSafeArea(.keyboard,edges: .all)
            
            //右上のゴミ箱マーク削除ボタン
            .toolbar {
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCompleteTaskAlert.toggle()
                    }) {
                        TrashButton()
                    }
                    //VoiceOver
                    .accessibilityLabel("Delete")
                    .accessibilityHint("Remove all completed tasks from the list")
                    .accessibilityAddTraits(.isButton)
                }
            }
            
            .embedInNavigationView()
            .opacity(isEdit ? 0.3:1.0)
            
            
            
            ///ラベル名がロングタップされたら編集用ウィンドウを表示
            if isEdit{
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing).ignoresSafeArea().opacity(0.5)
                EditIndexAlertScreen(showAlert: $isEdit, labelNum: selection, editText: store.getIndexArray()[selection])
                    .environmentObject(store)
            }
        }
        
    }
}
