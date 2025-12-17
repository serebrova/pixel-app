//
//  OnboardingView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    @State private var blinkOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Assets.image(named: .onboardingBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: .zero) {
                Text("START")
                    .font(Assets.Fonts.pixelify(size: 118, weight: .bold))
                    .foregroundStyle(Assets.Colors.rose)
                    .shadow(
                        color: Assets.Colors.pink,
                        radius: 0,
                        x: 0,
                        y: 4
                    )
                
                Text("ARE YOU READY?")
                    .font(Assets.Fonts.minecraft(size: 24, weight: .bold))
                    .foregroundStyle(Assets.Colors.white)
                    .padding(.top, 45)
                
                HStack {
                    // YES button
                    VStack(spacing: 8) {
                        Text("YES")
                            .font(Assets.Fonts.minecraft(size: 56, weight: .medium))
                            .foregroundStyle(Assets.Colors.white)
                        
                        Assets.image(named: .arrowUp)
                            .opacity(viewModel.showYesArrow ? 1.0 : 0.0)
                    }
                    .opacity(viewModel.isYesBlinking ? blinkOpacity : 1.0)
                    .onTapGesture {
                        startBlinkAnimation()
                        viewModel.selectYes()
                    }
                    
                    Spacer()
                    
                    // NO button
                    VStack(spacing: 8) {
                        Text("NO")
                            .font(Assets.Fonts.minecraft(size: 56, weight: .medium))
                            .foregroundStyle(Assets.Colors.white)
                        
                        Assets.image(named: .arrowUp)
                            .opacity(viewModel.showNoArrow ? 1.0 : 0.0)
                    }
                    .opacity(viewModel.isNoBlinking ? blinkOpacity : 1.0)
                    .onTapGesture {
                        startBlinkAnimation()
                        viewModel.selectNo()
                    }
                }
                .padding(.horizontal, 36)
                .padding(.top, 24)
            }
            .padding(.bottom, 120)
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
    }
}

#Preview {
    OnboardingView()
}
