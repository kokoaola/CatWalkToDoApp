//
//  LottieView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/08/08.
//

import SwiftUI
import Lottie


///歩く猫のビュー
struct CatView: View{
    ///ViewModelのための変数
    @ObservedObject var listVM: ListViewModel

    var body: some View{
        ///猫のサイズ
        let catSize = AppSetting.screenWidth / 6
        ///猫のポジション
        let rightPosition = AppSetting.screenWidth + catSize * 2 / 2
        let leftPosition = 0 - catSize
        
        //猫のアニメーション
        LottieView(isFacingRight: $listVM.isFacingRight, startAnimation: $listVM.isMoving)
            .frame(width: catSize)
            .position(x: listVM.stayPositionRight ? rightPosition : leftPosition, y: 40)
            .animation(.linear(duration: 7.0), value: listVM.stayPositionRight)
            .shadow(color:.black.opacity(0.5), radius: 3, x: 3, y: 3)
            .zIndex(1.0)
            .allowsHitTesting(false)
        //VoiceOver用
            .accessibilityElement(children: .ignore)
            .editAccessibility(label: "Walking cat", addTraits: .isImage)
    }
}



///LottieのアニメーションをSwiftUI用に変換するビュー
struct LottieView: UIViewRepresentable {
    
    let filename: String = "cat"
    let loop: LottieLoopMode = .loop
    // 左右反転するか否かのフラグ
    @Binding var isFacingRight: Bool
    @Binding var startAnimation: Bool  // アニメーションを開始/停止するかのフラグ
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .repeat(10)
        
        // isFacingRightがtrueの場合のみ反転を適用
        if isFacingRight {
            animationView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if let animationView = uiView.subviews.first as? LottieAnimationView {
            if startAnimation {
                animationView.play()
            }
            
            if isFacingRight {
                animationView.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                animationView.transform = CGAffineTransform.identity
            }
        }
    }
}



