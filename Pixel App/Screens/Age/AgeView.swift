//
//  AgeView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct AgeView: View {
    @State private var viewModel = AgeViewModel()
    
    var body: some View {
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
                    TalkingGhostView(
                        items: [
                            DialogueItem(
                                text: "HOW OLD ARE",
                                image: Assets.Images.crown,
                                imagePosition: .leading
                            ),
                            DialogueItem(
                                text: "YOU TODAY?",
                                image: nil,
                                imagePosition: .leading
                            )
                        ]
                    )
                    
                    TextFieldView(
                        text: $viewModel.age,
                        placeholder: "TYPE YOUR AGE",
                        onSubmit: {
                            viewModel.handleAgeSubmit()
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    AgeView()
}

