//
//  MovingButtonGameViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

@Observable
class MovingButtonGameViewModel {
    var clickCount: Int = 0
    var showButton: Bool = true
    var showTalkingGhost: Bool = true
    var shouldNavigateToCrossword: Bool = false
    
    var dialogueItems: [DialogueItem] {
        switch clickCount {
        case 0...1:
            return [
                DialogueItem(
                    text: "ARE YOU READY",
                    image: nil,
                    imagePosition: .leading
                ),
                DialogueItem(
                    text: "TO RECEIVE YOUR",
                    image: Assets.Images.gift,
                    imagePosition: .leading
                ),
                DialogueItem(
                    text: "BIRTHDAY GIFT?",
                    image: nil,
                    imagePosition: .leading
                )
            ]
        case 2...3:
            return [
                DialogueItem(
                    text: "WOW! NOT SO FAST!",
                    image: nil,
                    imagePosition: .leading
                )
            ]
        case 4...5:
            return [
                DialogueItem(
                    text: "YOU'RE QUICK, HUH?",
                    image: nil,
                    imagePosition: .leading
                )
            ]
        default:
            return [
                DialogueItem(
                    text: "THAN TRY TO CATCH THIS!",
                    image: nil,
                    imagePosition: .leading
                )
            ]
        }
    }
    
    func incrementClickCount() {
        clickCount += 1
        
        // После 6 кликов скрываем кнопку с анимацией
        if clickCount >= 6 {
            withAnimation(.easeOut(duration: 0.5)) {
                showButton = false
            }
            
            // Через 2 секунды скрываем TalkingGhost с анимацией и переходим на CrosswordView
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.showTalkingGhost = false
                }
                // Переходим на CrosswordView после завершения анимации
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.shouldNavigateToCrossword = true
                }
            }
        }
    }
}

