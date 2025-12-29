//
//  WhoAreYouViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

@Observable
class WhoAreYouViewModel {
    var shouldNavigateToHello: Bool = false
    var blinkingButtonIndex: Int? = nil
    
    func selectHero(_ hero: Hero, buttonIndex: Int) {
        guard HeroManager.shared.selectedHero == nil else { return }
        HeroManager.shared.selectedHero = hero
        blinkingButtonIndex = buttonIndex
        
        let blinkDuration = 0.1
        let blinkCount = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.shouldNavigateToHello = true
        }
    }
    
    func isButtonBlinking(_ index: Int) -> Bool {
        blinkingButtonIndex == index
    }
}

