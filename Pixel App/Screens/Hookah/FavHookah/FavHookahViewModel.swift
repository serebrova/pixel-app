//
//  FavHookahViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

@Observable
class FavHookahViewModel: YesNoButtonsViewModel {
    var selectedPlace: HookahPlaces?
    var showDialogueView: Bool = false
    var disabledPlaces: Set<HookahPlaces> = []
    var blinkingPlace: HookahPlaces?
    var mainContentOpacity: Double = 1.0
    var showButtons: Bool = true
    var showFinalState: Bool = false
    var buttonOpacity: [HookahPlaces: Double] = [
        .hookahEbenya: 1.0,
        .hookahNoisy: 1.0,
        .hookahVibe: 1.0,
        .hookahVitya: 1.0
    ]
    
    // YesNoButtonsViewModel properties
    var selection: YesNoSelection = .none
    var blinkingButton: YesNoSelection = .none
    
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
    
    var shouldNavigateToChooseHookah: Bool = false
    
    func selectYes() {
        guard selection != .yes else { return }
        selection = .yes
        triggerBlink(for: .yes)
        
        let blinkDuration = 0.1
        let blinkCount = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.shouldNavigateToChooseHookah = true
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
    
    func selectPlace(_ place: HookahPlaces) {
        guard !disabledPlaces.contains(place) else { return }
        blinkingPlace = place
        selectedPlace = place
    }
    
    func stopBlinking() {
        blinkingPlace = nil
    }
    
    func setOpacity(_ opacity: Double, for place: HookahPlaces) {
        buttonOpacity[place] = opacity
    }
    
    func getOpacity(for place: HookahPlaces) -> Double {
        buttonOpacity[place] ?? 1.0
    }
    
    func showDialogue() {
        withAnimation(.easeOut(duration: 0.3)) {
            mainContentOpacity = 0.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showDialogueView = true
        }
    }
    
    func hideDialogue() {
        withAnimation(.easeOut(duration: 0.3)) {
            showDialogueView = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.selectedPlace = nil
            
            // Проверяем, все ли кнопки выбраны
            if self.disabledPlaces.count == 4 {
                // Все выбраны - переходим в финальное состояние
                withAnimation(.easeOut(duration: 0.3)) {
                    self.showButtons = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.showFinalState = true
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.mainContentOpacity = 1.0
                    }
                }
            } else {
                // Не все выбраны - показываем контент обратно
                withAnimation(.easeIn(duration: 0.3)) {
                    self.mainContentOpacity = 1.0
                }
            }
        }
    }
    
    var allPlacesSelected: Bool {
        disabledPlaces.count == 4
    }
    
    func disablePlace(_ place: HookahPlaces) {
        disabledPlaces.insert(place)
    }
    
    func isDisabled(_ place: HookahPlaces) -> Bool {
        disabledPlaces.contains(place)
    }
    
    func isBlinking(_ place: HookahPlaces) -> Bool {
        blinkingPlace == place
    }
}

