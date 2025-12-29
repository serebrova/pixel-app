//
//  AgeViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

@Observable
class AgeViewModel {
    var age: String = ""
    var showDialogue: Bool = false
    var dialogueText: String = ""
    var dialogueState: DialogueState = .good
    var shouldNavigateToGame: Bool = false
    
    func handleAgeSubmit() {
        let trimmedAge = age.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedAge == "28" {
            dialogueText = "WOW You're old!".uppercased()
            dialogueState = .good
        } else {
            dialogueText = "I'm not sure, it is you age".uppercased()
            dialogueState = .bad
        }
        
        showDialogue = true
    }
    
    func handleButtonTap() {
        switch dialogueState {
        case .good:
            shouldNavigateToGame = true
        case .bad:
            // Возвращаемся к вводу возраста
            showDialogue = false
            age = ""
        case .both:
            break
        }
    }
}

