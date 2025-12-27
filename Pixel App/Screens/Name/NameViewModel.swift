//
//  NameViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

@Observable
class NameViewModel {
    var name: String = ""
    var showDialogue: Bool = false
    var dialogueText: String = ""
    var dialogueState: DialogueState = .good
    var shouldNavigateToAge: Bool = false
    
    func handleNameSubmit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if trimmedName == "ДИМА" || trimmedName == "DIMA" {
            dialogueText = "I knew it is your name!"
            dialogueState = .good
        } else {
            dialogueText = "That is not your name!"
            dialogueState = .bad
        }
        
        showDialogue = true
    }
    
    func handleButtonTap() {
        switch dialogueState {
        case .good:
            shouldNavigateToAge = true
        case .bad:
            // Возвращаемся к вводу имени
            showDialogue = false
            name = ""
        case .both:
            break
        }
    }
}

