//
//  NameView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct NameView: View {
    @State private var viewModel = NameViewModel()
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToAge {
                AgeView()
            } else {
                ZStack {
                    Assets.image(named: .background)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 80) {
                        if viewModel.showDialogue {
                            DialogueView(
                                text: viewModel.dialogueText,
                                state: viewModel.dialogueState,
                                onButtonTap: {
                                    viewModel.handleButtonTap()
                                }
                            )
                            .padding(.horizontal, 16)
                        } else {
                            TalkingGhostView(items: [
                                DialogueItem(text: " WHAT IS YOUR NAME?", image: nil, imagePosition: .leading)
                            ])
                            
                            TextFieldView(
                                text: $viewModel.name,
                                placeholder: "ENTER YOUR NAME",
                                onSubmit: {
                                    viewModel.handleNameSubmit()
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NameView()
}
