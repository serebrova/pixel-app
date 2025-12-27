//
//  BirthdayView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 17.12.2025.
//

import SwiftUI

struct BirthdayView: View {
    @State private var viewModel = BirthdayViewModel()
    
    var body: some View {
        Group {
            if viewModel.shouldNavigateToName {
                NameView()
            } else {
                ZStack {
                    Assets.image(named: .background)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 80) {
                        TalkingGhostView(items: [
                            DialogueItem(text: "IS YOUR BIRTHDAY", image: .cake, imagePosition: .leading),
                            DialogueItem(text: "TODAY?", image: .cakePiece, imagePosition: .trailing)
                        ])
                        
                        YesNoButtonsView(viewModel: viewModel)
                    }
                }
            }
        }
    }
}

#Preview {
    BirthdayView()
}
