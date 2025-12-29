//
//  WhoAreYouView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

struct WhoAreYouView: View {
    @State private var viewModel = WhoAreYouViewModel()
    @State private var blinkOpacity: Double = 1.0
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToHello {
                HelloView()
            } else {
                ZStack {
                    Assets.image(named: .background)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack(alignment: .trailing, spacing: 94) {
                        TalkingGhostView(
                            items: [
                                .init(
                                    text: "WHO ARE YOU,",
                                    image: nil,
                                    imagePosition: .leading
                                ),
                                .init(
                                    text: "WARRIOR?",
                                    image: nil,
                                    imagePosition: .leading
                                )
                            ]
                        )
                        .padding(.trailing, 37)
                        
                        VStack(spacing: 17) {
                            ForEach(Array(Hero.allCases.enumerated()), id: \.element) { index, hero in
                                heroButton(hero: hero, index: index)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    private func heroButton(hero: Hero, index: Int) -> some View {
        Button(action: {
            startBlinkAnimation()
            viewModel.selectHero(hero, buttonIndex: index)
        }) {
            HStack(spacing: 6) {
                Text(hero.heroName)
                    .font(Assets.Fonts.minecraft(size: 24))
                    .foregroundStyle(Assets.Colors.white)
                
                Spacer()
                
                Assets.image(named: hero.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Assets.Colors.purple)
                .stroke(Assets.Colors.white, lineWidth: 1)
        )
        .opacity(viewModel.isButtonBlinking(index) ? blinkOpacity : 1.0)
    }
    
    private func startBlinkAnimation() {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 0.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    WhoAreYouView()
}
