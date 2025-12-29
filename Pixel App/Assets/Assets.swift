//
//  Assets.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

enum Assets {
    // MARK: - Images
    enum Images: String {
        case onboardingBackground = "OnboardingBackground"
        case arrowUp = "arrowUp"
        case background = "Backgound"
        case dialogueArrow = "dialogueArrow"
        case talkingGhost = "talkingGhost"
        case cake = "cake"
        case cakePiece = "cakePiece"
        case textfieldSubmit = "textfieldSubmit"
        case submitButtonWhite = "submitButtonWhite"
        case upThumb = "upThumb"
        case downThumb = "downThumb"
        case crown = "crown"
        case gift = "gift"
        case dimashButton = "dimashButton"
        case fireFighterButton = "fireFighterButton"
        case lobbyBoyButton = "lobbyBoyButton"
        case dimashSprite = "dimashSprite"
        case fireFighterSprite = "fireFighterSprite"
        case lobbyboySprite = "lobbyboySprite"
        case fireGame = "fireGame"
        case hookahEbenya = "hookahEbenya"
        case hookahNoisy = "hookahNoisy"
        case hookahVibe = "hookahVibe"
        case hookahVitya = "hookahVitya"
        case decor1 = "decor1"
        case decor2 = "decor2"
        case decor3 = "decor3"
        case decor4 = "decor4"
        case furniture1 = "furniture1"
        case furniture2 = "furniture2"
        case furniture3 = "furniture3"
        case furniture4 = "furniture4"
        case wall1 = "wall1"
        case wall2 = "wall2"
        case wall3 = "wall3"
        case wall4 = "wall4"
    }
    
    static func image(named name: Images) -> Image {
        Image(name.rawValue)
    }
    
    // MARK: - Colors
    enum Colors {
        static let beige = Color("beige")
        static let pink = Color("pink")
        static let purple = Color("purple")
        static let rose = Color("rose")
        static let white = Color("white")
        static let purpleShadow = Color("purpleShadow")
        static let purpleTextfield = Color("purpleTextfield")
    }
    
    // MARK: - Fonts
    enum Fonts {
        static let minecraft = "Minecraft"
        static let nosutaru = "Nosutaru-dotMPlusH-10-Regular"
        
        // PixelifySans font names
        static let pixelifyRegular = "PixelifySans-Regular"
        static let pixelifyMedium = "PixelifySans-Medium"
        static let pixelifyBold = "PixelifySans-Bold"
        
        // Font weight enum
        enum Weight {
            case regular
            case medium
            case semibold
            case bold
            
            var pixelifyFontName: String {
                switch self {
                case .regular:
                    return pixelifyRegular
                case .medium:
                    return pixelifyMedium
                case .semibold:
                    return pixelifyMedium
                case .bold:
                    return pixelifyBold
                }
            }
        }
        
        static func custom(_ name: String, size: CGFloat) -> Font {
            .custom(name, size: size)
        }
        
        static func minecraft(size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .custom(minecraft, size: size)
                .weight(weight)
        }
        
        static func nosutaru(size: CGFloat) -> Font {
            .custom(nosutaru, size: size)
        }
        
        static func pixelify(size: CGFloat, weight: Weight = .regular) -> Font {
            .custom(weight.pixelifyFontName, size: size)
        }
    }
}

