//
//  HeroManager.swift
//  Pixel App
//
//  Created by  Leila Serebrova on 29.12.2025.
//

import SwiftUI

@Observable
class HeroManager {
    static let shared = HeroManager()
    
    var selectedHero: Hero?
    
    private init() {}
}

