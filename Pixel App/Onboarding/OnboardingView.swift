//
//  ContentView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            Assets.Images.image(named: Assets.Images.onboardingBackground)
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
                    Text("YES")
                        .font(Assets.Fonts.minecraft(size: 56, weight: .medium))
                        .foregroundStyle(Assets.Colors.white)
                    
                    Spacer()
                    
                    Text("NO")
                        .font(Assets.Fonts.minecraft(size: 56, weight: .medium))
                        .foregroundStyle(Assets.Colors.white)
                }
                .padding(.horizontal, 36)
                .padding(.top, 24)
            }
            .padding(.bottom, 120)
        }
    }
}

#Preview {
    OnboardingView()
}
