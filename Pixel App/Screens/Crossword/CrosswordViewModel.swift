//
//  CrosswordViewModel.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

@Observable
class CrosswordViewModel: YesNoButtonsViewModel {
    var squarePosition: CGPoint = CGPoint(x: 0, y: 0)
    let squareSize: CGFloat = 56
    var screenSize: CGSize = .zero
    var safeAreaInsets: EdgeInsets = EdgeInsets()
    var showMovingSquare: Bool = true
    var showFiveSquares: Bool = false
    var isMoving: Bool = true
    var whiteSquarePositions: [CGPoint] = []
    var showWhiteSquares: Bool = false
    var fixedSquares: Set<Int> = [] // Индексы зафиксированных квадратов
    var draggedSquareIndex: Int? = nil
    var dragStartPositions: [Int: CGPoint] = [:] // Начальные позиции при начале drag
    var squareToPurpleMapping: [Int: Int] = [:] // Маппинг: индекс белого квадрата -> индекс фиолетового
    var shouldNavigateToNext: Bool = false
    var shouldNavigateToHello: Bool = false
    var showQuestionView: Bool = false // Показывать TalkingGhostView и YesNoButtonsView
    var showJokeDialog: Bool = false // Показывать диалог с шуткой после нажатия на YES
    
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
    
    func selectYes() {
        guard selection != .yes else { return }
        selection = .yes
        triggerBlink(for: .yes)
        
        let blinkDuration = 0.1
        let blinkCount = 3
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            // Показываем диалог с шуткой вместо перехода к NextView
            withAnimation(.easeIn(duration: 0.5)) {
                self.showQuestionView = false
                self.showJokeDialog = true
            }
            // Сбрасываем selection для диалога
            self.selection = .none
        }
    }
    
    func selectNo() {
        guard selection != .no else { return }
        selection = .no
        triggerBlink(for: .no)
    }
    
    func handleJokeDialogNoTap() {
        shouldNavigateToNext = true
    }
    
    func handleJokeDialogYesTap() {
        HeroManager.shared.selectedHero = .lobbyBoy
        shouldNavigateToHello = true
    }
    
    private func triggerBlink(for button: YesNoSelection) {
        blinkingButton = button
        
        let blinkDuration = 0.1
        let blinkCount = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(blinkCount * 2)) {
            self.blinkingButton = .none
        }
    }
    
    let letters = ["P", "I", "D", "O", "R"]
    
    func handleSquareTap() {
        // Останавливаем перемещение
        isMoving = false
        
        // Анимированно скрываем квадрат
        withAnimation(.easeOut(duration: 0.5)) {
            showMovingSquare = false
        }
        
        // После исчезновения показываем 5 квадратов
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                self.showFiveSquares = true
            }
            
            // Затем запускаем падение белых квадратов
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startFallingWhiteSquares()
            }
        }
    }
    
    func initializeMovingSquare(in screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        
        // Устанавливаем начальную позицию
        squarePosition = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2
        )
        // Начинаем перемещение
        if isMoving {
            moveSquareToRandomPosition()
        }
    }
    
    func moveSquareToRandomPosition() {
        guard isMoving else { return }
        
        // Учитываем размер квадрата и safe area, чтобы он не выходил за пределы экрана
        let minX = safeAreaInsets.leading + squareSize / 2
        let maxX = screenSize.width - safeAreaInsets.trailing - squareSize / 2
        let minY = safeAreaInsets.top + squareSize / 2
        let maxY = screenSize.height - safeAreaInsets.bottom - squareSize / 2
        
        // Генерируем случайную позицию
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        // Быстрое перемещение
        withAnimation(.linear(duration: 0.3)) {
            squarePosition = CGPoint(x: randomX, y: randomY)
        }
        
        // После завершения анимации перемещаемся снова
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.moveSquareToRandomPosition()
        }
    }
    
    func startFallingWhiteSquares() {
        showWhiteSquares = true
        
        let minX = safeAreaInsets.leading + squareSize / 2
        let maxX = screenSize.width - safeAreaInsets.trailing - squareSize / 2
        let startY = safeAreaInsets.top - squareSize / 2 // Начальная позиция сверху
        let bottomY = screenSize.height - safeAreaInsets.bottom - squareSize / 2 // Дно экрана
        
        // Генерируем финальные X позиции так, чтобы квадраты не накладывались
        // Они должны лежать на дне рядом друг с другом, но не в одну линию
        var finalXPositions: [CGFloat] = []
        let spacing: CGFloat = squareSize + 4 // Минимальное расстояние между квадратами
        
        // Генерируем позиции, чтобы они не накладывались
        for _ in 0..<5 {
            var newX: CGFloat
            var attempts = 0
            repeat {
                newX = CGFloat.random(in: minX...maxX)
                attempts += 1
            } while attempts < 50 && finalXPositions.contains { abs($0 - newX) < spacing }
            
            finalXPositions.append(newX)
        }
        
        // Инициализируем начальные позиции (все сверху, случайные X)
        whiteSquarePositions = (0..<5).map { index in
            let randomX = CGFloat.random(in: minX...maxX)
            return CGPoint(x: randomX, y: startY)
        }
        
        // Запускаем падение каждого квадрата с разной задержкой и скоростью
        for index in 0..<5 {
            let delay = Double(index) * 0.1 // Разная задержка для каждого
            let duration = Double.random(in: 0.8...1.2) // Разная скорость падения
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.spring(response: duration, dampingFraction: 0.7)) {
                    if self.whiteSquarePositions.indices.contains(index) && finalXPositions.indices.contains(index) {
                        // Все падают на дно, но в разные X позиции
                        self.whiteSquarePositions[index].y = bottomY
                        self.whiteSquarePositions[index].x = finalXPositions[index]
                    }
                }
            }
        }
    }
    
    func getPurpleSquarePositions(in screenSize: CGSize) -> [CGPoint] {
        // Вычисляем позиции 5 фиолетовых квадратов в центре
        // Они в HStack с spacing 8, в центре экрана
        // HStack центрирован через .frame(maxWidth: .infinity, maxHeight: .infinity)
        let totalWidth = CGFloat(5) * squareSize + CGFloat(4) * 8 // 5 квадратов + 4 spacing
        let centerX = screenSize.width / 2
        let centerY = screenSize.height / 2
        
        // Начало HStack (левый край первого квадрата)
        let startX = centerX - totalWidth / 2
        
        return (0..<5).map { index in
            // Центр каждого квадрата
            let x = startX + CGFloat(index) * (squareSize + 8) + squareSize / 2
            return CGPoint(x: x, y: centerY)
        }
    }
    
    func checkAndFixSquare(at index: Int, in screenSize: CGSize) {
        guard whiteSquarePositions.indices.contains(index) else { return }
        guard !fixedSquares.contains(index) else { return }
        
        let whitePos = whiteSquarePositions[index]
        let purplePositions = getPurpleSquarePositions(in: screenSize)
        
        // Проверяем расстояние до каждого фиолетового квадрата
        for (purpleIndex, purplePos) in purplePositions.enumerated() {
            let distance = sqrt(pow(whitePos.x - purplePos.x, 2) + pow(whitePos.y - purplePos.y, 2))
            let threshold: CGFloat = squareSize // Порог для фиксации
            
            if distance < threshold {
                // Фиксируем белый квадрат на позиции фиолетового, но на 46 пикселей ниже
                let fixedPosition = CGPoint(x: purplePos.x, y: purplePos.y + 47)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    whiteSquarePositions[index] = fixedPosition
                }
                fixedSquares.insert(index)
                squareToPurpleMapping[index] = purpleIndex
                
                // Проверяем, правильно ли сложилось слово
                checkWordCompletion()
                break
            }
        }
    }
    
    func handleDragStart(at index: Int) {
        draggedSquareIndex = index
        if whiteSquarePositions.indices.contains(index) {
            dragStartPositions[index] = whiteSquarePositions[index]
        }
        // Убираем из зафиксированных при начале перетаскивания
        fixedSquares.remove(index)
        squareToPurpleMapping.removeValue(forKey: index)
    }
    
    func handleDragChanged(at index: Int, translation: CGSize) {
        if let startPos = dragStartPositions[index] {
            let newPosition = CGPoint(
                x: startPos.x + translation.width,
                y: startPos.y + translation.height
            )
            whiteSquarePositions[index] = newPosition
        }
    }
    
    func handleDragEnded(at index: Int, translation: CGSize, in screenSize: CGSize) {
        if let startPos = dragStartPositions[index] {
            let finalPosition = CGPoint(
                x: startPos.x + translation.width,
                y: startPos.y + translation.height
            )
            whiteSquarePositions[index] = finalPosition
        }
        dragStartPositions.removeValue(forKey: index)
        checkAndFixSquare(at: index, in: screenSize)
        draggedSquareIndex = nil
    }
    
    private func checkWordCompletion() {
        // Проверяем, правильно ли сложилось слово PIDOR
        // Буквы: P(0), I(1), D(2), O(3), R(4)
        // Они должны быть зафиксированы под фиолетовыми квадратами в порядке: 0, 1, 2, 3, 4
        let correctOrder = [0, 1, 2, 3, 4] // Индексы белых квадратов
        let purpleIndices = [0, 1, 2, 3, 4] // Индексы фиолетовых квадратов
        
        // Проверяем, что все 5 квадратов зафиксированы
        guard fixedSquares.count == 5 else { return }
        
        // Проверяем, что каждый белый квадрат стоит под правильным фиолетовым
        var isCorrect = true
        for (whiteIndex, purpleIndex) in zip(correctOrder, purpleIndices) {
            if squareToPurpleMapping[whiteIndex] != purpleIndex {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            // Скрываем фиолетовые квадраты без анимации
            showFiveSquares = false
            
            // Показываем TalkingGhostView и YesNoButtonsView с анимацией
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.showQuestionView = true
                }
            }
        }
    }
}

