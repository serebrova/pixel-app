//
//  ChooseHookahViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

enum WallType {
    case wall1
    case wall2
    case wall3
    case wall4
    
    var image: Assets.Images {
        switch self {
        case .wall1:
            return .wall1
        case .wall2:
            return .wall2
        case .wall3:
            return .wall3
        case .wall4:
            return .wall4
        }
    }
}

enum FurnitureType {
    case furniture1
    case furniture2
    case furniture3
    case furniture4
    
    var image: Assets.Images {
        switch self {
        case .furniture1:
            return .furniture1
        case .furniture2:
            return .furniture2
        case .furniture3:
            return .furniture3
        case .furniture4:
            return .furniture4
        }
    }
}

@Observable
class ChooseHookahViewModel {
    var selectedWall: WallType?
    var selectedFurniture: FurnitureType?
    var showBackButton: Bool = false
    var showWalls: Bool = true
    var showFurniture: Bool = false
    var wallsOffset: CGFloat = 0
    var furnitureOffset: CGFloat = 1000 // Начальное значение за пределами экрана
    var screenWidth: CGFloat = 1000
    
    func selectWall(_ wall: WallType) {
        selectedWall = wall
    }
    
    func selectFurniture(_ furniture: FurnitureType) {
        selectedFurniture = furniture
    }
    
    func nextButtonTapped() {
        // Скрываем кнопки стен (уплывают влево)
        withAnimation(.easeOut(duration: 0.5)) {
            wallsOffset = -screenWidth
            showWalls = false
        }
        
        // Показываем кнопку BACK
        withAnimation(.easeIn(duration: 0.3).delay(0.2)) {
            showBackButton = true
        }
        
        // Показываем кнопки мебели (въезжают справа)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.furnitureOffset = 0
                self.showFurniture = true
            }
        }
    }
    
    func backButtonTapped() {
        // Скрываем кнопку BACK
        withAnimation(.easeOut(duration: 0.3)) {
            showBackButton = false
        }
        
        // Убираем кнопки мебели (уплывают вправо)
        withAnimation(.easeOut(duration: 0.5)) {
            furnitureOffset = screenWidth
            showFurniture = false
        }
        
        // Показываем кнопки стен (въезжают слева)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                self.wallsOffset = 0
                self.showWalls = true
            }
        }
        
        // Сбрасываем выбранную мебель
        selectedFurniture = nil
    }
    
    func setScreenWidth(_ width: CGFloat) {
        screenWidth = width
        furnitureOffset = width
    }
}

