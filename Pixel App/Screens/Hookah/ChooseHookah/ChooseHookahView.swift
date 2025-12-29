//
//  ChooseHookahView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

struct ChooseHookahView: View {
    @State private var viewModel = ChooseHookahViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundImage
                
                VStack(spacing: 10) {
                    backButton
                    if viewModel.showDialogueView {
                        Spacer()
                    }
                    constructorView
                    
                    
                    if viewModel.showDialogueView {
                        dialogueView
                            .padding(.top, -40)
                        Spacer()
                    } else {
                        Spacer()
                        chooseText
                        selectionView
                        nextButton
                    }
                }
            }
        }
    }
    
    var backgroundImage: some View {
        Assets.image(named: .background)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    var backButton: some View {
        HStack {
            Button {
                viewModel.backButtonTapped()
            } label: {
                Text("< BACK")
                    .font(Assets.Fonts.minecraft(size: 20))
                    .foregroundStyle(Assets.Colors.white)
            }
            .opacity(viewModel.showBackButton ? 1 : 0)
            .transition(.opacity.combined(with: .move(edge: .leading)))
            Spacer()
        }
        .padding(.horizontal, 16)
        .animation(.easeIn(duration: 0.3), value: viewModel.showBackButton)
    }
    
    var constructorView: some View {
        ZStack {
            let size = viewModel.showDialogueView ? 360.0 : 244.0
            if let selectedWall = viewModel.selectedWall {
                
                Assets.image(named: selectedWall.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    //.cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Assets.Colors.rose, lineWidth: 2)
                    )
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Assets.Colors.purple)
                    .stroke(Assets.Colors.rose, lineWidth: 2)
                    .frame(width: size, height: size)
            }
            
            if let selectedFurniture = viewModel.selectedFurniture {
                Assets.image(named: selectedFurniture.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    //.cornerRadius(16)
            }
            
            if let selectedDecor = viewModel.selectedDecor {
                Assets.image(named: selectedDecor.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    //.cornerRadius(16)
            }
        }
    }
    
    var chooseText: some View {
        let text: String
        if viewModel.showDecor {
            text = "Choose your decor"
        } else if viewModel.showFurniture {
            text = "Choose your furniture"
        } else {
            text = "Choose your walls"
        }
        
        return Text(text.uppercased())
            .font(Assets.Fonts.minecraft(size: 24))
            .foregroundStyle(Assets.Colors.white)
            .padding(.top, 36)
            .frame(maxWidth: .infinity) // Фиксированная ширина для предотвращения движения
            .multilineTextAlignment(.center) // Центрирование текста
            .contentShape(Rectangle()) // Фиксированная форма
            .animation(.easeInOut(duration: 0.3), value: text)
    }
    
    var selectionView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                if viewModel.showWalls {
                    Button {
                        viewModel.selectWall(.wall1)
                    } label: {
                        Assets.image(named: .wall1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                    }
                    
                    Button {
                        viewModel.selectWall(.wall2)
                    } label: {
                        Assets.image(named: .wall2)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                    }
                } else if viewModel.showFurniture {
                    Button {
                        viewModel.selectFurniture(.furniture1)
                    } label: {
                        Assets.image(named: .furniture1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                    
                    Button {
                        viewModel.selectFurniture(.furniture2)
                    } label: {
                        Assets.image(named: .furniture2)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                } else if viewModel.showDecor {
                    Button {
                        viewModel.selectDecor(.decor1)
                    } label: {
                        Assets.image(named: .decor1)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                    
                    Button {
                        viewModel.selectDecor(.decor2)
                    } label: {
                        Assets.image(named: .decor2)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                }
            }
            .frame(height: 175)
            
            HStack(spacing: 10) {
                if viewModel.showWalls {
                    Button {
                        viewModel.selectWall(.wall3)
                    } label: {
                        Assets.image(named: .wall3)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                    }
                    
                    Button {
                        viewModel.selectWall(.wall4)
                    } label: {
                        Assets.image(named: .wall4)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                    }
                } else if viewModel.showFurniture {
                    Button {
                        viewModel.selectFurniture(.furniture3)
                    } label: {
                        Assets.image(named: .furniture3)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                    
                    Button {
                        viewModel.selectFurniture(.furniture4)
                    } label: {
                        Assets.image(named: .furniture4)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                } else if viewModel.showDecor {
                    Button {
                        viewModel.selectDecor(.decor3)
                    } label: {
                        Assets.image(named: .decor3)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                    
                    Button {
                        viewModel.selectDecor(.decor4)
                    } label: {
                        Assets.image(named: .decor4)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 175, height: 175)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white)
                            )
                    }
                }
            }
            .frame(height: 175)
        }
        .opacity(viewModel.showWalls || viewModel.showFurniture || viewModel.showDecor ? 1 : 0)
    }
            
    var nextButton: some View {
        Button {
            viewModel.nextButtonTapped()
        } label: {
            Text("NEXT")
                .font(Assets.Fonts.minecraft(size: 24))
                .foregroundStyle(Assets.Colors.white)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Assets.Colors.pink)
                )
                .rotationEffect(.degrees(-5))
                .shadow(
                    color: Assets.Colors.purpleShadow,
                    radius: 0,
                    x: -6,
                    y: 6
                )
                .padding(.top, -30)
                .padding(.bottom, 90)
        }
        .opacity((viewModel.selectedWall != nil && viewModel.showWalls) || (viewModel.selectedFurniture != nil && viewModel.showFurniture) || (viewModel.selectedDecor != nil && viewModel.showDecor) ? 1 : 0)
    }
    
    var dialogueView: some View {
        DialogueView(
            text: "This is Your Dream kalianka!".uppercased(),
            state: .good,
            onButtonTap: {
                // Обработка нажатия на кнопку "go next"
            },
            goodButtonText: "go next".uppercased()
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    ChooseHookahView()
}
