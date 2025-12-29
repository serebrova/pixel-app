//
//  CrosswordView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct CrosswordView: View {
    @State private var viewModel = CrosswordViewModel()
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToHello {
                HelloView()
            } else if viewModel.shouldNavigateToNext {
                WhoAreYouView()
            } else {
                GeometryReader { geometry in
                    ZStack {
                Assets.image(named: .background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea() 
                
                // Движущийся квадрат
                if viewModel.showMovingSquare {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Assets.Colors.purple)
                        .stroke(Assets.Colors.white, lineWidth: 2)
                        .frame(width: viewModel.squareSize, height: viewModel.squareSize)
                        .position(viewModel.squarePosition)
                        .opacity(viewModel.showMovingSquare ? 1.0 : 0.0)
                        .onTapGesture {
                            viewModel.handleSquareTap()
                        }
                        .onAppear {
                            viewModel.initializeMovingSquare(in: geometry.size, safeAreaInsets: geometry.safeAreaInsets)
                        }
                }
                
                VStack(spacing: 80) {
                    // Диалог с шуткой
                    if viewModel.showJokeDialog {
                        DialogueView(
                            text: "JUST KIDDING! I KNOW YOU'RE JUST A LOBBY BOY",
                            state: .both,
                            onYesTap: {
                                viewModel.handleJokeDialogYesTap()
                            },
                            onNoTap: {
                                viewModel.handleJokeDialogNoTap()
                            }
                        )
                        .opacity(viewModel.showJokeDialog ? 1.0 : 0.0)
                        .padding(.horizontal, 16)
                    } else {
                        // TalkingGhostView сверху
                        if viewModel.showQuestionView {
                            TalkingGhostView(items: [
                                DialogueItem(text: "WHO ARE YOU WARRIOR?", image: nil, imagePosition: .leading)
                            ])
                            .opacity(viewModel.showQuestionView ? 1.0 : 0.0)
                        }
                        
                        // 5 квадратов в центре
                        HStack(spacing: 8) {
                            ForEach(0..<5, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Assets.Colors.purple)
                                    .stroke(Assets.Colors.white, lineWidth: 2)
                                    .frame(width: viewModel.squareSize, height: viewModel.squareSize)
                            }
                        }
                        .opacity(viewModel.showFiveSquares ? 1.0 : 0.0)
                        
                        // YesNoButtonsView снизу
                        if viewModel.showQuestionView {
                            YesNoButtonsView(
                                viewModel: viewModel,
                                visibility: .yesOnly,
                                yesText: "YES!"
                            )
                            .opacity(viewModel.showQuestionView ? 1.0 : 0.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 5 белых квадратов, падающих сверху
                if viewModel.showWhiteSquares && !viewModel.showJokeDialog {
                    ForEach(0..<5, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.white)
                                .frame(width: viewModel.squareSize, height: viewModel.squareSize)
                            
                            Text(viewModel.letters[index])
                                .font(Assets.Fonts.minecraft(size: 24))
                                .foregroundStyle(Assets.Colors.purple)
                        }
                        .position(viewModel.whiteSquarePositions.indices.contains(index) ? viewModel.whiteSquarePositions[index] : CGPoint(x: 0, y: 0))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if viewModel.draggedSquareIndex == nil {
                                        viewModel.handleDragStart(at: index)
                                    }
                                    viewModel.handleDragChanged(at: index, translation: value.translation)
                                }
                                .onEnded { value in
                                    viewModel.handleDragEnded(at: index, translation: value.translation, in: geometry.size)
                                }
                        )
                    }
                }
                    }
                }
            }
        }
    }
}

#Preview {
    CrosswordView()
}

