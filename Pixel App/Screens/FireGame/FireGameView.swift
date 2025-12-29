//
//  FireGameView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

struct FireGameView: View {
    @State private var viewModel = FireGameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Assets.image(named: .background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Счетчик очков в левом верхнем углу
                VStack {
                    HStack {
                        Text("Score: \(viewModel.score)")
                            .font(Assets.Fonts.minecraft(size: 24))
                            .foregroundStyle(Assets.Colors.white)
                            .padding(.leading, 24)
                            .padding(.top, 24)
                        Spacer()
                        
                        // Таймер в правом верхнем углу
                        Text(viewModel.formattedTime)
                            .font(Assets.Fonts.minecraft(size: 24))
                            .foregroundStyle(Assets.Colors.white)
                            .padding(.trailing, 24)
                            .padding(.top, 24)
                    }
                    Spacer()
                }
                
                // Картинки fireGame
                
                
                // DialogueView после окончания игры
                if viewModel.showDialogueView {
                    VStack {
                        DialogueView(
                            text: viewModel.dialogueText,
                            state: .good,
                            onButtonTap: {
                                // Обработка нажатия на кнопку "WANNA RELAX"
                                // Можно добавить навигацию или другое действие
                            },
                            goodButtonText: "WANNA RELAX"
                        )
                        .padding(.bottom, 100)
                        
                    }
                } else {
                    ForEach(viewModel.fireItems) { item in
                        Assets.image(named: .fireGame)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 42)
                            .position(item.position)
                            .onTapGesture {
                                viewModel.tapFireItem(item)
                            }
                    }
                }
            }
            .onAppear {
                viewModel.initializeGame(in: geometry.size, safeAreaInsets: geometry.safeAreaInsets)
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
                viewModel.stopSpawning()
            }
        }
    }
}

#Preview {
    FireGameView()
}

