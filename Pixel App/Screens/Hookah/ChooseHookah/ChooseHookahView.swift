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
                Assets.image(named: .background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    HStack {
                        if viewModel.showBackButton {
                            Button {
                                viewModel.backButtonTapped()
                            } label: {
                                Text("< BACK")
                                    .font(Assets.Fonts.minecraft(size: 20))
                                    .foregroundStyle(Assets.Colors.white)
                            }
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        }
                        Spacer()
                    }
                    .animation(.easeIn(duration: 0.3), value: viewModel.showBackButton)
                    
                    // ZStack для наложения мебели на стену
                    ZStack {
                        // Слой стены
                        if let selectedWall = viewModel.selectedWall {
                            Assets.image(named: selectedWall.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 244, height: 244)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Assets.Colors.rose, lineWidth: 2)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Assets.Colors.purple)
                                .stroke(Assets.Colors.rose, lineWidth: 2)
                                .frame(width: 244, height: 244)
                        }
                        
                        // Слой мебели поверх стены
                        if let selectedFurniture = viewModel.selectedFurniture {
                            Assets.image(named: selectedFurniture.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 244, height: 244)
                                .cornerRadius(16)
                        }
                    }
                    
                    Text(viewModel.showFurniture ? "Choose your furniture".uppercased() : "Choose your walls".uppercased())
                        .font(Assets.Fonts.minecraft(size: 24))
                        .foregroundStyle(Assets.Colors.white)
                        .padding(.top, 36)
                    
                    // Кнопки стен
                    if viewModel.showWalls {
                        VStack(spacing: 10) {
                        HStack(spacing: 10) {
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
                        }
                        
                        HStack(spacing: 10) {
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
                        }
                        }
                        .offset(x: viewModel.wallsOffset)
                    }
                    
                    // Кнопки мебели
                    if viewModel.showFurniture {
                        VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Button {
                                viewModel.selectFurniture(.furniture1)
                            } label: {
                                Assets.image(named: .furniture1)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 175, height: 175)
                            }
                            
                            Button {
                                viewModel.selectFurniture(.furniture2)
                            } label: {
                                Assets.image(named: .furniture2)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 175, height: 175)
                            }
                        }
                        
                        HStack(spacing: 10) {
                            Button {
                                viewModel.selectFurniture(.furniture3)
                            } label: {
                                Assets.image(named: .furniture3)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 175, height: 175)
                            }
                            
                            Button {
                                viewModel.selectFurniture(.furniture4)
                            } label: {
                                Assets.image(named: .furniture4)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 175, height: 175)
                            }
                        }
                        }
                        .offset(x: viewModel.furnitureOffset)
                    }
                    
                    // Кнопка NEXT (показывается только когда выбрана стена и не показана мебель)
                    if viewModel.selectedWall != nil && !viewModel.showFurniture {
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
                        }
                    }
                }
                .padding(.horizontal, 16)
                .safeAreaPadding(.top)
                .safeAreaPadding(.bottom)
                .onAppear {
                    viewModel.setScreenWidth(geometry.size.width)
                }
            }
        }
    }
}

#Preview {
    ChooseHookahView()
}
