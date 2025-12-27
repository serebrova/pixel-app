//
//  OnboardingView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToBirthday {
                BirthdayView()
            } else {
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
                        
                        YesNoButtonsView(viewModel: viewModel)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
