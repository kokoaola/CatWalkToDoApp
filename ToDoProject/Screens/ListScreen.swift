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
    @StateObject var listVM = ListViewModel()
    @EnvironmentObject var store: Store
    
    ///買い物完了ボタンを押した時のアラート用のプロパティ
    @State var showCompleteTaskAlert = false
    ///ラベル編集アラート管理用のフラグ
    @State var isEdit = false
    
    ///タスク追加シート管理用のフラグ
    @State private var showAddNewItemSheet = false
    
    var body: some View {
        
        ZStack{//インデックス長押し時のアラート表示のためのZStack
            ZStack{//下部の追加ボタンを配置するためのZStack
                ///ToDoリストとラベルの表示
                VStack {
                    
                    //インデックスと動く猫ちゃんを並べたHStack
                    HStack{
                        ///猫のアニメーション
                        CatView(listVM: listVM)
                        
                        ///上に表示される３つのインデックス
                        ForEach(0 ..< 3) {num in
                            IndexView(num: num, selection: $listVM.selectedLabelNum, isEdit: $isEdit, index: store.getIndexArray()[num])
                        }
                    }//インデックスと動く猫ちゃんを並べたHStackここまで
                    .offset(x: -UIScreen.main.bounds.width / 18.5)
                    .padding(.bottom, -20)
                    .frame(height: 60)
                    
                    
                    ///買い物リストの中身(選択中のタブによって切り替える)
                    TabView(selection: $listVM.selectedLabelNum) {
                        ListView(listVM: listVM, filterdList: $listVM.label0Item)
                            .tag(0)
                        ListView(listVM: listVM, filterdList: $listVM.label1Item)
                            .tag(1)
                        ListView(listVM: listVM, filterdList: $listVM.label2Item)
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
                            .padding(5)
                    }
                    //VoiceOver用の設定
                    .contentShape(Rectangle())
                    .editAccessibility(label:"Add new task", addTraits: .isButton)
                    
                }//VStackここまで
                .ignoresSafeArea(.keyboard, edges: .bottom)
                //インデックス編集用アラート表示中はタップ無効
                .disabled(isEdit)
                .accessibilityHidden(isEdit)
                ///タスク新規追加用のシート
                .sheet(isPresented: $showAddNewItemSheet, content: {
                    AddNewItemScreen(newLabelNum: $listVM.selectedLabelNum)
                })
                
                ///ゴミ箱ボタンが押された後の確認アラート
                .alert(isPresented: $showCompleteTaskAlert){
                    Alert(title: Text("Task Completion"),
                          message: Text("Do you want to delete the checked items?"),
                          //OKならチェックした項目をリストから削除
                          primaryButton: .destructive(Text("Delete"), action: {
                        listVM.deleteCompletedTask(labelNum: listVM.selectedLabelNum)
                    }),
                          secondaryButton: .cancel(Text("Cancel"), action:{}))
                }
                
                ///編集アラート表示中に別のタブに遷移したら、編集アラートを非表示にする
                .onDisappear(){
                    isEdit = false
                }
            }//ZStackここまで
            
            
            .background(LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing))
            //キーボードによるビューの押し上げをなくす
            .ignoresSafeArea(.keyboard,edges: .all)
            
            ///右上のゴミ箱マーク削除ボタン
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCompleteTaskAlert.toggle()
                    }) {
                        TrashButton()
                    }
                    //VoiceOver
                    .editAccessibility(label:"Delete", hint:"Remove all completed tasks from the list", addTraits: .isButton)
                }
            }
            .embedInNavigationView()
            .opacity(isEdit ? 0.3:1.0)
            

            ///ラベル名がロングタップされたら編集用ウィンドウを表示
            if isEdit{
                LinearGradient(gradient: Gradient(colors: [AppSetting.mainColor1, AppSetting.mainColor2]), startPoint: .leading, endPoint: .trailing).ignoresSafeArea().opacity(0.5)
                EditIndexAlertScreen(showAlert: $isEdit, editText: store.getIndexArray()[listVM.selectedLabelNum])
                    .environmentObject(store)
            }
        }
    }
}
