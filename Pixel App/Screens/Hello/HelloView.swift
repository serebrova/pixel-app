//
//  HelloView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

enum Hero: CaseIterable {
    case lobbyBoy
    case dimash
    case fireFighter
    
    var heroName: String {
        switch self {
        case .lobbyBoy:
            return "LOBBY BOY"
        case .dimash:
            return "Dimash Kumiszhanov".uppercased()
        case .fireFighter:
            return "ASS FIRE FIGHTER"
        }
    }
    
    var icon: Assets.Images {
        switch self {
        case .lobbyBoy:
            return .lobbyBoyButton
        case .dimash:
            return .dimashButton
        case .fireFighter:
            return .fireFighterButton
        }
    }
    
    var sprite: Assets.Images {
        switch self {
        case .lobbyBoy:
            return .lobbyboySprite
        case .dimash:
            return .dimashSprite
        case .fireFighter:
            return .fireFighterSprite
        }
    }
}

struct HelloView: View {
    @Bindable var heroManager = HeroManager.shared
    let hero: Hero?
    @State private var showHelloText: Bool = true
    @State private var showTalkingGhost: Bool = false
    @State private var ghostText: String = "So you up already?".uppercased()
    @State private var ghostBlinkOpacity: Double = 1.0
    @State private var showDialogueView: Bool = false
    @State private var shouldNavigateToFireGame: Bool = false
    
    init(hero: Hero? = nil) {
        self.hero = hero
    }
    
    var body: some View {
        Group {
            if shouldNavigateToFireGame {
                FireGameView()
            } else {
                ZStack {
                    Assets.image(named: .background)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    if let hero = hero ?? heroManager.selectedHero {
                        VStack(spacing: 16) {
                            if showHelloText {
                                Text("HELLO, \n \(hero.heroName)")
                                    .font(Assets.Fonts.minecraft(size: 32))
                                    .foregroundStyle(Assets.Colors.white)
                                    .multilineTextAlignment(.center)
                                    .opacity(showHelloText ? 1.0 : 0.0)
                            }
                            
                            if showTalkingGhost && !showDialogueView {
                                TalkingGhostView(items: [
                                    DialogueItem(text: ghostText, image: nil, imagePosition: .leading)
                                ])
                                .opacity(showTalkingGhost ? ghostBlinkOpacity : 0.0)
                            }
                            
                            if showDialogueView {
                                DialogueView(
                                    attributedText: createDialogueText(),
                                    state: .good,
                                    onButtonTap: {
                                        shouldNavigateToFireGame = true
                                    },
                                    goodButtonText: "LET'S GO"
                                )
                                .opacity(showDialogueView ? 1.0 : 0.0)
                                .padding(.horizontal, 16)
                            }
                            
                            if !showDialogueView {
                                Assets.image(named: hero.sprite)
                                    .resizable()
                                    .frame(width: 321, height: 321)
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showHelloText = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeIn(duration: 0.5)) {
                                        showTalkingGhost = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        startGhostBlinkAnimation {
                                            ghostText = "It's time for work".uppercased()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                withAnimation(.easeOut(duration: 0.5)) {
                                                    showTalkingGhost = false
                                                }
                                                
                                                withAnimation(.easeIn(duration: 0.5)) {
                                                    showDialogueView = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func startGhostBlinkAnimation(completion: @escaping () -> Void) {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    ghostBlinkOpacity = 0.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    ghostBlinkOpacity = 1.0
                }
            }
        }
        
        let totalAnimationDuration = blinkDuration * Double(blinkCount * 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            completion()
        }
    }
    
    private func createDialogueText() -> AttributedString {
        let fullText = "You are a frontend \n engineering team \n leader. \n \n It's time to potushit \n zhopy before \n release day".uppercased()
        
        var attributedString = AttributedString(fullText)
        attributedString.font = Assets.Fonts.minecraft(size: 24)
        attributedString.foregroundColor = Assets.Colors.purple
        
        // Находим и выделяем слова "potushit" и "zhopy" розовым цветом
        if let potushitRange = attributedString.range(of: "POTUSHIT") {
            attributedString[potushitRange].foregroundColor = Assets.Colors.pink
        }
        
        if let zhopyRange = attributedString.range(of: "ZHOPY") {
            attributedString[zhopyRange].foregroundColor = Assets.Colors.pink
        }
        
        return attributedString
    }
}

#Preview {
    HelloView(hero: .lobbyBoy)
}

