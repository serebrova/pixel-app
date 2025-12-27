//
//  TextFieldView.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 21.12.2025.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    let placeholder: String
    let onSubmit: () -> Void
    
    @FocusState private var isFocused: Bool
    @State private var blinkOpacity: Double = 1.0
    @State private var submitButtonImage: Assets.Images = .textfieldSubmit
    
    var body: some View {
        HStack(spacing: 12) {
            TextField(placeholder, text: $text)
                .font(Assets.Fonts.minecraft(size: 24))
                .foregroundStyle(Assets.Colors.white)
                .tint(Assets.Colors.white)
                .textInputAutocapitalization(.characters)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .focused($isFocused)
                .onChange(of: text) { oldValue, newValue in
                    text = newValue.uppercased()
                    if submitButtonImage == .submitButtonWhite {
                        submitButtonImage = .textfieldSubmit
                    }
                }
                .overlay(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(Assets.Fonts.minecraft(size: 24))
                            .foregroundStyle(Assets.Colors.white.opacity(0.3))
                            .padding(.horizontal, 24)
                            .allowsHitTesting(false)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Assets.Colors.white, lineWidth: 2)
                        .fill(Assets.Colors.purpleTextfield)
                )
                .onSubmit {
                    isFocused = false
                    startBlinkAnimation()
                }
            
            Button(action: {
                isFocused = false
                startBlinkAnimation()
            }) {
                Assets.image(named: submitButtonImage)
            }
            .opacity(blinkOpacity)
        }
    }
    
    private func startBlinkAnimation() {
        let blinkDuration = 0.1
        let blinkCount = 3
        
        for i in 0..<blinkCount {
            // Hide
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 0.0
                }
            }
            // Show
            DispatchQueue.main.asyncAfter(deadline: .now() + blinkDuration * Double(i * 2 + 1)) {
                withAnimation(.linear(duration: 0.05)) {
                    blinkOpacity = 1.0
                }
            }
        }
        
        // После завершения анимации меняем иконку на submitButtonWhite и вызываем onSubmit
        let totalAnimationDuration = blinkDuration * Double(blinkCount * 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) {
            submitButtonImage = .submitButtonWhite
            onSubmit()
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    TextFieldView(
        text: $text,
        placeholder: "Enter your name",
        onSubmit: {
            print("Submitted: \(text)")
        }
    )
    .padding()
}
