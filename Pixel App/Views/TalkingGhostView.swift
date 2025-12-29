//
//  TalkingGhostView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 17.12.2025.
//

import SwiftUI

struct DialogueItem: Identifiable {
    let id = UUID()
    let text: String?
    let attributedText: AttributedString?
    let image: Assets.Images?
    let imagePosition: ImagePosition
    
    enum ImagePosition {
        case leading
        case trailing
    }
    
    init(text: String, image: Assets.Images? = nil, imagePosition: ImagePosition = .leading) {
        self.text = text
        self.attributedText = nil
        self.image = image
        self.imagePosition = imagePosition
    }
    
    init(attributedText: AttributedString, image: Assets.Images? = nil, imagePosition: ImagePosition = .leading) {
        self.text = nil
        self.attributedText = attributedText
        self.image = image
        self.imagePosition = imagePosition
    }
}

struct TalkingGhostView: View {
    let items: [DialogueItem]
    
    var body: some View {
            VStack(alignment: .trailing, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items) { item in
                        DialogueLineView(item: item)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Assets.Colors.white)
                        .shadow(
                            color: Assets.Colors.purpleShadow,
                            radius: 0,
                            x: -6,
                            y: 6
                        )
                )
                .padding(.trailing, 11)
                
                Assets.image(named: .dialogueArrow)
                    .shadow(
                        color: Assets.Colors.purpleShadow,
                        radius: 0,
                        x: -6,
                        y: 6
                    )
                    .padding(.trailing, 32)
                    .padding(.top, -4)
                
                Assets.image(named: .talkingGhost)
                    .padding(.top, 11)
            }
        }
}

struct DialogueLineView: View {
    let item: DialogueItem
    
    var body: some View {
        HStack(spacing: 8) {
            if let image = item.image, item.imagePosition == .leading {
                Assets.image(named: image)
            }
            
            if let attributedText = item.attributedText {
                Text(attributedText)
                    .font(Assets.Fonts.minecraft(size: 24))
            } else if let text = item.text {
                Text(text)
                    .font(Assets.Fonts.minecraft(size: 24))
                    .foregroundStyle(Assets.Colors.purple)
            }
            
            if let image = item.image, item.imagePosition == .trailing {
                Assets.image(named: image)
            }
        }
    }
}

#Preview {
    TalkingGhostView(items: [
        DialogueItem(text: "IS YOUR BIRTHDAY", image: .cake, imagePosition: .leading),
        DialogueItem(text: "TODAY?", image: .cakePiece, imagePosition: .trailing)
    ])
}
