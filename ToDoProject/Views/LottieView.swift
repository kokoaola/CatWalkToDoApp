//
//  LottieView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/08/08.
//

import SwiftUI
import Lottie


struct CatView: View{
    ///猫動かす用
    @Binding var goRight: Bool
    @Binding var flip: Bool
    @Binding var startMoving: Bool

    var body: some View{
        ///猫のサイズ
        let catSize = AppSetting.screenWidth / 6
        let catLeftPosition = AppSetting.screenWidth + catSize * 2 / 2
        let catRightPosition = 0 - catSize
        
        //猫のアニメーション
        LottieView(filename: "cat", loop: .loop, shouldFlip: $flip, startAnimation: $startMoving)
            .frame(width: catSize)
            .position(x: goRight ? catLeftPosition : catRightPosition, y: 40)
            .animation(.linear(duration: 7.0), value: goRight)
            .shadow(color:.black.opacity(0.5), radius: 3, x: 3, y: 3)
            .zIndex(1.0)
            .allowsHitTesting(false)
        //VoiceOver用
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Walking cat")
            .accessibilityAddTraits(.isImage)
    }
}



///LottieのアニメーションをSwiftUI用に変換するビュー
struct LottieView: UIViewRepresentable {
    
    let filename: String
    let loop: LottieLoopMode
    @Binding var shouldFlip: Bool  // 左右反転するか否かのフラグ
    @Binding var startAnimation: Bool  // アニメーションを開始/停止するかのフラグ
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .repeat(10)
        
        // shouldFlipがtrueの場合のみ反転を適用
        if shouldFlip {
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
            
            if shouldFlip {
                animationView.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                animationView.transform = CGAffineTransform.identity
            }
        }
    }
}



