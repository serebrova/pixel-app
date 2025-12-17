//
//  Assets.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 16.12.2025.
//

import SwiftUI

enum Assets {
    // MARK: - Images
    enum Images {
        static let onboardingBackground = "OnboardingBackground"
        
        static func image(named name: String) -> Image {
            Image(name)
        }
    }
    
    // MARK: - Colors
    enum Colors {
        static let beige = Color("beige")
        static let pink = Color("pink")
        static let purple = Color("purple")
        static let rose = Color("rose")
        static let white = Color("white")
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

