//
//  TalkingGhostView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 17.12.2025.
//

import SwiftUI

struct DialogueItem: Identifiable {
    let id = UUID()
    let text: String
    let image: Assets.Images?
    let imagePosition: ImagePosition
    
    enum ImagePosition {
        case leading
        case trailing
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
            
            Text(item.text)
                .font(Assets.Fonts.minecraft(size: 24))
                .foregroundStyle(Assets.Colors.purple)
            
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
