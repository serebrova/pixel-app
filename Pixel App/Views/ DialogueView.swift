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
    let state: DialogueState
    var onButtonTap: (() -> Void)? = nil
    
    @State private var blinkOpacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text(text)
                    .font(Assets.Fonts.minecraft(size: 24))
                    .foregroundStyle(Assets.Colors.purple)
                    .padding(.top, 40)
                    .padding(.bottom, 48)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Assets.Colors.white)
                    )
                    .padding(.horizontal, 26)
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
            button(text: "COOL", color: Assets.Colors.pink, rotation: -5, thumbImage: .upThumb)
        case .bad:
            button(text: "RETYPE", color: Assets.Colors.purple, rotation: 5, thumbImage: .downThumb)
        case .both:
            HStack(spacing: 16) {
                button(text: "YES", color: Assets.Colors.pink, rotation: -5, thumbImage: .upThumb)
                button(text: "NO", color: Assets.Colors.purple, rotation: 5, thumbImage: .downThumb)
            }
        }
    }
    
    private func button(text: String, color: Color, rotation: Double, thumbImage: Assets.Images) -> some View {
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
        .opacity(blinkOpacity)
        .onTapGesture {
            startBlinkAnimation()
        }
    }
    
    private func startBlinkAnimation() {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            // Hide
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 0.0
                }
            }
            // Show
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 1.0
                }
            }
        }
        
        // После завершения анимации вызываем callback
        let totalAnimationDuration = blinkDuration * Double(blinkCount * 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            onButtonTap?()
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
