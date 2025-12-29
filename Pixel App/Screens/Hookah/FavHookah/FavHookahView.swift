//
//  FavHookahPlace.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

enum HookahPlaces {
    case hookahEbenya
    case hookahNoisy
    case hookahVibe
    case hookahVitya
    
    var image: Assets.Images {
        switch self {
        case .hookahEbenya:
            return .hookahEbenya
        case .hookahNoisy:
            return .hookahNoisy
        case .hookahVibe:
            return .hookahVibe
        case .hookahVitya:
            return .hookahVitya
        }
    }
    
    var description: String {
        switch self {
        case .hookahEbenya:
            "This kalianka is in Ebenya.".uppercased()
        case .hookahNoisy:
            "This kalianka is very noisy.".uppercased()
        case .hookahVibe:
            "This kalianka doesn't fit. Vitya works here.".uppercased()
        case .hookahVitya:
            "The vibe here is just awful.".uppercased()
        }
    }
}

struct FavHookahPlace: View {
    @State private var viewModel = FavHookahViewModel()
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToChooseHookah {
                ChooseHookahView()
            } else {
                favHookahContent
            }
        }
    }
    
    private var favHookahContent: some View {
        ZStack {
            Assets.image(named: .background)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                TalkingGhostView(
                    items: viewModel.showFinalState ? finalGhostItems : initialGhostItems
                )
                
                // Кнопки hookahButton
                if viewModel.showButtons {
                    // Первый HStack с двумя кнопками
                    HStack(spacing: 16) {
                        hookahButton(place: .hookahEbenya)
                        hookahButton(place: .hookahNoisy)
                    }
                    
                    // Второй HStack с двумя кнопками
                    HStack(spacing: 16) {
                        hookahButton(place: .hookahVibe)
                        hookahButton(place: .hookahVitya)
                    }
                }
                
                if viewModel.showFinalState {
                    VStack {
                        YesNoButtonsView(
                            viewModel: viewModel,
                            visibility: .yesOnly,
                            yesText: "Let's Go!".uppercased()
                        )
                        .padding(.top, 200)
                    }
                }
            }
            .padding(.horizontal, 16)
            .opacity(viewModel.mainContentOpacity)
            
            // DialogueView поверх всего
            if viewModel.showDialogueView {
                VStack {
                    DialogueView(
                        text: viewModel.selectedPlace?.description ?? "",
                        state: .bad,
                        onButtonTap: {
                            viewModel.hideDialogue()
                        },
                        badButtonText: "Choose again".uppercased(),
                        disableBlinkAnimation: true
                    )
                    .transition(.opacity.combined(with: .scale))
                }
                .animation(.easeIn(duration: 0.3), value: viewModel.showDialogueView)
            }
        }
    }
    
    private func hookahButton(place: HookahPlaces) -> some View {
        Button(action: {
            guard !viewModel.isDisabled(place) else { return }
            viewModel.selectPlace(place)
            startBlinkAnimation(for: place)
        }) {
            Assets.image(named: place.image)
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 175)
        }
        .disabled(viewModel.isDisabled(place))
        .opacity(viewModel.getOpacity(for: place))
    }
    
    private func startBlinkAnimation(for place: HookahPlaces) {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    viewModel.setOpacity(0.0, for: place)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    viewModel.setOpacity(1.0, for: place)
                }
            }
        }
        
        let totalAnimationDuration = blinkDuration * Double(blinkCount * 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            // Сразу после мигания понижаем opacity и отключаем кнопку
            viewModel.setOpacity(0.5, for: place)
            viewModel.disablePlace(place)
            viewModel.stopBlinking()
            viewModel.showDialogue()
        }
    }
    
    private var initialGhostItems: [DialogueItem] {
        [
            .init(
                text: "Oh no! Your".uppercased(),
                image: nil,
                imagePosition: .leading
            ),
            .init(
                attributedText: createFavouriteKaliankaText(),
                image: nil,
                imagePosition: .leading
            ),
            .init(
                text: "is closed! Let's".uppercased(),
                image: nil,
                imagePosition: .leading
            ),
            .init(
                text: "Choose a new one!".uppercased(),
                image: nil,
                imagePosition: .leading
            )
        ]
    }
    
    private var finalGhostItems: [DialogueItem] {
        [
            .init(
                text: "I think you should make your own Kalianka!".uppercased(),
                image: nil,
                imagePosition: .leading
            )
        ]
    }
    
    private func createFavouriteKaliankaText() -> AttributedString {
        let fullText = "favourite Kalianka".uppercased()
        
        var attributedString = AttributedString(fullText)
        attributedString.font = Assets.Fonts.minecraft(size: 24)
        attributedString.foregroundColor = Assets.Colors.purple
        
        if let kaliankaRange = attributedString.range(of: "KALIANKA") {
            attributedString[kaliankaRange].foregroundColor = Assets.Colors.pink
        }
        
        return attributedString
    }
}

#Preview {
    FavHookahPlace()
}
