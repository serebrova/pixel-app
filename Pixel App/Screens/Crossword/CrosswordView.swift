//
//  CrosswordView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct CrosswordView: View {
    @State private var squarePosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var squareSize: CGFloat = 56
    @State private var screenSize: CGSize = .zero
    @State private var safeAreaInsets: EdgeInsets = EdgeInsets()
    @State private var showMovingSquare: Bool = true
    @State private var showFiveSquares: Bool = false
    @State private var isMoving: Bool = true
    @State private var whiteSquarePositions: [CGPoint] = []
    @State private var showWhiteSquares: Bool = false
    @State private var fixedSquares: Set<Int> = [] // Индексы зафиксированных квадратов
    @State private var draggedSquareIndex: Int? = nil
    @State private var dragStartPositions: [Int: CGPoint] = [:] // Начальные позиции при начале drag
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Assets.image(named: .background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Движущийся квадрат
                if showMovingSquare {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Assets.Colors.purple)
                        .stroke(Assets.Colors.white, lineWidth: 2)
                        .frame(width: squareSize, height: squareSize)
                        .position(squarePosition)
                        .opacity(showMovingSquare ? 1.0 : 0.0)
                        .onTapGesture {
                            handleSquareTap()
                        }
                        .onAppear {
                            // Сохраняем размеры экрана и safe area
                            screenSize = geometry.size
                            safeAreaInsets = geometry.safeAreaInsets
                            
                            // Устанавливаем начальную позицию
                            squarePosition = CGPoint(
                                x: geometry.size.width / 2,
                                y: geometry.size.height / 2
                            )
                            // Начинаем перемещение
                            if isMoving {
                                moveSquareToRandomPosition()
                            }
                        }
                }
                
                // 5 квадратов в центре
                if showFiveSquares {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.purple)
                                .stroke(Assets.Colors.white, lineWidth: 2)
                                .frame(width: squareSize, height: squareSize)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showFiveSquares ? 1.0 : 0.0)
                }
                
                // 5 белых квадратов, падающих сверху
                if showWhiteSquares {
                    let letters = ["P", "I", "D", "O", "R"]
                    ForEach(0..<5, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.white)
                                .frame(width: squareSize, height: squareSize)
                            
                            Text(letters[index])
                                .font(Assets.Fonts.minecraft(size: 24))
                                .foregroundStyle(Assets.Colors.purple)
                        }
                        .position(whiteSquarePositions.indices.contains(index) ? whiteSquarePositions[index] : CGPoint(x: 0, y: 0))
                        .gesture(
                            fixedSquares.contains(index) ? nil :
                            DragGesture()
                                .onChanged { value in
                                    if draggedSquareIndex == nil {
                                        draggedSquareIndex = index
                                        if whiteSquarePositions.indices.contains(index) {
                                            dragStartPositions[index] = whiteSquarePositions[index]
                                        }
                                    }
                                    
                                    if let startPos = dragStartPositions[index] {
                                        let newPosition = CGPoint(
                                            x: startPos.x + value.translation.width,
                                            y: startPos.y + value.translation.height
                                        )
                                        whiteSquarePositions[index] = newPosition
                                    }
                                }
                                .onEnded { value in
                                    if let startPos = dragStartPositions[index] {
                                        let finalPosition = CGPoint(
                                            x: startPos.x + value.translation.width,
                                            y: startPos.y + value.translation.height
                                        )
                                        whiteSquarePositions[index] = finalPosition
                                    }
                                    dragStartPositions.removeValue(forKey: index)
                                    checkAndFixSquare(at: index, in: geometry.size)
                                    draggedSquareIndex = nil
                                }
                        )
                    }
                }
            }
        }
    }
    
    private func handleSquareTap() {
        // Останавливаем перемещение
        isMoving = false
        
        // Анимированно скрываем квадрат
        withAnimation(.easeOut(duration: 0.5)) {
            showMovingSquare = false
        }
        
        // После исчезновения показываем 5 квадратов
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                showFiveSquares = true
            }
            
            // Затем запускаем падение белых квадратов
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startFallingWhiteSquares()
            }
        }
    }
    
    private func moveSquareToRandomPosition() {
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
            moveSquareToRandomPosition()
        }
    }
    
    private func startFallingWhiteSquares() {
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
                    if whiteSquarePositions.indices.contains(index) && finalXPositions.indices.contains(index) {
                        // Все падают на дно, но в разные X позиции
                        whiteSquarePositions[index].y = bottomY
                        whiteSquarePositions[index].x = finalXPositions[index]
                    }
                }
            }
        }
    }
    
    private func getPurpleSquarePositions(in screenSize: CGSize) -> [CGPoint] {
        // Вычисляем позиции 5 фиолетовых квадратов в центре
        // Они в HStack с spacing 8, в центре экрана
        let totalWidth = CGFloat(5) * squareSize + CGFloat(4) * 8 // 5 квадратов + 4 spacing
        let startX = (screenSize.width - totalWidth) / 2 + squareSize / 2
        let centerY = screenSize.height / 2
        
        return (0..<5).map { index in
            let x = startX + CGFloat(index) * (squareSize + 8)
            return CGPoint(x: x, y: centerY)
        }
    }
    
    private func checkAndFixSquare(at index: Int, in screenSize: CGSize) {
        guard whiteSquarePositions.indices.contains(index) else { return }
        guard !fixedSquares.contains(index) else { return }
        
        let whitePos = whiteSquarePositions[index]
        let purplePositions = getPurpleSquarePositions(in: screenSize)
        
        // Проверяем расстояние до каждого фиолетового квадрата
        for (purpleIndex, purplePos) in purplePositions.enumerated() {
            let distance = sqrt(pow(whitePos.x - purplePos.x, 2) + pow(whitePos.y - purplePos.y, 2))
            let threshold: CGFloat = squareSize // Порог для фиксации
            
            if distance < threshold {
                // Проверяем, не занят ли уже этот фиолетовый квадрат
                let isOccupied = fixedSquares.contains { fixedIndex in
                    // Можно добавить проверку, если нужно
                    false
                }
                
                // Фиксируем белый квадрат на позиции фиолетового
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    whiteSquarePositions[index] = purplePos
                }
                fixedSquares.insert(index)
                break
            }
        }
    }
}

#Preview {
    CrosswordView()
}

