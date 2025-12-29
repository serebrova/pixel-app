//
//  MovingButtonGameView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct MovingButtonGameView: View {
    @State private var viewModel = MovingButtonGameViewModel()
    @State private var buttonPosition: CGPoint = CGPoint(x: 0, y: 0)
    @State private var buttonSize: CGSize = .zero
    @State private var initialButtonPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    private func moveButtonToRandomPosition(in screenSize: CGSize, safeAreaInsets: EdgeInsets) {
        // Учитываем размер кнопки и safe area, чтобы она не выходила полностью за пределы
        // Кнопка может частично выходить, но должна оставаться видимой хотя бы на 20%
        let buttonWidth = buttonSize.width > 0 ? buttonSize.width : 200
        let buttonHeight = buttonSize.height > 0 ? buttonSize.height : 80
        
        // position задает центр кнопки, поэтому нужно учитывать это при расчете
        // Чтобы минимум 20% кнопки было видно:
        // - Если кнопка выходит влево: левый край может быть в -buttonWidth*0.8
        //   значит центр должен быть в -buttonWidth*0.8 + buttonWidth/2 = -buttonWidth*0.3
        // - Если кнопка выходит вправо: правый край может быть в screenSize.width + buttonWidth*0.8
        //   значит центр должен быть в screenSize.width + buttonWidth*0.8 - buttonWidth/2 = screenSize.width + buttonWidth*0.3
        let minVisiblePortion: CGFloat = 0.2 // Минимум 20% должно быть видимо
        
        // Для X: учитываем safe area слева и справа
        // Центр кнопки может быть от (safeAreaInsets.leading - buttonWidth*0.3) до (screenSize.width - safeAreaInsets.trailing + buttonWidth*0.3)
        let minX = safeAreaInsets.leading - buttonWidth * (0.5 - minVisiblePortion)
        let maxX = screenSize.width - safeAreaInsets.trailing + buttonWidth * (0.5 - minVisiblePortion)
        
        // Для Y: учитываем safe area сверху и снизу
        // Центр кнопки может быть от (safeAreaInsets.top - buttonHeight*0.3) до (screenSize.height - safeAreaInsets.bottom + buttonHeight*0.3)
        let minY = safeAreaInsets.top - buttonHeight * (0.5 - minVisiblePortion)
        let maxY = screenSize.height - safeAreaInsets.bottom + buttonHeight * (0.5 - minVisiblePortion)
        
        // Генерируем случайную позицию в допустимых пределах
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            buttonPosition = CGPoint(x: randomX, y: randomY)
        }
    }
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToCrossword {
                CrosswordView()
            } else {
                GeometryReader { geometry in
                    ZStack {
                        Assets.image(named: .background)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        VStack(spacing: 80) {
                            TalkingGhostView(items: viewModel.dialogueItems)
                                .padding(.bottom, 250)
                                .opacity(viewModel.showTalkingGhost ? 1.0 : 0.0)
                        }
                        
                        // Кнопка с абсолютным позиционированием
                        Button(action: {
                            viewModel.incrementClickCount()
                            if viewModel.showButton {
                                moveButtonToRandomPosition(in: geometry.size, safeAreaInsets: geometry.safeAreaInsets)
                            }
                        }) {
                            Text("LET'S GO!")
                                .font(Assets.Fonts.minecraft(size: 56))
                                .foregroundStyle(Assets.Colors.white)
                        }
                        .opacity(viewModel.showButton ? 1.0 : 0.0)
                        .background(
                            GeometryReader { buttonGeometry in
                                Color.clear
                                    .onAppear {
                                        buttonSize = buttonGeometry.size
                                        // Начальная позиция - центр экрана по X, ниже TalkingGhostView по Y
                                        initialButtonPosition = CGPoint(
                                            x: geometry.size.width / 2,
                                            y: geometry.size.height / 2 + 200
                                        )
                                        buttonPosition = initialButtonPosition
                                    }
                                    .onChange(of: buttonGeometry.size) { oldValue, newValue in
                                        buttonSize = newValue
                                    }
                            }
                        )
                        .position(buttonPosition)
                        .allowsHitTesting(viewModel.showButton)
                    }
                }
            }
        }
    }}

#Preview {
    MovingButtonGameView()
}

