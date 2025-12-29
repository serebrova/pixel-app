//
//   DialogueView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

enum DialogueState {
    case good
    case bad
    case both
}

struct DialogueView: View {
    let text: String
    let attributedText: AttributedString?
    let state: DialogueState
    var onButtonTap: (() -> Void)? = nil
    var onYesTap: (() -> Void)? = nil
    var onNoTap: (() -> Void)? = nil
    
    // Тексты кнопок с дефолтными значениями
    let goodButtonText: String
    let badButtonText: String
    let yesButtonText: String
    let noButtonText: String
    
    // Отключение анимации мигания
    let disableBlinkAnimation: Bool
    
    @State private var blinkOpacity: Double = 1.0
    @State private var yesBlinkOpacity: Double = 1.0
    @State private var noBlinkOpacity: Double = 1.0
    
    init(
        text: String,
        state: DialogueState,
        onButtonTap: (() -> Void)? = nil,
        onYesTap: (() -> Void)? = nil,
        onNoTap: (() -> Void)? = nil,
        goodButtonText: String = "COOL",
        badButtonText: String = "RETYPE",
        yesButtonText: String = "YES",
        noButtonText: String = "NO",
        disableBlinkAnimation: Bool = false
    ) {
        self.text = text
        self.attributedText = nil
        self.state = state
        self.onButtonTap = onButtonTap
        self.onYesTap = onYesTap
        self.onNoTap = onNoTap
        self.goodButtonText = goodButtonText
        self.badButtonText = badButtonText
        self.yesButtonText = yesButtonText
        self.noButtonText = noButtonText
        self.disableBlinkAnimation = disableBlinkAnimation
    }
    
    init(
        attributedText: AttributedString,
        state: DialogueState,
        onButtonTap: (() -> Void)? = nil,
        onYesTap: (() -> Void)? = nil,
        onNoTap: (() -> Void)? = nil,
        goodButtonText: String = "COOL",
        badButtonText: String = "RETYPE",
        yesButtonText: String = "YES",
        noButtonText: String = "NO",
        disableBlinkAnimation: Bool = false
    ) {
        self.text = ""
        self.attributedText = attributedText
        self.state = state
        self.onButtonTap = onButtonTap
        self.onYesTap = onYesTap
        self.onNoTap = onNoTap
        self.goodButtonText = goodButtonText
        self.badButtonText = badButtonText
        self.yesButtonText = yesButtonText
        self.noButtonText = noButtonText
        self.disableBlinkAnimation = disableBlinkAnimation
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if let attributedText = attributedText {
                    Text(attributedText)
                        .font(Assets.Fonts.minecraft(size: 24))
                        .padding(.top, 40)
                        .padding(.bottom, 48)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.white)
                        )
                        .padding(.horizontal, 26)
                } else {
                    Text(text)
                        .font(Assets.Fonts.minecraft(size: 24))
                        .foregroundStyle(Assets.Colors.purple)
                        .padding(.top, 40)
                        .padding(.bottom, 48)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.white)
                        )
                        .padding(.horizontal, 26)
                }
            }
            buttonsView
                .padding(.top, -25)
        }
        .compositingGroup()
        .shadow(
            color: Assets.Colors.purpleShadow,
            radius: 0,
            x: -6,
            y: 6
        )
    }
    
    @ViewBuilder
    private var buttonsView: some View {
        switch state {
        case .good:
            button(text: goodButtonText, color: Assets.Colors.pink, rotation: -5, thumbImage: .upThumb, opacity: $blinkOpacity, onTap: onButtonTap)
        case .bad:
            button(text: badButtonText, color: Assets.Colors.purple, rotation: 5, thumbImage: .downThumb, opacity: $blinkOpacity, onTap: onButtonTap)
        case .both:
            HStack(spacing: 16) {
                button(
                    text: yesButtonText,
                    color: Assets.Colors.pink,
                    rotation: -5,
                    thumbImage: .upThumb,
                    opacity: $yesBlinkOpacity,
                    onTap: onYesTap ?? onButtonTap
                )
                button(
                    text: noButtonText,
                    color: Assets.Colors.purple,
                    rotation: 5,
                    thumbImage: .downThumb,
                    opacity: $noBlinkOpacity,
                    onTap: onNoTap ?? onButtonTap
                )
            }
        }
    }
    
    private func button(text: String, color: Color, rotation: Double, thumbImage: Assets.Images, opacity: Binding<Double>, onTap: (() -> Void)? = nil) -> some View {
        HStack(spacing: 4) {
            Text(text)
                .font(Assets.Fonts.minecraft(size: 24))
                .foregroundStyle(Assets.Colors.white)
            
            Assets.image(named: thumbImage)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(rotation))
                .padding(.bottom, 5)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .padding(.top, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
        )
        .rotationEffect(.degrees(rotation))
        .opacity(opacity.wrappedValue)
        .onTapGesture {
            if disableBlinkAnimation {
                simpleTapAnimation(opacity: opacity, onTap: onTap)
            } else {
                startBlinkAnimation(opacity: opacity, onTap: onTap)
            }
        }
    }
    
    private func startBlinkAnimation(opacity: Binding<Double>, onTap: (() -> Void)? = nil) {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    opacity.wrappedValue = 0.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    opacity.wrappedValue = 1.0
                }
            }
        }
        
        let totalAnimationDuration = blinkDuration * Double(blinkCount * 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            onTap?()
        }
    }
    
    private func simpleTapAnimation(opacity: Binding<Double>, onTap: (() -> Void)? = nil) {
        withAnimation(.easeOut(duration: 0.1)) {
            opacity.wrappedValue = 0.6
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeIn(duration: 0.1)) {
                opacity.wrappedValue = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                onTap?()
            }
        }
    }
}

#Preview {
    VStack {
        DialogueView(text: "I knew it is your name!", state: .good)
        DialogueView(text: "That is not your name!", state: .bad)
        DialogueView(text: "Hello, World!", state: .both)
    }
}
