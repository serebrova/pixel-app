//
//  BirthdayViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 17.12.2025.
//

import SwiftUI

@Observable
class BirthdayViewModel: YesNoButtonsViewModel {
    var selection: YesNoSelection = .none
    var blinkingButton: YesNoSelection = .none
    var shouldNavigateToName: Bool = false
    
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
        
        let blinkDuration = 0.1
        let blinkCount = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.shouldNavigateToName = true
        }
    }
    
    func selectNo() {
        guard selection != .no else { return }
        selection = .no
        triggerBlink(for: .no)
    }
    
    private func triggerBlink(for button: YesNoSelection) {
        blinkingButton = button
        
        let blinkDuration = 0.1
        let blinkCount = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.blinkingButton = .none
        }
    }
}

