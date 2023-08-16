//
//  LottieView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/08/08.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let filename: String
    let loop: LottieLoopMode
    @Binding var shouldFlip: Bool  // 追加：左右反転するか否かのフラグ
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loop
        animationView.play()
        
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
            if shouldFlip {
                animationView.transform = CGAffineTransform(scaleX: -1, y: 1)
            } else {
                animationView.transform = CGAffineTransform.identity
            }
        }
    }
    }



