//
//  YesNoButtonsView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

enum ButtonVisibility {
    case yesOnly
    case noOnly
    case both
}

struct YesNoButtonsView<ViewModel: YesNoButtonsViewModel & Observable>: View {
    @Bindable var viewModel: ViewModel
    @State private var blinkOpacity: Double = 1.0
    
    let visibility: ButtonVisibility
    let yesText: String
    let noText: String
    
    init(
        viewModel: ViewModel,
        visibility: ButtonVisibility = .both,
        yesText: String = "YES",
        noText: String = "NO"
    ) {
        self.viewModel = viewModel
        self.visibility = visibility
        self.yesText = yesText
        self.noText = noText
    }
    
    var body: some View {
        HStack {
            // YES button
            if visibility == .yesOnly || visibility == .both {
                VStack(spacing: 8) {
                    Text(yesText)
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
            }
            
            if visibility == .both {
                Spacer()
            }
            
            // NO button
            if visibility == .noOnly || visibility == .both {
                VStack(spacing: 8) {
                    Text(noText)
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
        }
        .padding(.horizontal, 36)
        .padding(.top, 24)
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
    @Previewable @State var viewModel = OnboardingViewModel()
    YesNoButtonsView(
        viewModel: viewModel,
        visibility: .both,
        yesText: "YES",
        noText: "NO"
    )
}

