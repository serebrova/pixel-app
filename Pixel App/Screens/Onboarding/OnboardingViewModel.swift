//
//  OnboardingViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

enum OnboardingSelection {
    case none
    case yes
    case no
}

@Observable
class OnboardingViewModel {
    var selection: OnboardingSelection = .none
    var blinkingButton: OnboardingSelection = .none
    
    var showYesArrow: Bool {
        selection == .yes
    }
    
    var showNoArrow: Bool {
        selection == .no
    }
    
    var isYesBlinking: Bool {
        blinkingButton == .yes
    }
    
    var isNoBlinking: Bool {
        blinkingButton == .no
    }
    
    func selectYes() {
        guard selection != .yes else { return }
        selection = .yes
        triggerBlink(for: .yes)
    }
    
    func selectNo() {
        guard selection != .no else { return }
        selection = .no
        triggerBlink(for: .no)
    }
    
    private func triggerBlink(for button: OnboardingSelection) {
        blinkingButton = button
        
        let blinkDuration = 0.1
        let blinkCount = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.blinkingButton = .none
        }
    }
}

